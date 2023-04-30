-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Basic logging infrastructure
--
-- Log messages can be written via the 'Log' and 'Logf' functions and will be
-- pushed to whatever sinks are appropriate for the current environment.

local LogBuffer = CreateCircularBuffer(1024);
local LogChatFrame;

local function WriteToLogBuffer(entry)
	LogBuffer:PushFront(entry);
end

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

	WriteToLogBuffer(entry);
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

function TRP3_API.EnumerateLogEntries()
	-- Log entries are enumerated in order of newest to oldest.
	return LogBuffer:EnumerateIndexedEntries();
end

-- Soft errors will submit a message to the default error handler forcing the
-- current call to terminate. The use of securecallfunction here is to put the
-- client in a state whereby the error handler can use the debuglocals API to
-- provide additional context.

function TRP3_API.SoftError(message, level)
	securecallfunction(error, message, (level or 1) + 2);
end

function TRP3_API.SoftAssert(result, message, level)
	if not result then
		securecallfunction(error, message, (level or 1) + 2);
	end
end
