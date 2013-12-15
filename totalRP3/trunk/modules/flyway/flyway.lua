--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Flyway
-- This module is inspired by the Flyway java tool which is a tool managing schema changes between versions.
-- In TRP we use this principle to adapt structural saved variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SCHEMA_VERSION = 0001;

if not TRP3_Flyway then
	TRP3_Flyway = {};
end

local function applyPatches(fromBuild, toBuild)
	local i;
	for i=fromBuild, toBuild do
		if type(_G["TRP3_FlyWayPatches_"..i]) == "function" then
			_G["TRP3_FlyWayPatches_"..i]();
		end
	end
end

function TRP3_Flyway_Patches()
	if not TRP3_Flyway.currentBuild or TRP3_Flyway.currentBuild < SCHEMA_VERSION then
		applyPatches( (TRP3_Flyway.currentBuild or 0) + 1, SCHEMA_VERSION);
	end
	TRP3_Flyway.currentBuild = SCHEMA_VERSION;
end