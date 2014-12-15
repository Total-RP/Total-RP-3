----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Effects
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local assert, type, tostring, error, tonumber, pairs, unpack, wipe = assert, type, tostring, error, tonumber, pairs, unpack, wipe;

local EFFECTS = {
	["text"] = {
		codeReplacement= "print(\"%s\");",
		args = 1,
		env = {
			print = "print",
		}
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.script.registerEffect = function(effect)
	assert(type(effect) == "table" and effect.id, "Effect must have an id.");
	assert(not EFFECTS[effect.id], "Already registered effect id: " .. effect.id);
	EFFECTS[effect.id] = effect;
end

TRP3_API.script.getEffect = function(effectID)
	return EFFECTS[effectID];
end