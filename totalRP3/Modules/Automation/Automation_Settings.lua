-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_AutomationSettingsMixin = {};

function TRP3_AutomationSettingsMixin:OnLoad()
	self:OnBackdropLoaded();

	self.TitleText:SetText(L.AUTOMATION_MODULE_SETTINGS_TITLE);
	self.DescriptionText:SetText(L.AUTOMATION_MODULE_DESCRIPTION);
	self.HelpText:SetText(L.AUTOMATION_MODULE_SETTINGS_HELP);

	self.Actions:SetDefaultText(NONE);
	self.Actions:SetupMenu(function(_, menuDescription) self:SetupActionDropdownMenu(menuDescription); end);
	self.Actions:HookScript("OnEnter", function() self:OnActionDropDownEnter(); end);
	self.Actions:HookScript("OnLeave", function() self:OnActionDropDownLeave(); end);

	self.Profiles:SetDefaultText(NONE);
	self.Profiles:SetupMenu(function(_, menuDescription) self:SetupProfileDropdownMenu(menuDescription); end);

	self.SaveButton:RegisterCallback("OnClick", self.OnSaveButtonClicked, self);
	self.TestButton:RegisterCallback("OnClick", self.OnTestButtonClicked, self);
	self.TestButton:SetText(L.AUTOMATION_TEST_BUTTON);
	self.TestButton:SetTooltipInfo(L.AUTOMATION_TEST_BUTTON, L.AUTOMATION_TEST_HELP);

	self.EditorEditBox = self.Editor.ScrollFrame:GetEditBox();
	self.EditorScrollBox = self.Editor.ScrollFrame:GetScrollBox();
	self.EditorScrollBar = self.Editor.ScrollBar;

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Editor, "TOPLEFT", 8, -6),
		AnchorUtil.CreateAnchor("BOTTOM", self.Editor, "BOTTOM", -8, 4),
		AnchorUtil.CreateAnchor("RIGHT", self.EditorScrollBar, "LEFT", -8, 0),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		scrollBoxAnchorsWithBar[2],
		AnchorUtil.CreateAnchor("RIGHT", self.Editor, "RIGHT", -8, 0),
	};

	ScrollUtil.RegisterScrollBoxWithScrollBar(self.EditorScrollBox, self.EditorScrollBar);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.EditorScrollBox, self.EditorScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);

	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileChanged", "Update");
	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileModified", "Update");
	TRP3_AutomationEvents.RegisterCallback(self, "OnProfileDeleted", "Update");
end

function TRP3_AutomationSettingsMixin:OnShow()
	self:Update();
end

function TRP3_AutomationSettingsMixin:OnActionDropDownEnter()
	local function OnTooltipShow(tooltip)
		local action = self:GetSelectedAction();

		if not action then
			return;
		end

		local wrap = true;
		GameTooltip_SetTitle(tooltip, action.name);
		GameTooltip_AddNormalLine(tooltip, action.description or "", wrap);

		if action.help then
			GameTooltip_AddBlankLineToTooltip(tooltip);
			GameTooltip_AddNormalLine(tooltip, action.help, wrap);
		end
	end

	TRP3_MenuUtil.ShowTooltip(self.Actions, OnTooltipShow);
end

function TRP3_AutomationSettingsMixin:OnActionDropDownLeave()
	TRP3_MenuUtil.HideTooltip(self.Actions);
end

function TRP3_AutomationSettingsMixin:SetupActionDropdownMenu(menuDescription)
	local actions = TRP3_AutomationUtil.GetRegisteredActions();

	local function SortCompareActions(a, b)
		if a.category ~= b.category then
			return TRP3_StringUtil.SortCompareStrings(a.category, b.category);
		else
			return TRP3_StringUtil.SortCompareStrings(a.name, b.name);
		end
	end

	table.sort(actions, SortCompareActions);

	local function IsSelected(action)
		return action.id == self:GetSelectedActionID();
	end

	local function SetSelected(action)
		self:SetSelectedActionID(action.id);
	end

	local category = nil;

	for _, action in ipairs(actions) do
		if action.category ~= category then
			menuDescription:CreateTitle(action.category);
			category = action.category;
		end

		local displayText = action.name;
		local displayIcon;
		local tooltipText = string.join("|n|n", action.description, action.help);

		if action.expression and action.expression ~= "" then
			displayIcon = [[Interface\WorldMap\GEAR_64GREY]];
		end

		local button = menuDescription:CreateRadio(displayText, IsSelected, SetSelected, action);
		TRP3_MenuUtil.AttachTexture(button, displayIcon);
		TRP3_MenuUtil.SetElementTooltip(button, tooltipText);
	end
end

local function OnCreateProfileSelected()
	StaticPopup_Show("TRP3_AUTOMATION_CREATE_PROFILE");
end

local function OnEnableProfileSelected(profileName)
	TRP3_AutomationUtil.SetCurrentProfile(profileName);
end

local function OnCopyProfileSelected(profileName)
	local textArg1 = TRP3_AutomationUtil.GetCurrentProfile();
	local textArg2 = profileName;
	local data = profileName;

	StaticPopup_Show("TRP3_AUTOMATION_COPY_PROFILE", textArg1, textArg2, data);
end

local function OnDeleteProfileSelected(profileName)
	local textArg1 = profileName;
	local textArg2 = nil;
	local data = profileName;

	StaticPopup_Show("TRP3_AUTOMATION_DELETE_PROFILE", textArg1, textArg2, data);
end

local function OnResetProfileSelected()
	local textArg1 = TRP3_AutomationUtil.GetCurrentProfile();
	local textArg2 = nil;
	local data = TRP3_AutomationUtil.GetCurrentProfile();

	StaticPopup_Show("TRP3_AUTOMATION_RESET_PROFILE", textArg1, textArg2, data);
end

local function SetupProfileActionMenu(menuDescription, profileName)
	-- Enable profile button

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		local callback = function() OnEnableProfileSelected(profileName); end;
		local button = menuDescription:CreateButton(L.AUTOMATION_PROFILE_ENABLE, callback);
		TRP3_MenuUtil.SetElementTooltip(button, L.AUTOMATION_PROFILE_ENABLE_HELP);
	end

	-- Copy profile button; this doesn't make sense to show for the current
	-- profile as AceDB's idea of "copying" a profile means to import all of
	-- the settings from another named profile into the current one.

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		local callback = function() OnCopyProfileSelected(profileName); end;
		local button = menuDescription:CreateButton(L.AUTOMATION_PROFILE_COPY, callback);
		TRP3_MenuUtil.SetElementTooltip(button, L.AUTOMATION_PROFILE_COPY_HELP);
	end

	-- Delete profile button; AceDB doesn't allow us to delete the current
	-- profile so don't show it for the active one.
	--
	-- Additionally we don't want to allow users to delete the default
	-- profile. If they do it'll get recreated when they log into a new
	-- character anyway.

	if not TRP3_AutomationUtil.IsCurrentProfile(profileName) and not TRP3_AutomationUtil.IsDefaultProfile(profileName) then
		local callback = function() OnDeleteProfileSelected(profileName); end;
		local button = menuDescription:CreateButton(L.AUTOMATION_PROFILE_DELETE, callback);
		TRP3_MenuUtil.SetElementTooltip(button, L.AUTOMATION_PROFILE_DELETE_HELP);
	end

	-- Reset profile button; AceDB only allows this to work on the currently
	-- selected profile.

	if TRP3_AutomationUtil.IsCurrentProfile(profileName) then
		local callback = function() OnResetProfileSelected(); end;
		local button = menuDescription:CreateButton(L.AUTOMATION_PROFILE_RESET, callback);
		TRP3_MenuUtil.SetElementTooltip(button, L.AUTOMATION_PROFILE_RESET_HELP);
	end
end

function TRP3_AutomationSettingsMixin:SetupProfileDropdownMenu(menuDescription)
	local profiles = TRP3_AutomationUtil.GetAllProfiles();
	local currentProfileName = TRP3_AutomationUtil.GetCurrentProfile();

	local function SortCompareProfiles(a, b)
		return TRP3_StringUtil.SortCompareStrings(a, b);
	end

	table.sort(profiles, SortCompareProfiles);

	local function IsSelected(profileName)
		return profileName == currentProfileName;
	end

	local function SetSelected(profileName)
		OnEnableProfileSelected(profileName);
	end

	for _, profileName in ipairs(profiles) do
		local button = menuDescription:CreateRadio(profileName, IsSelected, SetSelected, profileName);
		button:SetShouldRespondIfSubmenu(true);
		button:SetShouldPlaySoundOnSubmenuClick(true);
		SetupProfileActionMenu(button, profileName);
	end

	menuDescription:QueueDivider();

	do  -- Create Profile button
		local callback = function() OnCreateProfileSelected(); end;
		local button = menuDescription:CreateButton(L.AUTOMATION_PROFILE_CREATE, callback);
		TRP3_MenuUtil.SetElementTooltip(button, L.AUTOMATION_PROFILE_CREATE_HELP);
	end
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
	self.Actions:OverrideText(action and action.name or NONE);
	self.Profiles:OverrideText(currentProfileName);
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
