----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Code generation
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

TRP3_API.script = {};

local assert, type, tostring, error, tonumber, pairs, unpack, wipe = assert, type, tostring, error, tonumber, pairs, unpack, wipe;
local tableCopy = TRP3_API.utils.table.copy;
local log, logLevel = TRP3_API.utils.log.log, TRP3_API.utils.log.level;
local writeElement;

local DEBUG = true;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Escape " in string argument, to avoid script injection
local function escapeArguments(args)
	if not args then return end
	local escaped = {};
	for index, arg in pairs(args) do
		if type(arg) == "string" then
			escaped[index] = arg:gsub("\"", "\\\"");
		else
			escaped[index] = arg;
		end
	end
	return escaped;
end
TRP3_API.script.escapeArguments = escapeArguments;

TRP3_API.script.eval = function(conditionValue, conditionID, conditionStorage)
	if conditionID then
		conditionStorage[conditionID] = conditionValue;
	end
	return conditionValue;
end

TRP3_API.script.delayed = function(delay, func)
	-- TODO
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Writer
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CURRENT_CODE, CURRENT_INDENT, CURRENT_STRUCTURE, CURRENT_ENVIRONMENT;
local INDENT_CHAR = "\t";

local function writeLine(code, onTop)
	if onTop then
		CURRENT_CODE =  CURRENT_INDENT .. code .. "\n" .. CURRENT_CODE;
	else
		CURRENT_CODE = CURRENT_CODE .. CURRENT_INDENT .. code .. "\n";
	end
end

local function addIndent()
	CURRENT_INDENT = CURRENT_INDENT .. INDENT_CHAR;
end

local function removeIndent()
	if CURRENT_INDENT:len() > 1 then
		CURRENT_INDENT = CURRENT_INDENT:sub(1, -2);
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

local function getTestOperande(id)
	return TRP3_API.script.getOperand(id);
end

local function writeOperand(testStructure, comparatorType)
	local code;
	assert(testStructure.v or testStructure.i, "No operand info");
	if testStructure.v then
		if comparatorType == "number" then
			assert(tonumber(testStructure.v) ~= nil, "Cannot parse operand value: " .. testStructure.v);
			code = testStructure.v;
		else
			if type(testStructure.v) == "string" then
				code = "\"" .. testStructure.v .. "\"";
			elseif type(testStructure.v) == "boolean" then
				code = tostring(testStructure.v);
			else
				error("Unknown operand value type: " .. type(testStructure.v));
			end
		end
	else
		local args = testStructure.a;
		local operandInfo = getTestOperande(testStructure.i);
		assert(operandInfo, "Unknown operand ID: " .. testStructure.i);
		assert(comparatorType ~= "number" or operandInfo.numeric, "Operand ID is not numeric: " .. testStructure.i);
		
		local codeReplacement =  operandInfo.codeReplacement;
		if operandInfo.args then -- has arguments
			assert(args, "Missing arguments for operand: " .. testStructure.i);
			assert(#args == operandInfo.args, ("Incomplete arguments for %s: %s / %s"):format(testStructure.i, #args, operandInfo.args));
			codeReplacement = codeReplacement:format(unpack(escapeArguments(args)));
		end
		code = codeReplacement;
		
		-- Register operand environment
		if operandInfo.env then
			for map, g in pairs(operandInfo.env) do
				CURRENT_ENVIRONMENT[map] = g;
			end
		end
	end
	return code;
end

local function writeTest(testStructure)
	assert(testStructure, "testStructure is nil");
	local comparator, comparatorType;

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
	assert(testStructure.l, "No left operand");
	local left = writeOperand(testStructure.l, comparatorType);
	
	-- Right operand
	assert(testStructure.r, "No Right operand");
	local right = writeOperand(testStructure.r, comparatorType)

	-- Write code
	return ("%s %s %s"):format(left, comparator, right);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 2 : Condition
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeCondition(conditionStructure, conditionID)
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
	
	if conditionID then
		code = ("eval(%s, \"%s\", conditionStorage)"):format(code, conditionID);
	end

	return code;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 3 : Effect
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local EFFECT_MISSING_ID = "MISSING";

local function getEffectInfo(id)
	return TRP3_API.script.getEffect(id) or TRP3_API.script.getEffect(EFFECT_MISSING_ID);
end

local function writeEffect(effectStructure)
	assert(type(effectStructure) == "table", "effectStructure is not a table");
	assert(effectStructure.id, "Effect don't have ID");
	local effectInfo = getEffectInfo(effectStructure.id);
	assert(effectInfo, "Unknown effect ID: " .. effectStructure.id);
	
	-- Register operand environment
	if effectInfo.env then
		for map, g in pairs(effectInfo.env) do
			CURRENT_ENVIRONMENT[map] = g;
		end
	end

	local effectCode = effectInfo.codeReplacementFunc(escapeArguments(effectStructure.args), effectStructure.id);

	if effectStructure.cond and #effectStructure.cond > 0 then
		startIf(writeCondition(effectStructure.cond, effectStructure.condID));
	end
	writeLine(effectCode);
	if effectStructure.cond and #effectStructure.cond > 0 then
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

local BRANCHING_COND = "if %s then";

local function writeBranching(branchStructure)
	assert(type(branchStructure.b) == "table", "branchStructure.b is not a table");
	if #branchStructure.b == 0 then return; end
	
	for index, branch in pairs(branchStructure.b) do
		if DEBUG then
			writeLine("-- branch " .. index);
		end
		if branch.cond and #branch.cond > 0 then
			startIf(writeCondition(branch.cond, branch.condID));
		end
		writeElement(branch.n);
		if DEBUG then
			writeLine("");
		end
		if branch.cond and #branch.cond > 0 then
			closeBlock();
		end
		if DEBUG then
			writeLine("");
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 4  : Delay
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function writeDelay(delayStructure)
	assert(type(delayStructure.d) == "number", "listStructure duration is not a number");
	
	writeLine(("delayed(%s, function() "):format(delayStructure.d));
	addIndent();
	if delayStructure.n then
		writeElement(delayStructure.n);
	end
	removeIndent();
	if DEBUG then
		writeLine("");
	end
	writeLine("end);");
	if DEBUG then
		writeLine("");
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LEVEL 5  : Thread
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

writeElement = function(elementID)
	assert(elementID, "elementID is nil");
	local element = CURRENT_STRUCTURE[elementID];
	assert(element, "Unknown element ID: " .. elementID);
	
	if DEBUG then
		writeLine("");
		writeLine("-- Element " .. elementID);
	end
	
	if element.t == "list" then
		writeEffectList(element);
	elseif element.t == "branch" then
		writeBranching(element);
	elseif element.t == "delay" then
		writeDelay(element);
	else
		error("Unknown element type: " .. tostring(element.t));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local BASE_ENV = {delayed = "TRP3_API.script.delayed", eval = "TRP3_API.script.eval", EMPTY = "{}"};
local IMPORT_PATTERN = "local %s = %s;";

local function writeImports()
	for alias, global in pairs(CURRENT_ENVIRONMENT) do
		writeLine(IMPORT_PATTERN:format(alias, global), true);
	end
	if DEBUG then
		writeLine("-- Imports", true);
	end
end

local function generateCode(effectStructure)
	CURRENT_CODE = "";
	CURRENT_INDENT = "";
	
	if not CURRENT_ENVIRONMENT then
		CURRENT_ENVIRONMENT = {};
	end
	wipe(CURRENT_ENVIRONMENT);
	tableCopy(CURRENT_ENVIRONMENT, BASE_ENV);
	
	CURRENT_STRUCTURE = effectStructure;

	writeLine("local func = function(args)");
	addIndent();
	writeLine("args = args or EMPTY;");
	writeLine("local conditionStorage = {};"); -- Store conditions evaluation
	writeElement("1"); -- 1 is always the first element
	writeLine("return 0, conditionStorage;");
	closeBlock();
	writeImports();
	writeLine("setfenv(func, {});");
	writeLine("return func;");
	
	return CURRENT_CODE;
end

local function generate(effectStructure)
	log("Generate FX", logLevel.DEBUG);
	local code = generateCode(effectStructure);
	
	-- Generating factory
	local func, errorMessage = loadstring(code, "Generated code");
	if not func then
		print(errorMessage);
		return nil, code;
	end
	
	return func, code;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MOCKUP
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MOCK_STRUCTURE = {
	-- EFFECT LIST 1
	["1"] = {
		t = "list",
		e = {
			-- EFFECT 1
			{
				id = "text",
				condID = 1,
				cond = {
					{l = {v = "Telkostrasz",},c = "==",r = {i = "tar_name",}},
				},
				args = {
					"La cible est Telkostrasz",
				}
			},
			-- EFFECT 1
			{
				id = "text",
				cond = {
					{l = {v = true,},c = "~=",r = {i = "cond", a = {1}}},
				},
				args = {
					"La cible\");print(\"you just got hacked\");print(\"",
				}
			}
		}
	},
}

local function getFunction(structure)
	local functionFactory, code = generate(structure);

	if DEBUG then
		TRP3_DEBUG_CODE_FRAME:Show();
		TRP3_DEBUG_CODE_FRAME_TEXT:SetText(code);
	end

	if functionFactory then
		return functionFactory();
	end
end
TRP3_API.script.getFunction = getFunction;

local function executeFunction(func, args)
	local status, ret, conditions = pcall(func, args);
	if status then
--		if DEBUG then TRP3_API.utils.table.dump(conditions); end
		return ret;
	else
		if DEBUG then log(tostring(ret), logLevel.WARN) end
	end
end
TRP3_API.script.executeFunction = executeFunction;

local function executeClassScript(class, args)
	if class and class.SC then
		if not class.SCc then -- Not compiled yet
			class.SCc = getFunction(class.SC);
		end
		return executeFunction(class.SCc, args);
	end
end
TRP3_API.script.executeClassScript = executeClassScript;

function TRP3_Generate()
	print(tostring(executeFunction(getFunction(MOCK_STRUCTURE))));
end