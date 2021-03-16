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
local TRP3_NamePlatesUtil = {};
TRP3_NamePlatesUtil.isInCombat = InCombatLockdown();

TRP3_NamePlatesUtil.MAX_NAME_CHARS = 45;
TRP3_NamePlatesUtil.MAX_TITLE_CHARS = 45;
TRP3_NamePlatesUtil.ICON_WIDTH = 16;
TRP3_NamePlatesUtil.ICON_HEIGHT = 16;

function TRP3_NamePlatesUtil.CropFontString(fontstring, width)
	fontstring:SetText(TRP3_API.utils.str.crop(fontstring:GetText(), width));
end

function TRP3_NamePlatesUtil.PrependTextToFontString(fontstring, text)
	fontstring:SetFormattedText("%s %s", text, fontstring:GetText());
end

function TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(fontstring, roleplayStatus)
	if roleplayStatus ~= AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		return;
	end

	fontstring:SetFormattedText("|cffff0000[%1$s]|r %2$s", TRP3_API.loc.CM_OOC, fontstring:GetText());
end

function TRP3_NamePlatesUtil.PrependIconToFontString(fontstring, icon)
	if type(icon) ~= "string" then
		return;
	end

	local width = TRP3_NamePlatesUtil.ICON_WIDTH;
	local height = TRP3_NamePlatesUtil.ICON_HEIGHT;

	fontstring:SetFormattedText("|Tinterface\\icons\\%1$s:%2$d:%3$d:0:-1|t %4$s", icon, width, height, fontstring:GetText());
end

function TRP3_NamePlatesUtil.SetTextureToIcon(texture, icon)
	texture:SetTexture([[interface\icons\]] .. icon);
	texture:SetSize(TRP3_NamePlatesUtil.ICON_WIDTH, TRP3_NamePlatesUtil.ICON_HEIGHT);
end

function TRP3_NamePlatesUtil.ShouldDisableOutOfCharacter()
	return TRP3_API.configuration.getValue("NamePlates_DisableOutOfCharacter");
end

function TRP3_NamePlatesUtil.ShouldDisableOutOfCharacterUnits()
	return TRP3_API.configuration.getValue("NamePlates_DisableOutOfCharacterUnits");
end

function TRP3_NamePlatesUtil.ShouldDisableInCombat()
	return TRP3_API.configuration.getValue("NamePlates_DisableInCombat");
end

function TRP3_NamePlatesUtil.ShouldHideNonRoleplayUnits()
	return TRP3_API.configuration.getValue("NamePlates_HideNonRoleplayUnits");
end

function TRP3_NamePlatesUtil.ShouldCustomizeNames()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeNames");
end

function TRP3_NamePlatesUtil.ShouldCustomizeNameColors()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeNameColors");
end

function TRP3_NamePlatesUtil.ShouldCustomizeTitles()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeTitles");
end

function TRP3_NamePlatesUtil.ShouldCustomizeIcons()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeIcons");
end

function TRP3_NamePlatesUtil.ShouldCustomizeHealthColors()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeHealthColors");
end

function TRP3_NamePlatesUtil.ShouldCustomizeRoleplayStatus()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeRoleplayStatus");
end

function TRP3_NamePlatesUtil.ShouldCustomizeFullTitles()
	return TRP3_API.configuration.getValue("NamePlates_CustomizeFullTitles");
end

function TRP3_NamePlatesUtil.ShouldCustomizeUnitNamePlate(unitToken)
	if TRP3_NamePlatesUtil.ShouldDisableInCombat() and TRP3_NamePlatesUtil.isInCombat then
		return false;
	elseif TRP3_NamePlatesUtil.ShouldDisableOutOfCharacter() and TRP3_NamePlatesUtil.IsUnitOutOfCharacter("player") then
		return false;
	elseif TRP3_NamePlatesUtil.ShouldDisableOutOfCharacterUnits() and TRP3_NamePlatesUtil.IsUnitOutOfCharacter(unitToken) then
		return false;
	else
		return true;
	end
end

function TRP3_NamePlatesUtil.ShouldShowUnitNamePlate(unitToken)
	if not TRP3_NamePlatesUtil.ShouldCustomizeUnitNamePlate(unitToken) then
		return true;  -- Customizations are disabled.
	elseif not TRP3_NamePlatesUtil.ShouldHideNonRoleplayUnits() then
		return true;  -- Option to hide non-roleplay units is disabled.
	elseif not unitToken or not UnitIsPlayer(unitToken) and not UnitIsOtherPlayersPet(unitToken) then
		return true;  -- Always show creature nameplates.
	end

	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		local characterID = TRP3_API.utils.str.getUnitID(unitToken);
		return characterID and TRP3_API.register.isUnitIDKnown(characterID) or false;
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		local companionFullID = TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType);
		return TRP3_API.companions.register.getCompanionProfile(companionFullID) ~= nil;
	else
		return true;  -- Should be impossible, default to showing it.
	end
end

function TRP3_NamePlatesUtil.GetUnitRoleplayStatus(unitToken)
	local player;

	if UnitIsUnit(unitToken, "player") then
		player = AddOn_TotalRP3.Player.GetCurrentUser();
	elseif UnitIsPlayer(unitToken) then
		player = AddOn_TotalRP3.Player.CreateFromUnit(unitToken);
	else
		-- For companion units query the OOC state of their owner.
		local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
		local characterID = select(2, TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType));

		if characterID then
			if characterID == TRP3_API.globals.player_id then
				player = AddOn_TotalRP3.Player.GetCurrentUser();
			else
				player = AddOn_TotalRP3.Player.CreateFromCharacterID(characterID);
			end
		end
	end

	if not player then
		return nil;
	else
		return player:GetRoleplayStatus();
	end
end

function TRP3_NamePlatesUtil.IsUnitOutOfCharacter(unitToken)
	local roleplayStatus = TRP3_NamePlatesUtil.GetUnitRoleplayStatus(unitToken);
	return roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

function TRP3_NamePlatesUtil.IsInCombat()
	return not not TRP3_NamePlatesUtil.isInCombat;
end

function TRP3_NamePlatesUtil.SetInCombat(isInCombat)
	TRP3_NamePlatesUtil.isInCombat = isInCombat;
end

--
-- Configuration Data
--

TRP3_NamePlatesUtil.Configuration = {
	DisableOutOfCharacter = {
		key = "NamePlates_DisableOutOfCharacter",
		default = false,
	},

	DisableOutOfCharacterUnits = {
		key = "NamePlates_DisableOutOfCharacterUnits",
		default = false,
	},

	DisableInCombat = {
		key = "NamePlates_DisableInCombat",
		default = false,
	},

	HideNonRoleplayUnits = {
		key = "NamePlates_HideNonRoleplayUnits",
		default = false,
	},

	CustomizeNames = {
		key = "NamePlates_CustomizeNames",
		default = true,
	},

	CustomizeNameColors = {
		key = "NamePlates_CustomizeNameColors",
		default = true,
	},

	CustomizeTitles = {
		key = "NamePlates_CustomizeTitles",
		default = true,
	},

	CustomizeIcons = {
		key = "NamePlates_CustomizeIcons",
		default = false,
	},

	CustomizeHealthColors = {
		key = "NamePlates_CustomizeHealthColors",
		default = true,
	},

	CustomizeRoleplayStatus = {
		key = "NamePlates_CustomizeRoleplayStatus",
		default = false,
	},

	CustomizeFullTitles = {
		key = "NamePlates_CustomizeFullTitles",
		default = false,
	},
};

TRP3_NamePlatesUtil.ConfigurationPage = {
	id = "main_config_nameplates",
	menuText = L.NAMEPLATES_CONFIG_MENU_TITLE,
	pageText = L.NAMEPLATES_CONFIG_PAGE_TEXT,
	elements = {
		{
			inherit = "TRP3_ConfigParagraph",
			title = L.NAMEPLATES_CONFIG_PAGE_HELP,
		},
		{
			inherit = "TRP3_ConfigH1",
			title = L.NAMEPLATES_CONFIG_VISIBILITY_HEADER,
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT,
			help = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT_HELP,
			configKey = "NamePlates_DisableInCombat",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER,
			help = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP,
			configKey = "NamePlates_DisableOutOfCharacter",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_UNITS,
			help = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_UNITS_HELP,
			configKey = "NamePlates_DisableOutOfCharacterUnits",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_HIDE_NON_ROLEPLAY_UNITS,
			help = L.NAMEPLATES_CONFIG_HIDE_NON_ROLEPLAY_UNITS_HELP,
			configKey = "NamePlates_HideNonRoleplayUnits",
		},
		{
			inherit = "TRP3_ConfigH1",
			title = L.NAMEPLATES_CONFIG_ELEMENT_HEADER,
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES_HELP,
			configKey = "NamePlates_CustomizeNames",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS_HELP,
			configKey = "NamePlates_CustomizeNameColors",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS_HELP,
			configKey = "NamePlates_CustomizeHealthColors",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_TITLES,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_TITLES_HELP,
			configKey = "NamePlates_CustomizeTitles",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES_HELP,
			configKey = "NamePlates_CustomizeFullTitles",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS_HELP,
			configKey = "NamePlates_CustomizeRoleplayStatus",
		},
		{
			inherit = "TRP3_ConfigCheck",
			title = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS,
			help = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS_HELP,
			configKey = "NamePlates_CustomizeIcons",
		},
	}
};

_G.TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
