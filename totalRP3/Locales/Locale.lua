-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local _, TRP3_API = ...;

local Locale = {};
TRP3_API.Locale = Locale;

function Locale.init()
	TRP3_API.configuration.registerConfigKey("AddonLocale", GetLocale());
	TRP3_API.loc:SetCurrentLocale(TRP3_API.configuration.getValue("AddonLocale"), true);

	BINDING_NAME_TRP3_TOGGLE = TRP3_API.loc.BINDING_NAME_TRP3_TOGGLE;
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = TRP3_API.loc.BINDING_NAME_TRP3_TOOLBAR_TOGGLE;
	BINDING_NAME_TRP3_OPEN_TARGET_PROFILE = TRP3_API.loc.BINDING_NAME_TRP3_OPEN_TARGET_PROFILE;
	BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS = TRP3_API.loc.BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS;
end

-- Shortcut formatting
--
-- Shortcuts are formatted according to "key chord" strings as would be
-- used by the underlying game bindings API.
--
-- A key chord is a string with keys delimited by an "-", eg. "CTRL-C" or
-- "ALT-CTRL-BUTTON1".
--
-- As an extension we support "mouse actions" in this system as part of the
-- chord string. Where "BUTTON1" would localized to "Left Button", you can
-- instead use "LCLICK" for the localized equivalent of "Left-click".
--

local DEFAULT_SHORTCUT_SEPARATOR = "+";
local SYSTEM_SHORTCUT_SEPARATOR = IsMacClient() and "-" or DEFAULT_SHORTCUT_SEPARATOR;

local MouseActionLocalizationKeys = {
	CLICK = "CM_CLICK",         -- "Click"
	DCLICK = "CM_DOUBLECLICK",  -- "Double click"
	DRAGDROP = "CM_DRAGDROP",   -- "Drag & drop"
	LCLICK = "CM_L_CLICK",      -- "Left-click"
	BUTTON1 = "CM_L_CLICK",
	MCLICK = "CM_M_CLICK",      -- "Middle-click"
	BUTTON3 = "CM_M_CLICK",
	RCLICK = "CM_R_CLICK",      -- "Right-click"
	BUTTON2 = "CM_R_CLICK",
};

local function GetLocalizedKeyText(key)
	local text;

	if MouseActionLocalizationKeys[key] then
		text = TRP3_API.loc[MouseActionLocalizationKeys[key]];
	else
		text = GetBindingText(key);
	end

	return text;
end

local function GetLocalizedSystemKeyText(key)
	if IsMacClient() then
		if key == "CTRL" then
			return "CMD";
		elseif key == "ALT" then
			return "OPT";
		end
	end

	return GetLocalizedKeyText(key);
end

TRP3_API.ShortcutType = {
	Normal = nil,
	System = 1,
};

function TRP3_API.FormatShortcut(binding, shortcutType)
	local separator;
	local localizer;

	if shortcutType == TRP3_API.ShortcutType.Normal then
		localizer = GetLocalizedKeyText;
		separator = DEFAULT_SHORTCUT_SEPARATOR;
	elseif shortcutType == TRP3_API.ShortcutType.System then
		localizer = GetLocalizedSystemKeyText;
		separator = SYSTEM_SHORTCUT_SEPARATOR;
	else
		error("invalid shortcut type");
	end

	local keys = TRP3_BindingUtil.DecomposeBinding(binding);

	for index, key in ipairs(keys) do
		keys[index] = localizer(key);
	end

	return table.concat(keys, separator);
end

function TRP3_API.FormatShortcutWithInstruction(binding, instruction, shortcutType)
	local shortcut = TRP3_API.FormatShortcut(binding, shortcutType);
	return string.format(TRP3_API.loc.SHORTCUT_INSTRUCTION, TRP3_API.MiscColors.Normal("[" .. shortcut .. "]"), TRP3_API.Colors.White(instruction));
end
