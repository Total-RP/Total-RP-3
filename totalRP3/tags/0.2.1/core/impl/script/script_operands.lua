--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Operands list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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