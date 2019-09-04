----------------------------------------------------------------------------------
--- Total RP 3
--- Schema migration tool
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

TRP3_API.flyway = {};

local type, tostring = type, tostring;

local SCHEMA_VERSION = 11;

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
