---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.LogsManager then
	return
end

-- Lua imports
local assert = assert;
local pairs = pairs;
local print = print;
local lower = string.lower;


local LogsManager = {};
Ellyb.LogsManager = LogsManager;

---@type Logger[]
local logs = {};

---@param logger Logger
function LogsManager:RegisterLogger(logger)
	local ID = logger:GetModuleName();
	assert(not logs[ID], "A Logger for " .. ID .. " has already been registered");
	logs[lower(ID)] = logger;
end

function LogsManager.show(ID)
	assert(logs[ID], "Cannot find Logger " .. ID);
	logs[ID]:Show();
end

function LogsManager.list()
	print("Available Loggers:");
	for _, log in pairs(logs) do
		print(log:GetModuleName());
	end
end