-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ScrollingEditBoxMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_ScrollingEditBoxMixin:GenerateCallbackEvents({
	"OnCursorChanged",
	"OnEditFocusGained",
	"OnEditFocusLost",
	"OnEscapePressed",
	"OnTabPressed",
	"OnTextChanged",
});

function TRP3_ScrollingEditBoxMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);

	self.EditBox = self.ScrollFrame:GetEditBox();
	self.EditBox:RegisterCallback("OnCursorChanged", self.OnCursorChanged, self);
	self.EditBox:RegisterCallback("OnEditFocusGained", self.OnEditFocusGained, self);
	self.EditBox:RegisterCallback("OnEditFocusLost", self.OnEditFocusLost, self);
	self.EditBox:RegisterCallback("OnEscapePressed", self.OnEscapePressed, self);
	self.EditBox:RegisterCallback("OnTabPressed", self.OnTabPressed, self);
	self.EditBox:RegisterCallback("OnTextChanged", self.OnTextChanged, self);
	self.EditBox:HookScript("OnChar", function(_, char) self:OnChar(char); end);

	self.FocusCapture:RegisterCallback("OnClick", self.SetFocus, self);

	self.ScrollBox = self.ScrollFrame:GetScrollBox();

	if self.defaultFontName then
		self.EditBox.defaultFontName = self.defaultFontName;
	end

	if self.fontName then
		self.EditBox.fontName = self.fontName;
		self.EditBox:SetFontObject(self.fontName);
	end

	if self.maxLetters then
		self.EditBox:SetMaxLetters(self.maxLetters);
	end
end

function TRP3_ScrollingEditBoxMixin:OnChar(char)
	if self.readOnly then
		local cursorPosition = self.EditBox:GetUTF8CursorPosition();
		self.EditBox:SetText(self.currentInputText);
		self.EditBox:SetCursorPosition(cursorPosition - strlenutf8(char));
	end
end

function TRP3_ScrollingEditBoxMixin:OnCursorChanged(x, y, width, height, context)
	self:TriggerEvent("OnCursorChanged", x, y, width, height, context);
end

function TRP3_ScrollingEditBoxMixin:OnEditFocusGained()
	self:TriggerEvent("OnEditFocusGained");
end

function TRP3_ScrollingEditBoxMixin:OnEditFocusLost()
	self:TriggerEvent("OnEditFocusLost");
end

function TRP3_ScrollingEditBoxMixin:OnEscapePressed()
	self:TriggerEvent("OnEscapePressed");
end

function TRP3_ScrollingEditBoxMixin:OnTabPressed()
	self:TriggerEvent("OnTabPressed");
end

function TRP3_ScrollingEditBoxMixin:OnTextChanged(userChanged)
	self.currentInputText = self:GetInputText();
	self:TriggerEvent("OnTextChanged", userChanged);
end

function TRP3_ScrollingEditBoxMixin:GetEditBox()
	return self.EditBox;
end

function TRP3_ScrollingEditBoxMixin:GetScrollBox()
	return self.ScrollBox;
end

function TRP3_ScrollingEditBoxMixin:ClearFocus()
	self.EditBox:ClearFocus();
end

function TRP3_ScrollingEditBoxMixin:ClearText()
	self.EditBox:ClearText();
end

function TRP3_ScrollingEditBoxMixin:GetFontHeight()
	return self.EditBox:GetFontHeight();
end

function TRP3_ScrollingEditBoxMixin:GetInputText()
	return self.EditBox:GetInputText();
end

function TRP3_ScrollingEditBoxMixin:IsReadOnly()
	return self.readOnlyText ~= nil;
end

function TRP3_ScrollingEditBoxMixin:SetDefaultText(defaultText)
	self.EditBox:SetDefaultText(defaultText);
end

function TRP3_ScrollingEditBoxMixin:SetDefaultTextColor(color)
	self.EditBox:SetDefaultTextColor(color);
end

function TRP3_ScrollingEditBoxMixin:SetDefaultTextEnabled(enabled)
	self.EditBox:SetDefaultTextEnabled(enabled);
end

function TRP3_ScrollingEditBoxMixin:SetEnabled(enabled)
	self.EditBox:SetEnabled(enabled);
end

function TRP3_ScrollingEditBoxMixin:SetReadOnly(readOnly)
	self.readOnly = readOnly;
end

function TRP3_ScrollingEditBoxMixin:SetFocus()
	self.EditBox:SetFocus();
end

function TRP3_ScrollingEditBoxMixin:SetFontObject(fontName)
	self.EditBox:SetFontObject(fontName);
end

function TRP3_ScrollingEditBoxMixin:SetText(text)
	self.EditBox:SetText(text);
end

function TRP3_ScrollingEditBoxMixin:SetTextColor(color)
	self.EditBox:SetTextColor(color);
end

TRP3_InsetScrollingEditBoxMixin = {};

function TRP3_InsetScrollingEditBoxMixin:OnLoad()
	TRP3_ScrollingEditBoxMixin.OnLoad(self);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 5, -5),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.ScrollBar, "BOTTOMLEFT", -5, 5),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 5),
	};

	ScrollUtil.RegisterScrollBoxWithScrollBar(self.ScrollBox, self.ScrollBar);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
end
