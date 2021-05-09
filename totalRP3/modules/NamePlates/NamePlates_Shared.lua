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

TRP3_NamePlatesUtil.MAX_NAME_CHARS = 30;
TRP3_NamePlatesUtil.MAX_TITLE_CHARS = 30;
TRP3_NamePlatesUtil.OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15:15|t";

function TRP3_NamePlatesUtil.GetPreferredOOCIndicatorStyle()
	return TRP3_API.configuration.getValue("NamePlates_PreferredOOCIndicator");
end

function TRP3_NamePlatesUtil.GetPreferredIconSize()
	local size = tonumber(TRP3_API.configuration.getValue("NamePlates_IconSize")) or 16;
	return size, size;
end

function TRP3_NamePlatesUtil.PrependRoleplayStatusToText(text, roleplayStatus)
	if roleplayStatus ~= AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		return text;
	end

	local preferredStyle = TRP3_NamePlatesUtil.GetPreferredOOCIndicatorStyle();

	if preferredStyle == "ICON" then
		return string.join(" ", TRP3_NamePlatesUtil.OOC_ICON, text);
	else
		return string.format("|cffff0000[%1$s]|r %2$s", TRP3_API.loc.CM_OOC, text);
	end
end

function TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(fontstring, roleplayStatus)
	if roleplayStatus ~= AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		return;
	end

	local preferredStyle = TRP3_NamePlatesUtil.GetPreferredOOCIndicatorStyle();

	if preferredStyle == "ICON" then
		fontstring:SetFormattedText("%s %s", TRP3_NamePlatesUtil.OOC_ICON, fontstring:GetText());
	else
		fontstring:SetFormattedText("|cffff0000[%1$s]|r %2$s", TRP3_API.loc.CM_OOC, fontstring:GetText());
	end
end

function TRP3_NamePlatesUtil.GetUnitRegisterID(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local registerID;

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		registerID = TRP3_API.utils.str.getUnitID(unitToken);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		registerID = TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType);
	end

	if registerID and string.find(registerID, UNKNOWNOBJECT, 1, true) == 1 then
		-- The player that owns this profile isn't yet known to the client.
		registerID = nil;
	end

	return registerID;
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

	HideOutOfCharacterUnits = {
		key = "NamePlates_HideOutOfCharacterUnits",
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

	IconSize = {
		key = "NamePlates_IconSize",
		default = 16,
	},

	CustomizeHealthColors = {
		key = "NamePlates_CustomizeHealthColors",
		default = true,
	},

	CustomizeRoleplayStatus = {
		key = "NamePlates_CustomizeRoleplayStatus",
		default = false,
	},

	PreferredOOCIndicator = {
		key = "NamePlates_PreferredOOCIndicator",
		default = "TEXT",
	},

	CustomizeFullTitles = {
		key = "NamePlates_CustomizeFullTitles",
		default = false,
	},

	EnableActiveQuery = {
		key = "NamePlates_EnableActiveQuery",
		default = true,
	},

	EnableClassColorFallback = {
		key = "NamePlates_EnableClassColorFallback",
		default = true,
	},
};

function TRP3_NamePlatesUtil.GenerateConfigurationPage()
	return {
		id = "main_config_nameplates",
		menuText = L.NAMEPLATES_CONFIG_MENU_TITLE,
		pageText = L.NAMEPLATES_CONFIG_PAGE_TEXT,
		elements = {
			{
				inherit = "TRP3_ConfigParagraph",
				title = L.NAMEPLATES_CONFIG_PAGE_HELP,
			},
			{
				inherit = "TRP3_ConfigButton",
				title = L.NAMEPLATES_CONFIG_ENABLE_MODULE,
				text = DISABLE,
				OnShow = function(button)
					local element = button:GetParent();
					local title = _G[element:GetName() .. "Title"];
					local addon = TRP3_NAMEPLATES_ADDON;

					if addon then
						title:SetFormattedText(L.NAMEPLATES_MODULE_ACTIVE_STATUS, (select(2, GetAddOnInfo(addon)) or addon));
					else
						title:SetText(L.NAMEPLATES_MODULE_INACTIVE_STATUS);
					end
				end,
				OnClick = function()
					TRP3_API.popup.showConfirmPopup(L.NAMEPLATES_MODULE_DISABLE_WARNING, function()
						local current = TRP3_Configuration.MODULE_ACTIVATION["trp3_nameplates"];
						TRP3_Configuration.MODULE_ACTIVATION["trp3_nameplates"] = not current;
						ReloadUI();
					end);
				end,
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
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_HIDE_OUT_OF_CHARACTER_UNITS,
				help = L.NAMEPLATES_CONFIG_HIDE_OUT_OF_CHARACTER_UNITS_HELP,
				configKey = "NamePlates_HideOutOfCharacterUnits",
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
				title = L.NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK,
				help = L.NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK_HELP,
				configKey = "NamePlates_EnableClassColorFallback",
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
				inherit = "TRP3_ConfigDropDown",
				title = L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR,
				listContent = {
					{ L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. TRP3_API.Ellyb.ColorManager.RED(L.CM_OOC), "TEXT" },
					{ L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON .. TRP3_NamePlatesUtil.OOC_ICON, "ICON" },
				},
				configKey = "NamePlates_PreferredOOCIndicator",
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS_HELP,
				configKey = "NamePlates_CustomizeIcons",
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_ICON_SIZE,
				help = L.NAMEPLATES_CONFIG_ICON_SIZE_HELP,
				configKey = "NamePlates_IconSize",
				min = 12,
				max = 48,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.CO_ADVANCED_SETTINGS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ACTIVE_QUERY,
				help = L.NAMEPLATES_CONFIG_ACTIVE_QUERY_HELP,
				configKey = "NamePlates_EnableActiveQuery",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY,
				help = L.NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY_HELP,
				OnShow = function(button)
					button:SetChecked(GetCVar("nameplateShowOnlyNames") ~= "0");
				end,
				OnClick = function(button)
					local value = button:GetChecked() and "1" or "0";
					local current = GetCVar("nameplateShowOnlyNames");

					if current ~= value then
						SetCVar("nameplateShowOnlyNames", value);
						TRP3_API.popup.showConfirmPopup(L.CO_UI_RELOAD_WARNING, ReloadUI);
					end
				end,
			},
		}
	};
end

_G.TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
