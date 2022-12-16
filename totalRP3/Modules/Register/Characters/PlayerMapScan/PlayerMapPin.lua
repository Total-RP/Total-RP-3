-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

--{{{ Lua imports
local huge = math.huge;
--}}}

--{{{ Total RP 3 imports
local loc = TRP3_API.loc;
--}}}

--{{{ Ellyb imports
local ORANGE = Ellyb.ColorManager.ORANGE;
---}}}

-- Create the pin template, above group members
---@type BaseMapPoiPinMixin|MapCanvasPinMixin|{Texture: Texture, GetMap: fun():MapCanvasMixin}
TRP3_PlayerMapPinMixin = AddOn_TotalRP3.MapPoiMixins.createPinTemplate(
	AddOn_TotalRP3.MapPoiMixins.GroupedCoalescedMapPinMixin, -- Use coalesced grouped tooltips (show multiple player names)
	AddOn_TotalRP3.MapPoiMixins.AnimatedPinMixin -- Use animated icons (bounce in)
);

-- Expose template name, so the scan can use it for the MapDataProvider
TRP3_PlayerMapPinMixin.TEMPLATE_NAME = "TRP3_PlayerMapPinTemplate";

local CONFIG_SHOW_DIFFERENT_WAR_MODES = "register_map_location_show_war_modes";
local getConfigValue = TRP3_API.configuration.getValue;

--- This is called when the data provider acquire a pin, to transform poiInfo received from the scan
--- into display info to be used to decorate the pin.
function TRP3_PlayerMapPinMixin:GetDisplayDataFromPoiInfo(poiInfo)
	local player = AddOn_TotalRP3.Player.CreateFromCharacterID(poiInfo.sender);
	local hasWarModeActive = poiInfo.hasWarModeActive;
	local shouldDifferentiateBetweenWarModes = getConfigValue(CONFIG_SHOW_DIFFERENT_WAR_MODES);
	local hasSameWarModeAsPlayer = (not TRP3_ClientFeatures.WarMode) or hasWarModeActive == C_PvP.IsWarModeActive()

	local displayData = {};

	displayData.sender = poiInfo.sender;
	displayData.playerName = player:GenerateFormattedName(TRP3_PlayerNameFormat.Plain);
	displayData.playerNameColored = player:GenerateFormattedName(TRP3_PlayerNameFormat.Colored);
	displayData.playerNameFancy = player:GenerateFormattedName(TRP3_PlayerNameFormat.Fancy);

	if player:IsCurrentUser() then
		-- Special case when seeing ourselves on the map (DEBUG)
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = Ellyb.ColorManager.CYAN;
		displayData.categoryName = loc.REG_RELATION .. ": " .. Ellyb.ColorManager.CYAN("SELF");
		displayData.categoryPriority = huge;
	elseif shouldDifferentiateBetweenWarModes and not hasSameWarModeAsPlayer then
		-- Swap out the atlas for this marker, show it in red, low opacity, and in a special category
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = Ellyb.ColorManager.GREY;
		displayData.opacity = 0.5
		displayData.categoryName = Ellyb.ColorManager.RED(loc.REG_LOCATION_DIFFERENT_WAR_MODE);
		displayData.categoryPriority = -1;
	else
		local relation = player:GetRelationshipWithPlayer()
		if relation ~= TRP3_API.register.relation.NONE then
			local relationshipColor = TRP3_API.register.relation.getColor(relation);
			-- Swap out the atlas for this marker.
			displayData.iconAtlas = "PlayerPartyBlip";
			displayData.iconColor = relationshipColor;

			-- Store the relationship on the marker itself as the category.
			displayData.categoryName = loc.REG_RELATION .. ": " .. relationshipColor(loc:GetText("REG_RELATION_".. relation));
			displayData.categoryPriority = TRP3_API.globals.RELATIONS_ORDER[relation] or huge;
		end
	end

	return displayData
end

--- This is called by the data provider to decorate the pin after the base pin mixin has done its job.
function TRP3_PlayerMapPinMixin:Decorate(displayData)
	self.Texture:SetSize(16, 16);
	self:SetSize(16, 16);
	if self.SetPassThroughButtons then
		self:SetPassThroughButtons("");
	end

	self.sender = displayData.sender;
	self.playerName = displayData.playerName;
	self.playerNameColored = displayData.playerNameColored;
	self.playerNameFancy = displayData.playerNameFancy;
	self.tooltipLine = displayData.playerNameFancy;
	self.categoryName = displayData.categoryName;
	self.categoryPriority = displayData.categoryPriority;
	self.sortName = displayData.playerName;

	if displayData.iconColor then
		self.Texture:SetVertexColor(displayData.iconColor:GetRGBA());
	else
		self.Texture:SetVertexColor(1, 1, 1, 1);
	end

	-- Adjust the frame level of pins that have a zero or higher priority.
	-- This applies to pins that have a relationship status set.
	local priority = displayData.categoryPriority or -1;
	if type(priority) == "number" and priority >= 0 then
		-- Topmost level if there's any sort of priority.
		self:UseFrameLevelType("PIN_FRAME_LEVEL_TOPMOST");
	else
		-- Default level.
		self:UseFrameLevelType("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");
	end

	self.Texture:SetAlpha(displayData.opacity or 1)

	Ellyb.Tooltips.getTooltip(self):SetTitle(ORANGE(loc.REG_PLAYERS)):ClearLines();
end

function TRP3_PlayerMapPinMixin:OnMouseDown(button)
	if button ~= "RightButton" then
		return;
	end

	local pins = self:GetMouseOverPinsByTemplate(self.pinTemplate);
	self:SortPins(pins);

	if #pins == 1 then
		-- Single pin; open straight to profile.
		TRP3_API.slash.openProfile(pins[1].sender);
	else
		-- More than one pin; user can select from a context menu.
		local level = 1;
		local anchor = "cursor";
		MSA_ToggleDropDownMenu(level, pins, TRP3_PlayerMapPinDropDown, anchor);
	end
end

function TRP3_PlayerMapPinMixin:OnTooltipAboutToShow(tooltip)
	tooltip:AddTempLine([[|TInterface\Common\UI-TooltipDivider-Transparent:8:128:0:0:8:8:0:128:0:8:255:255:255|t]]);
	tooltip:AddTempLine(Ellyb.Strings.clickInstruction(loc.CM_R_CLICK, loc.CL_OPEN_PROFILE), WHITE_FONT_COLOR);
end

TRP3_PlayerMapPinDropDownMixin = {};

function TRP3_PlayerMapPinDropDownMixin:OnLoad()
	self.maximumCharacterCount = 25;

	MSA_DropDownMenu_SetInitializeFunction(self, self.OnInitialize);
end

function TRP3_PlayerMapPinDropDownMixin:OnInitialize(level)
	local pins = MSA_DROPDOWNMENU_MENU_VALUE;

	if level ~= 1 or type(pins) ~= "table" or #pins == 0 then
		return;
	end

	MSA_DropDownMenu_AddButton({ text = loc.MAP_SCAN_CHAR_TITLE, isTitle = true, notCheckable = true });

	for i = 1, math.min(#pins, self.maximumCharacterCount) do
		-- Sender is cached as an upvalue to avoid any edge case if the pin is
		-- released while the context menu is kept open.

		local pin = pins[i];
		local sender = pin.sender;

		local info = {};
		info.text = string.format("%1$s: %2$s", loc.CL_OPEN_PROFILE, pin.playerNameColored);
		info.func = function() TRP3_API.slash.openProfile(sender); end;
		info.notCheckable = true;

		MSA_DropDownMenu_AddButton(info);
	end

	MSA_DropDownMenu_AddSeparator({});
	MSA_DropDownMenu_AddButton({ text = CANCEL, notCheckable = true });
end
