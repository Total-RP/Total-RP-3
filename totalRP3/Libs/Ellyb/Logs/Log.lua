---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Log then
	return
end

-- Lua imports
local time = time;

---@class Log
local Log, _private = Ellyb.Class("Log");
Ellyb.Log = Log;

function Log:initialize(level, ...)
	_private[self] = {};
	_private[self].date = time();
	_private[self].level = level;
	_private[self].args = { ... };
end

function Log:GetText()
	return Ellyb.Strings.convertTableToString(_private[self].args);
end

function Log:GetLevel()
	return _private[self].level;
end

function Log:GetTimestamp()
	return _private[self].date;
end