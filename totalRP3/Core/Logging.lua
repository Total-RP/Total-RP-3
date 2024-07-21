-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Basic logging infrastructure
--
-- Log messages can be written via the 'Log' and 'Logf' functions and will be
-- pushed to whatever sinks are appropriate for the current environment.

local LogChatFrame;

local function WriteToDebugLogAddon(entry)
	if DLAPI then
		DLAPI.DebugLog("totalRP3", "%s", entry.message);
	end
end

local function WriteToLogChatFrame(entry)
	if not TRP3_API.globals.DEBUG_MODE then
		return;
	end

	if not LogChatFrame then
		for i = 1, NUM_CHAT_WINDOWS do
			if GetChatWindowInfo(i) == "Logs" then
				LogChatFrame = Chat_GetChatFrame(i);
				break;
			end
		end
	end

	if LogChatFrame then
		TRP3_Addon:Print(LogChatFrame, entry.message);
	end
end

local function ProcessLogMessage(message)
	local timestamp = GetTimePreciseSec();
	local entry = { message = message, timestamp = timestamp };

	WriteToLogChatFrame(entry);
	WriteToDebugLogAddon(entry);
end

local function LogBasicMessage(message, ...)
	message = string.join(" ", tostringall(message, ...));
	ProcessLogMessage(message, ...);
end

local function LogFormattedMessage(format, ...)
	local message = string.format(format, ...);
	ProcessLogMessage(message);
end

-- Logging functions internally route through a securecall barrier to ensure
-- that any errors from formatting or string conversion (__tostring) don't break
-- calling code; these are intended to be non-failable calls.

function TRP3_API.Log(message, ...)
	securecallfunction(LogBasicMessage, message, ...);
end

function TRP3_API.Logf(format, ...)
	securecallfunction(LogFormattedMessage, format, ...);
end
