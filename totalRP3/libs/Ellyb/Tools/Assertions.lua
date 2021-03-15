---@type Ellyb
local Ellyb = Ellyb(...)

if Ellyb.Assertions then
	return
end

--- Various assertion functions to check if variables are of a certain type, empty, nil etc.
--- These assertions will directly raise an error if the test is not met.
local Assertions = {}

--{{{ Helpers

--- Throws an error in the parent's scope
---@param message string
local function throw(message)
	error(message, 3)
end

---@param variable UIObject
local function isUIObject(variable)
	return type(variable) == "table" and type(variable.GetObjectType) == "function"
end

---@param variable MiddleClass_Class
local function isAClass(variable)
	return type(variable) == "table" and type(variable.isInstanceOf) == "function"
end

---@param t table
---@return string
local function list(t)
	return table.concat(t, ", ")
end

--}}}

--- Check if a variable is of the expected type ("number", "boolean", "string")
--- Can also check for Widget type ("Frame", "Button", "Texture")
---@param variable any|UIObject Any kind of variable, to be tested for its type
---@param expectedType string Expected type of the variable
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isType(variable, expectedType, variableName)
	if isUIObject(variable) then
		if not variable:IsObjectType(expectedType) then
			throw(([[Invalid Widget type "%s" for variable "%s", expected a "%s".]]):format(variable:GetObjectType(), variableName, expectedType))
		end
	elseif type(variable) ~= expectedType then
		throw(([[Invalid variable type "%s" for variable "%s", expected "%s".]]):format(type(variable), variableName, expectedType))
	end
	return true
end

---Check if a variable is of one of the types expected ("number", "boolean", "string")
------Can also check for Widget types ("Frame", "Button", "Texture")
---@param variable any|UIObject Any kind of variable, to be tested for its type
---@param expectedTypes string[] A list of expected types for the variable
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isOfTypes(variable, expectedTypes, variableName)
	if isUIObject(variable) and not tContains(expectedTypes, variable:GetObjectType()) then
		throw(([[Invalid Widget type "%s" for variable "%s", expected one of {%s}.]]):format(variable:GetObjectType(), variableName, list(expectedTypes)))
	end
	if not tContains(expectedTypes, type(variable)) then
		throw(([[Invalid variable type "%s" for variable "%s", expected one of {%s}.]]):format(type(variable), variableName, list(expectedTypes)))
	end
	return true
end

---Check if a variable is not nil
---@param variable any Any kind of variable, will be checked if it is nil
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was not nil, or false with an error message if it wasn't.
function Assertions.isNotNil(variable, variableName)
	if variable == nil then
		throw(([[Unexpected nil variable "%s".]]):format(variableName))
	end
	return true
end

---Check if a variable is empty
---@param variable any Any kind of variable that can be checked to be empty
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was not empty, or false with an error message if it was.
function Assertions.isNotEmpty(variable, variableName)
	if variable == nil then
		throw(([[Variable "%s" cannot be empty.]]):format(variableName))
	end
	-- To check if a table is empty we can just try to get its next field
	if type(variable) == "table" and not next(variable) then
		throw(([[Variable "%s" cannot be an empty table.]]):format(variableName))
	end

	-- A string is considered empty if it is equal to empty string ""
	if type(variable) == "string" and variable == "" then
		throw(([[Variable "%s" cannot be an empty string.]]):format(variableName))
	end
	return true
end

--- Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.
---@param variable MiddleClass_Class The object to test
---@param class MiddleClass_Class A direct reference to the expected class
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.isInstanceOf(variable, class, variableName)
	if not isAClass(variable) then
		throw(([[Invalid type "%s" for variable "%s", expected a "%s".]]):format(type(variable), variableName, tostring(class)))
	end
	if not variable:isInstanceOf(class) then
		throw(([[Invalid Class "%s" for variable "%s", expected "%s".]]):format(tostring(variable.class), variableName, tostring(class)))
	end
	return true
end


--- Check if a variable value is one of the possible values.
---@param variable any Any kind of variable, will be checked if it's value is in the list of possible values
---@param possibleValues table A table of the possible values accepted
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.isOneOf(variable, possibleValues, variableName)
	if not tContains(possibleValues, variable) then
		throw(([[Unexpected variable value %s for variable "%s", expected to be one of {%s}.]]):format(tostring(variable), variableName, list(possibleValues)))
	end
	return true
end

--- Check if a variable is a number between a maximum and a minimum
---@param variable number A number to check
---@param minimum number The minimum value for the number
---@param maximum number The maximum value for the number
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.numberIsBetween(variable, minimum, maximum, variableName)

	-- Variable has to be a number to do comparison
	if type(variable) ~= "number" then
		throw(([[Invalid variable type "%s" for variable "%s", expected "number".]]):format(type(variable), variableName))
	end

	if variable < minimum or variable > maximum then
		throw(([[Invalid variable value "%s" for variable "%s". Expected the value to be between "%s" and "%s"]]):format(variable, variableName, minimum, maximum))
	end

	return true
end

Ellyb.Assertions = Assertions;
