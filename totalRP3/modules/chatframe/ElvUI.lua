----------------------------------------------------------------------------------
--- Total RP 3
--- ElvUI chat compatibility plugin
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

---@type TRP3_API
local _, TRP3_API = ...;

local loc = TRP3_API.loc;

local function onStart()
	-- Stop right here if ElvUI is not installed
	if not ElvUI then
		return false, loc.MO_ADDON_NOT_INSTALLED:format("ElvUI");
	end

	local ElvUI = ElvUI[1];
	local ElvUIChatModule = ElvUI:GetModule("Chat", true);
	if not ElvUIChatModule then
		return false, "Your version of ElvUI doesn't need this module to function.";
	end
	local ElvUIGetColoredName = ElvUIChatModule.GetColoredName;

	if not ElvUIGetColoredName then
		return false, "Your version of ElvUI doesn't need this module to function.";
	end

	-- Build the fallback, using ElvUI's function
	local function fallback(...)
		return ElvUIGetColoredName(ElvUIChatModule, ...);
	end

	-- Replace ElvUI's GetColoredName
	function ElvUIChatModule:GetColoredName(...)
		return TRP3_API.utils.customGetColoredNameWithCustomFallbackFunction(fallback, ...);
	end
end

-- Register a Total RP 3 module that can be disabled in the settings
TRP3_API.module.registerModule({
	["name"] = "ElvUI",
	["description"] = loc.MO_CHAT_CUSTOMIZATIONS_DESCRIPTION:format("ElvUI"),
	["version"] = 1.0,
	["id"] = "trp3_elvui_chat",
	["onStart"] = onStart,
	["minVersion"] = 48,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});
