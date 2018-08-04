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
local tonumber = tonumber;
local insert = table.insert;
--endregion

--region WoW imports
local CreateVector2D = CreateVector2D;
--endregion

--region Total RP 3 imports
local loc = TRP3_API.loc;
local broadcast = AddOn_TotalRP3.Communications.broadcast;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local get = TRP3_API.profile.getData;
local Map = AddOn_TotalRP3.Map;
--endregion

local CONFIG_ENABLE_MAP_LOCATION = "register_map_location";
local CONFIG_DISABLE_MAP_LOCATION_ON_OOC = "register_map_location_ooc";

local function shouldAnswerToLocationRequest()
	return getConfigValue(CONFIG_ENABLE_MAP_LOCATION)
		and (not getConfigValue(CONFIG_DISABLE_MAP_LOCATION_ON_OOC) or get("player/character/RP") ~= 2)
end

TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_ENABLE_MAP_LOCATION, true);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_OOC, false);

	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_LOCATION,
	});
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_ACTIVATE,
		help = loc.CO_LOCATION_ACTIVATE_TT,
		configKey = CONFIG_ENABLE_MAP_LOCATION,
	});
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_DISABLE_OOC,
		help = loc.CO_LOCATION_DISABLE_OOC_TT,
		configKey = CONFIG_DISABLE_MAP_LOCATION_ON_OOC,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});
end)

local SCAN_COMMAND = "C_SCAN";
---@type MapScanner
local playerMapScanner = AddOn_TotalRP3.MapScanner("playerScan")
-- Set scan display properties
playerMapScanner.scanIcon = "Achievement_GuildPerk_EverybodysFriend"
playerMapScanner.scanOptionText = loc.MAP_SCAN_CHAR;
playerMapScanner.scanTitle = loc.MAP_SCAN_CHAR_TITLE;
-- Indicate the name of the pin template to use with this scan.
-- The MapDataProvider will use this template to generate the pin
playerMapScanner.dataProviderTemplate = TRP3_PlayerMapPinMixin.TEMPLATE_NAME;

--region Scan behavior
function playerMapScanner:Scan()
	broadcast.broadcast(SCAN_COMMAND, Map.getDisplayedMapID());
end

-- Players can only scan for other players in zones where it is possible to retrieve player coordinates.
function playerMapScanner:CanScan()
	if getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
		local x, y = Map.getPlayerCoordinates()
		if x and y then
			return true;
		end
	end
	return false;
end
--endregion

--region Broadcast commands
broadcast.registerCommand(SCAN_COMMAND, function(sender, mapID)
	if Map.playerCanSeeTarget(sender) then
		mapID = tonumber(mapID);
		if shouldAnswerToLocationRequest() and Map.playerCanSeeTarget(sender) then
			local playerMapID = Map.getPlayerMapID();
			if playerMapID ~= mapID then
				return
			end
			local x, y = Map.getPlayerCoordinates();
			if x and y then
				broadcast.sendP2PMessage(sender, SCAN_COMMAND, x, y, playerMapID);
			end
		end
	end
end)

broadcast.registerP2PCommand(SCAN_COMMAND, function(sender, x, y)
	if Map.playerCanSeeTarget(sender) then
		playerMapScanner:OnScanDataReceived(sender, x, y)
	end
end)
--endregion