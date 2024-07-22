-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local _, TRP3_API = ...;

local Locale = {};
TRP3_API.Locale = Locale;

function Locale.init()
	TRP3_API.configuration.registerConfigKey("AddonLocale", GetLocale());
	TRP3_API.loc:SetCurrentLocale(TRP3_API.utils.GetPreferredLocale(), true);

	BINDING_NAME_TRP3_TOGGLE = TRP3_API.loc.BINDING_NAME_TRP3_TOGGLE;
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = TRP3_API.loc.BINDING_NAME_TRP3_TOOLBAR_TOGGLE;
	BINDING_NAME_TRP3_OPEN_TARGET_PROFILE = TRP3_API.loc.BINDING_NAME_TRP3_OPEN_TARGET_PROFILE;
	BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS = TRP3_API.loc.BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS;

	-- Localization strings are exported globally for use from XML which
	-- is incapable of performing nested lookups. Longer-term, we may want
	-- to use global strings everywhere for consistency.

	for key, value in TRP3_API.loc:EnumerateTexts() do
		_G["TRP3_L_" .. key] = value;
	end
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

local KeyLocalizationOverrides = {
	CLICK = "CM_CLICK",         -- "Click"
	DCLICK = "CM_DOUBLECLICK",  -- "Double-Click"
	DRAGDROP = "CM_DRAGDROP",   -- "Drag & Drop"
	LCLICK = "CM_L_CLICK",      -- "Left-Click"
	BUTTON1 = "CM_L_CLICK",
	MCLICK = "CM_M_CLICK",      -- "Middle-Click"
	BUTTON3 = "CM_M_CLICK",
	RCLICK = "CM_R_CLICK",      -- "Right-Click"
	BUTTON2 = "CM_R_CLICK",
	ALT = "CM_ALT",
	CMD = "CM_CMD",
	CTRL = "CM_CTRL",
	META = "CM_META",
	OPT = "CM_OPT",
	SHIFT = "CM_SHIFT",
};

local function GetLocalizedKeyText(key)
	local text;

	if KeyLocalizationOverrides[key] then
		text = TRP3_API.loc[KeyLocalizationOverrides[key]];
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
	local separator = "-";
	local localizer;

	if shortcutType == TRP3_API.ShortcutType.Normal then
		localizer = GetLocalizedKeyText;
	elseif shortcutType == TRP3_API.ShortcutType.System then
		localizer = GetLocalizedSystemKeyText;
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
	local text = string.format(TRP3_API.loc.SHORTCUT_INSTRUCTION, shortcut, instruction);
	return GREEN_FONT_COLOR:WrapTextInColorCode(text);
end
