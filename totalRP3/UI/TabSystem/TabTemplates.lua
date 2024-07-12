-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TabTemplates = {};

function TRP3_TabTemplates.CreateTabLayout()
	local layout = TRP3_TabSystem.CreateTabLayoutDescription();
	layout:SetDirectionMultiplier(TRP3_TabConstants.TabDirection);
	layout:SetButtonSpacing(TRP3_TabConstants.TabSpacing);
	return layout;
end

function TRP3_TabTemplates.CreateNaturalTabLayout(minExtent, maxExtent)
	minExtent = minExtent or TRP3_TabConstants.MinimumTabWidth;
	maxExtent = maxExtent or TRP3_TabConstants.MaximumTabWidth;

	local function CalculateExtent(button)
		local description = button:GetTabDescription();
		local buttonMinExtent = description:GetMinimumWidth() or minExtent;
		local buttonMaxExtent = description:GetMaximumWidth() or maxExtent;

		return Clamp(button:CalculateNaturalExtent(), buttonMinExtent, buttonMaxExtent);
	end

	local layout = TRP3_TabTemplates.CreateTabLayout();
	layout:SetButtonExtentCalculator(CalculateExtent);
	return layout;
end

function TRP3_TabTemplates.CreateFixedTabLayout(extent)
	local layout = TRP3_TabTemplates.CreateTabLayout();
	layout:SetButtonExtentCalculator(function() return extent; end);
	return layout;
end

function TRP3_TabTemplates.CreateDefaultTabLayout()
	return TRP3_TabTemplates.CreateNaturalTabLayout();
end

function TRP3_TabTemplates.CreateDefaultTabAnchor(owner)
	local point = TRP3_TabConstants.TabAnchorPoint;
	local relativeTo = owner;
	local relativePoint = TRP3_TabConstants.TabAnchorPoint;
	local offsetX = TRP3_TabConstants.TabOffsetX;
	local offsetY = TRP3_TabConstants.TabOffsetY;

	return AnchorUtil.CreateAnchor(point, relativeTo, relativePoint, offsetX, offsetY);
end

TRP3_TabButtonMixin = {};

function TRP3_TabButtonMixin:OnLoad()
	-- No-op; reserved for any future nonsense.
end

function TRP3_TabButtonMixin:OnEnter()
	if self.Text:IsTruncated() then
		TRP3_TooltipUtil.ShowTooltip(self, function(tooltip)
			GameTooltip_SetTitle(tooltip, self:GetText());
		end);
	end
end

function TRP3_TabButtonMixin:OnLeave()
	TRP3_TooltipUtil.HideTooltip(self);
end

function TRP3_TabButtonMixin:SetIcon(icon)
	local textOffsetTop = select(5, self.Text:GetPointByName("LEFT"));

	if icon ~= nil then
		if C_Texture.GetAtlasInfo(icon) then
			local useAtlasSize = false;
			self.Icon:SetAtlas(icon, useAtlasSize);
		else
			self.Icon:SetTexture(icon);
		end

		self.Text:SetPoint("LEFT", 26, textOffsetTop);
		self.Icon:Show();
	else
		self.Text:SetPoint("LEFT", 10, textOffsetTop);
		self.Icon:SetTexture(nil);
		self.Icon:Hide();
	end
end

function TRP3_TabButtonMixin:SetTabState(state)
	self:EnableMouse(state == "NORMAL");
	self:SetEnabled(state ~= "DISABLED");
	self.Left:SetShown(state ~= "SELECTED");
	self.Middle:SetShown(state ~= "SELECTED");
	self.Right:SetShown(state ~= "SELECTED");
	self.LeftActive:SetShown(state == "SELECTED");
	self.MiddleActive:SetShown(state == "SELECTED");
	self.RightActive:SetShown(state == "SELECTED");

	local iconOffsetLeft = select(4, self.Icon:GetPointByName("LEFT"));
	local textOffsetLeft = select(4, self.Text:GetPointByName("LEFT"));
	local textOffsetRight = select(4, self.Text:GetPointByName("RIGHT"));

	if state == "SELECTED" then
		self:SetNormalFontObject(self.selectedFontObject);
		self.Icon:SetPoint("LEFT", iconOffsetLeft, -3);
		self.Text:SetPoint("LEFT", textOffsetLeft, -3);
		self.Text:SetPoint("RIGHT", textOffsetRight, -3);
	else
		self:SetNormalFontObject(self.unselectedFontObject);
		self.Icon:SetPoint("LEFT", iconOffsetLeft, -6);
		self.Text:SetPoint("LEFT", textOffsetLeft, -6);
		self.Text:SetPoint("RIGHT", textOffsetRight, -6);
	end
end

TRP3_TabFrameMixin = CreateFromMixins(TRP3_TabSystemOwnerMixin);

function TRP3_TabFrameMixin:OnLoad()
	-- No-op; reserved for future use.
end

TRP3_TabFrameBarMixin = CreateFromMixins(TRP3_TabSystemMixin);

function TRP3_TabFrameBarMixin:OnLoad()
	TRP3_TabSystemMixin.OnLoad(self);

	self.buttons = {};
	self.initialAnchor = TRP3_TabTemplates.CreateDefaultTabAnchor(self);
	self.layout = TRP3_TabTemplates.CreateDefaultTabLayout();
	self.pool = CreateFramePool("Button", self, "TRP3_TabFrameButtonTemplate");
end

function TRP3_TabFrameBarMixin:OnShow()
	TRP3_TabSystemMixin.OnShow(self);
	self:ApplyLayout();
end

function TRP3_TabFrameBarMixin:OnSizeChanged()
	self:ApplyLayout();
end

function TRP3_TabFrameBarMixin:OnTabSelected(tabDescription)
	self:UpdateTabButtons();
	TRP3_TabSystemMixin.OnTabSelected(self, tabDescription);
end

function TRP3_TabFrameBarMixin:OnTabsRegistered()
	TRP3_TabSystemMixin.OnTabsRegistered(self);
	self:GenerateTabButtons();
end

function TRP3_TabFrameBarMixin:GetInitialAnchor()
	return self.initialAnchor;
end

function TRP3_TabFrameBarMixin:GetLayout()
	return self.layout;
end

function TRP3_TabFrameBarMixin:SetInitialAnchor(initialAnchor)
	self.initialAnchor = initialAnchor;
	self:ApplyLayout();
end

function TRP3_TabFrameBarMixin:SetLayout(layout)
	self.layout = layout;
	self:ApplyLayout();
end

function TRP3_TabFrameBarMixin:EnumerateTabButtons()
	return ipairs(self.buttons);
end

function TRP3_TabFrameBarMixin:GenerateTabButtons()
	self.pool:ReleaseAll();
	self.buttons = {};

	if not self:IsShown() then
		return;
	end

	for _, description in self:EnumerateTabDescriptions() do
		if description:IsShown() then
			local button = self.pool:Acquire();
			button:SetTabDescription(description);
			button:Show();
			table.insert(self.buttons, button);
		end
	end

	self:ApplyLayout();
end

function TRP3_TabFrameBarMixin:UpdateTabButtons()
	for _, button in self:EnumerateTabButtons() do
		button:Update();
	end
end

function TRP3_TabFrameBarMixin:ApplyLayout()
	if not self:IsShown() then
		return;
	end

	TRP3_TabUtil.ApplyTabLayout(self.buttons, self:GetInitialAnchor(), self:GetLayout());
end

TRP3_TabFrameButtonMixin = CreateFromMixins(TRP3_TabButtonMixin);

function TRP3_TabFrameButtonMixin:OnLoad()
	TRP3_TabButtonMixin.OnLoad(self);
end

function TRP3_TabFrameButtonMixin:OnShow()
	self:Update();
end

function TRP3_TabFrameButtonMixin:OnClick()
	local description = self:GetTabDescription();
	PlaySound(description:GetClickSoundKit());
	description:Select();
end

function TRP3_TabFrameButtonMixin:GetTabDescription()
	return self.tabDescription;
end

function TRP3_TabFrameButtonMixin:SetTabDescription(description)
	self.tabDescription = description;
	self:Update();
end

function TRP3_TabFrameButtonMixin:Update()
	local description = self:GetTabDescription();

	if not description then
		return;
	end

	self:SetIcon(description:GetIcon());
	self:SetText(description:GetText());

	if not description:IsEnabled() then
		self:SetTabState("DISABLED");
	elseif description:IsSelected() then
		self:SetTabState("SELECTED");
	else
		self:SetTabState("NORMAL");
	end
end

function TRP3_TabFrameButtonMixin:CalculateNaturalExtent()
	local leftPadding = self.Left:GetWidth();
	local rightPadding = self.Right:GetWidth();
	local iconWidth = self.Icon:IsShown() and self.Icon:GetWidth() or 0;
	local textWidth = self.Text:GetStringWidth();

	return leftPadding + iconWidth + textWidth + rightPadding;
end
