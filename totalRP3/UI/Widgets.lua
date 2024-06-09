-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--[[
	TRP3_TruncatedTextMixin
--]]

TRP3_TruncatedTextMixin = CreateFromMixins(FontableFrameMixin);

function TRP3_TruncatedTextMixin:OnLoad()
	if not self.Text then
		self.Text = self:CreateFontString(nil, self.fontStringLayer, self.fontStringTemplate, self.fontStringSubLayer);
		self.Text:SetAllPoints(self);
	end

	if self.fontStringColor then
		self.Text:SetTextColor(self.fontStringColor);
	end

	if self.fontStringJustifyH then
		self.Text:SetJustifyH(self.fontStringJustifyH);
	end

	if self.fontStringJustifyV then
		self.Text:SetJustifyV(self.fontStringJustifyV);
	end
end

function TRP3_TruncatedTextMixin:GetText()
	return self.Text:GetText();
end

function TRP3_TruncatedTextMixin:IsTruncated()
	return self.Text:IsTruncated();
end

function TRP3_TruncatedTextMixin:SetFormattedText(format, ...)
	return self.Text:SetFormattedText(format, ...)
end

function TRP3_TruncatedTextMixin:SetText(text)
	return self.Text:SetText(text);
end

--[[override]] function TRP3_TruncatedTextMixin:OnFontObjectUpdated()
	self.Text:SetFontObject(self:GetFontObject());
end

TRP3_TooltipMixin = {};

function TRP3_TooltipMixin:SetCenterColor(r, g, b, a)
	self.NineSlice:SetCenterColor(r, g, b, a or 1);
end

function TRP3_TooltipMixin:SetBorderColor(r, g, b, a)
	self.NineSlice:SetBorderColor(r, g, b, a or 1);
end

TRP3_TextAreaBaseMixin = {};

function TRP3_TextAreaBaseMixin:OnLoad()
	local editbox = self:GetEditBox();
	editbox:RegisterCallback("OnEditFocusGained", self.OnEditFocusGained, self);
	editbox:RegisterCallback("OnEditFocusGained", self.OnEditFocusLost, self);
end

function TRP3_TextAreaBaseMixin:OnShow()
	self:UpdateLayout();
end

function TRP3_TextAreaBaseMixin:OnSizeChanged()
	self:UpdateLayout();
end

function TRP3_TextAreaBaseMixin:OnEditFocusGained()
	local focus = self:GetFocusFrame();
	focus:Hide();
end

function TRP3_TextAreaBaseMixin:OnEditFocusLost()
	local focus = self:GetFocusFrame();
	focus:Show();
end

function TRP3_TextAreaBaseMixin:GetEditBox()
	return self.scroll.text;
end

function TRP3_TextAreaBaseMixin:GetFocusFrame()
	return self.dummy;
end

function TRP3_TextAreaBaseMixin:UpdateLayout()
	local editbox = self:GetEditBox();
	editbox:SetWidth(self:GetWidth() - 40);
end

TRP3_TextAreaBaseEditBoxMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_TextAreaBaseEditBoxMixin:GenerateCallbackEvents({
	"OnEditFocusGained",
	"OnEditFocusLost",
});

function TRP3_TextAreaBaseEditBoxMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	ScrollingEdit_OnLoad(self);
end

function TRP3_TextAreaBaseEditBoxMixin:OnCursorChanged(x, y, w, h)
	ScrollingEdit_OnCursorChanged(self, x, y, w, h);
end

function TRP3_TextAreaBaseEditBoxMixin:OnTextChanged()
	ScrollingEdit_OnTextChanged(self, self:GetScrollFrame());
end

function TRP3_TextAreaBaseEditBoxMixin:OnEscapePressed()
	self:ClearFocus();
end

function TRP3_TextAreaBaseEditBoxMixin:OnEditFocusGained()
	self:TriggerEvent("OnEditFocusGained", self);
end

function TRP3_TextAreaBaseEditBoxMixin:OnEditFocusLost()
	self:HighlightText(0, 0);
	self:TriggerEvent("OnEditFocusLost", self);
end

function TRP3_TextAreaBaseEditBoxMixin:GetScrollFrame()
	return self:GetParent();
end
