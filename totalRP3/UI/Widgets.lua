-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
