-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ColorSwatchMixin = {};

function TRP3_ColorSwatchMixin:OnShow()
	PixelUtil.SetPoint(self.OuterBorder, "TOPLEFT", self, "TOPLEFT", 0, 0);
	PixelUtil.SetPoint(self.OuterBorder, "BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
	PixelUtil.SetPoint(self.InnerBorder, "TOPLEFT", self, "TOPLEFT", 1, -1);
	PixelUtil.SetPoint(self.InnerBorder, "BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1);
	PixelUtil.SetPoint(self.Color, "TOPLEFT", self, "TOPLEFT", 2, -2);
	PixelUtil.SetPoint(self.Color, "BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2);
end

function TRP3_ColorSwatchMixin:SetColor(color)
	self.Color:SetVertexColor(color:GetRGB());
end

function TRP3_ColorSwatchMixin:SetColorRGB(r, g, b)
	self.Color:SetVertexColor(r, g, b);
end
