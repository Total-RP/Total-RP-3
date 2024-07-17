-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = TRP3_API.Ellyb;

local loc = TRP3_API.loc;

local REPORT_ICON = Ellyb.Icon([[Interface\HelpFrame\HelpIcon-OpenTicket]]);

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	if not TRP3_API.target then
		-- Target bar module disabled.
		return;
	end

	TRP3_API.target.registerButton({
		id = "zzzzzzzzzz_player_report",
		configText = loc.REG_REPORT_PLAYER_PROFILE,
		onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
		condition = function(_, unitID)
			return UnitIsPlayer("target") and unitID ~= TRP3_API.globals.player_id
		end,
		onClick = function()
			local playerID = TRP3_API.utils.str.getUnitID("target");
			local profile = TRP3_API.register.getUnitIDProfile(playerID)

			local reportText = loc.REG_REPORT_PLAYER_OPEN_URL_160:format(playerID);
			if profile.time then
				local DATE_FORMAT = "%Y-%m-%d around %H:%M";
				reportText = reportText .. "\n\n" .. loc.REG_REPORT_PLAYER_TEMPLATE_DATE:format(date(DATE_FORMAT, profile.time));
			end
			Ellyb.Popups:OpenURL("https://battle.net/support/help/product/wow/197/1501/solution", reportText, nil, loc.COPY_SYSTEM_MESSAGE);
		end,
		tooltip =  REPORT_ICON:GenerateString(25) .. loc.REG_REPORT_PLAYER_PROFILE,
		tooltipSub = loc.REG_REPORT_PLAYER_PROFILE_TT,
		iconFile = REPORT_ICON
	});
end)
