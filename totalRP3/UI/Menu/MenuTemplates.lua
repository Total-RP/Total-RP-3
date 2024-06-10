-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function CreateTextElementDescription(text)
	local elementDescription = TRP3_Menu.CreateMenuElementDescription();
	elementDescription.text = text;
	return elementDescription;
end

local function CreateButtonDescription(text)
	local function Initializer(info, description, menu)  -- luacheck: no unused
		info.text = TRP3_MenuUtil.GetElementText(description);
		info.disabled = not description:IsEnabled();
		info.hasArrow = description:CanOpenSubmenu();
	end

	local elementDescription = CreateTextElementDescription(text);
	elementDescription:AddInitializer(Initializer);
	return elementDescription;
end

local function CreateCheckboxDescription(text)
	local function Initializer(info, description, menu)  -- luacheck: no unused
		info.checked = function() return description:IsSelected(); end;
		info.isNotRadio = true;
		info.notCheckable = false;
	end

	local elementDescription = CreateButtonDescription(text);
	elementDescription:AddInitializer(Initializer);
	return elementDescription;
end

local function CreateRadioDescription(text)
	local function Initializer(info, description, menu)  -- luacheck: no unused
		info.checked = function() return description:IsSelected(); end;
		info.notCheckable = false;
	end

	local elementDescription = CreateButtonDescription(text);
	elementDescription:AddInitializer(Initializer);
	return elementDescription;
end

local function CreateTitleDescription(text, color)
	local function Initializer(info, description, menu)  -- luacheck: no unused
		info.colorCode = color and color:GenerateHexColorMarkup() or nil;
		info.isTitle = true;
	end

	local elementDescription = CreateButtonDescription(text);
	elementDescription:AddInitializer(Initializer);
	return elementDescription;
end

local function CreateDividerDescription()
	local function Initializer(info, description, menu)  -- luacheck: no unused
		info.hasArrow = false;
		info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
		info.iconInfo = { tCoordLeft = 0, tCoordRight = 1, tCoordTop = 0, tCoordBottom = 1, tSizeX = 0, tSizeY = 8, tFitDropDownSizeX = true };
		info.iconOnly = true;
		info.isTitle = true;
		info.notCheckable = true;
	end

	local elementDescription = TRP3_Menu.CreateMenuElementDescription();
	elementDescription:AddInitializer(Initializer);
	return elementDescription;
end

local function GetButtonSoundKit(description)  -- luacheck: no unused
	return SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON;
end

local function GetCheckboxSoundKit(description)
	if description:IsSelected() then
		return SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON;
	else
		return SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF;
	end
end

TRP3_MenuTemplates = {};

function TRP3_MenuTemplates.CreateButton(text, callback, data)
	local elementDescription = CreateButtonDescription(text);
	elementDescription:SetData(data);
	elementDescription:SetResponder(callback);
	elementDescription:SetSoundKit(GetButtonSoundKit);
	return elementDescription;
end

function TRP3_MenuTemplates.CreateCheckbox(text, isSelected, setSelected, data)
	local elementDescription = CreateCheckboxDescription(text);
	elementDescription:SetData(data);
	elementDescription:SetIsSelected(isSelected);
	elementDescription:SetResponder(setSelected);
	elementDescription:SetResponse(TRP3_MenuResponse.Refresh);
	elementDescription:SetSoundKit(GetCheckboxSoundKit);
	return elementDescription;
end

function TRP3_MenuTemplates.CreateRadio(text, isSelected, setSelected, data)
	local elementDescription = CreateRadioDescription(text);
	elementDescription:SetData(data);
	elementDescription:SetIsSelected(isSelected);
	elementDescription:SetRadio(true);
	elementDescription:SetResponder(setSelected);
	elementDescription:SetSoundKit(GetButtonSoundKit);
	return elementDescription;
end

function TRP3_MenuTemplates.CreateTitle(text, color)
	local elementDescription = CreateTitleDescription(text, color);
	return elementDescription;
end

function TRP3_MenuTemplates.CreateDivider()
	local elementDescription = CreateDividerDescription();
	return elementDescription;
end
