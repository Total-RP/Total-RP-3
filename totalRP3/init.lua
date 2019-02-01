----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

-- First file loaded. It will do the import stuff that needs to be run first
---@class TRP3_API
local addOnName, TRP3_API = ...;

-- Global informations
-- Note: This table will be overwritten in totalRP3/core/impl/globals.lua
-- It is here only so that DEBUG_MODE is available from the start
TRP3_API.globals = {
	--@debug@

	-- Debug mode is enable when the add-on has not been packaged by Curse
	DEBUG_MODE = true,
	--@end-debug@

	--[===[@non-debug@

	-- Debug mode is disabled when the add-on has been packaged by Curse
	DEBUG_MODE = false,

	--@end-non-debug@]===]
};

-- Public API
TRP3_API.r = {};

-- I will be moving all the stuff from totalRP3/core/impl/utils to their own modules
-- To ensure backward compatibility, we will keep an reference to the old utils table
TRP3_API.utils = {};

-- Get a new instance of the Ellyb library
TRP3_API.Ellyb = Ellyb:GetInstance(addOnName);

--[===[@non-debug@

-- Debug mode is disabled when the add-on has been packaged by Curse
TRP3_API.Ellyb.SetDebugMode(false)

--@end-non-debug@]===]


-- Make our shared table public so that our API is accessible to other add-ons and external modules
_G.TRP3_API = TRP3_API;

-- New public API, intended for external use
---@type AddOn_TotalRP3
AddOn_TotalRP3 = {};
