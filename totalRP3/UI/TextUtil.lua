-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TruncatedTextMixin = {};

function TRP3_TruncatedTextMixin:OnEnter()
	if self:IsTruncated() then
		TRP3_TooltipTemplates.ShowTruncationTooltip(self, self:GetText());
	end
end

function TRP3_TruncatedTextMixin:OnLeave()
	TRP3_TooltipUtil.HideTooltip(self);
end

TRP3_ReadableTextMixin = {};

function TRP3_ReadableTextMixin:SetReadableTextColor(color, backgroundColor, targetLevel)
	backgroundColor = backgroundColor or self.readableTextBackgroundColor or TRP3_API.Colors.Black;
	targetLevel = targetLevel or self.readableTextContrastLevel or TRP3_ColorContrastOption.UseConfiguredLevel;

	color = TRP3_API.GenerateReadableColor(color, backgroundColor, targetLevel);
	self:SetTextColor(color:GetRGBA());
end
