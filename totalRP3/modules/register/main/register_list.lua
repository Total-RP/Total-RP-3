----------------------------------------------------------------------------------
--- Total RP 3
--- Directory
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

-- imports
local Globals, Events = TRP3_API.globals, TRP3_API.events;
local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local unitIDToInfo, tsize = Utils.str.unitIDToInfo, Utils.table.size;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local isMenuRegistered = TRP3_API.navigation.menu.isMenuRegistered;
local registerMenu, selectMenu, openMainFrame = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu, TRP3_API.navigation.openMainFrame;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getUnitIDCharacter = TRP3_API.register.getUnitIDCharacter;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile = TRP3_API.register.hasProfile;
local getCompleteName = TRP3_API.register.getCompleteName;
local TRP3_RegisterListEmpty = TRP3_RegisterListEmpty;
local getProfile = TRP3_API.register.getProfile;
local getIgnoredList, unignoreID, isIDIgnored = TRP3_API.register.getIgnoredList, TRP3_API.register.unignoreID, TRP3_API.register.isIDIgnored;
local getRelationText, getRelationTooltipText = TRP3_API.register.relation.getRelationText, TRP3_API.register.relation.getRelationTooltipText;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local displayDropDown, showAlertPopup, showConfirmPopup = TRP3_API.ui.listbox.displayDropDown, TRP3_API.popup.showAlertPopup, TRP3_API.popup.showConfirmPopup;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local deleteProfile, deleteCharacter, getProfileList = TRP3_API.register.deleteProfile, TRP3_API.register.deleteCharacter, TRP3_API.register.getProfileList;
local ignoreID = TRP3_API.register.ignoreID;
local refreshList;
local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;
local checkGlanceActivation = TRP3_API.register.checkGlanceActivation;
local getCompanionProfiles = TRP3_API.companions.register.getProfiles;
local getRelationColors = TRP3_API.register.relation.getRelationColors;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;
local safeMatch = TRP3_API.utils.str.safeMatch;
local unitIDIsFilteredForMatureContent = TRP3_API.register.unitIDIsFilteredForMatureContent;
local profileIDISFilteredForMatureContent = TRP3_API.register.profileIDISFilteredForMatureContent;
local tContains = tContains;
local GetAutoCompleteRealms = GetAutoCompleteRealms;
local is_classic = Globals.is_classic;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTER_LIST_PAGEID = "register_list";
local playerMenu = "main_10_player";
local currentlyOpenedProfilePrefix = TRP3_API.register.MENU_LIST_ID_TAB;
local REGISTER_PAGE = TRP3_API.register.MENU_LIST_ID;

local function openPage(profileID, unitID)
	local profile = getProfile(profileID);
	local menuID = currentlyOpenedProfilePrefix .. profileID
	if isMenuRegistered(menuID) then
		local menuItem = TRP3_API.navigation.menu.getMenuItem(menuID)
		if unitID then
			menuItem.pageContext.unitID            = unitID
			menuItem.pageContext.openingWithUnitID = true
		end
		-- If the character already has his "tab", simply open it
		selectMenu(menuID);
		TRP3_API.navigation.page.getCurrentContext().openingWithUnitID = false
	else
		-- Else, create a new menu entry and open it.
		local tabText = UNKNOWN;
		if profile.characteristics and profile.characteristics.FN then
			tabText = profile.characteristics.FN;
		end
		local pageContext = {
			-- source isn't used, but useful in to know where you're getting the
			-- REGISTER_PROFILE_OPENED event from.
			source            = "directory",
			profile           = profile,
			profileID         = profileID,
			unitID            = unitID,
			openingWithUnitID = unitID ~= nil
		}
		registerMenu({
			id = menuID,
			text = tabText,
			onSelected = function() setPage("player_main", pageContext ) end,
			isChildOf = REGISTER_PAGE,
			closeable = true,
			icon = is_classic and "Interface\\ICONS\\INV_Helmet_20" or "Interface\\ICONS\\pet_type_humanoid",
			pageContext = pageContext,
		});
		selectMenu(menuID);
		TRP3_API.navigation.page.getCurrentContext().openingWithUnitID = false

		if (unitID and unitIDIsFilteredForMatureContent(unitID)) or (profileID and profileIDISFilteredForMatureContent(profileID)) then
			TRP3_API.popup.showPopup("mature_filtered");
			TRP3_MatureFilterPopup.profileID = profileID;
			TRP3_MatureFilterPopup.unitID = unitID;
			TRP3_MatureFilterPopup.menuID = menuID;
		end
	end
end
TRP3_API.register.openPageByProfileID = openPage;

local function openCompanionPage(profileID)
	local profile = getCompanionProfiles()[profileID];
	if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
		-- If the character already has his "tab", simply open it
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	else
		-- Else, create a new menu entry and open it.
		local tabText = UNKNOWN;
		if profile.data and profile.data.NA then
			tabText = profile.data.NA;
		end
		registerMenu({
			id = currentlyOpenedProfilePrefix .. profileID,
			text = tabText,
			onSelected = function() setPage(TRP3_API.navigation.page.id.COMPANIONS_PAGE, {profile = profile, profileID = profileID, isPlayer = false}) end,
			isChildOf = REGISTER_PAGE,
			closeable = true,
			icon = "Interface\\ICONS\\pet_type_beast",
		});
		selectMenu(currentlyOpenedProfilePrefix .. profileID);
	end
end
TRP3_API.companions.register.openPage = openCompanionPage;

local function openPageByUnitID(unitID)
	if unitID == Globals.player_id then
		selectMenu(playerMenu);
	elseif isUnitIDKnown(unitID) and hasProfile(unitID) then
		openPage(hasProfile(unitID), unitID);
	end
end
TRP3_API.register.openPageByUnitID = openPageByUnitID;


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local sortingType = 1;

local function switchNameSorting()
	sortingType = sortingType == 2 and 1 or 2;
	refreshList();
end

local function switchInfoSorting()
	sortingType = sortingType == 4 and 3 or 4;
	refreshList();
end

local function switchTimeSorting()
	sortingType = sortingType == 6 and 5 or 6;
	refreshList();
end

local function getNameForSort(name)
	name = name:lower()
	name = name:gsub("\"", "")
	name = name:gsub("'", "")
	return name
end

local function nameComparator(elem1, elem2)
	return getNameForSort(elem1[2]) < getNameForSort(elem2[2]);
end

local function nameComparatorInverted(elem1, elem2)
	return getNameForSort(elem1[2]) > getNameForSort(elem2[2]);
end

local function infoComparator(elem1, elem2)
	return elem1[3]:lower() < elem2[3]:lower();
end

local function infoComparatorInverted(elem1, elem2)
	return elem1[3]:lower() > elem2[3]:lower();
end

local function timeComparator(elem1, elem2)
	if elem1[4] == nil then
		return false;
	elseif elem2[4] == nil then
		return true;
	end
	return elem1[4] < elem2[4];
end

local function timeComparatorInverted(elem1, elem2)
	if elem1[4] == nil then
		return false;
	elseif elem2[4] == nil then
		return true;
	end
	return elem1[4] > elem2[4];
end

local comparators = {
	nameComparator, nameComparatorInverted, infoComparator, infoComparatorInverted, timeComparator, timeComparatorInverted
}

local function getCurrentComparator()
	return comparators[sortingType];
end

local ARROW_DOWN = "Interface\\Buttons\\Arrow-Down-Up";
local ARROW_UP = "Interface\\Buttons\\Arrow-Up-Up";
local ARROW_SIZE = 15;

local function getComparatorArrows()
	local nameArrow, relationArrow, timeArrow = "", "", "";
	if sortingType == 1 then
		nameArrow = " |T" .. ARROW_DOWN .. ":" .. ARROW_SIZE .. "|t";
	elseif sortingType == 2 then
		nameArrow = " |T" .. ARROW_UP .. ":" .. ARROW_SIZE .. "|t";
	elseif sortingType == 3 then
		relationArrow = " |T" .. ARROW_DOWN .. ":" .. ARROW_SIZE .. "|t";
	elseif sortingType == 4 then
		relationArrow = " |T" .. ARROW_UP .. ":" .. ARROW_SIZE .. "|t";
	elseif sortingType == 5 then
		timeArrow = " |T" .. ARROW_DOWN .. ":" .. ARROW_SIZE .. "|t";
	elseif sortingType == 6 then
		timeArrow = " |T" .. ARROW_UP .. ":" .. ARROW_SIZE .. "|t";
	end
	return nameArrow, relationArrow, timeArrow;
end

local MODE_CHARACTER, MODE_PETS, MODE_IGNORE = 1, 2, 3;
local selectedIDs = {};
local ICON_SIZE = 30;
local currentMode = 1;
local DATE_FORMAT = "%d/%m/%y %H:%M";
local IGNORED_ICON = Utils.str.texture("Interface\\Buttons\\UI-GroupLoot-Pass-Down", 15);
local GLANCE_ICON = Utils.str.texture("Interface\\MINIMAP\\TRACKING\\None", 15);
local NEW_ABOUT_ICON = Utils.str.texture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up", 15);
local MATURE_CONTENT_ICON = Utils.str.texture("Interface\\AddOns\\totalRP3\\resources\\18_emoji.tga", 15);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : CHARACTERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local characterLines = {};

local function decorateCharacterLine(line, characterIndex)
	local profileID = characterLines[characterIndex][1];
	local profile = getProfile(profileID);
	line.id = profileID;

	local name = getCompleteName(profile.characteristics or {}, UNKNOWN, true);
	local leftTooltipTitle, leftTooltipText = name, "";

	_G[line:GetName().."Name"]:SetText(name);
	if profile.characteristics and profile.characteristics.IC then
		leftTooltipTitle = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
	end

	local hasGlance = profile.misc and profile.misc.PE and checkGlanceActivation(profile.misc.PE);
	local hasNewAbout = profile.about and not profile.about.read;

	local atLeastOneIgnored = false;
	_G[line:GetName().."Info2"]:SetText("");
	local firstLink;
	if profile.link and tsize(profile.link) > 0 then
		leftTooltipText = leftTooltipText .. loc.REG_LIST_CHAR_TT_CHAR;
		for unitID, _ in pairs(profile.link) do
			if not firstLink then
				firstLink = unitID;
			end
			local unitName, unitRealm = unitIDToInfo(unitID);
			if isIDIgnored(unitID) then
				leftTooltipText = leftTooltipText .. "\n|cffff0000 - " .. unitName .. " ( " .. unitRealm .. " ) - " .. IGNORED_ICON .. " " .. loc.REG_LIST_CHAR_IGNORED;
				atLeastOneIgnored = true;
			else
				leftTooltipText = leftTooltipText .. "\n|cff00ff00 - " .. unitName .. " ( " .. unitRealm .. " )";
			end
		end
	else
		leftTooltipText = leftTooltipText .. "|cffffff00" .. loc.REG_LIST_CHAR_TT_CHAR_NO;
	end

	if profile.time and profile.zone then
		local formatDate = date(DATE_FORMAT, profile.time);
		leftTooltipText = leftTooltipText .. "\n|r" .. loc.REG_LIST_CHAR_TT_DATE:format(formatDate, profile.zone);
	end
	-- Middle column : relation
	local relation, relationRed, relationGreen, relationBlue = getRelationText(profileID), getRelationColors(profileID);
	local color = Utils.color.colorCode(relationRed * 255, relationGreen * 255, relationBlue * 255);
	if relation:len() > 0 then
		local middleTooltipTitle, middleTooltipText = relation, getRelationTooltipText(profileID, profile);
		setTooltipForSameFrame(_G[line:GetName().."ClickMiddle"], "TOPLEFT", 0, 5, middleTooltipTitle, color .. middleTooltipText);
	else
		setTooltipForSameFrame(_G[line:GetName().."ClickMiddle"]);
	end
	_G[line:GetName().."Info"]:SetText(color .. relation);

	local timeStr = "";
	if profile.time then
		timeStr = date(DATE_FORMAT, profile.time);
	end
	_G[line:GetName().."Time"]:SetText(timeStr);

	-- Third column : flags
	---@type string[]
	local rightTooltipTexts, flags = {}, {};
	if atLeastOneIgnored then
		table.insert(flags, IGNORED_ICON);
		table.insert(rightTooltipTexts, IGNORED_ICON .. " " .. loc.REG_LIST_CHAR_TT_IGNORE);
	end
	if hasGlance then
		table.insert(flags, GLANCE_ICON);
		table.insert(rightTooltipTexts, GLANCE_ICON .. " " .. loc.REG_LIST_CHAR_TT_GLANCE);
	end
	if hasNewAbout then
		table.insert(flags, NEW_ABOUT_ICON);
		table.insert(rightTooltipTexts, NEW_ABOUT_ICON .. " " .. loc.REG_LIST_CHAR_TT_NEW_ABOUT);
	end
	if profile.hasMatureContent then
		table.insert(flags, MATURE_CONTENT_ICON);
		table.insert(rightTooltipTexts, MATURE_CONTENT_ICON .. " " .. loc.MATURE_FILTER_TOOLTIP_WARNING);
	end
	if #rightTooltipTexts > 0 then
		setTooltipForSameFrame(_G[line:GetName().."ClickRight"], "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipTexts, "\n"));
	else
		setTooltipForSameFrame(_G[line:GetName().."ClickRight"]);
	end
	_G[line:GetName().."Info2"]:SetText(table.concat(flags, " "));

	local addon = Globals.addon_name;
	if profile.msp then
		addon = "Mary-Sue Protocol";
		if firstLink and isUnitIDKnown(firstLink) then
			local character = getUnitIDCharacter(firstLink);
			addon = character.client or "Mary-Sue Protocol";
		end
	end
	_G[line:GetName().."Addon"]:SetText(addon);

	_G[line:GetName().."Select"]:SetChecked(selectedIDs[profileID]);
	_G[line:GetName().."Select"]:Show();

	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, leftTooltipTitle, leftTooltipText .. "\n\n" ..
		Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.CM_OPEN) .. "\n" ..
		Ellyb.Strings.clickInstruction(
			Ellyb.System:FormatKeyboardShortcut(Ellyb.System.MODIFIERS.SHIFT, Ellyb.System.CLICKS.CLICK),
			loc.CL_TOOLTIP
		));
end

local function getCharacterLines()
	local nameSearch = TRP3_RegisterListFilterCharactName:GetText():lower();
	local guildSearch = TRP3_RegisterListFilterCharactGuild:GetText():lower();
	local realmOnly = TRP3_RegisterListFilterCharactRealm:GetChecked();
	local notesOnly = TRP3_RegisterListFilterCharactNotes:GetChecked();
	local profileList = getProfileList();
	local fullSize = tsize(profileList);
	wipe(characterLines);

	for profileID, profile in pairs(profileList) do
		local nameIsConform, guildIsConform, realmIsConform, notesIsConform = false, false, false, false;

		if profile.characteristics and not Ellyb.Tables.isEmpty(profile.characteristics) then

			-- Defines if at least one character is conform to the search criteria
			for unitID, _ in pairs(profile.link or Globals.empty) do
				local unitName, unitRealm = unitIDToInfo(unitID);
				if safeMatch(unitName:lower(), nameSearch) then
					nameIsConform = true;
				end
				if unitRealm == Globals.player_realm_id or tContains(GetAutoCompleteRealms(), unitRealm) then
					realmIsConform = true;
				end
				local characterData = AddOn_TotalRP3.Directory.getCharacterDataForCharacterId(unitID);
				if characterData and characterData.guild and safeMatch(characterData.guild:lower(), guildSearch) then
					guildIsConform = true;
				end
				local currentNotes = TRP3_API.profile.getPlayerCurrentProfile().notes or {};
				if TRP3_Notes and TRP3_Notes[profileID] or currentNotes[profileID] then
					notesIsConform = true;
				end
			end
			local completeName = getCompleteName(profile.characteristics or {}, "", true);
			if not nameIsConform and safeMatch(completeName:lower(), nameSearch) then
				nameIsConform = true;
			end

			nameIsConform = nameIsConform or nameSearch:len() == 0;
			guildIsConform = guildIsConform or guildSearch:len() == 0;
			realmIsConform = realmIsConform or not realmOnly;
			notesIsConform = notesIsConform or not notesOnly;

			if nameIsConform and guildIsConform and realmIsConform and notesIsConform then
				tinsert(characterLines, {profileID, completeName, getRelationText(profileID), profile.time});
			end

		end
	end

	table.sort(characterLines, getCurrentComparator());

	local lineSize = #characterLines;
	if lineSize == 0 then
		if fullSize == 0 then
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_CHAR_EMPTY);
		else
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_CHAR_EMPTY2);
		end
	end
	setupFieldSet(TRP3_RegisterListCharactFilter, loc.REG_LIST_CHAR_FILTER:format(lineSize, fullSize), 200);

	local nameArrow, relationArrow, timeArrow = getComparatorArrows();
	TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER .. nameArrow);
	TRP3_RegisterListHeaderInfo:SetText(loc.REG_RELATION .. relationArrow);
	TRP3_RegisterListHeaderTime:SetText(loc.REG_TIME .. timeArrow);
	TRP3_RegisterListHeaderTimeTT:Enable();
	TRP3_RegisterListHeaderInfoTT:Enable();
	TRP3_RegisterListHeaderNameTT:Enable();
	TRP3_RegisterListHeaderInfo2:SetText(loc.REG_LIST_FLAGS);
	TRP3_RegisterListHeaderActions:Show();

	return characterLines;
end

local MONTH_IN_SECONDS = 2592000;

local function onCharactersActionSelected(value)
	-- PURGES
	if value == "purge_time" then
		local profiles = getProfileList();
		local profilesToPurge = {};
		for profileID, profile in pairs(profiles) do
			if profile.time and time() - profile.time > MONTH_IN_SECONDS then
				tinsert(profilesToPurge, profileID);
			end
		end
		if #profilesToPurge == 0 then
			showAlertPopup(loc.REG_LIST_ACTIONS_PURGE_TIME_C:format(loc.REG_LIST_ACTIONS_PURGE_EMPTY));
		else
			showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_TIME_C:format(loc.REG_LIST_ACTIONS_PURGE_COUNT:format(#profilesToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID, true);
				end
				Events.fireEvent(Events.REGISTER_DATA_UPDATED);
				Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
				refreshList();
			end);
		end
	elseif value == "purge_unlinked" then
		local profiles = getProfileList();
		local profilesToPurge = {};
		for profileID, profile in pairs(profiles) do
			if not profile.link or tsize(profile.link) == 0 then
				tinsert(profilesToPurge, profileID);
			end
		end
		if #profilesToPurge == 0 then
			showAlertPopup(loc.REG_LIST_ACTIONS_PURGE_UNLINKED_C:format(loc.REG_LIST_ACTIONS_PURGE_EMPTY));
		else
			showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_UNLINKED_C:format(loc.REG_LIST_ACTIONS_PURGE_COUNT:format(#profilesToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID, true);
				end
				Events.fireEvent(Events.REGISTER_DATA_UPDATED);
				Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
				refreshList();
			end);
		end
	elseif value == "purge_ignore" then
		local profilesToPurge, characterToPurge = TRP3_API.register.getIDsToPurge();
		if #profilesToPurge + #characterToPurge == 0 then
			showAlertPopup(loc.REG_LIST_ACTIONS_PURGE_IGNORE_C:format(loc.REG_LIST_ACTIONS_PURGE_EMPTY));
		else
			showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_IGNORE_C:format(loc.REG_LIST_ACTIONS_PURGE_COUNT:format(#profilesToPurge + #characterToPurge)), function()
				for _, profileID in pairs(profilesToPurge) do
					deleteProfile(profileID, true);
				end
				for _, unitID in pairs(characterToPurge) do
					deleteCharacter(unitID);
				end
				Events.fireEvent(Events.REGISTER_DATA_UPDATED);
				Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
				refreshList();
			end);
		end
	elseif value == "purge_all" then
		local list = getProfileList();
		showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_ALL_C:format(tsize(list)), function()
			for profileID, _ in pairs(list) do
				deleteProfile(profileID, true);
			end
			Events.fireEvent(Events.REGISTER_DATA_UPDATED);
			Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	-- Mass actions
	elseif value == "actions_delete" then
		showConfirmPopup(loc.REG_LIST_ACTIONS_MASS_REMOVE_C:format(tsize(selectedIDs)), function()
			for profileID, _ in pairs(selectedIDs) do
				deleteProfile(profileID, true);
			end
			Events.fireEvent(Events.REGISTER_DATA_UPDATED);
			Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
			refreshList();
		end);
	elseif value == "actions_ignore" then
		local charactToIgnore = {};
		for profileID, _ in pairs(selectedIDs) do
			for unitID, _ in pairs(getProfile(profileID).link or Globals.empty) do
				charactToIgnore[unitID] = true;
			end
		end
		showTextInputPopup(loc.REG_LIST_ACTIONS_MASS_IGNORE_C:format(tsize(charactToIgnore)), function(text)
			for unitID, _ in pairs(charactToIgnore) do
				ignoreID(unitID, text);
			end
			refreshList();
		end);
	end
end

local function onCharactersActions(self)
	local values = {};
	tinsert(values, {loc.REG_LIST_ACTIONS_PURGE, {
			{loc.REG_LIST_ACTIONS_PURGE_TIME, "purge_time"},
			{loc.REG_LIST_ACTIONS_PURGE_UNLINKED, "purge_unlinked"},
			{loc.REG_LIST_ACTIONS_PURGE_IGNORE, "purge_ignore"},
			{loc.REG_LIST_ACTIONS_PURGE_ALL, "purge_all"},
		}});
	if tsize(selectedIDs) > 0 then
		tinsert(values, {loc.REG_LIST_ACTIONS_MASS:format(tsize(selectedIDs)), {
				{loc.REG_LIST_ACTIONS_MASS_REMOVE, "actions_delete"},
				{loc.REG_LIST_ACTIONS_MASS_IGNORE, "actions_ignore"},
			}});
	end
	displayDropDown(self, values, onCharactersActionSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : COMPANIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local companionIDToInfo, getAssociationsForProfile = TRP3_API.utils.str.companionIDToInfo, TRP3_API.companions.register.getAssociationsForProfile;
local deleteCompanionProfile = TRP3_API.companions.register.deleteProfile;
local companionLines = {};

local function decorateCompanionLine(line, index)
	local profileID = companionLines[index][1];
	local profile = getCompanionProfiles()[profileID];
	line.id = profileID;

	local hasGlance = profile.PE and checkGlanceActivation(profile.PE);
	local hasNewAbout = profile.data and profile.data.read == false;

	local name = UNKNOWN;
	if profile.data and profile.data.NA then
		name = profile.data.NA;
	end
	_G[line:GetName().."Name"]:SetText(name);

	local tooltip = name;
	if profile.data and profile.data.IC then
		tooltip = Utils.str.icon(profile.data.IC, ICON_SIZE) .. " " .. name;
	end

	local links, masters = {}, {};
	local fulllinks = getAssociationsForProfile(profileID);
	for _, companionFullID in pairs(fulllinks) do
		local ownerID, companionID = companionIDToInfo(companionFullID);
		links[companionID] = 1;
		masters[ownerID] = 1;
	end

	local companionList = "";
	for companionID, _ in pairs(links) do
		companionList = companionList .. "- |cff00ff00" .. getCompanionNameFromSpellID(companionID) .. "|r\n";
	end
	local masterList, firstMaster = "", "";
	for ownerID, _ in pairs(masters) do
		masterList = masterList .. "- |cff00ff00" .. ownerID .. "|r\n";
		if firstMaster == "" then
			firstMaster = ownerID;
		end
	end

	if isUnitIDKnown(firstMaster) and  TRP3_API.register.profileExists(firstMaster) then
		firstMaster = getCompleteName(getUnitIDProfile(firstMaster).characteristics or {}, "", true);
	end
	_G[line:GetName().."Addon"]:SetText(firstMaster);

	local secondLine = loc.REG_LIST_PETS_TOOLTIP .. ":\n" .. companionList .. "\n" .. loc.REG_LIST_PETS_TOOLTIP2 .. ":\n" .. masterList;
	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, tooltip, secondLine .. "\n\n" ..
		Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.CM_OPEN) .. "\n" ..
		Ellyb.Strings.clickInstruction(
			Ellyb.System:FormatKeyboardShortcut(Ellyb.System.MODIFIERS.SHIFT, Ellyb.System.CLICKS.CLICK),
			loc.CL_TOOLTIP
		));
	setTooltipForSameFrame(_G[line:GetName().."ClickMiddle"]);

	-- Third column : flags
	---@type string[]
	local rightTooltipText, flags = {}, {};
	if hasGlance then
		table.insert(flags, GLANCE_ICON);
		table.insert(rightTooltipText, GLANCE_ICON .. " " .. loc.REG_LIST_CHAR_TT_GLANCE);
	end
	if hasNewAbout then
		table.insert(flags, NEW_ABOUT_ICON);
		table.insert(rightTooltipText, NEW_ABOUT_ICON .. " " .. loc.REG_LIST_CHAR_TT_NEW_ABOUT);
	end
	if #rightTooltipText > 0 then
		setTooltipForSameFrame(_G[line:GetName().."ClickRight"], "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipText, "\n"));
	else
		setTooltipForSameFrame(_G[line:GetName().."ClickRight"]);
	end
	_G[line:GetName().."Info2"]:SetText(table.concat(flags, " "));

	_G[line:GetName().."Select"]:SetChecked(selectedIDs[profileID]);
	_G[line:GetName().."Select"]:Show();

	_G[line:GetName().."Info"]:SetText("");
	_G[line:GetName().."Time"]:SetText("");
end

local function getCompanionLines()
	local nameSearch = TRP3_RegisterListPetFilterName:GetText():lower();
	local typeSearch = TRP3_RegisterListPetFilterType:GetText():lower();
	local masterSearch = TRP3_RegisterListPetFilterMaster:GetText():lower();
	local profiles = getCompanionProfiles();
	local fullSize = tsize(profiles);
	wipe(companionLines);

	for profileID, profile in pairs(profiles) do
		local nameIsConform, typeIsConform, masterIsConform = false, false, false;

		-- Run this test only if there are criterias
		if typeSearch:len() > 0 or masterSearch:len() > 0 then
			for companionFullID, _ in pairs(profile.links) do
				local masterID, companionID = companionIDToInfo(companionFullID);
				if safeMatch(companionID:lower(), typeSearch) then
					typeIsConform = true;
				end
				if safeMatch(masterID:lower(), masterSearch) then
					masterIsConform = true;
				end
			end
		end

		local companionName = UNKNOWN;
		if profile.data and profile.data.NA then
			companionName = profile.data.NA;
		end
		if nameSearch:len() ~= 0 and profile.data and profile.data.NA and safeMatch(profile.data.NA:lower(), nameSearch) then
			nameIsConform = true;
		end

		nameIsConform = nameIsConform or nameSearch:len() == 0;
		typeIsConform = typeIsConform or typeSearch:len() == 0;
		masterIsConform = masterIsConform or masterSearch:len() == 0;

		if nameIsConform and typeIsConform and masterIsConform then
			tinsert(companionLines, {profileID, companionName, companionName, companionName});
		end
	end

	table.sort(companionLines, getCurrentComparator());

	local lineSize = #companionLines;
	if lineSize == 0 then
		if fullSize == 0 then
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_PETS_EMPTY);
		else
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_PETS_EMPTY2);
		end
	end
	setupFieldSet(TRP3_RegisterListPetFilter, loc.REG_LIST_PETS_FILTER:format(lineSize, fullSize), 200);

	local nameArrow = getComparatorArrows();
	TRP3_RegisterListHeaderName:SetText(loc.REG_COMPANION .. nameArrow);
	TRP3_RegisterListHeaderInfo:SetText("");
	TRP3_RegisterListHeaderTime:SetText("");
	TRP3_RegisterListHeaderTimeTT:Disable();
	TRP3_RegisterListHeaderInfoTT:Disable();
	TRP3_RegisterListHeaderNameTT:Enable();
	TRP3_RegisterListHeaderInfo2:SetText(loc.REG_LIST_FLAGS);
	TRP3_RegisterListHeaderActions:Show();

	return companionLines;
end

local DO_NOT_FIRE_EVENTS = true;
local function onCompanionActionSelected(value)
	if value == "purge_all" then
		local list = getCompanionProfiles();
		showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_ALL_COMP_C:format(tsize(list)), function()
			for profileID, _ in pairs(list) do
				-- We delete the companion profile without fire events to prevent UI freeze
				deleteCompanionProfile(profileID, DO_NOT_FIRE_EVENTS);
			end
			-- We then fire the event once every profile we needed to delete has been deleted
			Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	elseif value == "actions_delete" then
		showConfirmPopup(loc.REG_LIST_ACTIONS_MASS_REMOVE_C:format(tsize(selectedIDs)), function()
			for profileID, _ in pairs(selectedIDs) do
				-- We delete the companion profile without fire events to prevent UI freeze
				deleteCompanionProfile(profileID, DO_NOT_FIRE_EVENTS);
			end
			-- We then fire the event once every profile we needed to delete has been deleted
			Events.fireEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	end
end

local function onPetsActions(self)
	local values = {};
	tinsert(values, {loc.REG_LIST_ACTIONS_PURGE, {
			{loc.REG_LIST_ACTIONS_PURGE_ALL, "purge_all"},
		}});
	if tsize(selectedIDs) > 0 then
		tinsert(values, {loc.REG_LIST_ACTIONS_MASS:format(tsize(selectedIDs)), {
				{loc.REG_LIST_ACTIONS_MASS_REMOVE, "actions_delete"},
			}});
	end
	displayDropDown(self, values, onCompanionActionSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : IGNORED
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateIgnoredLine(line, unitID)
	line.id = unitID;
	_G[line:GetName().."Name"]:SetText(unitID);
	_G[line:GetName().."Info"]:SetText("");
	_G[line:GetName().."Time"]:SetText("");
	_G[line:GetName().."Info2"]:SetText("");
	_G[line:GetName().."Addon"]:SetText("");
	_G[line:GetName().."Select"]:Hide();
	setTooltipForSameFrame(_G[line:GetName().."Click"], "TOPLEFT", 0, 5, unitID, loc.REG_LIST_IGNORE_TT:format(getIgnoredList()[unitID]));
	setTooltipForSameFrame(_G[line:GetName().."ClickMiddle"]);
	setTooltipForSameFrame(_G[line:GetName().."ClickRight"]);
end

local function getIgnoredLines()
	if tsize(getIgnoredList()) == 0 then
		TRP3_RegisterListEmpty:SetText(loc.REG_LIST_IGNORE_EMPTY);
	end
	TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER);
	TRP3_RegisterListHeaderInfo:SetText("");
	TRP3_RegisterListHeaderTime:SetText("");
	TRP3_RegisterListHeaderTimeTT:Disable();
	TRP3_RegisterListHeaderInfoTT:Disable();
	TRP3_RegisterListHeaderNameTT:Disable();
	TRP3_RegisterListHeaderInfo2:SetText("");

	return getIgnoredList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : LIST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function refreshList()
	local lines;
	TRP3_RegisterListEmpty:Hide();
	TRP3_RegisterListHeaderActions:Hide();

	if currentMode == MODE_CHARACTER then
		lines = getCharacterLines();
		TRP3_RegisterList.decorate = decorateCharacterLine;
	elseif currentMode == MODE_PETS then
		lines = getCompanionLines();
		TRP3_RegisterList.decorate = decorateCompanionLine;
	elseif currentMode == MODE_IGNORE then
		lines = getIgnoredLines();
		TRP3_RegisterList.decorate = decorateIgnoredLine;
	end

	if tsize(lines) == 0 then
		TRP3_RegisterListEmpty:Show();
	end
	initList(TRP3_RegisterList, lines, TRP3_RegisterListSlider);
end

local function onLineClicked(self)
	if currentMode == MODE_CHARACTER then
		assert(self:GetParent().id, "No profileID on line.");
		if IsShiftKeyDown() then
			TRP3_API.RegisterPlayerChatLinksModule:InsertLink(self:GetParent().id);
		else
			openPage(self:GetParent().id);
		end
	elseif currentMode == MODE_PETS then
		assert(self:GetParent().id, "No profileID on line.");
		if IsShiftKeyDown() then
			TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_COMPANION_PROFILE, function(canBeImported)
				TRP3_API.RegisterCompanionChatLinksModule:InsertLink(self:GetParent().id, canBeImported);
			end);
		else
			openCompanionPage(self:GetParent().id);
		end
	elseif currentMode == MODE_IGNORE then
		assert(self:GetParent().id, "No unitID on line.");
		unignoreID(self:GetParent().id);
		refreshList();
	end
end

local function onLineSelected(self)
	assert(self:GetParent().id, "No id on line.");
	selectedIDs[self:GetParent().id] = self:GetChecked() or nil;
end

local function changeMode(_, value)
	currentMode = value;
	wipe(selectedIDs);
	TRP3_RegisterListCharactFilter:Hide();
	TRP3_RegisterListPetFilter:Hide();
	TRP3_RegisterListHeaderAddon:SetText("");
	if currentMode == MODE_CHARACTER then
		TRP3_RegisterListCharactFilter:Show();
		TRP3_RegisterListHeaderAddon:SetText(loc.REG_LIST_ADDON);
	elseif currentMode == MODE_PETS then
		TRP3_RegisterListPetFilter:Show();
		TRP3_RegisterListHeaderAddon:SetText(loc.REG_LIST_PET_MASTER);
	end
	refreshList();
	Events.fireEvent(Events.NAVIGATION_TUTORIAL_REFRESH, REGISTER_LIST_PAGEID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup;

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_RegisterMainTabBar", TRP3_RegisterList);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, 0);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
	{
		{loc.REG_LIST_CHAR_TITLE, 1, 150},
		{loc.REG_LIST_PETS_TITLE, 2, 150},
		{loc.REG_LIST_IGNORE_TITLE, 3, 150},
	},
	changeMode
	);
end

local TUTORIAL_CHARACTER;

local function createTutorialStructure()
	TUTORIAL_CHARACTER = {
		{
			box = {
				x = 20, y = -45, anchor = "TOPLEFT", width = 28, height = 340
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_LIST_CHAR_TUTO_ACTIONS,
				arrow = "LEFT"
			}
		},
		{
			box = {
				x = 50, y = -45, anchor = "TOPLEFT", width = 470, height = 340
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_LIST_CHAR_TUTO_LIST,
				textWidth = 400,
				arrow = "DOWN"
			}
		},
		{
			box = {
				x = 20, y = -387, anchor = "TOPLEFT", width = 500, height = 60
			},
			button = {
				x = 0, y = 10, anchor = "CENTER",
				text = loc.REG_LIST_CHAR_TUTO_FILTER,
				textWidth = 400,
				arrow = "UP"
			}
		}
	}
end

local function tutorialProvider()
	if currentMode == MODE_CHARACTER then
		return TUTORIAL_CHARACTER;
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	createTutorialStructure();

	-- To try, but I'm afraid for performances ...
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
		if getCurrentPageID() == REGISTER_LIST_PAGEID and unitID ~= Globals.player_id and (not dataType or dataType == "characteristics") then
			refreshList();
		end
	end);

	Events.listenToEvent(Events.REGISTER_PROFILE_DELETED, function(profileID)
		if profileID then
			selectedIDs[profileID] = nil;
			if isMenuRegistered(currentlyOpenedProfilePrefix .. profileID) then
				unregisterMenu(currentlyOpenedProfilePrefix .. profileID);
			end
		else
			for selectedProfileId, _ in pairs(selectedIDs) do
				if isMenuRegistered(currentlyOpenedProfilePrefix .. selectedProfileId) then
					unregisterMenu(currentlyOpenedProfilePrefix .. selectedProfileId);
				end
			end
			wipe(selectedIDs);
		end
		if getCurrentPageID() == REGISTER_LIST_PAGEID then
			refreshList();
		end
	end);

	registerMenu({
		id = REGISTER_PAGE,
		closeable = true,
		text = loc.REG_REGISTER,
		onSelected = function() setPage(REGISTER_LIST_PAGEID); end,
	});

	registerPage({
		id = REGISTER_LIST_PAGEID,
		templateName = "TRP3_RegisterList",
		frameName = "TRP3_RegisterList",
		frame = TRP3_RegisterList,
		onPagePostShow = function() tabGroup:SelectTab(1); end,
		tutorialProvider = tutorialProvider,
	});

	TRP3_RegisterListSlider:SetValue(0);
	handleMouseWheel(TRP3_RegisterListContainer, TRP3_RegisterListSlider);
	local widgetTab = {};
	for i=1,14 do
		local widget = _G["TRP3_RegisterListLine"..i];
		local widgetClick = _G["TRP3_RegisterListLine"..i.."Click"];
		local widgetSelect = _G["TRP3_RegisterListLine"..i.."Select"];
		widgetSelect:SetScript("OnClick", onLineSelected);
		widgetClick:SetScript("OnClick", onLineClicked);
		widgetClick:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
		widgetClick:SetAlpha(0.75);
		table.insert(widgetTab, widget);
	end
	TRP3_RegisterList.widgetTab = widgetTab;
	TRP3_RegisterListFilterCharactNotes:SetChecked(false);
	TRP3_RegisterListFilterCharactName:SetScript("OnEnterPressed", refreshList);
	TRP3_RegisterListFilterCharactGuild:SetScript("OnEnterPressed", refreshList);
	TRP3_RegisterListFilterCharactRealm:SetScript("OnClick", refreshList);
	TRP3_RegisterListFilterCharactNotes:SetScript("OnClick", refreshList);
	TRP3_RegisterListCharactFilterButton:SetScript("OnClick", function(_, button)
		if button == "RightButton" then
			TRP3_RegisterListFilterCharactName:SetText("");
			TRP3_RegisterListFilterCharactGuild:SetText("");
			TRP3_RegisterListFilterCharactRealm:SetChecked(true);
			TRP3_RegisterListFilterCharactNotes:SetChecked(false);
		end
		refreshList();
	end)
	setTooltipForSameFrame(TRP3_RegisterListCharactFilterButton, "LEFT", 0, 5, loc.REG_LIST_FILTERS, loc.REG_LIST_FILTERS_TT);
	TRP3_RegisterListFilterCharactNameText:SetText(loc.REG_LIST_NAME);
	TRP3_RegisterListFilterCharactGuildText:SetText(loc.REG_LIST_GUILD);
	TRP3_RegisterListFilterCharactRealmText:SetText(loc.REG_LIST_REALMONLY);
	TRP3_RegisterListFilterCharactNotesText:SetText(loc.REG_LIST_NOTESONLY);
	TRP3_RegisterListHeaderAddon:SetText(loc.REG_LIST_ADDON);
	TRP3_API.ui.frame.setupEditBoxesNavigation({TRP3_RegisterListFilterCharactName, TRP3_RegisterListFilterCharactGuild});

	TRP3_RegisterListPetFilterName:SetScript("OnEnterPressed", refreshList);
	TRP3_RegisterListPetFilterType:SetScript("OnEnterPressed", refreshList);
	TRP3_RegisterListPetFilterMaster:SetScript("OnEnterPressed", refreshList);
	TRP3_RegisterListPetFilterButton:SetScript("OnClick", function(_, button)
		if button == "RightButton" then
			TRP3_RegisterListPetFilterName:SetText("");
			TRP3_RegisterListPetFilterType:SetText("");
			TRP3_RegisterListPetFilterMaster:SetText("");
		end
		refreshList();
	end)
	setTooltipForSameFrame(TRP3_RegisterListPetFilterButton, "LEFT", 0, 5, loc.REG_LIST_FILTERS, loc.REG_LIST_FILTERS_TT);
	TRP3_RegisterListPetFilterNameText:SetText(loc.REG_LIST_PET_NAME);
	TRP3_RegisterListPetFilterTypeText:SetText(loc.REG_LIST_PET_TYPE);
	TRP3_RegisterListPetFilterMasterText:SetText(loc.REG_LIST_PET_MASTER);
	TRP3_API.ui.frame.setupEditBoxesNavigation({TRP3_RegisterListPetFilterName, TRP3_RegisterListPetFilterType, TRP3_RegisterListPetFilterMaster});

	TRP3_RegisterListHeaderNameTT:SetScript("OnClick", switchNameSorting);
	TRP3_RegisterListHeaderInfoTT:SetScript("OnClick", switchInfoSorting);
	TRP3_RegisterListHeaderTimeTT:SetScript("OnClick", switchTimeSorting);

	setTooltipForSameFrame(TRP3_RegisterListHeaderActions, "TOP", 0, 0, loc.CM_ACTIONS);
	TRP3_RegisterListHeaderActions:SetScript("OnClick", function(self)
		if currentMode == MODE_CHARACTER then
			onCharactersActions(self);
		elseif currentMode == MODE_PETS then
			onPetsActions(self);
		end
	end);

	createTabBar();


	-- Resizing
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		for _, line in pairs(widgetTab) do
			line:SetHeight((containerHeight - 120) * 0.065);
			if containerwidth < 690 then
				_G[line:GetName() .. "Time"]:SetWidth(2);
			else
				_G[line:GetName() .. "Time"]:SetWidth(160);
			end
			if containerwidth < 850 then
				_G[line:GetName() .. "Addon"]:SetWidth(2);
			else
				_G[line:GetName() .. "Addon"]:SetWidth(160);
			end
		end
		if containerwidth < 690 then
			TRP3_RegisterListHeaderTime:SetWidth(2);
		else
			TRP3_RegisterListHeaderTime:SetWidth(160);
		end
		if containerwidth < 850 then
			TRP3_RegisterListHeaderAddon:SetWidth(2);
		else
			TRP3_RegisterListHeaderAddon:SetWidth(160);
		end
	end);

end);

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_a_page",
			configText = loc.TF_OPEN_CHARACTER,
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			condition = function(_, unitID)
				return unitID == Globals.player_id or (isUnitIDKnown(unitID) and hasProfile(unitID));
			end,
			onClick = function(unitID)
				openMainFrame();
				openPageByUnitID(unitID);
			end,
			adapter = function(buttonStructure, unitID)
				buttonStructure.tooltip = loc.REG_PLAYER;
				buttonStructure.tooltipSub =  "|cffffff00" .. loc.CM_CLICK .. ": |r" .. loc.TF_OPEN_CHARACTER;
				buttonStructure.alert = nil;
				if unitID ~= Globals.player_id and hasProfile(unitID) then
					local profile = getUnitIDProfile(unitID);
					if profile.about and not profile.about.read then
						buttonStructure.tooltipSub =  "|cff00ff00" .. loc.REG_TT_NOTIF .. "\n" .. buttonStructure.tooltipSub;
						buttonStructure.alert = true;
					end
				end
			end,
			alertIcon = "Interface\\GossipFrame\\AvailableQuestIcon",
			icon = Globals.is_classic and "INV_Misc_Book_09" or "inv_inscription_scroll"
		});
	end
end);
