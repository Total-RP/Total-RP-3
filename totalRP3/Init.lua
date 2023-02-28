-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- First file loaded. It will do the import stuff that needs to be run first
---@class TRP3_API
local addOnName, TRP3_API = ...;

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

-- Make our shared table public so that our API is accessible to other add-ons and external modules
_G.TRP3_API = TRP3_API;

-- New public API, intended for external use
---@type AddOn_TotalRP3
AddOn_TotalRP3 = {};

--@debug@
-- Force showing Lua errors on non release builds
SetCVar("scriptErrors", 1);
--@end-debug@
