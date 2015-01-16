----------------------------------------------------------------------------------
-- Total RP 3
-- AFK/DND databroker plugin
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
local UnitIsAFK, UnitIsDND = UnitIsAFK, UnitIsDND;
local SendChatMessage = SendChatMessage;

local DNDTitle = icon("Ability_Mage_IncantersAbsorbtion", 25).." "..color("w")..loc("TB_STATUS")..": "..color("r")..loc("TB_DND_MODE");
local DNDText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
local DNDIcon = "Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion";

local AFKTitle = icon("Spell_Nature_Sleep", 25).." "..color("w")..loc("TB_STATUS")..": "..color("o")..loc("TB_AFK_MODE");
local AFKText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
local AFKIcon = "Interface\\ICONS\\Spell_Nature_Sleep";

local normalTitle = icon("Ability_Rogue_MasterOfSubtlety", 25).." "..color("w")..loc("TB_STATUS")..": "..color("g")..loc("TB_NORMAL_MODE");
local normalText = color("y")..loc("CM_L_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("o")..loc("TB_AFK_MODE")..color("w"))).."\n"..color("y")..loc("CM_R_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("r")..loc("TB_DND_MODE")..color("w")));
local normalIcon = "Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety";


local tooltipTitle = "";
local tooltipText = "";

local function onUpdate(LDBObject)
	if UnitIsDND("player") then
		tooltipTitle = DNDTitle;
		tooltipText = DNDText;
		LDBObject.icon = DNDIcon;
	elseif UnitIsAFK("player") then
		tooltipTitle = AFKTitle;
		tooltipText = AFKText;
		LDBObject.icon = AFKIcon;
	else
		tooltipTitle = normalTitle;
		tooltipText = normalText;
		LDBObject.icon = normalIcon;
	end
end

local function onClick(clickedframe, button)
	if UnitIsAFK("player") then
		SendChatMessage("","AFK");
	elseif UnitIsDND("player") then
		SendChatMessage("","DND");
	else
		if button == "LeftButton" then
			SendChatMessage("","AFK");
		else
			SendChatMessage("","DND");
		end
	end
	playUISound("igMainMenuOptionCheckBoxOn");
end

local function onTooltipShow(tooltip)
	tooltip:AddLine(tooltipTitle);
	tooltip:AddLine(tooltipText);
end

TRP3_API.databroker.registerButton(loc("DTBK_AFK"), {
	icon = "TEMP",
	OnClick = onClick,
	OnTooltipShow = onTooltipShow,
	OnUpdate = onUpdate
});