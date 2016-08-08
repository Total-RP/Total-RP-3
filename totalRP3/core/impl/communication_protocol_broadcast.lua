----------------------------------------------------------------------------------
-- Total RP 3
-- Broadcast communication system
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- imports
local GetChannelRosterInfo = GetChannelRosterInfo;
local GetChannelDisplayInfo = GetChannelDisplayInfo;
local GetChannelName = GetChannelName;
local JoinChannelByName = JoinChannelByName;
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local wipe, string, pairs, strsplit, assert, tinsert, type, tostring = wipe, string, pairs, strsplit, assert, tinsert, type, tostring;
local time = time;
local ChatThrottleLib = ChatThrottleLib;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Log = Utils.log;
local Comm, isIDIgnored = TRP3_API.communication, nil;
local unitIDToInfo = Utils.str.unitIDToInfo;
local getConfigValue = TRP3_API.configuration.getValue;

Comm.broadcast = {};

local function config_UseBroadcast()
	return getConfigValue("comm_broad_use");
end

local function config_BroadcastChannel()
	return getConfigValue("comm_broad_chan");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Communication protocol
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local helloWorlded = false;
local PREFIX_REGISTRATION, PREFIX_P2P_REGISTRATION = {}, {};
local BROADCAST_PREFIX = "RPB";
local BROADCAST_VERSION = 1;
local BROADCAST_SEPARATOR = "~";
local BROADCAST_HEADER = BROADCAST_PREFIX .. BROADCAST_VERSION;

local function broadcast(command, ...)
	if not config_UseBroadcast() or not command then
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
		local channelName = GetChannelName(config_BroadcastChannel());
		ChatThrottleLib:SendAddonMessage("NORMAL", BROADCAST_HEADER, message, "CHANNEL", channelName);
	else
		Log.log(("Trying a broadcast with a message with lenght %s. Abord !"):format(message:len()), Log.level.WARNING);
	end
end
Comm.broadcast.broadcast = broadcast;

local function receiveBroadcast(sender, command, ...)
	if PREFIX_REGISTRATION[command] then
		for _, callback in pairs(PREFIX_REGISTRATION[command]) do
			callback(sender, ...);
		end
	end
end

local function onBroadcastReceived(message, sender, channel)
	if not isIDIgnored(sender) and string.lower(channel) == string.lower(config_BroadcastChannel()) then
		local header, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
		if not header == BROADCAST_HEADER or not command then
			return; -- If not RP protocol or don't have a command
		end
		receiveBroadcast(sender, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peer to peer part
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onP2PMessageReceived(message, sender)
	if not sender then
		Log.log("onP2PMessageReceived: Malformed senderID: " .. tostring(sender), Log.level.WARNING);
		return;
	end
	if not sender:find('-') then
		sender = Utils.str.unitInfoToID(sender);
	end
	if not isIDIgnored(sender) then
		local command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
		if PREFIX_P2P_REGISTRATION[command] then
			for _, callback in pairs(PREFIX_P2P_REGISTRATION[command]) do
				callback(sender, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
			end
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
		ChatThrottleLib:SendAddonMessage("NORMAL", BROADCAST_HEADER, message, "WHISPER", target);
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

local function onChannelJoin(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if config_UseBroadcast() and arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = 1;
	end
end

local function onChannelLeave(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if config_UseBroadcast() and arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = nil;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init and helloWorld
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MAX_HELLO_ATTEMPT = 5;

Comm.broadcast.HELLO_CMD = "TRP3HI";
local HELLO_CMD = Comm.broadcast.HELLO_CMD;
local HELLO_COOLDOWN = 3;
local helloTimestamp;
local helloAttemptCount = 0;

-- Send in a broadcast your main informations.
-- [1] - TRP3 version
local function helloWorld()
	if not helloWorlded and (not helloTimestamp or time() - helloTimestamp > HELLO_COOLDOWN) and helloAttemptCount < MAX_HELLO_ATTEMPT then
		helloTimestamp = time();
		broadcast(HELLO_CMD, Globals.version, Globals.version_display);
		helloAttemptCount = helloAttemptCount + 1;
	end
end

local function onChannelNotice(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if config_UseBroadcast() and arg9 == config_BroadcastChannel() and arg1 == "YOU_JOINED" then
		helloWorld();
	end
end

local function onMouseOver()
	if config_UseBroadcast() then
		if GetChannelName(string.lower(config_BroadcastChannel())) == 0 then
			JoinChannelByName(string.lower(config_BroadcastChannel()));
		else
			-- Case of ReloadUI()
			helloWorld();
		end
	end
end

local function onMessageReceived(...)
	local prefix, message , distributionType, sender, _, _, _, channel = ...;
	if prefix == BROADCAST_HEADER then
		if distributionType == "CHANNEL" then
			onBroadcastReceived(message, sender, channel);
		else
			onP2PMessageReceived(message, sender);
		end
	end
end

Comm.broadcast.init = function()
	isIDIgnored = TRP3_API.register.isIDIgnored;

	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_NOTICE", onChannelNotice);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_JOIN", onChannelJoin);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_LEAVE", onChannelLeave);
	Utils.event.registerHandler("CHAT_MSG_ADDON", onMessageReceived);
	Utils.event.registerHandler("PLAYER_ENTERING_WORLD", function()
		RegisterAddonMessagePrefix(BROADCAST_HEADER);
	end);

	Comm.broadcast.registerCommand(HELLO_CMD, function(sender)
		if sender == Globals.player_id then
			Log.log("helloWorlded !");
			helloWorlded = true;
		end
	end);
end