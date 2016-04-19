----------------------------------------------------------------------------------
-- Total RP 3
-- Dashboard
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage, TRP3_DashboardStatus_OOCInfo = GetMouseFocus, _G, TRP3_DashboardStatus_Currently, RaidNotice_AddMessage, TRP3_DashboardStatus_OOCInfo;
local loc = TRP3_API.locale.getText;
local getPlayerCharacter, getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCharacter, TRP3_API.profile.getPlayerCurrentProfileID;
local getProfiles = TRP3_API.profile.getProfiles;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local icon, color = Utils.str.icon, Utils.str.color;
local playUISound = TRP3_API.ui.misc.playUISound;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local setTooltipForFrame, refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.setTooltipForFrame, TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local assert, tostring, tinsert, date, time, pairs, tremove, EMPTY, unpack, wipe, strconcat = assert, tostring, tinsert, date, time, pairs, tremove, TRP3_API.globals.empty, unpack, wipe, strconcat;
local initList, handleMouseWheel = TRP3_API.ui.list.initList, TRP3_API.ui.list.handleMouseWheel;
local TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No = TRP3_DashboardNotifications, TRP3_DashboardNotificationsSlider, TRP3_DashboardNotifications_No;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local displayMessage, RaidWarningFrame = TRP3_API.utils.message.displayMessage, RaidWarningFrame;
local GetInventoryItemID, GetItemInfo = GetInventoryItemID, GetItemInfo;

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
				text = loc("DB_TUTO_1"):format(TRP3_API.globals.player_id),
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

	setupFieldSet(TRP3_DashboardStatus, loc("DB_STATUS"), 150);
	TRP3_DashboardStatus_CharactStatus:SetText(loc("DB_STATUS_RP"));
	local OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15|t";
	local IC_ICON = "|TInterface\\COMMON\\Indicator-Green:15|t";
	local statusTab = {
		{IC_ICON .. " " .. loc("DB_STATUS_RP_IC"), 1, loc("DB_STATUS_RP_IC_TT")},
		{OOC_ICON .. " " .. loc("DB_STATUS_RP_OOC"), 2, loc("DB_STATUS_RP_OOC_TT")},
	};
	setupListBox(TRP3_DashboardStatus_CharactStatusList, statusTab, onStatusChange, nil, 170, true);

	TRP3_DashboardStatus_XPStatus:SetText(loc("DB_STATUS_XP"));
	local BEGINNER_ICON = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20|t";
	local VOLUNTEER_ICON = "|TInterface\\TARGETINGFRAME\\PortraitQuestBadge:15|t";
	local xpTab = {
		{BEGINNER_ICON .. " " .. loc("DB_STATUS_XP_BEGINNER"), 1, loc("DB_STATUS_XP_BEGINNER_TT")},
		{loc("DB_STATUS_RP_EXP"), 2, loc("DB_STATUS_RP_EXP_TT")},
		{VOLUNTEER_ICON .. " " .. loc("DB_STATUS_RP_VOLUNTEER"), 3, loc("DB_STATUS_RP_VOLUNTEER_TT")},
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

	-- Tab bar
	local whatsNewText = loc("WHATS_NEW");
	local moreModuleText = loc("MORE_MODULES");
	local aboutText = loc("THANK_YOU");

	moreModuleText = Utils.str.toHTML(moreModuleText);
	whatsNewText = Utils.str.toHTML(whatsNewText);
	aboutText = Utils.str.toHTML(aboutText:format(TRP3_API.globals.version_display, TRP3_API.globals.version));

	local frame = CreateFrame("Frame", "TRP3_DashboardBottomTabBar", TRP3_DashboardBottom);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, 30);
	frame:SetFrameLevel(1);
	local tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{ loc("DB_NEW"), 1, 150 },
			{ loc("DB_ABOUT"), 2, 150 },
			{ loc("DB_MORE"), 3, 150 },
		},
		function(tabWidget, value)
			if value == 1 then
				TRP3_DashboardBottomContent:SetText(whatsNewText);
				TRP3_DashboardBottomContent.text = whatsNewText;
			elseif value == 2 then
				TRP3_DashboardBottomContent:SetText(aboutText);
				TRP3_DashboardBottomContent.text = aboutText;
			elseif value == 3 then
				TRP3_DashboardBottomContent:SetText(moreModuleText);
				TRP3_DashboardBottomContent.text = moreModuleText;
			end
		end
	);

	TRP3_DashboardBottomContent:SetFontObject("p", GameFontNormal);
	TRP3_DashboardBottomContent:SetFontObject("h1", GameFontNormalHuge3);
	TRP3_DashboardBottomContent:SetFontObject("h2", GameFontNormalHuge);
	TRP3_DashboardBottomContent:SetFontObject("h3", GameFontNormalLarge);
	TRP3_DashboardBottomContent:SetTextColor("h1", 1, 1, 1);
	TRP3_DashboardBottomContent:SetTextColor("h2", 1, 1, 1);
	TRP3_DashboardBottomContent:SetTextColor("h3", 1, 1, 1);
	TRP3_DashboardBottomContent:SetScript("OnHyperlinkClick", function(self, url, text, button)
		if url == "map" then
			MiniMapWorldMapButton:GetScript("OnClick")(MiniMapWorldMapButton, "LeftButton");
			C_Timer.After(0.5, function() TRP3_API.map.launchScan("playerScan"); end);
		elseif url == "glance" then
			TRP3_API.navigation.menu.selectMenu("main_10_player");
			TRP3_API.register.player.tabGroup:SelectTab(3);
			TRP3_RegisterMiscViewGlanceSlot1:GetScript("OnClick")(TRP3_RegisterMiscViewGlanceSlot1, "LeftButton");
		elseif url == "language" then
			if TRP3_API.toolbar then
				if not TRP3_Toolbar:IsVisible() then
					TRP3_API.toolbar.switch();
				end
				for i = 1, 1000 do
					if not _G["TRP3_ToolbarButton" .. i] then
						break;
					elseif _G["TRP3_ToolbarButton" .. i].buttonId == "ww_trp3_languages" then
						_G["TRP3_ToolbarButton" .. i]:GetScript("OnClick")(_G["TRP3_ToolbarButton" .. i], "LeftButton");
						break;
					end
				end
			end
		elseif url == "scandisable" then
			TRP3_API.navigation.menu.selectMenu("main_91_config_main_config_register");
		elseif url == "modules" then
			C_Timer.After(0.1, function()
				tabGroup:SelectTab(3);
			end);
		elseif url == "storyline" then
			TRP3_API.popup.showTextInputPopup("Storyline", nil, nil, "http://storyline.totalrp3.info");
		elseif url:sub(1, 7) == "twitter" then
			if Social_ToggleShow and button == "LeftButton" then
				Social_ToggleShow(url:gsub("twitter", "|cff61AAEE@") .. "|r ");
			else
				TRP3_API.popup.showTextInputPopup("|TInterface\\ICONS\\ability_garrison_orangebird:50|t\nTwitter profile", nil, nil, url);
			end

		end
	end);
	TRP3_DashboardBottomContent:SetScript("OnHyperlinkEnter", function(self, link, text)
		TRP3_MainTooltip:Hide();
		TRP3_MainTooltip:SetOwner(TRP3_DashboardBottomContent, "ANCHOR_CURSOR");

		if Social_ToggleShow and link:sub(1, 7) == "twitter" then
			TRP3_MainTooltip:AddLine(link:gsub("twitter", "|cff61AAEE@"), 1, 1, 1, true);
			TRP3_MainTooltip:AddLine("|cffffff00" .. loc("CM_CLICK") .. ":|r " .. loc("CM_TWEET")
				.. "|n|cffffff00" .. loc("CM_R_CLICK") .. ":|r " .. loc("CM_TWEET_PROFILE"), 1, 1, 1, true);
		else
			TRP3_MainTooltip:AddLine(text, 1, 1, 1, true);
			TRP3_MainTooltip:AddLine("|cffffff00" .. loc("CM_CLICK") .. ":|r " .. loc("CM_OPEN"), 1, 1, 1, true);
		end
		TRP3_MainTooltip:Show();
	end);
	TRP3_DashboardBottomContent:SetScript("OnHyperlinkLeave", function() TRP3_MainTooltip:Hide(); end);
	tabGroup:SelectTab(1);

	-- Resizing
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		TRP3_DashboardBottomContent:SetSize(containerwidth - 54, 5);
		TRP3_DashboardBottomContent:SetText(TRP3_DashboardBottomContent.text);
	end);
end

local function profileSelected(profileID)
	TRP3_API.profile.selectProfile(profileID);
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

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
					Uibutton:GetNormalTexture():SetTexture(GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("BackSlot"))) or "Interface\\ICONS\\INV_Misc_Cape_18");
					Uibutton:GetPushedTexture():SetTexture(GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("BackSlot"))) or "Interface\\ICONS\\INV_Misc_Cape_18");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOn, capeText3);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)

				if(ShowingCloak()) then
					playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);
					ShowCloak(false);
				else
					playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
					ShowCloak(true);
				end


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
					Uibutton:GetNormalTexture():SetTexture(GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("HeadSlot"))) or "Interface\\ICONS\\INV_Helmet_13");
					Uibutton:GetPushedTexture():SetTexture(GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("HeadSlot"))) or "Interface\\ICONS\\INV_Helmet_13");
					Uibutton:GetPushedTexture():SetDesaturated(1);
					setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOn, helmText3);
				end
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)

				if ShowingHelm() then
					ShowHelm(false);
					playUISound("Sound\\Interface\\Pickup\\Putdowncloth_Leather01.wav", true);

				else
					ShowHelm(true);
					playUISound("Sound\\Interface\\Pickup\\Pickupcloth_Leather01.wav", true);
				end


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
				playUISound("igMainMenuOptionCheckBoxOn");
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
		local rpText2 = color("y")..loc("CM_L_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_ON");
		rpText2 = rpText2.."\n"..color("y")..loc("CM_R_CLICK")..": "..color("w")..loc("TB_SWITCH_PROFILE");
		local rpText3 = color("y")..loc("CM_L_CLICK")..": "..color("w")..loc("TB_RPSTATUS_TO_OFF");
		rpText3 = rpText3.."\n"..color("y")..loc("CM_R_CLICK")..": "..color("w")..loc("TB_SWITCH_PROFILE");
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

				if button == "RightButton" then

					local list = getProfiles();

					local dropdownItems = {};
					tinsert(dropdownItems,{loc("TB_SWITCH_PROFILE"), nil});
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
					playUISound("igMainMenuOptionCheckBoxOn");
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