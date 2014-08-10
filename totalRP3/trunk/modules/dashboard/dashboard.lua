--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Telkostrasz & Ellypse
-- Dashboard page
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local GetMouseFocus, _G, TRP3_DashboardStatus_Currently = GetMouseFocus, _G, TRP3_DashboardStatus_Currently;
local loc = TRP3_API.locale.getText;
local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
local Utils, Events = TRP3_API.utils, TRP3_API.events;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local toolbarAddButton = TRP3_API.toolbar.toolbarAddButton;
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NOTIFICATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DATE_FORMAT = "%d/%m/%y %H:%M:%S";
local NOTIFICATION_TYPES = {};
local NOTIF_CONFIG_PREFIX = TRP3_API.dashboard.NOTIF_CONFIG_PREFIX;

function TRP3_API.dashboard.registerNotificationType(notificationType)
	assert(notificationType and notificationType.id, "Nil notificationType or no id");
	assert(not NOTIFICATION_TYPES[notificationType.id], "Already registered notification type: " .. notificationType.id);
	NOTIFICATION_TYPES[notificationType.id] = notificationType;
	Utils.log.log("Registered notification: " .. notificationType.id);
end

function TRP3_API.dashboard.notify(notificationID, text, ...)
	assert(NOTIFICATION_TYPES[notificationID], "Unknown notification type: " .. tostring(notificationID));
	if getConfigValue(NOTIF_CONFIG_PREFIX .. notificationID) ~= true then return end
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
	Events.fireEvent(Events.NOTIFICATION_CHANGED);
end

function TRP3_API.dashboard.getNotificationTypeList()
	return NOTIFICATION_TYPES;
end

local function decorateNotificationList(widget, index)
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

local function refreshNotifications()
	local count = 0;
	local character = getPlayerCharacter();
	if character.notifications then
		count = #character.notifications;
	end
	if count == 0 then
		TRP3_DashboardNotifications_No:Show();
		TRP3_DashboardNotificationsClear:Hide();
	else
		TRP3_DashboardNotifications_No:Hide();
		TRP3_DashboardNotificationsClear:Show();
	end
	
	initList(TRP3_DashboardNotifications, count, TRP3_DashboardNotificationsSlider);
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- The variable which gonna make people cry : Currently status characters limit. :D
local CURRENTLY_SIZE = 200;

local function onStatusChange(status)
	local character = getPlayerCharacter();
	local old = character.RP;
	character.RP = status;
	if old ~= status then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
		Events.fireEvent(Events.REGISTER_RPSTATUS_CHANGED);
	end
end

local function switchStatus()
	if getPlayerCharacter().RP == 1 then
		onStatusChange(2);
	else
		onStatusChange(1);
	end
end

local function onStatusXPChange(status)
	local character = getPlayerCharacter();
	local old = character.XP;
	character.XP = status;
	if old ~= status then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
		Events.fireEvent(Events.REGISTER_XPSTATUS_CHANGED);
	end
end

local function onCurrentlyChanged()
	local character = getPlayerCharacter();
	local old = character.CU;
	character.CU = TRP3_DashboardStatus_Currently:GetText();
	if old ~= character.CU then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
		Events.fireEvent(Events.REGISTER_CURRENTLY_CHANGED);
	end
end

local function onShow(context)
	local character = getPlayerCharacter();
	TRP3_DashboardStatus_CharactStatusList:SetSelectedValue(character.RP or 1);
	TRP3_DashboardStatus_XPStatusList:SetSelectedValue(character.XP or 2);
	TRP3_DashboardStatus_Currently:SetText(character.CU or "");
	refreshNotifications();
end

TRP3_API.dashboard.isPlayerIC = function()
	return getPlayerCharacter().RP == 1;
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
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\item_icecrowncape");
				_G[Uibutton:GetName().."Pushed"]:SetTexture("Interface\\ICONS\\item_icecrowncape");
				_G[Uibutton:GetName().."Pushed"]:SetDesaturated(1);
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOff, capeText2);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\INV_Misc_Cape_18");
				_G[Uibutton:GetName().."Pushed"]:SetTexture("Interface\\ICONS\\INV_Misc_Cape_18");
				_G[Uibutton:GetName().."Pushed"]:SetDesaturated(1);
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
	toolbarAddButton(Button_Cape);
	
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
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Spell_Arcane_MindMastery");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOff, helmText2);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\INV_Helmet_13");
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
	toolbarAddButton(Button_Helmet);
	
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
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion");
				setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status1Text, status1SubText);
			elseif UnitIsAFK("player") then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Spell_Nature_Sleep");
				setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status2Text, status2SubText);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety");
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
	toolbarAddButton(Button_Status);
	
	-- Toolbar RP status
	local playerCharacter = TRP3_API.profile.getPlayerCharacter();
	local rpTextOff = icon("Inv_misc_grouplooking", 25) .. " ".. loc("TB_RPSTATUS_OFF");
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
			if playerCharacter.RP == 1 then
				local iconURL = get("player/characteristics/IC") or defaultIcon;
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\" .. iconURL);
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, icon(iconURL, 25) .. " ".. loc("TB_RPSTATUS_ON"), rpText3);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Inv_misc_grouplooking");
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
	toolbarAddButton(Button_RPStatus);
	
	Events.listenToEvents({Events.REGISTER_RPSTATUS_CHANGED, Events.NOTIFICATION_CHANGED}, function()
		if getCurrentPageID() == DASHBOARD_PAGE_ID then
			onShow(nil);
		end
	end);
end