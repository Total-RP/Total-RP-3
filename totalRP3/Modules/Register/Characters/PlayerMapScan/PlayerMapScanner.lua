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
local CONFIG_ROLEPLAY_STATUS_VISIBILITY = "register_map_location_status_visibility";

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

local RoleplayStatusVisibility = {
	ShowAll = true,
	ShowInCharacter = false,
};

local function ShouldShowRoleplayStatus(roleplayStatus)
	local preferredVisibility = getConfigValue(CONFIG_ROLEPLAY_STATUS_VISIBILITY);
	local shouldShowStatus;

	if roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		shouldShowStatus = (preferredVisibility ~= RoleplayStatusVisibility.ShowInCharacter);
	else
		shouldShowStatus = true;
	end

	return shouldShowStatus;
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_ENABLE_MAP_LOCATION, true);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_OOC, false);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE, false);
	registerConfigKey(CONFIG_SHOW_DIFFERENT_WAR_MODES, false);
	registerConfigKey(CONFIG_ROLEPLAY_STATUS_VISIBILITY, RoleplayStatusVisibility.ShowInCharacter);

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
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_SHOW_OUT_OF_CHARACTER,
		help = loc.CO_LOCATION_SHOW_OUT_OF_CHARACTER_TT,
		configKey = CONFIG_ROLEPLAY_STATUS_VISIBILITY,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});


	local SCAN_COMMAND = "C_SCAN";
	---@type MapScanner
	local playerMapScanner = AddOn_TotalRP3.MapScanner("playerScan");
	-- Set scan display properties
	playerMapScanner.scanIcon = Ellyb.Icon(TRP3_InterfaceIcons.PlayerScanIcon);
	playerMapScanner.scanOptionText = loc.MAP_SCAN_CHAR;
	playerMapScanner.scanTitle = loc.MAP_SCAN_CHAR_TITLE;
	-- Indicate the name of the pin template to use with this scan.
	-- The MapDataProvider will use this template to generate the pin
	playerMapScanner.dataProviderTemplate = TRP3_PlayerMapPinMixin.TEMPLATE_NAME;

	--{{{ Scan behavior
	--TODO: find a better way to trigger guild-only scans
	function playerMapScanner:Scan()
		local method = IsShiftKeyDown() and TRP3_BroadcastMethod.Guild or TRP3_ClientFeatures.BroadcastMethod;
		broadcast.broadcast(SCAN_COMMAND, method, Map.getDisplayedMapID());
	end

	-- Players can only scan for other players in zones where it is possible to retrieve player coordinates.
	function playerMapScanner:CanScan()
		if not getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
			return false;
		end

		-- Check if the map we are going to scan is the map the player is currently in
		-- and if we have access to coordinates. If not, it's a protected zone and we cannot scan.
		if Map.getDisplayedMapID() == Map.getPlayerMapID() then
			local x, y = Map.getPlayerCoordinates();
			if not x or not y then
				return false;
			end
		elseif not TRP3_ClientFeatures.ChannelBroadcasts then
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
					return;
				end
				local x, y = Map.getPlayerCoordinates();
				if x and y then
					local hasWarModeActive = (not TRP3_ClientFeatures.WarMode) or C_PvP.IsWarModeActive();
					local roleplayStatus = AddOn_TotalRP3.Player.GetCurrentUser():GetRoleplayStatus();

					broadcast.sendP2PMessage(sender, SCAN_COMMAND, x, y, hasWarModeActive, roleplayStatus);
				end
			end
		end
	end)

	broadcast.registerP2PCommand(SCAN_COMMAND, function(sender, x, y, hasWarModeActive, roleplayStatus)
		-- Parameters received from commands are strings, need to cast to appropriate types
		hasWarModeActive = (hasWarModeActive == "true");
		roleplayStatus = tonumber(roleplayStatus);
		local checkWarMode;

		-- If the option to show people in different War Mode is not enabled we will filter them out from the result
		if TRP3_ClientFeatures.WarMode and not getConfigValue(CONFIG_SHOW_DIFFERENT_WAR_MODES) then
			checkWarMode = hasWarModeActive;
		end

		if not roleplayStatus then
			-- Compatibility for old network clients; assume they're in-character.
			roleplayStatus = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
		end

		if Map.playerCanSeeTarget(sender, checkWarMode) and ShouldShowRoleplayStatus(roleplayStatus) then
			playerMapScanner:OnScanDataReceived(sender, x, y, {
				hasWarModeActive = hasWarModeActive,
				roleplayStatus = roleplayStatus,
			});
		end
	end)
	--}}}
end)

-- Slash command integration

function TRP3_API.IsLocationBroadcastEnabled()
	return TRP3_API.configuration.getValue(CONFIG_ENABLE_MAP_LOCATION);
end

function TRP3_API.SetLocationBroadcastEnabled(enabled)
	local state = TRP3_API.IsLocationBroadcastEnabled();

	if state == enabled then
		return;
	end

	TRP3_API.configuration.setValue(CONFIG_ENABLE_MAP_LOCATION, enabled);
end

local function DisplayLocationBroadcastStatus()
	if TRP3_API.IsLocationBroadcastEnabled() then
		SendSystemMessage(loc.SLASH_CMD_LOCATION_ENABLED);
	else
		SendSystemMessage(loc.SLASH_CMD_LOCATION_DISABLED);
	end
end

local function LocationBroadcastCommandHelp()
	local stem = WrapTextInColorCode("/trp3 location", "ffffffff");
	local options = WrapTextInColorCode("<on||off||status||toggle>", "ffffcc00");
	local examples = {
		"",  -- Empty leading line.
		string.format(loc.SLASH_CMD_LOCATION_HELP_OFF, WrapTextInColorCode("/trp3 location off", "ffffffff")),
		string.format(loc.SLASH_CMD_LOCATION_HELP_ON, WrapTextInColorCode("/trp3 location on", "ffffffff")),
		string.format(loc.SLASH_CMD_LOCATION_HELP_STATUS, WrapTextInColorCode("/trp3 location status", "ffffffff")),
		string.format(loc.SLASH_CMD_LOCATION_HELP_TOGGLE, WrapTextInColorCode("/trp3 location toggle", "ffffffff")),
	};

	SendSystemMessage(string.format(loc.SLASH_CMD_HELP_USAGE, string.join(" ", stem, options)));
	SendSystemMessage(string.format(loc.SLASH_CMD_HELP_COMMANDS, table.concat(examples, "|n")));
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	TRP3_API.slash.registerCommand({
		id = "location",
		helpLine = " " .. loc.SLASH_CMD_LOCATION_HELP,
		handler = function(...)
			local subcommand = string.trim(string.join(" ", ...));

			if string.find(subcommand, "^%[") then
				subcommand = TRP3_AutomationUtil.ParseMacroOption(subcommand);
			end

			if subcommand == "" or subcommand == "help" then
				LocationBroadcastCommandHelp();
			elseif subcommand == "on" or subcommand == "enable" then
				TRP3_API.SetLocationBroadcastEnabled(true);
				DisplayLocationBroadcastStatus();
			elseif subcommand == "off" or subcommand == "disable" then
				TRP3_API.SetLocationBroadcastEnabled(false);
				DisplayLocationBroadcastStatus();
			elseif subcommand == "toggle" then
				TRP3_API.SetLocationBroadcastEnabled(not TRP3_API.IsLocationBroadcastEnabled());
				DisplayLocationBroadcastStatus();
			elseif subcommand == "status" then
				DisplayLocationBroadcastStatus();
			else
				SendSystemMessage(string.format(loc.SLASH_CMD_LOCATION_FAILED, subcommand));
			end
		end
	});
end);
