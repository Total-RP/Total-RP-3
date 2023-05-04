-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local Settings = {
	Bindings = "Launcher_Bindings",
	LockMinimapButton = "Launcher_LockMinimapButton",
	MinimapButtonPosition = "Launcher_MinimapButtonPosition",
	ShowAddonCompartmentButton = "Launcher_ShowAddonCompartmentButton",
	ShowMinimapButton = "Launcher_ShowMinimapButton",
};

local DefaultBindings = {
	["BUTTON1"] = "trp3:open",
	["BUTTON2"] = "trp3:toolbar",
};

TRP3_LauncherSettings = {};

function TRP3_LauncherSettings.GetSavedBindings()
	local shallow = true;
	return CopyTable(TRP3_API.configuration.getValue(Settings.Bindings), shallow);
end

function TRP3_LauncherSettings.SetSavedBindings(bindings)
	local shallow = true;
	return TRP3_API.configuration.setValue(Settings.Bindings, CopyTable(bindings, shallow));
end

function TRP3_LauncherSettings.ResetMinimapButtonPosition()
	TRP3_API.configuration.setValue(Settings.MinimapButtonPosition, nil);
	TRP3_Launcher:Refresh();
end

function TRP3_LauncherSettings.ShouldShowInAddonCompartment()
	return TRP3_API.configuration.getValue(Settings.ShowAddonCompartmentButton);
end

function TRP3_LauncherSettings.CreateMinimapButtonSettingsProxy()
	-- A minimap settings proxy acts as a bridge between the 'db' table
	-- that LibDBIcon manipulates for icon display attributes (like position)
	-- and our own settings keys.

	local function ReadSettingsValue(_, key)
		if key == "hide" then
			return not TRP3_API.configuration.getValue(Settings.ShowMinimapButton);
		elseif key == "lock" then
			return TRP3_API.configuration.getValue(Settings.LockMinimapButton);
		elseif key == "minimapPos" then
			return TRP3_API.configuration.getValue(Settings.MinimapButtonPosition);
		else
			return nil;
		end
	end

	local function WriteSettingsValue(_, key, value)
		-- 'hide' is intentionally omitted. We don't want to nuke the users
		-- preferred setting when we show or hide the button based upon the
		-- state of the module itself.
		--
		-- Note that LibDBIcon doesn't ever write the 'hide' field anyway,
		-- but would rather not assume that will always be the case.

		if key == "lock" then
			return TRP3_API.configuration.setValue(Settings.LockMinimapButton, value);
		elseif key == "minimapPos" then
			return TRP3_API.configuration.setValue(Settings.MinimapButtonPosition, value);
		end
	end

	return setmetatable({}, {__index = ReadSettingsValue, __newindex = WriteSettingsValue });
end

local hasRegisteredSettings = false;
local hasRegisteredSettingsPage = false;

function TRP3_LauncherSettings.RegisterSettings()
	if hasRegisteredSettings then
		return;
	end

	TRP3_API.configuration.registerConfigKey(Settings.Bindings, DefaultBindings);
	TRP3_API.configuration.registerConfigKey(Settings.LockMinimapButton, false);
	TRP3_API.configuration.registerConfigKey(Settings.MinimapButtonPosition, 225);
	TRP3_API.configuration.registerConfigKey(Settings.ShowAddonCompartmentButton, true);
	TRP3_API.configuration.registerConfigKey(Settings.ShowMinimapButton, true);

	hasRegisteredSettings = true;
end

function TRP3_LauncherSettings.RegisterSettingsPage()
	if hasRegisteredSettingsPage then
		return;
	end

	local elements = {
		{
			inherit = "TRP3_ConfigParagraph",
			title = L.LAUNCHER_CONFIG_PAGE_DESCRIPTION,
		},
		{
			inherit = "TRP3_ConfigH1",
			title = L.CO_MINIMAP_BUTTON,
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.CO_MINIMAP_BUTTON_SHOW_TITLE,
			help = L.CO_MINIMAP_BUTTON_SHOW_HELP,
			configKey = Settings.ShowMinimapButton,
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.LAUNCHER_CONFIG_LOCK_MINIMAP_BUTTON,
			help = L.LAUNCHER_CONFIG_LOCK_MINIMAP_BUTTON_HELP,
			configKey = Settings.LockMinimapButton,
		},
		{
			inherit = "TRP3_ConfigButton",
			title = L.LAUNCHER_CONFIG_RESET_MINIMAP_BUTTON,
			help = L.LAUNCHER_CONFIG_RESET_MINIMAP_BUTTON_HELP,
			text = RESET,
			callback = function()
				TRP3_LauncherSettings.ResetMinimapButtonPosition();
			end,
		},
		{
			inherit = "TRP3_ConfigH1",
			title = L.LAUNCHER_CONFIG_ADDON_COMPARTMENT,
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.LAUNCHER_CONFIG_SHOW_ADDON_COMPARTMENT_BUTTON,
			help = L.LAUNCHER_CONFIG_SHOW_ADDON_COMPARTMENT_BUTTON_HELP,
			configKey = Settings.ShowAddonCompartmentButton,
		},
		{
			inherit = "TRP3_ConfigH1",
			title = L.LAUNCHER_CONFIG_ACTIONS,
		}
	};

	-- Actions are hacked into the config a bit and must be present before
	-- the panel is registered (PLAYER_LOGIN). They can be registered in
	-- script bodies directly without issue.

	local function ActionSortComparator(a, b)
		return strcmputf8i(a.name, b.name) < 0;
	end

	local actions = TRP3_LauncherUtil.GetActions();
	table.sort(actions, ActionSortComparator);

	for _, action in ipairs(actions) do
		table.insert(elements, {
			frameType = "Button",
			inherit = "TRP3_LauncherClickBindingElementTemplate",
			title = action.name,
			elementData = action,
			elementInitializer = function(widget, elementData) widget:Init(elementData); end,
		});
	end

	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_launcher",
		menuText = L.LAUNCHER_CONFIG_MENU_TITLE,
		pageText = L.LAUNCHER_CONFIG_MENU_TITLE,
		elements = elements,
	});

	hasRegisteredSettingsPage = true;
end

local LauncherClickBindingController = {};

function LauncherClickBindingController:OnLoad()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.listener = CreateFrame("Frame");
	self.selectedAction = nil;
end

function LauncherClickBindingController:ProcessClick(actionID, buttonName)
	if self.selectedAction ~= actionID and buttonName == "RightButton" then
		-- Reset binding.
		TRP3_LauncherUtil.SetActionBinding(actionID, nil);
		self:SetSelectedAction(nil);
	elseif self.selectedAction ~= actionID then
		-- Select action.
		self:SetSelectedAction(actionID);
	else
		-- Assign binding.
		local key = GetConvertedKeyOrButton(buttonName);
		local binding = TRP3_BindingUtil.GenerateBinding(key);
		TRP3_LauncherUtil.SetActionBinding(actionID, binding);
		self:SetSelectedAction(nil);
	end
end

function LauncherClickBindingController:OnKeyDown(_, key)
	if not TRP3_BindingUtil.IsModifierKey(key) then
		self:SetSelectedAction(nil);
	end
end

function LauncherClickBindingController:SetSelectedAction(actionID)
	self.selectedAction = actionID;
	self:SetListening(self.selectedAction ~= nil);
	self.callbacks:Fire("OnSelectedActionChanged", self.selectedAction);
end

function LauncherClickBindingController:SetListening(listening)
	if listening then
		self.listener:SetScript("OnKeyDown", GenerateClosure(self.OnKeyDown, self));
	else
		self.listener:SetScript("OnKeyDown", nil);
	end
end

LauncherClickBindingController:OnLoad();

TRP3_LauncherClickBindingButtonMixin = {};

function TRP3_LauncherClickBindingButtonMixin:OnLoad()
	self.events = TRP3_API.CreateCallbackGroup();
	self.events:RegisterCallback(TRP3_Launcher, "OnBindingsChanged", self.OnBindingsChanged, self);
	self.events:RegisterCallback(LauncherClickBindingController, "OnSelectedActionChanged", self.OnSelectedActionChanged, self);
	self.events:RegisterCallback(TRP3_API.GameEvents, "CVAR_UPDATE", self.OnCVarUpdate, self);

	self:RegisterForClicks("AnyUp");

	self.Text:ClearAllPoints();
	self.Text:SetPoint("LEFT", 6, 0);
	self.Text:SetPoint("RIGHT", -6, 0);
	self.Text:SetWordWrap(false);
end

function TRP3_LauncherClickBindingButtonMixin:OnClick(buttonName)
	if self.actionID then
		LauncherClickBindingController:ProcessClick(self.actionID, buttonName);
	end
end

function TRP3_LauncherClickBindingButtonMixin:OnEnter()
	local bindingText = self:GetBindingText();

	if bindingText ~= "" then
		local action = self:GetActionInfo();
		local tooltip = self:GetTooltipFrame();

		tooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip_AddHighlightLine(tooltip, string.format(KEY_BINDING_NAME_AND_KEY, action.name, bindingText));
		GameTooltip_AddNormalLine(tooltip, KEY_BINDING_TOOLTIP);
		tooltip:Show();
	end
end

function TRP3_LauncherClickBindingButtonMixin:OnLeave()
	local tooltip = self:GetTooltipFrame();

	if tooltip:IsOwned(self) then
		tooltip:Hide();
	end
end

function TRP3_LauncherClickBindingButtonMixin:OnBindingsChanged()
	self:Refresh();
end

function TRP3_LauncherClickBindingButtonMixin:OnSelectedActionChanged(actionID)
	self:SetSelected(self.actionID == actionID);
end

function TRP3_LauncherClickBindingButtonMixin:OnCVarUpdate(variableName)
	if variableName == "colorblindMode" then
		self:Refresh();
	end
end

function TRP3_LauncherClickBindingButtonMixin:GetAction()
	return self.actionID;
end

function TRP3_LauncherClickBindingButtonMixin:GetActionInfo()
	return TRP3_LauncherUtil.GetActionInfo(self.actionID);
end

function TRP3_LauncherClickBindingButtonMixin:GetBinding()
	return TRP3_LauncherUtil.GetActionBinding(self.actionID);
end

function TRP3_LauncherClickBindingButtonMixin:GetBindingText(format)
	local binding = self:GetBinding();
	local bindingText = TRP3_BindingUtil.FormatBinding(binding or "", format);

	return bindingText;
end

function TRP3_LauncherClickBindingButtonMixin:GetTooltipFrame()
	return self.tooltipFrame;
end

function TRP3_LauncherClickBindingButtonMixin:SetAction(actionID)
	if self.actionID ~= actionID then
		self.actionID = actionID;
		self:Refresh();
	end
end

function TRP3_LauncherClickBindingButtonMixin:SetSelected(selected)
	self.SelectedHighlight:SetShown(selected);
	self:GetHighlightTexture():SetAlpha(selected and 0 or 1);
end

function TRP3_LauncherClickBindingButtonMixin:Refresh()
	local bindingFormat = { useMouseButtonAtlases = true, atlasSize = 22 };
	local bindingText = self:GetBindingText(bindingFormat);

	if bindingText and bindingText ~= "" then
		self:SetNormalFontObject(GameFontHighlightSmall);
		self:SetText(bindingText);
	else
		self:SetNormalFontObject(GameFontDisableSmall);
		self:SetText(NOT_BOUND);
	end
end

TRP3_LauncherClickBindingElementMixin = {};

function TRP3_LauncherClickBindingElementMixin:Init(elementData)
	self.Button:SetAction(elementData.id);
end

function TRP3_LauncherClickBindingElementMixin:GetAction()
	return self.Button:GetAction();
end

function TRP3_LauncherClickBindingElementMixin:Refresh()
	self.Button:Refresh();
end
