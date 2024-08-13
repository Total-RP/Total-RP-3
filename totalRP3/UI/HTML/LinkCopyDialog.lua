-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_LinkCopyDialogMixin = {};

function TRP3_LinkCopyDialogMixin:OnLoad()
	self.EditBox:RegisterCallback("OnLinkCopied", self.OnLinkCopied, self);
	self.CancelButton:RegisterCallback("OnClick", self.OnCancelButtonClick, self);

	if C_Texture.GetAtlasInfo("UI-Frame-DiamondMetal-Header-CornerLeft") then
		-- DialogHeaderTemplate throws errors in certain client flavors.
		self.Header = CreateFrame("Frame", nil, self, "DialogHeaderTemplate");
	end

	if C_Texture.GetAtlasInfo("Professions-QualityWindow-Background") then
		self.Border.Bg:SetAtlas("Professions-QualityWindow-Background");
	else
		self.Border.Bg:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background]], "REPEAT", "REPEAT");
	end

	table.insert(UISpecialFrames, self:GetName());
end

function TRP3_LinkCopyDialogMixin:OnShow()
	local copy = TRP3_API.FormatShortcut("CTRL-C", TRP3_API.ShortcutType.System);
	local paste = TRP3_API.FormatShortcut("CTRL-V", TRP3_API.ShortcutType.System);

	if self.Header then
		self.Header:Setup(L.URL_COPY_TITLE);
	end

	self.InstructionText:SetText(string.format(L.URL_COPY_INSTRUCTIONS, copy, paste));
	self.WarningText:SetText(L.URL_COPY_WARNING);

	PlaySound(TRP3_InterfaceSounds.WindowOpen);
	self:Layout();
end

function TRP3_LinkCopyDialogMixin:OnHide()
	PlaySound(TRP3_InterfaceSounds.WindowClose);
end

function TRP3_LinkCopyDialogMixin:OnCancelButtonClick()
	self:Close();
end

function TRP3_LinkCopyDialogMixin:OnLinkCopied()
	-- Copying to the clipboard requires a single frame delay before the
	-- dialog is closed, as hiding the editbox on the same frame where the
	-- text is copied will result in nothing being written to the clipboard.

	local function OnTick()
		self:Close();
	end

	C_Timer.After(0, OnTick);
end

function TRP3_LinkCopyDialogMixin:Open(link)
	self.EditBox:SetLink(link);
	self:Show();

	-- These aren't in the OnShow because it's possible to open the dialog
	-- multiple times if you keep clicking links. Doing so won't re-trigger
	-- OnShow, but we want to ensure the editbox is focused every time it
	-- happens.

	self.EditBox:SetFocus();
	self:Raise();
end

function TRP3_LinkCopyDialogMixin:Close()
	self:Hide();
end

TRP3_LinkCopyDialogEditBoxMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_LinkCopyDialogEditBoxMixin:GenerateCallbackEvents({ "OnLinkCopied" });

function TRP3_LinkCopyDialogEditBoxMixin:OnChar()
	self:UpdateText();
end

function TRP3_LinkCopyDialogEditBoxMixin:OnKeyDown(key)
	if key == "C" and IsControlKeyDown() then
		UIErrorsFrame:AddMessage(L.COPY_SYSTEM_MESSAGE, YELLOW_FONT_COLOR:GetRGB());
		self:TriggerEvent("OnLinkCopied");
	end
end

function TRP3_LinkCopyDialogEditBoxMixin:SetLink(link)
	self.link = link;
	self:UpdateText();
end

function TRP3_LinkCopyDialogEditBoxMixin:UpdateText()
	self:SetText(self.link or "");
	self:HighlightText();
end
