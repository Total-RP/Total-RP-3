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

local DecomposeChordString;
local GetLocalizedKeyText;
local GetLocalizedSystemKeyText;
local MetaKeyComparator;

TRP3_API.ShortcutType = {
	Normal = nil,
	System = 1,
};

function TRP3_API.FormatShortcut(chord, shortcutType)
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

	local keys = DecomposeChordString(chord);

	for index, key in ipairs(keys) do
		keys[index] = localizer(key);
	end

	return table.concat(keys, separator);
end

function TRP3_API.FormatShortcutWithInstruction(chord, instruction, shortcutType)
	local shortcut = TRP3_API.FormatShortcut(chord, shortcutType);
	return string.format(TRP3_API.loc.SHORTCUT_INSTRUCTION, TRP3_API.MiscColors.Normal("[" .. shortcut .. "]"), TRP3_API.Colors.White(instruction));
end

local MetaKeyPriorities = {
	LALT = 1,
	RALT = 2,
	LCTRL = 3,
	RCTRL = 4,
	LSHIFT = 5,
	RSHIFT = 6,
	LMETA = 7,
	RMETA = 8,
	ALT = 9,
	CTRL = 10,
	SHIFT = 11,
	META = 12,
};

local CustomLocalizationKeys = {
	-- Meta keys
	ALT = "CM_ALT",
	CTRL = "CM_CTRL",
	SHIFT = "CM_SHIFT",

	-- Mouse actions
	CLICK = "CM_CLICK",         -- "Click"
	DCLICK = "CM_DOUBLECLICK",  -- "Double click"
	DRAGDROP = "CM_DRAGDROP",   -- "Drag & drop"
	LCLICK = "CM_L_CLICK",      -- "Left-click"
	MCLICK = "CM_M_CLICK",      -- "Middle-click"
	RCLICK = "CM_R_CLICK",      -- "Right-click"
};

function MetaKeyComparator(a, b)
	local priorityA = MetaKeyPriorities[a];
	local priorityB = MetaKeyPriorities[b];

	if priorityA and priorityB then
		return priorityA < priorityB;
	else
		return priorityA ~= nil;
	end
end

function DecomposeChordString(chord)
	local keys = { string.split("-", chord) };
	table.sort(keys, MetaKeyComparator);
	return keys;
end

function GetLocalizedKeyText(key)
	local text;

	if CustomLocalizationKeys[key] then
		text = TRP3_API.loc[CustomLocalizationKeys[key]];
	else
		text = GetBindingText(key);
	end

	return text;
end

function GetLocalizedSystemKeyText(key)
	if IsMacClient() then
		if key == "CTRL" then
			return TRP3_API.loc.CM_CTRL_MAC;
		elseif key == "ALT" then
			return TRP3_API.loc.CM_ALT_MAC;
		end
	end

	return GetLocalizedKeyText(key);
end
