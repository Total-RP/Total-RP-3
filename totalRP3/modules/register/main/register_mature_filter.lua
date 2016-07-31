----------------------------------------------------------------------------------
-- Total RP 3
-- Mature profile filtering module
--
-- The mature profile filtering module will flag profiles containing specific
-- keywords related to mature content.
-- Flagged profiles will have a hasMatureContent boolean attached on them
-- so we can check in the code if a profile has mature content by doing
-- if profile.hasMatureContent then
-- ---------------------------------------------------------------------------
-- Copyright 2016 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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

local matureFilterPopup;

-- WoW imports
local UnitIsPlayer = UnitIsPlayer;

local function onStart()

    -- API
    TRP3_API.register.mature_filter = {};

    -- Saved variables
    TRP3_MatureFilter = TRP3_MatureFilter or {
        whitelist = {},
        dictionnary = {}
    }


    local dictionnaryOfDirtyWords = {};

    -- Imports
    local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
    local log = Utils.log.log;
    local Config = TRP3_API.configuration;
    local getConfigValue = Config.getValue;
    local registerConfigKey = Config.registerConfigKey;
    local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
    local hasProfile = TRP3_API.register.hasProfile;
    local tinsert = tinsert;
    local tsize, loc = Utils.table.size, TRP3_API.locale.getText;
    local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
    local player_id = TRP3_API.globals.player_id;

    local function refreshDictionnaryOfDirtyWords()
        dictionnaryOfDirtyWords = {};
        for _, word in pairs(TRP3_API.utils.resources.getMatureFilterDictionnary()) do
            tinsert(dictionnaryOfDirtyWords, word);
        end
        for _, word in pairs(TRP3_MatureFilter.dictionnary) do
            tinsert(dictionnaryOfDirtyWords, word);
        end
    end

    refreshDictionnaryOfDirtyWords();

    ---
    -- Add a profile ID to the whitelist
    -- @param profileID
    --
    local function whitelistProfileID(profileID)
        TRP3_MatureFilter.whitelist[profileID] = true;
    end
    TRP3_API.register.mature_filter.whitelistUProfileID = whitelistProfileID;

    local function removeProfileIDFromWhiteList(profileID)
        TRP3_MatureFilter.whitelist[profileID] = nil;
    end

    local function isProfileWhitelisted(profileID)
        return TRP3_MatureFilter.whitelist[profileID] or false;
    end

    TRP3_API.register.mature_filter.isProfileWhitelisted = isProfileWhitelisted;

    local function isProfileWhitelistedUnitID(unitID)
        local profile, profileID = getUnitIDProfile(unitID);
        return isProfileWhitelisted(profileID);
    end

    ---
    -- Flag the profile of a give unit ID has having mature content
    -- @param unitID Unit ID to use to retreive the profile (Player-RealmName)
    --
    local function flagUnitProfileHasHavingMatureContent(unitID)
        local profile = getUnitIDProfile(unitID); -- TODO Check exists because it raise error
        profile.hasMatureContent = true;
    end
    TRP3_API.register.mature_filter.flagUnitProfileHasHavingMatureContent = flagUnitProfileHasHavingMatureContent

    ---
    -- Open a confirm popup to flag the profile of a give unit ID has having mature content.
    -- The popup also optionally asks for new words to put inside the dictionnary.
    -- Will call flagUnitProfileHasHavingMatureContent(unitID) if the user confirm.
    -- @param unitID Unit ID to use to retreive the profile (Player-RealmName)
    --
    local function flagUnitProfileHasHavingMatureContentConfirm(unitID)
        showTextInputPopup(loc("MATURE_FILTER_FLAG_PLAYER_TEXT"):format(unitID), function(text)
            -- If the user inserted words to add to the dicitonnary, we add them
			for word in text:gmatch("[^%s%p]+") do
				tinsert(TRP3_MatureFilter.dictionnary, word);
            end
            if text and #text > 0 then
                -- Refresh the dictionnary if needed
                refreshDictionnaryOfDirtyWords()
            end
            -- Flag the profile of the unit has having mature content
            flagUnitProfileHasHavingMatureContent(unitID);
            -- Fire the event that the register has been updated so the UI stuff get refreshed
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
        end);
    end

    local function removeUnitProfileFromWhitelistConfirm(unitID)
        TRP3_API.popup.showConfirmPopup(loc("MATURE_FILTER_REMOVE_FROM_WHITELIST_TEXT"):format(unitID), function()
            local profile, profileID = getUnitIDProfile(unitID);
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
    local function whitelistProfileByUnitIDConfirm(unitID)
        local profile, profileID = getUnitIDProfile(unitID); -- TODO Check exists because it raise error

        TRP3_API.popup.showConfirmPopup(loc("MATURE_FILTER_ADD_TO_WHITELIST_TEXT"):format(unitID), function()
            whitelistProfileID(profileID);
			Events.fireEvent(Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), nil);
        end);
    end

    TRP3_API.register.mature_filter.whitelistProfileByUnitIDConfirm = whitelistProfileByUnitIDConfirm;

    -- This structure list the fields we will filter
    local filteredFields = {
        character = {
            CU = "string",
            CO = "string"
        },
        characteristics = {
            RA = "string",
            CL = "string",
            FN = "string",
        },
        about = {
            T3 = {
                PH = {
                    TX = "string"
                },
                PS = {
                    TX = "string"
                },
                HI = {
                    TX = "string"
                }
            },
        }

    }

    ---
    -- Filter out mature content
    -- @param table
    --
    local function textContainsMatureContent(text)
        local words = {}
        -- Break string into a table
        for word in text:gmatch("[^%s%p]+") do
            -- We will use the lower case version of the words because our keywords are lowercased
            word = word:lower()
            -- If we already found this word in the string, increment the count for this word
            words[word] = (words[word] or 0) + 1;
        end
        -- Iterate through the matureWords dictionnary
        TRP3_API.utils.table.dump(dictionnaryOfDirtyWords);
        for _, matureWord in pairs(dictionnaryOfDirtyWords) do
            -- If the word is found, flag the profile as unsafe
            if words[matureWord] then
                log("Found |cff00ff00" .. matureWord .. "|r " .. words[matureWord] .. " times!", Utils.log.WARNING);
                return true
            end
        end
        return false
    end


    -- Mature profiles filtering should be enabled by default if the chat mature languge filter is on or parental control is on
    -- That variable name is dedicated to Telkostrasz and Saelora (◕‿◕)
    local matureProfileFilteringShoudBeEnabledByDefaultAfterWhatIBelieveIsTheBestSettings = true;

    registerConfigKey("register_mature_filter", matureProfileFilteringShoudBeEnabledByDefaultAfterWhatIBelieveIsTheBestSettings);

    -- Config must be built on WORKFLOW_ON_LOADED or else the TargetFrame module could be not yet loaded.
    TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
        tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
            inherit = "TRP3_ConfigH1",
            title = loc("MATURE_FILTER_TITLE"),
        });
        tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
            inherit = "TRP3_ConfigCheck",
            title = loc("MATURE_FILTER_OPTION"),
            configKey = "register_mature_filter",
            help = loc("MATURE_FILTER_OPTION_TT")
        });
    end);

    -- Add to white list button
    TRP3_API.target.registerButton({
        id = "aa_player_w_mature_white_list",
        configText = loc("MATURE_FILTER_ADD_TO_WHITELIST_OPTION"),
        onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
        condition = function(targetType, unitID)
            if UnitIsPlayer("target") and not TRP3_API.register.isIDIgnored(unitID) then
                return TRP3_API.register.unitIDIsFilteredForMatureContent(unitID)
            else
                return false;
            end
        end,
        onClick = whitelistProfileByUnitIDConfirm,
        tooltipSub = "|cffffff00" .. loc("CM_CLICK") .. "|r: " .. loc("MATURE_FILTER_ADD_TO_WHITELIST_TT"),
        tooltip = loc("MATURE_FILTER_ADD_TO_WHITELIST"),
        icon = "INV_ValentinesCard02"
    });
    -- Remove from white list button
    TRP3_API.target.registerButton({
        id = "aa_player_w_mature_remove_white_list",
        configText = loc("MATURE_FILTER_REMOVE_FROM_WHITELIST_OPTION"),
        onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
        condition = function(targetType, unitID)
            if UnitIsPlayer("target") and not TRP3_API.register.isIDIgnored(unitID) then
                return TRP3_API.register.unitIDIsFlaggedForMatureContent(unitID) and isProfileWhitelistedUnitID(unitID);
            else
                return false;
            end
        end,
        onClick = function(unitID)
            removeUnitProfileFromWhitelistConfirm(unitID);
        end,
        tooltipSub = loc("MATURE_FILTER_REMOVE_FROM_WHITELIST_TT"),
        tooltip = loc("MATURE_FILTER_REMOVE_FROM_WHITELIST"),
        icon = "INV_Inscription_ParchmentVar03"
    });

    -- Manually flag player button
    TRP3_API.target.registerButton({
        id = "aa_player_w_mature_flag",
        configText = loc("MATURE_FILTER_FLAG_PLAYER_OPTION"),
        onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
        condition = function(targetType, unitID)
            if UnitIsPlayer("target") and not TRP3_API.register.isIDIgnored(unitID) then
                return not TRP3_API.register.unitIDIsFlaggedForMatureContent(unitID);
            else
                return false;
            end
        end,
        onClick = function(unitID)
            flagUnitProfileHasHavingMatureContentConfirm(unitID);
        end,
        tooltipSub = loc("MATURE_FILTER_FLAG_PLAYER_TT"),
        tooltip = loc("MATURE_FILTER_FLAG_PLAYER"),
        icon = "Ability_Hunter_MasterMarksman"
    });

    local function filterData(dataType, data, unitID)
        --[[for field, value in pairs(filteredFields[dataType]) do
            -- If the value of the field is a string, we treat it
            if type(value) == "string" and data[field] then
                local profileHasMatureContent = textContainsMatureContent(data[dataType][field]);
                if profileHasMatureContent then
                    flagUnitProfileHasHavingMatureContent(unitID);
                    break
                end
                -- If the value of the field is a table, we recursively call filterOutMatureContent() on the table content
            elseif type(value) == "table" then
                -- filterData(value, unitID)
            end
        end]]
        -- Iterate over each field of the data table
        for key, value in pairs(data) do
            -- If the value of the field is a string, we treat it
            if type(value) == "string" then
               if textContainsMatureContent(value) then
                   flagUnitProfileHasHavingMatureContent(unitID);
               end
            elseif type(value) == "table" then
                filterData(dataType, value, unitID);
            end
        end
    end

    Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, profileID, dataType)
        if getConfigValue("register_mature_filter") and unitID and unitID ~= player_id and not isProfileWhitelisted(profileID) then
            if TRP3_API.register.isUnitIDKnown(unitID) and TRP3_API.register.profileExists(unitID) then
                local profile = getUnitIDProfile(unitID);
                filterData(dataType, profile, unitID);
            end
        end
    end);
end

local onInit = function ()
    matureFilterPopup = CreateFrame("Frame", "TRP3_MatureFilterPopup", TRP3_PopupsFrame, "TRP3_MatureFilterPopupTemplate");
end

local MODULE_STRUCTURE = {
    ["name"] = "Mature profile filtering",
    ["description"] = "Analyse incoming profiles for keywords and flag profiles if they contain mature content",
    ["version"] = 1.000,
    ["id"] = "trp3_mature_filter",
    ["onStart"] = onStart,
    ["onInit"] = onInit,
    ["minVersion"] = 14,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);