-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(_);
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- imports
local GetChannelRosterInfo = GetChannelRosterInfo;
local GetChannelDisplayInfo = GetChannelDisplayInfo;
local GetChannelName = GetChannelName;
local JoinChannelByName = JoinChannelByName;
local RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix;
local wipe, string, pairs, strsplit, assert, tinsert, type, tostring = wipe, string, pairs, strsplit, assert, tinsert, type, tostring;
local Chomp = AddOn_Chomp;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Log = Utils.log;
local Comm, isIDIgnored = AddOn_TotalRP3.Communications, nil;
local unitIDToInfo = Utils.str.unitIDToInfo;
local getConfigValue = TRP3_API.configuration.getValue;
local loc = TRP3_API.loc;

Comm.broadcast = {};
local ticker;

local function config_UseBroadcast()
	return getConfigValue(TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS);
end

local function config_BroadcastChannel()
	return getConfigValue(TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Communication protocol
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Comm.broadcast.HELLO_CMD = "TRP3HI";
local HELLO_CMD = Comm.broadcast.HELLO_CMD;

local helloWorlded = false;
local PREFIX_REGISTRATION, PREFIX_P2P_REGISTRATION = {}, {};
local BROADCAST_PREFIX = "RPB";
local BROADCAST_VERSION = 1;
local BROADCAST_SEPARATOR = "~";
local BROADCAST_HEADER = BROADCAST_PREFIX .. BROADCAST_VERSION;
Comm.totalBroadcast = 0;
Comm.totalBroadcastP2P = 0;
Comm.totalBroadcastR = 0;
Comm.totalBroadcastP2PR = 0;

local function broadcast(command, ...)
	if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel and not config_UseBroadcast() or not command then
		Log.log("Bad params");
		return;
	end
	if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel and not helloWorlded and command ~= HELLO_CMD then
		Log.log("Broadcast channel not yet initialized.");
		return;
	end
	local message = BROADCAST_HEADER .. BROADCAST_SEPARATOR .. command;
	for _, arg in pairs({...}) do
		arg = tostring(arg);
		if arg:find(BROADCAST_SEPARATOR) then
			Log.log("Trying a broadcast with a arg containing the separator character. Abord !", Log.level.WARNING);
			return;
		end
		message = message .. BROADCAST_SEPARATOR .. arg;
	end
	if message:len() < 254 then
		if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Yell then
			Chomp.SendAddonMessage(BROADCAST_HEADER, message, "YELL");
		elseif TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel then
			local channelName = GetChannelName(config_BroadcastChannel());
			Chomp.SendAddonMessage(BROADCAST_HEADER, message, "CHANNEL", channelName);
		else
			error("Unknown broadcast method for this client");
		end
		Comm.totalBroadcast = Comm.totalBroadcast + BROADCAST_HEADER:len() + message:len();
	else
		Log.log(("Trying a broadcast with a message with lenght %s. Abord !"):format(message:len()), Log.level.WARNING);
	end
end
Comm.broadcast.broadcast = broadcast;

local function onBroadcastReceived(message, sender)
	local header, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
	if not header == BROADCAST_HEADER or not command then
		return; -- If not RP protocol or don't have a command
	end
	Comm.totalBroadcastR = Comm.totalBroadcastR + BROADCAST_HEADER:len() + message:len();
	for _, callback in pairs(PREFIX_REGISTRATION[command] or Globals.empty) do
		callback(sender, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
	end
end

-- Register a function to callback when receiving args to a certain command
function Comm.broadcast.registerCommand(command, callback)
	assert(command and callback and type(callback) == "function", "Usage: command, callback");
	if PREFIX_REGISTRATION[command] == nil then
		PREFIX_REGISTRATION[command] = {};
	end
	tinsert(PREFIX_REGISTRATION[command], callback);
end

local SetChannelPasswordOld = SetChannelPassword;
if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel then
	SetChannelPassword = function(data, password)
		local _, channelName = GetChannelName(data);
		if channelName ~= config_BroadcastChannel() or password == "" then
			SetChannelPasswordOld(data, password);
		else
			-- We totally changed it :fatcat:
			local message = loc.BROADCAST_PASSWORD:format(data);
			Utils.message.displayMessage(message);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peer to peer part
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onP2PMessageReceived(message, sender)
	Comm.totalBroadcastP2PR = Comm.totalBroadcastP2PR + BROADCAST_HEADER:len() + message:len();
	local command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
	if PREFIX_P2P_REGISTRATION[command] then
		for _, callback in pairs(PREFIX_P2P_REGISTRATION[command]) do
			callback(sender, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
		end
	end
end

-- Register a function to callback when receiving args to a certain command
function Comm.broadcast.registerP2PCommand(command, callback)
	assert(command and callback and type(callback) == "function", "Usage: command, callback");
	if PREFIX_P2P_REGISTRATION[command] == nil then
		PREFIX_P2P_REGISTRATION[command] = {};
	end
	tinsert(PREFIX_P2P_REGISTRATION[command], callback);
end

local function sendP2PMessage(target, command, ...)
	local message = command;
	for _, arg in pairs({...}) do
		arg = tostring(arg);
		if arg:find(BROADCAST_SEPARATOR) then
			Log.log("Trying a broadcast with a arg containing the separator character. Abord !", Log.level.WARNING);
			return;
		end
		message = message .. BROADCAST_SEPARATOR .. arg;
	end
	if message:len() < 254 then
		Chomp.SendAddonMessage(BROADCAST_HEADER, message, "WHISPER", target);
		Comm.totalBroadcastP2P = Comm.totalBroadcastP2P + BROADCAST_HEADER:len() + message:len();
	else
		Log.log(("Trying a P2P message with a message with lenght %s. Abord !"):format(message:len()), Log.level.WARNING);
	end
end
Comm.broadcast.sendP2PMessage = sendP2PMessage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Players connexions listener
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local connectedPlayers = {};

Comm.broadcast.isPlayerBroadcastable = function(playerName)
	return connectedPlayers[playerName] ~= nil;
end

Comm.broadcast.getPlayers = function()
	return connectedPlayers;
end

Comm.broadcast.resetPlayers = function()
	if not config_UseBroadcast() then
		return nil;
	end
	local channelName;
	wipe(connectedPlayers);
	for i=1, MAX_CHANNEL_BUTTONS, 1 do
		channelName = GetChannelDisplayInfo(i);
		if channelName == config_BroadcastChannel() then
			local j = 1;
			while GetChannelRosterInfo(i, j) do
				local playerName = GetChannelRosterInfo(i, j);
				connectedPlayers[playerName] = 1;
				j = j + 1;
			end
			break;
		end
	end
	return connectedPlayers;
end

local function onChannelJoin(_, arg2, _, _, _, _, _, _, arg9)
	if config_UseBroadcast() and arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = 1;
	end
end

local function onChannelLeave(_, arg2, _, _, _, _, _, _, arg9)
	if config_UseBroadcast() and arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = nil;
	end
end

local function onMessageReceived(...)
	local prefix, message , distributionType, sender, _, _, _, channel = ...;

	if not sender then
		return;
	end

	if prefix == BROADCAST_HEADER then

		if not sender:find('-') then
			sender = Utils.str.unitInfoToID(sender);
		end

		if not isIDIgnored(sender) then
			-- Have to test "UNKNOWN" for "YELL" addon messages because Blizzard lul
			if distributionType == "YELL" or distributionType == "UNKNOWN" or distributionType == "CHANNEL" and string.lower(channel) == string.lower(config_BroadcastChannel()) then
				onBroadcastReceived(message, sender, channel);
			else
				onP2PMessageReceived(message, sender);
			end
		end

	end
end

--- Makes sure the broadcast channel is hidden from the chat frame.
--- Some add-ons are still sending chat messages instead of add-on message on the channel, so it's best for
--- the user if we hide the channel so they never have to see add-on generated text messages.
local function hideBroadcastChannelFromChatFrame()
	local chatFrame = FCF_GetCurrentChatFrame();
	if not chatFrame then return end -- In some instances we cannot get a chat frame (Details!?!?)

	local broadcastChannelName = config_BroadcastChannel();
	for index, value in pairs(chatFrame.channelList) do
		if strupper(broadcastChannelName) == strupper(value) then
			chatFrame.channelList[index] = nil;
			chatFrame.zoneChannelList[index] = nil;
		end
	end

	RemoveChatWindowChannel(chatFrame:GetID(), broadcastChannelName);
end

--- Swap channels by index, without losing the color association on Retail.
local swapChannelsByIndex = ChatConfigChannelSettings_SwapChannelsByIndex or C_ChatInfo.SwapChatChannelsByChannelIndex;

--- Makes sure the broadcast channel is always at the bottom of list.
--- This is so the user always have the channels they actually use first and that the broadcast channel
--- is never taking the General or Trade chat position.
local function moveBroadcastChannelToTheBottomOfTheList(forceMove)
	if getConfigValue(TRP3_API.ADVANCED_SETTINGS_KEYS.MAKE_SURE_BROADCAST_CHANNEL_IS_LAST) and (forceMove or helloWorlded) then
		local broadcastChannelIndex = GetChannelName(config_BroadcastChannel());
		if broadcastChannelIndex == nil then return end

		-- Get the index of the last channel
		local lastChannelIndex = 0;
		for index = broadcastChannelIndex, MAX_WOW_CHAT_CHANNELS do
			local shortcut = C_ChatInfo.GetChannelShortcut(index);
			if shortcut and shortcut ~= "" then
				lastChannelIndex = index;
			end
		end

		-- No need to move, the broadcast channel is already the last one
		if broadcastChannelIndex == lastChannelIndex then
			return;
		end

		-- Bubble the broadcast channel up to the last position
		for index = broadcastChannelIndex, lastChannelIndex - 1 do
			swapChannelsByIndex(index, index + 1);
		end
		Log.log("Moved broadcast channel from position " .. broadcastChannelIndex .. " to " .. lastChannelIndex .. ".");

		hideBroadcastChannelFromChatFrame();
	end
end

--- Return true if the channel list is ready for the broadcast channel to join.
-- @return isReady (boolean)
local function isChannelListReady()
	-- The channel list is empty
	if select("#", GetChannelList()) == 0 then
		return false;
	end

	-- Find gaps in the channel list
	local hasGaps = false;
	local previousIndex = 0;
	for index = 1, MAX_WOW_CHAT_CHANNELS do
		local shortcut = C_ChatInfo.GetChannelShortcut(index);
		if shortcut and shortcut ~= "" then
			if index ~= previousIndex + 1 then
				hasGaps = true;
				break;
			end
			previousIndex = index;
		end
	end

	-- Consider the channel list is ready if there is no gap
	return not hasGaps;
end

if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel then
	Ellyb.GameEvents.registerCallback("CHANNEL_UI_UPDATE", moveBroadcastChannelToTheBottomOfTheList);
	Ellyb.GameEvents.registerCallback("CHANNEL_COUNT_UPDATE", moveBroadcastChannelToTheBottomOfTheList);
	Ellyb.GameEvents.registerCallback("CHAT_MSG_CHANNEL_JOIN", moveBroadcastChannelToTheBottomOfTheList);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init and helloWorld
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Comm.broadcast.init = function()
	isIDIgnored = TRP3_API.register.isIDIgnored;

	-- First, register prefix
	RegisterAddonMessagePrefix(BROADCAST_HEADER);

	-- When we receive a broadcast or a P2P response
	Utils.event.registerHandler("CHAT_MSG_ADDON", onMessageReceived);

	-- No broadcast channel on Classic or BCC
	if TRP3_ClientFeatures.BroadcastMethod ~= TRP3_BroadcastMethod.Channel then
		TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_READY);
		return
	end

	-- Then, launch the loop
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		if config_UseBroadcast() then
			-- We'll send out the event nice and early to say we're setting up.
			TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_CONNECTING);

			-- Force joining the broadcast channel if we wait too long.
			local forceJoinChannel = false;
			C_Timer.After(10, function() forceJoinChannel = true end);

			local firstTime = true;
			ticker = C_Timer.NewTicker(1, function(_)
				if firstTime then firstTime = false; return; end
				if GetChannelName(string.lower(config_BroadcastChannel())) == 0 then
					if forceJoinChannel or isChannelListReady() then
						Log.log("Step 1: Try to connect to broadcast channel: " .. config_BroadcastChannel());
						JoinChannelByName(string.lower(config_BroadcastChannel()));
					end
				else
					Log.log("Step 2: Connected to broadcast channel: " .. config_BroadcastChannel() .. ". Now sending HELLO command.");
					moveBroadcastChannelToTheBottomOfTheList(true);
					if not helloWorlded then
						broadcast(HELLO_CMD, Globals.version, Globals.version_display, Globals.extended_version, Globals.extended_display_version);
					end
				end
			end, 15);
		else
			-- Broadcast isn't enabled so we should probably say it's offline.
			TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_OFFLINE, loc.BROADCAST_OFFLINE_DISABLED);
		end
	end);

	-- When someone placed a password on the channel
	Utils.event.registerHandler("CHANNEL_PASSWORD_REQUEST", function(channel)
		if channel == config_BroadcastChannel() then
			Log.log("Passworded !");

			local message = loc.BROADCAST_PASSWORD:format(channel);
			Utils.message.displayMessage(message);
			ticker:Cancel();

			-- Notify that it's unlikely broadcast will work due to the password.
			TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_OFFLINE, message);
		end
	end);

	if TRP3_ClientFeatures.BroadcastMethod == TRP3_BroadcastMethod.Channel then
		-- For when someone just places a password
		Utils.event.registerHandler("CHAT_MSG_CHANNEL_NOTICE_USER", function(mode, user, _, _, _, _, _, _, channel)
			if mode == "OWNER_CHANGED" and user == TRP3_API.globals.player_id and channel == config_BroadcastChannel() then
				SetChannelPasswordOld(config_BroadcastChannel(), "");
			end
		end);
	end

	-- When you are already in 10 channel
	Utils.event.registerHandler("CHAT_MSG_SYSTEM", function(message)
		if config_UseBroadcast() and message == ERR_TOO_MANY_CHAT_CHANNELS and not helloWorlded then
			Utils.message.displayMessage(loc.BROADCAST_10);
			ticker:Cancel();

			-- Notify that broadcast won't work due to the channel limit.
			TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_OFFLINE, message);
		end
	end);

	-- For stats
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_JOIN", onChannelJoin);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_LEAVE", onChannelLeave);

	-- We register our own HELLO msg so that when it happens we know we are capable of sending and receive on the channel.
	Comm.broadcast.registerCommand(HELLO_CMD, function(sender, _)
		if sender == Globals.player_id then
			Log.log("Step 3: HELLO command sent and parsed. Broadcast channel initialized.");
			helloWorlded = true;
			ticker:Cancel();

			-- Notify our other bits and pieces that we're all good to go.
			TRP3_API.events.fireEvent(TRP3_API.events.BROADCAST_CHANNEL_READY);
		end
	end);
end
