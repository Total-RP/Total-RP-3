----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---	Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage, TRP3_DashboardStatus_OOCInfo = GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage, TRP3_DashboardStatus_OOCInfo;
local getPlayerCharacter, getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCharacter, TRP3_API.profile.getPlayerCurrentProfileID;
local getProfiles = TRP3_API.profile.getProfiles;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local icon, color = Utils.str.icon, Utils.str.color;
local playUISound = TRP3_API.ui.misc.playUISound;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local setTooltipForFrame, refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.setTooltipForFrame, TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local setPage = TRP3_API.navigation.page.setPage;
local assert, tostring, tinsert, date, time, pairs, tremove, EMPTY, unpack, wipe, strconcat = assert, tostring, tinsert, date, time, pairs, tremove, TRP3_API.globals.empty, unpack, wipe, strconcat;
local initList, handleMouseWheel = TRP3_API.ui.list.initList, TRP3_API.ui.list.handleMouseWheel;
local TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No = TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local displayMessage, RaidWarningFrame = TRP3_API.utils.message.displayMessage, RaidWarningFrame;
local GetInventoryItemID, GetItemInfo = GetInventoryItemID, GetItemInfo;

-- Total RP 3 imports
local loc = TRP3_API.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local get, getDefaultProfile = TRP3_API.profile.getData, TRP3_API.profile.getDefaultProfile;

getDefaultProfile().player.character = {
	v = 1,
}

local function incrementCharacterVernum()
	local character = get("player/character");
	character.v = Utils.math.incrementNumber(character.v or 1, 2);
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getPlayerCurrentProfileID(), "character");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStatusChange(status)
	local character = get("player/character");
	local old = character.RP;
	character.RP = status;
	if old ~= status then
		incrementCharacterVernum();
	end
end

local function switchStatus()
	if get("player/character/RP") == 1 then
		onStatusChange(2);
	else
		onStatusChange(1);
	end
end
TRP3_API.dashboard.switchStatus = switchStatus;

local function onStatusXPChange(status)
	local character = get("player/character");
	local old = character.XP;
	character.XP = status;
	if old ~= status then
		incrementCharacterVernum();
	end
end

local function onShow(context)
	local character = get("player/character");
	TRP3_DashboardStatus_CharactStatusList:SetSelectedValue(character.RP or 1);
	TRP3_DashboardStatus_XPStatusList:SetSelectedValue(character.XP or 2);
end

function TRP3_API.dashboard.isPlayerIC()
	return get("player/character/RP") == 1;
end

function TRP3_API.dashboard.getCharacterExchangeData()
	return get("player/character");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SANITIZE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDS_TO_SANITIZE = {
	"CO", "CU"
}
---@param structure table
---@return boolean
function TRP3_API.dashboard.sanitizeCharacter(structure)
	local somethingWasSanitized = false;
	if structure then
		for _, field in pairs(FIELDS_TO_SANITIZE) do
			if structure[field] then
				local sanitizedValue = Utils.str.sanitize(structure[field]);
				if sanitizedValue ~= structure[field] then
					structure[field] = sanitizedValue;
					somethingWasSanitized = true;
				end
			end
		end
	end
	return somethingWasSanitized;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DASHBOARD_PAGE_ID = "dashboard";
local ShowingHelm, ShowingCloak, ShowCloak, ShowHelm = ShowingHelm, ShowingCloak, ShowCloak, ShowHelm;
local Button_Cape, Button_Helmet, Button_Status, Button_RPStatus;
local SendChatMessage, UnitIsDND, UnitIsAFK = SendChatMessage, UnitIsDND, UnitIsAFK;

TRP3_API.dashboard.init = function()

	local TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_DashboardStatus
			},
			button = {
				x = -50, y = 0, anchor = "RIGHT",
				text = loc.DB_TUTO_1:format(TRP3_API.globals.player_id),
				textWidth = 425,
				arrow = "UP"
			}
		},
	}

	registerMenu({
		id = "main_00_dashboard",
		align = "CENTER",
		text = TRP3_API.globals.addon_name,
		onSelected = function() setPage(DASHBOARD_PAGE_ID); end,
	});

	registerPage({
		id = DASHBOARD_PAGE_ID,
		frame = TRP3_Dashboard,
		onPagePostShow = onShow,
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end
	});

	setupFieldSet(TRP3_DashboardStatus, loc.DB_STATUS, 150);
	TRP3_DashboardStatus_CharactStatus:SetText(loc.DB_STATUS_RP);
	local OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15|t";
	local IC_ICON = "|TInterface\\COMMON\\Indicator-Green:15|t";
	local statusTab = {
		{IC_ICON .. " " .. loc.DB_STATUS_RP_IC, 1, loc.DB_STATUS_RP_IC_TT},
		{OOC_ICON .. " " .. loc.DB_STATUS_RP_OOC, 2, loc.DB_STATUS_RP_OOC_TT},
	};
	setupListBox(TRP3_DashboardStatus_CharactStatusList, statusTab, onStatusChange, nil, 170, true);

	TRP3_DashboardStatus_XPStatus:SetText(loc.DB_STATUS_XP);
	local BEGINNER_ICON = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20|t";
	local VOLUNTEER_ICON = "|TInterface\\TARGETINGFRAME\\PortraitQuestBadge:15|t";
	local xpTab = {
		{BEGINNER_ICON .. " " .. loc.DB_STATUS_XP_BEGINNER, 1, loc.DB_STATUS_XP_BEGINNER_TT},
		{loc.DB_STATUS_RP_EXP, 2, loc.DB_STATUS_RP_EXP_TT},
		{VOLUNTEER_ICON .. " " .. loc.DB_STATUS_RP_VOLUNTEER, 3, loc.DB_STATUS_RP_VOLUNTEER_TT},
	};
	setupListBox(TRP3_DashboardStatus_XPStatusList, xpTab, onStatusXPChange, nil, 170, true);

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, profileID, dataType)
		if (not dataType or dataType == "character") and getCurrentPageID() == DASHBOARD_PAGE_ID then
			onShow(nil);
		end
	end);
	Events.listenToEvent(Events.NOTIFICATION_CHANGED, function()
		if getCurrentPageID() == DASHBOARD_PAGE_ID then
			onShow(nil);
		end
	end);
end

local function profileSelected(profileID)
	TRP3_API.profile.selectProfile(profileID);
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	if TRP3_API.toolbar then

		local updateToolbarButton = TRP3_API.toolbar.updateToolbarButton;
		-- away/dnd
		local status1Text = color("w")..loc.TB_STATUS..": "..color("r")..loc.TB_DND_MODE;
		local status1SubText = color("y")..loc.CM_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("g")..loc.TB_NORMAL_MODE..color("w")));
		local status2Text = color("w")..loc.TB_STATUS..": "..color("o")..loc.TB_AFK_MODE;
		local status2SubText = color("y")..loc.CM_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("g")..loc.TB_NORMAL_MODE..color("w")));
		local status3Text = color("w")..loc.TB_STATUS..": "..color("g")..loc.TB_NORMAL_MODE;
		local status3SubText = color("y")..loc.CM_L_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("o")..loc.TB_AFK_MODE..color("w"))).."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("r")..loc.TB_DND_MODE..color("w")));
		Button_Status = {
			id = "aa_trp3_c",
			icon = "Ability_Rogue_MasterOfSubtlety",
			configText = loc.CO_TOOLBAR_CONTENT_STATUS,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if UnitIsDND("player") then
					buttonStructure.tooltip  = status1Text;
					buttonStructure.tooltipSub  = status1SubText;
					buttonStructure.icon = "Ability_Mage_IncantersAbsorbtion";
				elseif UnitIsAFK("player") then
					buttonStructure.tooltip  = status2Text;
					buttonStructure.tooltipSub  = status2SubText;
					buttonStructure.icon = "Spell_Nature_Sleep";
				else
					buttonStructure.tooltip  = status3Text;
					buttonStructure.tooltipSub  = status3SubText;
					buttonStructure.icon = "Ability_Rogue_MasterOfSubtlety";
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)
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
				playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Status);

		-- Toolbar RP status
		local RP_ICON, OOC_ICON = "spell_shadow_charm", "Inv_misc_grouplooking";
		local rpTextOn = loc.TB_RPSTATUS_ON;
		local rpTextOff = loc.TB_RPSTATUS_OFF;
		local rpText2 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_ON;
		rpText2 = rpText2.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;
		local rpText3 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_OFF;
		rpText3 = rpText3.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;
		local defaultIcon = TRP3_API.globals.player_icon;

		Button_RPStatus = {
			id = "aa_trp3_rpstatus",
			icon = "Inv_misc_grouplooking",
			configText = loc.CO_TOOLBAR_CONTENT_RPSTATUS,
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if get("player/character/RP") == 1 then
					buttonStructure.tooltip  = rpTextOn;
					buttonStructure.tooltipSub = rpText3;
					buttonStructure.icon = RP_ICON;
				else
					buttonStructure.tooltip  = rpTextOff;
					buttonStructure.tooltipSub  = rpText2;
					buttonStructure.icon = OOC_ICON;
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)

				if button == "RightButton" then

					local list = getProfiles();

					local dropdownItems = {};
					tinsert(dropdownItems,{loc.TB_SWITCH_PROFILE, nil});
					local currentProfileID = getPlayerCurrentProfileID()
					for key, value in pairs(list) do
						local icon = value.player.characteristics.IC or Globals.icons.profile_default;
						if key == currentProfileID then
							tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t|cff00ff00 "..value.profileName.."|r", nil});
						else
							tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t "..value.profileName, key});
						end
					end
					displayDropDown(Uibutton, dropdownItems, profileSelected, 0, true);
				else
					switchStatus();
					playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
				end
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
			visible = 1
		};
		TRP3_API.toolbar.toolbarAddButton(Button_RPStatus);
	end
end);
