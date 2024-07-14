-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LibWindow = LibStub:GetLibrary("LibWindow-1.1");

local DEFAULT_WINDOW_WIDTH = 840;
local DEFAULT_WINDOW_HEIGHT = 600;

local WindowState = {
	Normal = 1,
	Maximized = 2,
};

TRP3_MainFrameMixin = {};

function TRP3_MainFrameMixin:OnLoad()
	self.windowState = WindowState.Normal;

	tinsert(UISpecialFrames, self:GetName());
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
	self:SetSize(DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT);
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

TRP3_MainFrameLayoutMixin = CreateFromMixins(TRP3_MainFrameMixin);

function TRP3_MainFrameLayoutMixin:OnLoad()
	TRP3_MainFrameMixin.OnLoad(self);
	self.windowLayout = nil;  -- Aliases configuration table; set during addon load.
	TRP3_Addon.RegisterCallback(self, "WORKFLOW_ON_FINISH", "OnLayoutLoaded");
end

function TRP3_MainFrameLayoutMixin:OnLayoutLoaded()
	self.windowLayout = TRP3_API.configuration.getValue("window_layout");
	LibWindow.RegisterConfig(self, self.windowLayout);
	LibWindow.MakeDraggable(self);
	self:RestoreLayout();
end

function TRP3_MainFrameLayoutMixin:OnSizeChanged(...)
	if self:IsLayoutLoaded() then
		self:SaveLayout();
	end

	TRP3_MainFrameMixin.OnSizeChanged(self, ...);
end

function TRP3_MainFrameLayoutMixin:IsLayoutLoaded()
	return self.windowLayout ~= nil;
end

function TRP3_MainFrameLayoutMixin:RestoreLayout()
	assert(self:IsLayoutLoaded(), "attempted to restore window layout before layout has been loaded");

	local width = math.max(self.windowLayout.w or DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_WIDTH);
	local height = math.max(self.windowLayout.h or DEFAULT_WINDOW_HEIGHT, DEFAULT_WINDOW_HEIGHT);
	self:SetSize(width, height);
	LibWindow.RestorePosition(self);
end

function TRP3_MainFrameLayoutMixin:SaveLayout()
	assert(self:IsLayoutLoaded(), "attempted to save window layout before layout has been loaded");

	local width, height = self:GetSize();
	self.windowLayout.w = width;
	self.windowLayout.h = height;
	LibWindow.SavePosition(self);
end

TRP3_SidebarLogoMixin = {};

function TRP3_SidebarLogoMixin:OnLoad()
	TRP3_Addon.RegisterCallback(self, "CONFIGURATION_CHANGED", "OnConfigurationChanged");
end

function TRP3_SidebarLogoMixin:OnShow()
	self:Update();
end

function TRP3_SidebarLogoMixin:OnConfigurationChanged(_, key)
	if key == "secret_party" then
		self:Update();
	end
end

function TRP3_SidebarLogoMixin:Update()
	local isSeriousDay = TRP3_API.globals.serious_day;
	local isSeriousTime = TRP3_API.configuration.getValue("secret_party");

	if isSeriousDay or isSeriousTime then
		self:SetTexture([[Interface\AddOns\totalRP3\Resources\UI\ui-sidebar-logo-alt]]);
		self:SetVertexColor(1, 1, 1, 1);
	else
		self:SetTexture([[Interface\AddOns\totalRP3\Resources\UI\ui-sidebar-logo]]);
		self:SetVertexColor(0.5, 0.4, 0.3, 0.5);
	end
end
