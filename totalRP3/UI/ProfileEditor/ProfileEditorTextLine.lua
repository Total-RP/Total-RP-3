-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

function TRP3_ProfileEditor.CreateTextLineInitializer(accessor, label, description, maxLetters)
	local object = TRP3_API.AllocateObject(TRP3_ProfileEditorTextControlInitializer);
	object:__init(accessor, label, description, maxLetters);
	return object;
end

TRP3_ProfileEditorTextLineMixin = CreateFromMixins(TRP3_ProfileEditorTextControlMixin);

function TRP3_ProfileEditorTextLineMixin:Init(initializer)
	TRP3_ProfileEditorTextControlMixin.Init(self, initializer);
end

function TRP3_ProfileEditorTextLineMixin:GetText()
	return self.Control:GetText();
end

function TRP3_ProfileEditorTextLineMixin:GetTextLength()
	return self.Control:GetNumLetters();
end

function TRP3_ProfileEditorTextLineMixin:SetText(text)
	return self.Control:SetText(text);
end
