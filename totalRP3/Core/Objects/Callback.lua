-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Callback objects are prebaked closures associated with a registry that can
-- be toggled on-demand.
--
-- The callback function will be invoked with the supplied owner as the first
-- parameter, followed by the bound parameter pack, and then event arguments.
--
-- If no owner is supplied it will default to the callback registration object
-- itself. This permits the executed callback to have access to the registration
-- object if it wishes to unregister itself.

local Callback = {};

function Callback:__init(registry, event, callback, owner, ...)
	assert(TRP3_API.IsEventValid(registry, event), "attempted to create a registration for an invalid callback event");

	if callback == nil then
		callback = event;
	end

	if owner == nil then
		owner = self;
	end

	self.registry = registry;
	self.event = event;
	self.owner = owner;
	self.closure = TRP3_API.GenerateCallbackClosure(callback, owner, ...);
end

function Callback:Invoke(...)
	securecallfunction(self.closure, ...);
end

function Callback:Register()
	self.registry.RegisterCallback(self.owner, self.event, self.closure);
end

function Callback:Unregister()
	self.registry.UnregisterCallback(self.owner, self.event);
end

function TRP3_API.CreateCallback(registry, event, callback, owner, ...)
	return TRP3_API.CreateAndInitFromPrototype(Callback, registry, event, callback, owner, ...);
end

function TRP3_API.IsEventValid(registry, event)
	if registry.IsEventValid then
		return registry:IsEventValid(event);
	else
		return true;  -- This registry does not validate events.
	end
end

function TRP3_API.RegisterCallback(registry, event, callback, owner, ...)
	local registration = TRP3_API.CreateCallback(registry, event, callback, owner, ...);
	registration:Register();
	return registration;
end

function TRP3_API.UnregisterCallback(registry, event, owner)
	registry.UnregisterCallback(owner, event);
end

function TRP3_API.UnregisterAllCallbacks(registry, owner)
	registry.UnregisterAllCallbacks(owner);
end

-- Callbacks registered through our utilities are packed into fully bound and
-- optimized closures with support for multiple bound parameters as well as
-- the late-binding through string-based method names.
--
-- All closures strip the first parameter (event name) from the argument list
-- to more closely match Blizzards' behavior.
--
-- For the 'CallbackMethodClosureFactories' list the first closure generator
-- is a bit special; if GenerateCallbackClosure is called with solely a string
-- method name and no other parameters it will generate a closure that invokes
-- the named method on the first non-event parameter supplied to the closure.

local CallbackClosureFactories =
{
	function(f) return function(_, ...) return f(...); end; end,
	function(f, a) return function(_, ...) return f(a, ...); end; end,
	function(f, a, b) return function(_, ...) return f(a, b, ...); end end,
	function(f, a, b, c) return function(_, ...) return f(a, b, c, ...); end end,
	function(f, a, b, c, d) return function(_, ...) return f(a, b, c, d, ...); end end,
	function(f, a, b, c, d, e) return function(_, ...) return f(a, b, c, d, e, ...); end end,
};

local CallbackMethodClosureFactories =
{
	function(m) return function(_, o, ...) return o[m](o, ...); end; end,
	function(m, o) return function(_, ...) return o[m](o, ...); end; end,
	function(m, o, a) return function(_, ...) return o[m](a, ...); end; end,
	function(m, o, a, b) return function(_, ...) return o[m](o, a, b, ...); end; end,
	function(m, o, a, b, c) return function(_, ...) return o[m](o, a, b, c, ...); end; end,
	function(m, o, a, b, c, d) return function(_, ...) return o[m](o, a, b, c, d, ...); end; end,
};

function TRP3_API.GenerateCallbackClosure(callback, ...)
	local factories;

	if type(callback) == "string" then
		factories = CallbackMethodClosureFactories;
	else
		factories = CallbackClosureFactories;
	end

	local nparams = select("#", ...);
	local factory = assert(factories[nparams + 1], "attempted to bind an unsupported number of parameters");

	return factory(callback, ...);
end
