----------------------------------------------------------------------------------
--- Total RP 3
--- Assertions
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---     http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@class TRP3_Debug
--- # Total RP 3 Debug
---
local Debug = {};
TRP3_API.Debug = Debug;

--- WoW imports
local error = error;
local type = type;
local getinfo = debug.getinfo;
local format = string.format;
local gethook = debug.gethook;
local huge = math.huge;
local getlocal = debug.getlocal;
local sethook = debug.sethook;
local tinsert = table.insert;
local pcall = pcall;
local tconcat = table.concat;
local pairs = pairs;

function Debug.getFunctionInfo()
	local args = {}
	local hook = gethook()
	local funcInfo = getinfo(3);
	local functionName = funcInfo.name;

	local functionCallLocalVariables = {};
	local idx = 1;
	while true do
		local name, value = getlocal(3, idx)
		if name then
			functionCallLocalVariables[name] = value;
			idx = idx + 1;
		else
			break;
		end
	end

	local argHook = function( ... )
		local info = getinfo(3)
		if 'pcall' ~= info.name then
			return
		end

		for i = 1, huge do
			local name, value = getlocal(2, i)
			if '(*temporary)' == name then
				sethook(hook)
				error('')
				return
			end
			tinsert(args, name)
		end
	end

	sethook(argHook, "c")
	pcall(funcInfo.func)

	local functionDeclaration = functionName .. "(" .. tconcat(args, ", ") .. ")";

	local formattedArgs = "\nParameters:\n";
	for _, argName in pairs(args) do
		local value = functionCallLocalVariables[argName];
		formattedArgs = formattedArgs .. format("%s: %s (type: %s)", argName, value, type(value)) ..  "\n";
	end

	return functionDeclaration, formattedArgs;
end

local PARAMETER_TYPE_ERROR_MESSAGE = [[
Invalid parameter type "%1$s" for parameter "%2$s" in function "%3$s".
Expected type for parameter "%2$s" is "%4$s".
]]

---Check that the type of the parameter is what we want.
---@param parameterValue any @ The actual value of the parameter, will be checked for its type
---@param parameterName string @ The name of the parameter, will be shown in the error message
---@param requiredType string @ The type reqyired for the parameter
function Debug.assertType(parameterValue, parameterName, requiredType)
	local parameterType = type(parameterValue);

	if parameterType ~= requiredType then
		local functionDeclaration, parameters = Debug.getFunctionInfo();
		error(format(PARAMETER_TYPE_ERROR_MESSAGE, parameterType, parameterName, functionDeclaration, requiredType) .. parameters);
	end
end

local NIL_PARAMETER_ERROR_MESSAGE = [[
Unexpected nil parameter "%1$s" in function "%2$s".
]]

---Check that the value of the parameter is not null
---@param parameterValue any @ The actual value of the parameter
---@param parameterName string @ The name of the parameter, will be shown in the error message
function Debug.assertNotNil(parameterValue, parameterName)
	if parameterValue == nil then
		local functionDeclaration, parameters = Debug.getFunctionInfo();
		error(format(NIL_PARAMETER_ERROR_MESSAGE, parameterName, functionDeclaration) .. parameters);
	end
end