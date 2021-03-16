---@type Ellyb
local Ellyb = Ellyb(...);

-- IDE shortcut to go to module
local _ = Ellyb.GameEvents;

Ellyb.Documentation:AddDocumentationTable("Ellyb.GameEvents", {
	Name = "Ellyb.GameEvents",
	Type = "System",
	Namespace = "Ellyb.GameEvents",

	Functions = {
		{
			Name = "registerCallback",
			Type = "Function",
			Documentation = { "Register a callback for a game event." },

			Arguments = {
				{ Name = "event", Type = "string", Nilable = false, Documentation = { "A game event to listen to." } },
				{ Name = "callback", Type = "function", Nilable = false, Documentation = { "A callback that will be called when the event is fired with its arguments." } },
			},

			Returns =
			{
				{ Name = "handlerID", Type = "string", Nilable = false, Documentation = { "A handler ID that can be used to unregister the callback later." }  },
			},
		},
		{
			Name = "unregisterCallback",
			Type = "Function",
			Documentation = { "Unregister a previously registered callback using the handler ID given at registration." },

			Arguments = {
				{ Name = "handlerID", Type = "string", Nilable = false, Documentation = { "The handler ID of a previsouly registered callback that we want to unregister." } },
			},
		},

		{
			Name = "triggerEvent",
			Type = "Function",
			Documentation = { "Register a callback for a game event." },

			Arguments = {
				{ Name = "event", Type = "string", Nilable = false, Documentation = { "A game event to manually trigger." } },
				{ Name = "...", Type = "any", Nilable = false, Documentation = { "Arguments to pass to the listeners" } },
			},
		},
	},
})
