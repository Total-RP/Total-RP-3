----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Operands
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

local OPERANDS = {
	["tar_name"] = {
		codeReplacement= "tostring(name(\"target\"))",
		env = {
			["name"] = "UnitName",
			["tostring"] = "tostring",
		},
	},
	
	["cond"] = {
		codeReplacement= "conditionStorage[\"%s\"]",
		args = 1
	},
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.script.registerOperand = function(operand)
	assert(type(operand) == "table" and operand.id, "Operand must have an id.");
	assert(not OPERANDS[operand.id], "Already registered operand id: " .. operand.id);
	OPERANDS[operand.id] = operand;
end

TRP3_API.script.getOperand = function(operandID)
	return OPERANDS[operandID];
end