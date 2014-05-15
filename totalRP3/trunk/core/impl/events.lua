--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_EVENTS = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Total RP 3 events
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Profiles changes
	REGISTER_PROFILES_LOADED = "REGISTER_PROFILES_LOADED",
	REGISTER_EXCHANGE_PROFILE_CHANGED = "REGISTER_EXCHANGE_PROFILE_CHANGED",
	REGISTER_EXCHANGE_RECEIVED_INFO = "REGISTER_EXCHANGE_RECEIVED_INFO",
	REGISTER_MISC_SAVED = "REGISTER_MISC_SAVED",
	REGISTER_ABOUT_SAVED = "REGISTER_ABOUT_SAVED",
	REGISTER_CHARACTERISTICS_SAVED = "REGISTER_CHARACTERISTICS_SAVED",
	REGISTER_RPSTATUS_CHANGED = "REGISTER_RPSTATUS_CHANGED",
	-- Notifications
	NOTIFICATION_CHANGED = "NOTIFICATION_CHANGED",
};

-- TRP3 imports
local Utils = TRP3_UTILS;
local Log = Utils.log;
local assert, tostring, type, tinsert, pairs = assert, tostring, type, tinsert, pairs;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles Total RP 3 events system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

local function registerEvent(event)
	assert(event, "Event must be set.");
	assert(not REGISTERED_EVENTS[event], "Event already registered.");
	REGISTERED_EVENTS[event] = {};
	Log.log("Registered TRP event: " .. event);
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