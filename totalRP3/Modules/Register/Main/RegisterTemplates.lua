-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_RegisterSectionHeaderMixin = {};

function TRP3_RegisterSectionHeaderMixin:SetText(text)
	self.Text:SetText(text);
end

function TRP3_RegisterSectionHeaderMixin:SetIconTexture(icon)
	self.Icon:SetIconTexture(icon);
end

TRP3_RegisterTraitLineMixin = {};

function TRP3_RegisterTraitLineMixin:OnEnter()
	TRP3_API.register.togglePsychoCountText(self, true);
end

function TRP3_RegisterTraitLineMixin:OnLeave()
	TRP3_API.register.togglePsychoCountText(self, false);
end

function TRP3_RegisterTraitLineMixin:SetLeftText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.LeftText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetRightText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.RightText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetLeftIcon(icon)
	self.LeftIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetRightIcon(icon)
	self.RightIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetLeftColor(color)
	self.LeftText:SetReadableTextColor(color);
	self.LeftText:SetFixedColor(true);
	self.Bar:SetStatusBarColor(color:GetRGBA());
end

function TRP3_RegisterTraitLineMixin:SetRightColor(color)
	self.RightText:SetReadableTextColor(color);
	self.RightText:SetFixedColor(true);
	self.Bar.OppositeFill:SetVertexColor(color:GetRGBA());
end

TRP3_RegisterColorSwatchMixin = {};

function TRP3_RegisterColorSwatchMixin:OnTooltipShow(description)
	if self.showContrastTooltip then
		description:AddNormalLine(L.REG_COLOR_SWATCH_WARNING);
	end
end

function TRP3_RegisterColorSwatchMixin:SetShowContrastTooltip(showContrastTooltip)
	self.showContrastTooltip = showContrastTooltip;
	self:RefreshTooltip();
end

TRP3_RegisterInfoLineMixin = {};

function TRP3_RegisterInfoLineMixin:OnLoad()
	self.Value:SetFixedColor(true);
end

function TRP3_RegisterInfoLineMixin:OnSizeChanged(width)
	self.Title:SetWidth(width * 0.3);
end

function TRP3_RegisterInfoLineMixin:SetIcon(icon)
	self.Icon:SetIconTexture(icon);
end

function TRP3_RegisterInfoLineMixin:SetIconShown(shown)
	self.Icon:SetShown(shown);
	self:SetHeight(shown and 34 or 26);
end

function TRP3_RegisterInfoLineMixin:SetTitleText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Title:SetText(text);
end

function TRP3_RegisterInfoLineMixin:SetValueText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Value:SetText(text);
end

TRP3_RegisterInfoSwatchLineMixin = CreateFromMixins(TRP3_RegisterInfoLineMixin);

function TRP3_RegisterInfoSwatchLineMixin:SetValueColorFromHexString(hex)
	local color;

	if hex then
		color = TRP3_API.ParseColorFromHexString(hex);
	end

	self:SetValueColor(color);
end

function TRP3_RegisterInfoSwatchLineMixin:SetValueColor(color)
	if color then
		self.Value:SetReadableTextColor(color);
		self.Swatch:SetColor(color);
		self.Swatch:SetShowContrastTooltip(not TRP3_API.IsColorReadable(color, TRP3_PARCHMENT_BACKGROUND_COLOR));
		self.Swatch:Show();
	else
		self.Value:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
		self.Swatch:Hide();
	end
end
