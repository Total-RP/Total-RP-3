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

local function slightlyCustomizeReportingFrame()
    PlayerReportFrame:SetHeight(254)
    PlayerReportFrame.Comment:SetHeight(120)
    PlayerReportFrame.CommentBox:SetMaxLetters(250);
end

local REPORT_ICON = Ellyb.Icon([[Interface\HelpFrame\HelpIcon-OpenTicket]]);

TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()
    TRP3_API.target.registerButton({
        id = "zzzzzzzzzz_player_report",
        configText = loc.REG_REPORT_PLAYER_PROFILE,
        onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
        condition = function(_, unitID)
            return UnitIsPlayer("target") and unitID ~= TRP3_API.globals.player_id
        end,
        onClick = function()
            local DATE_FORMAT = "%Y-%m-%d around %H:%M";
            local playerID = TRP3_API.utils.str.getUnitID("target");
            local profile = TRP3_API.register.getUnitIDProfile(playerID)
            local characterInfo = TRP3_API.register.getUnitIDCharacter(playerID);

            assert(profile, "Something went wrong, could not retrieve the profile.")
            assert(characterInfo, "Something went wrong, could not retrieve the information about the player linked to this profile.")
            assert(profile.link and Ellyb.Tables.size(profile.link) > 0, "Something went wrong, could not retrieve the players linked to this profile.")

            local playerLocation = PlayerLocation:CreateFromUnit("target");

            slightlyCustomizeReportingFrame()
            PlayerReportFrame:InitiateReport(PLAYER_REPORT_TYPE_LANGUAGE, playerID, playerLocation);

            -- Use reporting template
            local commentText = loc.REG_REPORT_PLAYER_TEMPLATE:format(characterInfo.client);

            -- Add information about the last time we saw this profile, if we have the info
            if profile.time then
                commentText = commentText .. "\n" .. loc.REG_REPORT_PLAYER_TEMPLATE_DATE:format(date(DATE_FORMAT, profile.time));
            end

            -- Indicate if this was a trial account if we have that info
            if characterInfo.isTrial then
                commentText = commentText .. "\n" .. loc.REG_REPORT_PLAYER_TEMPLATE_TRIAL_ACCOUNT;
            end
            PlayerReportFrame.CommentBox:SetText(commentText);
        end,
        tooltip =  REPORT_ICON:GenerateString(25) .. loc.REG_REPORT_PLAYER_PROFILE,
        tooltipSub = loc.REG_REPORT_PLAYER_PROFILE_TT,
        icon = REPORT_ICON
    });
end)
