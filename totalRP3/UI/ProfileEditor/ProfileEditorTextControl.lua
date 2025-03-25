-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorTextControlInitializer = CreateFromMixins(TRP3_ProfileEditorControlInitializer);

function TRP3_ProfileEditorTextControlInitializer:__init(accessor, label, tooltip, maxLetters)
	TRP3_ProfileEditorControlInitializer.__init(self, accessor, label, tooltip);
	self.maxLetters = maxLetters or math.huge;
end

function TRP3_ProfileEditorTextControlInitializer:GetMaxLetters()
	return self.maxLetters;
end

TRP3_ProfileEditorTextControlMixin = CreateFromMixins(TRP3_ProfileEditorControlMixin);

function TRP3_ProfileEditorTextControlMixin:Init(initializer)
	TRP3_ProfileEditorControlMixin.Init(self, initializer);
	self.Label:Init(initializer);
end

function TRP3_ProfileEditorTextControlMixin:Release()
	self.Label:Release();
	TRP3_ProfileEditorControlMixin.Release(self);
end

TRP3_ProfileEditorTextControlLabelMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_ProfileEditorTextControlLabelMixin:Init(initializer)
	self.label = initializer:GetLabel();
	self.tooltip = initializer:GetTooltip();

	self.Title:SetText(initializer:GetLabel());
	-- self:RefreshCount();  -- TODO: Reimpl
	self:RefreshTooltip();
end

function TRP3_ProfileEditorTextControlLabelMixin:Release()
	self:HideTooltip();
	self.Count:Hide();
	self.Count:SetText("");
	self.Title:SetText("");

	self.tooltip = nil;
	self.label = nil;
end

function TRP3_ProfileEditorTextControlLabelMixin:OnEnter()
	TRP3_TooltipScriptMixin.OnEnter(self);
end

function TRP3_ProfileEditorTextControlLabelMixin:OnLeave()
	TRP3_TooltipScriptMixin.OnLeave(self);
end

function TRP3_ProfileEditorTextControlLabelMixin:OnTooltipShow(description)
	TRP3_ProfileEditor.CreateControlTooltip(description, self.label, self.tooltip);
	-- TODO: Restore count warning.
end

function TRP3_ProfileEditorTextControlLabelMixin:ShouldShowTooltip()
	-- TODO: Reimplement conditional logic for count warning.
	return self.Title:IsTruncated() or self.tooltip ~= nil;
end
