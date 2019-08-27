----------------------------------------------------------------------------------
--- Total RP 3
--- "At first glance" bar module
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

-- API
TRP3_API.register.glance = {};
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local tostring, _G, pairs, type, tinsert, assert, wipe, bit, strsplit = tostring, _G, pairs, type, tinsert, assert, wipe, bit, strsplit;
local loc = TRP3_API.loc;
local getIcon, tableRemove = Utils.str.icon, Utils.table.remove;
local setTooltipForSameFrame, toast = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.toast;
local unitIDIsFilteredForMatureContent;
local crop = TRP3_API.Ellyb.Strings.crop;
local shouldCropTexts = TRP3_API.ui.tooltip.shouldCropTexts;

-- CONSTANTS
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local EMPTY = Globals.empty;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local LOAD_PREFIX, REMOVE_PREFIX = "+", "-";
local GLANCE_PRESETS, GLANCE_PRESETS_CATEGORY;

-- Show a toast if TRP frame is open, or else place a chat message.
local function presetMessage(message, duration)
	if TRP3_MainFrame:IsVisible() then
		toast(message, duration);
	else
		Utils.message.displayMessage(message);
	end
end

local presetStructureForTargetFrame = {};
local function getSlotPresetDataForList(output)
	-- If we're not given an output table then we'll reuse the one created
	-- above, to maintain backwards compatibility.
	--
	-- If we are given one, don't wipe it. Could be an in-progress creation.
	if type(output) ~= "table" then
		output = presetStructureForTargetFrame;
		wipe(output);
	end

	-- Title
	tinsert(output, {loc.REG_PLAYER_GLANCE_PRESET_SELECT, nil});
	tinsert(output, {loc.REG_PLAYER_GLANCE_PRESET_CREATE, -1});
	-- Category sorting
	local tmp = {};
	for category, _ in pairs(GLANCE_PRESETS_CATEGORY) do
		tinsert(tmp, category);
	end
	table.sort(tmp);
	for _, category in pairs(tmp) do
		local categoryTab = GLANCE_PRESETS_CATEGORY[category];
		local categoryListElementTarget = {category, {}};
		-- Glance
		for _, glance in pairs(categoryTab) do
			local glanceInfo = GLANCE_PRESETS[glance];
			tinsert(categoryListElementTarget[2], {getIcon(glanceInfo.icon, 20) .. " " .. tostring(glanceInfo.title),
				{
					{loc.CM_LOAD, LOAD_PREFIX .. glance},
					{loc.CM_REMOVE, REMOVE_PREFIX .. glance}
				}
			});
		end
		tinsert(output, categoryListElementTarget);
	end

	return output;
end
TRP3_API.register.glance.getSlotPresetDataForList = getSlotPresetDataForList;

local function swapDataFromSlots(dataTab, from, to)
	if not dataTab.PE then return; end
	local fromData = dataTab.PE[from];
	local toData = dataTab.PE[to];
	dataTab.PE[from] = toData;
	dataTab.PE[to] = fromData;
	-- version increment
	dataTab.v = Utils.math.incrementNumber(dataTab.v or 1, 2);
end
TRP3_API.register.glance.swapDataFromSlots = swapDataFromSlots;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance slot context menu population
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- GLANCE_MENU_FLAG_PRESETS indicates the dropdown entries should include
--  options for managing presets.
local GLANCE_MENU_FLAG_PRESETS = 0x01;

--- GLANCE_MENU_FLAG_CLIPBOARD indicates dropdown entries should include
--  options for copying and pasting glances.
local GLANCE_MENU_FLAG_CLIPBOARD = 0x02;

--- GLANCE_MENU_FLAGSET_DEFAULT is a set of flags used by default when
--  populating a list for the glance context menu.
local GLANCE_MENU_FLAGSET_DEFAULT = bit.bor(GLANCE_MENU_FLAG_CLIPBOARD);

--- GLANCE_MENU_FLAGSET_IS_MINE is a set of flags used when populating
--  the preset context menu for a glance owned by the user.
local GLANCE_MENU_FLAGSET_IS_USER = bit.bor(GLANCE_MENU_FLAGSET_DEFAULT, GLANCE_MENU_FLAG_PRESETS);

--- GLANCE_MENU_ENTRY_HANDLERS is a mapping of menu entry value IDs to
--  functions to be called by dispatchGlanceMenuEntryAction.
local GLANCE_MENU_ENTRY_HANDLERS = {};

--- getGlanceMenuEntries returns a table containing a list of entries
--  displayable in a context menu for a slot.
--
--  The entries returned can be filtered by passing flags into this function.
--  By default, only the flags present in GLANCE_MENU_FLAGSET_DEFAULT are
--  used if none are passed.
--
--  @param button The button that will own the menu.
--  @param ... Flags indicating the entries to include. Multiple flags can be
--             passed and will be OR'd together automatically.
local function getGlanceMenuEntries(button, ...)
	-- You can either pass a single flag or multiple - we'll combine them
	-- automatically.
	local flags = (...) and bit.bor(...) or GLANCE_MENU_FLAGSET_DEFAULT;

	-- Create a new table for the entries on call.
	--
	-- If table churn is an issue, I think this should be resolved at a dropdown
	-- level - it'd be nice if the dropdown code could take an iterator in
	-- the values position and build a list that way and recycle appropriately.
	local entries = {}

	-- Mirror the clipboard management items.
	if bit.band(flags, GLANCE_MENU_FLAG_CLIPBOARD) ~= 0 then
		TRP3_API.register.glance.getGlanceMenuClipboardEntries(button, entries);
	end

	-- Mirror the presets.
	if bit.band(flags, GLANCE_MENU_FLAG_PRESETS) ~= 0 then
		TRP3_API.register.glance.getSlotPresetDataForList(entries);
	end

	return entries;
end
TRP3_API.register.glance.getGlanceMenuEntries = getGlanceMenuEntries;

--- dispatchGlanceMenuEntryAction attempts to dispatch any registered handler
--  belonging to the given key. If there is no exact match for a given key,
--  a prefix check will be applied up-to the first occurence of a colon.
--
--  @param key The key of the entry to be dispatched.
--  @param ... Additional arguments to pass to the handler.
--  @return True if a handler exists and was called.
local function dispatchGlanceMenuEntryAction(key, ...)
	-- Search the key up-to the first colon for advanced items.
	local keyPrefix = tostring(key):match("^[^:]+");

	local handler = GLANCE_MENU_ENTRY_HANDLERS[key] or GLANCE_MENU_ENTRY_HANDLERS[keyPrefix];
	if handler then
		handler(key, ...);
		return true;
	end
end
TRP3_API.register.glance.dispatchGlanceMenuEntryAction = dispatchGlanceMenuEntryAction;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance editor clipboard management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- GLANCE_MENU_ENTRY_CLIPBOARD_COPY_PREFIX is the prefix for menu actions
--  that should trigger a copy glance operation.
local GLANCE_MENU_ENTRY_CLIPBOARD_COPY_PREFIX = "clipboard/copy";

--- GLANCE_MENU_ENTRY_CLIPBOARD_PASTE_PREFIX is the prefix for menu actions
--  that should trigger a paste glance operation.
local GLANCE_MENU_ENTRY_CLIPBOARD_PASTE_PREFIX = "clipboard/paste";

--- GLANCE_MENU_CLIPBOARD_ID_CHARACTER is the key used by the clipboard
--  for storing and retrieving a glance slot of a character.
local GLANCE_MENU_CLIPBOARD_ID_CHARACTER = "CHARACTER";

--- GLANCE_MENU_CLIPBOARD_ID_CHARACTER is the key used by the clipboard
--  for storing and retrieving a glance slot of a companion.
local GLANCE_MENU_CLIPBOARD_ID_COMPANION = "COMPANION";

--- clipboardCurrentEntries holds the current clipboard selections for
--  player and companion profiles.
local clipboardCurrentEntries = {
	-- Preallocate the slots and document the fact we use them.
	[GLANCE_MENU_CLIPBOARD_ID_CHARACTER] = nil,
	[GLANCE_MENU_CLIPBOARD_ID_COMPANION] = nil,
};

--- getGlanceMenuClipboardEntries populates a given output list with items
--  suitable for use on a context menu dropdown.
--
--  The entries will always contain a "Copy" item that copies a slot
--  into our local store, and will include a "Paste" item if there is data
--  in the clipboard.
--
--  The button passed to this function must have a global name, or no entries
--  are added. This is because we rely on the button to access the data of the
--  entry to copy.
--
--  @param button The button that will own the dropdown menu. Must have a
--                global name.
--  @param output The list of entries to append our own menu items to.
local function getGlanceMenuClipboardEntries(button, output)
	-- If the button has no name we'll fail because we can't do a copy,
	-- and I don't much trust our chances of doing a paste either.
	if not button:GetName() then
		return;
	end

	-- What clipboard section should we be dealing with here?
	local clipboardType = (button.targetType == TYPE_CHARACTER)
		and GLANCE_MENU_CLIPBOARD_ID_CHARACTER
		or GLANCE_MENU_CLIPBOARD_ID_COMPANION;

	-- Create a key for the copy entry of the form "prefix:type,buttonName".
	-- Only do this if the button has a data member.
	if button.data then
		local copyKey = string.format("%s:%s,%s",
			GLANCE_MENU_ENTRY_CLIPBOARD_COPY_PREFIX,
			clipboardType,
			button:GetName()
		);

		tinsert(output, { loc.REG_PLAYER_GLANCE_MENU_COPY, copyKey });
	end

	-- The paste operation should only be present if you have something,
	-- and if this is your own profile.
	--
	-- As this is a destructive operation potentially, we'll also validate
	-- the slot ID is present since defaulting it could silently misbehave.
	if not clipboardCurrentEntries[clipboardType] or not button.isCurrentMine or not button.slot then
		return;
	end

	-- Paste key follows the same principle as the copy key except in the
	-- form "prefix:type,slot[,target,profile]".
	local pasteKey = string.format("%s:%s,%s,%s,%s",
		GLANCE_MENU_ENTRY_CLIPBOARD_PASTE_PREFIX,
		clipboardType,
		button.slot,
		button.targetID or "",
		button.profileID or ""
	);

	-- We'll also put the name of the item that you'd paste into the menu
	-- so that you have a rough idea on what would happen.
	local pasteName = clipboardCurrentEntries[clipboardType].TI or "";
	tinsert(output, { loc.REG_PLAYER_GLANCE_MENU_PASTE:format(pasteName), pasteKey });
end
TRP3_API.register.glance.getGlanceMenuClipboardEntries = getGlanceMenuClipboardEntries;

--- onGlanceMenuCopySelected is called when the "Copy" item in a glance slot
--  menu is clicked. Rather self-explanatorily, it'll copy the item.
--
--  @param key The key of the menu item itself with comma-delimited parameters
--             of the form "prefix:type,button".
local function onGlanceMenuCopySelected(key)
	-- Split the key up into its little bits.
	local segments = key:match(":(.+)$");
	local typeID, buttonName = strsplit(",", segments);

	-- Don't do much of anything if the key is malformed.
	if not typeID or not buttonName then
		return;
	end

	-- Copy the data stored on the button itself.
	local button = _G[buttonName];
	if not button then
		return;
	end

	clipboardCurrentEntries[typeID] = {};
	Utils.table.copy(clipboardCurrentEntries[typeID], button.data);
end

--- onGlanceMenuCopySelected is called when the "Paste" item in a glance slot
--  menu is clicked. To no great surprise, this handles pasting the data
--  in our clipboard to the slot in question.
--
--  @param key The key of the menu item itself with comma-delimited parameters
--             of the form "prefix:type,slot[,target,profile]".
local function onGlanceMenuPasteSelected(key)
	-- Split the key up into its little bits.
	local segments = key:match(":(.+)$");
	local typeID, slotID, targetID, profileID = strsplit(",", segments);

	-- Nil out the optionals if they aren't a thing.
	targetID = (targetID ~= "") and targetID or nil;
	profileID = (profileID ~= "") and profileID or nil;

	-- Ignore broken keys.
	if not typeID or not slotID then
		return;
	end

	-- Get the data to be pasted, if there are none we'll do nothing.
	local pasteData = clipboardCurrentEntries[typeID];
	if not pasteData then
		return;
	end

	-- Dispatch the correct update function.
	local updateFunc;
	if typeID == GLANCE_MENU_CLIPBOARD_ID_CHARACTER then
		updateFunc = TRP3_API.register.applyPeekSlot;
	elseif typeID == GLANCE_MENU_CLIPBOARD_ID_COMPANION then
		updateFunc = TRP3_API.companions.player.applyPeekSlot;
	else
		-- Bad type ID, can't update.
		return;
	end

	return updateFunc(slotID, pasteData.IC, pasteData.AC, pasteData.TI, pasteData.TX, false, targetID, profileID);
end

-- Register the handlers in the table.
GLANCE_MENU_ENTRY_HANDLERS[GLANCE_MENU_ENTRY_CLIPBOARD_COPY_PREFIX] = onGlanceMenuCopySelected;
GLANCE_MENU_ENTRY_HANDLERS[GLANCE_MENU_ENTRY_CLIPBOARD_PASTE_PREFIX] = onGlanceMenuPasteSelected;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance slot presets
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function removeSlotPreset(presetID)
	assert(GLANCE_PRESETS[presetID], "Unknown glance preset: " .. tostring(presetID));
	local name = GLANCE_PRESETS[presetID].title;
	local icon = GLANCE_PRESETS[presetID].icon;
	wipe(GLANCE_PRESETS[presetID]);
	GLANCE_PRESETS[presetID] = nil;
	for category, categoryTab in pairs(GLANCE_PRESETS_CATEGORY) do
		local found = tableRemove(categoryTab, presetID);
		if found and #categoryTab == 0 then
			wipe(GLANCE_PRESETS_CATEGORY[category]);
			GLANCE_PRESETS_CATEGORY[category] = nil;
		end
	end
	presetMessage(loc.REG_PLAYER_GLANCE_PRESET_REMOVE:format(Utils.str.icon(icon, 15) .. " " .. name), 3);
end
TRP3_API.register.glance.removeSlotPreset = removeSlotPreset;

local function saveSlotPreset(glanceTab)
	if glanceTab == nil then return end;
	local presetTitle = glanceTab.TI or UNKNOWN;
	local presetText = glanceTab.TX or "";
	local presetIcon = glanceTab.IC or Globals.icons.unknown;
	local presetID = Utils.str.id();

	local icon = Utils.str.icon(presetIcon, 25) .. "\n|cff00ff00" .. presetTitle .. "|r";
	TRP3_API.popup.showTextInputPopup(loc.REG_PLAYER_GLANCE_PRESET_GET_CAT:format(icon), function(presetCategory)
		if not presetCategory or presetCategory:len() == 0 then
			presetMessage(loc.REG_PLAYER_GLANCE_PRESET_ALERT1, 2);
			return;
		end
		GLANCE_PRESETS[presetID] = {};
		GLANCE_PRESETS[presetID].icon = presetIcon;
		GLANCE_PRESETS[presetID].title = presetTitle;
		GLANCE_PRESETS[presetID].text = presetText;
		if not GLANCE_PRESETS_CATEGORY[presetCategory] then
			GLANCE_PRESETS_CATEGORY[presetCategory] = {};
		end
		tinsert(GLANCE_PRESETS_CATEGORY[presetCategory], presetID);
		presetMessage(loc.REG_PLAYER_GLANCE_PRESET_ADD:format(Utils.str.icon(presetIcon, 15) .. " " .. presetTitle), 3);
	end);
end
TRP3_API.register.glance.saveSlotPreset = saveSlotPreset;

function TRP3_API.register.inits.glanceInit()
	if not TRP3_Presets then
		TRP3_Presets = {};
	end
	if not TRP3_Presets.peek then
		TRP3_Presets.peek = {};
	end
	if not TRP3_Presets.peekCategory then
		TRP3_Presets.peekCategory = {};
	end
	GLANCE_PRESETS = TRP3_Presets.peek;
	GLANCE_PRESETS_CATEGORY = TRP3_Presets.peekCategory;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance editor section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local stEtN = Utils.str.emptyToNil;

local function onIconSelected(icon)
	icon = icon or Globals.icons.default;
	setupIconButton(TRP3_AtFirstGlanceEditorIcon, icon);
	TRP3_AtFirstGlanceEditorIcon.icon = icon;
end

local function openGlanceEditor(slot, slotData, callback, external, arg1, arg2)
	assert(callback, "No callback for glance editor");

	TRP3_AtFirstGlanceEditorTitle:SetText(loc.REG_PLAYER_GLANCE_EDITOR:format(slot));
	TRP3_AtFirstGlanceEditorActive:SetChecked(slotData.AC);
	TRP3_AtFirstGlanceEditorTextScrollText:SetText(slotData.TX or "");
	TRP3_AtFirstGlanceEditorName:SetText(slotData.TI or "");
	TRP3_AtFirstGlanceEditorApply:SetScript("OnClick", function()
		callback(
			slot,
			TRP3_AtFirstGlanceEditorIcon.icon,
			TRP3_AtFirstGlanceEditorActive:GetChecked(),
			stEtN(TRP3_AtFirstGlanceEditorName:GetText()),
			stEtN(TRP3_AtFirstGlanceEditorTextScrollText:GetText()),
			nil, -- No swap
			arg1, arg2
		);
	end);
	TRP3_AtFirstGlanceEditorName:SetFocus();
	TRP3_AtFirstGlanceEditorName:HighlightText();

	TRP3_AtFirstGlanceEditorIcon.isExternal = external;
	TRP3_AtFirstGlanceEditorIcon:SetScript("OnClick", function(self)
		TRP3_API.popup.hideIconBrowser();
		if self.isExternal then
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, {parent = TRP3_AtFirstGlanceEditor, point = "RIGHT", parentPoint = "LEFT"}, {onIconSelected, nil, 0.75});
		else
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {onIconSelected});
		end
	end);
	onIconSelected(slotData.IC);
	TRP3_API.popup.hideIconBrowser();
end
TRP3_API.register.glance.openGlanceEditor = openGlanceEditor;



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Glance bar module section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
local getUnitID, companionIDToInfo = Utils.str.getUnitID, Utils.str.companionIDToInfo;
local get, getDataDefault = TRP3_API.profile.getData, TRP3_API.profile.getDataDefault;
local hasProfile, isUnitIDKnown, getUnitIDCurrentProfile = TRP3_API.register.hasProfile, TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCurrentProfile;
local getCompanionProfile, getCompanionRegisterProfile = TRP3_API.companions.player.getCompanionProfile, TRP3_API.companions.register.getCompanionProfile;
local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
local isIDIgnored = TRP3_API.register.isIDIgnored;

local ui_GlanceBar;

-- Always build UI on init. Because maybe other modules would like to anchor it on start.
local function onInit()
	ui_GlanceBar = CreateFrame("Frame", "TRP3_GlanceBar", UIParent, "TRP3_GlanceBarTemplate");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_TOOLTIP_CROP = 400;
local GLANCE_TITLE_CROP = 150;

local currentTargetID, currentTargetType, isCurrentMine;

local function getCharacterInfo()
	if currentTargetID == Globals.player_id then
		return get("player") or EMPTY;
	elseif isUnitIDKnown(currentTargetID) and hasProfile(currentTargetID) then
		return getUnitIDCurrentProfile(currentTargetID) or EMPTY;
	end
	return EMPTY;
end

local function getCompanionInfo(owner, companionID, currentTargetId)
	local profile;
	if owner == Globals.player_id then
		profile = getCompanionProfile(companionID) or EMPTY;
	else
		profile = getCompanionRegisterProfile(currentTargetId) or EMPTY;
	end
	return profile;
end

local function getGlanceTab()
	if currentTargetType == TYPE_CHARACTER then
		if isIDIgnored(currentTargetID) or unitIDIsFilteredForMatureContent(currentTargetID) then
			return;
		end
		return getDataDefault("misc/PE", EMPTY, getCharacterInfo());
	elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
		local owner, companionID = companionIDToInfo(currentTargetID);
		if isIDIgnored(owner) or unitIDIsFilteredForMatureContent(currentTargetID) then
			return;
		end
		return getCompanionInfo(owner, companionID, currentTargetID).PE;
	end
end

local function atLeastOneactiveGlance(tab)
	for _, info in pairs(tab) do
		if type(info) == "table" and info.AC then
			return true;
		end
	end
	return false;
end

local function getTargetType()
	return originalGetTargetType("target");
end

local function getOnGlanceEditorConfirmFunction(button)
	if button.targetType == TYPE_CHARACTER then
		return TRP3_API.register.applyPeekSlot;
	end
	return TRP3_API.companions.player.applyPeekSlot;
end

local function onGlanceSelection(presetAction, button)
	if presetAction == nil then return end -- Cancel button

	local slot = button.data;

	if presetAction == -1 then
		saveSlotPreset(slot);
		return;
	end

	-- If we've got a handler in the dispatcher table then this'll call it
	-- and return a truthy value of some description.
	if dispatchGlanceMenuEntryAction(presetAction, button) then
		return;
	end

	if type(presetAction) == "string" then
		local action = presetAction:sub(1, 1);
		if action == LOAD_PREFIX then
			local presetID = presetAction:sub(2);
			assert(GLANCE_PRESETS[presetID], "Unknown peek preset: " .. tostring(presetID));
			local preset = GLANCE_PRESETS[presetID];
			getOnGlanceEditorConfirmFunction(button)(button.slot, preset.icon, true, preset.title, preset.text, false, button.targetID, button.profileID);
		elseif action == REMOVE_PREFIX then
			removeSlotPreset(presetAction:sub(2));
		end
	end
end

local function onGlanceSlotClick(button, clickType)
	if clickType == "LeftButton" and button.isCurrentMine then
		if IsShiftKeyDown() then
			local glanceTab = getDataDefault("misc/PE", EMPTY, get("player") or EMPTY);
			local glance = glanceTab[button.slot];
			if glance and glance.AC then
				TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_GLANCE, function(canBeImported)
					TRP3_API.AtFirstGlanceChatLinksModule:InsertLink(glance, canBeImported);
				end);
			end
		else

			if TRP3_AtFirstGlanceEditor:IsVisible() and TRP3_AtFirstGlanceEditor.current == button then
				TRP3_AtFirstGlanceEditor:Hide();
			else
				local _, y = GetCursorPosition();
				local scale = UIParent:GetEffectiveScale();
				y = y / scale;
				TRP3_API.ui.frame.configureHoverFrame(TRP3_AtFirstGlanceEditor, button, y <= 200 and "BOTTOM" or "TOP");
				TRP3_AtFirstGlanceEditor.current = button;
				openGlanceEditor(button.slot, button.data or button.glanceTab[button.slot] or {}, getOnGlanceEditorConfirmFunction(button), TRP3_AtFirstGlanceEditor, button.targetID, button.profileID);
			end
		end
	elseif clickType == "RightButton" then
		-- Pick the right set of flags for getting the entries used in the menu.
		local flags = GLANCE_MENU_FLAGSET_DEFAULT;
		if button.isCurrentMine then
			flags = GLANCE_MENU_FLAGSET_IS_USER;
		end

		local values = getGlanceMenuEntries(button, flags);
		local onSelected = function(value) onGlanceSelection(value, button) end;

		if #values > 0 then
			displayDropDown(button, values, onSelected, 0, true);
		end
	end
end
TRP3_API.register.glance.onGlanceSlotClick = onGlanceSlotClick;
local function onGlanceDoubleClick(button, clickType)
	if button.isCurrentMine and clickType == "LeftButton" then
		getOnGlanceEditorConfirmFunction(button)(button.slot, nil, nil, nil, nil, true, button.targetID, button.profileID);
	end
end
TRP3_API.register.glance.onGlanceDoubleClick = onGlanceDoubleClick;

local CONFIG_GLANCE_TT_ANCHOR = "CONFIG_GLANCE_TT_ANCHOR";

local function configTooltipAnchor()
	return getConfigValue(CONFIG_GLANCE_TT_ANCHOR);
end

local function displayGlanceSlots()
	local glanceTab = getGlanceTab();

	if glanceTab ~= nil and (isCurrentMine or atLeastOneactiveGlance(glanceTab)) then
		ui_GlanceBar:Show();
		for i=1,5,1 do
			local button = _G["TRP3_GlanceBarSlot"..i];
			local glance = glanceTab[tostring(i)];
			button.data = glance;
			button.glanceTab = glanceTab;

			local icon = Globals.icons.default;

			if glance and glance.AC then
				button:SetAlpha(1);
				if glance.IC and glance.IC:len() > 0 then
					icon = glance.IC;
				end
				local TTText = glance.TX or "...";
				local glanceTitle = glance.TI or "...";
				if not isCurrentMine and shouldCropTexts() then
					TTText = crop(TTText, GLANCE_TOOLTIP_CROP);
					glanceTitle = crop(glanceTitle, GLANCE_TITLE_CROP);
				end
				TTText = "|cffff9900" .. TTText;
				setTooltipForSameFrame(button, configTooltipAnchor(), 0, 0, Utils.str.icon(icon, 30) .. " " .. glanceTitle, TTText);
			else
				button:SetAlpha(0.25);
				setTooltipForSameFrame(button);
			end

			Utils.texture.applyRoundTexture("TRP3_GlanceBarSlot" .. i .. "Image", "Interface\\ICONS\\" .. icon);
			button.isCurrentMine = isCurrentMine;
		end
	end
end

local function onGlanceDragStart(button)
	if button.isCurrentMine and button.data then
		SetCursor("Interface\\ICONS\\" .. (button.data.IC or Globals.icons.default));
	end
end
TRP3_API.register.glance.onGlanceDragStart = onGlanceDragStart;

local function onGlanceDragStop(button)
	ResetCursor();
	if button.isCurrentMine and button and button.slot then
		local from, to = button.slot;
		local toButton = GetMouseFocus();
		if toButton.slot then
			to = toButton.slot;
			if to ~= from then
				if button.targetType == TYPE_CHARACTER then
					TRP3_API.register.swapGlanceSlot(from, to);
				else
					TRP3_API.companions.player.swapGlanceSlot(from, to, button.targetID, button.profileID);
				end
			end
		end
	end
end
TRP3_API.register.glance.onGlanceDragStop = onGlanceDragStop;

local function onTargetChanged()
	ui_GlanceBar:Hide();
	TRP3_AtFirstGlanceEditor:Hide();
	currentTargetType, isCurrentMine = getTargetType();
	currentTargetID = nil;
	if currentTargetType == TYPE_CHARACTER then
		currentTargetID = getUnitID("target");
	elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
		currentTargetID = getCompanionFullID("target", currentTargetType);
	end
	for i=1,5,1 do
		local slot = _G["TRP3_GlanceBarSlot"..i];
		slot.targetType = currentTargetType;
		slot.targetID = currentTargetID;
	end
	if currentTargetID then
		displayGlanceSlots();
	end
end

local function onStart()

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Config - Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local UIParent, GetCursorPosition, TargetFrame = UIParent, GetCursorPosition, TargetFrame;
	unitIDIsFilteredForMatureContent = TRP3_API.register.unitIDIsFilteredForMatureContent;

	local CONFIG_GLANCE_PARENT = "CONFIG_GLANCE_PARENT";
	local CONFIG_GLANCE_LOCK = "CONFIG_GLANCE_LOCK";
	local CONFIG_GLANCE_ANCHOR_X = "CONFIG_GLANCE_ANCHOR_X";
	local CONFIG_GLANCE_ANCHOR_Y = "CONFIG_GLANCE_ANCHOR_Y";

	local function getParentFrame()
		return _G[getConfigValue(CONFIG_GLANCE_PARENT)] or TargetFrame;
	end

	local function replaceBar()
		local parentFrame = getParentFrame();
		local parentScale = UIParent:GetEffectiveScale();
		ui_GlanceBar:SetParent(parentFrame);
		ui_GlanceBar:ClearAllPoints();
		ui_GlanceBar:SetPoint("BOTTOM", parentFrame, "BOTTOM", getConfigValue(CONFIG_GLANCE_ANCHOR_X) / parentScale, getConfigValue(CONFIG_GLANCE_ANCHOR_Y) / parentScale);
	end

	-- Function called when the glance bar is dragged
	local function glanceBar_DraggingFrame_OnUpdate(self)
		if not getConfigValue(CONFIG_GLANCE_LOCK) and self.isDraging then
			local parentFrame = getParentFrame();
			local scaleFactor = UIParent:GetEffectiveScale();
			local xpos, ypos = GetCursorPosition();
			local xmin, ymin = parentFrame:GetLeft(), parentFrame:GetBottom();

			xpos = xpos - xmin * scaleFactor;
			ypos = ypos - ymin * scaleFactor;

			-- Setting the minimap coordinates
			setConfigValue(CONFIG_GLANCE_ANCHOR_X, xpos);
			setConfigValue(CONFIG_GLANCE_ANCHOR_Y, ypos);

			replaceBar();
		end
	end

	registerConfigKey(CONFIG_GLANCE_PARENT, "TRP3_TargetFrame");
	registerConfigKey(CONFIG_GLANCE_ANCHOR_X, 0);
	registerConfigKey(CONFIG_GLANCE_ANCHOR_Y, -14);
	registerConfigKey(CONFIG_GLANCE_LOCK, true);
	registerConfigKey(CONFIG_GLANCE_TT_ANCHOR, "LEFT");
	registerConfigHandler({CONFIG_GLANCE_PARENT}, replaceBar);
	registerConfigHandler({CONFIG_GLANCE_TT_ANCHOR}, onTargetChanged);
	replaceBar();
	ui_GlanceBar:SetScript("OnUpdate", glanceBar_DraggingFrame_OnUpdate);

	function TRP3_API.register.resetGlanceBar()
		setConfigValue(CONFIG_GLANCE_PARENT, "TRP3_TargetFrame");
		setConfigValue(CONFIG_GLANCE_ANCHOR_X, 0);
		setConfigValue(CONFIG_GLANCE_ANCHOR_Y, -14);
		replaceBar();
	end

	-- Config must be built on WORKFLOW_ON_LOADED or else the TargetFrame module could be not yet loaded.
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.CO_GLANCE_MAIN,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigEditBox",
			title = loc.CO_MINIMAP_BUTTON_FRAME,
			configKey = CONFIG_GLANCE_PARENT,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_GLANCE_LOCK,
			help = loc.CO_GLANCE_LOCK_TT,
			configKey = CONFIG_GLANCE_LOCK,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigButton",
			title = loc.CO_MINIMAP_BUTTON_RESET,
			help = loc.CO_GLANCE_RESET_TT,
			text = loc.CO_MINIMAP_BUTTON_RESET_BUTTON,
			callback = TRP3_API.register.resetGlanceBar,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigButton",
			title = loc.CO_GLANCE_PRESET_TRP2,
			text = loc.CO_GLANCE_PRESET_TRP2_BUTTON,
			help = loc.CO_GLANCE_PRESET_TRP2_HELP,
			callback = function()
				setConfigValue(CONFIG_GLANCE_PARENT, "TargetFrame");
				setConfigValue(CONFIG_GLANCE_ANCHOR_X, 161);
				setConfigValue(CONFIG_GLANCE_ANCHOR_Y, 31);
				replaceBar();
			end,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigDropDown",
			widgetName = "TRP3_ConfigurationTooltip_GlanceTT_Anchor",
			title = loc.CO_GLANCE_TT_ANCHOR,
			listContent = {
				{loc.CO_ANCHOR_TOP_LEFT, "TOPLEFT"},
				{loc.CO_ANCHOR_TOP, "TOP"},
				{loc.CO_ANCHOR_TOP_RIGHT, "TOPRIGHT"},
				{loc.CO_ANCHOR_RIGHT, "RIGHT"},
				{loc.CO_ANCHOR_BOTTOM_RIGHT, "BOTTOMRIGHT"},
				{loc.CO_ANCHOR_BOTTOM, "BOTTOM"},
				{loc.CO_ANCHOR_BOTTOM_LEFT, "BOTTOMLEFT"},
				{loc.CO_ANCHOR_LEFT, "LEFT"}
			},
			configKey = CONFIG_GLANCE_TT_ANCHOR,
			listWidth = nil,
			listCancel = true,
		});
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
		if not unitID or (currentTargetID == unitID) and (not dataType or dataType == "misc") then
			onTargetChanged();
		end
	end);

	for i=1,5,1 do
		local slot = _G["TRP3_GlanceBarSlot"..i];
		slot.slot = tostring(i);
		slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		slot:RegisterForDrag("LeftButton");
		slot:SetScript("OnDragStart", onGlanceDragStart);
		slot:SetScript("OnDragStop", onGlanceDragStop);
		slot:SetScript("OnClick", onGlanceSlotClick);
		slot:SetScript("OnDoubleClick", onGlanceDoubleClick);

		-- Display indications in the tooltip on how to create a chat link
		Ellyb.Tooltips.getTooltip(slot):AddLine(
				Ellyb.Strings.clickInstruction(
						Ellyb.System:FormatKeyboardShortcut(Ellyb.System.MODIFIERS.SHIFT, Ellyb.System.CLICKS.CLICK),
						loc.CL_TOOLTIP
				)
		)
	end
end

local MODULE_STRUCTURE = {
	["name"] = "\"At first glance\" bar",
	["description"] = "Add a bar showing the content of the target's \"At first glance\".",
	["version"] = 1.000,
	["id"] = "trp3_glance_bar",
	["onStart"] = onStart,
	["onInit"] = onInit,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
