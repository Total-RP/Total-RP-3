-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
