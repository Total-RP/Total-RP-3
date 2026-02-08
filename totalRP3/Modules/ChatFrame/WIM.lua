-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3.loc;

local function onStart()
	-- Stop right here if WIM is not installed
	if not WIM then
		return TRP3.module.status.MISSING_DEPENDENCY, loc.MO_ADDON_NOT_INSTALLED:format("WIM");
	end

	-- Import Total RP 3 functions
	local playerID = TRP3.globals.player_id;
	local getFullnameForUnitUsingChatMethod = TRP3.chat.getFullnameForUnitUsingChatMethod; -- Get full name using settings
	local configShowNameCustomColors = TRP3.chat.configShowNameCustomColors
	local getData = TRP3.profile.getData;
	local getConfigValue = TRP3.configuration.getValue;
	local icon = TRP3.utils.str.icon;
	local playerName = TRP3.globals.player;
	local disabledByOOC = TRP3.chat.disabledByOOC;

	local classes = WIM.constants.classes;

	-- We store WIM's custom GetColoredName function as we will send it as a fallback to TRP3's GetColoredName function
	local WIMsGetColoredNameFunction = classes.GetColoredNameByChatEvent;

	-- Replace WIM's GetColoredName function by our own to display RP names and fallback to WIM's GetColoredName function
	-- if we couldn't handle the name ourselves.
	classes.GetColoredNameByChatEvent = function(event, ...)
		return TRP3.utils.customGetColoredName(event, nil, ...) or WIMsGetColoredNameFunction(event, ...);
	end;

	-- Replace WIM's GetMyColoredName to display our full RP name
	local oldWIMGetMyColoredName = classes.GetMyColoredName;
	classes.GetMyColoredName = function()
		if disabledByOOC() then
			return oldWIMGetMyColoredName();
		end

		local name = getFullnameForUnitUsingChatMethod(playerID) or playerName;
		local color = TRP3.GetClassDisplayColor((UnitClassBase("player")));

		if configShowNameCustomColors() then
			local player = TRP3.Player.GetCurrentUser();
			local customColor = player:GetCustomColorForDisplay();

			if customColor then
				color = customColor;
			end
		end

		name = color:WrapTextInColorCode(name);

		if getConfigValue("chat_show_icon") then
			local info = getData("player");
			if info and info.characteristics and info.characteristics.IC then
				name = icon(info.characteristics.IC, 15) .. " " .. name;
			end
		end

		return name;
	end
end

-- Register a Total RP 3 module that can be disabled in the settings
TRP3.module.registerModule({
	["name"] = "WIM",
	["description"] = loc.MO_CHAT_CUSTOMIZATIONS_DESCRIPTION:format("WIM (WoW Instant Messenger"),
	["version"] = 1.000,
	["id"] = "trp3_wim",
	["onStart"] = onStart,
	["minVersion"] = 25,
	["requiredDeps"] = {
		{ "trp3_chatframes", 1.100 },
	}
});
