-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MenuTemplates = {};

function TRP3_MenuTemplates.CreateColorSelectionButton(text, color, callback, data)
	local elementDescription = MenuUtil.CreateButton(text, callback, data);

	local function ColorSwatchInitializer(frame)
		frame.colorSwatch = frame:AttachTemplate("TRP3_ColorSwatchTemplate");
		frame.colorSwatch:SetPoint("LEFT");
		frame.colorSwatch:SetSize(16, 16);
		frame.colorSwatch:SetColor(color);

		frame.fontString:SetPoint("LEFT", frame.colorSwatch, "RIGHT", 5, 0);
	end

	elementDescription:AddInitializer(ColorSwatchInitializer);
	return elementDescription;
end
