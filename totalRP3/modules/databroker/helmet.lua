----------------------------------------------------------------------------------
-- Total RP 3
-- Helmet databroker plugin
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

-- WoW functions
local ShowingHelm, ShowHelm = ShowingHelm, ShowHelm;

local iconOn = "Interface\\ICONS\\INV_Helmet_13";
local iconOff = "Interface\\ICONS\\Spell_Arcane_MindMastery";

local helmTitleOn = icon("INV_Helmet_13", 25) .. " ".. loc("TB_SWITCH_HELM_ON");
local helmTitleOff = icon("Spell_Arcane_MindMastery", 25) .. " ".. loc("TB_SWITCH_HELM_OFF");
local helmTextOn = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_1");
local helmTextOff = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_2");

local tooltipTitle = "";
local tooltipText = "";

TRP3_API.databroker.registerButton(loc("DTBK_HELMET"), {
	icon = "TEMP",
	OnClick = function()
        if ShowingHelm() then
            ShowHelm(false);
            playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);
        else
            ShowHelm(true);
            playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
        end
    end,
	OnTooltipShow = function (tooltip)
        tooltip:AddLine(tooltipTitle);
        tooltip:AddLine(tooltipText);
    end,
	OnUpdate = function (LDBObject)
        if ShowingHelm() then
            LDBObject.icon = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("HeadSlot"))) or iconOn;
            tooltipTitle = helmTitleOn;
            tooltipText = helmTextOn;
        else
            LDBObject.icon = iconOff;
            tooltipTitle = helmTitleOff;
            tooltipText = helmTextOff;
        end
    end
});