--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_EVENTS = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Total RP 3 events
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Profiles changes
	REGISTER_EXCHANGE_PROFILE_CHANGED = "\1",
	REGISTER_EXCHANGE_RECEIVED_INFO = "\2",
	REGISTER_MISC_SAVED = "\3",
	REGISTER_ABOUT_SAVED = "\4",
	REGISTER_CHARACTERISTICS_SAVED = "\5",
};

-- TRP3 API
local Utils = TRP3_UTILS;
local Log = Utils.log;
local assert = assert;
local tostring = tostring;
local type = type;
local tinsert = tinsert;
local pairs = pairs;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles Total RP 3 events system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

local function registerEvent(event)
	assert(event, "Event must be set.");
	assert(not REGISTERED_EVENTS[event], "Event already registered.");
	REGISTERED_EVENTS[event] = {};
	Log.log("Registered TRP event: " ..tostring(event));
end

-- Register main Total RP 3 events
for event, eventID in pairs(TRP3_EVENTS) do
	registerEvent(eventID);
end

TRP3_EVENTS.registerEvent = registerEvent;

local function listenToEvent(event, handler)
	assert(event, "Event must be set.");
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	assert(handler and type(handler) == "function", "Handler must be a function");
	tinsert(REGISTERED_EVENTS[event], handler);
end
TRP3_EVENTS.listenToEvent = listenToEvent;

TRP3_EVENTS.listenToEvents = function(events, handler)
	assert(events and type(events) == "table", "Events must be a table.");
	for _, event in pairs(events) do
		listenToEvent(event, handler);
	end
end

TRP3_EVENTS.fireEvent = function(event, ...)
	assert(event, "Event must be set.");
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	for _, handler in pairs(REGISTERED_EVENTS[event]) do
		handler(...);
	end
end