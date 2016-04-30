----------------------------------------------------------------------------------
-- Total RP 3
-- Roleplay status databroker plugin
--	---------------------------------------------------------------------------
--	Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- TRP3_API import
local icon, color = TRP3_API.utils.str.icon, TRP3_API.utils.str.color;
local loc = TRP3_API.locale.getText;
local playUISound = TRP3_API.ui.misc.playUISound;
local get = TRP3_API.profile.getData;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local selectProfile = TRP3_API.profile.selectProfile;
local getProfiles = TRP3_API.profile.getProfiles;
local currentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local switchStatus = TRP3_API.dashboard.switchStatus;
local iconProfileDefault = TRP3_API.globals.icons.profile_default;

-- WoW functions
local ShowingHelm, ShowHelm = ShowingHelm, ShowHelm;

local iconOn = "Interface\\ICONS\\spell_shadow_charm";
local iconOff = "Interface\\ICONS\\Inv_misc_grouplooking";

local RPTitleOn = icon("spell_shadow_charm", 25) .. " ".. loc("TB_RPSTATUS_ON");
local RPTitleOff = icon("Inv_misc_grouplooking", 25) .. " ".. loc("TB_RPSTATUS_OFF");
local profilesText = "\n" .. color("y") .. loc("CM_R_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_PROFILE");
local RPTextOn = color("y") .. loc("CM_L_CLICK") .. ": " .. color("w") .. loc("TB_RPSTATUS_TO_OFF") .. profilesText;
local RPTextOff = color("y") .. loc("CM_L_CLICK") .. ": " .. color("w") .. loc("TB_RPSTATUS_TO_ON") .. profilesText;

local tooltipTitle = "";
local tooltipText = "";

local function onUpdate(LDBObject)
	if get("player/character/RP") == 1 then
		LDBObject.icon = iconOn;
		tooltipTitle = RPTitleOn;
		tooltipText = RPTextOn;
	else
		LDBObject.icon = iconOff;
		tooltipTitle = RPTitleOff;
		tooltipText = RPTextOff;
	end
end

local function onClick(clickedframe, button)
	if button == "RightButton" then
		local list = getProfiles();

		local dropdownItems = {};
		tinsert(dropdownItems,{loc("TB_SWITCH_PROFILE"), nil});
		local profileID = currentProfileID();
		for key, value in pairs(list) do
			local icon = value.player.characteristics.IC or iconProfileDefault;
			if key == profileID then
				tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t|cff00ff00 "..value.profileName.."|r", nil});
			else
				tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t "..value.profileName, key});
			end
		end
		displayDropDown(clickedframe, dropdownItems, selectProfile, 0, true);
	else
		switchStatus();
		playUISound("igMainMenuOptionCheckBoxOn");
	end
end

local function onTooltipShow(tooltip)
	tooltip:AddLine(tooltipTitle);
	tooltip:AddLine(tooltipText);
end

TRP3_API.databroker.registerButton(loc("DTBK_RP"), {
	icon = "TEMP",
	OnClick = onClick,
	OnTooltipShow = onTooltipShow,
	OnUpdate = onUpdate
});