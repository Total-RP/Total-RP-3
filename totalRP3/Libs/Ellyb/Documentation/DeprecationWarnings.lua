---@type Ellyb
local Ellyb = Ellyb(...);

-- IDE shortcut to go to module
local _ = Ellyb.DeprecationWarnings;

Ellyb.Documentation:AddDocumentationTable("Ellyb.DeprecationWarnings", {
	Name = "Ellyb.DeprecationWarnings",
	Type = "System",
	Namespace = "Ellyb.DeprecationWarnings",

	Functions = {
		{
			Name = "wrapAPI",
			Type = "Function",
			Documentation = { "Create a new table that will throw deprecation warnings and use a given new API table to map a previous API now deprecated." },

			Arguments = {
				{ Name = "newAPITable", Type = "table", Nilable = false, Documentation = { "The table for the new API." } },
				{ Name = "oldAPIName", Type = "string", Nilable = false, Documentation = { "The name of the deprecated API." } },
				{ Name = "newAPIName", Type = "string", Nilable = false, Documentation = { "The name of the new API." } },
				{ Name = "oldAPIReference", Type = "table", Nilable = true, Documentation = { "An existing table that should be used to wrap with the new API warnings." } },
			},

			Returns =
			{
				{ Name = "wrappedAPI", Type = "table", Nilable = false, Documentation = { "This table can be used to access the new API while throwing deprecation warnings." }  },
			},
		},
		{
			Name = "wrapFunction",
			Type = "Function",
			Documentation = { "Create a new function that will throw deprecation warnings and use a given new function to map a previous API functions now deprecated." },

			Arguments = {
				{ Name = "newFunction", Type = "function", Nilable = false, Documentation = { "The new function that should be called instead of the deprecated one." } },
				{ Name = "oldFunctionName", Type = "string", Nilable = false, Documentation = { "The name of the deprecated function." } },
				{ Name = "newFunctionName", Type = "string", Nilable = false, Documentation = { "The name of the new function." } },
			},

			Returns =
			{
				{ Name = "wrappedFunction", Type = "function", Nilable = false, Documentation = { "Calling this function will call the new function and throw a deprecation warning." }  },
			},
		},
		{
			Name = "warn",
			Type = "Function",
			Documentation = { "Send a custom deprecation warning." },

			Arguments = {
				{ Name = "customWarning", Type = "string", Nilable = false, Documentation = { "A custom message to display as a warning." } },

			},
		},
	},
})
