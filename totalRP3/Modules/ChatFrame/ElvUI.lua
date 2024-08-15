-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

local loc = TRP3_API.loc;

local function onStart()
	-- Stop right here if ElvUI is not installed
	if not ElvUI then
		return TRP3_API.module.status.MISSING_DEPENDENCY, loc.MO_ADDON_NOT_INSTALLED:format("ElvUI");
	end

	local ElvUI = ElvUI[1];
	local ElvUIChatModule = ElvUI:GetModule("Chat", true);
	if not ElvUIChatModule then
		return TRP3_API.module.status.MISSING_DEPENDENCY, "Your version of ElvUI doesn't need this module to function.";
	end
	local ElvUIGetColoredName = ElvUIChatModule.GetColoredName;

	if not ElvUIGetColoredName then
		return TRP3_API.module.status.MISSING_DEPENDENCY, "Your version of ElvUI doesn't need this module to function.";
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
	["name"] = "ElvUI Chat",
	["description"] = loc.MO_CHAT_CUSTOMIZATIONS_DESCRIPTION:format("ElvUI"),
	["version"] = 1.0,
	["id"] = "trp3_elvui_chat",
	["onStart"] = onStart,
	["minVersion"] = 48,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});
