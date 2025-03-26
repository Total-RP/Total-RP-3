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

function TRP3_ProfileEditorTextControlMixin:UpdateLetterCount(letterCount)
	self.Label:UpdateLetterCount(letterCount);
end

TRP3_ProfileEditorTextControlLabelMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_ProfileEditorTextControlLabelMixin:OnLoad()
	self.letterCount = 0;
end

function TRP3_ProfileEditorTextControlLabelMixin:Init(initializer)
	self.label = initializer:GetLabel();
	self.tooltip = initializer:GetTooltip();
	self.letterCountMax = (initializer:GetMaxLetters() or math.huge);
	self.letterCountHint = math.floor((self.letterCountMax * 0.9) / 5) * 5;

	self.Title:SetText(initializer:GetLabel());
end

function TRP3_ProfileEditorTextControlLabelMixin:Release()
	self:HideTooltip();
	self:UpdateLetterCount(0);

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

	if self:IsAboveMaxLetterCount() then
		description:AddBlankLine();
		-- TODO: AddSubtitleLine / AddSubtitleWithIconLine perhaps? :thinkles:
		description:AddHighlightLine(TRP3_MarkupUtil.GenerateIconMarkup("services-icon-warning", { height = 16, width = 18 }) .. " Warning");
		-- TODO: Allow configuring this in the initializer (and localize it).
		description:AddNormalLine("We strongly recommend |cnGREEN_FONT_COLOR:reducing the amount of text|r in this field as it |cnWARNING_FONT_COLOR:may not display correctly|r when viewed by other players.");
	end
end

function TRP3_ProfileEditorTextControlLabelMixin:OnLetterCountChanged(letterCount)  -- luacheck: no unused
	self:RefreshLetterCount();

	-- Changes to the letter count can result in the conditions for tooltip
	-- visibility no longer being met. Refresh only if they're still present
	-- and otherwise hide it.

	if self:ShouldShowTooltip() then
		self:RefreshTooltip();
	else
		self:HideTooltip();
	end
end

function TRP3_ProfileEditorTextControlLabelMixin:ShouldShowTooltip()
	return self.tooltip ~= nil or self:ShouldShowCounterWarning() or self.Title:IsTruncated();
end

function TRP3_ProfileEditorTextControlLabelMixin:IsAboveMaxLetterCount()
	return self.letterCount > self.letterCountMax;
end

function TRP3_ProfileEditorTextControlLabelMixin:ResetLetterCount()
	self:UpdateLetterCount(0);
end

function TRP3_ProfileEditorTextControlLabelMixin:UpdateLetterCount(letterCount)
	if self.letterCount == letterCount then
		return;
	end

	self.letterCount = letterCount;
	self:OnLetterCountChanged(letterCount);
end

function TRP3_ProfileEditorTextControlLabelMixin:RefreshLetterCount()
	self.Counter:SetLetterCount(self.letterCount, self.letterCountHint, self.letterCountMax);
end

TRP3_ProfileEditorTextControlLetterCountMixin = {};

function TRP3_ProfileEditorTextControlLetterCountMixin:SetLetterCount(count, hint, limit)
	if count >= hint then
		local color = (count > limit) and WARNING_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
		local distance = (limit - count);

		self:SetFormattedText("%d", distance);
		self:SetTextColor(color:GetRGB());
		self:Show();
	else
		self:Hide();
	end
end
