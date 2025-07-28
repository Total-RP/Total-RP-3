-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_TooltipMixin = {};

function TRP3_TooltipMixin:SetCenterColor(r, g, b, a)
	self.NineSlice:SetCenterColor(r, g, b, a or 1);
end

function TRP3_TooltipMixin:SetBorderColor(r, g, b, a)
	self.NineSlice:SetBorderColor(r, g, b, a or 1);
end

TRP3_TextAreaBaseMixin = {};

function TRP3_TextAreaBaseMixin:OnLoad()
	local editbox = self:GetEditBox();
	editbox:RegisterCallback("OnEditFocusGained", self.OnEditFocusGained, self);
	editbox:RegisterCallback("OnEditFocusGained", self.OnEditFocusLost, self);
end

function TRP3_TextAreaBaseMixin:OnShow()
	self:UpdateLayout();
end

function TRP3_TextAreaBaseMixin:OnSizeChanged()
	self:UpdateLayout();
end

function TRP3_TextAreaBaseMixin:OnEditFocusGained()
	local focus = self:GetFocusFrame();
	focus:Hide();
end

function TRP3_TextAreaBaseMixin:OnEditFocusLost()
	local focus = self:GetFocusFrame();
	focus:Show();
end

function TRP3_TextAreaBaseMixin:GetEditBox()
	return self.scroll.text;
end

function TRP3_TextAreaBaseMixin:GetFocusFrame()
	return self.dummy;
end

function TRP3_TextAreaBaseMixin:UpdateLayout()
	local editbox = self:GetEditBox();
	editbox:SetWidth(self:GetWidth() - 40);
end

TRP3_TextAreaBaseEditBoxMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_TextAreaBaseEditBoxMixin:GenerateCallbackEvents({
	"OnEditFocusGained",
	"OnEditFocusLost",
});

function TRP3_TextAreaBaseEditBoxMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	ScrollingEdit_OnLoad(self);
end

function TRP3_TextAreaBaseEditBoxMixin:OnCursorChanged(x, y, w, h)
	ScrollingEdit_OnCursorChanged(self, x, y, w, h);
end

function TRP3_TextAreaBaseEditBoxMixin:OnTextChanged()
	ScrollingEdit_OnTextChanged(self, self:GetScrollFrame());
end

function TRP3_TextAreaBaseEditBoxMixin:OnEscapePressed()
	self:ClearFocus();
end

function TRP3_TextAreaBaseEditBoxMixin:OnEditFocusGained()
	self:TriggerEvent("OnEditFocusGained", self);
end

function TRP3_TextAreaBaseEditBoxMixin:OnEditFocusLost()
	self:HighlightText(0, 0);
	self:TriggerEvent("OnEditFocusLost", self);
end

function TRP3_TextAreaBaseEditBoxMixin:GetScrollFrame()
	return self:GetParent();
end

TRP3_CategoryButtonMixin = {};

function TRP3_CategoryButtonMixin:OnLoad()
end

function TRP3_CategoryButtonMixin:OnEnter()
	if self.Text:IsTruncated() then
		TRP3_TooltipTemplates.ShowTruncationTooltip(self, self:GetText());
	end
end

function TRP3_CategoryButtonMixin:OnLeave()
	TRP3_TooltipUtil.HideTooltip(self);
end

function TRP3_CategoryButtonMixin:SetCloseCallback(callback)
	self.CloseButton:SetScript("OnClick", function() callback(); end);
	self.CloseButton:SetShown(callback ~= nil);
end

function TRP3_CategoryButtonMixin:SetJustifyH(justifyH)
	self.Text:SetJustifyH(justifyH);
end

function TRP3_CategoryButtonMixin:SetIcon(icon)
	if icon then
		if C_Texture.GetAtlasInfo(icon) then
			local useAtlasSize = false;
			self.Icon:SetAtlas(icon, useAtlasSize);
		else
			self.Icon:SetTexture(icon);
		end

		self.Text:SetPoint("LEFT", 28, 0);
		self.Icon:Show();
	else
		self.Text:SetPoint("LEFT", 12, 0);
		self.Icon:Hide();
	end
end

function TRP3_CategoryButtonMixin:SetSelected(selected)
	self:SetEnabled(not selected);
end

TRP3_RedButtonMixin = {};

function TRP3_RedButtonMixin:OnShow()
	self:UpdateVisualState();
end

function TRP3_RedButtonMixin:OnDisable()
	self:UpdateVisualState();
end

function TRP3_RedButtonMixin:OnEnable()
	self:UpdateVisualState();
end

function TRP3_RedButtonMixin:OnMouseDown()
	self:UpdateVisualState("PUSHED");
end

function TRP3_RedButtonMixin:OnMouseUp()
	self:UpdateVisualState("NORMAL");
end

function TRP3_RedButtonMixin:UpdateVisualState(overrideState)
	local state = overrideState or self:GetButtonState();

	if not self:IsEnabled() then
		state = "DISABLED";
	end

	local suffix = "";

	if state == "DISABLED" then
		suffix = "-Disabled";
	elseif state == "PUSHED" then
		suffix = "-Pressed";
	end

	local useAtlasSize = false;

	if C_Texture.GetAtlasInfo("_128-RedButton-Center" .. suffix) then
		-- Retail atlases.
		self.EdgeLeft:SetAtlas("128-RedButton-Left" .. suffix, useAtlasSize);
		self.EdgeLeft:SetWidth(26);
		self.EdgeRight:SetAtlas("128-RedButton-Right" .. suffix, useAtlasSize);
		self.EdgeRight:SetWidth(68);
		self.Center:SetAtlas("_128-RedButton-Center" .. suffix, useAtlasSize);
	else
		-- Classic atlases.
		self.EdgeLeft:SetAtlas("128-RedButton-LeftCorner" .. suffix, useAtlasSize);
		self.EdgeLeft:SetWidth(68);
		self.EdgeRight:SetAtlas("128-RedButton-RightCorner" .. suffix, useAtlasSize);
		self.EdgeRight:SetWidth(26);
		self.Center:SetAtlas("_128-RedButton-Tile" .. suffix, useAtlasSize);
	end
end


local g_lastCopiedIcon;

--- TRP3_API.SetLastCopiedIcon sets the last copied icon.
---@param icon string Contains the name of the icon to be copied.
function TRP3_API.SetLastCopiedIcon(icon)
	g_lastCopiedIcon = icon;
end

--- TRP3_API.GetLastCopiedIcon gets the last copied icon.
---@return string icon Contains the name of the last icon that was copied.
function TRP3_API.GetLastCopiedIcon()
	return g_lastCopiedIcon;
end

local g_lastCopiedColor;

--- TRP3_API.SetLastCopiedColor sets the last copied color.
---@param color string|table Contains the color to be copied.
function TRP3_API.SetLastCopiedColor(color)
	g_lastCopiedColor = color;
end

--- TRP3_API.GetLastCopiedColor gets the last copied color.
---@return string|table color Contains the last color that was copied.
function TRP3_API.GetLastCopiedColor()
	return g_lastCopiedColor;
end

TRP3_ColorPickerButtonMixin = {};

function TRP3_ColorPickerButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	self.setColor = function(red, green, blue)
		self.red = red;
		self.green = green;
		self.blue = blue;
		if red and green and blue then
			self.SwatchBg:SetColorTexture(red / 255, green / 255, blue / 255);
			self.SwatchBgHighlight:SetVertexColor(red / 255, green / 255, blue / 255);
		else
			self.SwatchBg:SetTexture([[interface\icons\]] .. TRP3_InterfaceIcons.Gears);
			self.SwatchBgHighlight:SetVertexColor(1.0, 1.0, 1.0);
		end
		if self.onSelection then
			self.onSelection(red, green, blue);
		end
		self.Blink.Animate:Play();
		self.Blink.Animate:Finish();
	end
	self.setColor();
end

function TRP3_ColorPickerButtonMixin:OnEnter()
	TRP3_RefreshTooltipForFrame(self);
end

function TRP3_ColorPickerButtonMixin:OnLeave()
	TRP3_MainTooltip:Hide();
end

function TRP3_ColorPickerButtonMixin:PostClick()
	PlaySound(TRP3_InterfaceSounds.ButtonClick);
end

function TRP3_ColorPickerButtonMixin:OnClick(mouseButtonName)
	if mouseButtonName ~= "LeftButton" and mouseButtonName ~= "RightButton" then
		return;
	end

	local hexa;
	if self.red then
		hexa = TRP3_API.CreateColorFromBytes(self.red, self.green, self.blue):GenerateHexColorOpaque();
	end

	local function OnCopyColorClicked()
		local code = "#" .. hexa;
		TRP3_API.popup.showCopyDropdownPopup({ code });
	end

	local function OnPasteColorClicked()
		local color = TRP3_API.GetLastCopiedColor() or nil;
		local colorObject = type(color) == "table" and TRP3_API.CreateColorFromTable(color) or TRP3_API.CreateColorFromHexString(color);
		self.setColor(colorObject:GetRGBAsBytes());
	end

	local function GenerateMenu(_, rootDescription)
		local copyButton = rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPY, TRP3_API.SetLastCopiedColor, hexa);
		copyButton:SetEnabled(hexa ~= nil);

		local copyNameButton = rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPYNAME, OnCopyColorClicked);
		copyNameButton:SetEnabled(hexa ~= nil);

		local pasteButton = rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_PASTE, OnPasteColorClicked);
		pasteButton:SetEnabled(TRP3_API.GetLastCopiedColor() ~= nil);

		if hexa then
			rootDescription:CreateButton("|cnRED_FONT_COLOR:" .. L.REG_PLAYER_COLOR_TT_DISCARD .. "|r", function() self.setColor(nil, nil, nil); end);
		end
	end

	if mouseButtonName == "LeftButton" then
		if IsShiftKeyDown() or (TRP3_API.configuration.getValue("default_color_picker")) then
			TRP3_API.popup.showDefaultColorPicker({self.setColor, self.red, self.green, self.blue});
		else
			TRP3_API.popup.showPopup(TRP3_API.popup.COLORS, nil, {self.setColor, self.red, self.green, self.blue});
		end
	elseif mouseButtonName == "RightButton" then
		TRP3_MenuUtil.CreateContextMenu(self, GenerateMenu);
	end
end

TRP3_ReadOnlyEditBoxMixin = {};

function TRP3_ReadOnlyEditBoxMixin:OnChar(char)
	local readOnlyText = self:GetReadOnlyText();

	if readOnlyText ~= nil then
		local cursorPosition = self:GetUTF8CursorPosition();
		self:RestoreReadOnlyText();
		self:SetCursorPosition(cursorPosition - strlenutf8(char));
	end
end

function TRP3_ReadOnlyEditBoxMixin:GetReadOnlyText()
	return self.readOnlyText;
end

function TRP3_ReadOnlyEditBoxMixin:SetReadOnlyText(text)
	self.readOnlyText = text;
	self:RestoreReadOnlyText();
end

function TRP3_ReadOnlyEditBoxMixin:ClearReadOnlyText()
	self:SetReadOnlyText(nil);
end

function TRP3_ReadOnlyEditBoxMixin:RestoreReadOnlyText()
	self:SetText(self.readOnlyText);
end

TRP3_FocusHighlightEditBoxMixin = {};

function TRP3_FocusHighlightEditBoxMixin:OnEditFocusGained()
	self:HighlightText();
end

function TRP3_FocusHighlightEditBoxMixin:OnEditFocusLost()
	self:HighlightText(0, 0);
end

TRP3_EscapeSanitizedEditBoxMixin = {};

local function GetEditBoxTextUnhooked(editBox)
	return GetEditBoxMetatable().__index.GetText(editBox);
end

local function SetEditBoxTextUnhooked(editBox, text)
	return GetEditBoxMetatable().__index.SetText(editBox, text);
end

function TRP3_EscapeSanitizedEditBoxMixin:GetText()
	return (string.gsub(GetEditBoxTextUnhooked(self), "||", "|"));
end

function TRP3_EscapeSanitizedEditBoxMixin:SetText(text)
	SetEditBoxTextUnhooked(self, (string.gsub(text, "|", "||")));
end
