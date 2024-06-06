-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

if TRP3_USE_MODERN_MENUS then
	return;
end

local function CalculateMinimumMenuWidth(dropdown)
	return dropdown:GetWidth() - UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING;
end

TRP3_DropdownButtonMixin = {};

function TRP3_DropdownButtonMixin:OnLoad()
	self:SetHitRectInsets(8, 8, 4, 4);
	self:SetMouseMotionEnabled(true);
	self:SetMouseClickEnabled(true);

	self.Menu = CreateFrame("Frame", "$parentMenu", self, "UIDropDownMenuTemplate");
	self.Menu:SetPoint("LEFT", -13, 0);
	self.Menu:SetPoint("RIGHT");
	-- Force truncation of the text label if it exceeds button bounds.
	self.Menu.Text:ClearAllPoints();
	self.Menu.Text:SetPoint("LEFT", self.Menu.Left, 27, 2);
	self.Menu.Text:SetPoint("RIGHT", self.Menu.Right, -43, 2);
	UIDropDownMenu_SetWidth(self.Menu, CalculateMinimumMenuWidth(self));

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

function TRP3_DropdownButtonMixin:OnEnter()
	if self.Menu.Text:IsTruncated() then
		local function Initialize(tooltip)
			GameTooltip_SetTitle(tooltip, self.Menu.Text:GetText());
		end

		TRP3_MenuUtil.ShowTooltip(self, Initialize);
	end

	self.Menu.Button:SetHighlightLocked(true);
end

function TRP3_DropdownButtonMixin:OnLeave()
	self.Menu.Button:SetHighlightLocked(false);
	TRP3_MenuUtil.HideTooltip(self);
end

function TRP3_DropdownButtonMixin:OnMouseDown()
	self:OpenMenu();
end

function TRP3_DropdownButtonMixin:OnSizeChanged()
	UIDropDownMenu_SetWidth(self.Menu, CalculateMinimumMenuWidth(self));
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

	TRP3_Menu.OpenMenu(self.Menu, self.menuDescription);
end

function TRP3_DropdownButtonMixin:SetMenuAnchor(anchor)
	self.menuAnchor = anchor;
	UIDropDownMenu_SetAnchor(self.Menu, anchor.x, anchor.y, anchor.point, anchor.relativeTo, anchor.relativePoint);
end

function TRP3_DropdownButtonMixin:IsEnabled()
	return UIDropDownMenu_IsEnabled(self.Menu);
end

function TRP3_DropdownButtonMixin:SetEnabled(enabled)
	UIDropDownMenu_SetDropDownEnabled(self.Menu, enabled);
end

function TRP3_DropdownButtonMixin:GetDefaultText()
	return self.defaultText;
end

function TRP3_DropdownButtonMixin:SetDefaultText(defaultText)
	self.defaultText = defaultText;
	self:UpdateText();
end

function TRP3_DropdownButtonMixin:GetText()
	return UIDropDownMenu_GetText(self.Menu);
end

function TRP3_DropdownButtonMixin:SetText(text)
	UIDropDownMenu_SetText(self.Menu, text);
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

function TRP3_DropdownButtonMixin:RegisterMenu(rootDescription)
	self.menuDescription = rootDescription;
	self.menuDescription:AddMenuResponseCallback(function() self:UpdateText(); end);
	self.menuDescription:SetMinimumWidth(CalculateMinimumMenuWidth(self));

	TRP3_Menu.SetMenuInitializer(self.Menu, self.menuDescription);

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
