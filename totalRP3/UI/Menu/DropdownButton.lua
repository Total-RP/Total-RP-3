-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_DropdownButtonMixin = {};

function TRP3_DropdownButtonMixin:OnLoad()
	local anchor = AnchorUtil.CreateAnchor(self.menuPoint, self, self.menuRelativePoint, self.menuPointX, self.menuPointY);
	self:SetMenuAnchor(anchor);
end

function TRP3_DropdownButtonMixin:IsMenuOpen()
	return self.Button:IsMenuOpen();
end

function TRP3_DropdownButtonMixin:CloseMenu()
	self.Button:CloseMenu();
end

function TRP3_DropdownButtonMixin:OpenMenu()
	self.Button:OpenMenu();
end

function TRP3_DropdownButtonMixin:ToggleMenu()
	self:SetMenuOpen(not self:IsMenuOpen());
end

function TRP3_DropdownButtonMixin:SetMenuOpen(open)
	if open then
		self:OpenMenu();
	else
		self:CloseMenu();
	end
end

function TRP3_DropdownButtonMixin:SetMenuAnchor(anchor)
	self.Button:SetMenuAnchor(anchor);
end

function TRP3_DropdownButtonMixin:IsEnabled()
	return self.Button:IsEnabled();
end

function TRP3_DropdownButtonMixin:SetEnabled(enabled)
	self.Button:SetEnabled(enabled);
end

function TRP3_DropdownButtonMixin:GetDefaultText()
	return self.Button:GetDefaultText();
end

function TRP3_DropdownButtonMixin:SetDefaultText(defaultText)
	self.Button:SetDefaultText(defaultText);
end

function TRP3_DropdownButtonMixin:GetText()
	return self.Button:GetText();
end

function TRP3_DropdownButtonMixin:SetText(text)
	self.Button:SetText(text);
end

function TRP3_DropdownButtonMixin:GetUpdateText()
	return self.Button:GetUpdateText();
end

function TRP3_DropdownButtonMixin:GetMenuDescription()
	return self.Button:GetMenuDescription();
end

function TRP3_DropdownButtonMixin:HasElements()
	return self.Button:HasElements();
end

function TRP3_DropdownButtonMixin:RegisterMenu(menuDescription)
	self.Button:RegisterMenu(menuDescription);
end

function TRP3_DropdownButtonMixin:GenerateMenu()
	self.Button:GenerateMenu();
end

function TRP3_DropdownButtonMixin:SetupMenu(menuGenerator)
	self.Button:SetupMenu(menuGenerator);
end

function TRP3_DropdownButtonMixin:Update()
	self.Button:Update();
end

function TRP3_DropdownButtonMixin:UpdateText()
	self.Button:UpdateText();
end

function TRP3_DropdownButtonMixin:OverrideText(text)
	self.Button:OverrideText(text);
end

function TRP3_DropdownButtonMixin:SetSelectionTranslator(translator)
	self.Button:SetSelectionTranslator(translator);
end

function TRP3_DropdownButtonMixin:HandlesGlobalMouseEvent(buttonName, event)
	return event == "GLOBAL_MOUSE_DOWN" and buttonName == "LeftButton";
end
