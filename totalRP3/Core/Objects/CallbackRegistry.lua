-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0");

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
-- Callback prototype.
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

	TRP3_DebugUtil.AddToEventTraceWindow(callbacks);

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
	-- The 'events' table may either be an array of event names or a key/value
	-- mapping where the value represents the event name.

	events = tInvert(events);

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
	return TRP3_API.CreateObject(CallbackRegistry);
end

function TRP3_API.CreateCallbackRegistryWithEvents(events)
	local registry = TRP3_API.CreateCallbackRegistry();
	TRP3_API.AddCallbackEventTableValidator(registry, events);
	return registry;
end
