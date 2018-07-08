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
local insert = table.insert;
local sort = table.sort;
local huge = math.huge;
--endregion

--region WoW imports
local After = C_Timer.After;
--endregion

--region Total RP 3 imports
local loc = TRP3_API.loc;
--endregion

-- Create the pin template, above group members
---@type BaseMapPoiPinMixin|MapCanvasPinMixin|{GetMap:fun():MapCanvasMixin}
TRP3_PlayerMapPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");

TRP3_PlayerMapPinMixin.TEMPLATE_NAME = "TRP3_PlayerMapPinTemplate";

-- SCAN_MARKER_BLIP_RELATIONSHIP_SUBLEVEL is a texture sublevel applied to the
-- blip for markers representing characters you have relationship states set
-- with.
--
-- The net result is they'll take priority in the draw order, and get shown
-- on top of a pile of dots in crowded scenarios.
local SCAN_MARKER_BLIP_RELATIONSHIP_SUBLEVEL = 4;

--- Decorates a marker with additional information based upon the established
--  relationship defined in the characters' profile.
--
--  @param characterID The ID of the character.
--  @param entry The entry containing the scan result data.
--  @param marker The marker blip being decorated.
local function scanMarkerDecorateRelationship(characterID, marker)
	-- Skip bad character IDs.
	if not TRP3_API.register.isUnitIDKnown(characterID) then
		return;
	end

	-- Easiest way to get at relationship stuff takes the profile ID.
	local profileID = TRP3_API.register.getUnitIDProfileID(characterID);
	if not profileID then
		return;
	end

	local relation = TRP3_API.register.relation.getRelation(profileID);
	if math.random() > 0.5 then
		relation = TRP3_API.register.relation.BUSINESS
	end
	if relation == TRP3_API.register.relation.NONE then
		-- This profile has no relationship status.
		return;
	end

	-- Swap out the atlas for this marker.
	marker.iconAtlas = "PlayerPartyBlip";

	-- Recycle any color instance already present if there is one.
	local r, g, b = TRP3_API.register.relation.getRelationColors(profileID);
	marker.iconColor = marker.iconColor or Ellyb.Color(0, 0, 0, 0);
	marker.iconColor:SetRGBA(r, g, b, 1);

	-- Arbitrary increase in layer means we'll display these icons over the
	-- defaults.
	marker.iconSublevel = SCAN_MARKER_BLIP_RELATIONSHIP_SUBLEVEL;

	-- Store the relationship on the marker itself as the category.
	marker.categoryName = loc:GetText("REG_RELATION_".. relation);
	marker.categoryPriority = TRP3_API.globals.RELATIONS_ORDER[relation] or -huge;
end


---@param poiInfo {position:Vector2DMixin}
function TRP3_PlayerMapPinMixin:OnAcquired(poiInfo)
	poiInfo.atlasName = "RaidMember";
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

	self.Texture:SetSize(16, 16);
	self:SetSize(16, 16);

	local characterID = poiInfo.sender;
	local playerName;
	if TRP3_API.register.isUnitIDKnown(characterID) and TRP3_API.register.hasProfile(characterID) then
		local profile = TRP3_API.register.getUnitIDCurrentProfile(characterID);
		playerName = TRP3_API.register.getCompleteName(profile.characteristics, characterID, true);

		if profile.characteristics and profile.characteristics.CH then
			local color = Ellyb.Color.CreateFromHexa(profile.characteristics.CH);
			playerName = color(playerName)
		end
	else
		-- Remove server name
		playerName = characterID:gsub("%-.*$", "");
	end
	self.tooltipLine = playerName;

	Ellyb.Tooltips.getTooltip(self):SetTitle(loc.REG_PLAYERS):ClearLines();

	if TRP3_API.ui.misc.shouldPlayUIAnimation then
		local x, y = poiInfo.position:GetXY();
		self:Hide();
		After(AddOn_TotalRP3.Map.getDistanceFromMapCenterFactor(poiInfo.position), function()
			self:Show();
			TRP3_API.ui.misc.playAnimation(self.Bounce);
		end);
	end
end

function TRP3_PlayerMapPinMixin:OnMouseEnter()
	local tooltip = Ellyb.Tooltips.getTooltip(self);
	-- Iterate over the blips in a first pass to build a list of all the ones we're mousing over.
	for marker in self:GetMap():EnumerateAllPins() do
		if marker:IsVisible() and marker:IsMouseOver() then
			tooltip:AddTempLine(marker.tooltipLine)
		end
	end
	tooltip:Show();
end