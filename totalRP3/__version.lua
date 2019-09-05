----------------------------------------------------------------------------------
--- Total RP 3
--- This file is responsible for providing version number information.
--- The name is generated during the build according to the build number.
--- Updating the add-on while the game is running will NOT load the updated version of this file.
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

--- Build version, based on Git revision number (ex: 1723)
--[===[@non-debug@
TRP3_API.BUILD_NUMBER = @project-revision@;
--@end-non-debug@]===]

--@debug@
TRP3_API.BUILD_NUMBER = -1;
--@end-debug@

--- Display version, based on the build tag (ex: 1.5.2)
--[===[@non-debug@
TRP3_API.VERSION_DISPLAY = "@project-version@";
--@end-non-debug@]===]
--@debug@
TRP3_API.VERSION_DISPLAY = "-dev";
--@end-debug@

--- Legacy version number (we keep it for now, it should go in the long term)
TRP3_API.LEGACY_VERSION = 76;
