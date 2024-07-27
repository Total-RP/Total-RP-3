-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LibWindow = LibStub:GetLibrary("LibWindow-1.1");

local function ResetWindowPoint(frame)
	local parent = frame:GetParent() or UIParent;
	local offsetX = frame:GetLeft();
	local offsetY = -(parent:GetTop() - frame:GetTop());

	frame:ClearAllPoints();
	frame:SetPoint("TOPLEFT", offsetX, offsetY);
end

TRP3_MainFrameMixin = {};

function TRP3_MainFrameMixin:OnLoad()
	tinsert(UISpecialFrames, self:GetName());
	self.windowLayout = nil;  -- Aliases configuration table; set during addon load.

	self.CloseButton:SetScript("OnClick", function() TRP3_API.navigation.switchMainFrame() end);
	self.ResizeButton.minWidth, self.ResizeButton.minHeight = self:GetMinimumSize();
	self.ResizeButton.onResizeStart = function() self:OnResizeStart(); end;
	self.ResizeButton.onResizeStop = function(width, height) self:OnResizeStop(width, height); end;
	TRP3_API.ui.frame.initResize(self.ResizeButton);

	TRP3_Addon.RegisterCallback(self, "WORKFLOW_ON_FINISH", "OnLayoutLoaded");
end

function TRP3_MainFrameMixin:OnSizeChanged()
	if self:IsLayoutLoaded() then
		self:SaveLayout();
	end

	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetSize());
end

function TRP3_MainFrameMixin:OnLayoutLoaded()
	self.windowLayout = TRP3_API.configuration.getValue("window_layout");
	LibWindow.RegisterConfig(self, self.windowLayout);
	LibWindow.MakeDraggable(self);
	self:RestoreLayout();
end

function TRP3_MainFrameMixin:OnResizeStart()
	ResetWindowPoint(self);
end

function TRP3_MainFrameMixin:OnResizeStop(width, height)
	self:ResizeWindow(width, height);
end

function TRP3_MainFrameMixin:GetDefaultSize()
	return 840, 600;
end

function TRP3_MainFrameMixin:GetMinimumSize()
	return self:GetDefaultSize();
end

function TRP3_MainFrameMixin:GetMaximumSize()
	return math.huge, math.huge;
end

function TRP3_MainFrameMixin:ResizeWindowToDefault()
	self:ResizeWindow(self:GetDefaultSize());
end

function TRP3_MainFrameMixin:ResizeWindow(width, height)
	ResetWindowPoint(self);
	self:SetSize(width, height);
end

function TRP3_MainFrameMixin:IsLayoutLoaded()
	return self.windowLayout ~= nil;
end

function TRP3_MainFrameMixin:RestoreLayout()
	assert(self:IsLayoutLoaded(), "attempted to restore window layout before layout has been loaded");

	local defaultWidth, defaultHeight = self:GetDefaultSize();
	local minimumWidth, minimumHeight = self:GetMinimumSize();
	local maximumWidth, maximumHeight = self:GetMaximumSize();

	local width = Clamp(self.windowLayout.w or defaultWidth, minimumWidth, maximumWidth);
	local height = Clamp(self.windowLayout.h or defaultHeight, minimumHeight, maximumHeight);

	self:SetSize(width, height);
	LibWindow.RestorePosition(self);
	ResetWindowPoint(self);
end

function TRP3_MainFrameMixin:SaveLayout()
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
