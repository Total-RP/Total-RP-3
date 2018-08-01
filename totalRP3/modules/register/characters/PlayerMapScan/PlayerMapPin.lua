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

--region Ellyb imports
local ORANGE = Ellyb.ColorManager.ORANGE;
---endregion

-- Create the pin template, above group members
TRP3_PlayerMapPinMixin = AddOn_TotalRP3.MapPoiMixins.createPinTemplate(
	AddOn_TotalRP3.MapPoiMixins.GroupedCoalescedMapPinMixin, -- Use coalesced grouped tooltips (show multiple player names)
	AddOn_TotalRP3.MapPoiMixins.AnimatedPinMixin -- Use animated icons (bounce in)
);

-- Expose template name, so the scan can use it for the MapDataProvider
TRP3_PlayerMapPinMixin.TEMPLATE_NAME = "TRP3_PlayerMapPinTemplate";

--- This is called when the data provider acquire a pin, to transform poiInfo received from the scan
--- into display info to be used to decorate the pin.
function TRP3_PlayerMapPinMixin:GetDisplayDataFromPoiInfo(poiInfo)
	local characterID = poiInfo.sender;
	local displayData = {};
	local isSelf = characterID == TRP3_API.globals.player_id;

	if not isSelf and (not TRP3_API.register.isUnitIDKnown(characterID) or not TRP3_API.register.hasProfile(characterID)) then
		-- Only remove the server name from the sender ID
		displayData.playerName = characterID:gsub("%-.*$", "");
		return displayData;
	end

	local profile;
	if isSelf then
		-- Special case when seeing ourselves on the map (DEBUG)
		profile = TRP3_API.profile.getPlayerCurrentProfile().player;
		displayData.iconAtlas = "PlayerPartyBlip";
		displayData.iconColor = Ellyb.ColorManager.CYAN;
		displayData.categoryName = loc.REG_RELATION .. ": " .. Ellyb.ColorManager.CYAN("SELF");
		displayData.categoryPriority = -huge;
	else
		profile = TRP3_API.register.getUnitIDCurrentProfile(characterID);

		--region Player relationship
		local relation = TRP3_API.register.relation.getRelation(TRP3_API.register.getUnitIDProfileID(characterID));
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
	end

	--region Player name
	displayData.playerName = TRP3_API.register.getCompleteName(profile.characteristics, characterID, true);

	if profile.characteristics then
		if profile.characteristics.CH then
			local color = Ellyb.Color.CreateFromHexa(profile.characteristics.CH);
			displayData.playerName = color(displayData.playerName);
		end
		if profile.characteristics.IC then
			displayData.playerName = TRP3_API.utils.str.icon(profile.characteristics.IC, 15) .. " " .. displayData.playerName;
		end
	end
	--endregion

	return displayData
end

--- This is called by the data provider to decorate the pin after the base pin mixin has done its job.
---@param poiInfo {position:Vector2DMixin, sender:string}
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

	Ellyb.Tooltips.getTooltip(self):SetTitle(ORANGE(loc.REG_PLAYERS)):ClearLines();
end