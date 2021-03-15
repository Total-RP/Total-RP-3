---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.GameEvents then
	return
end

-- Ellyb imports
local Logger = Ellyb.Logger("GameEvents");

--- Used for listening to in-game events and firing callbacks
local GameEvents = {};
Ellyb.GameEvents = GameEvents;

local eventsDispatcher = Ellyb.EventsDispatcher();
local EventFrame = CreateFrame("FRAME");

---Register a callback for a game event
---@param event string @ A game event to listen to
---@param callback function @ A callback that will be called when the event is fired with its arguments
function GameEvents.registerCallback(event, callback, handlerID)
	Ellyb.Assertions.isType(event, "string", "event");
	Ellyb.Assertions.isType(callback, "function", "callback");

	if not EventFrame:IsEventRegistered(event) then
		EventFrame:RegisterEvent(event);
		Logger:Info(("Listening to new Game event %s."):format(tostring(event)))
	end

	return eventsDispatcher:RegisterCallback(event, callback, handlerID);
end

---Unregister a previously registered callback using the handler ID given at registration
---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister
function GameEvents.unregisterCallback(handlerID)
	Ellyb.Assertions.isType(handlerID, "string", "handlerID");

	eventsDispatcher:UnregisterCallback(handlerID);
end

local function dispatchEvent(self, event, ...)
	if eventsDispatcher:HasCallbacksForEvent(event) then
		eventsDispatcher:TriggerEvent(event, ...);
	else
		self:UnregisterEvent(event);
		Logger:Info(("Stopped listening to Game event %s, no more callbacks for this event"):format(tostring(event)));
	end
end

EventFrame:SetScript("OnEvent", dispatchEvent);

function GameEvents.triggerEvent(event, ...)
	Ellyb.Assertions.isType(event, "string", "event");
	dispatchEvent(EventFrame, event, ...)
end
