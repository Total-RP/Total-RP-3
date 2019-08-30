----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local TRP3_Config = TRP3_API.configuration;
local TRP3_Enums = AddOn_TotalRP3.Enums;
local TRP3_Events = TRP3_API.events;

local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local getProfiles = TRP3_API.profile.getProfiles;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local color = Utils.str.color;
local playUISound = TRP3_API.ui.misc.playUISound;
local refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local setPage = TRP3_API.navigation.page.setPage;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local is_classic = Globals.is_classic;

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
	if get("player/character/RP") == TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		onStatusChange(TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
	else
		onStatusChange(TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER);
	end
end
TRP3_API.dashboard.switchStatus = switchStatus;

local function onShow()
	TRP3_DashboardStatus.RPStatus:UpdateSelectedListItem();
	TRP3_DashboardStatus.XPStatus:UpdateSelectedListItem();
	TRP3_DashboardStatus.RPLanguage:UpdateSelectedListItem();
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

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(_, _, dataType)
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
		local Button_Status = {
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
					buttonStructure.icon = is_classic and "Ability_Warrior_Challange" or "Ability_Mage_IncantersAbsorbtion";
				elseif UnitIsAFK("player") then
					buttonStructure.tooltip  = status2Text;
					buttonStructure.tooltipSub  = status2SubText;
					buttonStructure.icon = "Spell_Nature_Sleep";
				else
					buttonStructure.tooltip  = status3Text;
					buttonStructure.tooltipSub  = status3SubText;
					buttonStructure.icon = is_classic and "Ability_Stealth" or "Ability_Rogue_MasterOfSubtlety";
				end
			end,
			onClick = function(_, _, button)
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
		local RP_ICON, OOC_ICON = "spell_shadow_charm", is_classic and "Achievement_GuildPerk_EverybodysFriend" or "Inv_misc_grouplooking";
		local rpTextOn = loc.TB_RPSTATUS_ON;
		local rpTextOff = loc.TB_RPSTATUS_OFF;
		local rpText2 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_ON;
		rpText2 = rpText2.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;
		local rpText3 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_OFF;
		rpText3 = rpText3.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;

		local Button_RPStatus = {
			id = "aa_trp3_rpstatus",
			icon = "Inv_misc_grouplooking",
			configText = loc.CO_TOOLBAR_CONTENT_RPSTATUS,
			onEnter = function() end,
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
			onClick = function(Uibutton, _, button)

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

--- Mixin for dropdown menus on the dashboard status frame. These widgets
--  come with an attached label for the control and a dropdown as a subframe.
local DashboardStatusDropDownMixin = {};
TRP3_DashboardStatusDropDownMixin = DashboardStatusDropDownMixin;

--- Handler called when the dropdown is loaded.
function DashboardStatusDropDownMixin:OnLoad()
	-- Initialize all Dashboard status dropdowns with a common width.
	MSA_DropDownMenu_SetWidth(self.DropDown, 170);

	-- Callbacks used by the dropdown API.
	self.onDropDownInitialize = function(...)
		self:VisualizeListModel(...);
	end

	self.onDropDownItemClicked = function(...)
		self:OnListItemClicked(...)
	end

	-- Subscribe to important events.
	TRP3_Events.registerCallback(TRP3_Events.WORKFLOW_ON_LOADED, function()
		self:OnAddOnWorkflowLoaded();
	end);
end

--- Handler called when the WORKFLOW_ON_LOADED event is raised.
function DashboardStatusDropDownMixin:OnAddOnWorkflowLoaded()
	-- Defer registering config handlers to here, since OnLoad is too early.
	TRP3_Config.registerHandler({ "AddonLocale" }, function()
		self:OnAddOnLocaleChanged();
	end);

	self:LocalizeUI();
end

--- Handler called when the selected locale for the addon changes.
function DashboardStatusDropDownMixin:OnAddOnLocaleChanged()
	self:LocalizeUI();
end

--- Handler called when an item in the list model is clicked.
function DashboardStatusDropDownMixin:OnListItemClicked(item)
	self:SetSelectedListItem(item.value);
end

--- Returns the localization key used by the UI label.
function DashboardStatusDropDownMixin:GetLabelTextKey()
	return self.labelTextKey;
end

--- Sets the localization key used by the UI label.
function DashboardStatusDropDownMixin:SetLabelTextKey(labelTextKey)
	self.labelTextKey = labelTextKey;
	self:LocalizeUI();
end

--- Returns the list model displayed by the dropdown menu widget.
function DashboardStatusDropDownMixin:GetListModel()
	return self.listModel;
end

--- Replaces the list model displayed by the dropdown menu widget.
function DashboardStatusDropDownMixin:SetListModel(listModel)
	self.listModel = listModel;

	MSA_DropDownMenu_Initialize(self.DropDown, self.onDropDownInitialize);
end

--- Returns the currently selected list item value.
function DashboardStatusDropDownMixin:GetSelectedListItem()
	return self.DropDown.selectedValue;
end

--- Sets the currently selected list item value.
function DashboardStatusDropDownMixin:SetSelectedListItem(value)
	-- Don't use the _SetSelected* type functions as they're not reliable
	-- if we're not the open/initializing menu. Instead, do it by hand.
	self.DropDown.selectedValue = value;
	self:RefreshListModel();
end

--- Updates the UI to apply any localization-specific changes.
function DashboardStatusDropDownMixin:LocalizeUI()
	self.Label:SetText(loc:GetText(self:GetLabelTextKey()) or "");
end

--- Refreshes the dropdown list from the contents of the assigned model.
function DashboardStatusDropDownMixin:RefreshListModel()
	-- Refresh the full menu only if open.
	if MSA_DROPDOWNMENU_OPEN_MENU == self.DropDown then
		MSA_DropDownMenu_RefreshAll(self.DropDown);
		return;
	end

	-- The menu isn't open, but we can update the text on the widget at least.
	-- The default is "Custom", in line with the stock UI.
	local text = VIDEO_QUALITY_LABEL6;
	local listModel = self:GetListModel();
	if self.DropDown.selectedValue ~= nil and listModel then
		for listIndex = 1, #listModel do
			local listItem = listModel[listIndex];
			if listItem.value == self.DropDown.selectedValue then
				text = listItem.text;
				break;
			end
		end
	end

	MSA_DropDownMenu_SetText(self.DropDown, text);
end

--- Populates a dropdown menu based off the contents of the assigned model.
function DashboardStatusDropDownMixin:VisualizeListModel(_, level)
	local listModel = self:GetListModel();
	if not listModel or (level and level > 1) then
		-- No model assigned, or you're (somehow) building a tree.
		return;
	end

	for listIndex = 1, #listModel do
		local listItem = listModel[listIndex];
		local menuItem = MSA_DropDownMenu_CreateInfo();

		if listItem.class == "separator" then
			MSA_DropDownMenu_AddSeparator(menuItem, level);
		else
			-- The list item fields are passed through, but we'll set some
			-- common sense defaults.
			menuItem.func = self.onDropDownItemClicked;
			menuItem.tooltipOnButton = true;
			Mixin(menuItem, listItem);

			-- And we'll apply more defaults afterwards.
			if menuItem.tooltipText and not menuItem.tooltipTitle then
				-- Has tooltip text but no title; use item text.
				menuItem.tooltipTitle = menuItem.text;
			end

			MSA_DropDownMenu_AddButton(menuItem, level);
		end
	end
end

--- Mixin for the RP Status dropdown widget.
local RPStatusDropDownMixin = CreateFromMixins(DashboardStatusDropDownMixin);
TRP3_RPStatusDropDownMixin = RPStatusDropDownMixin;

function RPStatusDropDownMixin:OnAddOnWorkflowLoaded()
	DashboardStatusDropDownMixin.OnAddOnWorkflowLoaded(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function RPStatusDropDownMixin:OnAddOnLocaleChanged()
	DashboardStatusDropDownMixin.OnAddOnLocaleChanged(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function RPStatusDropDownMixin:OnListItemClicked(item)
	DashboardStatusDropDownMixin.OnListItemClicked(self, item);

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.RP == item.value then
		-- Value isn't changing.
		return;
	end

	character.RP = item.value;
	incrementCharacterVernum();
end

function RPStatusDropDownMixin:UpdateListModel()
	-- Build the model for the dropdown.
	local OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15|t";
	local IC_ICON = "|TInterface\\COMMON\\Indicator-Green:15|t";

	self:SetListModel({
		{
			text = format(loc.DB_STATUS_ICON_ITEM, IC_ICON, loc.DB_STATUS_RP_IC),
			value = TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER,
			tooltipText = loc.DB_STATUS_RP_IC_TT,
		},
		{
			text = format(loc.DB_STATUS_ICON_ITEM, OOC_ICON, loc.DB_STATUS_RP_OOC),
			value = TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER,
			tooltipText = loc.DB_STATUS_RP_OOC_TT,
		},
	});
end

function RPStatusDropDownMixin:UpdateSelectedListItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	self:SetSelectedListItem(currentUser:GetRoleplayStatus());
end

--- Mixin for the RP experience dropdown widget.
local XPStatusDropDownMixin = CreateFromMixins(DashboardStatusDropDownMixin);
TRP3_XPStatusDropDownMixin = XPStatusDropDownMixin;

function XPStatusDropDownMixin:OnAddOnWorkflowLoaded()
	DashboardStatusDropDownMixin.OnAddOnWorkflowLoaded(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function XPStatusDropDownMixin:OnAddOnLocaleChanged()
	DashboardStatusDropDownMixin.OnAddOnLocaleChanged(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function XPStatusDropDownMixin:OnListItemClicked(item)
	DashboardStatusDropDownMixin.OnListItemClicked(self, item);

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.XP == item.value then
		-- Value isn't changing.
		return;
	end

	character.XP = item.value;
	incrementCharacterVernum();
end

function XPStatusDropDownMixin:UpdateListModel()
	-- Build the model for the dropdown.
	local ICON_BEGINNER = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20|t";
	local ICON_VOLUNTEER = "|TInterface\\TARGETINGFRAME\\PortraitQuestBadge:15|t";

	self:SetListModel({
		{
			text = format(loc.DB_STATUS_ICON_ITEM, ICON_BEGINNER, loc.DB_STATUS_XP_BEGINNER),
			value = TRP3_Enums.ROLEPLAY_EXPERIENCE.BEGINNER,
			tooltipText = loc.DB_STATUS_XP_BEGINNER_TT,
		},
		{
			text = loc.DB_STATUS_RP_EXP,
			value = TRP3_Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED,
			tooltipTitle = loc.DB_STATUS_RP_EXP,
			tooltipText = loc.DB_STATUS_RP_EXP_TT,
		},
		{
			text = format(loc.DB_STATUS_ICON_ITEM, ICON_VOLUNTEER, loc.DB_STATUS_RP_VOLUNTEER),
			value = TRP3_Enums.ROLEPLAY_EXPERIENCE.VOLUNTEER,
			tooltipText = loc.DB_STATUS_RP_VOLUNTEER_TT,
		},
	});
end

function XPStatusDropDownMixin:UpdateSelectedListItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	self:SetSelectedListItem(currentUser:GetRoleplayExperience());
end


--- Mixin for the RP language widget.
local RPLanguageDropDownMixin = CreateFromMixins(DashboardStatusDropDownMixin);
TRP3_RPLanguageDropDownMixin = RPLanguageDropDownMixin;

function RPLanguageDropDownMixin:OnAddOnWorkflowLoaded()
	DashboardStatusDropDownMixin.OnAddOnWorkflowLoaded(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function RPLanguageDropDownMixin:OnAddOnLocaleChanged()
	DashboardStatusDropDownMixin.OnAddOnLocaleChanged(self);

	self:UpdateListModel();
	self:UpdateSelectedListItem();
end

function RPLanguageDropDownMixin:OnListItemClicked(item)
	DashboardStatusDropDownMixin.OnListItemClicked(self, item);

	-- Translate special locale entries to values suitable for storage
	-- in the profile.
	local localeCode = item.value;
	if localeCode == self.LocaleCodeDefault then
		local locale = loc:GetActiveLocale();
		localeCode = locale and locale:GetCode() or nil;
	end

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.LC == localeCode then
		-- Locale code isn't changing.
		return;
	end

	character.LC = localeCode;
	incrementCharacterVernum();
end

function RPLanguageDropDownMixin:UpdateListModel()
	-- Grab all the registered locale codes and sort them.
	local localeCodes = {};
	for localeCode in pairs(loc:GetLocales(true)) do
		table.insert(localeCodes, localeCode);
	end

	table.sort(localeCodes);

	-- Add all the locales to the model.
	local model = {};

	for _, localeCode in ipairs(localeCodes) do
		local locale = loc:GetLocale(localeCode);
		table.insert(model, {
			text = locale:GetName(),
			value = localeCode,
			radio = true,
		});
	end

	self:SetListModel(model);
end

function RPLanguageDropDownMixin:UpdateSelectedListItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local localeCode = currentUser:GetRoleplayLanguage();
	if localeCode == nil then
		-- A nil locale code translates to "whatever the addon locale is".
		localeCode = self.LocaleCodeDefault;
	end

	self:SetSelectedListItem(localeCode);
end
