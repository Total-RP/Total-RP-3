-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local WindowState = {
	Normal = 1,
	Maximized = 2,
};

TRP3_MainFrameMixin = {};

function TRP3_MainFrameMixin:OnLoad()
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

local function ResetTexCoords(texture)
	texture:SetTexCoord(0, 1, 0, 1);
end

local function MirrorTexCoordsAlongHorizontalAxis(region)
	local x1, y1, x2, y2, x3, y3, x4, y4 = region:GetTexCoord();
	region:SetTexCoord(x3, y3, x4, y4, x1, y1, x2, y2);
end

TRP3_WindowCloseButtonArtMixin = {};

function TRP3_WindowCloseButtonArtMixin:OnLoad()
	if C_Texture.GetAtlasInfo("RedButton-Exit") then
		ResetTexCoords(self:GetNormalTexture());
		ResetTexCoords(self:GetPushedTexture());
		ResetTexCoords(self:GetDisabledTexture());
		ResetTexCoords(self:GetHighlightTexture());
		self:SetNormalAtlas("RedButton-Exit");
		self:SetPushedAtlas("RedButton-Exit-Pressed");
		self:SetDisabledAtlas("RedButton-Exit-Disabled");
		self:SetHighlightAtlas("RedButton-Highlight", "ADD");
	end
end

TRP3_WindowMaximizeButtonArtMixin = {};

function TRP3_WindowMaximizeButtonArtMixin:OnLoad()
	if C_Texture.GetAtlasInfo("RedButton-Expand") then
		ResetTexCoords(self:GetNormalTexture());
		ResetTexCoords(self:GetPushedTexture());
		ResetTexCoords(self:GetDisabledTexture());
		ResetTexCoords(self:GetHighlightTexture());
		self:SetNormalAtlas("RedButton-Expand");
		self:SetPushedAtlas("RedButton-Expand-Pressed");
		self:SetDisabledAtlas("RedButton-Expand-Disabled");
		self:SetHighlightAtlas("RedButton-Highlight", "ADD");
	end
end

TRP3_WindowMinimizeButtonArtMixin = {};

function TRP3_WindowMinimizeButtonArtMixin:OnLoad()
	if C_Texture.GetAtlasInfo("RedButton-Condense") then
		ResetTexCoords(self:GetNormalTexture());
		ResetTexCoords(self:GetPushedTexture());
		ResetTexCoords(self:GetDisabledTexture());
		ResetTexCoords(self:GetHighlightTexture());
		self:SetNormalAtlas("RedButton-Condense");
		self:SetPushedAtlas("RedButton-Condense-Pressed");
		self:SetDisabledAtlas("RedButton-Condense-Disabled");
		self:SetHighlightAtlas("RedButton-Highlight", "ADD");
	end
end

TRP3_WindowResizeButtonArtMixin = {};

function TRP3_WindowResizeButtonArtMixin:OnLoad()
	TRP3_WindowMinimizeButtonArtMixin.OnLoad(self);

	if C_Texture.GetAtlasInfo("RedButton-Condense") then
		MirrorTexCoordsAlongHorizontalAxis(self:GetNormalTexture());
		MirrorTexCoordsAlongHorizontalAxis(self:GetPushedTexture());
		MirrorTexCoordsAlongHorizontalAxis(self:GetDisabledTexture());
	end
end
