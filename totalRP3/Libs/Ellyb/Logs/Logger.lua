local addOnName = ...;
---@type Ellyb
local Ellyb = Ellyb(addOnName);

if Ellyb.Logger then
	return
end

-- Lua imports
local format = string.format;
local date = date;
local print = print;

-- Ellyb imports
local Log = Ellyb.Log;

---@class Logger : Object
local Logger = Ellyb.Class("Logger");
Ellyb.Logger = Logger;

Logger.LEVELS = {
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARNING = "WARNING",
	SEVERE = "SEVERE",
}

---@return Ellyb_Color
local function GetColorForLevel(level)
	if level == Logger.LEVELS.SEVERE then
		return Ellyb.ColorManager.RED;
	elseif level == Logger.LEVELS.WARNING then
		return Ellyb.ColorManager.ORANGE;
	elseif level == Logger.LEVELS.DEBUG then
		return Ellyb.ColorManager.CYAN;
	else
		return Ellyb.ColorManager.WHITE;
	end
end

local function WriteToChatFrame(logger, level, message, ...)
	local ChatFrame;
	for i = 0, NUM_CHAT_WINDOWS do
		if GetChatWindowInfo(i) == "Logs" then
			ChatFrame = _G["ChatFrame"..i]
		end
	end

	local log = Log(level, message, ...);
	local logText = log:GetText();
	local logHeader = logger:GetLogHeader(log:GetLevel());
	local timestamp = format("[%s]", date("%X", log:GetTimestamp()));
	local message = Ellyb.ColorManager.GREY(timestamp) .. logHeader .. logText;
	if ChatFrame and log:GetLevel() ~= Logger.LEVELS.WARNING and log:GetLevel() ~= Logger.LEVELS.SEVERE then
		ChatFrame:AddMessage(message)
	else
		print(message)
	end
end

local function WriteToDebugLogAddOn(logger, level, message, ...)
	local prefix = logger:GetModuleName() .. "~";

	if level == Logger.LEVELS.WARNING then
		prefix = "WARN~" .. prefix;
	elseif level == Logger.LEVELS.SEVERE then
		prefix = "ERR~" .. prefix;
	end

    message = string.join(" ", tostringall(prefix, message, ...));
    message = string.gsub(message, "%%", "%%%%");

    DLAPI.DebugLog(addOnName, message);
end

--- Constructor
---@param moduleName string @ The name of the module initializing the Logger
function Logger:initialize(moduleName)
	self.moduleName = moduleName;

	Ellyb.LogsManager:RegisterLogger(self);
	self:Info("Logger " .. moduleName .. " initialized.");
end

---@return string moduleName @ Returns the name of the Logger's module
function Logger:GetModuleName()
	return self.moduleName;
end

local LOG_HEADER_FORMAT = "[%s - %s]: ";
function Logger:GetLogHeader(logLevel)
	local color = GetColorForLevel(logLevel);
	return format(LOG_HEADER_FORMAT, Ellyb.ColorManager.ORANGE(self:GetModuleName()), color(logLevel));
end

function Logger:Log(level, message, ...)
	if not Ellyb:IsDebugModeEnabled() then
		return;
	elseif DLAPI then
		WriteToDebugLogAddOn(self, level, message, ...);
	else
		WriteToChatFrame(self, level, message, ...);
	end
end

function Logger:Debug(...)
	self:Log(self.LEVELS.DEBUG, ...);
end

function Logger:Info(...)
	self:Log(self.LEVELS.INFO, ...);
end

function Logger:Warning(...)
	self:Log(self.LEVELS.WARNING, ...);
end

function Logger:Severe(...)
	self:Log(self.LEVELS.SEVERE, ...);
end
