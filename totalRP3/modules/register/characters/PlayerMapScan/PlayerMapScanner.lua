-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
		if not TRP3_ClientFeatures.WarMode then
			return not UnitIsPVP("player");
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
	if not TRP3_ClientFeatures.WarMode then
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
	playerMapScanner.scanIcon = Ellyb.Icon(TRP3_InterfaceIcons.PlayerScanIcon)
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
		elseif TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Yell then
			-- When Yell comms are in use we forbid scans in zones other
			-- than the one you're in.
			return false;
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
					broadcast.sendP2PMessage(sender, SCAN_COMMAND, x, y, (not TRP3_ClientFeatures.WarMode) or C_PvP.IsWarModeActive());
				end
			end
		end
	end)

	broadcast.registerP2PCommand(SCAN_COMMAND, function(sender, x, y, hasWarModeActive)
		-- Booleans received from commands are strings, need to cast to boolean
		hasWarModeActive = hasWarModeActive == "true"
		local checkWarMode;

		-- If the option to show people in different War Mode is not enabled we will filter them out from the result
		if TRP3_ClientFeatures.WarMode and not getConfigValue(CONFIG_SHOW_DIFFERENT_WAR_MODES) then
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
