-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileEditorLabelInitializer = CreateFromMixins(TRP3_ProfileEditorTooltipInitializer);

function TRP3_ProfileEditorLabelInitializer:__init(label, tooltip)
	TRP3_ProfileEditorTooltipInitializer.__init(self, tooltip);

	self.label = label;
end

function TRP3_ProfileEditorLabelInitializer:GetLabel()
	return self.label or L.CM_UNKNOWN;
end

function TRP3_ProfileEditorLabelInitializer:SetLabel(label)
	self.label = label;
end

TRP3_ProfileEditorLabelMixin = CreateFromMixins(TRP3_ProfileEditorTooltipMixin);

function TRP3_ProfileEditorLabelMixin:Init(initializer)
	TRP3_ProfileEditorTooltipMixin.Init(self, initializer);
	self.Title:SetText(initializer:GetLabel());
end

function TRP3_ProfileEditorLabelMixin:Release()
	TRP3_ProfileEditorTooltipMixin.Release(self);
	self.Title:SetText("");
end

function TRP3_ProfileEditorLabelMixin:ShouldShowTooltip()
	if TRP3_ProfileEditorTooltipMixin.ShouldShowTooltip(self) then
		return true;
	else
		return self.Title:IsTruncated();
	end
end

function TRP3_ProfileEditorLabelMixin:PopulateTooltip(description)
	description:AddTitleLine(self.Title:GetText());
	description:QueueBlankLine();
	TRP3_ProfileEditorTooltipMixin.PopulateTooltip(self, description);
	description:ClearQueuedLines();
end
