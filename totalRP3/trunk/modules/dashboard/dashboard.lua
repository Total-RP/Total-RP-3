--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Telkostrasz & Ellypse
-- Dashboard page
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.dashboard = {};

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
local buildToolbar = TRP3_API.toolbar.buildToolbar;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local assert, tostring, tinsert, date, time, pairs, tremove, EMPTY, unpack, wipe = assert, tostring, tinsert, date, time, pairs, tremove, {}, unpack, wipe;
local initList, handleMouseWheel = TRP3_API.ui.list.initList, TRP3_API.ui.list.handleMouseWheel;
local TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No = TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NOTIFICATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DATE_FORMAT = "%d/%m/%y %H:%M:%S";
local NOTIFICATION_TYPES = {};

TRP3_API.dashboard.registerNotificationType = function(notificationType)
	assert(notificationType and notificationType.id, "Nil notificationType or no id");
	assert(not NOTIFICATION_TYPES[notificationType.id], "Already registered notification type: " .. notificationType.id);
	NOTIFICATION_TYPES[notificationType.id] = notificationType;
end

TRP3_API.dashboard.notify = function(notificationID, text, ...)
	assert(NOTIFICATION_TYPES[notificationID], "Unknown notification type: " .. tostring(notificationID));
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
	end
end

local function onCurrentlyChanged()
	local character = getPlayerCharacter();
	local old = character.CU;
	character.CU = TRP3_DashboardStatus_Currently:GetText();
	if old ~= character.CU then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
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

local CONFIG_CONTENT_RPSTATUS = "toolbar_content_rpstatus";
local DASHBOARD_PAGE_ID = "dashboard";

TRP3_API.dashboard.init = function()

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
	setupFieldSet(TRP3_DashboardNotifications, loc("DB_NOTIFICATIONS"), 150);
	TRP3_DashboardStatus_CurrentlyText:SetText(loc("DB_STATUS_CURRENTLY"));
	TRP3_DashboardNotifications_No:SetText(loc("DB_NOTIFICATIONS_NO"));
	setTooltipForSameFrame(TRP3_DashboardStatus_CurrentlyHelp, "LEFT", 0, 5, loc("DB_STATUS_CURRENTLY"), loc("DB_STATUS_CURRENTLY_TT"));
	TRP3_DashboardStatus_Currently:SetScript("OnTextChanged", onCurrentlyChanged);
	
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
	
	-- Toolbar RP status
	local playerCharacter = TRP3_API.profile.getPlayerCharacter();
	local rpTextOn = icon("Inv_misc_grouplooking", 25) .. " ".. loc("TB_RPSTATUS_ON");
	local rpTextOff = icon("inv_leather_a_03defias", 25) .. " ".. loc("TB_RPSTATUS_OFF");
	local rpText2 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_ON");
	local rpText3 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_OFF");
	local Button_RPStatus = {
		id = "aa_trp3_rpstatus",
		icon = "Inv_misc_grouplooking",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if playerCharacter.RP == 1 then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Inv_misc_grouplooking");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, rpTextOn, rpText3);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\inv_leather_a_03defias");
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
	registerConfigHandler({CONFIG_CONTENT_RPSTATUS}, function()
		Button_RPStatus.visible = getConfigValue(CONFIG_CONTENT_RPSTATUS);
		buildToolbar();
	end);
	Events.listenToEvents({Events.REGISTER_RPSTATUS_CHANGED, Events.NOTIFICATION_CHANGED}, function()
		if getCurrentPageID() == DASHBOARD_PAGE_ID then
			onShow(nil);
		end
	end);
end