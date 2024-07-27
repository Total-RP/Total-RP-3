-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LibWindow = LibStub:GetLibrary("LibWindow-1.1");

local DEFAULT_WINDOW_WIDTH = 840;
local DEFAULT_WINDOW_HEIGHT = 600;

TRP3_MainFrameMixin = {};

function TRP3_MainFrameMixin:OnLoad()
	tinsert(UISpecialFrames, self:GetName());
	TRP3_API.ui.frame.initResize(self.Resize);
end

function TRP3_MainFrameMixin:OnSizeChanged()
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetSize());
end

function TRP3_MainFrameMixin:RestoreWindow()
	self:SetSize(DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT);
end

function TRP3_MainFrameMixin:ResizeWindow(width, height)
	self:SetSize(width, height);
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
