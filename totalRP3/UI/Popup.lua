-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Public accessor
TRP3_API.popup = {};

-- imports
local Ellyb = TRP3_API.Ellyb;
local loc = TRP3_API.loc;
local initList = TRP3_API.ui.list.initList;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local getImageList, getImageListSize;
local TRP3_Enums = AddOn_TotalRP3.Enums;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups definition
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function GetDialogEditBox(dialog)
	return dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox;
end

local function GetDialogButton1(dialog)
	return dialog.GetButton1 and dialog:GetButton1() or dialog.button1;
end

local function GetDialogButton2(dialog)
	return dialog.GetButton2 and dialog:GetButton2() or dialog.button2;
end

StaticPopupDialogs["TRP3_INFO"] = {
	button1 = OKAY,
	timeout = false,
	whileDead = true,
	hideOnEscape = true
};

StaticPopupDialogs["TRP3_CONFIRM"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept();
		end
	end,
	OnCancel = function()
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel();
		end
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
};

StaticPopupDialogs["TRP3_YES_NO"] = {
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		if StaticPopupDialogs["TRP3_YES_NO"].trp3onAccept then
			StaticPopupDialogs["TRP3_YES_NO"].trp3onAccept();
		end
	end,
	OnCancel = function()
		if StaticPopupDialogs["TRP3_YES_NO"].trp3onCancel then
			StaticPopupDialogs["TRP3_YES_NO"].trp3onCancel();
		end
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

StaticPopupDialogs["TRP3_YES_NO_CUSTOM"] = {
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		if StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onAccept then
			StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onAccept();
		end
	end,
	OnCancel = function()
		if StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onCancel then
			StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onCancel();
		end
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

StaticPopupDialogs["TRP3_INPUT_TEXT"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		GetDialogEditBox(self):SetNumeric(false);
		-- Remove letters limit that other add-ons might have added but not cleaned
		GetDialogEditBox(self):SetMaxLetters(0);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept(GetDialogEditBox(self):GetText());
		end
	end,
	OnCancel = function()
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel();
		end
	end,
	EditBoxOnEnterPressed = function(self)
		StaticPopup_OnClick(self:GetParent(), GetDialogButton1(self:GetParent()):GetID());
	end,
	EditBoxOnEscapePressed = function(self)
		StaticPopup_OnClick(self:GetParent(), GetDialogButton2(self:GetParent()):GetID());
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = true,
};

StaticPopupDialogs["TRP3_INPUT_NUMBER"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		GetDialogEditBox(self):SetNumeric(true);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept(GetDialogEditBox(self):GetNumber());
		end
	end,
	OnHide = function(self)
		GetDialogEditBox(self):SetNumeric(false);
	end,
	OnCancel = function()
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel();
		end
	end,
	EditBoxOnEnterPressed = function(self)
		StaticPopup_OnClick(self:GetParent(), GetDialogButton1(self:GetParent()):GetID());
	end,
	EditBoxOnEscapePressed = function(self)
		StaticPopup_OnClick(self:GetParent(), GetDialogButton2(self:GetParent()):GetID());
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = true,
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- local POPUP_HEAD = "|TInterface\\AddOns\\totalRP3\\resources\\trp3logo:113:263|t\n \n";
local POPUP_HEAD = "Total RP 3\n \n";

-- Show a simple alert with a OK button.
function TRP3_API.popup.showAlertPopup(text)
	StaticPopupDialogs["TRP3_INFO"].text = POPUP_HEAD..text;
	local dialog = StaticPopup_Show("TRP3_INFO");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showConfirmPopup(text, onAccept, onCancel)
	text = string.gsub(text, "%%", "%%%%");
	StaticPopupDialogs["TRP3_CONFIRM"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_CONFIRM");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showYesNoPopup(text, onAccept, onCancel)
	text = string.gsub(text, "%%", "%%%%");
	StaticPopupDialogs["TRP3_YES_NO"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_YES_NO"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_YES_NO"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_YES_NO");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showCustomYesNoPopup(text, yesText, noText, onAccept, onCancel)
	text = string.gsub(text, "%%", "%%%%");
	StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].button1 = yesText;
	StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].button2 = noText;
	StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].text = text;
	StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_YES_NO_CUSTOM"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_YES_NO_CUSTOM");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showTextInputPopup(text, onAccept, onCancel, default)
	text = string.gsub(text, "%%", "%%%%");
	StaticPopupDialogs["TRP3_INPUT_TEXT"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_TEXT");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
		_G[dialog:GetName().."EditBox"]:SetText(default or "");
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

function TRP3_API.popup.showNumberInputPopup(text, onAccept, onCancel, default)
	text = string.gsub(text, "%%", "%%%%");
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_NUMBER");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
		_G[dialog:GetName().."EditBox"]:SetNumber(default or false);
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

local function GetOrCreateCopyTextPopup()
	local popup = TRP3_StaticPopUpCopyDropdown;

	if not popup then
		popup = CreateFrame("Frame", "TRP3_StaticPopUpCopyDropdown", UIParent, "TRP3_StaticPopUpCopyDropdownTemplate");
		popup.Button.Text:SetText(CLOSE);
		Ellyb.EditBoxes.makeReadOnly(popup.CopyText);
		Ellyb.EditBoxes.selectAllTextOnFocus(popup.CopyText);
		Ellyb.EditBoxes.looseFocusOnEscape(popup.CopyText);

		popup.CopyText:HookScript("OnEnterPressed",	function() popup:Hide() end);
		popup.CopyText:HookScript("OnEscapePressed", function() popup:Hide() end);
		popup.CopyText:HookScript("OnKeyDown", function(_, key)
			if key == "C" and IsControlKeyDown() then
				local systemInfo = ChatTypeInfo["SYSTEM"];
				UIErrorsFrame:AddMessage(loc.COPY_SYSTEM_MESSAGE, systemInfo.r, systemInfo.g, systemInfo.b);
				PlaySound(TRP3_InterfaceSounds.PopupClose);
				popup:Hide();
			end
		end);
	end

	return popup;
end

--- Open a popup with an autofocused text field to let the user copy the a text selected via dropdown
---@param copyTexts table The text we want to let the user copy
---@param customText string A custom text to display, instead of the default hint to copy the URL
---@param customShortcutInstructions string A custom text for the copy and paste shortcut instructions.
---@overload fun(url: string)
---@overload fun(url: string, customText: string)
function TRP3_API.popup.showCopyDropdownPopup(copyTexts, customText, customShortcutInstructions)
	if type(copyTexts) ~= "table" or #copyTexts == 0 then return end
	local popupText = customText and (customText .. "\n\n") or "";
	if not customShortcutInstructions then
		customShortcutInstructions = loc.COPY_DROPDOWN_POPUP_TEXT;
	end
	local copyShortcut = TRP3_API.FormatShortcut("CTRL-C", TRP3_API.ShortcutType.System);
	local pasteShortcut = TRP3_API.FormatShortcut("CTRL-V", TRP3_API.ShortcutType.System);

	popupText = popupText .. customShortcutInstructions:format(TRP3_API.Colors.Orange(copyShortcut), TRP3_API.Colors.Orange(pasteShortcut));
	local popup = GetOrCreateCopyTextPopup();
	popup.Text:SetText(popupText);
	popup.CopyText:SetText(copyTexts[1]);
	if #copyTexts > 1 then
		popup.DropdownButton:Show();
		local copyTextsTable = {};
		for i, text in ipairs(copyTexts) do
			copyTextsTable[i] = {text, text};
		end
		TRP3_API.ui.listbox.setupDropDownMenu(popup.DropdownButton, copyTextsTable, function(copyText)
			popup.CopyText:SetText(copyText);
			popup.CopyText:SetFocus();
			popup.CopyText:HighlightText();
		end, 0, false, false);
	else
		popup.DropdownButton:Hide();
	end
	popup:SetHeight(120 + popup.Text:GetHeight());
	popup:Show();
	popup.CopyText:SetFocus();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Dynamic popup
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_PopupsFrame = TRP3_PopupsFrame;

local function showPopup(popup)
	for _, frame in pairs({TRP3_PopupsFrame:GetChildren()}) do
		frame:Hide();
	end
	TRP3_PopupsFrame:Show();
	popup:Show();
end

local function hidePopups()
	TRP3_PopupsFrame:Hide();
end
TRP3_API.popup.hidePopups = hidePopups;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function showIconBrowser(onSelectCallback, onCancelCallback, scale, selectedIcon)
	local function OnAccept(iconInfo)
		hidePopups();

		if onSelectCallback then
			onSelectCallback(iconInfo.name, iconInfo);
		end
	end

	local function OnCancel()
		hidePopups();

		if onCancelCallback then
			onCancelCallback();
		end
	end

	TRP3_IconBrowser.Open({
		onAcceptCallback = OnAccept,
		onCancelCallback = OnCancel,
		scale = scale,
		selectedIcon = selectedIcon,
	});
end

function TRP3_API.popup.hideIconBrowser()
	TRP3_IconBrowser.Close();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Background browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function ShowBackgroundBrowser(onSelectCallback, onCancelCallback, scale, selectedImageID)
	local function OnAccept(imageInfo)
		hidePopups();

		if onSelectCallback then
			onSelectCallback(imageInfo);
		end
	end

	local function OnCancel()
		hidePopups();

		if onCancelCallback then
			onCancelCallback();
		end
	end

	TRP3_BackgroundBrowser.Open({
		onAcceptCallback = OnAccept,
		onCancelCallback = OnCancel,
		scale = scale,
		selectedImage = selectedImageID,
	});
end

function TRP3_API.popup.ShowBackgroundBrowser(callback, selectedImageID)
	TRP3_API.popup.showPopup(TRP3_API.popup.BACKGROUNDS, nil, {callback, nil, nil, selectedImageID});
end;

function TRP3_API.popup.HideBackgroundBrowser()
	TRP3_BackgroundBrowser.Close();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_CompanionBrowserButtonMixin = {};

function TRP3_CompanionBrowserButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TRP3_CompanionBrowserButtonMixin:OnEnter()
	TRP3_RefreshTooltipForFrame(self);
end

function TRP3_CompanionBrowserButtonMixin:OnLeave()
	TRP3_MainTooltip:Hide();
end

local TRP3_CompanionBrowser = TRP3_CompanionBrowser;
local companionWidgetTab = {};
local filteredCompanionList = {};
local ui_CompanionBrowserContent = TRP3_CompanionBrowserContent;
local currentCompanionType;

local function onCompanionClick(button)
	TRP3_CompanionBrowser:Hide();
	hidePopups();
	if ui_CompanionBrowserContent.onSelectCallback then
		ui_CompanionBrowserContent.onSelectCallback(filteredCompanionList[button.index], currentCompanionType, button);
	end
end

local function onCompanionClose()
	TRP3_CompanionBrowser:Hide();
	hidePopups();
	if ui_CompanionBrowserContent.onCancelCallback then
		ui_CompanionBrowserContent.onCancelCallback();
	end
end

local function decorateCompanion(button, index)
	local name, icon = filteredCompanionList[index][1], filteredCompanionList[index][2];
	local description, speciesName = filteredCompanionList[index][3], filteredCompanionList[index][4];
	button:SetNormalTexture(icon);
	button:SetPushedTexture(icon);
	local text = "|cnGREEN_FONT_COLOR:" .. speciesName .. "|r";
	if description and description:len() > 0 then
		text = text .. "\n\"" .. description .. "\"";
	end

	local tooltipTitle = "|T" .. icon .. ":40|t " .. name;
	local tooltipText = text;

	-- For Retail clients we strongly recommend that battle pets be renamed
	-- to be bound, but this is only possible there and not in Classic.

	if TRP3_CompanionUtil.CanRenameCompanionPets() and (name == speciesName) then
		button.RenameWarning:Show();
		tooltipText = tooltipText .. "|n|n" .. TRP3_API.loc.UI_COMPANION_BROWSER_RENAME_WARNING;
	else
		button.RenameWarning:Hide();
	end

	TRP3_API.ui.tooltip.setTooltipAll(button, "RIGHT", 0, 0, tooltipTitle, tooltipText);
	button.index = index;
end

local function nameComparator(elem1, elem2)
	return elem1[1] < elem2[1];
end

local function SearchFilterPredicate(value, filter)
	if type(value) ~= "string" then
		return false;
	end

	value = string.lower(string.trim(value));
	filter = string.lower(string.trim(filter));

	return filter == "" or (not not string.find(value, filter, 1, true));
end

local function CollectBattlePets(filter)
	local uniquePetNames = {};
	local battlePets = {};

	for _, petInfo in TRP3_CompanionUtil.EnumerateCompanionPets() do
		if not uniquePetNames[petInfo.name] and SearchFilterPredicate(petInfo.name, filter) then
			uniquePetNames[petInfo.name] = true;
			table.insert(battlePets, { petInfo.name, petInfo.icon, petInfo.description, petInfo.speciesName });
		end
	end

	return battlePets;
end

local function BattlePetNameComparator(a, b)
	local customNameA = a[1]
	local customNameB = b[1]
	local isRenamedA = customNameA ~= a[4]
	local isRenamedB = customNameB ~= b[4]

	if isRenamedA ~= isRenamedB then
		return isRenamedA;
	else
		return strcmputf8i(customNameA, customNameB) < 0;
	end
end

local function getWoWCompanionFilteredList(filter)
	local count = 0;
	wipe(filteredCompanionList);

	if currentCompanionType == TRP3_Enums.UNIT_TYPE.BATTLE_PET then
		-- Battle pets
		Mixin(filteredCompanionList, CollectBattlePets(filter));
		count = #filteredCompanionList;
		table.sort(filteredCompanionList, BattlePetNameComparator);
	elseif currentCompanionType == TRP3_Enums.UNIT_TYPE.MOUNT then
		-- Mounts
		for _, mountInfo in TRP3_CompanionUtil.EnumerateMounts() do
			-- The not-false check here is intended to allow mounts that we've
			-- either definitely collected (true) or mounts whose collection
			-- state is indeterminate (nil).
			if mountInfo.isCollected ~= false and SearchFilterPredicate(mountInfo.name, filter) then
				tinsert(filteredCompanionList, {mountInfo.name, mountInfo.icon, mountInfo.description, loc.PR_CO_MOUNT, mountInfo.spellID, mountInfo.id});
				count = count + 1;
			end
		end
		table.sort(filteredCompanionList, nameComparator);
	end


	return count;
end

local function filteredCompanionBrowser()
	local filter = TRP3_CompanionBrowserFilterBox:GetText();
	local totalCompanionCount = getWoWCompanionFilteredList(filter);
	TRP3_CompanionBrowserTotal:SetText(string.format(GENERIC_FRACTION_STRING, #filteredCompanionList, totalCompanionCount));
	initList(
		{
			widgetTab = companionWidgetTab,
			decorate = decorateCompanion
		},
		filteredCompanionList,
		TRP3_CompanionBrowserContentSlider
	);
end

local function initCompanionBrowser()
	handleMouseWheel(ui_CompanionBrowserContent, TRP3_CompanionBrowserContentSlider);
	TRP3_CompanionBrowserContentSlider:SetValue(0);
	-- Create icons

	for row = 0, 5 do
		for column = 0, 7 do
			local button = CreateFrame("Button", "TRP3_CompanionBrowserButton_"..row.."_"..column, ui_CompanionBrowserContent, "TRP3_CompanionBrowserButtonTemplate");
			button:ClearAllPoints();
			button:SetPoint("TOPLEFT", ui_CompanionBrowserContent, "TOPLEFT", 15 + (column * 45), -15 + (row * (-45)));
			button:SetScript("OnClick", onCompanionClick);
			tinsert(companionWidgetTab, button);
		end
	end

	TRP3_CompanionBrowserFilterBox:SetScript("OnTextChanged", filteredCompanionBrowser);
	TRP3_CompanionBrowserClose:SetScript("OnClick", onCompanionClose);

	TRP3_CompanionBrowserFilterBoxText:SetText(loc.UI_FILTER);
end

function TRP3_API.popup.showCompanionBrowser(onSelectCallback, onCancelCallback, companionType)
	currentCompanionType = companionType or TRP3_Enums.UNIT_TYPE.BATTLE_PET;
	if currentCompanionType == TRP3_Enums.UNIT_TYPE.BATTLE_PET then
		TRP3_CompanionBrowserTitle:SetText(loc.REG_COMPANION_BROWSER_BATTLE);
	else
		TRP3_CompanionBrowserTitle:SetText(loc.REG_COMPANION_BROWSER_MOUNT);
	end

	ui_CompanionBrowserContent.onSelectCallback = onSelectCallback;
	ui_CompanionBrowserContent.onCancelCallback = onCancelCallback;

	local frame = TRP3_CompanionBrowser;
	frame:SetScript("OnKeyDown", function(_, key)
		-- Do not steal input if we're in combat.
		if InCombatLockdown() then return; end

		if key == "ESCAPE" then
			PlaySound(TRP3_InterfaceSounds.PopupClose);
			frame:SetPropagateKeyboardInput(false);
			-- Hiding frames & Cancel callback is handled within.
			onCompanionClose();
		else
			frame:SetPropagateKeyboardInput(true);
		end
	end);

	TRP3_CompanionBrowserFilterBox:SetText("");
	filteredCompanionBrowser();
	showPopup(TRP3_CompanionBrowser);
	TRP3_CompanionBrowserFilterBox:SetFocus();
end

function TRP3_API.popup.showPetBrowser(profileID, onSelectCallback, onCancelCallback)
	local frame = AddOn_TotalRP3.Ui.GetPetBrowserFrame();
	if not frame then
		return;
	end

	onSelectCallback = onSelectCallback or nop;
	onCancelCallback = onCancelCallback or nop;

	frame:SetScript("OnKeyDown", function(_, key)
		-- Do not steal input if we're in combat.
		if InCombatLockdown() then return; end

		if key == "ESCAPE" then
			PlaySound(TRP3_InterfaceSounds.PopupClose);
			frame:SetPropagateKeyboardInput(false);
			frame:Hide();
			hidePopups();
			-- Handle cancel callback through function.
			onCancelCallback();
		else
			frame:SetPropagateKeyboardInput(true);
		end
	end);

	frame:SetDialogProfileID(profileID);
	frame:SetDialogCallback(function(result, ...)
		hidePopups();

		if result == frame.DialogResult.Accept then
			onSelectCallback(...);
		else
			onCancelCallback();
		end
	end);

	showPopup(frame);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Color browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function ShowColorBrowser(callback, r8, g8, b8)
	local function OnAccept(color)
		TRP3_API.popup.hidePopups();
		callback(color:GetRGBAsBytes());
	end

	local function OnCancel()
		TRP3_API.popup.hidePopups();
	end

	local initialColor = TRP3_API.CreateColorFromBytes(r8 or 255, g8 or 255, b8 or 255);
	TRP3_ColorBrowser:Open(initialColor, OnAccept, OnCancel);
end

function TRP3_API.popup.showDefaultColorPicker(popupArgs)
	local setColor, r, g, b = unpack(popupArgs);

	local function OnColorChanged()
		local newR, newG, newB = ColorPickerFrame:GetColorRGB();
		setColor(newR * 255, newG * 255, newB * 255);
	end

	local function OnCancel()
		setColor(r, g, b);
	end

	-- For the swatchFunc and opacityFunc callbacks we debounce changes; these
	-- fire rapidly so long as the user has the mouse held over the color
	-- wheel or opacity slider. Debouncing means that we won't apply the color
	-- change until the user stops changing things for 0.1s.

	local options = {
		swatchFunc = TRP3_FunctionUtil.Debounce(0.1, OnColorChanged),
		opacityFunc = TRP3_FunctionUtil.Debounce(0.1, OnColorChanged),
		cancelFunc = OnCancel,
		hasOpacity = false,
		r = (r or 255) / 255,
		g = (g or 255) / 255,
		b = (b or 255) / 255,
	};

	if ColorPickerFrame.SetupColorPickerAndShow then
		ColorPickerFrame:SetupColorPickerAndShow(options);
	else
		ColorPickerFrame.func = options.swatchFunc;
		ColorPickerFrame.hasOpacity = options.hasOpacity;
		ColorPickerFrame.opacity = options.opacity;
		ColorPickerFrame.opacityFunc = options.opacityFunc;
		ColorPickerFrame.cancelFunc = options.cancelFunc;
		ColorPickerFrame:SetColorRGB(options.r, options.g, options.b);
		ShowUIPanel(ColorPickerFrame);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Image browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local imageWidgetTab = {};
local filteredImageList = {};
local TRP3_ImageBrowser = TRP3_ImageBrowser;

local function onImageSelect()
	assert(TRP3_ImageBrowserContent.currentImage, "No current image ...");
	hidePopups();
	TRP3_ImageBrowser:Hide();
	if TRP3_ImageBrowser.callback then
		TRP3_ImageBrowser.callback(filteredImageList[TRP3_ImageBrowserContent.currentImage]);
	end
end

local function decorateImage(texture, index)
	local image = filteredImageList[index];
	local ratio = image.height / image.width;
	local maxSize = math.max(texture:GetHeight(), texture:GetWidth());
	if ratio > 1 then
		texture:SetHeight(maxSize);
		texture:SetWidth(texture:GetHeight() / ratio);
	else
		texture:SetWidth(maxSize);
		texture:SetHeight(texture:GetWidth() * ratio);
	end
	texture:SetTexture(image.url);
	TRP3_ImageBrowserContentURL:SetText(image.url:sub(11));
	TRP3_ImageBrowserContent.currentImage = index;
end

local function filteredImageBrowser()
	local filter = TRP3_ImageBrowserFilterBox:GetText();
	filteredImageList = getImageList(filter);
	local size = #filteredImageList;
	TRP3_ImageBrowserTotal:SetText(string.format(GENERIC_FRACTION_STRING, size, getImageListSize()));
	if size > 0 then
		TRP3_ImageBrowserSelect:Enable();
	else
		TRP3_ImageBrowserSelect:Disable();
	end
	initList(
		{
			widgetTab = imageWidgetTab,
			decorate = decorateImage
		},
		filteredImageList,
		TRP3_ImageBrowserContentSlider
	);
end

local function initImageBrowser()
	handleMouseWheel(TRP3_ImageBrowserContent, TRP3_ImageBrowserContentSlider);
	TRP3_ImageBrowserContentSlider:SetValue(0);
	TRP3_ImageBrowserFilterBox:SetScript("OnTextChanged", filteredImageBrowser);
	TRP3_ImageBrowserSelect:SetScript("OnClick", onImageSelect);

	tinsert(imageWidgetTab, TRP3_ImageBrowserContentTexture);

	TRP3_ImageBrowserTitle:SetText(loc.UI_IMAGE_BROWSER);
	TRP3_ImageBrowserFilterBoxText:SetText(loc.UI_FILTER);
	TRP3_ImageBrowserSelect:SetText(loc.UI_IMAGE_SELECT);
	filteredImageBrowser();
end

local function showImageBrowser(callback)
	TRP3_ImageBrowser.callback = callback;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.popup.init()
	getImageList, getImageListSize = TRP3_API.utils.resources.getImageList, TRP3_API.utils.resources.getImageListSize;

	initCompanionBrowser();
	initImageBrowser();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- POPUP REFACTOR
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tostring, type, unpack = tostring, type, unpack;

TRP3_API.popup.IMAGES = "images";
TRP3_API.popup.ICONS = "icons";
TRP3_API.popup.COLORS = "colors";
TRP3_API.popup.MUSICS = "musics";
TRP3_API.popup.COMPANIONS = "companions";
TRP3_API.popup.PETS = "pets";
TRP3_API.popup.BACKGROUNDS = "backgrounds";

local POPUP_STRUCTURE = {
	[TRP3_API.popup.IMAGES] = {
		frame = TRP3_ImageBrowser,
		showMethod = showImageBrowser,
	},
	[TRP3_API.popup.COLORS] = {
		frame = TRP3_ColorBrowser,
		disableCloseOnEscape = true,  -- Handled by the browser itself.
		showMethod = ShowColorBrowser,
	},
	[TRP3_API.popup.ICONS] = {
		frame = TRP3_IconBrowserFrame,
		showMethod = showIconBrowser,
	},
	[TRP3_API.popup.MUSICS] = {
		frame = TRP3_MusicBrowser,
		showMethod = function(callback) TRP3_MusicBrowser:Open(callback) end,
	},
	[TRP3_API.popup.COMPANIONS] = {
		frame = TRP3_CompanionBrowser,
		showMethod = TRP3_API.popup.showCompanionBrowser,
	},
	[TRP3_API.popup.PETS] = AddOn_TotalRP3.Ui.IsPetBrowserEnabled() and {
		frame = AddOn_TotalRP3.Ui.GetPetBrowserFrame(),
		showMethod = TRP3_API.popup.showPetBrowser,
	} or nil,
	[TRP3_API.popup.BACKGROUNDS] = {
		frame = TRP3_BackgroundBrowserFrame,
		showMethod = ShowBackgroundBrowser,
	},
}
TRP3_API.popup.POPUPS = POPUP_STRUCTURE;

function TRP3_API.popup.showPopup(popupID, popupPosition, popupArgs)
	assert(popupID and POPUP_STRUCTURE[popupID], "Unknown popupID: " .. tostring(popupID));
	assert(popupPosition == nil or type(popupPosition) == "table", "PopupPosition must be a table or be nil");
	assert(popupArgs == nil or type(popupArgs) == "table", "PopupArgs must be a table or be nil");

	local popup = POPUP_STRUCTURE[popupID];

	popup.frame:ClearAllPoints();

	if not popup.disableCloseOnEscape then
		popup.frame:HookScript("OnKeyDown", function(_, key)
			-- Do not steal input if we're in combat.
			if InCombatLockdown() then return; end

			if key == "ESCAPE" then
				PlaySound(TRP3_InterfaceSounds.PopupClose);
				popup.frame:SetPropagateKeyboardInput(false);
				hidePopups();
			else
				popup.frame:SetPropagateKeyboardInput(true);
			end
		end);
	end

	if popupPosition and popupPosition.parent then
		popup.frame:SetParent(popupPosition.parent);
		popup.frame:SetPoint(popupPosition.point or "CENTER", popupPosition.parent, popupPosition.parentPoint or "CENTER", 0, 0);
		popup.frame:SetFrameLevel(popupPosition.parent:GetFrameLevel() + 20);
		popup.frame:Show();
	else
		popup.frame:SetParent(TRP3_PopupsFrame);
		popup.frame:SetPoint("CENTER", 0, 0);
		for _, frame in pairs({TRP3_PopupsFrame:GetChildren()}) do
			frame:Hide();
		end
		TRP3_PopupsFrame:Show();
		popup.frame:Show();
	end

	if popup.showMethod then
		popup.showMethod(unpack(popupArgs));
	end

end
