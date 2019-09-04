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
local tonumber = tonumber;
local insert = table.insert;
--}}}

--{{{ Total RP 3 imports
local loc = TRP3_API.loc;
local broadcast = AddOn_TotalRP3.Communications.broadcast;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local Map = AddOn_TotalRP3.Map;
--}}}

local CONFIG_ENABLE_MAP_LOCATION = "register_map_location";
local CONFIG_DISABLE_MAP_LOCATION_ON_OOC = "register_map_location_ooc";
local CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE = "register_map_location_disable_war_mode";
local CONFIG_SHOW_DIFFERENT_WAR_MODES = "register_map_location_show_war_modes";

local player = AddOn_TotalRP3.Player.GetCurrentUser()

local function shouldAnswerToLocationRequest()
	if not getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
		return false;
	end
	if getConfigValue(CONFIG_DISABLE_MAP_LOCATION_ON_OOC) and not player:IsInCharacter() then
		return false;
	end
	if getConfigValue(CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE) then
		if TRP3_API.globals.is_classic then
			return UnitIsPVP("player");
		elseif C_PvP.IsWarModeActive() then
			return GetZonePVPInfo() == "sanctuary"
		end
	end
	return true;
end

TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_ENABLE_MAP_LOCATION, true);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_OOC, false);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE, false);
	registerConfigKey(CONFIG_SHOW_DIFFERENT_WAR_MODES, false);

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
	if TRP3_API.globals.is_classic then
		insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_LOCATION_DISABLE_CLASSIC_PVP,
			help = loc.CO_LOCATION_DISABLE_CLASSIC_PVP_TT,
			configKey = CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE,
			dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
		});
	else
		insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_LOCATION_DISABLE_WAR_MODE,
			help = loc.CO_LOCATION_DISABLE_WAR_MODE_TT,
			configKey = CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE,
			dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
		});
		insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_LOCATION_SHOW_DIFFERENT_WAR_MODES,
			help = loc.CO_LOCATION_SHOW_DIFFERENT_WAR_MODES_TT,
			configKey = CONFIG_SHOW_DIFFERENT_WAR_MODES,
			dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
		});
	end


	local SCAN_COMMAND = "C_SCAN";
	---@type MapScanner
	local playerMapScanner = AddOn_TotalRP3.MapScanner("playerScan")
	-- Set scan display properties
	playerMapScanner.scanIcon = Ellyb.Icon("Achievement_GuildPerk_EverybodysFriend")
	playerMapScanner.scanOptionText = loc.MAP_SCAN_CHAR;
	playerMapScanner.scanTitle = loc.MAP_SCAN_CHAR_TITLE;
	-- Indicate the name of the pin template to use with this scan.
	-- The MapDataProvider will use this template to generate the pin
	playerMapScanner.dataProviderTemplate = TRP3_PlayerMapPinMixin.TEMPLATE_NAME;

	--{{{ Scan behavior
	function playerMapScanner:Scan()
		broadcast.broadcast(SCAN_COMMAND, Map.getDisplayedMapID());
	end

	-- Players can only scan for other players in zones where it is possible to retrieve player coordinates.
	function playerMapScanner:CanScan()
		if not getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
			return false
		end

		-- Check if the map we are going to scan is the map the player is currently in
		-- and if we have access to coordinates. If not, it's a protected zone and we cannot scan.
		if Map.getDisplayedMapID() == Map.getPlayerMapID() then
			local x, y = Map.getPlayerCoordinates()
			if not x or not y then
				return false;
			end
		end

		return true;
	end
	--}}}

	--{{{ Broadcast commands
	broadcast.registerCommand(SCAN_COMMAND, function(sender, mapID)
		if Map.playerCanSeeTarget(sender) then
			mapID = tonumber(mapID);
			if shouldAnswerToLocationRequest() then
				local playerMapID = Map.getPlayerMapID();
				if playerMapID ~= mapID then
					return
				end
				local x, y = Map.getPlayerCoordinates();
				if x and y then
					broadcast.sendP2PMessage(sender, SCAN_COMMAND, x, y, TRP3_API.globals.is_classic or C_PvP.IsWarModeActive());
				end
			end
		end
	end)

	broadcast.registerP2PCommand(SCAN_COMMAND, function(sender, x, y, hasWarModeActive)
		-- Booleans received from commands are strings, need to cast to boolean
		hasWarModeActive = hasWarModeActive == "true"
		local checkWarMode = not TRP3_API.globals.is_classic;

		-- If the option to show people in different War Mode is not enabled we will filter them out from the result
		if not TRP3_API.globals.is_classic and not getConfigValue(CONFIG_SHOW_DIFFERENT_WAR_MODES) then
			checkWarMode = hasWarModeActive;
		end

		if Map.playerCanSeeTarget(sender, checkWarMode) then
			playerMapScanner:OnScanDataReceived(sender, x, y, {
				hasWarModeActive = hasWarModeActive
			})
		end
	end)
	--}}}
end)
