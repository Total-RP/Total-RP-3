----------------------------------------------------------------------------------
-- Total RP 3
-- Cloak databroker plugin
--	---------------------------------------------------------------------------
--	Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
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

-- WoW functions
local ShowingCloak, ShowCloak = ShowingCloak, ShowCloak;

local iconOn = "Interface\\ICONS\\INV_Misc_Cape_18";
local iconOff = "Interface\\ICONS\\item_icecrowncape";

local cloakTitleOn = icon("INV_Misc_Cape_18", 25) .. " ".. loc("TB_SWITCH_CAPE_ON");
local cloakTitleOff = icon("item_icecrowncape", 25) .. " ".. loc("TB_SWITCH_CAPE_OFF");
local cloakTextOn = color("y") .. loc("CM_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_CAPE_1");
local cloakTextOff = color("y") .. loc("CM_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_CAPE_2");

local tooltipTitle = "";
local tooltipText = "";

local function onUpdate(LDBObject)
	if ShowingCloak() then
		LDBObject.icon = iconOn;
		tooltipTitle = cloakTitleOn;
		tooltipText = cloakTextOn;
	else
		LDBObject.icon = iconOff;
		tooltipTitle = cloakTitleOff;
		tooltipText = cloakTextOff;
	end
end

local function onClick()
	if ShowingCloak() then
		ShowCloak(false);
		playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);
	else
		ShowCloak(true);
		playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
	end
end

local function onTooltipShow(tooltip)
	tooltip:AddLine(tooltipTitle);
	tooltip:AddLine(tooltipText);
end

TRP3_API.databroker.registerButton(loc("DTBK_CLOAK"), {
	icon = "TEMP",
	OnClick = onClick,
	OnTooltipShow = onTooltipShow,
	OnUpdate = onUpdate
});