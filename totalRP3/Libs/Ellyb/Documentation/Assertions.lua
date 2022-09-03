---@type Ellyb
local Ellyb = Ellyb(...);

-- IDE shortcut to quickly go to related module
local _ = Ellyb.Assertions;

Ellyb.Documentation:AddDocumentationTable("Ellyb.Assertions", {
	Name = "Ellyb.Assertions",
	Type = "System",
	Namespace = "Ellyb.Assertions",

	Functions = {
		{
			Name = "isType",
			Type = "Function",
			Documentation = { [[Check if a variable is of the expected type ("number", "boolean", "string")
Can also check for Widget type ("Frame", "Button", "Texture")]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "expectedType", Type = "string", Documentation = { "Expected type of the variable" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},
		},
		{
			Name = "isOfTypes",
			Type = "Function",
			Documentation = { [[Check if a variable is of one of the types expected ("number", "boolean", "string")
Can also check for Widget types ("Frame", "Button", "Texture")]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "expectedTypes", Type = "table", Documentation = { "A list of expected types for the variable" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},
		},
		{
			Name = "isNotNil",
			Type = "Function",
			Documentation = { [[Check if a variable is not nil]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},
		},
		{
			Name = "isNotEmpty",
			Type = "Function",
			Documentation = { [[Check if a variable is not empty]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

		},
		{
			Name = "isInstanceOf",
			Type = "Function",
			Documentation = { [[Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "class", Type = "string", Documentation = { "A direct reference to the class definition" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

		},
		{
			Name = "isOneOf",
			Type = "Function",
			Documentation = { [[Check if a variable value is one of the possible values.]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its content" } },
				{ Name = "possibleValues", Type = "table", Documentation = { "A table of the possible values accepted" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

		},
		{
			Name = "numberIsBetween",
			Type = "Function",
			Documentation = { [[Check if a variable is a number between a maximum and a minimum.]] },

			Arguments = {
				{ Name = "variable", Type = "number", Documentation = { "A number to check" } },
				{ Name = "minimum", Type = "number", Documentation = { "The minimum value for the number" } },
				{ Name = "maximum", Type = "number", Documentation = { "The maximum value for the number" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

		},
	},
});
