-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MenuUtil = {};

function TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText)
	local function OnTooltipShow(tooltip)
		local tooltipTitle = MenuUtil.GetElementText(elementDescription);

		GameTooltip_SetTitle(tooltip, tooltipTitle);
		GameTooltip_AddNormalLine(tooltip, tooltipText, true);
	end

	elementDescription:SetTooltip(OnTooltipShow);
end

function TRP3_MenuUtil.AttachTexture(elementDescription, icon)
	local function Initializer(button)
		local iconTexture = button:AttachTexture();
		iconTexture:SetPoint("RIGHT");
		iconTexture:SetSize(16, 16);

		if C_Texture.GetAtlasInfo(icon) then
			local useAtlasSize = false;
			iconTexture:SetAtlas(icon, useAtlasSize);
		else
			iconTexture:SetTexture(icon);
		end
	end

	elementDescription:AddInitializer(Initializer);
end

function TRP3_MenuUtil.CreateContextMenu(ownerRegion, menuGenerator)
	return MenuUtil.CreateContextMenu(ownerRegion, menuGenerator);
end
