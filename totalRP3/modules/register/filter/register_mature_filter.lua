----------------------------------------------------------------------------------
--- Total RP 3
--- Mature profile filtering module
---
--- The mature profile filtering module will flag profiles containing specific
--- keywords related to mature content.
--- Flagged profiles will have a hasMatureContent boolean attached on them
--- so we can check in the code if a profile has mature content by doing
--- if profile.hasMatureContent then
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local function onStart()

	-- TRP3 API imports
	local Utils, Events, Register, UI, Config = TRP3_API.utils, TRP3_API.events, TRP3_API.register, TRP3_API.ui, TRP3_API.configuration;
	local getProfileByID = Register.getProfile;
	local getUnitIDProfile = Register.getUnitIDCurrentProfileSafe;
	local getUnitIDProfileID = Register.getUnitIDProfileID;
	local hasProfile = Register.hasProfile;
	local getProfileOrNil = TRP3_API.register.getProfileOrNil;
	local getUnitRPName = Register.getUnitRPNameWithID;
	local handleMouseWheel = UI.list.handleMouseWheel;
	local initList = UI.list.initList;
	local setTooltipForFrame = UI.tooltip.setTooltipForFrame;
	local playAnimation = UI.misc.playAnimation;
	local configureHoverFrame = UI.frame.configureHoverFrame;
	local getConfigValue = Config.getValue;
	local setConfigValue = Config.setValue;
	local registerConfigKey = Config.registerConfigKey;
	local registerConfigHandler = Config.registerHandler;
	local hidePopups = TRP3_API.popup.hidePopups;
	local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
	local log = Utils.log.log;
	local getUnitID = Utils.str.getUnitID;
	local loc = TRP3_API.loc;
	local player_id = TRP3_API.globals.player_id;

	-- API
	TRP3_API.register.mature_filter = {};

	local MATURE_FILTER_CONFIG = "register_mature_filter";
	local MATURE_FILTER_CONFIG_STRENGTH = "register_mature_filter_strength";

	-- Saved variables
	TRP3_MatureFilter = TRP3_MatureFilter or {
		whitelist = {},
		dictionary = nil
	}

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- WHITE LIST MANAGEMENT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local whiteList = TRP3_MatureFilter.whitelist;

	---
	-- Add a profile ID to the whitelist
	-- @param profileID
	--
	local function whitelistProfileID(profileID)
		assert(profileID, ("Trying to call whitelistProfileID with a nil profileID."));

		whiteList[profileID] = true;
	end

	TRP3_API.register.mature_filter.whitelistProfileID = whitelistProfileID;

	---
	-- Remove a profile from the white list
	-- @param profileID ID of the profile to remove
	--
	local function removeProfileIDFromWhiteList(profileID)
		assert(profileID, ("Trying to call removeProfileIDFromWhiteList with a nil profileID."));
		assert(whiteList[profileID], ("Profile %s is not currently in the whitelist."):format(profileID));

		whiteList[profileID] = nil;
	end

	---
	-- Check if a profile is white listed
	-- @param profileID ID of the profile to check
	--
	local function isProfileWhitelisted(profileID)
		return whiteList[profileID] or false;
	end

	TRP3_API.register.mature_filter.isProfileWhitelisted = isProfileWhitelisted;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- DICTIONARY MANAGEMENT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function resetDictionnary()
		TRP3_MatureFilter.dictionary = {};
		-- Insert every word of the default dictionnary
		for _, word in pairs(TRP3_API.utils.resources.getMatureFilterDictionary()) do
			TRP3_MatureFilter.dictionary[word] = 1;
		end
	end

	if not TRP3_MatureFilter.dictionary then
		resetDictionnary();
	end

	---
	-- Add a given word to the custom dictionary
	-- @param word
	--
	local function addWordToCustomDictionary(word)
		assert(word, ("Trying to call addWordToCustomDictionary with a nil word."));

		TRP3_MatureFilter.dictionary[word] = true;
	end

	---
	-- Add multiple words to the custom dictionary
	-- @param words A table or a string of words separated by spaces
	--
	local function addWordsToCustomDictionary(words)
		assert(words, ("Trying to call addWordsToCustomDictionary with a nil value."));
		assert(type(words) == "table" or type(words) == "string", ("Trying to call addWordsToCustomDictionary with a value that is neither a table nor a string."));

		if type(words) == "table" then
			for _, word in words do
				addWordToCustomDictionary(word);
			end
		elseif type(words) == "string" then
			for word in words:gmatch("[^%s%p]+") do
				addWordToCustomDictionary(word);
			end
		end
	end

	local function removeWordFromCustomDictionary(word)
		assert(word, ("Trying to call removeWordFromCustomDictionary with a nil word."));
		assert(TRP3_MatureFilter.dictionary[word], ("Trying to remove unkown word %s from custom dictionary."):format(word));

		TRP3_MatureFilter.dictionary[word] = nil;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- FLAGGING MANAGEMENT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	---
	-- Flag a profile has having mature content
	-- @param profileID The profile ID of the profile to flag
	--
	local function flagUnitProfileHasHavingMatureContent(profileID)
		assert(profileID, ("Trying to call flagUnitProfileHasHavingMatureContent with a nil profileID."));
		local profile = getProfileByID(profileID);
		profile.hasMatureContent = true;
		profile.lastMatureContentEvaluation = time();
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, nil, profileID, nil);
	end
	TRP3_API.register.mature_filter.flagUnitProfileHasHavingMatureContent = flagUnitProfileHasHavingMatureContent

	---
	-- Open a confirm popup to flag the profile of a give unit ID has having mature content.
	-- The popup also optionally asks for new words to put inside the dictionary.
	-- Will call flagUnitProfileHasHavingMatureContent(unitID) if the user confirm.
	-- @param unitID Unit ID to use to retreive the profile (Player-RealmName)
	--
	local function flagUnitProfileHasHavingMatureContentConfirm(unitID)
		assert(unitID, ("Trying to call flagUnitProfileHasHavingMatureContentConfirm with a nil unitID."));
		local profileID = getUnitIDProfileID(unitID);
		local unitName = getUnitRPName(unitID);

		showTextInputPopup(loc.MATURE_FILTER_FLAG_PLAYER_TEXT:format(unitName), function(text)
			-- If the user inserted words to add to the dicitonnary, we add them
			for word in text:gmatch("[^%s%p]+") do
				addWordToCustomDictionary(word);
			end

			-- Flag the profile of the unit has having mature content
			flagUnitProfileHasHavingMatureContent(profileID);
			-- Fire the event that the register has been updated so the UI stuff get refreshed
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
		end);
	end

	local function removeUnitProfileFromWhitelistConfirm(unitID)
		TRP3_API.popup.showConfirmPopup(loc.MATURE_FILTER_REMOVE_FROM_WHITELIST_TEXT:format(unitID), function()
			local profileID = getUnitIDProfileID(unitID);
			-- Flag the profile of the unit has having mature content
			removeProfileIDFromWhiteList(profileID);
			-- Fire the event that the register has been updated so the UI stuff get refreshed
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
		end);
	end

	---
	-- Open a confirm popup to add the profile of a given unit ID to the whitelist
	-- @param unitID
	--
	local function whitelistProfileByUnitIDConfirm(unitID, callback)
		local profileID = getUnitIDProfileID(unitID);

		TRP3_API.popup.showConfirmPopup(loc.MATURE_FILTER_ADD_TO_WHITELIST_TEXT:format(unitID), function()
			whitelistProfileID(profileID);
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
			if callback and type(callback) == "function" then callback() end;
		end);
	end

	TRP3_API.register.mature_filter.whitelistProfileByUnitIDConfirm = whitelistProfileByUnitIDConfirm;

	local function getBadWordsThreshold()
		return 11 - getConfigValue(MATURE_FILTER_CONFIG_STRENGTH);
	end
	---
	-- Returns true if the given text contains a word from our dictionnary
	-- @param text Text to search
	--
	local function textContainsMatureContent(text)
		local words = {};
		local badWordsFound = 0;
		local threshold = getBadWordsThreshold();
		-- Break string into a table
		for word in text:gmatch("[^%s%p]+") do
			-- We will use the lower case version of the words because our keywords are lowercased
			word = word:lower()
			-- If we already found this word in the string, increment the count for this word
			words[word] = (words[word] or 0) + 1;
		end
		-- Iterate through the matureWords dictionary
		for matureWord, _ in pairs(TRP3_MatureFilter.dictionary) do
			-- If the word is found, return true
			if words[matureWord] then
				log("Found |cff00ff00" .. matureWord .. "|r " .. words[matureWord] .. " times!", Utils.log.WARNING);
				badWordsFound = badWordsFound + 1;
				if badWordsFound >= threshold then
					return badWordsFound;
				end
			end
		end
		return badWordsFound;
	end

	-- This structure list the fields that must not be filtered
	local unfilteredFields = {
		IC = true, -- We do not fiter the user icon, obviously
	};

	---
	-- Go through a data table given and test its content to see if it contains mature content
	-- It will flag the given profile ID if any field of the data table contains mature content.
	-- @param data Table of data to test
	-- @param profileID Profile ID that will be flagged as having mature content
	--
	local function filterData(data, profileID)
		local numberOfBadWordsFound = 0;
		local threshold = getBadWordsThreshold();
		-- Iterate over each field of the data table
		for key, value in pairs(data) do
			-- Ommit fields we do not want to filter
			if not unfilteredFields[key] then
				-- If the value of the field is a string, we treat it
				if type(value) == "string" then
					numberOfBadWordsFound = numberOfBadWordsFound + textContainsMatureContent(value);
					if numberOfBadWordsFound >= threshold then
						break;
					end
				elseif type(value) == "table" then
					filterData(value, profileID);
				end
			end
		end

		if numberOfBadWordsFound >= threshold then
			flagUnitProfileHasHavingMatureContent(profileID);
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- DICTIONARY EDITOR
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local dictionaryEditor = TRP3_MatureDictionaryEditor;

	---
	-- Ask the scrolling list handler to (re)build the list
	local function refreshDictionaryList()
		initList(dictionaryEditor, TRP3_MatureFilter.dictionary, dictionaryEditor.content.slider);
	end

	---
	-- Decorate a line:
	-- Setup its tooltip, its text and store some value inside the frame
	-- @param lineFrame The line to decorate
	-- @param word The word associated to this line
	--
	function dictionaryEditor.decorate(lineFrame, word)
		setTooltipForFrame(
		lineFrame, lineFrame, "RIGHT", 0, -30, -- Tooltip position
		word, -- Tooltip title
		("\n|cffff9900%s: |cffffffff%s\n|cffff9900%s: |cffff0000%s"):format( -- Tooltip content
		loc.CM_L_CLICK,
		loc.MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD,
		loc.CM_R_CLICK,
		loc.MATURE_FILTER_EDIT_DICTIONARY_DELETE_WORD
		)
		);
		lineFrame.text:SetText(word);
		lineFrame.value = word;
	end

	---
	-- Open the word editor popup on a given line with the text field prepopulated with the word and focused,
	-- and remember the current line focused.
	-- @param lineFrame
	--
	local function showWordEditorPopup(lineFrame)
		dictionaryEditor.editPopup.currentLine = lineFrame;
		dictionaryEditor.editPopup.value = lineFrame.value;
		dictionaryEditor.editPopup.input:SetText(lineFrame.value);
		configureHoverFrame(dictionaryEditor.editPopup, lineFrame, "RIGHT", 0, 5, true);
		dictionaryEditor.editPopup.input:SetFocus();
	end

	---
	-- Hide the word editor popup and forget about the current line
	local function hideWordEditorPopup()
		dictionaryEditor.editPopup.currentLine = nil;
		dictionaryEditor.editPopup:Hide();
	end

	---
	-- Handle when clicking on a line in the dictionary editor
	-- @param lineFrame The line that was clicked
	-- @param mousebutton The mouse button used
	--
	local function onDictionaryLineClicked(lineFrame, mousebutton)
		-- LeftButton -> Edit the word
		if mousebutton == "LeftButton" then
			if dictionaryEditor.editPopup:IsVisible() and dictionaryEditor.editPopup.currentLine == lineFrame then
				hideWordEditorPopup();
			else
				showWordEditorPopup(lineFrame);
			end
			-- RightButton -> Delete the word
		elseif mousebutton == "RightButton" then
			removeWordFromCustomDictionary(lineFrame.value)
			refreshDictionaryList();
		end
	end

	---
	-- Function executed when a new word is entered in entered in the dictionary editor
	local function saveNewWordToDictionnary()
		local text = dictionaryEditor.addNewWord.input:GetText();
		if strtrim(text) == "" then return end;

		-- Play a little animation as a visual feedback that the user action as been registered
		playAnimation(dictionaryEditor.addNewWord.input.animation);

		-- Take each word inside the text input and add them to the dictionary
		addWordsToCustomDictionary(text);

		-- Refresh the list
		refreshDictionaryList();

		-- Clear the text input
		dictionaryEditor.addNewWord.input:SetText("");

		-- Always hide the word editor popup.
		-- As the list is refreshed, if it was opened it might be on the wrong line now
		hideWordEditorPopup();
	end

	---
	-- Function executed when the user submit the word editor popup
	local function editWord()
		-- Get the text the user entered
		local newText = dictionaryEditor.editPopup.input:GetText();

		-- Only treat it if it has changed
		if dictionaryEditor.editPopup.value ~= newText then
			-- Remove old value
			removeWordFromCustomDictionary(dictionaryEditor.editPopup.value);

			-- Add the words to the dictionary
			addWordsToCustomDictionary(newText)

			refreshDictionaryList();
		end

		hideWordEditorPopup();
	end

	-- Create lines
	dictionaryEditor.widgetTab = {};

	for line = 0, 8 do
		local lineFrame = CreateFrame("Button", "TRP3_MatureDictionaryEditorButton_" .. line, dictionaryEditor.content, "TRP3_MatureDictionaryLine");
		lineFrame:SetPoint("TOP", dictionaryEditor.content, "TOP", 0, -10 + (line * (-31)));
		lineFrame:SetScript("OnClick", onDictionaryLineClicked);
		tinsert(dictionaryEditor.widgetTab, lineFrame);
	end

	dictionaryEditor.title:SetText(loc.MATURE_FILTER_EDIT_DICTIONARY_TITLE);

	dictionaryEditor.addNewWord.button:SetText(loc.MATURE_FILTER_EDIT_DICTIONARY_ADD_BUTTON);
	dictionaryEditor.addNewWord.button:SetScript("OnClick", saveNewWordToDictionnary);
	dictionaryEditor.addNewWord.input:SetScript("OnEnterPressed", saveNewWordToDictionnary);
	dictionaryEditor.addNewWord.input.title:SetText(loc.MATURE_FILTER_EDIT_DICTIONARY_ADD_TEXT);

	dictionaryEditor.editPopup.title:SetText(loc.MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD);
	dictionaryEditor.editPopup.button:SetText(SAVE);
	dictionaryEditor.editPopup.button:SetScript("OnClick", editWord);
	dictionaryEditor.editPopup.input:SetScript("OnEnterPressed", editWord);

	dictionaryEditor.content.slider:SetValue(0);
	dictionaryEditor.content.slider.upButton:Disable();
	handleMouseWheel(dictionaryEditor.content, dictionaryEditor.content.slider);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- MATURE ALERT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_MatureFilterPopup.title:SetText(loc.MATURE_FILTER_WARNING_TITLE);
	TRP3_MatureFilterPopup.text:SetText(loc.MATURE_FILTER_WARNING_TEXT);

	-- Go back
	TRP3_MatureFilterPopup.cancel:SetText(loc.MATURE_FILTER_WARNING_GO_BACK);
	TRP3_MatureFilterPopup.cancel:SetScript("OnClick", function()
		-- Remove the current profile from the menu list
		TRP3_API.navigation.menu.unregisterMenu(TRP3_MatureFilterPopup.menuID);
		-- Go to dashboard
		TRP3_API.navigation.menu.selectMenu("main_00_dashboard");
	end);

	-- Continue
	TRP3_MatureFilterPopup.accept:SetText(loc.MATURE_FILTER_WARNING_CONTINUE);
	TRP3_MatureFilterPopup.accept:SetScript("OnClick", hidePopups)

	-- Remember for this profile
	TRP3_MatureFilterPopup.remember:SetText("Remember for this profile");
	TRP3_MatureFilterPopup.remember:SetScript("OnClick", function()
		-- Ask to confirm then hide the popup
		whitelistProfileByUnitIDConfirm(TRP3_MatureFilterPopup.unitID, function()
			hidePopups();
		end);
	end)

	-- Disable mature filter
	TRP3_MatureFilterPopup.disable:SetText("Disable mature filter");
	TRP3_MatureFilterPopup.disable:SetScript("OnClick", function()
		-- Hide the popup and go the the regi
		hidePopups();
		-- Disable mature profile
		setConfigValue(MATURE_FILTER_CONFIG, false);
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CONFIGURATION
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local matureFilterShouldBeEnabledByDefault = false;

	-- Mature filter should be enabled by default if profanity filter is enabled
	matureFilterShouldBeEnabledByDefault = GetCVar("profanityFilter") == "1" or matureFilterShouldBeEnabledByDefault;
	-- Mature filter should be enabled by default if parental control is enabled
	-- (As far as I know, there is not other way to know if parental control is enabled other that checking the store API…)
	matureFilterShouldBeEnabledByDefault = C_StorePublic.IsDisabledByParentalControls() or matureFilterShouldBeEnabledByDefault;

	registerConfigKey(MATURE_FILTER_CONFIG, matureFilterShouldBeEnabledByDefault);
	registerConfigKey(MATURE_FILTER_CONFIG_STRENGTH, 7);

	registerConfigHandler(MATURE_FILTER_CONFIG, function()
		local unitID = getUnitID("target");
		if UnitIsPlayer("target") and unitID ~= player_id and not TRP3_API.register.isIDIgnored(unitID) then
			local _, profileID = getUnitIDProfile(unitID);
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, profileID, nil);
		end
	end);

	---
	-- Returns true if the mature filter is enabled
	local function isMatureFilterEnabled()
		return getConfigValue(MATURE_FILTER_CONFIG);
	end
	TRP3_API.register.mature_filter.isMatureFilterEnabled = isMatureFilterEnabled;

	-- Config must be built on WORKFLOW_ON_LOADED or else the TargetFrame module could be not yet loaded.
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		-- Section title
		tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.MATURE_FILTER_TITLE,
		});
		-- Enable mature filter checkbox
		tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.MATURE_FILTER_OPTION,
			configKey = MATURE_FILTER_CONFIG,
			help = loc.MATURE_FILTER_OPTION_TT
		});
		-- Enable mature filter checkbox
		tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.MATURE_FILTER_STRENGTH,
			help = loc.MATURE_FILTER_STRENGTH_TT,
			configKey = MATURE_FILTER_CONFIG_STRENGTH,
			min = 1,
			max = 10,
			step = 1,
			integer = true,
			dependentOnOptions = {MATURE_FILTER_CONFIG},
		});
		-- Edit dictionary button
		tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigButton",
			title = loc.MATURE_FILTER_EDIT_DICTIONARY,
			help = loc.MATURE_FILTER_EDIT_DICTIONARY_TT,
			text = loc.MATURE_FILTER_EDIT_DICTIONARY_BUTTON,
			callback = function()
				TRP3_API.popup.showPopup("mature_dictionary");
				refreshDictionaryList();
			end,
			dependentOnOptions = {MATURE_FILTER_CONFIG},
		});
		-- Reset dictionnary button
		tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigButton",
			title = loc.MATURE_FILTER_EDIT_DICTIONARY_RESET_TITLE,
			text = loc.MATURE_FILTER_EDIT_DICTIONARY_RESET_BUTTON,
			callback = function()
				TRP3_API.popup.showConfirmPopup(loc.MATURE_FILTER_EDIT_DICTIONARY_RESET_WARNING, function()
					resetDictionnary();
				end);
			end,
			dependentOnOptions = {MATURE_FILTER_CONFIG},
		})

		-- Register our popups to the popup manager
		TRP3_API.popup.POPUPS["mature_dictionary"] = {
			frame = TRP3_MatureDictionaryEditor,
			showMethod = nil,
		}

		TRP3_API.popup.POPUPS["mature_filtered"] = {
			frame = TRP3_MatureFilterPopup,
			showMethod = nil,
		}
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- TARGET FRAME BUTTONS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if TRP3_API.target then
		-- Add to white list button
		TRP3_API.target.registerButton({
			id = "aa_player_w_mature_white_list",
			configText = loc.MATURE_FILTER_ADD_TO_WHITELIST_OPTION,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				if UnitIsPlayer("target") and unitID ~= player_id and not TRP3_API.register.isIDIgnored(unitID) then
					local profileID = getUnitIDProfileID(unitID);
					return profileID and TRP3_API.register.unitIDIsFilteredForMatureContent(unitID)
				else
					return false;
				end
			end,
			onClick = whitelistProfileByUnitIDConfirm,
			tooltipSub = "|cffffff00" .. loc.CM_CLICK .. "|r: " .. loc.MATURE_FILTER_ADD_TO_WHITELIST_TT,
			tooltip = loc.MATURE_FILTER_ADD_TO_WHITELIST,
			icon = "INV_ValentinesCard02"
		});
		-- Remove from white list button
		TRP3_API.target.registerButton({
			id = "aa_player_w_mature_remove_white_list",
			configText = loc.MATURE_FILTER_REMOVE_FROM_WHITELIST_OPTION,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				if UnitIsPlayer("target") and unitID ~= player_id and not TRP3_API.register.isIDIgnored(unitID) then
					local profile = getUnitIDProfile(unitID);
					local profileID = getUnitIDProfileID(unitID);
					return profileID and profile.hasMatureContent and isProfileWhitelisted(profileID);
				else
					return false;
				end
			end,
			onClick = function(unitID)
				removeUnitProfileFromWhitelistConfirm(unitID);
			end,
			tooltipSub = loc.MATURE_FILTER_REMOVE_FROM_WHITELIST_TT,
			tooltip = loc.MATURE_FILTER_REMOVE_FROM_WHITELIST,
			icon = TRP3_API.globals.is_classic and "INV_Scroll_07" or "INV_Inscription_ParchmentVar03"
		});

		-- Manually flag player button
		TRP3_API.target.registerButton({
			id = "aa_player_w_mature_flag",
			configText = loc.MATURE_FILTER_FLAG_PLAYER_OPTION,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				if UnitIsPlayer("target") and unitID ~= player_id and not TRP3_API.register.isIDIgnored(unitID) then
					local profile = getUnitIDProfile(unitID);
					local profileID = getUnitIDProfileID(unitID);
					return profileID and not profile.hasMatureContent and not isProfileWhitelisted(profileID);
				else
					return false;
				end
			end,
			onClick = function(unitID)
				flagUnitProfileHasHavingMatureContentConfirm(unitID);
			end,
			tooltipSub = loc.MATURE_FILTER_FLAG_PLAYER_TT,
			tooltip = loc.MATURE_FILTER_FLAG_PLAYER,
			icon = TRP3_API.globals.is_classic and "Ability_Hunter_SniperShot" or "Ability_Hunter_MasterMarksman"
		});
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- EVENT LISTENER
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local EXPIRATION = 86400; -- 24 hours
	local function shouldReEvaluateContent(lastMatureContentEvaluation)
		if not lastMatureContentEvaluation then return true end;
		local now = time();
		return now - lastMatureContentEvaluation > EXPIRATION;
	end

	-- We listen to data updates in the register and apply the filter if enabled
	-- and the profile is not already whitelisted
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(_, profileID, _)
		if isMatureFilterEnabled() and profileID and getProfileOrNil(profileID) and not isProfileWhitelisted(profileID) then
			local profile = getProfileByID(profileID);
			if not profile.hasMatureContent or shouldReEvaluateContent(profile.lastMatureContentEvaluation) then
				filterData(getProfileByID(profileID), profileID);
			end
		end
	end);
end

local MODULE_STRUCTURE = {
	["name"] = "Mature profile filtering",
	["description"] = "Analyse incoming profiles for keywords and flag profiles if they contain mature content",
	["version"] = 1.100,
	["id"] = "trp3_mature_filter",
	["onStart"] = onStart,
	["minVersion"] = 38,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
