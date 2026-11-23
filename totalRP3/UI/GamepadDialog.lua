-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- A dialog drawn by a frame of our own, for use in place of Blizzard's
-- static popups while the game shows its controller interface.
--
-- With that interface shown, a static popup tells the controller's focus
-- manager that it opened and closed. For a popup shown by an addon the
-- manager does that bookkeeping while tainted, and the game then blocks its
-- own controller actions; see GamepadMenu.lua, which exists for the same
-- reason.

TRP3_GamepadDialog = {};

local DialogWidth = 360;
local Padding = 20;
local Spacing = 14;
local ButtonWidth = 130;
local ButtonHeight = 22;
local ButtonSpacing = 10;
local EditBoxWidth = 220;
local EditBoxHeight = 20;

local GamepadButton = {
	Accept = "PAD1",
	Cancel = "PAD2",
};

---@class TRP3.GamepadDialogInfo
---@field text string The text shown in the dialog.
---@field acceptText string? Text of the first button; defaults to "Okay".
---@field cancelText string? Text of the second button; it's left out if nil.
---@field hasEditBox boolean? Whether to show a text box under the text.
---@field isNumeric boolean? Whether the text box only takes a number.
---@field defaultValue (string | number)? The initial contents of the text box.
---@field validate (fun(value: string | number): boolean)? Whether the contents of the text box can be accepted.
---@field onAccept (fun(value: (string | number)?))? Called with the contents of the text box, if there is one.
---@field onCancel fun()? Called if the dialog is closed any other way.

local dialog;

local function GetEditBoxValue()
	local info = dialog.info;

	if not info or not info.hasEditBox then
		return nil;
	elseif info.isNumeric then
		return dialog.EditBox:GetNumber();
	else
		return dialog.EditBox:GetText();
	end
end

local function CanAccept()
	local info = dialog.info;

	if info and info.hasEditBox and info.validate then
		return info.validate(GetEditBoxValue()) and true or false;
	else
		return info ~= nil;
	end
end

-- The dialog is hidden before its callbacks run, as either one may show
-- another dialog.

local function Accept()
	if not CanAccept() then
		return;
	end

	local info = dialog.info;
	local value = GetEditBoxValue();

	dialog.info = nil;
	dialog:Hide();

	if info.onAccept then
		info.onAccept(value);
	end
end

local function Cancel()
	local info = dialog.info;

	if not info then
		return;
	end

	dialog.info = nil;
	dialog:Hide();

	if info.onCancel then
		info.onCancel();
	end
end

local function OnDialogHide()
	-- Hidden by something other than its own buttons, such as the Escape
	-- key closing windows.
	Cancel();
end

local function OnGamePadButtonDown(_, button)
	if button == GamepadButton.Accept then
		Accept();
	elseif button == GamepadButton.Cancel then
		if dialog.info and not dialog.info.cancelText then
			Accept();  -- A dialog with one button only has the one way out.
		else
			Cancel();
		end
	end
end

local function OnEditBoxTextChanged()
	dialog.AcceptButton:SetEnabled(CanAccept());
end

local function GetOrCreateDialog()
	if dialog then
		return dialog;
	end

	dialog = CreateFrame("Frame", "TRP3_GamepadDialogFrame", UIParent, "TooltipBackdropTemplate");
	dialog:SetFrameStrata("FULLSCREEN_DIALOG");
	dialog:SetFrameLevel(200);
	dialog:SetWidth(DialogWidth);
	dialog:SetPoint("CENTER");
	dialog:SetClampedToScreen(true);
	dialog:EnableMouse(true);
	dialog:Hide();
	dialog:SetScript("OnHide", OnDialogHide);
	dialog:SetScript("OnGamePadButtonDown", OnGamePadButtonDown);

	dialog.Text = dialog:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	dialog.Text:SetPoint("TOP", 0, -Padding);
	dialog.Text:SetWidth(DialogWidth - (Padding * 2));

	dialog.EditBox = CreateFrame("EditBox", nil, dialog, "InputBoxTemplate");
	dialog.EditBox:SetSize(EditBoxWidth, EditBoxHeight);
	dialog.EditBox:SetPoint("TOP", dialog.Text, "BOTTOM", 0, -Spacing);
	dialog.EditBox:SetAutoFocus(false);
	dialog.EditBox:SetScript("OnEnterPressed", Accept);
	dialog.EditBox:SetScript("OnEscapePressed", Cancel);
	dialog.EditBox:SetScript("OnTextChanged", OnEditBoxTextChanged);

	dialog.AcceptButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate");
	dialog.AcceptButton:SetSize(ButtonWidth, ButtonHeight);
	dialog.AcceptButton:SetScript("OnClick", Accept);

	dialog.CancelButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate");
	dialog.CancelButton:SetSize(ButtonWidth, ButtonHeight);
	dialog.CancelButton:SetPoint("BOTTOMLEFT", dialog, "BOTTOM", ButtonSpacing / 2, Padding);
	dialog.CancelButton:SetScript("OnClick", Cancel);

	-- Lets the Escape key close the dialog along with other windows.
	table.insert(UISpecialFrames, dialog:GetName());

	return dialog;
end

--- Returns true if dialogs should be shown by our own frame; this is the
--- case only while the game shows its controller interface.
function TRP3_GamepadDialog.IsEnabled()
	return TRP3_GamepadMenu.IsEnabled();
end

function TRP3_GamepadDialog.IsShown()
	return dialog ~= nil and dialog.info ~= nil;
end

--- Closes the dialog, if one is shown, as though it had been cancelled.
function TRP3_GamepadDialog.Hide()
	if dialog then
		Cancel();
	end
end

--- Shows a dialog. One that is already shown is replaced without either of
--- its callbacks being called.
---
---@param info TRP3.GamepadDialogInfo
function TRP3_GamepadDialog.Show(info)
	local frame = GetOrCreateDialog();
	local hasEditBox = info.hasEditBox and true or false;
	local hasCancelButton = (info.cancelText ~= nil);

	frame.info = nil;
	frame:Hide();

	frame.Text:SetText(info.text);
	frame.AcceptButton:SetText(info.acceptText or OKAY);
	frame.CancelButton:SetText(info.cancelText or "");
	frame.CancelButton:SetShown(hasCancelButton);
	frame.EditBox:SetShown(hasEditBox);

	frame.AcceptButton:ClearAllPoints();

	if hasCancelButton then
		frame.AcceptButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -ButtonSpacing / 2, Padding);
	else
		frame.AcceptButton:SetPoint("BOTTOM", 0, Padding);
	end

	local height = Padding + frame.Text:GetStringHeight() + Spacing + ButtonHeight + Padding;

	if hasEditBox then
		height = height + EditBoxHeight + Spacing;
	end

	frame:SetHeight(height);
	frame.info = info;

	if hasEditBox then
		frame.EditBox:SetNumeric(info.isNumeric and true or false);
		frame.EditBox:SetMaxLetters(0);
		frame.EditBox:SetText(info.defaultValue ~= nil and tostring(info.defaultValue) or "");
	end

	frame.AcceptButton:SetEnabled(CanAccept());
	frame:EnableGamePadButton(true);
	frame:Show();

	if hasEditBox then
		frame.EditBox:SetFocus();
		frame.EditBox:HighlightText();
	end
end
