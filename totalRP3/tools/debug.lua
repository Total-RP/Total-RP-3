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

---@type AddOn
local _, AddOn = ...;

---@class TRP3_Debug
--- # Total RP 3 Debug
---
local Debug = {};
AddOn.Debug = Debug;

--- WoW imports
local error = error;
local type = type;
local format = string.format;

local PARAMETER_TYPE_ERROR_MESSAGE = [[
Invalid parameter type "%1$s" for parameter "%2$s" in function "%3$s".
Expected type for parameter "%2$s" is "%4$s".
]]

---Check that the type of the parameter is what we want.
---@param parameterValue any @ The actual value of the parameter, will be checked for its type
---@param parameterName string @ The name of the parameter, will be shown in the error message
---@param requiredType string @ The type reqyired for the parameter
function Debug.assertType(parameterValue, parameterName, requiredType, functionDeclaration)
	local parameterType = type(parameterValue);

	if parameterType ~= requiredType then
		if not functionDeclaration then
			functionDeclaration = UNKNOWN
		end
		error(format(PARAMETER_TYPE_ERROR_MESSAGE, parameterType, parameterName, functionDeclaration, requiredType));
	end
end

local NIL_PARAMETER_ERROR_MESSAGE = [[
Unexpected nil parameter "%1$s" in function "%2$s".
]]

---Check that the value of the parameter is not null
---@param parameterValue any @ The actual value of the parameter
---@param parameterName string @ The name of the parameter, will be shown in the error message
function Debug.assertNotNil(parameterValue, parameterName, functionDeclaration)
	if parameterValue == nil then
		if not functionDeclaration then
			functionDeclaration = UNKNOWN
		end
		error(format(NIL_PARAMETER_ERROR_MESSAGE, parameterName, functionDeclaration));
	end
end