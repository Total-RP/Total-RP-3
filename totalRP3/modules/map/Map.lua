----------------------------------------------------------------------------------
--- Total RP 3
--- New map system
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

local Map = {};

-- These are the map IDs for zones that have a phase personal to the user (garrisons)
-- TODO Update with BfA zones ID
local PERSONAL_PHASED_ZONES = {
	971, -- Alliance garrison
	976  -- Horde garrison
};

---@return number mapID @ The ID of the zone where the player currently is
function Map.getPlayerMapID()
	return C_Map.GetBestMapForUnit("player");
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
function Map.playerCanSeeTarget(target, targetHasWarModeEnabled)
	-- Players should not see themselves (answer their own requests), except if in DEBUG_MODE, for testing
	if target == TRP3_API.globals.player_id and not TRP3_API.globals.DEBUG_MODE then
		return false;
	end
	local currentMapID = Map.getPlayerMapID();
	if tContains(PERSONAL_PHASED_ZONES, currentMapID) then
		-- If the player is in a personal phased zone, the target has to be in their group to be seen
		return UnitInParty(Ambiguate(target, "none"));
	end
	if not TRP3_API.globals.is_classic and targetHasWarModeEnabled ~= nil then
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
	TRP3_API.MapDataProvider:OnScan({ poiInfo }, pinTemplate)
end

-- Exposing public API
AddOn_TotalRP3.Map = Map;
