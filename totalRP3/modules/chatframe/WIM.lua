local function onStart()
	-- Stop right here if WIM is not installed
	if not WIM then return false, "WIM not found." end
	
	-- Import Total RP 3 functions
	local customGetColoredNameWithCustomFallbackFunction = TRP3_API.utils.customGetColoredNameWithCustomFallbackFunction;
	local playerID                                       = TRP3_API.globals.player_id;
	local getUnitColor                                   = TRP3_API.utils.color.getUnitColor; -- Get unit color (custom or default)
	local getFullnameForUnitUsingChatMethod              = TRP3_API.chat.getFullnameForUnitUsingChatMethod; -- Get full name using settings

	local classes = WIM.constants.classes;

	-- We store WIM's custom GetColoredName function as we will send it as a fallback to TRP3's GetColoredName function
	local WIMsGetColoredNameFunction = classes.GetColoredNameByChatEvent;

	-- Replace WIM's GetColoredName function by our own to display RP names and fallback to WIM's GetColoredName function
	-- if we couldn't handle the name ourselves.
	classes.GetColoredNameByChatEvent = function(...)
		return customGetColoredNameWithCustomFallbackFunction(WIMsGetColoredNameFunction, ...);
	end;

	-- Replace WIM's GetMyColoredName to display our full RP name
	classes.GetMyColoredName = function()
		local name = getFullnameForUnitUsingChatMethod(playerID);
		local color = getUnitColor(playerID);
		return color:WrapTextInColorCode(name);
	end
end

-- Register a Total RP 3 module that can be disabled in the settings
TRP3_API.module.registerModule({
	["name"] = "WIM support",
	["description"] = "Add support for the WoW Instant Messenger (WIM) add-on.",
	["version"] = 1.000,
	["id"] = "trp3_wim",
	["onStart"] = onStart,
	["minVersion"] = 25,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});