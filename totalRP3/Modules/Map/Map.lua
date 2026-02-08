-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
---@type AddOn_TotalRP3

local Map = {};
Map.Enums = {};

-- These are the map IDs for zones that have a phase personal to the user (garrisons)
-- TODO Update with BfA zones ID
Map.Enums.PERSONAL_PHASED_ZONES = {
	GARRISON_A = 1, -- Lunarfall (Alliance garrison)
	GARRISON_H = 2, -- Frostwall (Horde garrison)
};

Map.Enums.PERSONAL_PHASED_ZONES_UIMAPID = {
	[Map.Enums.PERSONAL_PHASED_ZONES.GARRISON_A] = 582, -- Lunarfall (Alliance garrison)
	[Map.Enums.PERSONAL_PHASED_ZONES.GARRISON_H] = 590, -- Frostwall (Horde garrison)
};

Map.Enums.NEIGHBORHOOD_ZONES = {
	ALLIANCE = 1,
	HORDE = 2,
};

Map.Enums.NEIGHBORHOOD_ZONES_UIMAPID = {
	[Map.Enums.NEIGHBORHOOD_ZONES.ALLIANCE] = 2352,
	[Map.Enums.NEIGHBORHOOD_ZONES.HORDE] = 2351,
};

function Map.IsHousingMap()
	return tContains(Map.Enums.NEIGHBORHOOD_ZONES_UIMAPID, Map.getDisplayedMapID());
end

function Map.IsCurrentHousingMap()
	local neighborhoodGUID = C_Housing.GetCurrentNeighborhoodGUID();
	return neighborhoodGUID and C_Housing.GetUIMapIDForNeighborhood(neighborhoodGUID) == Map.getDisplayedMapID();
end

---@return number mapID @ The ID of the zone where the player currently is
function Map.getPlayerMapID()
	return C_Map.GetBestMapForUnit("player") or 946; -- If GetBestMapForUnit returns nil, use the cosmic map ID.
end

---@return number, number x, y @ Returns the X and Y coordinates of the player for the current map, or nil if we could not get their coordinates
function Map.getPlayerCoordinates()
	---@type Vector2DMixin
	local position = C_Map.GetPlayerMapPosition(Map.getPlayerMapID(), "player");
	if not position then
		return
	end
	return position:GetXY()
end

---playerCanSeeTarget
---@param target string @ A valid unit token
---@param targetHasWarModeEnabled bool|nil @ Indicate if the target has War Mode enabled or not. If nil, the check for War Mode will be ignored.
---@return boolean canSeeTarget @ Return true if the player can see the target, or false if something like phases prevent them from seeing each other.
function Map.playerCanSeeTarget(target, targetHasWarModeEnabled, targetMapID)
	-- Players should not see themselves (answer their own requests), except if in DEBUG_MODE, for testing
	if target == TRP3.globals.player_id and not TRP3.globals.DEBUG_MODE then
		return false;
	end
	local currentMapID = Map.getPlayerMapID();
	if tContains(Map.Enums.PERSONAL_PHASED_ZONES_UIMAPID, targetMapID or currentMapID) then
		-- If the player is in a personal phased zone, the target has to be in their group to be seen
		return UnitInParty(Ambiguate(target, "none"));
	end
	if TRP3_ClientFeatures.WarMode and targetHasWarModeEnabled ~= nil then
		return C_PvP.IsWarModeActive() == targetHasWarModeEnabled
	end
	return true;
end

local MAX_DISTANCE_MARKER = math.sqrt(0.5);
function Map.getDistanceFromMapCenterFactor(position)
	local x, y = position:GetXY();
	local distanceX = 0.5 - x;
	local distanceY = 0.5 - y;
	local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY);
	local factor = distance/MAX_DISTANCE_MARKER;
	return factor;
end

function Map.getDisplayedMapID()
	return WorldMapFrame:GetMapID();
end

function Map.placeSingleMarker(x, y, poiInfo, pinTemplate)
	poiInfo.position = CreateVector2D(x, y);
	TRP3.MapDataProvider:OnScan({ poiInfo }, pinTemplate)
end

-- Exposing public API
AddOn_TotalRP3.Map = Map;
