-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileEditorTextControlInitializer = CreateFromMixins(TRP3_ProfileEditorControlInitializer);

function TRP3_ProfileEditorTextControlInitializer:__init(accessor, label, tooltip, letterCountLimit)
	TRP3_ProfileEditorControlInitializer.__init(self, accessor, label, tooltip);

	self.letterCountLimit = letterCountLimit;
	self.letterCountWarningText = nil;
end

function TRP3_ProfileEditorTextControlInitializer:GetLetterCountLimit()
	return self.letterCountLimit or math.huge;
end

function TRP3_ProfileEditorTextControlInitializer:SetLetterCountLimit(letterCountLimit)
	self.letterCountLimit = letterCountLimit;
end

function TRP3_ProfileEditorTextControlInitializer:GetLetterCountWarningText()
	return self.letterCountWarningText or L.TODOFINDAPREFIXTODO_PROFILE_FIELD_IS_CHONK3;
end

function TRP3_ProfileEditorTextControlInitializer:SetLetterCountWarningText(letterCountWarningText)
	self.letterCountWarningText = letterCountWarningText;
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
	self.letterCountLimit = initializer:GetLetterCountLimit();
	self.letterCountWarningText = initializer:GetLetterCountWarningText();
	self.letterCountHint = math.floor((self.letterCountLimit * 0.9) / 5) * 5;

	self.Title:SetText(initializer:GetLabel());
end

function TRP3_ProfileEditorTextControlLabelMixin:Release()
	self:HideTooltip();
	self:ResetLetterCount();

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

	if self:IsAboveLetterLimit() then
		description:AddBlankLine();
		-- TODO: AddSubtitleLine / AddSubtitleWithIconLine perhaps? :thinkles:
		description:AddHighlightLine(TRP3_MarkupUtil.GenerateIconMarkup("services-icon-warning", { height = 16, width = 18 }) .. " Warning");
		description:AddNormalLine(self.letterCountWarningText);
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
	return self.tooltip ~= nil or self:IsAboveLetterLimit() or self.Title:IsTruncated();
end

function TRP3_ProfileEditorTextControlLabelMixin:IsAboveLetterLimit()
	return self.letterCount > self.letterCountLimit;
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
	self.Counter:SetLetterCount(self.letterCount, self.letterCountHint, self.letterCountLimit);
end

TRP3_ProfileEditorTextControlLetterCountMixin = {};

function TRP3_ProfileEditorTextControlLetterCountMixin:SetLetterCount(count, hint, limit)
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
