---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Events then
	return
end

-- Ellyb imports
local Logger = Ellyb.Logger("Events");
---@class EventsDispatcher : Object
--- Used for listening to NON game events and firing callbacks
local EventsDispatcher = Ellyb.Class("EventsDispatcher");
Ellyb.EventsDispatcher = EventsDispatcher;

---@type {callbackRegistry: function[][] }[]
local private = Ellyb.getPrivateStorage();

local LOG_EVENT_REGISTERED = [[Registered new callback for event "%s" with handler ID "%s".]];
local LOG_EVENT_UNREGISTERED = [[Registered event callback with handler ID "%s" for event "%s".]];

function EventsDispatcher:initialize()
	private[self].callbackRegistry = {};
	Logger:Info("Initialized new EventDispatcher")
end

--- Register a callback that we want to be called when the given event is fired.
---@param event string The event we want to listen to
---@param callback function A callback that will be called when the event is fired. Will receive the arguments passed when firing the event.
---@param handlerID string An optional handler ID to re-use, for cases where we register a callback for more than one event
---@return string Handler ID, either the one that was given or a generated one
---@overload fun(event:string, callback: function):string
function EventsDispatcher:RegisterCallback(event, callback, handlerID)
	Ellyb.Assertions.isType(event, "string", "event")
	Ellyb.Assertions.isType(callback, "function", "callback");

	if not private[self].callbackRegistry[event] then
		private[self].callbackRegistry[event] = {};
	end

	if handlerID ~= nil then
		Ellyb.Assertions.isType(handlerID, "string", "handlerID");
	else
		handlerID = Ellyb.Strings.generateUniqueID(private[self].callbackRegistry[event]);
	end
	private[self].callbackRegistry[event][handlerID] = callback;

	Logger:Info(LOG_EVENT_REGISTERED:format(event, handlerID));

	return handlerID;
end

--- Unregister a callback using its generated handler ID.
--- If the callback was registered with that ID to more than one event, all events registered with this ID will be unregistered.
---@param handlerID string The handler ID for the callback we want to unregister.
function EventsDispatcher:UnregisterCallback(handlerID)
	Ellyb.Assertions.isType(handlerID, "string", "handlerID");

	for eventName, eventRegistry in pairs(private[self].callbackRegistry) do
		if eventRegistry[handlerID] then
			eventRegistry[handlerID] = nil;
			Logger:Info(LOG_EVENT_UNREGISTERED:format(handlerID, eventName));
		end
	end
end

--- Fire the given event with the given passed arguments. All callbacks will receive these arguments.
---@param event string The event we want to fire
---@vararg any Any argument we want to pass to the event's registered callback
function EventsDispatcher:TriggerEvent(event, ...)
	Ellyb.Assertions.isType(event, "string", "event")
	local registry = private[self].callbackRegistry[event];
	if registry then
		for _, callback in pairs(registry) do
			xpcall(callback, CallErrorHandler, ...);
		end
	end
end

--- Check if this EventsDispatcher has at least one callback registered for a given event
---@param event string The event we want to check
---@return boolean True if this EventsDispatcher has a callback registered for the given event
function EventsDispatcher:HasCallbacksForEvent(event)
	Ellyb.Assertions.isType(event, "string", "event")
	return not Ellyb.Tables.isEmpty(private[self].callbackRegistry[event] or {});
end
