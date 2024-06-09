-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_GroupBoxMixin = {};

function TRP3_GroupBoxMixin:SetBackdropBorderColor(r, g, b, a)
	BackdropTemplateMixin.SetBackdropBorderColor(self, r, g, b, a);
	self.Header:SetBackdropBorderColor(r, g, b, a);
end

function TRP3_GroupBoxMixin:GetTitleText()
	return self.Header.Text:GetText();
end

function TRP3_GroupBoxMixin:SetTitleText(text)
	self.Header.Text:SetText(text);
end

function TRP3_GroupBoxMixin:GetTitleWidth()
	return self.Header:GetWidth();
end

function TRP3_GroupBoxMixin:SetTitleWidth(width)
	local padding = 20;

	if width == 0 then
		width = self.Header.Text:GetStringWidth();
	end

	self.Header:SetWidth(width + padding);
end

function TRP3_GroupBoxMixin:SetTitleToFit(text)
	self:SetTitleText(text);
	self:SetTitleWidth(0);
end
