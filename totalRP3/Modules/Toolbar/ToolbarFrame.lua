-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ToolbarFrameMixin = {};

function TRP3_ToolbarFrameMixin:Init()
	TRP3_Addon.RegisterCallback(self, "CONFIGURATION_CHANGED", "OnConfigurationChanged");
	TRP3_Addon.RegisterCallback(self, "ROLEPLAY_STATUS_CHANGED", "OnRoleplayStatusChanged");

	self:LoadPosition();
	self:UpdateFrameVisibility();
	self:UpdateTitleVisibility();
end

function TRP3_ToolbarFrameMixin:OnLoad()
	self.buttonPool = CreateFramePool("Button", self.Container, "TRP3_ToolbarButtonTemplate");
	self.buttonDataProvider = nil;
end

function TRP3_ToolbarFrameMixin:OnShow()
	self:MarkDirty();
end

function TRP3_ToolbarFrameMixin:OnUpdate()
	self:UpdateButtons();
end

function TRP3_ToolbarFrameMixin:OnDragStart()
	self:StartMoving();
end

function TRP3_ToolbarFrameMixin:OnDragStop()
	self:StopMovingOrSizing();
	self:SavePosition();
end

function TRP3_ToolbarFrameMixin:OnRoleplayStatusChanged()
	local configuredVisibility = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.Visibility);

	if configuredVisibility == TRP3_ToolbarVisibilityOption.OnlyShowInCharacter then
		self:UpdateFrameVisibility();
	end
end

function TRP3_ToolbarFrameMixin:OnConfigurationChanged(_, key)
	if key == TRP3_ToolbarConfigKeys.Visibility then
		self:UpdateFrameVisibility();
	elseif key == TRP3_ToolbarConfigKeys.HideTitle then
		self:UpdateTitleVisibility();
	end
end

function TRP3_ToolbarFrameMixin:MarkDirty()
	self:SetScript("OnUpdate", self.UpdateButtons);
end

function TRP3_ToolbarFrameMixin:MarkClean()
	self:SetScript("OnUpdate", nil);
end

function TRP3_ToolbarFrameMixin:UpdateButtons()
	local provider = self:GetDataProvider();
	local pool = self.buttonPool;

	self:MarkClean();
	pool:ReleaseAll();

	if not provider or not self:IsShown() then
		return;
	end

	local buttons = {};
	local extent = TRP3_ToolbarUtil.GetToolbarButtonExtent();

	for _, elementData in provider:EnumerateEntireRange() do
		local button = pool:Acquire();
		button:SetElementData(elementData);
		button:SetSize(extent, extent);
		button:Show();

		table.insert(buttons, button);
	end

	local direction = GridLayoutMixin.Direction.TopLeftToBottomRight;
	local stride = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.ButtonStride);
	local spacingX = 0;
	local spacingY = 0;

	local initialAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self.Container, "TOPLEFT", 8, -8);
	local layout = AnchorUtil.CreateGridLayout(direction, stride, spacingX, spacingY);

	AnchorUtil.GridLayout(buttons, initialAnchor, layout);
	self.Container:Layout();
end

function TRP3_ToolbarFrameMixin:GetDataProvider()
	return self.buttonDataProvider;
end

function TRP3_ToolbarFrameMixin:RemoveDataProvider()
	self.buttonDataProvider = nil;
	self.buttonPool:ReleaseAll();
end

function TRP3_ToolbarFrameMixin:SetDataProvider(provider)
	self.buttonDataProvider = provider;
	self:MarkDirty();
end

function TRP3_ToolbarFrameMixin:RefreshButtons()
	for button in self.buttonPool:EnumerateActive() do
		button:MarkDirty();
	end
end

function TRP3_ToolbarFrameMixin:Toggle()
	self:UpdateFrameVisibility(not self:IsShown());

	if self:IsShown() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);
	end
end

function TRP3_ToolbarFrameMixin:UpdateFrameVisibility(forcedVisibility)
	local configuredVisibility = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.Visibility);
	local shouldShow;

	if forcedVisibility ~= nil then
		shouldShow = forcedVisibility;
	elseif configuredVisibility == TRP3_ToolbarVisibilityOption.AlwaysHidden then
		shouldShow = false;
	elseif configuredVisibility == TRP3_ToolbarVisibilityOption.OnlyShowInCharacter then
		shouldShow = AddOn_TotalRP3.Player.GetCurrentUser():IsInCharacter();
	else
		shouldShow = true;
	end

	self:SetShown(shouldShow);
end

function TRP3_ToolbarFrameMixin:UpdateTitleVisibility()
	self.Title.Text:SetText(TRP3_API.globals.addon_name);
	self.Title:SetShown(TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.HideTitle));
end

function TRP3_ToolbarFrameMixin:LoadPosition()
	local anchor = TRP3_ToolbarUtil.GetToolbarAnchor();

	self:ClearAllPoints();
	self:SetPoint(anchor:Get());
end

function TRP3_ToolbarFrameMixin:SavePosition()
	local anchor, _, _, x, y = self:GetPoint(1);
	TRP3_API.configuration.setValue(TRP3_ToolbarConfigKeys.AnchorPoint, anchor);
	TRP3_API.configuration.setValue(TRP3_ToolbarConfigKeys.AnchorOffsetX, x);
	TRP3_API.configuration.setValue(TRP3_ToolbarConfigKeys.AnchorOffsetY, y);
end
