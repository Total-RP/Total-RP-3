----------------------------------------------------------------------------------
--- Total RP 3
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

--region Lua imports
local huge = math.huge;
--endregion

--region Total RP 3 imports
local loc = TRP3_API.loc;
--endregion

-- Create the pin template, above group members
---@type BaseMapPoiPinMixin|MapCanvasPinMixin|{GetMap:fun():MapCanvasMixin}
TRP3_PlayerMapPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");

-- Add mixins to automatically animate the pins and coalesce nearby pins
Mixin(TRP3_PlayerMapPinMixin, AddOn_TotalRP3.MapPOIMixins.GroupedCoalescedMapPinMixin);
Mixin(TRP3_PlayerMapPinMixin, AddOn_TotalRP3.MapPOIMixins.AnimatedPinMixin);


TRP3_PlayerMapPinMixin.TEMPLATE_NAME = "TRP3_PlayerMapPinTemplate";

local function getDisplayDataFromPOIInfo(poiInfo)
	local characterID = poiInfo.sender;
	local displayData = {};

	if TRP3_API.register.isUnitIDKnown(characterID) and TRP3_API.register.hasProfile(characterID) then

		local profileID = TRP3_API.register.getUnitIDProfileID(characterID);
		--region Player name
		local profile = TRP3_API.register.getUnitIDCurrentProfile(characterID);
		displayData.playerName = TRP3_API.register.getCompleteName(profile.characteristics, characterID, true);

		if profile.characteristics and profile.characteristics.CH then
			local color = Ellyb.Color.CreateFromHexa(profile.characteristics.CH);
			displayData.playerName = color(displayData.playerName)
		end
		--endregion
	else
		-- Remove server name
		displayData.playerName = characterID:gsub("%-.*$", "");
	end

	--region Player relationship
	--local relation = TRP3_API.register.relation.getRelation(profileID);
	local relation = TRP3_API.register.relation.NONE
	local rand = math.random(100);
	if rand > 80 then
		relation = TRP3_API.globals.RELATIONS.LOVE;
	elseif rand > 50 then
		relation = TRP3_API.globals.RELATIONS.FRIEND;
	end
	if relation ~= TRP3_API.register.relation.NONE then
		local relationShipColor = TRP3_API.register.relation.getColor(relation);
		-- Swap out the atlas for this marker.
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = relationShipColor;

		-- Store the relationship on the marker itself as the category.
		displayData.categoryName = loc.REG_RELATION .. ": " .. relationShipColor(loc:GetText("REG_RELATION_".. relation));
		displayData.categoryPriority = TRP3_API.globals.RELATIONS_ORDER[relation] or -huge;
	end
	--endregion

	return displayData
end

---@param poiInfo {position:Vector2DMixin, sender:string}
function TRP3_PlayerMapPinMixin:OnAcquired(poiInfo)
	local displayData = getDisplayDataFromPOIInfo(poiInfo);
	poiInfo.atlasName = displayData.iconAtlas or "PartyMember";
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

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

	Ellyb.Tooltips.getTooltip(self):SetTitle(loc.REG_PLAYERS):ClearLines();
end