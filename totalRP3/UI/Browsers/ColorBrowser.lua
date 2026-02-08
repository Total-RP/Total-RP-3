-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3.loc;

local COLOR_PRESETS_BASIC = {
	{ CO = TRP3.Colors.Red, TX = L.CM_RED},
	{ CO = TRP3.Colors.Orange, TX = L.CM_ORANGE},
	{ CO = TRP3.Colors.Yellow, TX = L.CM_YELLOW},
	{ CO = TRP3.Colors.Green, TX = L.CM_GREEN},
	{ CO = TRP3.Colors.Cyan, TX = L.CM_CYAN},
	{ CO = TRP3.Colors.Blue, TX = L.CM_BLUE},
	{ CO = TRP3.Colors.Purple, TX = L.CM_PURPLE},
	{ CO = TRP3.Colors.Pink, TX = L.CM_PINK},
	{ CO = TRP3.Colors.White, TX = L.CM_WHITE},
	{ CO = TRP3.Colors.Grey, TX = L.CM_GREY},
	{ CO = TRP3.Colors.Black, TX = L.CM_BLACK},
}

local COLOR_PRESETS_CLASS = {
	{ CO = TRP3.ClassColors.HUNTER, TX = LOCALIZED_CLASS_NAMES_MALE.HUNTER or L.CM_CLASS_HUNTER },
	{ CO = TRP3.ClassColors.WARLOCK, TX = LOCALIZED_CLASS_NAMES_MALE.WARLOCK or L.CM_CLASS_WARLOCK },
	{ CO = TRP3.ClassColors.PRIEST, TX = LOCALIZED_CLASS_NAMES_MALE.PRIEST or L.CM_CLASS_PRIEST },
	{ CO = TRP3.ClassColors.PALADIN, TX = LOCALIZED_CLASS_NAMES_MALE.PALADIN or L.CM_CLASS_PALADIN },
	{ CO = TRP3.ClassColors.MAGE, TX = LOCALIZED_CLASS_NAMES_MALE.MAGE or L.CM_CLASS_MAGE },
	{ CO = TRP3.ClassColors.ROGUE, TX = LOCALIZED_CLASS_NAMES_MALE.ROGUE or L.CM_CLASS_ROGUE },
	{ CO = TRP3.ClassColors.DRUID, TX = LOCALIZED_CLASS_NAMES_MALE.DRUID or L.CM_CLASS_DRUID },
	{ CO = TRP3.ClassColors.SHAMAN, TX = LOCALIZED_CLASS_NAMES_MALE.SHAMAN or L.CM_CLASS_SHAMAN },
	{ CO = TRP3.ClassColors.WARRIOR, TX = LOCALIZED_CLASS_NAMES_MALE.WARRIOR or L.CM_CLASS_WARRIOR },
	{ CO = TRP3.ClassColors.DEATHKNIGHT, TX = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT or L.CM_CLASS_DEATHKNIGHT },
	{ CO = TRP3.ClassColors.MONK, TX = LOCALIZED_CLASS_NAMES_MALE.MONK or L.CM_CLASS_MONK },
	{ CO = TRP3.ClassColors.DEMONHUNTER, TX = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER or L.CM_CLASS_DEMONHUNTER },
	{ CO = TRP3.ClassColors.EVOKER, TX = LOCALIZED_CLASS_NAMES_MALE.EVOKER or L.CM_CLASS_EVOKER },
}

local COLOR_PRESETS_RESOURCES = {
	{ CO = TRP3.PowerTypeColors.Mana, TX = POWER_TYPE_MANA },
	{ CO = TRP3.PowerTypeColors.Rage, TX = RAGE },
	{ CO = TRP3.PowerTypeColors.Focus, TX = POWER_TYPE_FOCUS },
	{ CO = TRP3.PowerTypeColors.Energy, TX = POWER_TYPE_ENERGY },
	{ CO = TRP3.PowerTypeColors.ComboPoints, TX = COMBO_POINTS },
	{ CO = TRP3.PowerTypeColors.Runes, TX = RUNES },
	{ CO = TRP3.PowerTypeColors.RunicPower, TX = POWER_TYPE_RUNIC_POWER or RUNIC_POWER },
	{ CO = TRP3.PowerTypeColors.SoulShards, TX = SOUL_SHARDS },
	{ CO = TRP3.PowerTypeColors.LunarPower, TX = POWER_TYPE_LUNAR_POWER },
	{ CO = TRP3.PowerTypeColors.HolyPower, TX = HOLY_POWER },
	{ CO = TRP3.PowerTypeColors.Maelstrom, TX = POWER_TYPE_MAELSTROM },
	{ CO = TRP3.PowerTypeColors.Insanity, TX = POWER_TYPE_INSANITY },
	{ CO = TRP3.PowerTypeColors.Chi, TX = CHI },
	{ CO = TRP3.PowerTypeColors.ArcaneCharges, TX = POWER_TYPE_ARCANE_CHARGES },
	{ CO = TRP3.PowerTypeColors.Fury, TX = POWER_TYPE_FURY },
	{ CO = TRP3.PowerTypeColors.Pain, TX = POWER_TYPE_PAIN },
	{ CO = TRP3.PowerTypeColors.AmmoSlot, TX = AMMOSLOT },
	{ CO = TRP3.PowerTypeColors.Fuel, TX = POWER_TYPE_FUEL },
}

local COLOR_PRESETS_ITEMS = {
	{ CO = TRP3.ItemQualityColors.Poor, TX = ITEM_QUALITY0_DESC},
	{ CO = TRP3.ItemQualityColors.Common, TX = ITEM_QUALITY1_DESC},
	{ CO = TRP3.ItemQualityColors.Uncommon, TX = ITEM_QUALITY2_DESC},
	{ CO = TRP3.ItemQualityColors.Rare, TX = ITEM_QUALITY3_DESC},
	{ CO = TRP3.ItemQualityColors.Epic, TX = ITEM_QUALITY4_DESC},
	{ CO = TRP3.ItemQualityColors.Legendary, TX = ITEM_QUALITY5_DESC},
	{ CO = TRP3.ItemQualityColors.Artifact, TX = ITEM_QUALITY6_DESC},
	{ CO = TRP3.ItemQualityColors.Heirloom, TX = ITEM_QUALITY7_DESC},
	{ CO = TRP3.ItemQualityColors.WoWToken, TX = ITEM_QUALITY8_DESC},
}

local function CompareSortPresetsByName(a, b)
	return TRP3_StringUtil.SortCompareStrings(a.TX, b.TX);
end

table.sort(COLOR_PRESETS_CLASS, CompareSortPresetsByName);
table.sort(COLOR_PRESETS_RESOURCES, CompareSortPresetsByName);

TRP3_ColorPresetManager = {};

local function FindPresetByName(name)
	local index, preset = FindInTableIf(TRP3_Colors or {}, function(preset) return preset.TX == name; end);
	return index, preset;
end

function TRP3_ColorPresetManager.GetCustomPreset(name)
	local _, preset = FindPresetByName(name);
	return preset;
end

function TRP3_ColorPresetManager.GetAllCustomPresets()
	local presets = {};

	for _, preset in ipairs(TRP3_Colors or {}) do
		table.insert(presets, { TX = preset.TX, CO = TRP3.CreateColorFromHexString(preset.CO) });
	end

	table.sort(presets, CompareSortPresetsByName);
	return presets;
end

function TRP3_ColorPresetManager.SaveCustomPreset(name, color)
	if not TRP3_Colors then
		TRP3_Colors = {};
	end

	local _, preset = FindPresetByName(name);
	local colorString = "#" .. color:GenerateHexColorOpaque();

	if preset then
		preset.CO = colorString;
	else
		table.insert(TRP3_Colors, { TX = name, CO = colorString; });
	end
end

function TRP3_ColorPresetManager.RenameCustomPreset(oldName, newName)
	local _, preset = FindPresetByName(oldName);

	if preset then
		preset.TX = newName;
	end
end

function TRP3_ColorPresetManager.DeleteCustomPreset(name)
	if not TRP3_Colors then
		return;
	end

	local index = FindPresetByName(name);

	if index then
		table.remove(TRP3_Colors, index);
	end
end

function TRP3_ColorPresetManager.GenerateDefaultPresetName(color)
	return "#" .. color:GenerateHexColorOpaque();
end

TRP3_ColorBrowserMixin = {};

function TRP3_ColorBrowserMixin:OnLoad()
	self.CloseButton:SetScript("OnClick", function() self:OnCloseButtonClick(); end);
	self.Content.AcceptButton:SetScript("OnClick", function() self:OnAcceptButtonClick(); end);
	self.Content.PresetButton:SetScript("OnClick", function() self:OnPresetButtonClick(); end);
	self.Content.PreviewSwatch:SetScript("OnClick", function() self:OnPreviewSwatchClick(); end);
	self.Content.ColorSelect:SetScript("OnColorSelect", function(_, r, g, b) self:OnColorWheelSelect(r, g, b); end);
	self.Content.HexInput:RegisterCallback("OnColorInput", self.OnHexColorInput, self);
end

function TRP3_ColorBrowserMixin:OnShow()
	self.Title:SetText(L.UI_COLOR_BROWSER);
	self.Content.AcceptButton:SetText(L.UI_COLOR_BROWSER_SELECT);
	self.Content.PresetButton:SetText(L.UI_COLOR_BROWSER_PRESETS);
	self:Update();
end

local function SetPropagateInsecureKeyboardInput(frame, propagate)
	if not InCombatLockdown() then
		frame:SetPropagateKeyboardInput(propagate);
	end
end

function TRP3_ColorBrowserMixin:OnKeyDown(key)
	if key == "ESCAPE" then
		SetPropagateInsecureKeyboardInput(self, false);
		PlaySound(TRP3_InterfaceSounds.PopupClose);
		self:Cancel();
	else
		SetPropagateInsecureKeyboardInput(self, true);
	end
end

function TRP3_ColorBrowserMixin:OnHexColorInput(color)
	self:SetSelectedColor(color);
end

function TRP3_ColorBrowserMixin:OnColorWheelSelect(r, g, b)
	local color = TRP3.CreateColor(r, g, b);

	self:SetSelectedColor(color);
end

function TRP3_ColorBrowserMixin:OnCloseButtonClick()
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Cancel();
end

function TRP3_ColorBrowserMixin:OnAcceptButtonClick()
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Accept();
end

function TRP3_ColorBrowserMixin:OnPresetButtonClick()
	local function OnPresetColorSelected(color)
		self:SetSelectedColor(color);
	end

	local function OnPresetSaveClicked(color)
		local function OnPopupResponse(name)
			if name == "" then
				name = TRP3_ColorPresetManager.GenerateDefaultPresetName(color);
			end

			TRP3_ColorPresetManager.SaveCustomPreset(name, color);
		end

		local prompt = string.join("|n|n", L.BW_CUSTOM_NAME, L.BW_CUSTOM_NAME_TT);
		TRP3.popup.showTextInputPopup(prompt, OnPopupResponse);
	end

	local function OnPresetRenameClicked(preset)
		local function OnPopupResponse(name)
			if name == "" then
				name = TRP3_ColorPresetManager.GenerateDefaultPresetName(preset.CO);
			end

			TRP3_ColorPresetManager.RenameCustomPreset(preset.TX, name);
		end

		local prompt = string.join("|n|n", L.BW_CUSTOM_NAME, L.BW_CUSTOM_NAME_TT);
		TRP3.popup.showTextInputPopup(prompt, OnPopupResponse);
	end

	local function OnPresetDeleteClicked(preset)
		TRP3_ColorPresetManager.DeleteCustomPreset(preset.TX);
	end

	local function GeneratePresetMenu(_, rootDescription)
		rootDescription:CreateTitle(L.BW_COLOR_PRESET_TITLE);

		local function CreatePresetButton(preset, menuDescription)
			local text = preset.TX;
			local color = TRP3.CreateColorFromTable(preset.CO);
			local callback = OnPresetColorSelected;
			local buttonDescription = TRP3_MenuTemplates.CreateColorSelectionButton(text, color, callback, color);

			menuDescription:Insert(buttonDescription);
			return buttonDescription;
		end

		local function CreateStaticPresetMenu(title, presets)
			local menuDescription = rootDescription:CreateButton(title);

			for _, preset in ipairs(presets) do
				CreatePresetButton(preset, menuDescription);
			end
		end

		local function CreateCustomPresetMenu(title, presets)
			local menuDescription = rootDescription:CreateButton(title);

			for _, preset in ipairs(presets) do
				local buttonDescription = CreatePresetButton(preset, menuDescription);
				buttonDescription:SetShouldRespondIfSubmenu(true);
				buttonDescription:SetShouldPlaySoundOnSubmenuClick(true);
				buttonDescription:CreateButton(L.BW_COLOR_PRESET_SELECT, OnPresetColorSelected, buttonDescription:GetData());
				buttonDescription:CreateButton(L.BW_COLOR_PRESET_RENAME, OnPresetRenameClicked, preset);
				buttonDescription:CreateButton(RED_FONT_COLOR:WrapTextInColorCode(L.BW_COLOR_PRESET_DELETE), OnPresetDeleteClicked, preset);
			end
		end

		CreateStaticPresetMenu(L.UI_COLOR_BROWSER_PRESETS_BASIC, COLOR_PRESETS_BASIC);
		CreateStaticPresetMenu(L.UI_COLOR_BROWSER_PRESETS_CLASSES, COLOR_PRESETS_CLASS);
		CreateStaticPresetMenu(L.UI_COLOR_BROWSER_PRESETS_RESOURCES, COLOR_PRESETS_RESOURCES);
		CreateStaticPresetMenu(L.UI_COLOR_BROWSER_PRESETS_ITEMS, COLOR_PRESETS_ITEMS);
		CreateCustomPresetMenu(L.UI_COLOR_BROWSER_PRESETS_CUSTOM, TRP3_ColorPresetManager.GetAllCustomPresets());

		rootDescription:CreateDivider();
		rootDescription:CreateButton(L.BW_COLOR_PRESET_SAVE, OnPresetSaveClicked, self:GetSelectedColor());
	end

	TRP3_MenuUtil.CreateContextMenu(self, GeneratePresetMenu);
end

function TRP3_ColorBrowserMixin:OnPreviewSwatchClick()
	PlaySound(TRP3_InterfaceSounds.ButtonClick);
	self:SetSelectedColor(self.Content.PreviewSwatch:GetReadableColor());
end

function TRP3_ColorBrowserMixin:Open(initialColor, acceptCallback, cancelCallback)
	if not initialColor then
		initialColor = TRP3.Colors.White;
	end

	self.acceptCallback = acceptCallback;
	self.cancelCallback = cancelCallback;
	self.initialColor = initialColor;
	self.selectedColor = initialColor;
	self:Update();

	-- Focusing and highlighting the input field should occur after the
	-- initial update which assigns the text contents.

	self.Content.HexInput:SetFocus();
	self.Content.HexInput:HighlightText();
end

function TRP3_ColorBrowserMixin:Accept()
	if not self:IsShown() then
		return;
	end

	if self.acceptCallback then
		securecallfunction(self.acceptCallback, self:GetSelectedColor());
	end

	self:Hide();
end

function TRP3_ColorBrowserMixin:Cancel()
	if not self:IsShown() then
		return;
	end

	if self.cancelCallback then
		securecallfunction(self.cancelCallback, self:GetInitialColor());
	end

	self:Hide();
end

function TRP3_ColorBrowserMixin:Update()
	local selectedColor = self:GetSelectedColor();

	self.Content.ColorSelect:SetColorRGB(selectedColor:GetRGB());
	self.Content.PreviewSwatch:SetColor(selectedColor);
	self.Content.HexInput:SetText(selectedColor:GenerateHexColorOpaque());
end

function TRP3_ColorBrowserMixin:GetInitialColor()
	return self.initialColor or TRP3.Colors.White;
end

function TRP3_ColorBrowserMixin:GetSelectedColor()
	return self.selectedColor or self:GetInitialColor();
end

function TRP3_ColorBrowserMixin:SetSelectedColor(color)
	if color == self.selectedColor then
		return;
	end

	self.selectedColor = color;
	self:Update();
end

function TRP3_ColorBrowserMixin:ResetSelectedColor()
	self:SetSelectedColor(self:GetInitialColor());
end

TRP3_ColorBrowserSwatchMixin = {};

function TRP3_ColorBrowserSwatchMixin:OnLoad()
	self.SelectedColor:SetVertexOffset(LOWER_RIGHT_VERTEX, -self.SelectedColor:GetWidth(), 0);
	self.ReadableColor:SetVertexOffset(UPPER_LEFT_VERTEX, self.ReadableColor:GetWidth(), 0);
end

function TRP3_ColorBrowserSwatchMixin:OnTooltipShow(description)
	description:AddTitleLineWithIcon(L.BW_COLOR_UNREADABLE, "services-icon-warning");
	description:AddNormalLine(L.BW_COLOR_UNREADABLE_TT);
	description:AddBlankLine();
	description:AddInstructionLine("CLICK", L.BW_COLOR_UNREADABLE_CLICK);
end

function TRP3_ColorBrowserSwatchMixin:GetColor()
	return self.color or TRP3.Colors.White;
end

function TRP3_ColorBrowserSwatchMixin:SetColor(color)
	self.color = color;
	self:Update();
end

-- For the color browser we intentionally ignore the user's configured
-- color contrast level as the intent is to pick a color that's suitable
-- for *other* people to read generally. As such, we also go one level
-- above the default (MediumLow) to try and improve the chances that our
-- suggested colors are actually broadly readable.
local COLOR_CONTRAST_BACKGROUND = TRP3.Colors.Black;
local COLOR_CONTRAST_TARGET = TRP3_ColorContrastOption.MediumLow;

function TRP3_ColorBrowserSwatchMixin:GetReadableColor()
	local foregroundColor = self:GetColor();
	local backgroundColor = COLOR_CONTRAST_BACKGROUND;
	local targetLevel = COLOR_CONTRAST_TARGET;

	return TRP3.GenerateReadableColor(foregroundColor, backgroundColor, targetLevel);
end

function TRP3_ColorBrowserSwatchMixin:IsColorReadable()
	local foregroundColor = self:GetColor();
	local backgroundColor = COLOR_CONTRAST_BACKGROUND;
	local targetLevel = COLOR_CONTRAST_TARGET;

	return TRP3.IsColorReadable(foregroundColor, backgroundColor, targetLevel);
end

function TRP3_ColorBrowserSwatchMixin:ShouldShowTooltip()
	return self:IsMouseMotionFocus() and not self:IsColorReadable();
end

function TRP3_ColorBrowserSwatchMixin:Update()
	self.SelectedColor:SetColorTexture(self:GetColor():GetRGB());
	self.ReadableColor:SetColorTexture(self:GetReadableColor():GetRGB());
	self:SetTooltipShown(self:IsMouseMotionFocus() and self:ShouldShowTooltip());
	self.ReadableColorWarningIcon:SetShown(not self:IsColorReadable());
end

TRP3_ColorBrowserHexInputMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_ColorBrowserHexInputMixin:GenerateCallbackEvents({ "OnColorInput" });

function TRP3_ColorBrowserHexInputMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);

	self.Instructions:ClearAllPoints();
	self.Instructions:SetPoint("TOPLEFT", self, "TOPLEFT", 16, 0);
	self.Instructions:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);
end

function TRP3_ColorBrowserHexInputMixin:OnShow()
	self.Instructions:SetText(L.BW_COLOR_CODE_HEX);
end

function TRP3_ColorBrowserHexInputMixin:OnChar()
	local text = string.gsub(self:GetText(), "[^A-Fa-f0-9]", "");

	self:SetText(text);
	self:UpdateInstructions();
end

function TRP3_ColorBrowserHexInputMixin:OnTextChanged(userInput)
	self:UpdateInstructions();

	if userInput then
		local color = self:GetInputColor();

		if color then
			self:TriggerEvent("OnColorInput", color);
		end
	end
end

function TRP3_ColorBrowserHexInputMixin:OnEnterPressed()
	if self:GetInputColor() then
		self:ClearFocus();
	end
end

function TRP3_ColorBrowserHexInputMixin:GetInputColor()
	local text = self:GetText();
	local color;

	-- Note that while the underlying color utilities support hex colors
	-- of either RGB[A] or RRGGBB[AA] formats, we intentionally only support
	-- RRGGBB inputs.

	if #text == 6 then
		color = TRP3.ParseColorFromHexString(text);
	end

	return color;
end

function TRP3_ColorBrowserHexInputMixin:UpdateInstructions()
	self.Instructions:SetShown(self:GetText() == "");
end
