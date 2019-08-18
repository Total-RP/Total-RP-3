----------------------------------------------------------------------------------
--- Total RP 3
--- This file does a couple of checks to make sure the add-on is being loaded properly in the expected environment.
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---     http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

--region Build version check
if TRP3_API.BUILD_NUMBER == nil then
	-- luacheck: ignore 311
	TRP3_API = nil -- Force API reference to nil. This will break most of the add-on so it stops loading.
	error([[Missing critical Total RP 3 files.

You probably tried to update the add-on while the game client was running. This is not recommended.
Please quit the game completely in order for the add-on to properly update.
]]);
end
--endregion

--region Dev builds setup
--@alpha@
-- Force showing Lua errors on non release builds
SetCVar("scriptErrors", 1);
--@end-alpha@
--endregion
