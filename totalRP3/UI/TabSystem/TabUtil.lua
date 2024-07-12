-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TabUtil = {};

function TRP3_TabUtil.CreateTabs(owner, buttons)
	local function GenerateTabs(_, barDescription)
		for index, button in ipairs(buttons) do
			barDescription:CreateNamedTab(button.id or index, button.text, button.region);
		end
	end

	owner:SetupTabs(GenerateTabs);
end

function TRP3_TabUtil.ApplyTabLayout(buttons, anchor, layout)
	local spacing = layout:GetButtonSpacing();
	local multiplier = layout:GetDirectionMultiplier();
	local offset = 0;

	for index, button in ipairs(buttons) do
		local clearAllPoints = true;
		anchor:SetPointWithExtraOffset(button, clearAllPoints, offset, 0);
		button:SetWidth(1);

		local extent = layout:CalculateButtonExtent(button);
		button:SetWidth(extent);

		offset = offset + ((extent + (index > 0 and spacing or 0)) * multiplier);
	end
end
