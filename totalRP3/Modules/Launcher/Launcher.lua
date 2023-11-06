-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- Launcher module
--
-- The launcher module registers data object for LDB displays through which
-- users can toggle the main window of the addon or the toolbar.
--
-- Additionally this controls the registration of a minimap button display
-- and Blizzard's addon compartment feature.

local LibDataBroker = LibStub:GetLibrary("LibDataBroker-1.1");
local LibDBCompartment = LibStub:GetLibrary("LibDBCompartment-1.0");
local LibDBIcon = LibStub:GetLibrary("LibDBIcon-1.0");

TRP3_Launcher = TRP3_Addon:NewModule("Launcher");

function TRP3_Launcher:OnLoad()
	self.actions = {};
	self.bindings = {};

	self.object = nil;
	self.objectName = "Total RP 3";

	self.callbacks = TRP3_API.InitCallbackRegistry(self);

	self.events = TRP3_API.CreateCallbackGroup();
	self.events:AddCallback(TRP3_API.GameEvents, "ADDONS_UNLOADING", self.OnUninitialize, self);
	self.events:AddCallback(TRP3_Addon, "CONFIGURATION_CHANGED", self.OnConfigurationChanged, self);

	self:SetEnabledState(false);
end

function TRP3_Launcher:OnInitialize()
	TRP3_LauncherSettings.RegisterSettings();

	self.object = LibDataBroker:NewDataObject(self.objectName, {
		type = "launcher",
		icon = [[Interface\AddOns\totalRP3\Resources\trp3minimap.tga]],
		tocname = "totalRP3",
		OnClick = GenerateClosure(self.OnClick, self),
		OnTooltipShow = GenerateClosure(self.OnTooltipShow, self),
	});

	LibDBIcon:Register(self.objectName, self.object, TRP3_LauncherSettings.CreateMinimapButtonSettingsProxy());
	LibDBCompartment:Register(self.objectName, self.object);

	self:LoadBindings(TRP3_LauncherSettings.GetSavedBindings());
end

function TRP3_Launcher:OnEnable()
	self.events:Register();
	self:Refresh();
end

function TRP3_Launcher:OnDisable()
	self.events:Unregister();
	self:Refresh();
end

function TRP3_Launcher:OnUninitialize()
	TRP3_LauncherSettings.SetSavedBindings(self:SaveBindings());
end

function TRP3_Launcher:OnConfigurationChanged()
	self:Refresh();
end

function TRP3_Launcher:OnClick(_, buttonName)
	local binding = TRP3_BindingUtil.GenerateBinding(GetConvertedKeyOrButton(buttonName));
	local action;

	for actionBinding, actionID in pairs(self.bindings) do
		if TRP3_BindingUtil.CompareBindings(binding, actionBinding) then
			action = self.actions[actionID];
			break;
		end
	end

	if action then
		action.Activate();
	end
end

function TRP3_Launcher:OnTooltipShow(tooltip)
	tooltip:AddLine("Total RP 3", TRP3_API.Colors.White:GetRGB());

	local bindings = GetKeysArray(self.bindings);
	TRP3_BindingUtil.SortBindings(bindings);

	for _, binding in ipairs(bindings) do
		local actionID = self.bindings[binding];
		local action = self.actions[actionID];
		local instruction = TRP3_API.FormatShortcutWithInstruction(binding, action.name);

		tooltip:AddLine(instruction);
	end

	local owner = tooltip:GetOwner();

	if owner and owner:HasScript("OnDragStart") and owner:GetScript("OnDragStart") then
		tooltip:AddLine(TRP3_API.FormatShortcutWithInstruction("DRAGDROP", L.MM_SHOW_HIDE_MOVE));
	end
end

function TRP3_Launcher:Refresh()
	if self:IsEnabled() then
		LibDBCompartment:SetShown(self.objectName, TRP3_LauncherSettings.ShouldShowInAddonCompartment());
		LibDBIcon:Refresh(self.objectName);
	else
		LibDBCompartment:Hide(self.objectName);
		LibDBIcon:Hide(self.objectName);
	end
end

function TRP3_Launcher:RegisterAction(action)
	assert(type(action) == "table", "attempted to register an invalid action: expected table");
	assert(type(action.id) == "string", "attempted to register an invalid action: 'id' field must be a string");
	assert(type(action.Activate) == "function", "attempted to register an invalid action: 'Activate' field must be a function");
	assert(not self.actions[action.id], "attempted to register a duplicate action");

	self.actions[action.id] = action;
end

function TRP3_Launcher:EnumerateActions()
	return pairs(self.actions);
end

function TRP3_Launcher:GetActionInfo(actionID)
	return self.actions[actionID];
end

function TRP3_Launcher:GetBindingAction(binding)
	return self.bindings[binding];
end

function TRP3_Launcher:GetActionBinding(actionID)
	for binding, boundActionID in pairs(self.bindings) do
		if actionID == boundActionID then
			return binding;
		end
	end

	return nil;
end

function TRP3_Launcher:SetActionBinding(actionID, binding)
	for otherBinding, otherActionID in pairs(self.bindings) do
		if actionID == otherActionID then
			self.bindings[otherBinding] = nil;
		end
	end

	if binding ~= nil then
		self.bindings[binding] = actionID;
	end

	self.callbacks:Fire("OnBindingsChanged");
end

function TRP3_Launcher:LoadBindings(bindings)
	local shallow = true;
	self.bindings = CopyTable(bindings, shallow);
	self.callbacks:Fire("OnBindingsChanged");
end

function TRP3_Launcher:SaveBindings()
	local shallow = true;
	return CopyTable(self.bindings, shallow);
end

TRP3_Launcher:OnLoad();

-- Module registration

TRP3_API.module.registerModule({
	id = "trp3_launcher",
	name = L.LAUNCHER_MODULE_NAME,
	description = L.LAUNCHER_MODULE_DESCRIPTION,
	version = 1,
	hotReload = true,

	onStart = function()
		TRP3_Launcher:Enable();
		TRP3_LauncherSettings.RegisterSettingsPage();
	end,

	onDisable = function()
		TRP3_Launcher:Disable();
	end,
});
