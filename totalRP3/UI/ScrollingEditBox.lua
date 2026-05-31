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
	if self:IsReadOnly() then
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
	if self.highlightOnFocus then
		RunNextFrame(function() self.EditBox:HighlightText(); end);
	end
end

function TRP3_ScrollingEditBoxMixin:OnEditFocusLost()
	self:TriggerEvent("OnEditFocusLost");
	self.EditBox:HighlightText(0, 0);
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
    self.ScrollFrame:ClearText();
end

function TRP3_ScrollingEditBoxMixin:GetFontHeight()
	return self.EditBox:GetFontHeight();
end

function TRP3_ScrollingEditBoxMixin:GetInputText()
	local text = self.EditBox:GetInputText();
	if self.escapeSanitized then
		text = string.gsub(text, "||", "|");
	end
	return text;
end

function TRP3_ScrollingEditBoxMixin:IsReadOnly()
	return self.readOnly ~= nil;
end

function TRP3_ScrollingEditBoxMixin:SetDefaultText(defaultText)
    self.EditBox:ApplyDefaultText(defaultText);
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

function TRP3_ScrollingEditBoxMixin:SetEscapeSanitized(enabled)
    self.escapeSanitized = enabled;
end

function TRP3_ScrollingEditBoxMixin:SetHighlightOnFocus(enabled)
    self.highlightOnFocus = enabled;
end

function TRP3_ScrollingEditBoxMixin:SetText(text)
	if self.escapeSanitized then
		text = string.gsub(text, "|", "||");
	end
	self.currentInputText = text;
	self.EditBox:SetText(text);
end

function TRP3_ScrollingEditBoxMixin:SetTextColor(color)
	self.EditBox:SetTextColor(color);
end

TRP3_InsetScrollingEditBoxMixin = {};

function TRP3_InsetScrollingEditBoxMixin:OnLoad()
	TRP3_ScrollingEditBoxMixin.OnLoad(self);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 8, -6),
		AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", -8, 4),
		AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -8, 0),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		scrollBoxAnchorsWithBar[2],
		AnchorUtil.CreateAnchor("RIGHT", self, "RIGHT", -8, 0),
	};

	ScrollUtil.RegisterScrollBoxWithScrollBar(self.ScrollBox, self.ScrollBar);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
end
