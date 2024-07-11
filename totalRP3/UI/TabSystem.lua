-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TabButtonMixin = {};

function TRP3_TabButtonMixin:OnLoad()
end

function TRP3_TabButtonMixin:OnShow()
	self:MarkDirty();
end

function TRP3_TabButtonMixin:OnHide()
	self:MarkClean();
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

function TRP3_TabButtonMixin:IsTabSelected()
	return GetValueOrCallFunction(self, "selected");
end

function TRP3_TabButtonMixin:SetTabSelected(selected)
	self.selected = selected;
	self:MarkDirty();
end

function TRP3_TabButtonMixin:MarkDirty()
	self:SetScript("OnUpdate", self.Update);
end

function TRP3_TabButtonMixin:MarkClean()
	self:SetScript("OnUpdate", nil);
end

function TRP3_TabButtonMixin:Update()
	local selected = self:IsTabSelected();

	self:SetEnabled(not selected);
	self.Left:SetShown(not selected);
	self.Middle:SetShown(not selected);
	self.Right:SetShown(not selected);
	self.LeftActive:SetShown(selected);
	self.MiddleActive:SetShown(selected);
	self.RightActive:SetShown(selected);
	self.Text:SetPoint("LEFT", self.textMargin, selected and -3 or -6);
	self.Text:SetPoint("RIGHT", -self.textMargin, selected and -3 or -6);
end
