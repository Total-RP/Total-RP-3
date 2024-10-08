-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

--{{{ Total RP 3 imports
local loc = TRP3_API.loc;
--}}}

--{{{ Ellyb imports
local ORANGE = TRP3_API.Colors.Orange;
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
	local hasSameWarModeAsPlayer = (not TRP3_ClientFeatures.WarMode) or hasWarModeActive == C_PvP.IsWarModeActive();

	local displayData = {
		categoryName = nil,
		categoryPriority = nil,
		iconAtlas = nil,
		iconColor = nil,
		opacity = 1.0,
		playerName = player:GenerateFormattedName(TRP3_PlayerNameFormat.Plain),
		playerNameColored = player:GenerateFormattedName(TRP3_PlayerNameFormat.Colored),
		playerNameFancy = player:GenerateFormattedName(TRP3_PlayerNameFormat.Fancy),
		sender = poiInfo.sender,
		sortOrder = 0,
	};

	if player:IsCurrentUser() then
		-- Special case when seeing ourselves on the map (DEBUG)
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = TRP3_API.Colors.Cyan;
		displayData.categoryName = loc.REG_RELATION .. ": " .. TRP3_API.Colors.Cyan("SELF");
		displayData.categoryPriority = math.huge;
	elseif shouldDifferentiateBetweenWarModes and not hasSameWarModeAsPlayer then
		-- Swap out the atlas for this marker, show it in red, low opacity, and in a special category
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = TRP3_API.Colors.Grey;
		displayData.opacity = math.min(0.5, displayData.opacity);
		displayData.categoryName = TRP3_API.Colors.Red(loc.REG_LOCATION_DIFFERENT_WAR_MODE);
		displayData.categoryPriority = 1;
	else
		local relation = player:GetRelationshipWithPlayer()
		if relation.id ~= TRP3_API.register.relation.getRelationInfo().id then
			local relationshipColor = TRP3_API.register.relation.getColor(relation);
			displayData.iconAtlas = "PlayerPartyBlip";
			displayData.iconColor = relationshipColor;
			displayData.categoryName = loc.REG_RELATION .. ": " .. (relationshipColor or TRP3_API.Colors.White)(relation.name or loc:GetText("REG_RELATION_".. relation.id));
			displayData.categoryPriority = -relation.order or math.huge;
		end
	end

	if poiInfo.roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		-- OOC characters will be suffixed with an OOC indicator and faded.
		displayData.opacity = math.min(0.5, displayData.opacity);
		displayData.playerNameFancy = string.format("%2$s |cffff0000(%1$s)|r", loc.CM_OOC, displayData.playerNameFancy);
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
	self.sortOrder = displayData.sortOrder;

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

local function GeneratePinContextMenu(pins, _, rootDescription)
	local MAX_CHARACTER_COUNT = 25;

	rootDescription:CreateTitle(loc.MAP_SCAN_CHAR_TITLE);

	for i = 1, math.min(#pins, MAX_CHARACTER_COUNT) do
		local pin = pins[i];
		local text = string.format("%1$s: %2$s", loc.CL_OPEN_PROFILE, pin.playerNameColored);
		local sender = pin.sender;
		local callback = function(...) TRP3_API.slash.openProfile((...)); end;

		rootDescription:CreateButton(text, callback, sender);
	end
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
		TRP3_MenuUtil.CreateContextMenu(self, function(...) GeneratePinContextMenu(pins, ...); end);
	end
end

function TRP3_PlayerMapPinMixin:OnTooltipAboutToShow(tooltip)
	tooltip:AddTempLine([[|TInterface\Common\UI-TooltipDivider-Transparent:8:128:0:0:8:8:0:128:0:8:255:255:255|t]]);
	tooltip:AddTempLine(TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.CL_OPEN_PROFILE), WHITE_FONT_COLOR);
end

function TRP3_PlayerMapPinMixin:CheckMouseButtonPassthrough()
	-- Intentional no-op; this is called by Blizzard *after* pin acquisition
	-- logic and would reset explicit configuration of our button passthrough
	-- in the OnAcquire handler.
end
