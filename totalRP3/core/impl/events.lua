----------------------------------------------------------------------------------
--- Total RP 3
--- Events API
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
--
--- 	http://www.apache.org/licenses/LICENSE-2.0
--
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

local Events = {
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

	-- Called when the user changes the page in the main frame. (setPage)
	-- Arg1 : Page ID
	-- Arg2 : Page context
	PAGE_OPENED = "PAGE_OPENED",

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

	-- Called when Wow Event UPDATE_MOUSEOVER_UNIT is fired
	-- Arg1 : Target ID
	-- Arg2 : Target mode (Character, pet, battle pet ...)
	MOUSE_OVER_CHANGED = "MOUSE_OVER_CHANGED",
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles Total RP 3 events system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local log = TRP3_API.Ellyb.Logger("TRP3 Events");
local eventsDispatcher = TRP3_API.Ellyb.EventsDispatcher();

function Events.registerEvent()
	log:Warning("DEPRECATED: Registering events is not longer required with the new events system.");
end

function Events.unregisterCallback(handlerID)
	Ellyb.Assertions.isType(handlerID, "string", "handlerID");
	return eventsDispatcher:UnregisterCallback(handlerID);
end

---@overload fun(event:string, handler:function)
function Events.registerCallback(event, handler, handlerID)
	Ellyb.Assertions.isType(event, "string", "event");
	Ellyb.Assertions.isType(handler, "function", "handler");
	return eventsDispatcher:RegisterCallback(event, handler, handlerID);
end

Events.listenToEvent = Events.registerCallback;

function Events.registerCallbacks(events, handler)
	Ellyb.Assertions.isType(events, "table", "events");
	Ellyb.Assertions.isType(handler, "function", "handler");

	local handlerID;
	for _, event in pairs(events) do
		handlerID = Events.registerCallback(event, handler, handlerID);
	end

	return handlerID;
end
Events.listenToEvents = Events.registerCallback;

function Events.triggerEvent(event, ...)
	Ellyb.Assertions.isType(event, "string", "event");
	eventsDispatcher:TriggerEvent(event, ...);
end

Events.fireEvent = Events.triggerEvent;

TRP3_API.Events = Events;
TRP3_API.events = Events;
