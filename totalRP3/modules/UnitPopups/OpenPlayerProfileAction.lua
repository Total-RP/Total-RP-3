----------------------------------------------------------------------------------
--- Total RP 3
---
--- UnitPopup Integration
---	---------------------------------------------------------------------------
--- Copyright 2018 Daniel "Meorawr" Yates <me@meorawr.io>
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);
local loc = TRP3_API.loc;
local utils = TRP3_API.utils;

local UnitPopups = TRP3_API.UnitPopups;

local UnitAction = UnitPopups.UnitAction;

local OpenPlayerProfileAction = Ellyb.Class("OpenPlayerProfileAction", UnitAction);

function OpenPlayerProfileAction:initialize()
	UnitAction.initialize(self, loc.UP_OPEN_PROFILE_BUTTON);
end

function OpenPlayerProfileAction:OnTriggered(_, name, server)
	TRP3_API.slash.openProfile(utils.str.unitInfoToID(name, server));
end

-- Exports...
UnitPopups.OpenPlayerProfileAction = OpenPlayerProfileAction;
