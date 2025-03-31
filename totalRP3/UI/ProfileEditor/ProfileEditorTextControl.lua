-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileEditorTextControlInitializer = CreateFromMixins(TRP3_ProfileEditorControlInitializer, TRP3_ProfileEditorLabelInitializer);

function TRP3_ProfileEditorTextControlInitializer:__init(field, label, tooltip, maxLetters)
	TRP3_ProfileEditorControlInitializer.__init(self, field);
	TRP3_ProfileEditorLabelInitializer.__init(self, label, tooltip);

	self.maxLetters = maxLetters;
	self.lengthWarning = nil;
end

function TRP3_ProfileEditorTextControlInitializer:GetMaxLetters()
	return self.maxLetters or math.huge;
end

function TRP3_ProfileEditorTextControlInitializer:SetMaxLetters(maxLetters)
	self.maxLetters = maxLetters;
end

function TRP3_ProfileEditorTextControlInitializer:GetLengthWarningText()
	return (self.lengthWarning ~= "") and self.lengthWarning or L.PROFILE_EDITOR_LENGTH_WARNING_DEFAULT;
end

function TRP3_ProfileEditorTextControlInitializer:SetLengthWarningText(lengthWarning)
	self.lengthWarning = lengthWarning;
end

TRP3_ProfileEditorTextLabelMixin = CreateFromMixins(TRP3_ProfileEditorLabelMixin);

function TRP3_ProfileEditorTextLabelMixin:Init(initializer)
	TRP3_ProfileEditorLabelMixin.Init(self, initializer);

	self.maxLetters = initializer:GetMaxLetters();
	self.lengthWarning = initializer:GetLengthWarningText();
end

function TRP3_ProfileEditorTextLabelMixin:Release()
	self:ResetLetterCount();
	TRP3_ProfileEditorLabelMixin.Release(self);
end

function TRP3_ProfileEditorTextLabelMixin:OnEnter()
	TRP3_ProfileEditorLabelMixin.OnEnter(self);
	self.WarningIcon:SetHighlightLocked(true);
end

function TRP3_ProfileEditorTextLabelMixin:OnLeave()
	self.WarningIcon:SetHighlightLocked(false);
	TRP3_ProfileEditorLabelMixin.OnLeave(self);
end

function TRP3_ProfileEditorTextLabelMixin:OnTooltipShow(description)
	TRP3_ProfileEditorLabelMixin.OnTooltipShow(self, description);

	if self:ShouldShowLengthWarning() then
		local icon = TRP3_MarkupUtil.GenerateIconMarkup("services-icon-warning", { height = 16, width = 18 });

		description:AddBlankLine();
		description:AddHighlightLine(string.join(" ", icon, L.CM_WARNING));
		description:AddNormalLine(self.lengthWarning);
	end
end

function TRP3_ProfileEditorTextLabelMixin:ShouldShowTooltip()
	if TRP3_ProfileEditorLabelMixin.ShouldShowTooltip(self) then
		return true;
	else
		return self:ShouldShowLengthWarning();
	end
end

function TRP3_ProfileEditorTextLabelMixin:ShouldShowLengthWarning()
	return (self.numLetters > self.maxLetters);
end

function TRP3_ProfileEditorTextLabelMixin:ResetLetterCount()
	self:UpdateLetterCount(0);
end

function TRP3_ProfileEditorTextLabelMixin:UpdateLetterCount(numLetters)
	if self.numLetters == numLetters then
		return;
	end

	self.numLetters = numLetters;
	self:OnLetterCountChanged(numLetters);
end

function TRP3_ProfileEditorTextLabelMixin:OnLetterCountChanged(_numLetters)
	local shouldShowWarning = self:ShouldShowLengthWarning();

	self.LetterCount:SetCount(self.numLetters, self.maxLetters);
	self.WarningIcon:SetShown(shouldShowWarning);
	self.TooltipIcon:SetShown(not shouldShowWarning);
	self:SetTooltipShown(self:ShouldShowTooltip());
end

TRP3_ProfileEditorTextControlMixin = CreateFromMixins(TRP3_ProfileEditorControlMixin);

function TRP3_ProfileEditorTextControlMixin:Init(initializer)
	TRP3_ProfileEditorControlMixin.Init(self, initializer);
	self.Label:Init(initializer);
end

function TRP3_ProfileEditorTextControlMixin:Release()
	TRP3_ProfileEditorControlMixin.Release(self);
	self.Label:Release();
end

function TRP3_ProfileEditorTextControlMixin:UpdateLetterCount(numLetters)
	self.Label:UpdateLetterCount(numLetters);
end
