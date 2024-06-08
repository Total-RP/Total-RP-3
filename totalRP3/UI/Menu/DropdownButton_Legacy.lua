-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

if TRP3_USE_MODERN_MENUS then
	return;
end

function TRP3_DropdownButtonMixin:OnLoad()
	self:SetHitRectInsets(4, 4, 2, 2);
	self:SetMouseMotionEnabled(true);
	self:SetMouseClickEnabled(true);

	self.Left = self:CreateTexture(nil, "ARTWORK");
	self.Left:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	self.Left:SetTexCoord(0, 0.1953125, 0, 1);
	self.Left:SetSize(25, 64);
	self.Left:SetPoint("TOPLEFT", -16, 17);

	self.Right = self:CreateTexture(nil, "ARTWORK");
	self.Right:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	self.Right:SetTexCoord(0.8046875, 1, 0, 1);
	self.Right:SetSize(25, 64);
	self.Right:SetPoint("TOPRIGHT", 18, 17);

	self.Middle = self:CreateTexture(nil, "ARTWORK");
	self.Middle:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	self.Middle:SetTexCoord(0.1953125, 0.8046875, 0, 1);
	self.Middle:SetSize(115, 64);
	self.Middle:SetPoint("LEFT", self.Left, "RIGHT");
	self.Middle:SetPoint("RIGHT", self.Right, "LEFT");

	self.Text = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	self.Text:SetWordWrap(false);
	self.Text:SetJustifyH("RIGHT");
	self.Text:SetPoint("LEFT", self.Left, "LEFT", 27, 2);
	self.Text:SetPoint("RIGHT", self.Right, "RIGHT", -43, 2);

	self.Icon = self:CreateTexture(nil, "OVERLAY");
	self.Icon:SetShown(false);
	self.Icon:SetSize(16, 16);
	self.Icon:SetPoint("LEFT", 30, 2);

	-- This is a button purely for tax reasons. We make it non-interactive
	-- and instead rely on its parent region to handle all interactions.
	self.Button = CreateFrame("Button", nil, self);
	self.Button:SetSize(24, 24);
	self.Button:SetPoint("TOPRIGHT", self.Right, "TOPRIGHT", -16, -19);
	self.Button:SetMouseClickEnabled(false);
	self.Button:SetMouseMotionEnabled(false);
	self.Button:RegisterForClicks();
	self.Button:RegisterForMouse();

	self.Button.NormalTexture = self.Button:CreateTexture(nil, "ARTWORK");
	self.Button.NormalTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]]);
	self.Button.NormalTexture:SetSize(24, 24);
	self.Button.NormalTexture:SetPoint("RIGHT");
	self.Button:SetNormalTexture(self.Button.NormalTexture);

	self.Button.PushedTexture = self.Button:CreateTexture(nil, "ARTWORK");
	self.Button.PushedTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]]);
	self.Button.PushedTexture:SetSize(24, 24);
	self.Button.PushedTexture:SetPoint("RIGHT");
	self.Button:SetPushedTexture(self.Button.PushedTexture);

	self.Button.DisabledTexture = self.Button:CreateTexture(nil, "ARTWORK");
	self.Button.DisabledTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]]);
	self.Button.DisabledTexture:SetSize(24, 24);
	self.Button.DisabledTexture:SetPoint("RIGHT");
	self.Button:SetDisabledTexture(self.Button.DisabledTexture);

	self.Button.HighlightTexture = self.Button:CreateTexture(nil, "ARTWORK");
	self.Button.HighlightTexture:SetTexture([[Interface\Buttons\UI-Common-MouseHilight]]);
	self.Button.HighlightTexture:SetBlendMode("ADD");
	self.Button.HighlightTexture:SetSize(24, 24);
	self.Button.HighlightTexture:SetPoint("RIGHT");
	self.Button:SetHighlightTexture(self.Button.HighlightTexture);

	self.defaultText = nil;
	self.menuGenerator = nil;
	self.menuDescription = nil;
	self.menuAnchor = nil;

	local anchor = AnchorUtil.CreateAnchor(self.menuPoint, self, self.menuRelativePoint, self.menuPointX, self.menuPointY);
	self:SetMenuAnchor(anchor);
end

function TRP3_DropdownButtonMixin:OnShow()
	self:Update();
end

function TRP3_DropdownButtonMixin:OnHide()
	self:CloseMenu();
end

function TRP3_DropdownButtonMixin:OnEnter()
	if self.Text:IsTruncated() then
		local function Initialize(tooltip)
			GameTooltip_SetTitle(tooltip, self.Text:GetText());
		end

		TRP3_MenuUtil.ShowTooltip(self, Initialize);
	end

	self.Button:SetHighlightLocked(self:IsEnabled());
end

function TRP3_DropdownButtonMixin:OnLeave()
	self.Button:SetHighlightLocked(false);
	TRP3_MenuUtil.HideTooltip(self);
end

function TRP3_DropdownButtonMixin:OnMouseDown()
	self.Button:SetButtonState(self:IsEnabled() and "PUSHED" or "DISABLED");
	self:OpenMenu();
end

function TRP3_DropdownButtonMixin:OnMouseUp()
	self.Button:SetButtonState(self:IsEnabled() and "NORMAL" or "DISABLED");
end

function TRP3_DropdownButtonMixin:HandlesGlobalMouseEvent(buttonName, event)
	return event == "GLOBAL_MOUSE_DOWN" and buttonName == "LeftButton";
end

function TRP3_DropdownButtonMixin:IsMenuOpen()
	return UIDROPDOWNMENU_OPEN_MENU == self;
end

function TRP3_DropdownButtonMixin:CloseMenu()
	if self:IsMenuOpen() then
		CloseDropDownMenus();
	end
end

function TRP3_DropdownButtonMixin:OpenMenu()
	if self:IsMenuOpen() then
		return;
	elseif not self:IsEnabled() then
		return;
	end

	self:GenerateMenu();

	if not self:HasElements() then
		return;
	end

	TRP3_Menu.OpenMenu(self, self.menuDescription);
end

function TRP3_DropdownButtonMixin:SetMenuAnchor(anchor)
	self.menuAnchor = anchor;
	UIDropDownMenu_SetAnchor(self, anchor.x, anchor.y, anchor.point, anchor.relativeTo, anchor.relativePoint);
end

function TRP3_DropdownButtonMixin:IsEnabled()
	return UIDropDownMenu_IsEnabled(self);
end

function TRP3_DropdownButtonMixin:SetEnabled(enabled)
	UIDropDownMenu_SetDropDownEnabled(self, enabled);
end

function TRP3_DropdownButtonMixin:GetDefaultText()
	return self.defaultText;
end

function TRP3_DropdownButtonMixin:SetDefaultText(defaultText)
	self.defaultText = defaultText;
	self:UpdateText();
end

function TRP3_DropdownButtonMixin:GetText()
	return UIDropDownMenu_GetText(self);
end

function TRP3_DropdownButtonMixin:SetText(text)
	UIDropDownMenu_SetText(self, text);
end

local function GetTextFromSelections(rootDescription)
	if not rootDescription then
		return nil;
	end

	local currentSelections = TRP3_MenuUtil.GetSelections(rootDescription);

	if #currentSelections == 0 then
		return nil;
	end

	local elementTexts = {};

	for _, elementDescription in ipairs(currentSelections) do
		local elementText = TRP3_MenuUtil.GetElementText(elementDescription);
		table.insert(elementTexts, elementText);
	end

	return table.concat(elementTexts, LIST_DELIMITER);
end

function TRP3_DropdownButtonMixin:GetUpdateText()
	local updateText = GetTextFromSelections(self.menuDescription);

	if not updateText or updateText == "" then
		updateText = self.defaultText;
	end

	return updateText;
end

function TRP3_DropdownButtonMixin:GetMenuDescription()
	return self.menuDescription;
end

function TRP3_DropdownButtonMixin:HasElements()
	return self.menuDescription and self.menuDescription:HasElements() or false;
end

local function CalculateMinimumMenuWidth(self)
	return self:GetWidth() - 23;
end

function TRP3_DropdownButtonMixin:RegisterMenu(rootDescription)
	self.menuDescription = rootDescription;
	self.menuDescription:AddMenuResponseCallback(function() self:UpdateText(); end);
	self.menuDescription:SetMinimumWidth(CalculateMinimumMenuWidth(self));

	TRP3_Menu.SetMenuInitializer(self, self.menuDescription);

	if self:IsMenuOpen() then
		-- Open menus require a full reinitialization; unlike modern menus
		-- this unfortunately means that we need to close + reopen it.
		self:ToggleMenu();
	end

	self:UpdateText();
end

function TRP3_DropdownButtonMixin:GenerateMenu()
	if not self.menuGenerator then
		return;
	end

	local rootDescription = TRP3_Menu.CreateRootMenuDescription();
	securecallfunction(self.menuGenerator, self, rootDescription);
	self:RegisterMenu(rootDescription);
end

function TRP3_DropdownButtonMixin:SetupMenu(menuGenerator)
	self.menuGenerator = menuGenerator;

	if self:IsShown() then
		self:GenerateMenu();
	end
end

function TRP3_DropdownButtonMixin:Update()
	self:GenerateMenu();
end

function TRP3_DropdownButtonMixin:UpdateText()
	if self.disableSelectionText then
		return;
	end

	self:SetText(self:GetUpdateText());
end

function TRP3_DropdownButtonMixin:OverrideText(text)
	self.disableSelectionText = true;
	self:SetText(text);
end
