-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

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
		if not UnitIsPVPSanctuary("player") then
			if UnitIsPVPFreeForAll("player") then
				return false;
			elseif UnitIsPVP("player") then
				return false;
			elseif TRP3_API.utils.IsWarModeFeatureEnabled() and C_PvP.IsWarModeActive() then
				return false;
			end
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

local SCAN_COMMAND = "C_SCAN";
local lastScannerUsed;
-- The shared map APIs do not distinguish Forever's addressed transport.
local isForever = WOW_PROJECT_CAMELOT and WOW_PROJECT_ID == WOW_PROJECT_CAMELOT;
local StartForeverMapScan;
local ReportForeverMapScan;
local ForeverScanWindow = 12;

local PlayerMapScannerMixin = {};
-- Set scan display properties
PlayerMapScannerMixin.scanIcon = Ellyb.Icon(TRP3_InterfaceIconIDs.PlayerScanIcon);
PlayerMapScannerMixin.scanOptionText = loc.MAP_SCAN_CHAR;
PlayerMapScannerMixin.scanTitle = loc.MAP_SCAN_CHAR_TITLE;
PlayerMapScannerMixin.broadcastMethod = TRP3_API.BroadcastMethod.World
-- Indicate the name of the pin template to use with this scan.
-- The MapDataProvider will use this template to generate the pin
PlayerMapScannerMixin.dataProviderTemplate = TRP3_PlayerMapPinMixin.TEMPLATE_NAME;

--{{{ Default scan behavior
function PlayerMapScannerMixin:Scan()
	if isForever then
		StartForeverMapScan(self);
		return;
	end
	local mapID = Map.getDisplayedMapID();
	if Map.IsHousingMap() then
		-- In neighborhoods we use the GUID instead (scan is disabled if you're not in a neighborhood)
		mapID = C_Housing.GetCurrentNeighborhoodGUID();
	end
	broadcast.broadcast(SCAN_COMMAND, self.broadcastMethod, mapID);
	lastScannerUsed = self;
end

function PlayerMapScannerMixin:OnScanCompleted()
	if isForever then ReportForeverMapScan(self) end
end

-- Players can only scan for other players in zones where it is possible to retrieve player coordinates.
function PlayerMapScannerMixin:CanScan()
	if not getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
		return false;
	end
	if isForever then
		local mapID = Map.getDisplayedMapID();
		return not InCombatLockdown() and canaccessvalue(mapID) and type(mapID) == "number" and mapID > 0;
	end

	-- Check if the map we are going to scan is the map the player is currently in
	-- and if we have access to coordinates. If not, it's a protected zone and we cannot scan.
	if Map.getDisplayedMapID() == Map.getPlayerMapID() then
		local x, y = Map.getPlayerCoordinates();
		if not x or not y then
			return false;
		end
	elseif Map.IsHousingMap() and not Map.IsCurrentHousingMap() then
		-- Can't scan the neighborhood map if you're not in the neighborhood
		return false;
	elseif not TRP3_ClientFeatures.ChannelBroadcasts then
		-- When Yell comms are in use we forbid scans in zones other
		-- than the one you're in.
		return false;
	end

	return true;
end

local function newMapScanner(scanID)
	local scanner = AddOn_TotalRP3.MapScanner(scanID);
	Mixin(scanner, PlayerMapScannerMixin);
	if isForever then scanner.duration = ForeverScanWindow end
	return scanner;
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	registerConfigKey(CONFIG_ENABLE_MAP_LOCATION, true);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_OOC, false);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE, false);
	registerConfigKey(CONFIG_SHOW_DIFFERENT_WAR_MODES, false);
	registerConfigKey(CONFIG_ROLEPLAY_STATUS_VISIBILITY, RoleplayStatusVisibility.ShowInCharacter);

	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_LOCATION,
	});
	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_ACTIVATE,
		help = loc.CO_LOCATION_ACTIVATE_TT,
		configKey = CONFIG_ENABLE_MAP_LOCATION,
	});
	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_DISABLE_OOC,
		help = loc.CO_LOCATION_DISABLE_OOC_TT,
		configKey = CONFIG_DISABLE_MAP_LOCATION_ON_OOC,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});
	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_DISABLE_PVP,
		help = loc.CO_LOCATION_DISABLE_PVP_TT,
		configKey = CONFIG_DISABLE_MAP_LOCATION_ON_WAR_MODE,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});
	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_SHOW_DIFFERENT_WAR_MODES,
		help = loc.CO_LOCATION_SHOW_DIFFERENT_WAR_MODES_TT,
		configKey = CONFIG_SHOW_DIFFERENT_WAR_MODES,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
		showPredicate = function() return TRP3_API.utils.IsWarModeFeatureEnabled(); end,
	});
	table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_SHOW_OUT_OF_CHARACTER,
		help = loc.CO_LOCATION_SHOW_OUT_OF_CHARACTER_TT,
		configKey = CONFIG_ROLEPLAY_STATUS_VISIBILITY,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});

	local playerMapScanner = newMapScanner("playerScan");
	playerMapScanner.scanSortIndex = 0;

	---@type MapScanner
	local guildMapScanner = newMapScanner("guildScan");
	guildMapScanner.scanIcon = Ellyb.Icon(TRP3_InterfaceIconIDs.MiscInfoGuildRank);
	guildMapScanner.scanOptionText = loc.MAP_SCAN_CHAR_GUILD_ONLY;
	guildMapScanner.scanSortIndex = 50;
	guildMapScanner.scanTitle = loc.MAP_SCAN_CHAR_GUILD_ONLY_TITLE;
	guildMapScanner.broadcastMethod = TRP3_API.BroadcastMethod.Guild;

	local CanScanCommon = guildMapScanner.CanScan;
	guildMapScanner.CanScan = function(self)
		if not IsInGuild() then
			return false;
		end
		return CanScanCommon(self);
	end

	local function GetScanResponseCoordinates(mapID)
		local x, y;
		local inInstance, instanceType = IsInInstance();
		if inInstance then
			if instanceType == "interior" then
				if not FlagsUtil.IsSet(C_Housing.GetHousingAccessFlags(), Enum.HouseSettingFlags.HouseAccessAnyone) then
					-- House is not open to everyone, don't respond
					return;
				end

				local houseInfo = C_Housing.GetCurrentHouseInfo();
				if not houseInfo or houseInfo.neighborhoodGUID ~= mapID then
					-- House info doesn't match neighborhood
					return;
				end

				local plotEntryID = houseInfo.plotID;
				if C_Housing.GetUIMapIDForNeighborhood(houseInfo.neighborhoodGUID) == Map.Enums.NEIGHBORHOOD_ZONES_UIMAPID[Map.Enums.NEIGHBORHOOD_ZONES.ALLIANCE] then
					-- Only Alliance starts at 0, thanks Blizz
					plotEntryID = plotEntryID + 1;
				end

				local houseMapInfo = C_HousingNeighborhood.GetNeighborhoodMapData()[plotEntryID];
				-- Adding a little bit of fuzzing so it's easier to see if there are multiple people in a house
				x = houseMapInfo.mapPosition.x + fastrandom(-15, 15) * 0.0001;
				y = houseMapInfo.mapPosition.y + fastrandom(-25, 25) * 0.0001;
			elseif instanceType == "neighborhood" then
				local neighborhoodGUID = C_Housing.GetCurrentNeighborhoodGUID();
					if neighborhoodGUID ~= mapID then
					-- Wrong zone
					return;
				end

				x, y = Map.getPlayerCoordinates();
			else
				-- no point responding if inside a non-housing instance
				return;
			end
		else
			mapID = tonumber(mapID);

			local playerMapID = Map.getPlayerMapID();
			if playerMapID ~= mapID then
				-- Wrong zone
				return;
			end
			x, y = Map.getPlayerCoordinates();
		end

		return string.format("%.3f", x), string.format("%.3f", y);
	end

	--{{{ Broadcast commands
	broadcast.registerCommand(SCAN_COMMAND, function(sender, mapID)
		if Map.playerCanSeeTarget(sender) then
			if shouldAnswerToLocationRequest() then
				local x, y = GetScanResponseCoordinates(mapID);
				if x and y then
					local hasWarModeActive = TRP3_API.utils.IsWarModeFeatureEnabled() and C_PvP.IsWarModeActive();
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
		if TRP3_API.utils.IsWarModeFeatureEnabled() and not getConfigValue(CONFIG_SHOW_DIFFERENT_WAR_MODES) then
			checkWarMode = hasWarModeActive;
		end

		if not roleplayStatus then
			-- Compatibility for old network clients; assume they're in-character.
			roleplayStatus = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
		end

		local scannedMapID = Map.getDisplayedMapID()
		if Map.playerCanSeeTarget(sender, checkWarMode, scannedMapID) and ShouldShowRoleplayStatus(roleplayStatus) and lastScannerUsed then
			lastScannerUsed:OnScanDataReceived(sender, x, y, {
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

-- Forever uses addressed map replies. Other clients keep the native broadcast scanner.
if isForever then
	local L = TRP3_API.loc;
	local RosterBatchSize = 80;
	local MaxDirectProbes = 14;
	local MaxBridgeRequests = 14;
	local MaxBridgeHandshakes = 6;
	local Prefix = "SVMAP1";
	local ShareKey = "register_svmap_forever_share";
	local ScanWindow = ForeverScanWindow;
	local activeScan;
	local serial = 0;
	local lastReplies = {};
	local lastIncoming = {};
	local lastScan;
	local heardFrom = {};
	local rosterCursor;

	local function CancelScan()
		if activeScan and activeScan.scanner then
			activeScan.scanner:ResetScanData();
		end
		activeScan = nil;
	end

	local function IsScanActive(scan)
		if activeScan ~= scan then return false end
		if GetTime() >= scan.deadline then
			activeScan = nil;
			return false;
		end
		local displayedMap = Map.getDisplayedMapID();
		if InCombatLockdown() or not canaccessvalue(displayedMap) or displayedMap ~= scan.map then
			CancelScan();
			return false;
		end
		return true;
	end

	local function RememberPeer(peer)
		local now = GetTime();
		local count, oldest, oldestAt = 0, nil, math.huge;
		for name, stamp in pairs(heardFrom) do
			if now - stamp > 180 then
				heardFrom[name] = nil;
			else
				count = count + 1;
				if stamp < oldestAt then oldest, oldestAt = name, stamp end
			end
		end
		if not heardFrom[peer] and count >= 128 then heardFrom[oldest] = nil end
		heardFrom[peer] = now;
	end

	function ReportForeverMapScan(scanner)
		local scan = lastScan;
		if not scan or (scanner and scan.scanner ~= scanner) then return end
		SendSystemMessage(L.FOREVER_MAP_SCAN_SUMMARY:format(
			scan.map, scan.sent, scan.attempted, scan.received, scan.shown, scan.received - scan.shown));
		if scan.firstReply then
			SendSystemMessage(L.FOREVER_MAP_SCAN_LOCATION:format(
				scan.firstReply.peer, scan.firstReply.x * 100, scan.firstReply.y * 100));
		end
		if scan.rosterMatches then
			SendSystemMessage(L.FOREVER_MAP_SCAN_ROSTER:format(
				scan.rosterMatches, scan.rosterRead, scan.probes));
		end
		if scan.bridgeSent then
			SendSystemMessage(L.FOREVER_MAP_SCAN_BRIDGE:format(
				scan.bridgeProbes, scan.bridgeSent, scan.bridgeReceived));
		end
	end

	local function NormalizePeer(name)
		if not canaccessvalue(name) or type(name) ~= "string" or #name > 110 or name:find("[%c|~]") then
			return nil;
		end
		-- Forever whisper addresses use the character's name without the backend realm.
		name = name:gsub("[- ]*[Cc][Aa][Mm][Ww][Oo][Ww]%a*%d+[Rr][Ee][Aa][Ll][Mm]%d+%a*$", "");
		return TRP3_NameUtil.GetQualifiedNameFromString((name:gsub("[-%s]+", " ")));
	end

	local function Send(peer, packet, route, manual)
		local target = peer and peer:gsub(" ", "-");
		local ok, result = pcall(C_ChatInfo.SendAddonMessage, Prefix, packet, route or "WHISPER", target);
		local codes = Enum and Enum.SendAddonMessageResult;
		local submitted = ok and (result == nil or result == true or result == (codes and codes.Success or 0));
		local bridge = StoryveilProfileBridge;
		if submitted and peer and not manual and (not route or route == "WHISPER") and bridge and bridge.TrackMeshWhisper then
			-- A submitted whisper can still produce an asynchronous player not found message.
			bridge:TrackMeshWhisper(peer, ScanWindow);
		end
		return submitted;
	end

	local function ValidCoordinate(value)
		return canaccessvalue(value) and type(value) == "number" and value >= 0 and value <= 1;
	end

	local function OnLocationMessage(_, _, prefix, packet, route, sender, bridgeRoute, reply)
		if not canaccessallvalues(prefix, packet, route, sender) or prefix ~= Prefix or
			type(packet) ~= "string" or #packet > 100 then
			return;
		end
		local peer = NormalizePeer(sender);
		if not peer or peer == TRP3_API.globals.player_id or TRP3_API.register.isIDIgnored(peer) then
			return;
		end
		local kind = packet:sub(1, 2);
		if kind == "Q|" then
			local nonce, map = packet:match("^Q|([%d%-]+)|(%d+)$");
			if not nonce or #nonce > 28 or #map > 10 then return end
			local mapID = tonumber(map);
			if not bridgeRoute and route ~= "WHISPER" and route ~= "GUILD" and route ~= "PARTY" and
				route ~= "RAID" and route ~= "YELL" then return end
			if mapID > 0 then RememberPeer(peer) end
			local transport = bridgeRoute and "bridge" or "direct";
			lastIncoming[transport] = {map = mapID};
			local function Report(result) lastIncoming[transport].result = result end
			if InCombatLockdown() then return Report(L.FOREVER_MAP_REPLY_IN_COMBAT) end
			if not getConfigValue(ShareKey) then return Report(L.FOREVER_MAP_REPLY_SHARING_OFF) end
			if not getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then return Report(L.FOREVER_MAP_REPLY_LOCATION_OFF) end
			if not shouldAnswerToLocationRequest() then return Report(L.FOREVER_MAP_REPLY_FILTERED) end
			local playerMap = Map.getPlayerMapID();
			if not canaccessvalue(playerMap) or type(playerMap) ~= "number" then return Report(L.FOREVER_MAP_REPLY_MAP_UNKNOWN) end
			if mapID <= 0 or mapID ~= playerMap then return Report(L.FOREVER_MAP_REPLY_MAP_MISMATCH:format(playerMap)) end
			if IsInInstance() or not Map.playerCanSeeTarget(peer) then return Report(L.FOREVER_MAP_REPLY_PHASE) end
			-- A direct whisper can fail even when the bridge route is available.
			if GetTime() - (lastReplies[transport] or -math.huge) < 1 then return Report(L.FOREVER_MAP_REPLY_COOLDOWN) end
			local x, y = Map.getPlayerCoordinates();
			if ValidCoordinate(x) and ValidCoordinate(y) then
				local status = player:IsInCharacter() and 2 or 1; -- SVMAP1 status, distinct from RPB1.
				local response = ("R|%s|%d|%.5f|%.5f|%d"):format(nonce, mapID, x, y, status);
				local sent;
				if reply then sent = reply(response) else sent = Send(peer, response) end
				if sent then lastReplies[transport] = GetTime() end
				Report(sent and L.FOREVER_MAP_REPLY_SUBMITTED or L.FOREVER_MAP_REPLY_FAILED);
			else
				Report(L.FOREVER_MAP_REPLY_NO_COORDINATES);
			end
			return;
		end

		local scan = activeScan;
		if kind ~= "R|" or not scan or not IsScanActive(scan) or scan.replied[peer] then return end
		if bridgeRoute then
			if not scan.bridgeRequested or scan.bridgeRequested[bridgeRoute] ~= peer then return end
		else
			if route ~= "WHISPER" then return end
			if scan.peer and scan.peer ~= peer then return end
			if not scan.peer and not scan.shared and not scan.requested[peer] then return end
		end
		local replyNonce, replyMap, x, y, status = packet:match("^R|([%d%-]+)|(%d+)|([%d.]+)|([%d.]+)|([123])$");
		if replyNonce ~= scan.nonce or tonumber(replyMap) ~= scan.map then
			return;
		end
		x, y = tonumber(x), tonumber(y);
		if not ValidCoordinate(x) or not ValidCoordinate(y) or not Map.playerCanSeeTarget(peer, nil, scan.map) then
			return;
		end
		scan.replied[peer] = true;
		RememberPeer(peer);
		scan.received = scan.received + 1;
		if bridgeRoute then scan.bridgeReceived = scan.bridgeReceived + 1 end
		scan.firstReply = scan.firstReply or {peer = peer, x = x, y = y};
		if scan.peer then activeScan = nil end
		local statuses = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS;
		local rpStatus = status == "1" and statuses.OUT_OF_CHARACTER or statuses.IN_CHARACTER;
		if not ShouldShowRoleplayStatus(rpStatus) then
			if scan.peer then SendSystemMessage(L.FOREVER_MAP_REPLY_STATUS_HIDDEN) end
			return;
		end

		scan.shown = scan.shown + 1;
		local pinData = {sender = peer, roleplayStatus = rpStatus};
		if scan.scanner then
			scan.scanner:OnScanDataReceived(peer, x, y, pinData);
		else
			Map.placeSingleMarker(x, y, pinData, TRP3_PlayerMapPinMixin.TEMPLATE_NAME);
			SendSystemMessage(L.FOREVER_MAP_REPLY_RECEIVED:format(peer));
		end
	end

	local function StartBridgeScan(scan, packet, peers)
		local bridge = StoryveilProfileBridge;
		if not bridge or not bridge.supportsTRP3Map or not bridge.started or
			not bridge.settings.enabled or not bridge.settings.crossRealm then return end
		scan.bridgeSent, scan.bridgeReceived, scan.bridgeProbes, scan.bridgeRequested = 0, 0, 0, {};
		bridge:Discover(true);
		local queried, probed = {}, {};
		local contacts = bridge.MapWhisperContacts and bridge:MapWhisperContacts() or {};
		local function ProbeWhisper(name, faction)
			local peer = NormalizePeer(name);
			if not peer or peer == TRP3_API.globals.player_id or queried[peer] or probed[peer] or
				scan.replied[peer] or TRP3_API.register.isIDIgnored(peer) then return false end
			probed[peer] = true;
			if not bridge:ProbeMapWhisper(peer, faction) then return false end
			scan.bridgeProbes = scan.bridgeProbes + 1;
			return true;
		end
		local function DiscoverWhisper()
			if not bridge.ProbeMapWhisper or scan.bridgeProbes >= MaxBridgeHandshakes then return end
			for _, contact in ipairs(contacts) do
				if ProbeWhisper(contact.name, contact.faction) then return end
			end
			for _, peer in ipairs(peers) do
				local faction = bridge.observedFactions and bridge.observedFactions[bridge:Key(peer)];
				if ProbeWhisper(peer, faction) then return end
			end
		end
		local function ProbeRoutes()
			if not IsScanActive(scan) or not bridge.settings.enabled or not bridge.settings.crossRealm then return end
			for _, entry in ipairs(bridge:Routes()) do
				local route = entry.peer.route;
				local peer = NormalizePeer(route.name);
				if peer and not queried[peer] and not scan.replied[peer] and
					not TRP3_API.register.isIDIgnored(peer) and bridge:SendMapLocation(route, packet) then
					queried[peer] = true;
					scan.bridgeRequested[bridge:RouteKey(route)] = peer;
					scan.bridgeSent = scan.bridgeSent + 1;
					break;
				end
			end
			DiscoverWhisper();
			if scan.bridgeSent < MaxBridgeRequests then C_Timer.After(0.8, ProbeRoutes) end
		end
		ProbeRoutes();
	end

	-- Visible units, recent map traffic and freshly updated profiles go first.
	local function CollectNearbyPeers()
		local peers, seen = {}, {};
		local function Add(name, normalized)
			local peer = normalized and name or NormalizePeer(name);
			if peer and peer ~= TRP3_API.globals.player_id and not seen[peer] and
				not TRP3_API.register.isIDIgnored(peer) then
				seen[peer] = true;
				peers[#peers + 1] = peer;
			end
		end
		local function AddUnit(unit)
			local isPlayer = UnitIsPlayer(unit);
			if canaccessvalue(isPlayer) and isPlayer then
				Add(TRP3_NameUtil.GetQualifiedName(unit));
			end
		end
		for _, unit in ipairs({"target", "focus", "mouseover"}) do AddUnit(unit) end
		for index = 1, 40 do AddUnit("nameplate"..index) end
		local contacts, now = {}, GetTime();
		for name, stamp in pairs(heardFrom) do
			if now - stamp <= 180 then contacts[#contacts + 1] = {name = name, stamp = stamp} end
		end
		table.sort(contacts, function(left, right) return left.stamp > right.stamp end);
		for _, contact in ipairs(contacts) do Add(contact.name) end
		local bridge = StoryveilProfileBridge;
		if bridge and bridge.started and bridge.MeshRPResults then
			local results = bridge:MeshRPResults();
			for i = 1, math.min(8, #results) do Add(results[i].name) end
		end
		return peers, seen, Add;
	end

	-- Snapshot the keys before yielding. Profile updates can change the register
	-- while the scan is in progress.
	local function ReadKnownProfiles(scan, needsRoster, add, onComplete)
		local names = {};
		for name in pairs(TRP3_API.register.getCharacterList()) do
			names[#names + 1] = name;
		end

		local recent, known, epoch = {}, {}, time();
		local function ReadBatch(first)
			if not IsScanActive(scan) then return end
			local last = math.min(first + RosterBatchSize - 1, #names);
			for index = first, last do
				local name = names[index];
				local profile = TRP3_API.register.getUnitIDCurrentProfileSafe(name);
				local updated = profile and profile.time;
				if type(updated) == "number" then
					local isRecent = updated <= epoch and epoch - updated <= 180;
					local peer = (needsRoster or isRecent) and NormalizePeer(name);
					if peer then
						known[peer] = true;
						if isRecent then
							recent[#recent + 1] = {name = peer, updated = updated};
						end
					end
				end
			end
			if last < #names then
				C_Timer.After(0, function() ReadBatch(last + 1) end);
				return;
			end

			table.sort(recent, function(left, right) return left.updated > right.updated end);
			for _, entry in ipairs(recent) do add(entry.name, true) end
			onComplete(known);
		end
		ReadBatch(1);
	end

	local function GetOOCRoster()
		local getMember = C_ChatInfo.GetChannelRosterInfo or GetChannelRosterInfo;
		if not GetChannelDisplayInfo or not getMember then return end
		local count = GetNumDisplayChannels and GetNumDisplayChannels();
		count = canaccessvalue(count) and type(count) == "number" and count or 40;
		for slot = 1, math.min(count, 40) do
			local name, header, _, _, members, active = GetChannelDisplayInfo(slot);
			if canaccessallvalues(name, header, members, active) and type(name) == "string" and
				name:gsub("^%d+%.%s*", ""):lower() == "ooc" and not header and active ~= false and
				type(members) == "number" and members > 0 then
				return slot, math.min(members, 1000), getMember;
			end
		end
	end

	function StartForeverMapScan(scanner)
		local map = Map.getDisplayedMapID();
		if not canaccessvalue(map) or type(map) ~= "number" or map <= 0 then return end
		local now = GetTime();
		serial = serial + 1;
		local scan = {scanner = scanner, map = map, nonce = ("%d-%d"):format(math.floor(now * 1000), serial),
			deadline = now + ScanWindow, requested = {}, replied = {}, sent = 0, attempted = 0, received = 0, shown = 0};
		activeScan, lastScan = scan, scan;
		local packet = ("Q|%s|%d"):format(scan.nonce, map);
		local function Query(peer, route)
			scan.attempted = scan.attempted + 1;
			local sent = Send(peer, packet, route);
			if sent then scan.sent = scan.sent + 1 end
			return sent;
		end
		if scanner.broadcastMethod == TRP3_API.BroadcastMethod.Guild then
			scan.shared = Query(nil, "GUILD");
			return;
		end
		local group = IsInRaid() and "RAID" or IsInGroup() and "PARTY";
		if group then scan.shared = Query(nil, group) end
		if IsInGuild() and Query(nil, "GUILD") then scan.shared = true end
		local playerMap = Map.getPlayerMapID();
		if canaccessvalue(playerMap) and playerMap == map and Query(nil, "YELL") then scan.shared = true end
		local peers, seen, add = CollectNearbyPeers();
		StartBridgeScan(scan, packet, peers);
		local slot, count, getMember = GetOOCRoster();
		scan.rosterMatches, scan.rosterRead, scan.probes = 0, 0, 0;
		local rosterPeers, rosterCandidates = {}, {};
		local index, candidatesReady = 1, false;
		local function FinishRoster(known)
			if not slot then
				candidatesReady = true;
				return;
			end
			local function ReadRoster(first)
				if not IsScanActive(scan) then return end
				local last = math.min(first + RosterBatchSize - 1, count);
				for member = first, last do
					local ok, name = pcall(getMember, slot, member);
					if ok and canaccessvalue(name) and type(name) == "string" and name ~= "" then
						scan.rosterRead = scan.rosterRead + 1;
						local peer = NormalizePeer(name);
						if peer and known[peer] and not seen[peer] and peer ~= TRP3_API.globals.player_id and
							not TRP3_API.register.isIDIgnored(peer) then
							seen[peer] = true;
							rosterPeers[#rosterPeers + 1] = peer;
							rosterCandidates[peer] = true;
						end
					end
				end
				if last < count then
					C_Timer.After(0, function() ReadRoster(last + 1) end);
				else
					table.sort(rosterPeers);
					local start = 1;
					while rosterPeers[start] and rosterCursor and rosterPeers[start] <= rosterCursor do
						start = start + 1;
					end
					-- Leave room for roster matches after nearby contacts. An
					-- insertion must never move already-processed candidates.
					local insertAt = math.min(#peers + 1, math.max(index, 9));
					local reserved = MaxDirectProbes - 8;
					for offset = 0, math.min(#rosterPeers, reserved) - 1 do
						table.insert(peers, insertAt + offset, rosterPeers[(start + offset - 1) % #rosterPeers + 1]);
					end
					scan.rosterMatches = #rosterPeers;
					candidatesReady = true;
				end
			end
			ReadRoster(1);
		end
		ReadKnownProfiles(scan, slot ~= nil, add, FinishRoster);

		local function Probe()
			if not IsScanActive(scan) then return end
			while peers[index] and scan.replied[peers[index]] do index = index + 1 end
			local peer = peers[index];
			if peer then
				scan.probes = scan.probes + 1;
				if rosterCandidates[peer] then rosterCursor = peer end
				if Query(peer) then scan.requested[peer] = true end
				index = index + 1;
			end
			if scan.probes < MaxDirectProbes and (peers[index] or not candidatesReady) then C_Timer.After(0.65, Probe) end
		end
		Probe();
	end

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
		local bridge = StoryveilProfileBridge;
		if bridge and bridge.supportsTRP3Map then
			bridge.OnTRP3MapLocation = function(self, route, packet, reply)
				if not self.settings.crossRealm then return end
				local routeKey = self:RouteKey(route);
				-- A reply to Storyveil's own scan belongs to its handler.
				local nonce = packet:match("^R|([%d%-]+)|");
				if nonce and (not activeScan or not activeScan.bridgeRequested or
					nonce ~= activeScan.nonce or not activeScan.bridgeRequested[routeKey]) then return end
				OnLocationMessage(nil, nil, Prefix, packet, route.channel, route.name, routeKey, reply);
				return true;
			end;
		end
		registerConfigKey(ShareKey, true);
		table.insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = L.FOREVER_MAP_CONFIG_SHARE,
			help = L.FOREVER_MAP_CONFIG_SHARE_HELP,
			configKey = ShareKey,
			dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
		});
		C_ChatInfo.RegisterAddonMessagePrefix(Prefix);
		local listener = CreateFrame("Frame");
		listener:RegisterEvent("CHAT_MSG_ADDON");
		listener:RegisterEvent("PLAYER_REGEN_DISABLED");
		listener:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_REGEN_DISABLED" then
				CancelScan();
			else
				OnLocationMessage(self, event, ...);
			end
		end);
		-- Cancel immediately so returning to the map cannot revive queued work.
		hooksecurefunc(TRP3_API.MapDataProvider, "OnMapChanged", CancelScan);

		TRP3_API.slash.registerCommand({
			id = "svmap",
			helpLine = L.FOREVER_MAP_COMMAND_HELP,
			handler = function(...)
				local input = string.trim(string.join(" ", ...));
				local sharing = input:lower();
				if sharing == "status" then
					if lastScan then ReportForeverMapScan()
					else SendSystemMessage(L.FOREVER_MAP_STATUS_NO_SCAN) end
					for _, transport in ipairs({"bridge", "direct"}) do
						local incoming = lastIncoming[transport];
						local label = transport == "bridge" and L.FOREVER_MAP_STATUS_BRIDGE or L.FOREVER_MAP_STATUS_DIRECT;
						if incoming then
							SendSystemMessage(L.FOREVER_MAP_STATUS_INCOMING:format(
								label, incoming.map, incoming.result or L.FOREVER_MAP_STATUS_PROCESSING));
						else
							SendSystemMessage(L.FOREVER_MAP_STATUS_NO_INCOMING:format(label));
						end
					end
					return;
				end
				if sharing == "share on" or sharing == "share off" then
					TRP3_API.configuration.setValue(ShareKey, sharing == "share on");
					SendSystemMessage(sharing == "share on" and L.FOREVER_MAP_SHARING_ENABLED or L.FOREVER_MAP_SHARING_DISABLED);
					return;
				end
				if InCombatLockdown() then return end
				local peer = NormalizePeer(input);
				local mapID = Map.getDisplayedMapID();
				if not peer or peer == TRP3_API.globals.player_id or TRP3_API.register.isIDIgnored(peer) or
					not WorldMapFrame:IsShown() or not canaccessvalue(mapID) or type(mapID) ~= "number" or mapID <= 0 then
					SendSystemMessage(L.FOREVER_MAP_COMMAND_DESTINATION);
					return;
				end
				local now = GetTime();
				if activeScan and now < activeScan.deadline then
					SendSystemMessage(L.FOREVER_MAP_COMMAND_BUSY);
					return;
				end
				serial = serial + 1;
				local nonce = ("%d-%d"):format(math.floor(now * 1000), serial);
				local scan = {peer = peer, map = mapID, nonce = nonce, deadline = now + ScanWindow, replied = {},
					sent = 0, attempted = 1, received = 0, shown = 0};
				activeScan, lastScan = scan, scan;
				if not Send(peer, ("Q|%s|%d"):format(nonce, mapID), nil, true) then
					activeScan = nil;
					SendSystemMessage(L.FOREVER_MAP_COMMAND_REJECTED);
					return;
				end
				scan.sent = 1;
				SendSystemMessage(L.FOREVER_MAP_COMMAND_SENT:format(peer));
				C_Timer.After(ScanWindow, function()
					if activeScan ~= scan then return end
					activeScan = nil;
					SendSystemMessage(L.FOREVER_MAP_COMMAND_NO_REPLY);
				end);
			end,
		});
	end);
end
