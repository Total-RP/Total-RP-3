-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_DropdownButtonMixin = {};

function TRP3_DropdownButtonMixin:OnLoad()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnShow()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnHide()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnEnter()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnLeave()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnMouseDown()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OnMouseUp()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:IsMenuOpen()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:CloseMenu()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OpenMenu()
	-- No-op; override in another file.
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

function TRP3_DropdownButtonMixin:SetMenuAnchor(anchor)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:IsEnabled()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:SetEnabled(enabled)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:GetDefaultText()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:SetDefaultText(defaultText)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:GetText()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:SetText(text)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:GetUpdateText()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:GetMenuDescription()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:HasElements()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:RegisterMenu(menuDescription)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:GenerateMenu()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:SetupMenu(menuGenerator)  -- luacheck: no unused
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:Update()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:UpdateText()
	-- No-op; override in another file.
end

function TRP3_DropdownButtonMixin:OverrideText(text)  -- luacheck: no unused
	-- No-op; override in another file.
end
