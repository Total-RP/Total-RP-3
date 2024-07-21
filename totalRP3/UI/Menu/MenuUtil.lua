-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MenuUtil = {};

function TRP3_MenuUtil.CreateButton(text, callback, data)
	local elementDescription;

	if TRP3_USE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateButton(text, callback, data);
	else
		elementDescription = TRP3_MenuTemplates.CreateButton(text, callback, data);
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateCheckbox(text, isSelected, setSelected, data)
	local elementDescription;

	if TRP3_USE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateCheckbox(text, isSelected, setSelected, data);
	else
		elementDescription = TRP3_MenuTemplates.CreateCheckbox(text, isSelected, setSelected, data);
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateRadio(text, isSelected, setSelected, data)
	local elementDescription;

	if TRP3_USE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateRadio(text, isSelected, setSelected, data);
	else
		elementDescription = TRP3_MenuTemplates.CreateRadio(text, isSelected, setSelected, data);
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateDivider()
	local elementDescription;

	if TRP3_USE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateDivider();
	else
		elementDescription = TRP3_MenuTemplates.CreateDivider();
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateTitle(text, color)
	local elementDescription;

	if TRP3_USE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateTitle(text, color);
	else
		elementDescription = TRP3_MenuTemplates.CreateTitle(text, color);
	end

	return elementDescription;
end

function TRP3_MenuUtil.GetElementText(elementDescription)
	local text;

	if TRP3_USE_MODERN_MENUS then
		text = MenuUtil.GetElementText(elementDescription);
	else
		text = elementDescription.text;
	end

	return text;
end

function TRP3_MenuUtil.SetElementText(elementDescription, text)
	if TRP3_USE_MODERN_MENUS then
		MenuUtil.SetElementText(elementDescription, text);
	else
		elementDescription.text = text;
	end
end

function TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText)
	if TRP3_USE_MODERN_MENUS then
		local function OnTooltipShow(tooltip)
			local tooltipTitle = TRP3_MenuUtil.GetElementText(elementDescription);

			GameTooltip_SetTitle(tooltip, tooltipTitle);
			GameTooltip_AddNormalLine(tooltip, tooltipText, true);
		end

		elementDescription:SetTooltip(OnTooltipShow);
	else
		local function Initializer(info, description, menu)  -- luacheck: no unused
			info.tooltipTitle = TRP3_MenuUtil.GetElementText(elementDescription);
			info.tooltipText = tooltipText;
			info.tooltipOnButton = true;
		end

		elementDescription:AddInitializer(Initializer);
	end
end

function TRP3_MenuUtil.AttachTexture(elementDescription, icon)
	if TRP3_USE_MODERN_MENUS then
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
	else
		local function Initializer(info, description, menu)  -- luacheck: no unused
			info.icon = icon;
			info.iconXOffset = -4;
		end

		elementDescription:AddInitializer(Initializer);
	end
end

function TRP3_MenuUtil.HideTooltip(owner)
	if TRP3_USE_MODERN_MENUS then
		MenuUtil.HideTooltip(owner);
	else
		local tooltip = TRP3_MainTooltip;

		if TRP3_TooltipUtil.IsOwned(tooltip, owner) then
			tooltip:Hide();
		end
	end
end

function TRP3_MenuUtil.ShowTooltip(owner, func, ...)
	if TRP3_USE_MODERN_MENUS then
		MenuUtil.ShowTooltip(owner, func, ...);
	else
		local tooltip = TRP3_MainTooltip;
		tooltip:SetOwner(owner, "ANCHOR_RIGHT");
		func(tooltip, ...);
		tooltip:Show();
	end
end

local function TraverseSelections(elementDescription, selections, condition)
	if ((condition == nil) or condition(elementDescription)) and (elementDescription:IsSelected()) then
		table.insert(selections, elementDescription);
	end

	for _, desc in elementDescription:EnumerateElementDescriptions() do
		TraverseSelections(desc, selections, condition);
	end

	return false;
end

function TRP3_MenuUtil.GetSelections(elementDescription, condition)
	local selections = {};

	for _, desc in elementDescription:EnumerateElementDescriptions() do
		TraverseSelections(desc, selections, condition);
	end

	return selections;
end

function TRP3_MenuUtil.CreateContextMenu(ownerRegion, menuGenerator)
	if TRP3_USE_MODERN_MENUS then
		return MenuUtil.CreateContextMenu(ownerRegion, menuGenerator);
	else
		return TRP3_Menu.OpenContextMenu(ownerRegion, menuGenerator);
	end
end
