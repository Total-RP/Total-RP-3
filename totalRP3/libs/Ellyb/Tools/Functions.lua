---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Functions then
	return
end

local Functions = {};
Ellyb.Functions = Functions;

--- Binds a given function to a value, returning a closure will call the
--- original function with the given value as the first argument, and
--- all arguments to the closure after it.
---
--- This is super useful for cases where you want to invoke an object method
--- but are being asked for a naked callback.
---
--- @param fn function The function to wrap.
--- @param value any The value to be supplied to fn as the first argument.
function Functions.bind(fn, value)
	return function(...) return fn(value, ...); end
end
