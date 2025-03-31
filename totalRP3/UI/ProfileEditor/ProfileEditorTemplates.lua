-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorLetterCountMixin = {};

local function FloorToMultiple(n, mult)
	return math.floor(n / mult) * mult;
end

function TRP3_ProfileEditorLetterCountMixin:SetCount(count, limit)
	local threshold = FloorToMultiple(limit * 0.9, 5);

	if count >= threshold then
		local color = (count > limit) and self.warningColor or self.defaultColor;
		local distance = (limit - count);

		self:SetFormattedText("%d", distance);
		self:SetTextColor(color:GetRGB());
		self:Show();
	else
		self:Hide();
	end
end
