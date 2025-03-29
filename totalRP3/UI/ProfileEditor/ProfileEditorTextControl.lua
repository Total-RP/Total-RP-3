-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileEditorTextControlInitializer = CreateFromMixins(TRP3_ProfileEditorControlInitializer, TRP3_ProfileEditorLabelInitializer);

function TRP3_ProfileEditorTextControlInitializer:__init(field, label, tooltip, maxLetters)
	TRP3_ProfileEditorControlInitializer.__init(self, field);
	TRP3_ProfileEditorLabelInitializer.__init(self, label, tooltip);

	self.maxLetters = maxLetters;
	self.lengthWarningText = nil;
end

function TRP3_ProfileEditorTextControlInitializer:GetMaxLetters()
	return self.maxLetters or math.huge;
end

function TRP3_ProfileEditorTextControlInitializer:SetMaxLetters(maxLetters)
	self.maxLetters = maxLetters;
end

function TRP3_ProfileEditorTextControlInitializer:GetLengthWarningText()
	return (self.lengthWarningText ~= "") and self.lengthWarningText or "heckin' ayaya";
end

function TRP3_ProfileEditorTextControlInitializer:SetLengthWarningText(lengthWarningText)
	self.lengthWarningText = lengthWarningText;
end

TRP3_ProfileEditorLetterCounterMixin = {};

function TRP3_ProfileEditorLetterCounterMixin:SetLetterCount(count, hint, limit)
	if count >= hint then
		local color = (count > limit) and self.warningColor or self.defaultColor;
		local distance = (limit - count);

		self:SetFormattedText("%d", distance);
		self:SetTextColor(color:GetRGB());
		self:Show();
	else
		self:Hide();
	end
end

TRP3_ProfileEditorTextLabelMixin = CreateFromMixins(TRP3_ProfileEditorLabelMixin);

function TRP3_ProfileEditorTextLabelMixin:Init(initializer)
	TRP3_ProfileEditorLabelMixin.Init(self, initializer);

	self.maxLetters = initializer:GetMaxLetters();
	self.maxLettersHint = math.floor((self.maxLetters * 0.9) / 5) * 5;
	self.lengthWarningText = initializer:GetLengthWarningText();
end

function TRP3_ProfileEditorTextLabelMixin:Release()
	TRP3_ProfileEditorLabelMixin.Release(self);

	self:ResetLetterCount();
end

function TRP3_ProfileEditorTextLabelMixin:PopulateTooltip(description)
	TRP3_ProfileEditorLabelMixin.PopulateTooltip(self, description);

	if self:ShouldShowLengthWarning() then
		local icon = TRP3_MarkupUtil.GenerateIconMarkup("services-icon-warning", { height = 16, width = 18 });

		description:AddBlankLine();
		description:AddHighlightLine(string.join(" ", icon, L.CM_WARNING));
		description:AddNormalLine(self.lengthWarningText);
	end
end

function TRP3_ProfileEditorTextLabelMixin:OnLetterCountChanged(numLetters)  -- luacheck: no unused
	self:RefreshLetterCount();
	self:RefreshTooltip();
end

function TRP3_ProfileEditorTextLabelMixin:ShouldShowTooltip()
	if TRP3_ProfileEditorLabelMixin.ShouldShowTooltip(self) then
		return true;
	else
		return self:ShouldShowLengthWarning();
	end
end

function TRP3_ProfileEditorTextLabelMixin:ShouldShowLengthWarning()
	return (self.lengthWarningText ~= nil) and (self.numLetters > self.maxLetters);
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

function TRP3_ProfileEditorTextLabelMixin:RefreshLetterCount()
	self.LetterCounter:SetLetterCount(self.numLetters, self.maxLettersHint, self.maxLetters);
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
