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
end

function TRP3_AutomationSettingsMixin:OnShow()
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
	self:PopulateActionDropDown();
end

function TRP3_AutomationSettingsMixin:OnActionSelected(actionID)
	self:SetSelectedActionID(actionID);
end

function TRP3_AutomationSettingsMixin:OnSaveButtonClicked()
	local actionID = self:GetSelectedActionID();
	local expression = self:GetEditorInputText();

	TRP3_AutomationUtil.SetActionExpression(actionID, expression);
end

function TRP3_AutomationSettingsMixin:OnTestButtonClicked()
	local expression = self:GetEditorInputText();
	local result = TRP3_AutomationUtil.ParseMacroOption(expression);

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

function TRP3_AutomationSettingsMixin:PopulateActionDropDown()
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

	self:SetEditorShown(action ~= nil);
	self:SetEditorExampleText(action and action.example or "");
	self:SetEditorInputText(action and action.expression or "");
	self:SetActionDropDownText(action and action.name or NONE);
end
