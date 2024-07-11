-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local AddOn_TotalRP3 = AddOn_TotalRP3;
local Ellyb = TRP3_API.Ellyb
local Languages = {};
AddOn_TotalRP3.Languages = Languages;

---@type TRP3_API;
local _, TRP3_API = ...;

-- Imports
local refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local loc = TRP3_API.loc;
local Globals = TRP3_API.globals;
local GetNumLanguages, GetLanguageByIndex, GetDefaultLanguage = GetNumLanguages, GetLanguageByIndex, GetDefaultLanguage;

local Configuration = TRP3_API.configuration;

local LAST_LANGUAGE_USED = "chat_last_language_used";

---@return Language[]
function Languages.getAvailableLanguages()
	local languages = {}
	for i = 1, GetNumLanguages() do
		table.insert(languages, Languages.getLanguageByIndex(i))
	end
	return languages
end

---@return Language
function Languages.getDefaultLanguage()
	local name, id = GetDefaultLanguage()
	return AddOn_TotalRP3.Language(id, name)
end

---@return Language|nil
function Languages.getLanguageByID(languageID)
	for _, knownLanguage in ipairs(Languages.getAvailableLanguages()) do
		if knownLanguage:GetID() == languageID then
			return knownLanguage
		end
	end
end

function Languages.getLanguageByIndex(languageIndex)
	local name, id = GetLanguageByIndex(languageIndex)
	return AddOn_TotalRP3.Language(id, name)
end

---@param language Language
local function saveSelectedLanguageToCharacterData(language)
	Ellyb.Assertions.isInstanceOf(language, AddOn_TotalRP3.Language, "language");
	TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED] = language:GetID();
end

---Will set the language currently spoken by the player using a language ID
---@param language Language
function Languages.setLanguage(language)
	Ellyb.Assertions.isInstanceOf(language, AddOn_TotalRP3.Language, "language")
	TRP3_API.Log("Setting language " .. language:GetName());

	saveSelectedLanguageToCharacterData(language);

	for i = 1, 9 do
		if _G["ChatFrame"..i.."EditBox"] then
			_G["ChatFrame"..i.."EditBox"].languageID = language:GetID();
			_G["ChatFrame"..i.."EditBox"].language = language:GetName();
		end
	end
end

---@param languageID string
function Languages.setLanguageByID(languageID)
	local language = Languages.getLanguageByID(languageID)
	if not language then
		language = Languages.getDefaultLanguage()
		TRP3_API.Log("Trying to set a language that is not known by this character, going back to default language: " .. language);
	end
	Languages.setLanguage(language)
end

---@return Language
function Languages.getCurrentLanguage()
	return Languages.getLanguageByID(ChatFrame1EditBox.languageID)
end

function Languages.getSavedLanguage()
	if TRP3_Characters and TRP3_Characters[Globals.player_id] and TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED] then
		return Languages.getLanguageByID(TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED])
	end
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	if not TRP3_API.toolbar then return end;

	local languagesButton = {
		id = "ww_trp3_languages",
		icon = TRP3_InterfaceIcons.ToolbarLanguage,
		configText = loc.TB_LANGUAGE,
		onEnter = function(Uibutton)
			refreshTooltip(Uibutton);
		end,
		onUpdate = function(Uibutton, buttonStructure)
			TRP3_API.toolbar.updateToolbarButton(Uibutton, buttonStructure);
		end,
		onModelUpdate = function(buttonStructure)
			if buttonStructure.currentLanguageID ~= ChatFrame1EditBox.languageID then
				buttonStructure.currentLanguageID = ChatFrame1EditBox.languageID
				local currentLanguage = Languages.getCurrentLanguage()
				buttonStructure.currentLanguageID = currentLanguage:GetID();
				buttonStructure.tooltip = loc.TB_LANGUAGE .. ": " .. currentLanguage:GetName();
				buttonStructure.tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_LANGUAGES_TT);
				buttonStructure.icon = currentLanguage:GetIcon():GetFileName() or TRP3_InterfaceIcons.ToolbarLanguage;
			end
		end,
		onMouseDown = function(Uibutton)
			TRP3_MenuUtil.CreateContextMenu(Uibutton, function(_, description)
				description:CreateTitle(loc.TB_LANGUAGE);
				for _, language in ipairs(Languages.getAvailableLanguages()) do
					if language:IsActive() then
						description:CreateButton(language:GetIcon():GenerateString(15) .. " " .. TRP3_API.Colors.Green(language:GetName()));
					else
						description:CreateButton(language:GetIcon():GenerateString(15) .. " " .. language:GetName(), Languages.setLanguageByID, language:GetID());
					end
				end
			end);
		end,
		onLeave = function()
			mainTooltip:Hide();
		end,
	};
	TRP3_API.toolbar.toolbarAddButton(languagesButton);

	local function checkCurrentLanguageAndRestoreSavedState()
		local savedLanguage = Languages.getSavedLanguage()
		if not savedLanguage then
			return
		end
		if not savedLanguage:IsKnown() then
			local defaultLanguage = Languages.getDefaultLanguage()
			Languages.setLanguage(defaultLanguage)
			TRP3_API.utils.message.displayMessage(loc.LANG_CHANGE_CAUSED_REVERT_TO_DEFAULT:format(defaultLanguage:GetName(), savedLanguage:GetName()))
		else
			if Languages.getCurrentLanguage() ~= savedLanguage then
				Languages.setLanguage(savedLanguage)
			end
		end
	end

	-- Listen to events related to language changes and check that we are still able to speak the saved language
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "LANGUAGE_LIST_CHANGED", checkCurrentLanguageAndRestoreSavedState)

	if NeutralPlayerSelectFaction then
		TRP3_API.RegisterCallback(TRP3_API.GameEvents, "NEUTRAL_FACTION_SELECT_RESULT", checkCurrentLanguageAndRestoreSavedState)
	end

	-- If workaround for language reset is enabled, try to restore saved language when loading screen ended
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "LOADING_SCREEN_DISABLED", function()
		if Configuration.getValue(TRP3_API.ADVANCED_SETTINGS_KEYS.USE_WORKAROUND_FOR_LANGUAGE_RESET) then
			checkCurrentLanguageAndRestoreSavedState()
		end
	end)

	-- If the option to remember last language used is enabled, try to restore saved language after entering world
	if Configuration.getValue(TRP3_API.ADVANCED_SETTINGS_KEYS.REMEMBER_LAST_LANGUAGE_USED) then
		TRP3_API.RegisterCallback(TRP3_API.GameEvents, "PLAYER_ENTERING_WORLD", checkCurrentLanguageAndRestoreSavedState)
		-- We have to wait a little for everything to be fully loaded before trying to restore previously selected language
		C_Timer.After(1, checkCurrentLanguageAndRestoreSavedState)
	end
end);


-- Advanced settings
tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigH1",
	title = loc.CO_ADVANCED_LANGUAGES,
});

-- Remember last language used
TRP3_API.ADVANCED_SETTINGS_KEYS.REMEMBER_LAST_LANGUAGE_USED = "chat_language_remember_last_used";
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.REMEMBER_LAST_LANGUAGE_USED] = true;
tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigCheck",
	title = loc.CO_ADVANCED_LANGUAGES_REMEMBER,
	help = loc.CO_ADVANCED_LANGUAGES_REMEMBER_TT,
	configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.REMEMBER_LAST_LANGUAGE_USED,
});

-- Workaround for language resetting
-- Remember last language used
TRP3_API.ADVANCED_SETTINGS_KEYS.USE_WORKAROUND_FOR_LANGUAGE_RESET = "chat_language_enabled_workaround_for_language_reset";
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.USE_WORKAROUND_FOR_LANGUAGE_RESET] = true;
tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigCheck",
	title = loc.CO_ADVANCED_LANGUAGE_WORKAROUND,
	help = loc.CO_ADVANCED_LANGUAGE_WORKAROUND_TT,
	configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.USE_WORKAROUND_FOR_LANGUAGE_RESET,
});
