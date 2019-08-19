----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---     http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

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
	local hasSameWarModeAsPlayer = TRP3_API.globals.is_classic or hasWarModeActive == C_PvP.IsWarModeActive()

	local displayData = {};

	--{{{ Player name
	displayData.playerName = player:GetCustomColoredRoleplayingNamePrefixedWithIcon();
	--}}}

	--{{{ Player relationship
	-- Special case when seeing ourselves on the map (DEBUG)
	if player:IsCurrentUser() then
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
	--}}}

	return displayData
end

--- This is called by the data provider to decorate the pin after the base pin mixin has done its job.
---@param displayData {playerName:string, categoryName:string|nil, categoryPriority:number|nil, iconColor: Color, opacity: number|nil}
function TRP3_PlayerMapPinMixin:Decorate(displayData)
	self.Texture:SetSize(16, 16);
	self:SetSize(16, 16);

	self.tooltipLine = displayData.playerName;
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
