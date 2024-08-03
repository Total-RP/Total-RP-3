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
