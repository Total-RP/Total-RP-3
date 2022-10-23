-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3_API.loc;

TRP3_API.module.registerModule({
	["name"] = "TipTac",
	["id"] = "trp3_tiptac",
	["description"] = loc.MO_TOOLTIP_CUSTOMIZATIONS_DESCRIPTION:format("TipTac"),
	["version"] = 1.200,
	["minVersion"] = 25,
	["onStart"] = function()

		-- Stop right here if TipTac is not installed
		if not TipTac then
			return false, loc.MO_ADDON_NOT_INSTALLED:format("TipTac");
		end

		-- List of the tooltips we want to be customized by TipTac
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
		TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_FINISH, function()

			-- Go through each tooltips from our table
			for _, tooltip in pairs(TOOLTIPS) do
				if _G[tooltip] then -- We check that the tooltip exists and then add it to TipTac
					TipTac:AddModifiedTip(_G[tooltip]);
				end
			end

		end);
	end,
});
