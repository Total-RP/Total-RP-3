-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3_API.loc;

TRP3_API.module.registerModule({
	["name"] = "TinyTooltip",
	["id"] = "trp3_tinytooltip",
	["description"] = loc.MO_TOOLTIP_CUSTOMIZATIONS_DESCRIPTION:format("TinyTooltip"),
	["version"] = 1.000,
	["minVersion"] = 25,
	["onStart"] = function()

		-- Check if the add-on TinyTooltip is installed
		if not TinyTooltip then
			return TRP3_API.module.status.MISSING_DEPENDENCY,  loc.MO_ADDON_NOT_INSTALLED:format("TinyTooltip");
		end

		-- List of the tooltips we want to be customized by TinyTooltips
		local TOOLTIPS = {
			-- Total RP 3
			"TRP3_MainTooltip",
			"TRP3_CharacterTooltip",
			"TRP3_CompanionTooltip",
			-- Total RP 3: Extended
			"TRP3_ItemTooltip",
			"TRP3_NPCTooltip"
		}

		-- Wait for the add-on to be fully loaded so all the tooltips are available
		TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()

			-- Get the LibEvent used by TinyTooltip
			local LibEvent = LibStub:GetLibrary("LibEvent.7000");

			-- Go through each tooltips from our table
			for _, tooltip in pairs(TOOLTIPS) do
				if _G[tooltip] then -- We check that the tooltip exists and then add it to TinyTooltips
					-- Ask TinyTooltip to skin the tooltip
					LibEvent:trigger("tooltip.style.init", _G[tooltip]);
				end
			end

		end);
	end,
});
