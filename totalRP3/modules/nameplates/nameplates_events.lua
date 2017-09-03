----------------------------------------------------------------------------------
--- 	Total RP 3
--- 	Nameplates events
---    ---------------------------------------------------------------------------
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@class TRP3_NameplatesEvents
local NameplatesEvents = {};
TRP3_API.nameplates.events = NameplatesEvents;

function NameplatesEvents.init()
	
	local Events = TRP3_API.events;
	local registerEventHandler = TRP3_API.utils.event.registerHandler;
	local registerTRP3EventHandler = Events.listenToEvent;
	
	
	local EVENTS = {
		"NAME_PLATE_CREATED",
		"NAME_PLATE_UNIT_ADDED",
		"NAME_PLATE_UNIT_REMOVED",
		"PLAYER_TARGET_CHANGED",
		"DISPLAY_SIZE_CHANGED",
		"VARIABLES_LOADED",
		"CVAR_UPDATE",
		"RAID_TARGET_UPDATE",
		"UNIT_FACTION"
	}
	
	local TRP3_EVENTS = {
		Events.REGISTER_DATA_UPDATED
	}
	
	for _, event in pairs(EVENTS) do
		registerEventHandler(event, TRP3_API.nameplates.refresh);
	end
	
	for _, TRP3Event in pairs(TRP3_EVENTS) do
		registerTRP3EventHandler(TRP3Event, TRP3_API.nameplates.refresh);
	end
end