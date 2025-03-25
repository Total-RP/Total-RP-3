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
end

function TRP3_ProfileEditorTextAreaMixin:GetText()
	return self.Control:GetText();
end

function TRP3_ProfileEditorTextAreaMixin:GetTextLength()
	return self.Control:GetEditBox():GetNumLetters();
end

function TRP3_ProfileEditorTextAreaMixin:SetText(text)
	self.Control:SetText(text);
end
