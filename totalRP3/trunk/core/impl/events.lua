--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.events = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Total RP 3 events
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Workflow
	WORKFLOW_ON_LOAD = "WORKFLOW_ON_LOAD",
	WORKFLOW_ON_LOADED = "WORKFLOW_ON_LOADED",
	-- Navigation
	NAVIGATION_TUTORIAL_REFRESH = "NAVIGATION_TUTORIAL_REFRESH",
	-- Profiles changes
	REGISTER_PROFILES_LOADED = "REGISTER_PROFILES_LOADED",
	REGISTER_PROFILE_DELETED = "REGISTER_PROFILE_DELETED",
	REGISTER_DATA_CHANGED = "REGISTER_DATA_CHANGED",
	REGISTER_IGNORED = "REGISTER_IGNORED",
	REGISTER_EXCHANGE_RECEIVED_INFO = "REGISTER_EXCHANGE_RECEIVED_INFO",
	REGISTER_MISC_SAVED = "REGISTER_MISC_SAVED",
	REGISTER_ABOUT_SAVED = "REGISTER_ABOUT_SAVED",
	REGISTER_CHARACTERISTICS_SAVED = "REGISTER_CHARACTERISTICS_SAVED",
	REGISTER_RPSTATUS_CHANGED = "REGISTER_RPSTATUS_CHANGED",
	REGISTER_ABOUT_READ = "REGISTER_ABOUT_READ",
	-- Notifications
	NOTIFICATION_CHANGED = "NOTIFICATION_CHANGED",
	-- Refresh
	TARGET_SHOULD_REFRESH = "TARGET_SHOULD_REFRESH",
};

-- TRP3 imports
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
end

-- Register main Total RP 3 events
for event, eventID in pairs(TRP3_API.events) do
	registerEvent(eventID);
end

TRP3_API.events.registerEvent = registerEvent;

local function listenToEvent(event, handler)
	assert(event, "Event must be set.");
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	assert(handler and type(handler) == "function", "Handler must be a function");
	tinsert(REGISTERED_EVENTS[event], handler);
end
TRP3_API.events.listenToEvent = listenToEvent;

TRP3_API.events.listenToEvents = function(events, handler)
	assert(events and type(events) == "table", "Events must be a table.");
	for _, event in pairs(events) do
		listenToEvent(event, handler);
	end
end

TRP3_API.events.fireEvent = function(event, ...)
	assert(event, "Event must be set.");
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	for _, handler in pairs(REGISTERED_EVENTS[event]) do
		handler(...);
	end
end