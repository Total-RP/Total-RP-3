----------------------------------------------------------------------------------
-- Total RP 3
-- Events API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- Public accessor
TRP3_API.events = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Total RP 3 events
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Workflow
	WORKFLOW_ON_API = "WORKFLOW_ON_API",
	WORKFLOW_ON_LOAD = "WORKFLOW_ON_LOAD",
	WORKFLOW_ON_LOADED = "WORKFLOW_ON_LOADED",
	WORKFLOW_ON_FINISH = "WORKFLOW_ON_FINISH",

	-- Broadcast
	BROADCAST_CHANNEL_CONNECTING = "BROADCAST_CHANNEL_CONNECTING",
	BROADCAST_CHANNEL_READY = "BROADCAST_CHANNEL_READY",
	BROADCAST_CHANNEL_OFFLINE = "BROADCAST_CHANNEL_OFFLINE",

	-- Navigation
	NAVIGATION_TUTORIAL_REFRESH = "NAVIGATION_TUTORIAL_REFRESH",
	NAVIGATION_RESIZED = "NAVIGATION_RESIZED",
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Data changed
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	-- General event when a data changed in a profile of a certain unitID (character or companion)
	-- Arg1 : (optional) unitID or companionFullID
	-- Arg2 : profile ID
	-- Arg3 : (optional) Data type : either nil or "characteristics", "about", "misc", "character", "unitID"
	REGISTER_DATA_UPDATED = "REGISTER_DATA_UPDATED",
	
	-- Called when you switch from one profile to another
	-- Use to known when re-compress all of the current profile.
	-- Arg1 : profile structure
	REGISTER_PROFILES_LOADED = "REGISTER_PROFILES_LOADED",
	
	-- Called when a profile is deleted (character or companion)
	-- Arg1 : Profile ID
	-- Arg2 : (optional, currently only for characters) A tab containing all the linked unitIDs to the profile
	REGISTER_PROFILE_DELETED = "REGISTER_PROFILE_DELETED",
	
	-- Called when as "About" page is shown.
	-- This is used by the tooltip and the target bar to be refreshed
	REGISTER_ABOUT_READ = "REGISTER_ABOUT_READ",

	-- Called when a notifications is created/read/removed
	NOTIFICATION_CHANGED = "NOTIFICATION_CHANGED",
	
	-- Called when Wow Event UPDATE_MOUSEOVER_UNIT is fired
	-- Arg1 : Target ID
	-- Arg2 : Target mode (Character, pet, battle pet ...)
	MOUSE_OVER_CHANGED = "MOUSE_OVER_CHANGED",
};

-- TRP3 imports
local assert, tostring, type, tinsert, pairs = assert, tostring, type, tinsert, pairs;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles Total RP 3 events system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

local function registerEvent(event)
	assert(event, "Event can't be nil.");
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