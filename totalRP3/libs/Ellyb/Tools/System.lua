---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.System then
	return
end

-- Ellyb imports
local loc = Ellyb.loc;

local System = {};
Ellyb.System = System;

---@return boolean isMac @ Returns true if the client is running on a Mac
function System:IsMac()
	return IsMacClient();
end

function System:IsTestBuild()
	return IsTestBuild();
end

function System:IsTrialAccount()
	return IsTrialAccount();
end

function System:IsClassic()
	return WOW_PROJECT_ID == Ellyb.Enum.GAME_CLIENT_TYPES.CLASSIC;
end

function System:IsRetail()
	return WOW_PROJECT_ID == Ellyb.Enum.GAME_CLIENT_TYPES.RETAIL;
end

local SHORTCUT_SEPARATOR = System:IsMac() and "-" or " + ";

System.MODIFIERS = {
	CTRL = loc.MODIFIERS_CTRL,
	ALT = loc.MODIFIERS_ALT,
	SHIFT = loc.MODIFIERS_SHIFT,
}

local MAC_SHORT_EQUIVALENCE = {
	[System.MODIFIERS.CTRL] = loc.MODIFIERS_MAC_CTRL,
	[System.MODIFIERS.ALT] = loc.MODIFIERS_MAC_ALT,
	[System.MODIFIERS.SHIFT] = loc.MODIFIERS_MAC_SHIFT,
}

--- Format a keyboard shortcut with the appropriate separators according to the user operating system
---@vararg string
---@return string
function System:FormatKeyboardShortcut(...)
	local shortcutComponents = { ... };

	return table.concat(shortcutComponents, SHORTCUT_SEPARATOR);
end

--- Format a keyboard shortcut with the appropriate separators according to the user operating system
--- Will also convert Ctrl into Command and Alt into Option for Mac users.
---@vararg string
---@return string
function System:FormatSystemKeyboardShortcut(...)
	local shortcutComponents = { ... };

	if IsMacClient() then
		-- Replace shortcut components
		for index, component in pairs(shortcutComponents) do
			if MAC_SHORT_EQUIVALENCE[component] then
				shortcutComponents[index] = MAC_SHORT_EQUIVALENCE[component];
			end
		end
	end

	return table.concat(shortcutComponents, SHORTCUT_SEPARATOR);
end

System.SHORTCUTS = {
	COPY = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "C"),
	PASTE = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "V"),
};

System.CLICKS = {
	CLICK = loc.CLICK ,
	RIGHT_CLICK = loc.RIGHT_CLICK,
	LEFT_CLICK = loc.LEFT_CLICK,
	MIDDLE_CLICK = loc.MIDDLE_CLICK,
	DOUBLE_CLICK = loc.DOUBLE_CLICK,
};
