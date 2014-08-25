--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Flyway
-- This module is inspired by the Flyway java tool which is a tool managing schema changes between versions.
-- In TRP we use this principle to adapt structural saved variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.flyway = {};

local type, _G, tostring = type, _G, tostring;

local SCHEMA_VERSION = 2;

if not TRP3_Flyway then
	TRP3_Flyway = {};
end

local function applyPatches(fromBuild, toBuild)
	local i;
	for i=fromBuild, toBuild do
		if type(TRP3_API.flyway.patches[tostring(i)]) == "function" then
			TRP3_API.utils.log.log(("Applying patch %s"):format(i));
			TRP3_API.flyway.patches[tostring(i)]();
		end
	end
end

function TRP3_API.flyway.applyPatches()
	if not TRP3_Flyway.currentBuild or TRP3_Flyway.currentBuild < SCHEMA_VERSION then
		applyPatches( (TRP3_Flyway.currentBuild or 0) + 1, SCHEMA_VERSION);
	end
	TRP3_Flyway.currentBuild = SCHEMA_VERSION;
end