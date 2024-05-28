-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_BindingUtil = {};

local KEY_SEPARATOR = "-";

local ModifierKeyPriorities = {
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

function TRP3_BindingUtil.IsModifierKey(key)
	return ModifierKeyPriorities[key] ~= nil;
end

function TRP3_BindingUtil.IsKeyDown(key)
	-- The IsKeyDown function only considers directioned keys (left/right)
	-- as valid for modifiers, whereas this function accepts them and tests
	-- via the appropriate Is*KeyDown() functions.

	if key == "ALT" then
		return IsAltKeyDown();
	elseif key == "CTRL" then
		return IsControlKeyDown();
	elseif key == "SHIFT" then
		return IsShiftKeyDown();
	elseif key == "META" then
		return IsMetaKeyDown();
	else
		return IsKeyDown(key);
	end
end

local function KeyComparator(a, b)
	local priorityA = ModifierKeyPriorities[a];
	local priorityB = ModifierKeyPriorities[b];

	if priorityA and priorityB then
		return priorityA < priorityB;
	elseif priorityA or priorityB then
		return priorityA ~= nil;
	else
		return a < b;
	end
end

function TRP3_BindingUtil.SortKeys(keys)
	table.sort(keys, KeyComparator);
	return keys;
end

local function BindingComparator(a, b)
	a = TRP3_BindingUtil.DecomposeBinding(a);
	b = TRP3_BindingUtil.DecomposeBinding(b);

	if #a ~= #b then
		return #a < #b;
	end

	for i = 1, #a do
		local ka = a[i];
		local kb = b[i];

		if ka ~= kb then
			return KeyComparator(ka, kb);
		end
	end

	return false;
end

function TRP3_BindingUtil.SortBindings(bindings)
	table.sort(bindings, BindingComparator);
	return bindings;
end

function TRP3_BindingUtil.ComposeBinding(keys)
	keys = TRP3_BindingUtil.SortKeys({ unpack(keys) });
	return table.concat(keys, KEY_SEPARATOR);
end

function TRP3_BindingUtil.DecomposeBinding(binding)
	local keys = TRP3_BindingUtil.SortKeys({ string.split(KEY_SEPARATOR, binding) });
	return keys;
end

local MouseActionButtons = {
	LCLICK = "BUTTON1",
	RCLICK = "BUTTON2",
	MCLICK = "BUTTON3",
};

local ButtonMouseActions = {
	BUTTON1 = "LCLICK",
	BUTTON2 = "RCLICK",
	BUTTON3 = "MCLICK",
};

function TRP3_BindingUtil.GetMouseActionFromButtonName(buttonName)
	return ButtonMouseActions[buttonName];
end

function TRP3_BindingUtil.GetButtonNameFromMouseAction(mouseAction)
	return MouseActionButtons[mouseAction];
end

local MouseButtonAtlases = {
	-- While 'newplayertutorial-icon-mouse-*' exists and provides a middle
	-- mouse button atlas, it's extremely hard to see it when embedded into
	-- font strings. As such we only support left and right buttons.

	BUTTON1 = "NPE_LeftClick",
	BUTTON2 = "NPE_RightClick",
};

function TRP3_BindingUtil.GetCurrentModifierState()
	return {
		ALT = IsAltKeyDown(),
		CTRL = IsControlKeyDown(),
		SHIFT = IsShiftKeyDown(),
		META = IsMetaKeyDown(),
	};
end

local function GetNormalizedKeymapFromBinding(binding)
	local keys = tInvert(TRP3_BindingUtil.DecomposeBinding(binding));

	-- The supplied binding string should be treated as dirty and needs its
	-- modifier keys normalized to non-directional variants.

	keys.ALT = keys.ALT or keys.LALT or keys.RALT;
	keys.LALT = nil;
	keys.RALT = nil;

	keys.CTRL = keys.CTRL or keys.LCTRL or keys.RCTRL;
	keys.LCTRL = nil;
	keys.RCTRL = nil;

	keys.SHIFT = keys.SHIFT or keys.LSHIFT or keys.RSHIFT;
	keys.LSHIFT = nil;
	keys.RSHIFT = nil;

	keys.META = keys.META or keys.LMETA or keys.RMETA;
	keys.LMETA = nil;
	keys.RMETA = nil;

	return keys;
end

function TRP3_BindingUtil.CompareBindings(bindingA, bindingB)
	-- Two bindings are considered equal only if they contain the exact
	-- same set of required keys. Modifiers are normalized such that "LALT"
	-- requires just a generic "ALT" press.

	local keymapA = GetNormalizedKeymapFromBinding(bindingA);
	local keymapB = GetNormalizedKeymapFromBinding(bindingB);

	local keyA;
	local keyB;

	repeat
		keyA = next(keymapA, keyA);
		keyB = next(keymapB, keyB);
	until not keyA or not keyB or keyA ~= keyB;

	return keyA == nil and keyA == keyB;
end

function TRP3_BindingUtil.EvaluateBinding(binding, key, modifiers)
	local input = TRP3_BindingUtil.GenerateBinding(key, modifiers);
	return TRP3_BindingUtil.CompareBindings(binding, input);
end

local DefaultFormatOptions = {
	useMouseButtonAtlases = false,
};

function TRP3_BindingUtil.FormatBinding(binding, options)
	options = options or DefaultFormatOptions;

	local keys = TRP3_BindingUtil.DecomposeBinding(binding);

	for index, key in ipairs(keys) do
		local text;

		if options.useMouseButtonAtlases and not C_CVar.GetCVarBool("colorblindMode") then
			local atlas = MouseButtonAtlases[key];

			if atlas then
				text = CreateAtlasMarkup(MouseButtonAtlases[key], options.atlasSize, options.atlasSize);
			end
		end

		if not text then
			text = GetBindingText(key);
		end

		keys[index] = text;
	end

	return table.concat(keys, KEY_SEPARATOR);
end

function TRP3_BindingUtil.GenerateBinding(key, modifiers)
	local keys = {};

	modifiers = modifiers or TRP3_BindingUtil.GetCurrentModifierState();

	if modifiers.ALT then
		table.insert(keys, "ALT");
	end

	if modifiers.CTRL then
		table.insert(keys, "CTRL");
	end

	if modifiers.SHIFT then
		table.insert(keys, "SHIFT");
	end

	if modifiers.META then
		table.insert(keys, "META");
	end

	table.insert(keys, key);

	return table.concat(keys, KEY_SEPARATOR);
end
