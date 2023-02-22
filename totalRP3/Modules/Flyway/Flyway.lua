-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_API.flyway = {};

local type, tostring = type, tostring;

local SCHEMA_VERSION = 13;

if not TRP3_Flyway then
	TRP3_Flyway = {};
end

local function applyPatches(fromBuild, toBuild)
	for i = fromBuild, toBuild do
		if type(TRP3_API.flyway.patches[tostring(i)]) == "function" then
			TRP3_API.utils.log.log(("Applying patch %s"):format(i));
			TRP3_API.flyway.patches[tostring(i)]();
		end
	end
	TRP3_Flyway.log = ("Patch applied from %s to %s on %s"):format(fromBuild, toBuild, date("%d/%m/%y %H:%M:%S"));
end

function TRP3_API.flyway.applyPatches()
	if not TRP3_Flyway.currentBuild or TRP3_Flyway.currentBuild < SCHEMA_VERSION then
		applyPatches((TRP3_Flyway.currentBuild or 0) + 1, SCHEMA_VERSION);
	end
	TRP3_Flyway.currentBuild = SCHEMA_VERSION;
end
