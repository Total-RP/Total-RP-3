----------------------------------------------------------------------------------
-- Total RP 3
-- Dashboard
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage = GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage;
local loc = TRP3_API.locale.getText;
local getPlayerCharacter, getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCharacter, TRP3_API.profile.getPlayerCurrentProfileID;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local icon, color = Utils.str.icon, Utils.str.color;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local setTooltipForFrame, refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.setTooltipForFrame, TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local assert, tostring, tinsert, date, time, pairs, tremove, EMPTY, unpack, wipe, strconcat = assert, tostring, tinsert, date, time, pairs, tremove, {}, unpack, wipe, strconcat;
local initList, handleMouseWheel = TRP3_API.ui.list.initList, TRP3_API.ui.list.handleMouseWheel;
local TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No = TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local displayMessage, RaidWarningFrame = TRP3_API.utils.message.displayMessage, RaidWarningFrame;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NOTIFICATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- No : no notification
-- Simple : notification
-- Double : notification + chat frame
-- Triple : notification + chat frame + raid alert
local NOTIFICATION_METHOD = {
	SIMPLE = 1,
	DOUBLE = 2,
	TRIPLE = 3
};
TRP3_API.dashboard.NOTIFICATION_METHOD = NOTIFICATION_METHOD;

local loaded = false;
local DATE_FORMAT = "%d/%m/%y %H:%M:%S";
local NOTIFICATION_TYPES = {};
local NOTIF_CONFIG_PREFIX = TRP3_API.dashboard.NOTIF_CONFIG_PREFIX;
local NOTIF_INDEXES = {};

function TRP3_API.dashboard.registerNotificationType(notificationType)
	assert(not loaded, "Please register your notification type before WORKFLOW_ON_LOADED.");
	assert(notificationType and notificationType.id, "Nil notificationType or no id");
	assert(not NOTIFICATION_TYPES[notificationType.id], "Already registered notification type: " .. notificationType.id);
	NOTIFICATION_TYPES[notificationType.id] = notificationType;
	Utils.log.log("Registered notification: " .. notificationType.id);
end

function TRP3_API.dashboard.notify(notificationID, text, ...)
	assert(NOTIFICATION_TYPES[notificationID], "Unknown notification type: " .. tostring(notificationID));
	if not getConfigValue(NOTIF_CONFIG_PREFIX .. notificationID) then
		return
	end
	
	local method = getConfigValue(NOTIF_CONFIG_PREFIX .. notificationID);
	local notificationType = NOTIFICATION_TYPES[notificationID];
	local character = getPlayerCharacter();
	local notification = {};
	if not character.notifications then
		character.notifications = {};
	end
	notification.id = notificationID;
	notification.text = text;
	if ... then
		notification.args = {...};
	end
	notification.time = time();
	tinsert(character.notifications, notification);
	
	-- Chat message
	if method == NOTIFICATION_METHOD.DOUBLE or method == NOTIFICATION_METHOD.TRIPLE then
		displayMessage(notification.text);
	end
	
	-- Raid alert
	if method == NOTIFICATION_METHOD.TRIPLE then
		RaidNotice_AddMessage(RaidWarningFrame, notification.text, ChatTypeInfo["RAID_WARNING"]);
	end
	
	Events.fireEvent(Events.NOTIFICATION_CHANGED);
end

local function decorateNotificationList(widget, i)
	local index = NOTIF_INDEXES[i];
	local notifications = getPlayerCharacter().notifications;
	widget.notification = notifications[index];
	_G[widget:GetName().."Text"]:SetText(widget.notification.text);
	_G[widget:GetName().."TopText"]:SetText(date(DATE_FORMAT, widget.notification.time));

	local notificationType = NOTIFICATION_TYPES[widget.notification.id];
	if notificationType and notificationType.callback then
		_G[widget:GetName().."Show"]:Show();
	else
		_G[widget:GetName().."Show"]:Hide();
	end
end

local function refreshNotifications(filter)
	local character = getPlayerCharacter();
	filter = filter or 0;
	wipe(NOTIF_INDEXES);
	if character.notifications then
		for index, notif in pairs(character.notifications) do
			if filter == 0 or notif.id == filter then
				tinsert(NOTIF_INDEXES, index);
			end
		end
	end
	if #NOTIF_INDEXES == 0 then
		TRP3_DashboardNotifications_No:Show();
		TRP3_DashboardNotificationsClear:Hide();
	else
		TRP3_DashboardNotifications_No:Hide();
		TRP3_DashboardNotificationsClear:Show();
	end

	initList(TRP3_DashboardNotifications, NOTIF_INDEXES, TRP3_DashboardNotificationsSlider);
end

local function onNotificationRemove(button)
	local notification = button:GetParent().notification;
	assert(notification, "No attached notification to the line.");
	local notifications = getPlayerCharacter().notifications;
	for index, n in pairs(notifications) do
		if n.id == notification.id then
			tremove(notifications, index);
			--			wipe(notification);
			break;
		end
	end
	Events.fireEvent(Events.NOTIFICATION_CHANGED);
end

local function clearAllNotifications()
	local notifications = getPlayerCharacter().notifications;
	if notifications then
		wipe(notifications);
	end
	Events.fireEvent(Events.NOTIFICATION_CHANGED);
end

local function onNotificationShow(button)
	local notification = button:GetParent().notification;
	assert(notification, "No attached notification to the line.");
	local notificationType = NOTIFICATION_TYPES[notification.id];
	if notificationType.callback then
		notificationType.callback(unpack(notification.args or EMPTY));
	end
	if notificationType.removeOnShown ~= false then
		onNotificationRemove(button);
	end
end

local function buildNotificationConfig()
	loaded = true;
	-- Config
	local sortedNotifs = Utils.table.keys(NOTIFICATION_TYPES);

	table.sort(sortedNotifs);

	tinsert(TRP3_API.configuration.CONFIG_STRUCTURE_GENERAL.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_GENERAL_NOTIF"),
	});

	local NOTIFICATION_METHOD_TAB = {
		{loc("CO_NOTIF_NO"), false},
		{loc("CO_NOTIF_SIMPLE"), 1},
		{loc("CO_NOTIF_DOUBLE"), 2},
		{loc("CO_NOTIF_TRIPLE"), 3},
	}
	
	local notifList = {
		{loc("DB_NOTIFICATIONS_ALL"), 0},
	};

	for _, notificationID in pairs(sortedNotifs) do
		local notification = NOTIFICATION_TYPES[notificationID];
		registerConfigKey(NOTIF_CONFIG_PREFIX .. notificationID, notification.defaultMethod or NOTIFICATION_METHOD.SIMPLE);
		tinsert(notifList, {notification.configText or notificationID, notificationID});
		tinsert(TRP3_API.configuration.CONFIG_STRUCTURE_GENERAL.elements, {
			inherit = "TRP3_ConfigDropDown",
			widgetName = "TRP3_ConfigurationTooltip_Notif_" .. notificationID,
			title = notification.configText or notificationID,
			configKey = NOTIF_CONFIG_PREFIX .. notificationID,
			listContent = NOTIFICATION_METHOD_TAB,
			listCancel = true,
		});
	end
	
	-- Filter
	setupListBox(TRP3_DashboardNotificationsFilter, notifList, refreshNotifications, nil, 170, true);
	TRP3_DashboardNotificationsFilter:SetSelectedValue(0);
end

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

-- The variable which gonna make people cry : Currently status characters limit. :D
local CURRENTLY_SIZE = 200;

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

local function onStatusXPChange(status)
	local character = get("player/character");
	local old = character.XP;
	character.XP = status;
	if old ~= status then
		incrementCharacterVernum();
	end
end

local function onCurrentlyChanged()
	local character = get("player/character");
	local old = character.CU;
	character.CU = TRP3_DashboardStatus_Currently:GetText();
	if old ~= character.CU then
		incrementCharacterVernum();
	end
end

local function onShow(context)
	local character = get("player/character");
	TRP3_DashboardStatus_CharactStatusList:SetSelectedValue(character.RP or 1);
	TRP3_DashboardStatus_XPStatusList:SetSelectedValue(character.XP or 2);
	TRP3_DashboardStatus_Currently:SetText(character.CU or "");
	refreshNotifications();
end

function TRP3_API.dashboard.isPlayerIC()
	return get("player/character/RP") == 1;
end

function TRP3_API.dashboard.getCharacterExchangeData()
	return get("player/character");
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
				x = 15, y = -139, anchor = "TOPLEFT", width = 510, height = 115,
			},
			button = {
				x = 0, y = -10, anchor = "TOP",
				text = loc("DB_TUTO_1"):format(TRP3_API.globals.player_id),
				textWidth = 425,
				arrow = "UP"
			}
		},
		{
			box = {
				x = 15, y = -258, anchor = "TOPLEFT", width = 510, height = 195,
			},
			button = {
				x = -30, y = 0, anchor = "RIGHT",
				text = loc("DB_TUTO_2"),
				textWidth = 375,
				arrow = "LEFT"
			}
		}
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

	TRP3_DashboardNotificationsSlider:SetValue(0);
	handleMouseWheel(TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider);
	local widgetTab = {};
	for i=1, 4 do
		local widget = _G["TRP3_DashboardNotifications"..i];
		_G[widget:GetName().."Remove"]:SetScript("OnClick", onNotificationRemove);
		_G[widget:GetName().."Show"]:SetText(loc("CM_SHOW"));
		_G[widget:GetName().."Show"]:SetScript("OnClick", onNotificationShow);
		tinsert(widgetTab, widget);
	end
	TRP3_DashboardNotifications.widgetTab = widgetTab;
	TRP3_DashboardNotifications.decorate = decorateNotificationList;
	TRP3_DashboardNotificationsClear:SetText(loc("DB_NOTIFICATIONS_CLEAR"));
	TRP3_DashboardNotificationsClear:SetScript("OnClick", clearAllNotifications);

	setupFieldSet(TRP3_DashboardStatus, loc("DB_STATUS"), 150);
	setupFieldSet(TRP3_DashboardNotifications, loc("DB_NOTIFICATIONS"), 200);
	TRP3_DashboardStatus_CurrentlyText:SetText(loc("DB_STATUS_CURRENTLY"));
	TRP3_DashboardNotifications_No:SetText(loc("DB_NOTIFICATIONS_NO"));
	setTooltipForSameFrame(TRP3_DashboardStatus_CurrentlyHelp, "LEFT", 0, 5, loc("DB_STATUS_CURRENTLY"), loc("DB_STATUS_CURRENTLY_TT"));
	TRP3_DashboardStatus_Currently:SetScript("OnTextChanged", onCurrentlyChanged);

	TRP3_MainFrameVersionText:SetText(TRP3_API.locale.getText("GEN_VERSION"):format(TRP3_API.globals.version_display, TRP3_API.globals.version));

	TRP3_DashboardStatus_Currently:SetMaxLetters(CURRENTLY_SIZE);

	TRP3_DashboardStatus_CharactStatus:SetText(loc("DB_STATUS_RP"));
	local statusTab = {
		{loc("DB_STATUS_RP_IC"), 1},
		{loc("DB_STATUS_RP_OOC"), 2},
	};
	setupListBox(TRP3_DashboardStatus_CharactStatusList, statusTab, onStatusChange, nil, 120, true);

	TRP3_DashboardStatus_XPStatus:SetText(loc("DB_STATUS_XP"));
	local xpTab = {
		{loc("DB_STATUS_XP_BEGINNER"), 1},
		{loc("DB_STATUS_RP_EXP"), 2},
		{loc("DB_STATUS_RP_VOLUNTEER"), 3},
	};
	setupListBox(TRP3_DashboardStatus_XPStatusList, xpTab, onStatusXPChange, nil, 120, true);

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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	buildNotificationConfig();
	if TRP3_API.toolbar then
		-- Show/hide cape
		local capeTextOn = icon("INV_Misc_Cape_18", 25) .. " ".. loc("TB_SWITCH_CAPE_ON");
		local capeTextOff = icon("item_icecrowncape", 25) .. " ".. loc("TB_SWITCH_CAPE_OFF");
		local capeText2 = strconcat(color("y"), loc("CM_CLICK"), ": ", color("w"), loc("TB_SWITCH_CAPE_1"));
		local capeText3 = strconcat(color("y"), loc("CM_CLICK"), ": ", color("w"), loc("TB_SWITCH_CAPE_2"));
		Button_Cape = {
			id = "aa_trp3_a",
			icon = "INV_Misc_Cape_18",
			configText = loc("CO_TOOLBAR_CONTENT_CAPE"),
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				if not ShowingCloak() then
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\item_icecrowncape");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\item_icecrowncape");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOff, capeText2);
				else
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\INV_Misc_Cape_18");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\INV_Misc_Cape_18");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOn, capeText3);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)
				ShowCloak(not ShowingCloak());
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Cape);

		-- Show / hide helmet
		local helmTextOn = icon("INV_Helmet_13", 25) .. " ".. loc("TB_SWITCH_HELM_ON");
		local helmTextOff = icon("Spell_Arcane_MindMastery", 25) .. " ".. loc("TB_SWITCH_HELM_OFF");
		local helmText2 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_1");
		local helmText3 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_2");
		Button_Helmet = {
			id = "aa_trp3_b",
			icon = "INV_Helmet_13",
			configText = loc("CO_TOOLBAR_CONTENT_HELMET"),
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				if not ShowingHelm() then
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\Spell_Arcane_MindMastery");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\Spell_Arcane_MindMastery");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOff, helmText2);
				else
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\INV_Helmet_13");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\INV_Helmet_13");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOn, helmText3);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)
				ShowHelm(not ShowingHelm());
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Helmet);

		-- away/dnd
		local status1Text = icon("Ability_Mage_IncantersAbsorbtion", 25).." "..color("w")..loc("TB_STATUS")..": "..color("r")..loc("TB_DND_MODE");
		local status1SubText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
		local status2Text = icon("Spell_Nature_Sleep", 25).." "..color("w")..loc("TB_STATUS")..": "..color("o")..loc("TB_AFK_MODE");
		local status2SubText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
		local status3Text = icon("Ability_Rogue_MasterOfSubtlety", 25).." "..color("w")..loc("TB_STATUS")..": "..color("g")..loc("TB_NORMAL_MODE");
		local status3SubText = color("y")..loc("CM_L_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("o")..loc("TB_AFK_MODE")..color("w"))).."\n"..color("y")..loc("CM_R_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("r")..loc("TB_DND_MODE")..color("w")));
		Button_Status = {
			id = "aa_trp3_c",
			icon = "Ability_Rogue_MasterOfSubtlety",
			configText = loc("CO_TOOLBAR_CONTENT_STATUS"),
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				if UnitIsDND("player") then
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status1Text, status1SubText);
				elseif UnitIsAFK("player") then
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\Spell_Nature_Sleep");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\Spell_Nature_Sleep");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status2Text, status2SubText);
				else
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety");
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status3Text, status3SubText);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
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
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Status);

		-- Toolbar RP status
		local RP_ICON, OOC_ICON = "spell_shadow_charm", "Inv_misc_grouplooking";
		local rpTextOn = icon(RP_ICON, 25) .. " ".. loc("TB_RPSTATUS_ON");
		local rpTextOff = icon(OOC_ICON, 25) .. " ".. loc("TB_RPSTATUS_OFF");
		local rpText2 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_ON");
		local rpText3 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_OFF");
		local get = TRP3_API.profile.getData;
		local defaultIcon = TRP3_API.globals.player_icon;

		local Button_RPStatus = {
			id = "aa_trp3_rpstatus",
			icon = "Inv_misc_grouplooking",
			configText = loc("CO_TOOLBAR_CONTENT_RPSTATUS"),
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				if get("player/character/RP") == 1 then
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\" .. RP_ICON);
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\" .. RP_ICON);
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, rpTextOn, rpText3);
				else
					Uibutton:GetNormalTexture():SetTexture("Interface\\ICONS\\" .. OOC_ICON);
					Uibutton:GetPushedTexture():SetTexture("Interface\\ICONS\\" .. OOC_ICON);
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, rpTextOff, rpText2);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)
				switchStatus();
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
			visible = 1
		};
		TRP3_API.toolbar.toolbarAddButton(Button_RPStatus);
	end
end);