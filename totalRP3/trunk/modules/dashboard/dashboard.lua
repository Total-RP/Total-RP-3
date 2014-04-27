--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Telkostrasz & Ellypse
-- Dashboard page
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DASHBOARD = {};

-- imports
local GetMouseFocus, _G, TRP3_DashboardStatus_Currently = GetMouseFocus, _G, TRP3_DashboardStatus_Currently;
local loc = TRP3_L;
local getcharacter = TRP3_PROFILE.getCharacter;
local Utils, Events = TRP3_UTILS, TRP3_EVENTS;
local setupListBox = TRP3_UI_UTILS.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_UI_UTILS.tooltip.setTooltipForSameFrame;
local toolbarAddButton = TRP3_TOOLBAR.toolbarAddButton;
local icon, color = Utils.str.icon, Utils.str.color;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_CONFIG.getValue, TRP3_CONFIG.registerConfigKey, TRP3_CONFIG.registerHandler;
local setTooltipForFrame, refreshTooltip, mainTooltip = TRP3_UI_UTILS.tooltip.setTooltipForFrame, TRP3_UI_UTILS.tooltip.refresh, TRP3_MainTooltip;
local buildToolbar = TRP3_TOOLBAR.buildToolbar;
local getCurrentContext, getCurrentPageID = TRP3_NAVIGATION.page.getCurrentContext, TRP3_NAVIGATION.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_NAVIGATION.menu.registerMenu, TRP3_NAVIGATION.page.registerPage;
local registerPage, setPage = TRP3_NAVIGATION.page.registerPage, TRP3_NAVIGATION.page.setPage;

-- The variable which gonna make people cry : Currently status characters limit. :D
local CURRENTLY_SIZE = 200;

local function onStatusChange(status)
	local character = getcharacter();
	local old = character.RP;
	character.RP = status;
	if old ~= status then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
		Events.fireEvent(Events.REGISTER_RPSTATUS_CHANGED);
	end
end

local function switchStatus()
	if getcharacter().RP == 1 then
		onStatusChange(2);
	else
		onStatusChange(1);
	end
end

local function onStatusXPChange(status)
	local character = getcharacter();
	local old = character.XP;
	character.XP = status;
	if old ~= status then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
	end
end

local function onCurrentlyChanged()
	local character = getcharacter();
	local old = character.CU;
	character.CU = TRP3_DashboardStatus_Currently:GetText();
	if old ~= character.CU then
		character.v = Utils.math.incrementNumber(character.v or 1, 2);
	end
end

local function onShow(context)
	local character = getcharacter();
	TRP3_DashboardStatus_CharactStatusList:SetSelectedValue(character.RP or 1);
	TRP3_DashboardStatus_XPStatusList:SetSelectedValue(character.XP or 2);
	TRP3_DashboardStatus_Currently:SetText(character.CU or "");
end

TRP3_DASHBOARD.isPlayerIC = function()
	return getcharacter().RP == 1;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CONFIG_CONTENT_RPSTATUS = "toolbar_content_rpstatus";
local DASHBOARD_PAGE_ID = "dashboard";

TRP3_DASHBOARD.init = function()

	registerMenu({
		id = "main_00_dashboard",
		align = "CENTER",
		text = TRP3_GLOBALS.addon_name,
		onSelected = function() setPage(DASHBOARD_PAGE_ID); end,
	});
	
	registerPage({
		id = DASHBOARD_PAGE_ID,
		frame = TRP3_Dashboard,
		onPagePostShow = onShow,
	});
	
	TRP3_FieldSet_SetCaption(TRP3_DashboardStatus, loc("DB_STATUS"), 150);
	TRP3_FieldSet_SetCaption(TRP3_DashboardNotifications, loc("DB_NOTIFICATIONS"), 150);
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
	local character = TRP3_PROFILE.getCharacter();
	local rpTextOn = icon("Inv_misc_grouplooking", 25) .. " ".. loc("TB_RPSTATUS_ON");
	local rpTextOff = icon("inv_leather_a_03defias", 25) .. " ".. loc("TB_RPSTATUS_OFF");
	local rpText2 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_ON");
	local rpText3 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_OFF");
	local Button_RPStatus = {
		id = "aa_trp3_rpstatus",
		icon = "Inv_misc_grouplooking",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if character.RP == 1 then
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
	Events.listenToEvent(Events.REGISTER_RPSTATUS_CHANGED, function()
		if getCurrentPageID() == DASHBOARD_PAGE_ID then
			onShow(nil);
		end
	end);
end