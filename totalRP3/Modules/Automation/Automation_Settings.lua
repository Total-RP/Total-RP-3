-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_AutomationSettingsMixin = {};

function TRP3_AutomationSettingsMixin:OnLoad()
	self:TooltipBackdropOnLoad();

	self.TitleText:SetText(L.AUTOMATION_MODULE_SETTINGS_TITLE);
	self.DescriptionText:SetText(L.AUTOMATION_MODULE_DESCRIPTION);
	self.HelpText:SetText(L.AUTOMATION_MODULE_SETTINGS_HELP);

	MSA_DropDownMenu_SetInitializeFunction(self.Actions, function(_, ...) self:OnActionDropDownInitialize(...); end);
	MSA_DropDownMenu_SetWidth(self.Actions, self.Actions:GetWidth());
	self.Actions:SetScript("OnEnter", function(_, ...) self:OnActionDropDownEnter(...); end);
	self.Actions:SetScript("OnLeave", function(_, ...) self:OnActionDropDownLeave(...); end);

	MSA_DropDownMenu_SetInitializeFunction(self.Profiles, function(_, ...) self:OnProfileDropDownInitialize(...); end);
	MSA_DropDownMenu_SetWidth(self.Profiles, self.Profiles:GetWidth());
	-- self.Profiles:SetScript("OnEnter", function(_, ...) self:OnProfileDropDownEnter(...); end);
	-- self.Profiles:SetScript("OnLeave", function(_, ...) self:OnProfileDropDownLeave(...); end);

	self.SaveButton:RegisterCallback("OnClick", self.OnSaveButtonClicked, self);
	self.TestButton:RegisterCallback("OnClick", self.OnTestButtonClicked, self);
	self.TestButton:SetText(L.AUTOMATION_TEST_BUTTON);
	self.TestButton:SetTooltipInfo(L.AUTOMATION_TEST_BUTTON, L.AUTOMATION_TEST_HELP);

	self.EditorEditBox = self.Editor.ScrollFrame:GetEditBox();
	self.EditorScrollBox = self.Editor.ScrollFrame:GetScrollBox();
	self.EditorScrollBar = self.Editor.ScrollBar;

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Editor, "TOPLEFT", 8, -8),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.EditorScrollBar, "BOTTOMLEFT", -4, 4),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.Editor, "BOTTOMRIGHT", -8, 8),
	};

	ScrollUtil.RegisterScrollBoxWithScrollBar(self.EditorScrollBox, self.EditorScrollBar);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.EditorScrollBox, self.EditorScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);

	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileChanged");
	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileModified");
	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileDeleted");
end

function TRP3_AutomationSettingsMixin:OnShow()
	self:Update();
end

function TRP3_AutomationSettingsMixin:OnProfileChanged()
	self:Update();
end

function TRP3_AutomationSettingsMixin:OnProfileModified()
	self:Update();
end

function TRP3_AutomationSettingsMixin:OnProfileDeleted()
	self:Update();
end

function TRP3_AutomationSettingsMixin:OnActionDropDownEnter()
	local tooltip = TRP3_MainTooltip;
	tooltip:SetOwner(self.Actions, "ANCHOR_RIGHT");
	self:PopulateActionTooltip(tooltip);
	tooltip:Show();
end

function TRP3_AutomationSettingsMixin:OnActionDropDownLeave()
	local tooltip = TRP3_MainTooltip;

	if tooltip:IsOwned(self.Actions) then
		tooltip:Hide();
	end
end

function TRP3_AutomationSettingsMixin:OnActionDropDownInitialize()
	self:PopulateActionsDropDown();
end

function TRP3_AutomationSettingsMixin:OnActionSelected(actionID)
	self:SetSelectedActionID(actionID);
end

function TRP3_AutomationSettingsMixin:OnActionDropDownInitialize()
	self:PopulateActionsDropDown();
end

function TRP3_AutomationSettingsMixin:OnProfileDropDownInitialize()
	self:PopulateProfilesDropDown();
end

function TRP3_AutomationSettingsMixin:OnCreateProfileSelected()
	StaticPopup_Show("TRP3_AUTOMATION_CREATE_PROFILE");
	MSA_CloseDropDownMenus();
end

function TRP3_AutomationSettingsMixin:OnEnableProfileSelected(profileName)
	TRP3_AutomationUtil.SetCurrentProfile(profileName);
	MSA_CloseDropDownMenus();
end

function TRP3_AutomationSettingsMixin:OnCopyProfileSelected(profileName)
	local textArg1 = TRP3_AutomationUtil.GetCurrentProfile();
	local textArg2 = profileName;
	local data = profileName;

	StaticPopup_Show("TRP3_AUTOMATION_COPY_PROFILE", textArg1, textArg2, data);
	MSA_CloseDropDownMenus();
end

function TRP3_AutomationSettingsMixin:OnDeleteProfileSelected(profileName)
	local textArg1 = profileName;
	local textArg2 = nil;
	local data = profileName;

	StaticPopup_Show("TRP3_AUTOMATION_DELETE_PROFILE", textArg1, textArg2, data);
	MSA_CloseDropDownMenus();
end

function TRP3_AutomationSettingsMixin:OnResetProfileSelected()
	local textArg1 = TRP3_AutomationUtil.GetCurrentProfile();
	local textArg2 = nil;
	local data = TRP3_AutomationUtil.GetCurrentProfile();

	StaticPopup_Show("TRP3_AUTOMATION_RESET_PROFILE", textArg1, textArg2, data);
	MSA_CloseDropDownMenus();
end

function TRP3_AutomationSettingsMixin:OnSaveButtonClicked()
	local actionID = self:GetSelectedActionID();
	local expression = self:GetEditorInputText();

	TRP3_AutomationUtil.SetActionExpression(actionID, expression);
end

function TRP3_AutomationSettingsMixin:OnTestButtonClicked()
	local expression = self:GetEditorInputText();
	local result = TRP3_AutomationUtil.ParseMacroOption(expression);

	TRP3_Automation:ResetMessageCooldowns();
	TRP3_Addon:Printf(L.AUTOMATION_TEST_OUTPUT, string.format("|cff33ff99%s|r", result));
end

function TRP3_AutomationSettingsMixin:GetSelectedAction()
	return TRP3_AutomationUtil.GetActionByID(self.selectedActionID);
end

function TRP3_AutomationSettingsMixin:GetSelectedActionID()
	return self.selectedActionID;
end

function TRP3_AutomationSettingsMixin:SetSelectedActionID(actionID)
	if self.selectedActionID ~= actionID then
		self.selectedActionID = actionID;
		self:Update();
	end
end

function TRP3_AutomationSettingsMixin:PopulateActionsDropDown()
	local actions = TRP3_AutomationUtil.GetRegisteredActions();

	local function SortCompareActions(a, b)
		if a.category ~= b.category then
			return TRP3_StringUtil.SortCompareStrings(a.category, b.category);
		else
			return TRP3_StringUtil.SortCompareStrings(a.name, b.name);
		end
	end

	table.sort(actions, SortCompareActions);

	local category = nil;

	for _, action in ipairs(actions) do
		if action.category ~= category then
			MSA_DropDownMenu_AddButton({ text = action.category, isTitle = true, notCheckable = true });
			category = action.category;
		end

		local displayText = action.name;
		local displayIcon;

		if action.expression and action.expression ~= "" then
			displayText = string.format("|cff33ff99%s|r", displayText);
			displayIcon = [[Interface\Scenarios\ScenarioIcon-Interact]];
		end

		MSA_DropDownMenu_AddButton({
			text = displayText,
			icon = displayIcon,
			padding = 16,
			func = function() self:OnActionSelected(action.id); end,
			notCheckable = true,
			tooltipTitle = action.name,
			tooltipText = table.concat({ action.description, action.help }, "|n|n"),
			tooltipOnButton = true,
		});
	end
end

function TRP3_AutomationSettingsMixin:PopulateActionTooltip(tooltip)
	local action = self:GetSelectedAction();
	local wrap = true;

	if action then
		GameTooltip_SetTitle(tooltip, action.name);
		GameTooltip_AddNormalLine(tooltip, action.description or "", wrap);

		if action.help then
			GameTooltip_AddBlankLineToTooltip(tooltip);
			GameTooltip_AddNormalLine(tooltip, action.help, wrap);
		end
	end
end

function TRP3_AutomationSettingsMixin:SetActionDropDownText(text)
	MSA_DropDownMenu_SetText(self.Actions, text);
end

function TRP3_AutomationSettingsMixin:PopulateProfileListMenu(menuLevel)
	local profiles = TRP3_AutomationUtil.GetAllProfiles();
	local currentProfileName = TRP3_AutomationUtil.GetCurrentProfile();

	local function SortCompareProfiles(a, b)
		return TRP3_StringUtil.SortCompareStrings(a, b);
	end

	table.sort(profiles, SortCompareProfiles);

	for _, profileName in ipairs(profiles) do
		local displayText = profileName;

		if profileName == currentProfileName then
			displayText = string.format("|cff33ff99%s|r", profileName);
		end

		MSA_DropDownMenu_AddButton({
			text = displayText,
			value = profileName,
			func = function() self:OnEnableProfileSelected(profileName); end,
			notCheckable = true,
			hasArrow = true,
		}, menuLevel);
	end

	MSA_DropDownMenu_AddSeparator({}, menuLevel);

	MSA_DropDownMenu_AddButton({
		text = "Create profile",
		func = function() self:OnCreateProfileSelected(); end,
		notCheckable = true,
		tooltipTitle = L.AUTOMATION_PROFILE_CREATE,
		tooltipText = L.AUTOMATION_PROFILE_CREATE_HELP,
		tooltipOnButton = true,
	}, menuLevel);
end

function TRP3_AutomationSettingsMixin:PopulateProfileActionMenu(menuLevel, profileName)
	-- Enable profile button.

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		MSA_DropDownMenu_AddButton({
			text = "Enable profile",
			func = function() self:OnEnableProfileSelected(profileName); end,
			notCheckable = true,
			tooltipTitle = L.AUTOMATION_PROFILE_ENABLE,
			tooltipText = L.AUTOMATION_PROFILE_ENABLE_HELP,
			tooltipOnButton = true,
		}, menuLevel);
	end

	-- Copy profile button; this doesn't make sense to show for the current
	-- profile as AceDB's idea of "copying" a profile means to import all of
	-- the settings from another named profile into the current one.

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		MSA_DropDownMenu_AddButton({
			text = "Copy profile",
			func = function() self:OnCopyProfileSelected(profileName); end,
			notCheckable = true,
			tooltipTitle = L.AUTOMATION_PROFILE_COPY,
			tooltipText = L.AUTOMATION_PROFILE_COPY_HELP,
			tooltipOnButton = true,
		}, menuLevel);
	end

	-- Delete profile button; AceDB doesn't allow us to delete the current
	-- profile so don't show it for the active one.
	--
	-- Additionally we don't want to allow users to delete the default
	-- profile. If they do it'll get recreated when they log into a new
	-- character anyway.

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) and not TRP3_AutomationUtil.IsDefaultProfile(profileName) then
		MSA_DropDownMenu_AddButton({
			text = "Delete profile",
			func = function() self:OnDeleteProfileSelected(profileName); end,
			notCheckable = true,
			tooltipTitle = L.AUTOMATION_PROFILE_DELETE,
			tooltipText = L.AUTOMATION_PROFILE_DELETE_HELP,
			tooltipOnButton = true,
		}, menuLevel);
	end

	-- Reset profile button; AceDB only allows this to work on the currently
	-- selected profile.

	if TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		MSA_DropDownMenu_AddButton({
			text = "Reset profile",
			func = function() self:OnResetProfileSelected(); end,
			notCheckable = true,
			tooltipTitle = L.AUTOMATION_PROFILE_RESET,
			tooltipText = L.AUTOMATION_PROFILE_RESET_HELP,
			tooltipOnButton = true,
		}, menuLevel);
	end
end

function TRP3_AutomationSettingsMixin:PopulateProfilesDropDown()
	local menuLevel = MSA_DROPDOWNMENU_MENU_LEVEL;

	if menuLevel == 1 then
		self:PopulateProfileListMenu(menuLevel);
	elseif menuLevel == 2 then
		local profileName = MSA_DROPDOWNMENU_MENU_VALUE;
		self:PopulateProfileActionMenu(menuLevel, profileName);
	end
end

function TRP3_AutomationSettingsMixin:SetProfileDropDownText(text)
	MSA_DropDownMenu_SetText(self.Profiles, text);
end

function TRP3_AutomationSettingsMixin:SetEditorExampleText(exampleText)
	-- This ordering of calls is important as repeated calls to
	-- ApplyDefaultText don't work unless the input text is cleared.

	local inputText = self.EditorEditBox:GetInputText();

	self.EditorEditBox:SetText("");
	self.EditorEditBox:ApplyDefaultText(exampleText);
	self.EditorEditBox:ApplyText(inputText);
end

function TRP3_AutomationSettingsMixin:GetEditorInputText()
	return self.EditorEditBox:GetInputText();
end

function TRP3_AutomationSettingsMixin:SetEditorInputText(inputText)
	self.EditorEditBox:ApplyText(inputText);
end

function TRP3_AutomationSettingsMixin:SetEditorShown(shown)
	for _, frame in ipairs(self.editorFrames) do
		frame:SetShown(shown);
	end
end

function TRP3_AutomationSettingsMixin:Update()
	local action = self:GetSelectedAction();
	local currentProfileName = TRP3_AutomationUtil.GetCurrentProfile();

	self:SetEditorShown(action ~= nil);
	self:SetEditorExampleText(action and action.example or "");
	self:SetEditorInputText(action and action.expression or "");
	self:SetActionDropDownText(action and action.name or NONE);
	self:SetProfileDropDownText(currentProfileName);
end

------------------------------------------------------------------------------
-- Static Popup Dialogs

do
	local function IsValidProfileName(profileName)
		return string.trim(profileName) ~= "" and not TRP3_AutomationUtil.DoesProfileExist(profileName);
	end

	local function OnDialogAccept(self)
		local profileName = self.editBox:GetText();

		if IsValidProfileName(profileName) then
			TRP3_AutomationUtil.SetCurrentProfile(profileName);
		end
	end

	local function OnDialogShow(self)
		self.editBox:SetText(TRP3_AutomationUtil.GenerateProfileName());
	end

	local function OnDialogEditBoxEnterPressed(self)
		local parent = self:GetParent();
		parent.button1:Click();
	end

	local function OnDialogEditBoxTextChanged(self)
		local parent = self:GetParent();
		local profileName = self:GetText();

		parent.button1:SetEnabled(IsValidProfileName(profileName));
	end

	local function OnDialogEditBoxEscapePressed(self)
		local parent = self:GetParent();
		parent:Hide();
	end

	StaticPopupDialogs["TRP3_AUTOMATION_CREATE_PROFILE"] = {
		text = L.AUTOMATION_PROFILE_CREATE_DIALOG_TITLE,
		button1 = L.AUTOMATION_PROFILE_CREATE_DIALOG_BUTTON1,
		button2 = CANCEL,
		hasEditBox = 1,
		OnAccept = OnDialogAccept,
		OnShow = OnDialogShow,
		EditBoxOnEnterPressed = OnDialogEditBoxEnterPressed,
		EditBoxOnTextChanged = OnDialogEditBoxTextChanged,
		EditBoxOnEscapePressed = OnDialogEditBoxEscapePressed,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	};
end

do
	local function OnDialogAccept(self)
		local profileName = self.data;
		TRP3_AutomationUtil.CopyProfile(profileName);
	end

	StaticPopupDialogs["TRP3_AUTOMATION_COPY_PROFILE"] = {
		text = L.AUTOMATION_PROFILE_COPY_DIALOG_TITLE,
		button1 = L.AUTOMATION_PROFILE_COPY_DIALOG_BUTTON1,
		button2 = CANCEL,
		OnAccept = OnDialogAccept,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	};
end

do
	local function OnDialogAccept(self)
		local profileName = self.data;
		TRP3_AutomationUtil.DeleteProfile(profileName);
	end

	StaticPopupDialogs["TRP3_AUTOMATION_DELETE_PROFILE"] = {
		text = L.AUTOMATION_PROFILE_DELETE_DIALOG_TITLE,
		button1 = DELETE,
		button2 = CANCEL,
		OnAccept = OnDialogAccept,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	};
end

do
	local function OnDialogAccept(self)
		TRP3_AutomationUtil.ResetCurrentProfile();
	end

	StaticPopupDialogs["TRP3_AUTOMATION_RESET_PROFILE"] = {
		text = L.AUTOMATION_PROFILE_RESET_DIALOG_TITLE,
		button1 = RESET,
		button2 = CANCEL,
		OnAccept = OnDialogAccept,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	};
end
