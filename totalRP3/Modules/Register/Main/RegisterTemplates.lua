-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_RegisterSectionHeaderMixin = {};

function TRP3_RegisterSectionHeaderMixin:SetText(text)
	self.Text:SetText(text);
end

function TRP3_RegisterSectionHeaderMixin:SetIconTexture(icon)
	self.Icon:SetIconTexture(icon);
end

TRP3_RegisterTraitLineMixin = {};

function TRP3_RegisterTraitLineMixin:OnEnter()
	TRP3_API.register.togglePsychoCountText(self, true);
end

function TRP3_RegisterTraitLineMixin:OnLeave()
	TRP3_API.register.togglePsychoCountText(self, false);
end

function TRP3_RegisterTraitLineMixin:SetLeftText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.LeftText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetRightText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.RightText:SetText(text);
end

function TRP3_RegisterTraitLineMixin:SetLeftIcon(icon)
	self.LeftIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetRightIcon(icon)
	self.RightIcon:SetIconTexture(icon);
end

function TRP3_RegisterTraitLineMixin:SetLeftColor(color)
	self.LeftText:SetReadableTextColor(color);
	self.LeftText:SetFixedColor(true);
	self.Bar:SetStatusBarColor(color:GetRGBA());
end

function TRP3_RegisterTraitLineMixin:SetRightColor(color)
	self.RightText:SetReadableTextColor(color);
	self.RightText:SetFixedColor(true);
	self.Bar.OppositeFill:SetVertexColor(color:GetRGBA());
end

TRP3_RegisterColorSwatchMixin = {};

function TRP3_RegisterColorSwatchMixin:OnMouseDown(mouseButtonName)
	if mouseButtonName ~= "RightButton" then
		return;
	end

	local color = self:GetColor();

	local function OnCopyColorClicked()
		local code = "#" .. color:GenerateHexColorOpaque();
		TRP3_API.popup.showCopyDropdownPopup({ code });
	end

	local function OnSaveColorClicked()
		local function OnPopupResponse(name)
			if name == "" then
				name = TRP3_ColorPresetManager.GenerateDefaultPresetName(color);
			end

			TRP3_ColorPresetManager.SaveCustomPreset(name, color);
		end

		local prompt = string.join("|n|n", L.BW_CUSTOM_NAME, L.BW_CUSTOM_NAME_TT);
		TRP3_API.popup.showTextInputPopup(prompt, OnPopupResponse);
	end

	local function GenerateMenu(_, rootDescription)
		rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPY, TRP3_API.SetLastCopiedColor, color);
		rootDescription:CreateButton(L.REG_PLAYER_COLOR_TT_COPYNAME, OnCopyColorClicked);
		rootDescription:CreateButton(L.BW_COLOR_PRESET_SAVE_AS_CUSTOM, OnSaveColorClicked);
	end

	TRP3_MenuUtil.CreateContextMenu(self, GenerateMenu);
end

function TRP3_RegisterColorSwatchMixin:OnTooltipShow(description)
	if self.showContrastTooltip then
		description:AddNormalLine(L.REG_COLOR_SWATCH_WARNING);
		description:AddBlankLine();
		description:AddInstructionLine("RCLICK", L.REG_PLAYER_COLOR_TT_OPTIONS);
	end
end

function TRP3_RegisterColorSwatchMixin:SetShowContrastTooltip(showContrastTooltip)
	self.showContrastTooltip = showContrastTooltip;
	self:RefreshTooltip();
end

TRP3_RegisterInfoLineMixin = {};

function TRP3_RegisterInfoLineMixin:OnLoad()
	self.Value:SetFixedColor(true);
end

function TRP3_RegisterInfoLineMixin:OnSizeChanged(width)
	self.Title:SetWidth(width * 0.3);
end

function TRP3_RegisterInfoLineMixin:SetIcon(icon)
	self.Icon:SetIconTexture(icon);
end

function TRP3_RegisterInfoLineMixin:SetIconShown(shown)
	self.Icon:SetShown(shown);
	self:SetHeight(shown and 34 or 26);
end

function TRP3_RegisterInfoLineMixin:SetTitleText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Title:SetText(text);
end

function TRP3_RegisterInfoLineMixin:SetValueText(text)
	text = string.gsub(text or "", "%s+", " ");
	self.Value:SetText(text);
end

TRP3_RegisterInfoSwatchLineMixin = CreateFromMixins(TRP3_RegisterInfoLineMixin);

function TRP3_RegisterInfoSwatchLineMixin:SetValueColorFromHexString(hex)
	local color;

	if hex then
		color = TRP3_API.ParseColorFromHexString(hex);
	end

	self:SetValueColor(color);
end

function TRP3_RegisterInfoSwatchLineMixin:SetValueColor(color)
	if color then
		self.Value:SetReadableTextColor(color);
		self.Swatch:SetColor(color);
		self.Swatch:SetShowContrastTooltip(not TRP3_API.IsColorReadable(color, TRP3_PARCHMENT_BACKGROUND_COLOR));
		self.Swatch:Show();
	else
		self.Value:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
		self.Swatch:Hide();
	end
end

-- TODO: This file is on the road to getting meaty. Relocate this?
-- TODO: Do we also want to change naming convention here? ('TRP3_ProfileEditorTextInputLabelMixin', ...)
--       "Register" is shorter but the module name is stoopdid.

TRP3_RegisterTextInputLabelMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_RegisterTextInputLabelMixin:Init(initializer)
	self.title = initializer:GetTitle() or L.CM_UNKNOWN;
	self.description = initializer:GetDescription() or "";
	self.textLength = initializer:GetInitialTextLength() or 0;
	self.textLengthLimit = initializer:GetTextLengthLimit() or math.huge;
	-- TODO: Maybe make this an initializer property. If the limit is too small small then the rounding here is awkward.
	self.textLengthHint = RoundToNearestMultiple(self.textLengthLimit * 0.9, 5);

	self.Title:SetText(self.title);
	self:OnTextLengthChanged(self.textLength);
end

function TRP3_RegisterTextInputLabelMixin:OnEnter()
	TRP3_TooltipScriptMixin.OnEnter(self);
end

function TRP3_RegisterTextInputLabelMixin:OnLeave()
	TRP3_TooltipScriptMixin.OnLeave(self);
end

function TRP3_RegisterTextInputLabelMixin:OnTextLengthChanged()
	self:RefreshLetterCount();
	self:RefreshTooltip();
end

function TRP3_RegisterTextInputLabelMixin:OnTooltipShow(description)
	TRP3_TooltipTemplates.CreateBasicTooltip(description, self.title, self.description);

	if self:ShouldShowTooltipWarning() then
		description:AddBlankLine();
		-- TODO: AddSubtitleLine / AddSubtitleWithIconLine perhaps? :thinkles:
		description:AddHighlightLine(TRP3_MarkupUtil.GenerateIconMarkup("services-icon-warning", { height = 16, width = 18 }) .. " Warning");
		-- TODO: Allow configuring this in the initializer (and localize it).
		description:AddNormalLine("We strongly recommend |cnGREEN_FONT_COLOR:reducing the amount of text|r in this field as it |cnWARNING_FONT_COLOR:may not display correctly|r when viewed by other players.");
	end
end

function TRP3_RegisterTextInputLabelMixin:ShouldShowTooltipWarning()
	return self.textLength > self.textLengthLimit;
end

function TRP3_RegisterTextInputLabelMixin:ShouldShowTooltip()
	-- TODO: Do we (need to) support description-less fields? Note that the "i" icon shows even if the tooltip won't.
	return (self.description ~= "") or self:ShouldShowTooltipWarning() or self.Title:IsTruncated();
end

function TRP3_RegisterTextInputLabelMixin:SetTextLength(textLength)
	if self.textLength == textLength then
		return;
	end

	self.textLength = textLength;
	self:OnTextLengthChanged(textLength);
end

function TRP3_RegisterTextInputLabelMixin:RefreshLetterCount()
	local textLength = self.textLength;
	local textLengthLimit = self.textLengthLimit;
	local textLengthHint = self.textLengthHint;

	if textLength >= textLengthHint then
		local color = (textLength > textLengthLimit) and WARNING_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
		self.Counter:SetFormattedText("%d", (textLengthLimit - textLength));
		self.Counter:SetTextColor(color:GetRGB());
		self.Counter:Show();
	else
		self.Counter:Hide();
	end
end

TRP3_RegisterTextInputControlMixin = {};

function TRP3_RegisterTextInputControlMixin:Init(initializer)
	self.Label:Init(initializer);

	local function OnTextChanged(_, editbox, isUserInput)
		local text = editbox:GetText();
		self.Label:SetTextLength(editbox:GetNumLetters());
		initializer:InvokeTextChangedCallback(text, isUserInput);
	end

	self.Control:RegisterCallback("OnTextChanged", OnTextChanged, self);
	self.Control:SetText(initializer:GetInitialText());
end

TRP3_RegisterUtil = {};

local RegisterTextInputInitializer = {};

function RegisterTextInputInitializer:GetTitle()
	return self.title;
end

function RegisterTextInputInitializer:SetTitle(title)
	self.title = title;
end

function RegisterTextInputInitializer:GetDescription()
	return self.description;
end

function RegisterTextInputInitializer:SetDescription(description)
	self.description = description;
end

function RegisterTextInputInitializer:GetInitialText()
	return self.initialText;
end

function RegisterTextInputInitializer:GetInitialTextLength()
	return strlenutf8(self.initialText or "");
end

function RegisterTextInputInitializer:SetInitialText(initialText)
	self.initialText = initialText;
end

function RegisterTextInputInitializer:InvokeTextChangedCallback(text, isUserInput)
	if self.textChangedCallback then
		securecallfunction(self.textChangedCallback, text, isUserInput);
	end
end

function RegisterTextInputInitializer:SetTextChangedCallback(textChangedCallback)
	self.textChangedCallback = textChangedCallback;
end

function RegisterTextInputInitializer:GetTextLengthLimit()
	return self.textLengthLimit;
end

function RegisterTextInputInitializer:SetTextLengthLimit(textLengthLimit)
	self.textLengthLimit = textLengthLimit;
end

-- TODO: Some things are required, make them into parameters perhaps (it'd be silly to *not* have a title, for example).
function TRP3_RegisterUtil.CreateTextInputInitializer()
	return TRP3_API.CreateObject(RegisterTextInputInitializer);
end
