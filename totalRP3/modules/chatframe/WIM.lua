----------------------------------------------------------------------------------
--- Total RP 3
--- WIM plugin
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local loc = TRP3_API.locale.getText;

local function onStart()
	-- Stop right here if WIM is not installed
	if not WIM then
		return false, loc("MO_ADDON_NOT_INSTALLED"):format("WIM");
	end
	
	-- Import Total RP 3 functions
	local customGetColoredNameWithCustomFallbackFunction = TRP3_API.utils.customGetColoredNameWithCustomFallbackFunction;
	local playerID                                       = TRP3_API.globals.player_id;
	local getFullnameForUnitUsingChatMethod              = TRP3_API.chat.getFullnameForUnitUsingChatMethod; -- Get full name using settings
	local getClassColor 								 = TRP3_API.utils.color.getClassColor;
	local getUnitCustomColor							 = TRP3_API.utils.color.getUnitCustomColor;
	local increaseColorContrast							 = TRP3_API.chat.configIncreaseNameColorContrast;
	local configShowNameCustomColors					 = TRP3_API.chat.configShowNameCustomColors
	local getData 										 = TRP3_API.profile.getData;
	local UnitClass 									 = UnitClass;
	local getConfigValue 								 = TRP3_API.configuration.getValue;
	local icon 											 = TRP3_API.utils.str.icon;
	local playerName									 = TRP3_API.globals.player;

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
		local name = getFullnameForUnitUsingChatMethod(playerID, playerName);
		local _, playerClass = UnitClass("Player");
		local color = configShowNameCustomColors() and getUnitCustomColor(playerID) or getClassColor(playerClass);
	
		if increaseColorContrast() then
			color:LightenColorUntilItIsReadable();
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
TRP3_API.module.registerModule({
	["name"] = "WIM",
	["description"] = loc("MO_CHAT_CUSTOMIZATIONS_DESCRIPTION"):format("WIM (WoW Instant Messenger"),
	["version"] = 1.000,
	["id"] = "trp3_wim",
	["onStart"] = onStart,
	["minVersion"] = 25,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});