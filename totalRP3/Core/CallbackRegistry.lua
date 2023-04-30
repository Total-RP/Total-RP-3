-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- This module provides a set of convenience wrappers and utilities around
-- callback registries backed by the CallbackHandler library.

local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0");

-- Callback registration objects are prebaked closures associated with a
-- registry that can be toggled on-demand.
--
-- The callback function will be invoked with the supplied owner as the first
-- parameter, followed by the bound parameter pack, and then event arguments.
--
-- If no owner is supplied it will default to the callback registration object
-- itself. This permits the executed callback to have access to the registration
-- object if it wishes to unregister itself.

local CallbackRegistration = {};

function CallbackRegistration:__init(registry, event, callback, owner, ...)
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

function CallbackRegistration:Register()
	self.registry.RegisterCallback(self.owner, self.event, self.closure);
end

function CallbackRegistration:Unregister()
	self.registry.UnregisterCallback(self.owner, self.event);
end

function TRP3_API.CreateCallbackRegistration(registry, event, callback, owner, ...)
	return TRP3_API.CreateAndInitFromPrototype(CallbackRegistration, registry, event, callback, owner, ...);
end

function TRP3_API.IsEventValid(registry, event)
	if registry.IsEventValid then
		return registry:IsEventValid(event);
	else
		return true;  -- This registry does not validate events.
	end
end

function TRP3_API.RegisterCallback(registry, event, callback, owner, ...)
	local registration = TRP3_API.CreateCallbackRegistration(registry, event, callback, owner, ...);
	registration:Register();
	return registration;
end

-- Callback groups provide a mechanism for toggling a collection of registrables
-- on-demand. The concept of a "registrable" is anything that provides a pair
-- of parameterless "Register" and "Unregister" methods.

local CallbackGroup = {};

function CallbackGroup:__init()
	self.registrables = {};
end

function CallbackGroup:AddCallback(registry, event, callback, owner, ...)
	local registration = TRP3_API.CreateCallbackRegistration(registry, event, callback, owner, ...);
	table.insert(self.registrables, registration);
end

function CallbackGroup:RegisterCallback(registry, event, callback, owner, ...)
	local registration = TRP3_API.RegisterCallback(registry, event, callback, owner, ...);
	table.insert(self.registrables, registration);
end

function CallbackGroup:AddRegistrable(registration)
	table.insert(self.registrables, registration);
end

function CallbackGroup:Clear()
	self.registrables = {};
end

function CallbackGroup:EnumerateIndexedRegistrables()
	return ipairs(self.registrables);
end

function CallbackGroup:Register()
	for _, registrable in ipairs(self.registrables) do
		registrable:Register();
	end
end

function CallbackGroup:Unregister()
	for _, registrable in ipairs(self.registrables) do
		registrable:Unregister();
	end
end

function TRP3_API.CreateCallbackGroup()
	return TRP3_API.CreateAndInitFromPrototype(CallbackGroup);
end

-- Callback group collections are a convenience wrapper for managing a keyed
-- set of callback groups. Callbacks can be added to a child group with a
-- user-defined group "key", and the groups later mass-toggled or individually
-- manipulated as needed.

local CallbackGroupCollection = {};

function CallbackGroupCollection:__init()
	self.groups = {};
end

function CallbackGroupCollection:AddCallback(key, registry, event, callback, owner, ...)
	local group = self:GetOrCreateGroup(key);
	group:AddCallback(registry, event, callback, owner, ...);
end

function CallbackGroupCollection:RegisterCallback(key, registry, event, callback, owner, ...)
	local group = self:GetOrCreateGroup(key);
	group:RegisterCallback(registry, event, callback, owner, ...);
end

function CallbackGroupCollection:AddRegistrable(key, registrable)
	local group = self:GetOrCreateGroup(key);
	group:AddRegistrable(registrable);
end

function CallbackGroupCollection:AddGroup(key, group)
	assert(not self.groups[key], "attempted to add a duplicate callback group");
	self.groups[key] = group;
end

function CallbackGroupCollection:CreateGroup(key)
	assert(not self.groups[key], "attempted to create a duplicate callback group");

	local group = TRP3_API.CreateCallbackGroup();
	self.groups[key] = group;
	return group;
end

function CallbackGroupCollection:EnumerateKeyedGroups()
	return pairs(self.groups);
end

function CallbackGroupCollection:GetGroup(key)
	return self.groups[key];
end

function CallbackGroupCollection:GetOrCreateGroup(key)
	return self.groups[key] or self:CreateGroup(key);
end

function CallbackGroupCollection:Clear()
	self.groups = {};
end

function CallbackGroupCollection:ClearGroup(key)
	local group = assert(self.groups[key], "attempted to clear a non-existent callback group");
	group:clear();
end

function CallbackGroupCollection:Register()
	for _, group in pairs(self.groups) do
		group:Register();
	end
end

function CallbackGroupCollection:RegisterGroup(key)
	local group = assert(self.groups[key], "attempted to register a non-existent callback group");
	group:Register();
end

function CallbackGroupCollection:Unregister()
	for _, group in pairs(self.groups) do
		group:Unregister();
	end
end

function CallbackGroupCollection:UnregisterGroup(key)
	local group = assert(self.groups[key], "attempted to unregister a non-existent callback group");
	group:Unregister();
end

function TRP3_API.CreateCallbackGroupCollection()
	return TRP3_API.CreateAndInitFromPrototype(CallbackGroupCollection);
end

-- The below convenience utilities are for initializing callback callbacks
-- support on existing objects.
--
-- The supplied registry object will gain the following functions from the
-- CallbackHandler library:
--
--    function registry.RegisterCallback(owner, event[, func, ...]) end
--    function registry.UnregisterCallback(owner, event) end
--    function registry.UnregisterAllCallbacks(owner) end
--
-- Note that these must be called with "." syntax. This is handled for you
-- automatically if you use the 'TRP3_API.RegisterCallback' utility API or the
-- CallbackRegistration prototype.
--
-- Registries may additionally provide any of the following optional methods
-- which will be used if present.
--
--   function registry.OnEventUsed(event) end
--   function registry.OnEventUnused(event) end
--   function registry.IsEventValid(event) end
--
-- OnEventUsed and OnEventUnused will be called when any event in the registry
-- transitions from zero to one registered callback, or from one to zero.
--
-- IsEventValid will be checked if present prior to creation of callback
-- registrations; if the function returns false an error will be raised and
-- the registration will not be permitted. Note that this function is assumed
-- to have static behavior; for any queried event the function must always
-- return the same boolean value.
--
-- The InitCallbackRegistry function family will return the inner callback
-- table, through which callbacks can be invoked by calling
-- `callbacks:Fire(event, ...)`.

local function OnCallbackEventUsed(_, registry, event)
	if registry.OnEventUsed then
		registry:OnEventUsed(event);
	end
end

local function OnCallbackEventUnused(_, registry, event)
	if registry.OnEventUnused then
		registry:OnEventUnused(event);
	end
end

function TRP3_API.InitCallbackRegistry(registry)
	local RegisterCallback = "RegisterCallback";
	local UnregisterCallback = "UnregisterCallback";
	local UnregisterAllCallbacks = "UnregisterAllCallbacks";

	local callbacks = CallbackHandler:New(registry, RegisterCallback, UnregisterCallback, UnregisterAllCallbacks);
	callbacks.OnUsed = OnCallbackEventUsed;
	callbacks.OnUnused = OnCallbackEventUnused;

	return callbacks;
end

function TRP3_API.InitCallbackRegistryWithEvents(registry, events)
	local callbacks = TRP3_API.InitCallbackRegistry(registry);
	TRP3_API.AddCallbackEventTableValidator(registry, events);
	return callbacks;
end

function TRP3_API.AddCallbackEventValidator(registry, validator)
	local super = registry.IsEventValid or nop;

	local function IsEventValid(self, event)
		return validator(self, event) or super(self, event);
	end

	registry.IsEventValid = IsEventValid;
end

function TRP3_API.AddCallbackEventTableValidator(registry, events)
	local function IsEventValid(self, event)
		return events[event] ~= nil;
	end

	TRP3_API.AddCallbackEventValidator(registry, IsEventValid);
end

-- Standalone callback registries can be created through the following functions
-- for more local convenience.

local CallbackRegistry = {};

function CallbackRegistry:__init()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
end

function CallbackRegistry:TriggerEvent(event, ...)
	assert(TRP3_API.IsEventValid(self, event), "attempted to trigger an invalid callback event");
	self.callbacks:Fire(event, ...);
end

function TRP3_API.CreateCallbackRegistry()
	return TRP3_API.CreateAndInitFromPrototype(CallbackRegistry);
end

function TRP3_API.CreateCallbackRegistryWithEvents(events)
	local registry = TRP3_API.CreateCallbackRegistry();
	TRP3_API.AddCallbackEventTableValidator(registry, events);
	return registry;
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
