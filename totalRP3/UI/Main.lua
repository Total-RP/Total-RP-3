-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local WindowState = {
	Normal = 1,
	Maximized = 2,
};

TRP3_MainFrameMixin = {};

function TRP3_MainFrameMixin:OnLoad()
	tinsert(UISpecialFrames, self:GetName());
	self.windowState = WindowState.Normal;
	TRP3_Addon.RegisterCallback(self, "CONFIGURATION_CHANGED", "OnConfigurationChanged");
	TRP3_API.ui.frame.initResize(self.Resize);
end

function TRP3_MainFrameMixin:OnConfigurationChanged(_, key)
	if key == "hide_maximize_button" then
		self:UpdateWindowStateButtons();
	end
end

function TRP3_MainFrameMixin:OnShow()
	self:UpdateWindowStateButtons();
end

function TRP3_MainFrameMixin:OnSizeChanged()
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetSize());
end

function TRP3_MainFrameMixin:OnWindowStateChanged(oldState, newState)  -- luacheck: no unused
	self:UpdateWindowStateButtons();
end

function TRP3_MainFrameMixin:MaximizeWindow()
	self:SetSize(UIParent:GetSize());
	self:SetWindowState(WindowState.Maximized);
end

function TRP3_MainFrameMixin:RestoreWindow()
	self:SetSize(768, 500);
	self:SetWindowState(WindowState.Normal);
end

function TRP3_MainFrameMixin:ResizeWindow(width, height)
	self:SetSize(width, height);
	self:SetWindowState(WindowState.Normal);
end

function TRP3_MainFrameMixin:GetWindowState()
	return self.windowState or WindowState.Normal;
end

function TRP3_MainFrameMixin:SetWindowState(state)
	assert(type(state) == "number", "bad argument #2 to 'SetWindowState': expected number");

	local oldState = self.windowState;
	local newState = state;

	if oldState == newState then
		return;
	end

	self.windowState = newState;
	self:OnWindowStateChanged(oldState, newState);
end

local function ShouldShowWindowStateButtons()
	return not TRP3_API.configuration.getValue("hide_maximize_button");
end

function TRP3_MainFrameMixin:UpdateWindowStateButtons()
	local state = self:GetWindowState();

	self.Minimize:SetShown(state == WindowState.Maximized and ShouldShowWindowStateButtons());
	self.Maximize:SetShown(state == WindowState.Normal and ShouldShowWindowStateButtons());
end
