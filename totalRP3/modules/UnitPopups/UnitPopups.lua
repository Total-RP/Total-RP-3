--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

--
-- Unit Popups Module
--

local UnitPopupsModule = {};

UnitPopupsModule.MenuButtons = {};
UnitPopupsModule.MenuEntries = {};

function UnitPopupsModule:Init()
	hooksecurefunc("UnitPopup_ShowMenu", function(...) return self:OnUnitPopupShown(...); end);
end

function UnitPopupsModule:OnUnitPopupShown(dropdownMenu, menuType)
	if not dropdownMenu or not self.MenuEntries[menuType] then
		return;
	end

	-- If we're processing a submenu then the menu type is inferred from the
	-- value field of the parent, which is stored a global when activated.

	if UIDROPDOWNMENU_MENU_LEVEL ~= 1 then
		menuType = UIDROPDOWNMENU_MENU_VALUE;
	end

	local menuEntries = self.MenuEntries[menuType];
	if not menuEntries or #menuEntries == 0 then
		return;
	end

	-- The top-level menu has a separator/header display before the actual
	-- items are added. This is user-configurable to deal with cases such
	-- as the Raider.IO addon which itself also adds unit menu options with
	-- its own separator.

	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		UIDropDownMenu_AddSeparator();
		UIDropDownMenu_AddButton(self.MenuButtons.RoleplayOptions);
	end

	for _, buttonId in ipairs(self.MenuEntries[menuType]) do
		UIDropDownMenu_AddButton(self.MenuButtons[buttonId], UIDROPDOWNMENU_MENU_LEVEL);
	end
end

--
-- Menu Data
--

Mixin(UnitPopupsModule.MenuButtons, {
	RoleplayOptions = {
		text = L.UNIT_POPUPS_ROLEPLAY_OPTIONS_HEADER,
		isTitle = true,
		isUninteractable = true,
		notCheckable = true,
	},

	OpenProfile = {
		text = L.UNIT_POPUPS_OPEN_PROFILE,
		notCheckable = true,
		func = function()
			local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
			local unit = dropdownFrame.unit;
			local name = dropdownFrame.name;
			local server = dropdownFrame.server;
			local fullName = string.join("-", name or UNKNOWNOBJECT, server or GetNormalizedRealmName());

			if UnitExists(unit) and false then
				TRP3_API.slash.openProfile(unit);
			elseif not string.find(fullName, UNKNOWNOBJECT, 1, true) then
				TRP3_API.slash.openProfile(fullName);
			end
		end,
	},

	CharacterStatus = {
		text = L.DB_STATUS_RP_OOC,
		notCheckable = false,
		isNotRadio = true,
		keepShownOnClick = true,
		checked = function()
			local player = AddOn_TotalRP3.Player.GetCurrentUser();
			local roleplayStatus = player:GetRoleplayStatus();

			return roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
		end,
		func = function(button)
			local player = AddOn_TotalRP3.Player.GetCurrentUser();

			if button.checked() then
				player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER);
			else
				player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
			end
		end,
	},
});

Mixin(UnitPopupsModule.MenuEntries, {
	CHAT_ROSTER    = { "OpenProfile" },
	FRIEND         = { "OpenProfile" },
	FRIEND_OFFLINE = { "OpenProfile" },
	GUILD          = { "OpenProfile" },
	GUILD_OFFLINE  = { "OpenProfile" },
	PARTY          = { "OpenProfile" },
	PLAYER         = { "OpenProfile" },
	RAID           = { "OpenProfile" },
	RAID_PLAYER    = { "OpenProfile" },
	SELF           = { "OpenProfile", "CharacterStatus" },
});

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_unitpopups",
	name = L.UNIT_POPUPS_MODULE_NAME,
	description = L.UNIT_POPUPS_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	onStart = function() UnitPopupsModule:Init(); end,
});
