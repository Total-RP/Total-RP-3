--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Code generation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local assert, type, tostring, error, tonumber, pairs, unpack = assert, type, tostring, error, tonumber, pairs, unpack;
local writeElement;

local PRETTY = true;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Writer
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CURRENT_CODE, CURRENT_INDENT, CURRENT_STRUCTURE;
local INDENT_CHAR = " ";

local function writeLine(code)
	CURRENT_CODE = CURRENT_CODE .. CURRENT_INDENT .. code .. "\n";
end

local function addIndent()
	CURRENT_INDENT = CURRENT_INDENT .. INDENT_CHAR;
end

local function removeIndent()
	if CURRENT_INDENT:len() > 1 then
		CURRENT_INDENT = CURRENT_INDENT:sub(1, -1);
	else
		CURRENT_INDENT = "";
	end
end

local function startIf(content)
	writeLine(("if %s then"):format(content));
	addIndent();
end

local function closeBlock()
	removeIndent();
	writeLine("end");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 1 : Test
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TEST_OPERANDE = {
	["tar_name"] = {
		codeReplacement= "UnitName(\"target\")",
	},
	["tar_hp"] = {
		codeReplacement= "UnitHealth(\"target\")",
		numeric = true,
	}
}

local function getTestOperande(id)
	return TEST_OPERANDE[id];
end

local function writeTest(testStructure)
	assert(testStructure, "testStructure is nil");
	local left, comparator, right, comparatorType;

	-- Comparator
	assert(testStructure.c, "Comparator is nil");
	local comparator = tostring(testStructure.c);
	if comparator == "<" or comparator == ">" or comparator == "<=" or comparator == ">=" then
		comparatorType = "number";
	elseif comparator == "==" or comparator == "~=" then
		comparatorType = "string";
	else
		error("Unknown comparator: " .. tostring(comparator));
	end

	-- Left operande
	assert(testStructure.l, "Left operand is nil");
	if type(testStructure.l) == "string" then
		if comparatorType == "number" then
			assert(tonumber(testStructure.l) ~= nil, "Cannot parse left operand value: " .. testStructure.l);
			left = testStructure.l;
		else
			left = "\"" .. testStructure.l .. "\"";
		end
	elseif type(testStructure.l) == "table" then
		local operandInfo = getTestOperande(tostring(testStructure.l.id));
		assert(operandInfo, "Unknown left operand ID: " .. tostring(testStructure.l.id));
		if comparatorType == "number" then
			assert(operandInfo.numeric, "Left operand ID is not numeric: " .. tostring(testStructure.l.id));
			left = operandInfo.codeReplacement;
		else
			left = "tostring(" .. operandInfo.codeReplacement .. ")";
		end

	else
		error("Unknown left operand type: " .. type(testStructure.l));
	end

	-- Right operand
	assert(testStructure.r, "Right operand is nil");
	if type(testStructure.r) == "string" then
		if comparatorType == "number" then
			assert(tonumber(testStructure.r) ~= nil, "Cannot parse right operand value: " .. testStructure.r);
			right = testStructure.r;
		else
			right = "\"" .. testStructure.r .. "\"";
		end
	elseif type(testStructure.r) == "table" then
		local operandInfo = getTestOperande(tostring(testStructure.r.id));
		assert(operandInfo, "Unknown right operand ID: " .. tostring(testStructure.r.id));
		if comparatorType == "number" then
			assert(operandInfo.numeric, "Right operand ID is not numeric: " .. tostring(testStructure.r.id));
			right = operandInfo.codeReplacement;
		else
			right = "tostring(" .. operandInfo.codeReplacement .. ")";
		end
	else
		error("Unknown right operand type: " .. type(testStructure.r));
	end

	-- Write code
	return ("%s %s %s"):format(left, comparator, right);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 2 : Condition
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeCondition(conditionStructure)
	assert(type(conditionStructure) == "table", "conditionStructure is not a table");
	local code = "";
	local previousType;
	local isInParenthesis = false;
	for index, element in pairs(conditionStructure) do
		if type(element) == "string" then
			assert(index > 1 and index < #conditionStructure, ("Can't have a logic operator at start or end: index %s for operator %s"):format(index, element));
			assert(previousType ~= "string", "Can't have two successive logic operator");
			if element == "+" then
				code = code .. "and" .. " ";
			elseif element == "*" then
				code = code .. "or" .. " ";
			else
				error("Unknown logic operator: " .. element);
			end
		elseif type(element) == "table" then
			assert(previousType ~= "table", "Can't have two successive tests");
			if index == #conditionStructure and isInParenthesis then -- End of condition
				code = code .. writeTest(element) .. " ) ";
				isInParenthesis = false;
			elseif index < #conditionStructure then
				if conditionStructure[index + 1] == "+" and isInParenthesis then
					code = code .. writeTest(element) .. " ) ";
					isInParenthesis = false;
				elseif conditionStructure[index + 1] == "*" and not isInParenthesis then
					code = code .. "( " .. writeTest(element) .. " ";
					isInParenthesis = true;
				else
					code = code .. writeTest(element) .. " ";
				end
			else
				code = code .. writeTest(element) .. " ";
			end
		else
			error("Unknown condition element: " .. element);
		end
		previousType = type(element);
	end

	return code;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 3 : Effect
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local EFFECTS = {
	["play_sound"] = {
		codeReplacement= "PlaySound();",
	},
	["dialog"] = {
		codeReplacement= "Dialog(\"%s\", \"%s\");",
		argCount = 2,
	},
	["setHP"] = {
		codeReplacement= "setHP(%s);",
		argCount = 1,
	}
}

local function getEffectInfo(id)
	return EFFECTS[id];
end

local function writeEffect(effectStructure)
	assert(type(effectStructure) == "table", "effectStructure is not a table");
	assert(effectStructure.id, "Effect don't have ID");
	local effectInfo = getEffectInfo(effectStructure.id);
	assert(effectInfo, "Unknown effect ID: " .. effectStructure.id);

	local effectCode = effectInfo.codeReplacement;
	if (effectInfo.argCount or 0) > 0 and effectStructure.args then
		effectCode = effectCode:format(unpack(effectStructure.args));
	end

	if effectStructure.cond then
		startIf(writeCondition(effectStructure.cond));
	end
	writeLine(effectCode);
	if effectStructure.cond then
		closeBlock();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 4  : Effects list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeEffectList(listStructure)
	assert(type(listStructure.e) == "table", "listStructure.e is not a table");
	for index, effect in pairs(listStructure.e) do
		writeEffect(effect);
	end
	
	if listStructure.n then
		writeElement(listStructure.n);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 4  : Branching
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeBranching()

end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 4  : Delay
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeDelay(delayStructure)
	assert(type(delayStructure.d) == "number", "listStructure duration is not a number");
	writeLine(("delayed( %s, function() "):format(delayStructure.d));
	addIndent();
	if delayStructure.n then
		writeElement(delayStructure.n);
	end
	removeIndent();
	writeLine("end);");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 5  : Thread
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

writeElement = function(elementID)
	assert(elementID, "elementID is nil");
	local element = CURRENT_STRUCTURE[elementID];
	assert(element, "Unknown element ID: " .. elementID);
	
	if PRETTY then
		writeLine("");
		writeLine("-- Element " .. elementID);
	end
	if element.t == "list" then
		writeEffectList(element);
	elseif element.t == "delay" then
		writeDelay(element);
	else
		error("Unknown element type: " .. tostring(element.t));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function generate(effectStructure)
	CURRENT_CODE = "";
	CURRENT_INDENT = "";
	CURRENT_STRUCTURE = effectStructure;
	writeLine("-- Generated code:");
	writeElement("1"); -- 1 is always the first element
	return CURRENT_CODE;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MOCKUP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MOCK_STRUCTURE = {
	-- EFFECT LIST 1
	["1"] = {
		t = "list",
		n = "3",
		e = {
			-- EFFECT 1
			{
				id = "play_sound",
			},
			-- EFFECT 2
			{
				id = "dialog",
				cond = {
					{
						l = "10.57",
						c = "<",
						r = {
							id = "tar_hp"
						}
					},
					"*",
					{
						l = {
							id = "tar_name"
						},
						c = "~=",
						r = "Ellypse"
					}
				},
				args = {
					"SAY",
					"Hello !"
				}
			}
		}
	},
	-- EFFECT LIST 1
	["2"] = {
		t = "list",
		e = {
			-- EFFECT 1
			{
				id = "play_sound",
			}
		}
	},
	-- DELAY 1
	["3"] = {
		t = "delay",
		d = 5,
		n = "2"
	},
}

function TRP3_Generate()
	local code = generate(MOCK_STRUCTURE);
	print(code);
end