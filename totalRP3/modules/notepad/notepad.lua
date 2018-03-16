----------------------------------------------------------------------------------
-- Total RP 3
-- Module: Notepad
-- ---------------------------------------------------------------------------
-- Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
-- Copyright 2017 Enno Ritz (Rien) (Ascathor@web.de)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

-- ---------------
-- Public Accessor
-- ---------------
TRP3_API.module.notepad = {};

-- --------------------------
-- Define global dependencies
-- --------------------------
local Globals = TRP3_API.globals;
local displayMessage = TRP3_API.utils.message.displayMessage;
local loc = TRP3_API.locale.getText;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local Notepad = TRP3_API.module.notepad;
local icon, color = TRP3_API.utils.str.icon, TRP3_API.utils.str.color;
local refreshTooltip = TRP3_API.ui.tooltip.refresh;
local playUISound = TRP3_API.ui.misc.playUISound;

-- -------------------
-- Initalize & Declare
-- -------------------
-- Create colored string with character name.
Notepad.coloredCharName = "|cff00ff00" .. UnitName("player").. "|r";

-- OnStart function for Module Activation. Initializes all requirements
local function onStart()
	-- First, validate the character's own note as string and make sure it's within 10k characters (to prevent crashes by modifying the addon cache)
	if TRP3_Module_Notepad_Char_Note ~= nil then
		if TRP3_API.module.notepad.ValidateNote(TRP3_Module_Notepad_Char_Note):len() > 10000 then
			displayMessage(loc("MODULE_NOTEPAD_WARNING_CHAR_LOAD_TEXT")):format(Notepad.coloredCharName);
			TRP3_Module_Notepad_Char_Note = TRP3_Module_Notepad_Char_Note:sub(1, 10000);
		end
	end

	-- Second, validate the account's note as string and make sure it's within 10k characters (to prevent crashes by modifying the addon cache)
	if TRP3_Module_Notepad_Acc_Note ~= nil then
		if TRP3_API.module.notepad.ValidateNote(TRP3_Module_Notepad_Acc_Note):len() > 10000 then
			displayMessage(loc("MODULE_NOTEPAD_WARNING_ACC_LOAD_TEXT"));
			TRP3_Module_Notepad_Acc_Note = TRP3_Module_Notepad_Acc_Note:sub(1, 10000);
		end
	end

	-- Set Help-Button after validation of notes, also set help and the localization for the texts
	setTooltipForSameFrame(TRP3_Notepad_Info, "BOTTOMRIGHT", 30, 22, loc("MODULE_NOTEPAD_HELP_TITLE"), loc("MODULE_NOTEPAD_HELP_TEXT"));
	-- Format the character and account text on start
	TRP3_MODULE_NOTEPAD_CHAR_TEXT:SetText(loc("MODULE_NOTEPAD_CHAR_TEXT"):format(Notepad.coloredCharName));
	TRP3_MODULE_NOTEPAD_ACC_TEXT:SetText(loc("MODULE_NOTEPAD_ACC_TEXT"));


	if TRP3_API.toolbar then
		local updateToolbarButton = TRP3_API.toolbar.updateToolbarButton;
	
		local NotepadIconOn = "INV_Misc_Note_03";
		local NotepadIconOff = "INV_Misc_Note_02";
		local NotepadTextOn = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_NOTEPAD_1");
		local NotepadTextOff = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_NOTEPAD_2");

		-- Create a button for the toolbar to show/hide the Notepad Button on the Dashboard.
		local Button_Notepad = {
			id = "aa_trp3_c_np",
			icon = "INV_Misc_Note_03",
			configText = loc("CO_TOOLBAR_CONTENT_NOTEPAD"),
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if TRP3_Notepad:IsVisible() then
					buttonStructure.tooltip = loc("TB_SWITCH_NOTEPAD_OFF");
					buttonStructure.tooltipSub = NotepadTextOff;
					buttonStructure.icon = NotepadIconOff;
				else
					buttonStructure.tooltip = loc("TB_SWITCH_NOTEPAD_ON");
					buttonStructure.tooltipSub = NotepadTextOn;
					buttonStructure.icon = NotepadIconOn;
				end
			end,
			onClick = function(Uibutton, buttonStructure, button)
				if TRP3_Notepad:IsVisible() then
					TRP3_Notepad:Hide();
				else
					TRP3_Notepad:Show();
				end
				playUISound("igMainMenuOptionCheckBoxOn");
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Notepad);
	end
end

-- ------------------
--  Utility functions
-- ------------------

-- Validate the given text to not be nil, but a string (empty or not)
TRP3_API.module.notepad.ValidateNote = function(text)
	return text or "";
end

-- Validate the given Char Note that is supposed to be saved
TRP3_API.module.notepad.ValidateCharNoteOnSave = function(charnote)
	if charnote ~= nil then
		if charnote:len() == 10000 then
			displayMessage(loc("MODULE_NOTEPAD_WARNING_CHAR_SAVE_TEXT"):format(Notepad.coloredCharName));
		end
		TRP3_MODULE_NOTEPAD_CHAR_NOTE = charnote;
	else
		DisplayMessage("Error! Invalid (nil) Note to save for Character Note.");
		return
	end
end

-- Validate the given Account Note that is supposed to be saved
TRP3_API.module.notepad.ValidateAccNoteOnSave = function(accnote)
	if accnote ~= nil then
		if accnote:len() == 10000 then
			displayMessage(loc("MODULE_NOTEPAD_WARNING_ACC_SAVE_TEXT"));
		end
		TRP3_MODULE_NOTEPAD_ACC_NOTE = accnote;
	else
		DisplayMessage("Error! Invalid (nil) Note to save for Account Note.");
		return
	end
end


-- MODULE_STRUCTURE as required to load the module up
local MODULE_STRUCTURE = {
	["name"] = "Notepad",
	["description"] = "Adds a notepad to the dashboard.",
	["version"] = 1.100,
	["id"] = "trp3_notepad",
	["onStart"] = onStart,
	["minVersion"] = 3,
};

-- Actual registration for module_management.lua on start (after init)
TRP3_API.module.registerModule(MODULE_STRUCTURE);
