-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

function TRP3_ProfileEditor.CreateTextAreaInitializer(accessor, label, description, maxLetters)
	local object = TRP3_API.AllocateObject(TRP3_ProfileEditorTextControlInitializer);
	object:__init(accessor, label, description, maxLetters);
	return object;
end

TRP3_ProfileEditorTextAreaMixin = CreateFromMixins(TRP3_ProfileEditorTextControlMixin);

function TRP3_ProfileEditorTextAreaMixin:Init(initializer)
	TRP3_ProfileEditorTextControlMixin.Init(self, initializer);

	local initialText = self:GetAccessor():GetValue() or "";
	self.Control:SetText(initialText);
	self.Control:RegisterCallback("OnTextChanged", self.OnControlTextChanged, self);

	self:UpdateLetterCount(self:GetTextLength());
end

function TRP3_ProfileEditorTextAreaMixin:Release()
	self.Control:UnregisterAllCallbacks(self);
	self.Control:ClearText();

	TRP3_ProfileEditorTextControlMixin.Release(self);
end

function TRP3_ProfileEditorTextAreaMixin:OnControlTextChanged(editbox, isUserInput)  -- luacheck: no unused (editbox)
	self:UpdateLetterCount(self:GetTextLength());

	if isUserInput then
		self:GetAccessor():SetValue(self:GetText())
	end
end

function TRP3_ProfileEditorTextAreaMixin:GetText()
	return self.Control:GetInputText();
end

function TRP3_ProfileEditorTextAreaMixin:GetTextLength()
	return self.Control:GetEditBox():GetNumLetters();
end

function TRP3_ProfileEditorTextAreaMixin:SetText(text)
	self.Control:SetText(text);
end
