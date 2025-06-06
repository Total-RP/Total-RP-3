-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- imports
local Globals, Events = TRP3_API.globals, TRP3_Addon.Events;
local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local unitIDToInfo = Utils.str.unitIDToInfo;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local isMenuRegistered = TRP3_API.navigation.menu.isMenuRegistered;
local registerMenu, selectMenu, openMainFrame = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu, TRP3_API.navigation.openMainFrame;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local getUnitIDCharacter = TRP3_API.register.getUnitIDCharacter;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile = TRP3_API.register.hasProfile;
local getCompleteName = TRP3_API.register.getCompleteName;
local getProfile = TRP3_API.register.getProfile;
local getIgnoredList, unignoreID, isIDIgnored = TRP3_API.register.getIgnoredList, TRP3_API.register.unignoreID, TRP3_API.register.isIDIgnored;
local getRelationText, getRelationTooltipText = TRP3_API.register.relation.getRelationText, TRP3_API.register.relation.getRelationTooltipText;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local showAlertPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showConfirmPopup;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local deleteProfile, deleteCharacter, getProfileList = TRP3_API.register.deleteProfile, TRP3_API.register.deleteCharacter, TRP3_API.register.getProfileList;
local ignoreID = TRP3_API.register.ignoreID;
local refreshList;
local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;
local getCompanionProfiles = TRP3_API.companions.register.getProfiles;
local getRelationColor = TRP3_API.register.relation.getRelationColor;
local getCompanionNameFromSpellID = TRP3_API.companions.getCompanionNameFromSpellID;
local unitIDIsFilteredForMatureContent = TRP3_API.register.unitIDIsFilteredForMatureContent;
local profileIDISFilteredForMatureContent = TRP3_API.register.profileIDISFilteredForMatureContent;

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
			icon = [[interface\icons\]] .. TRP3_InterfaceIcons.CharacterMenuItem,
			pageContext = pageContext,
			sortGroup = currentlyOpenedProfilePrefix,
			sortIndex = -time(),
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
			icon = [[interface\icons\]] .. TRP3_InterfaceIcons.CompanionMenuItem,
			sortGroup = currentlyOpenedProfilePrefix,
			sortIndex = -time(),
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

local ARROW_DOWN = "|TInterface\\Buttons\\Arrow-Down-Up:15:15:0:-6|t";
local ARROW_UP = "|TInterface\\Buttons\\Arrow-Up-Up:15|t";

local function getComparatorArrows()
	local nameArrow, relationArrow, timeArrow = "", "", "";
	if sortingType == 1 then
		nameArrow = " " .. ARROW_DOWN;
	elseif sortingType == 2 then
		nameArrow = " " .. ARROW_UP;
	elseif sortingType == 3 then
		relationArrow = " " .. ARROW_DOWN;
	elseif sortingType == 4 then
		relationArrow = " " .. ARROW_UP;
	elseif sortingType == 5 then
		timeArrow = " " .. ARROW_DOWN;
	elseif sortingType == 6 then
		timeArrow = " " .. ARROW_UP;
	end
	return nameArrow, relationArrow, timeArrow;
end

local MODE_CHARACTER, MODE_PETS, MODE_IGNORE = 1, 2, 3;
local selectedIDs = {};
local ICON_SIZE = 30;
local currentMode = 1;
local IGNORED_ICON = Utils.str.texture("Interface\\Buttons\\UI-GroupLoot-Pass-Down", 15);
local NEW_ABOUT_ICON = "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-unread:15:15|t";
local PROFILE_NOTES_ICON = "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-note:15:15|t";
local WALKUP_ICON = "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-walkup:15:15|t";
local MATURE_CONTENT_ICON = Utils.str.texture("Interface\\AddOns\\totalRP3\\resources\\18_emoji.tga", 15);

local function onLineClicked(self, button)
	if currentMode == MODE_CHARACTER then
		assert(self:GetParent().id, "No profileID on line.");
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				TRP3_API.RegisterPlayerChatLinksModule:InsertLink(self:GetParent().id);
			else
				openPage(self:GetParent().id);
			end
		else
			local profile = getProfile(self:GetParent().id);
			if profile.link and TableHasAnyEntries(profile.link) then
				local characterList = {};
				for unitID, _ in pairs(profile.link) do
					local unitName, unitRealm = unitIDToInfo(unitID);
					if unitRealm == Globals.player_realm_id then
						tinsert(characterList, unitName);
					else
						tinsert(characterList, unitName .. "-" .. unitRealm);
					end
				end
				TRP3_API.popup.showCopyDropdownPopup(characterList);
			end
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

local function ResizeLineContents(line)
	local containerWidth = TRP3_MainFramePageContainer:GetWidth();

	if containerWidth < 690 then
		line.Time:SetWidth(2);
	else
		line.Time:SetWidth(160);
	end

	if containerWidth < 850 then
		line.Addon:SetWidth(2);
	else
		line.Addon:SetWidth(160);
	end
end

local function decorateGenericLine(line)
	line.Click:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	line.Click:SetScript("OnClick", onLineClicked);
	line.Click:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue");
	line.Click:SetAlpha(0.75);
	line.Select:SetScript("OnClick", onLineSelected);
	ResizeLineContents(line);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : CHARACTERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCharacterLine(line, elementData)
	decorateGenericLine(line);
	local profileID = elementData[1];
	local profile = getProfile(profileID);
	line.id = profileID;

	local name = getCompleteName(profile.characteristics or {}, UNKNOWN, true);
	local leftTooltipTitle, leftTooltipText = name, "";

	line.Name:SetText(name);
	if profile.characteristics and profile.characteristics.IC then
		leftTooltipTitle = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
	end

	local hasNewAbout = profile.about and not profile.about.read;
	local currentNotes = TRP3_API.profile.getPlayerCurrentProfile().notes or {};
	local hasNotes = TRP3_Notes and TRP3_Notes[profileID] or currentNotes[profileID];
	local isWalkupFriendly = profile.character and profile.character.WU == AddOn_TotalRP3.Enums.WALKUP.YES;

	local atLeastOneIgnored = false;
	line.Info2:SetText("");
	local firstLink;
	if profile.link and TableHasAnyEntries(profile.link) then
		leftTooltipText = leftTooltipText .. loc.REG_LIST_CHAR_TT_CHAR .. "|cnGREEN_FONT_COLOR:";
		for unitID, _ in pairs(profile.link) do
			if not firstLink then
				firstLink = unitID;
			end
			local unitName, unitRealm = unitIDToInfo(unitID);
			if isIDIgnored(unitID) then
				leftTooltipText = leftTooltipText .. "\n - " .. unitName .. " ( " .. unitRealm .. " ) - " .. IGNORED_ICON .. " " .. loc.REG_LIST_IGNORE_TITLE;
				atLeastOneIgnored = true;
			else
				leftTooltipText = leftTooltipText .. "\n - " .. unitName .. " ( " .. unitRealm .. " )";
			end
		end
		leftTooltipText = leftTooltipText .. "|r";
	else
		leftTooltipText = leftTooltipText .. loc.REG_LIST_CHAR_TT_CHAR_NO;
	end

	if profile.time and profile.zone then
		local formatDate = Utils.GenerateFormattedDateString(profile.time);
		leftTooltipText = leftTooltipText .. "\n" .. loc.REG_LIST_CHAR_TT_DATE:format(formatDate, profile.zone);
	end
	-- Middle column : relation
	local relation, relationColor = getRelationText(profileID, true), getRelationColor(profileID);
	local color = (relationColor or TRP3_API.Colors.White):GenerateHexColorMarkup();
	if #relation > 0 then
		if relationColor then
			relation = relationColor:WrapTextInColorCode(relation);
		end
		setTooltipForSameFrame(line.ClickMiddle, "TOPLEFT", 0, 5, loc.REG_RELATION .. ": " .. relation, getRelationTooltipText(profileID, profile));
	else
		setTooltipForSameFrame(line.ClickMiddle);
	end
	line.Info:SetText(color .. relation);

	local timeStr = "";
	if profile.time then
		timeStr = Utils.GenerateFormattedDateString(profile.time);
	end
	line.Time:SetText(timeStr);

	-- Third column : flags
	---@type string[]
	local rightTooltipTexts, flags = {}, {};
	if atLeastOneIgnored then
		table.insert(flags, IGNORED_ICON);
		table.insert(rightTooltipTexts, IGNORED_ICON .. " " .. loc.REG_LIST_CHAR_TT_IGNORE);
	end
	if hasNewAbout then
		table.insert(flags, NEW_ABOUT_ICON);
		table.insert(rightTooltipTexts, NEW_ABOUT_ICON .. " " .. loc.REG_TT_NOTIF);
	end
	if hasNotes then
		table.insert(flags, PROFILE_NOTES_ICON);
		table.insert(rightTooltipTexts, PROFILE_NOTES_ICON .. " " .. loc.REG_NOTES_PROFILE);
	end
	if isWalkupFriendly then
		table.insert(flags, WALKUP_ICON);
		table.insert(rightTooltipTexts, WALKUP_ICON .. " " .. loc.DB_STATUS_WU);
	end
	if profile.hasMatureContent then
		table.insert(flags, MATURE_CONTENT_ICON);
		table.insert(rightTooltipTexts, MATURE_CONTENT_ICON .. " " .. loc.MATURE_FILTER_TOOLTIP_WARNING);
	end
	if #rightTooltipTexts > 0 then
		setTooltipForSameFrame(line.ClickRight, "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipTexts, "\n"));
	else
		setTooltipForSameFrame(line.ClickRight);
	end
	line.Info2:SetText(table.concat(flags, " "));

	local addon = Globals.addon_name;
	if profile.msp then
		addon = "Mary-Sue Protocol";
		if firstLink and isUnitIDKnown(firstLink) then
			local character = getUnitIDCharacter(firstLink);
			addon = character.client or "Mary-Sue Protocol";
		end
	end
	line.Addon:SetText(addon);

	line.Select:SetChecked(selectedIDs[profileID]);
	line.Select:Show();

	setTooltipForSameFrame(line.Click, "TOPLEFT", 0, 5, leftTooltipTitle, leftTooltipText .. "\n\n" ..
		TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_CHARACTER) .. "\n" ..
		TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_CHAR_NAME_COPY) .. "\n" ..
		TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.CL_TOOLTIP));
end

local function getCharacterLines()
	local nameSearch = TRP3_RegisterListFilterCharactName:GetText():lower();
	local guildSearch = TRP3_RegisterListFilterCharactGuild:GetText():lower();
	local realmOnly = TRP3_RegisterListFilterCharactRealm:GetChecked();
	local notesOnly = TRP3_RegisterListFilterCharactNotes:GetChecked();
	local profileList = getProfileList();
	local fullSize = CountTable(profileList);
	local characterLines = {};
	local connectedRealms = tInvert(GetAutoCompleteRealms());

	for profileID, profile in pairs(profileList) do
		local nameIsConform, guildIsConform, realmIsConform, notesIsConform = false, false, false, false;

		-- Don't add default profiles to the directory
		if not TRP3_API.profile.isDefaultProfile(profileID) and profile.characteristics and next(profile.characteristics) ~= nil then

			-- Defines if at least one character is conform to the search criteria
			for unitID, _ in pairs(profile.link or Globals.empty) do
				local unitName, unitRealm = unitIDToInfo(unitID);
				if string.find(unitName:lower(), nameSearch, 1, true) then
					nameIsConform = true;
				end
				if unitRealm == Globals.player_realm_id or connectedRealms[unitRealm] then
					realmIsConform = true;
				end
				local characterData = AddOn_TotalRP3.Directory.getCharacterDataForCharacterId(unitID);
				if characterData and characterData.guild and string.find(characterData.guild:lower(), guildSearch, 1, true) then
					guildIsConform = true;
				end
				local currentNotes = TRP3_API.profile.getPlayerCurrentProfile().notes or {};
				if TRP3_Notes and TRP3_Notes[profileID] or currentNotes[profileID] then
					notesIsConform = true;
				end
			end
			local completeName = getCompleteName(profile.characteristics or {}, "", true);
			if not nameIsConform and string.find(completeName:lower(), nameSearch, 1, true) then
				nameIsConform = true;
			end

			nameIsConform = nameIsConform or #nameSearch == 0;
			guildIsConform = guildIsConform or #guildSearch == 0;
			realmIsConform = realmIsConform or not realmOnly;
			notesIsConform = notesIsConform or not notesOnly;

			if nameIsConform and guildIsConform and realmIsConform and notesIsConform then
				tinsert(characterLines, {profileID, completeName, getRelationText(profileID, true), profile.time});
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
	TRP3_RegisterListCharactFilter:SetTitleText(loc.REG_LIST_CHAR_FILTER:format(lineSize, fullSize));
	TRP3_RegisterListCharactFilter:SetTitleWidth(200);

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
				TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
				TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
				refreshList();
			end);
		end
	elseif value == "purge_unlinked" then
		local profiles = getProfileList();
		local profilesToPurge = {};
		for profileID, profile in pairs(profiles) do
			if not profile.link or TableIsEmpty(profile.link) then
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
				TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
				TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
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
				TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
				TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
				refreshList();
			end);
		end
	elseif value == "purge_all" then
		local list = getProfileList();
		showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_ALL_C:format(CountTable(list)), function()
			for profileID, _ in pairs(list) do
				deleteProfile(profileID, true);
			end
			TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
			TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	-- Mass actions
	elseif value == "actions_delete" then
		showConfirmPopup(loc.REG_LIST_ACTIONS_MASS_REMOVE_C:format(CountTable(selectedIDs)), function()
			for profileID, _ in pairs(selectedIDs) do
				deleteProfile(profileID, true);
			end
			TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
			TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
			refreshList();
		end);
	elseif value == "actions_ignore" then
		local charactToIgnore = {};
		for profileID, _ in pairs(selectedIDs) do
			for unitID, _ in pairs(getProfile(profileID).link or Globals.empty) do
				charactToIgnore[unitID] = true;
			end
		end
		showTextInputPopup(loc.REG_LIST_ACTIONS_MASS_IGNORE_C:format(CountTable(charactToIgnore)), function(text)
			for unitID, _ in pairs(charactToIgnore) do
				ignoreID(unitID, text);
			end
			refreshList();
		end);
	end
end

local function onCharactersActions(button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		local purge = description:CreateButton(loc.REG_LIST_ACTIONS_PURGE);
		purge:CreateButton(loc.REG_LIST_ACTIONS_PURGE_TIME, onCharactersActionSelected, "purge_time");
		purge:CreateButton(loc.REG_LIST_ACTIONS_PURGE_UNLINKED, onCharactersActionSelected, "purge_unlinked");
		purge:CreateButton(loc.REG_LIST_ACTIONS_PURGE_IGNORE, onCharactersActionSelected, "purge_ignore");
		purge:CreateButton(loc.REG_LIST_ACTIONS_PURGE_ALL, onCharactersActionSelected, "purge_all");
		if TableHasAnyEntries(selectedIDs) then
			local mass = description:CreateButton(loc.REG_LIST_ACTIONS_MASS:format(CountTable(selectedIDs)));
			mass:CreateButton(loc.REG_LIST_ACTIONS_MASS_REMOVE, onCharactersActionSelected, "actions_delete");
			mass:CreateButton(loc.REG_LIST_ACTIONS_MASS_IGNORE, onCharactersActionSelected, "actions_ignore");
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : COMPANIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local companionIDToInfo, getAssociationsForProfile = TRP3_API.utils.str.companionIDToInfo, TRP3_API.companions.register.getAssociationsForProfile;
local deleteCompanionProfile = TRP3_API.companions.register.deleteProfile;

local function decorateCompanionLine(line, elementData)
	decorateGenericLine(line);
	local profileID = elementData[1];
	local profile = getCompanionProfiles()[profileID];
	line.id = profileID;

	local hasNewAbout = profile.data and profile.data.read == false;

	local name = UNKNOWN;
	if profile.data and profile.data.NA then
		name = profile.data.NA;
	end
	line.Name:SetText(name);

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
	companionList = companionList .. "|cnGREEN_FONT_COLOR:";
	for companionID, _ in pairs(links) do
		companionList = companionList .. "- " .. getCompanionNameFromSpellID(companionID) .. "\n";
	end
	companionList = companionList .. "|r";
	local masterList, firstMaster = "", "";
	masterList = masterList .. "|cnGREEN_FONT_COLOR:";
	for ownerID, _ in pairs(masters) do
		masterList = masterList .. "- " .. ownerID .. "\n";
		if firstMaster == "" then
			firstMaster = ownerID;
		end
	end
	masterList = masterList .. "|r";

	if isUnitIDKnown(firstMaster) and  TRP3_API.register.profileExists(firstMaster) then
		firstMaster = getCompleteName(getUnitIDProfile(firstMaster).characteristics or {}, "", true);
	end
	line.Addon:SetText(firstMaster);

	local secondLine = loc.REG_LIST_PETS_TOOLTIP .. ":\n" .. companionList .. "\n" .. loc.REG_LIST_PETS_TOOLTIP2 .. ":\n" .. masterList;
	setTooltipForSameFrame(line.Click, "TOPLEFT", 0, 5, tooltip, secondLine .. "\n\n" ..
		TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_COMPANION) .. "\n" ..
		TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.CL_TOOLTIP));
	setTooltipForSameFrame(line.ClickMiddle);

	-- Third column : flags
	---@type string[]
	local rightTooltipText, flags = {}, {};
	if hasNewAbout then
		table.insert(flags, NEW_ABOUT_ICON);
		table.insert(rightTooltipText, NEW_ABOUT_ICON .. " " .. loc.REG_TT_NOTIF);
	end
	if #rightTooltipText > 0 then
		setTooltipForSameFrame(line.ClickRight, "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipText, "\n"));
	else
		setTooltipForSameFrame(line.ClickRight);
	end
	line.Info2:SetText(table.concat(flags, " "));

	line.Select:SetChecked(selectedIDs[profileID]);
	line.Select:Show();

	line.Info:SetText("");
	line.Time:SetText("");
end

local function getCompanionLines()
	local nameSearch = TRP3_RegisterListPetFilterName:GetText():lower();
	local typeSearch = TRP3_RegisterListPetFilterType:GetText():lower();
	local masterSearch = TRP3_RegisterListPetFilterMaster:GetText():lower();
	local profiles = getCompanionProfiles();
	local fullSize = CountTable(profiles);
	local companionLines = {};

	for profileID, profile in pairs(profiles) do
		local nameIsConform, typeIsConform, masterIsConform = false, false, false;

		-- Run this test only if there are criterias
		if #typeSearch > 0 or #masterSearch > 0 then
			for companionFullID, _ in pairs(profile.links) do
				local masterID, companionID = companionIDToInfo(companionFullID);
				if string.find(companionID:lower(), typeSearch, 1, true) then
					typeIsConform = true;
				end
				if string.find(masterID:lower(), masterSearch, 1, true) then
					masterIsConform = true;
				end
			end
		end

		local companionName = UNKNOWN;
		if profile.data and profile.data.NA then
			companionName = profile.data.NA;
		end
		if #nameSearch ~= 0 and profile.data and profile.data.NA and string.find(profile.data.NA:lower(), nameSearch, 1, true) then
			nameIsConform = true;
		end

		nameIsConform = nameIsConform or #nameSearch == 0;
		typeIsConform = typeIsConform or #typeSearch == 0;
		masterIsConform = masterIsConform or #masterSearch == 0;

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
	TRP3_RegisterListPetFilter:SetTitleText(loc.REG_LIST_PETS_FILTER:format(lineSize, fullSize))
	TRP3_RegisterListPetFilter:SetTitleWidth(200);

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
		showConfirmPopup(loc.REG_LIST_ACTIONS_PURGE_ALL_COMP_C:format(CountTable(list)), function()
			for profileID, _ in pairs(list) do
				-- We delete the companion profile without fire events to prevent UI freeze
				deleteCompanionProfile(profileID, DO_NOT_FIRE_EVENTS);
			end
			-- We then fire the event once every profile we needed to delete has been deleted
			TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	elseif value == "actions_delete" then
		showConfirmPopup(loc.REG_LIST_ACTIONS_MASS_REMOVE_C:format(CountTable(selectedIDs)), function()
			for profileID, _ in pairs(selectedIDs) do
				-- We delete the companion profile without fire events to prevent UI freeze
				deleteCompanionProfile(profileID, DO_NOT_FIRE_EVENTS);
			end
			-- We then fire the event once every profile we needed to delete has been deleted
			TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
		end);
	end
end

local function onPetsActions(button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		local purge = description:CreateButton(loc.REG_LIST_ACTIONS_PURGE);
		purge:CreateButton(loc.REG_LIST_ACTIONS_PURGE_ALL, onCompanionActionSelected, "purge_all");
		if TableHasAnyEntries(selectedIDs) then
			local mass = description:CreateButton(loc.REG_LIST_ACTIONS_MASS:format(CountTable(selectedIDs)));
			mass:CreateButton(loc.REG_LIST_ACTIONS_MASS_REMOVE, onCompanionActionSelected, "actions_delete");
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : IGNORED
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateIgnoredLine(line, unitID)
	decorateGenericLine(line);
	line.id = unitID;
	line.Name:SetText(unitID);
	line.Info:SetText("");
	line.Time:SetText("");
	line.Info2:SetText("");
	line.Addon:SetText("");
	line.Select:Hide();
	setTooltipForSameFrame(line.Click, "TOPLEFT", 0, 5, unitID, loc.REG_LIST_IGNORE_TT:format(getIgnoredList()[unitID])
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.REG_LIST_IGNORE_REMOVE));
	setTooltipForSameFrame(line.ClickMiddle);
	setTooltipForSameFrame(line.ClickRight);
end

local function getIgnoredLines()
	if TableIsEmpty(getIgnoredList()) then
		TRP3_RegisterListEmpty:SetText(loc.REG_LIST_IGNORE_EMPTY);
	end
	TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER);
	TRP3_RegisterListHeaderInfo:SetText("");
	TRP3_RegisterListHeaderTime:SetText("");
	TRP3_RegisterListHeaderTimeTT:Disable();
	TRP3_RegisterListHeaderInfoTT:Disable();
	TRP3_RegisterListHeaderNameTT:Disable();
	TRP3_RegisterListHeaderInfo2:SetText("");

	return GetKeysArray(getIgnoredList());
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : LIST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function refreshList()
	local lines;
	local initializer;
	TRP3_RegisterListEmpty:Hide();
	TRP3_RegisterListHeaderActions:Hide();

	if currentMode == MODE_CHARACTER then
		lines = getCharacterLines();
		initializer = decorateCharacterLine;
	elseif currentMode == MODE_PETS then
		lines = getCompanionLines();
		initializer = decorateCompanionLine;
	elseif currentMode == MODE_IGNORE then
		lines = getIgnoredLines();
		initializer = decorateIgnoredLine;
	end

	if TableIsEmpty(lines) then
		TRP3_RegisterListEmpty:Show();
	end

	local provider = CreateDataProvider(lines);
	TRP3_RegisterListContainer.ScrollView:SetElementInitializer("TRP3_RegisterListLine", initializer);
	TRP3_RegisterListContainer.ScrollView:SetDataProvider(provider, ScrollBoxConstants.RetainScrollPosition);
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
	TRP3_Addon:TriggerEvent(Events.NAVIGATION_TUTORIAL_REFRESH, REGISTER_LIST_PAGEID);
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
				allPoints = TRP3_RegisterListContainer.ScrollBox,
			},
			button = {
				x = 0, y = -10, anchor = "TOP",
				text = loc.REG_LIST_CHAR_TUTO_LIST,
				textWidth = 400,
				arrow = "DOWN"
			}
		},
		{
			box = {
				allPoints = TRP3_RegisterListCharactFilter
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

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()
	createTutorialStructure();

	-- To try, but I'm afraid for performances ...
	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_DATA_UPDATED, function(_, unitID, _, dataType)
		if TRP3_MainFrame:IsShown() and getCurrentPageID() == REGISTER_LIST_PAGEID and unitID ~= Globals.player_id and (not dataType or dataType == "characteristics") then
			refreshList();
		end
	end);

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_PROFILE_DELETED, function(_, profileID)
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

	do
		local self = TRP3_RegisterListContainer;

		local scrollBoxAnchorsWithBar = {
			AnchorUtil.CreateAnchor("TOP", self.Header, "BOTTOM", 0, -3),
			AnchorUtil.CreateAnchor("LEFT", self, "LEFT", 16, 0),
			AnchorUtil.CreateAnchor("RIGHT", self, "RIGHT", -16, 0),
			AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 88),
		};

		self.ScrollView = CreateScrollBoxListLinearView();
		ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
		ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithBar);
	end

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
	setTooltipForSameFrame(TRP3_RegisterListCharactFilterButton, "RIGHT", 0, 5, loc.REG_LIST_FILTERS, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_LIST_FILTERS_APPLY)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_FILTERS_CLEAR));
	TRP3_RegisterListFilterCharactNameText:SetText(loc.REG_LIST_NAME);
	TRP3_RegisterListFilterCharactGuildText:SetText(loc.REG_LIST_GUILD);
	TRP3_RegisterListFilterCharactRealm:SetText(loc.REG_LIST_REALMONLY);
	TRP3_RegisterListFilterCharactNotes:SetText(loc.REG_LIST_NOTESONLY);
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
	setTooltipForSameFrame(TRP3_RegisterListPetFilterButton, "RIGHT", 0, 5, loc.REG_LIST_FILTERS, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_LIST_FILTERS_APPLY)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_FILTERS_CLEAR));
	TRP3_RegisterListPetFilterNameText:SetText(loc.REG_LIST_PET_NAME);
	TRP3_RegisterListPetFilterTypeText:SetText(loc.REG_LIST_PET_TYPE);
	TRP3_RegisterListPetFilterMasterText:SetText(loc.REG_LIST_PET_MASTER);
	TRP3_API.ui.frame.setupEditBoxesNavigation({TRP3_RegisterListPetFilterName, TRP3_RegisterListPetFilterType, TRP3_RegisterListPetFilterMaster});

	TRP3_RegisterListHeaderNameTT:SetScript("OnClick", switchNameSorting);
	TRP3_RegisterListHeaderInfoTT:SetScript("OnClick", switchInfoSorting);
	TRP3_RegisterListHeaderTimeTT:SetScript("OnClick", switchTimeSorting);

	setTooltipForSameFrame(TRP3_RegisterListHeaderActions, "RIGHT", 0, 5, loc.CM_OPTIONS, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPTIONS_ADDITIONAL));
	TRP3_RegisterListHeaderActions:SetScript("OnMouseDown", function(self)
		if currentMode == MODE_CHARACTER then
			onCharactersActions(self);
		elseif currentMode == MODE_PETS then
			onPetsActions(self);
		end
	end);

	createTabBar();


	-- Resizing
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.NAVIGATION_RESIZED, function(_, containerwidth, containerHeight)  -- luacheck: no unused
		for _, line in TRP3_RegisterListContainer.ScrollBox:EnumerateFrames() do
			ResizeLineContents(line);
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

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_a_page",
			configText = loc.TF_OPEN_CHARACTER,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, characterID)
				return characterID == Globals.player_id or (isUnitIDKnown(characterID) and hasProfile(characterID));
			end,
			onClick = function(characterID)
				openMainFrame();
				TRP3_API.r.sendQuery(characterID);
				TRP3_API.r.sendMSPQuery(characterID);
				openPageByUnitID(characterID);
			end,
			adapter = function(buttonStructure, characterID)
				-- Initialize the buttonStructure parts.
				buttonStructure.alert = false;
				local factionTag = UnitFactionGroup("target");
				if factionTag == "Alliance" then
					buttonStructure.icon = TRP3_InterfaceIcons.TargetOpenCharacterA;
				elseif factionTag == "Horde" then
					buttonStructure.icon = TRP3_InterfaceIcons.TargetOpenCharacterH;
				else
					buttonStructure.icon = TRP3_InterfaceIcons.TargetOpenCharacterN;
				end
				buttonStructure.tooltip = loc.REG_PLAYER;

				-- Retrieve the character's profile.
				local profile;
				if characterID == Globals.player_id then
					profile = TRP3_API.profile.getData("player");
				else
					profile = getUnitIDProfile(characterID);
				end

				local tooltipLines = {};

				if characterID ~= Globals.player_id and profile.about and not profile.about.read then
					local icon = "Interface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-unread-overlay";
					table.insert(tooltipLines, TRP3_MarkupUtil.GenerateFileMarkup(icon, { size = 16 }) .. loc.REG_TT_NOTIF_LONG_TT);
					buttonStructure.alert = true;
				end

				table.insert(tooltipLines, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_CHARACTER));
				buttonStructure.tooltipSub = table.concat(tooltipLines, "|n|n");
			end,
			alertIcon = "Interface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-unread-overlay",
		});
	end
end);
