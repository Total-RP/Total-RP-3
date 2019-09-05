-------------------------------------------------------------------------------
--- Total RP 3
--- Report profile button
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local Ellyb = Ellyb(...);

local loc = TRP3_API.loc;

local REPORT_ICON = Ellyb.Icon([[Interface\HelpFrame\HelpIcon-OpenTicket]]);

TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()
	if not TRP3_API.target then
		-- Target bar module disabled.
		return;
	end

	TRP3_API.target.registerButton({
		id = "zzzzzzzzzz_player_report",
		configText = loc.REG_REPORT_PLAYER_PROFILE,
		onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
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
			Ellyb.Popups:OpenURL("https://battle.net/support/help/product/wow/197/1501/solution", reportText);
		end,
		tooltip =  REPORT_ICON:GenerateString(25) .. loc.REG_REPORT_PLAYER_PROFILE,
		tooltipSub = loc.REG_REPORT_PLAYER_PROFILE_TT,
		icon = REPORT_ICON
	});
end)
