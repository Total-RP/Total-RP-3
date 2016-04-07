----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Code generation
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

TRP3_API.script = {};

local assert, type, tostring, error, tonumber, pairs, unpack, wipe = assert, type, tostring, error, tonumber, pairs, unpack, wipe;
local tableCopy = TRP3_API.utils.table.copy;
local log, logLevel = TRP3_API.utils.log.log, TRP3_API.utils.log.level;
local writeElement;
local loc = TRP3_API.locale.getText;

local DEBUG = false;

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

local after = C_Timer.After;
TRP3_API.script.delayed = function(delay, func)
	if func and delay then
		after(delay, func);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Writer
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CURRENT_CODE, CURRENT_INDENT, CURRENT_STRUCTURE, CURRENT_SECURITY_CONTEXT;
local CURRENT_ENVIRONMENT = {};
local INDENT_CHAR = "\t";

local function writeLine(code, onTop)
	if onTop then
		CURRENT_CODE = CURRENT_INDENT .. code .. "\n" .. CURRENT_CODE;
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
	assert(type(testStructure) == "table", "testStructure is not a table");
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

		local codeReplacement = operandInfo.codeReplacement;
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
	assert(#testStructure == 3, "testStructure should have three components");
	local comparator, comparatorType;

	-- Comparator
	assert(type(testStructure[2]) == "string", "testStructure comparator is not a string");
	local comparator = tostring(testStructure[2]);
	if comparator == "<" or comparator == ">" or comparator == "<=" or comparator == ">=" then
		comparatorType = "number";
	elseif comparator == "==" or comparator == "~=" then
		comparatorType = "string";
	else
		error("Unknown comparator: " .. tostring(comparator));
	end

	-- Left operande
	local left = writeOperand(testStructure[1], comparatorType);

	-- Right operand
	local right = writeOperand(testStructure[3], comparatorType)

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

function TRP3_API.script.protected()
	print("Protected !");
	return -1;
end

local function writeEffect(effectStructure)
	assert(type(effectStructure) == "table", "effectStructure is not a table");
	assert(effectStructure.id, "Effect don't have ID");
	local effectInfo = getEffectInfo(effectStructure.id);
	assert(effectInfo, "Unknown effect ID: " .. effectStructure.id);

	local effectCode;

--	if effectInfo.secured and effectInfo.secured ~= TRP3_API.script.security.HIGH then
		-- TODO: security system
--		effectCode = "lastEffectReturn = protected();";
--		CURRENT_ENVIRONMENT["protected"] = "TRP3_API.script.protected";
--	else
		-- Register operand environment
		if effectInfo.env then
			for map, g in pairs(effectInfo.env) do
				CURRENT_ENVIRONMENT[map] = g;
			end
		end
		effectCode = effectInfo.codeReplacementFunc(escapeArguments(effectStructure.args), effectStructure.id);
--	end

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

	if DEBUG then
		writeLine("");
		writeLine("-- Element " .. elementID);
	end

	if not element then
		if DEBUG then
			writeLine("-- WARNING: Unknown element ID: " .. elementID);
		end
		return;
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

local BASE_ENV = { ["tostring, EMPTY, delayed, eval"] = "tostring, TRP3_API.globals.empty, TRP3_API.script.delayed, TRP3_API.script.eval" };
local IMPORT_PATTERN = "local %s = %s;";
local EMPTY = TRP3_API.globals.empty;

local function writeImports()
	for alias, global in pairs(CURRENT_ENVIRONMENT) do
		writeLine(IMPORT_PATTERN:format(alias, global), true);
	end
	if DEBUG then
		writeLine("-- Imports", true);
	end
end

local function generateCode(effectStructure, securityContext)
	CURRENT_CODE = "";
	CURRENT_INDENT = "";

	wipe(CURRENT_ENVIRONMENT);
	tableCopy(CURRENT_ENVIRONMENT, BASE_ENV);

	CURRENT_STRUCTURE = effectStructure;
	CURRENT_SECURITY_CONTEXT = securityContext or EMPTY;

	writeLine("local func = function(args)");
	addIndent();
	writeLine("args = args or EMPTY;");
	writeLine("if not args.custom then args.custom = {}; end");
	writeLine("local conditionStorage = {};"); -- Store conditions evaluation
	writeLine("local lastEffectReturn;"); -- Store last return value from effect, to be able to test it in further conditions.
	writeElement("1"); -- 1 is always the first element
	writeLine("return 0, conditionStorage;");
	closeBlock();
	writeImports();
	writeLine("setfenv(func, {});");
	writeLine("return func;");

	return CURRENT_CODE;
end

local function generate(effectStructure, securityContext)
	log("Generate FX", logLevel.DEBUG);
	local code = generateCode(effectStructure, securityContext);

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
					{ l = { v = "Telkostrasz", }, c = "==", r = { i = "tar_name", } },
				},
				args = {
					"La cible est Telkostrasz",
				}
			},
			-- EFFECT 1
			{
				id = "text",
				cond = {
					{ l = { v = true, }, c = "~=", r = { i = "cond", a = { 1 } } },
				},
				args = {
					"La cible\");print(\"you just got hacked\");print(\"",
				}
			}
		}
	},
}

local function getFunction(structure, securityContext)
	local functionFactory, code = generate(structure, securityContext);

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
		TRP3_API.utils.message.displayMessage(loc("SCRIPT_ERROR"));
		log(tostring(ret), logLevel.WARN);
	end
end

TRP3_API.script.executeFunction = executeFunction;

local function executeClassScript(scriptID, classScripts, args)
	if scriptID and classScripts then
		assert(classScripts[scriptID], "Unknown script: " .. tostring(scriptID));
		local class = classScripts[scriptID];
		if not class.c then -- Not compiled yet
			class.c = getFunction(class.ST);
		end
		return executeFunction(class.c, args);
	end
end

TRP3_API.script.executeClassScript = executeClassScript;

function TRP3_Generate()
	print(tostring(executeFunction(getFunction(MOCK_STRUCTURE))));
end