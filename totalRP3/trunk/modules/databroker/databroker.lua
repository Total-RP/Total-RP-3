----------------------------------------------------------------------------------
-- Total RP 3
-- Databroker plugins module
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

-- IMPORTS :

-- 	WoW
local ShowingHelm, ShowHelm = ShowingHelm, ShowHelm;
local ShowingCloak, ShowCloak = ShowingCloak, ShowCloak;
local UnitIsDND, UnitIsAFK = UnitIsDND, UnitIsAFK;
local SendChatMessage = SendChatMessage;

-- 	TRP3_API
local get = TRP3_API.profile.getData;
local icon, color = TRP3_API.utils.str.icon, TRP3_API.utils.str.color;
local loc = TRP3_API.locale.getText;
local playUISound = TRP3_API.ui.misc.playUISound;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local selectProfile = TRP3_API.profile.selectProfile;
local getProfiles = TRP3_API.profile.getProfiles;
local currentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local switchStatus = TRP3_API.dashboard.switchStatus;
local iconProfileDefault = TRP3_API.globals.icons.profile_default;

-- Lua
local tinsert, pairs = tinsert, pairs;

local function helmet()

	local object;

	local function determineData(helmShown)
		local iconOn = "Interface\\ICONS\\INV_Helmet_13";
		local iconOff = "Interface\\ICONS\\Spell_Arcane_MindMastery";
		local helmTitleOn = icon("INV_Helmet_13", 25) .. " ".. loc("TB_SWITCH_HELM_ON");
		local helmTitleOff = icon("Spell_Arcane_MindMastery", 25) .. " ".. loc("TB_SWITCH_HELM_OFF");
		local helmTextOn = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_1");
		local helmTextOff = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_2");

		return 	helmShown and helmTitleOn or helmTitleOff,
				helmShown and helmTextOn or helmTextOff,
				helmShown and iconOn or iconOff
	end

	local tooltipTitle, tooltipText, icon = determineData(ShowingHelm());

	object = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(loc("DTBK_HELMET"), {
		type = "launcher",
		icon = icon,
		OnClick = function(clickedframe, button)
			if ShowingHelm() then
				ShowHelm(false);
				tooltipTitle, tooltipText, object.icon = determineData(false)
				playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);

			else
				ShowHelm(true);
				tooltipTitle, tooltipText, object.icon = determineData(true)
				playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(tooltipTitle);
			tooltip:AddLine(tooltipText);
		end,
	})

end

local function cloak()

	local object;

	local function determineData(cloakShown)

		local iconOn = "Interface\\ICONS\\INV_Misc_Cape_18";
		local iconOff = "Interface\\ICONS\\item_icecrowncape";
		local cloakTitleOn = icon("INV_Misc_Cape_18", 25) .. " ".. loc("TB_SWITCH_CAPE_ON");
		local cloakTitleOff = icon("item_icecrowncape", 25) .. " ".. loc("TB_SWITCH_CAPE_OFF");
		local cloakTextOn = color("y") .. loc("CM_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_CAPE_1");
		local cloakTextOff = color("y") .. loc("CM_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_CAPE_2");

		return 	cloakShown and cloakTitleOn or cloakTitleOff,
				cloakShown and cloakTextOn or cloakTextOff,
				cloakShown and iconOn or iconOff;
	end

	local tooltipTitle, tooltipText, icon = determineData(ShowCloak());

	object = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(loc("DTBK_CLOAK"), {
		type = "launcher",
		icon = icon,
		OnClick = function(clickedframe, button)
			if ShowingCloak() then
				ShowCloak(false);
				tooltipTitle, tooltipText, object.icon = determineData(false);
				playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);

			else
				ShowCloak(true);
				tooltipTitle, tooltipText, object.icon = determineData(true);
				playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(tooltipTitle);
			tooltip:AddLine(tooltipText);
		end,
	})

end

local function afk()

	local object;

	local function determineData(status)

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
		local icon = "";
		if status == 1 then
			tooltipTitle = DNDTitle;
			tooltipText = DNDText;
			icon = DNDIcon;
		elseif status == 2 then
			tooltipTitle = AFKTitle;
			tooltipText = AFKText;
			icon = AFKIcon;
		else
			tooltipTitle = normalTitle;
			tooltipText = normalText;
			icon = normalIcon;
		end
		return tooltipTitle, tooltipText, icon;
	end

	local tooltipTitle, tooltipText, icon = determineData(UnitIsAFK("player") and 2 or UnitIsDND("player") and 1 or 0);

	object = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(loc("DTBK_AFK"), {
		type = "launcher",
		icon = icon,
		OnClick = function(clickedframe, button)
			local status = 0;
			if UnitIsAFK("player") then
				SendChatMessage("","AFK");
			elseif UnitIsDND("player") then
				SendChatMessage("","DND");
			else
				if button == "LeftButton" then
					SendChatMessage("","AFK");
					status = 2;
				else
					SendChatMessage("","DND");
					status = 1;
				end
			end
			playUISound("igMainMenuOptionCheckBoxOn");
			tooltipTitle, tooltipText, object.icon = determineData(status);

		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(tooltipTitle);
			tooltip:AddLine(tooltipText);
		end,
	})
end

local function rp()

	local object;

	local function determineData(RP)

		local iconOn = "Interface\\ICONS\\spell_shadow_charm";
		local iconOff = "Interface\\ICONS\\Inv_misc_grouplooking";
		local RPTitleOn = icon("spell_shadow_charm", 25) .. " ".. loc("TB_RPSTATUS_ON");
		local RPTitleOff = icon("Inv_misc_grouplooking", 25) .. " ".. loc("TB_RPSTATUS_OFF");
		local profilesText = "\n" .. color("y") .. loc("CM_R_CLICK") .. ": " .. color("w") .. loc("TB_SWITCH_PROFILE");
		local RPTextOn = color("y") .. loc("CM_L_CLICK") .. ": " .. color("w") .. loc("TB_RPSTATUS_TO_ON") .. profilesText;
		local RPTextOff = color("y") .. loc("CM_L_CLICK") .. ": " .. color("w") .. loc("TB_RPSTATUS_TO_OFF") .. profilesText;

		return 	RP and RPTitleOn or RPTitleOff,
				RP and RPTextOn or RPTextOff,
				RP and iconOn or iconOff;
	end

	local tooltipTitle, tooltipText, icon = determineData(get("player/character/RP") == 1);

	object = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(loc("DTBK_RP"), {
		type = "launcher",
		icon = icon,
		OnClick = function(clickedframe, button)
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
				tooltipTitle, tooltipText, object.icon = determineData(get("player/character/RP") == 1);
				playUISound("igMainMenuOptionCheckBoxOn");
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(tooltipTitle);
			tooltip:AddLine(tooltipText);
		end,
	})
end

local function onStart()
	helmet();
	cloak();
	afk();
	rp();
end

local MODULE_STRUCTURE = {
	["name"] = "Databroker plugins",
	["description"] = "Add several handy actions as plugins for DataBroker add-ons (FuBar, Titan, Bazooka) !",
	["version"] = 1.000,
	["id"] = "trp3_databroker",
	["onStart"] = onStart,
	["minVersion"] = 8,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
