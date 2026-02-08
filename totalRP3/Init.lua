-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@class TRP3
TRP3 = select(2, ...);

TRP3_Addon = LibStub("AceAddon-3.0"):NewAddon("TRP3", "AceConsole-3.0");

--- Build version, based on Git revision number (ex: 1723)
--[===[@non-debug@
TRP3.BUILD_NUMBER = @project-revision@;
--@end-non-debug@]===]

--@debug@
TRP3.BUILD_NUMBER = -1;
--@end-debug@

--- Display version, based on the build tag (ex: 1.5.2)
--[===[@non-debug@
TRP3.VERSION_DISPLAY = "@project-version@";
--@end-non-debug@]===]
--@debug@
TRP3.VERSION_DISPLAY = "-dev";
--@end-debug@

-- Global informations
-- Note: This table will be overwritten in totalRP3/core/impl/globals.lua
-- It is here only so that DEBUG_MODE is available from the start
TRP3.globals = {
	--@debug@

	-- Debug mode is enable when the add-on has not been packaged by Curse
	DEBUG_MODE = true,
	--@end-debug@

	--[===[@non-debug@

	-- Debug mode is disabled when the add-on has been packaged by Curse
	DEBUG_MODE = false,

	--@end-non-debug@]===]
};

TRP3.r = {};

TRP3.utils = {
	log = {},
	table = {},
	str = {},
	color = {},
	math = {},
	serial = {},
	event = {},
	music = {},
	texture = {},
	message = {},
	resources = {},
};

-- Legacy aliases for accessing our functions. To be deprecated in perpetuum.

---@class TRP3
TRP3_API = TRP3;

---@class TRP3
AddOn_TotalRP3 = TRP3;
