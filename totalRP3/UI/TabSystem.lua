-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TabButtonMixin = {};

function TRP3_TabButtonMixin:OnLoad()
	-- No-op; reserved for any future nonsense.
end

function TRP3_TabButtonMixin:OnEnter()
	if self.tooltipFunction then
		TRP3_TooltipUtil.ShowTooltip(self, self.tooltipFunction);
	elseif self.Text:IsTruncated() then
		TRP3_TooltipTemplates.ShowTruncationTooltip(self, self.Text:GetText());
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

function TRP3_TabButtonMixin:SetTooltip(tooltipFunction)
	self.tooltipFunction = tooltipFunction;
end

function TRP3_TabButtonMixin:IsTabLocked()
	return GetValueOrCallFunction(self, "locked");
end

function TRP3_TabButtonMixin:SetTabLocked(locked)
	self.locked = locked;
	self:MarkDirty();
end

function TRP3_TabButtonMixin:MarkDirty()
	self:SetOnUpdateMode(Enum.OnUpdateMode.RunWhenVisibleOnce);
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

function TRP3_TabButtonMixin:Update()
	local selected = self:IsTabSelected();
	local locked = self:IsTabLocked();

	self:SetEnabled(not selected and not locked);
	self.Left:SetShown(not selected);
	self.Middle:SetShown(not selected);
	self.Right:SetShown(not selected);
	self.LeftActive:SetShown(selected);
	self.MiddleActive:SetShown(selected);
	self.RightActive:SetShown(selected);
	self.Text:SetPoint("LEFT", 10, selected and -3 or -6);
	self.Text:SetPoint("RIGHT", -10, selected and -3 or -6);
end

function TRP3_TabButtonMixin:OnUpdate()
	self:Update();
end
