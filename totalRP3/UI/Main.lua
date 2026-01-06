-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;
local LibWindow = LibStub:GetLibrary("LibWindow-1.1");

TRP3_MainFrameSizeConstants = {
	DefaultWidth = 840,
	DefaultHeight = 600,
	MinimumWidth = 840,
	MinimumHeight = 600,
};

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
	self.ResizeButton:Init(self);
end

function TRP3_MainFrameMixin:OnSizeChanged()
	self:UpdateClampRectInsets();
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetSize());
end

function TRP3_MainFrameMixin:OnResizeStart()
	ResetWindowPoint(self);
end

function TRP3_MainFrameMixin:OnResizeStop(width, height)
	self:ResizeWindow(width, height);
end

function TRP3_MainFrameMixin:OnResizeToDefault()
	self:RestoreWindow();
end

function TRP3_MainFrameMixin:ResizeWindow(width, height)
	ResetWindowPoint(self);
	self:SetSize(width, height);
end

function TRP3_MainFrameMixin:RestoreWindow()
	self:SetSize(TRP3_MainFrameSizeConstants.DefaultWidth, TRP3_MainFrameSizeConstants.DefaultHeight);
end

function TRP3_MainFrameMixin:UpdateClampRectInsets()
	local width, height = self:GetSize();
	local ratio = width / height;
	local padding = 300;

	local left = width - padding;
	local right = -left;
	local bottom = height - (padding / ratio);
	local top = -bottom;

	self:SetClampRectInsets(left, right, top, bottom);
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

	local width = math.max(self.windowLayout.w or TRP3_MainFrameSizeConstants.DefaultWidth, TRP3_MainFrameSizeConstants.MinimumWidth);
	local height = math.max(self.windowLayout.h or TRP3_MainFrameSizeConstants.DefaultHeight, TRP3_MainFrameSizeConstants.MinimumHeight);
	self:SetSize(width, height);
	LibWindow.RestorePosition(self);
	ResetWindowPoint(self);
end

function TRP3_MainFrameLayoutMixin:SaveLayout()
	assert(self:IsLayoutLoaded(), "attempted to save window layout before layout has been loaded");

	local width, height = self:GetSize();
	self.windowLayout.w = width;
	self.windowLayout.h = height;
	LibWindow.SavePosition(self);
end

TRP3_MainFrameResizeButtonMixin = {};

function TRP3_MainFrameResizeButtonMixin:Init(target)
	self.target = target;
	self.onResizeStart = function(mouseButtonName) return self:OnResizeStart(mouseButtonName); end;
	self.onResizeStop = function(width, height) self:OnResizeStop(width, height); end;
	TRP3_API.ui.frame.initResize(self);
end

function TRP3_MainFrameResizeButtonMixin:OnResizeStart(mouseButtonName)
	if mouseButtonName == "LeftButton" then
		self.target:OnResizeStart();
		self:HideTooltip();
		return false;
	end

	-- All other mouse interactions will prevent the user from resizing the
	-- window via dragging.

	if mouseButtonName == "RightButton" then
		self.target:OnResizeToDefault();
	end

	return true;
end

function TRP3_MainFrameResizeButtonMixin:OnResizeStop(width, height)
	self.target:OnResizeStop(width, height);
end

function TRP3_MainFrameResizeButtonMixin:OnTooltipShow(description)
	description:AddTitleLine(L.CM_RESIZE);
	description:AddInstructionLine("DRAGDROP", L.CM_RESIZE_TT);
	description:AddInstructionLine("RCLICK", L.CM_RESIZE_RESET_TT);
end

TRP3_MainFrameCloseButtonMixin = {};

function TRP3_MainFrameCloseButtonMixin:OnClick()
	TRP3_API.navigation.switchMainFrame();
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
