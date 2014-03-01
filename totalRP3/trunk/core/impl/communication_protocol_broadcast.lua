--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3 Broadcast Communication protocol
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- API
local GetChannelRosterInfo = GetChannelRosterInfo;
local GetChannelDisplayInfo = GetChannelDisplayInfo;
local GetChannelName = GetChannelName;
local JoinChannelByName = JoinChannelByName;
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local tostring = tostring;
local pairs = pairs;
local assert = assert;
local string = string;
local wipe = wipe;
local tinsert = tinsert;
local type = type;
local math = math;
local ChatThrottleLib = ChatThrottleLib;
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local Log = Utils.log;
local Comm = TRP3_COMM;
local unitIDToInfo = Utils.str.unitIDToInfo;

Comm.broadcast = {};

local function config_UseBroadcast()
	return true; -- TODO: locals
end

local function config_BroadcastChannel()
	return "xtensionxtooltip2"; -- TODO: locals
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Communication protocol
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
	if arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = 1;
	end
end

local function onChannelLeave(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if arg2 and arg9 == config_BroadcastChannel() then
		local unitName = unitIDToInfo(arg2);
		connectedPlayers[unitName] = nil;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init and helloWorld
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local helloWorlded = false;

-- Send in a broadcast your main informations.
-- [1] - TRP3 version
local function helloWorld()
	if not helloWorlded then
		Log.log("helloWorld !");
		helloWorlded = true;
	end
end

local function onChannelNotice(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if arg9 == config_BroadcastChannel() and arg1 == "YOU_JOINED" then
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

Comm.broadcast.init = function()
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_NOTICE", onChannelNotice);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_JOIN", onChannelJoin);
	Utils.event.registerHandler("CHAT_MSG_CHANNEL_LEAVE", onChannelLeave);
end