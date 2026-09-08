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
local getIgnoredList, unignoreID, isIDIgnored = TRP3_API.register.getIgnoredList, TRP3_API.register.unignoreID, TRP3_API.register.isIDIgnored;
local getRelation, getRelationInfo, getRelationText, getRelationTooltipText = TRP3_API.register.relation.getRelation, TRP3_API.register.relation.getRelationInfo, TRP3_API.register.relation.getRelationText, TRP3_API.register.relation.getRelationTooltipText;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local showAlertPopup, showConfirmPopup = TRP3_API.popup.showAlertPopup, TRP3_API.popup.showConfirmPopup;
local showTextInputPopup = TRP3_API.popup.showTextInputPopup;
local deleteProfile, deleteCharacter, getProfileList = TRP3_API.register.deleteProfile, TRP3_API.register.deleteCharacter, TRP3_API.register.getProfileList;
local ignoreID = TRP3_API.register.ignoreID;
local RefreshRegisterList;
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
	local profile = TRP3_API.register.getProfileOrNil(profileID);
	if not profile then
		return;
	end

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
	if not profile then
		return;
	end

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

local sortingMap = {
	Name = { asc = 1, desc = 2 },
	Info = { asc = 3, desc = 4 },
	Time = { asc = 5, desc = 6 },
	Guild = { asc = 7, desc = 8 },
	Realm = { asc = 9, desc = 10 },
}

local function CompareRelationsAscending(a, b)
	return a.relationOrder < b.relationOrder;
end

local function CompareRelationsDescending(a, b)
	local relationA = a.relationOrder;
	local relationB = b.relationOrder;

	-- Treat 0 as highest value so it goes last when descending.
	if relationA == 0 then relationA = math.huge; end
	if relationB == 0 then relationB = math.huge; end

	return relationA < relationB;
end

local function CompareTimesAscending(a, b)
	local timeA = a.time;
	local timeB = b.time;

	if timeA == nil then
		return false;
	elseif timeB == nil then
		return true;
	end
	return timeA < timeB;
end

local function CompareTimesDescending(a, b)
	local timeA = a.time;
	local timeB = b.time;

	if timeA == nil then
		return false;
	elseif timeB == nil then
		return true;
	end
	return timeA > timeB;
end

local SortingConfigurations = {
	[1] = { sortValue = "name", direction = TRP3_SortKeyDirection.Ascending },
	[2] = { sortValue = "name", direction = TRP3_SortKeyDirection.Descending },
	[3] = { comparator = CompareRelationsAscending },
	[4] = { comparator = CompareRelationsDescending },
	[5] = { comparator = CompareTimesAscending },
	[6] = { comparator = CompareTimesDescending },
	[7] = { sortValue = "guild", direction = TRP3_SortKeyDirection.Ascending },
	[8] = { sortValue = "guild", direction = TRP3_SortKeyDirection.Descending },
	[9] = { sortValue = "realm", direction = TRP3_SortKeyDirection.Ascending },
	[10] = { sortValue = "realm", direction = TRP3_SortKeyDirection.Descending },
}

local function switchSorting(key)
	local pair = sortingMap[key];
	if not pair then
		return;
	end
	sortingType = (sortingType == pair.asc) and pair.desc or pair.asc;
	RefreshRegisterList();
end

---@param direction TRP3.SortKeyDirection
local function CreateUserStringSortOptions(direction)
	return {
		direction = direction,
		emptyKeyPosition = (direction == TRP3_SortKeyDirection.Ascending and TRP3_SortKeyEmptyPosition.Last or nil),
		transliterator = TRP3_Transliterators.LettersOnly,
	};
end

local function getCurrentComparator()
	local configuration = SortingConfigurations[sortingType];
	local comparator;

	if configuration.comparator then
		comparator = configuration.comparator;
	elseif configuration.sortValue then
		comparator = function(a, b)
			a = a.sortKey;
			b = b.sortKey;

			if configuration.direction == TRP3_SortKeyDirection.Descending then
				a, b = b, a;
			end

			return a < b;
		end
	end

	return comparator;
end

local ARROW_DOWN = "|TInterface\\Buttons\\Arrow-Down-Up:15:15:0:-6|t";
local ARROW_UP = "|TInterface\\Buttons\\Arrow-Up-Up:15|t";

---@return string nameArrow
---@return string relationArrow
---@return string timeArrow
---@return string guildArrow
---@return string realmArrow
local function getComparatorArrows()
	local arrows = { "", "", "", "", "" };
	local arrowByType = {
		[1] = {1, ARROW_DOWN}, [2] = {1, ARROW_UP}, -- name
		[3] = {2, ARROW_DOWN}, [4] = {2, ARROW_UP}, -- relation
		[5] = {3, ARROW_DOWN}, [6] = {3, ARROW_UP}, -- time
		[7] = {4, ARROW_DOWN}, [8] = {4, ARROW_UP}, -- guild
		[9] = {5, ARROW_DOWN}, [10] = {5, ARROW_UP}, -- realm
	};

	local entry = arrowByType[sortingType];
	if entry then
		arrows[entry[1]] = " " .. entry[2];
	end

	return unpack(arrows);
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

local function UpdateRegisterListHeaders()
	local nameArrow, relationArrow, timeArrow, guildArrow, realmArrow = getComparatorArrows();

	if currentMode == MODE_CHARACTER then
		TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER .. nameArrow);
		TRP3_RegisterListHeaderRelations:SetText(loc.REG_RELATION .. relationArrow);
		TRP3_RegisterListHeaderTime:SetText(loc.REG_TIME .. timeArrow);
		TRP3_RegisterListHeaderGuild:SetText(loc.REG_GUILD .. guildArrow);
		TRP3_RegisterListHeaderRealm:SetText(loc.REG_REALM .. realmArrow);
		TRP3_RegisterListHeaderFlags:SetText(loc.REG_LIST_FLAGS);
	elseif currentMode == MODE_PETS then
		TRP3_RegisterListHeaderName:SetText(loc.REG_COMPANION .. nameArrow);
		TRP3_RegisterListHeaderRelations:SetText("");
		TRP3_RegisterListHeaderTime:SetText("");
		TRP3_RegisterListHeaderGuild:SetText(loc.REG_LIST_PET_OWNER);
		TRP3_RegisterListHeaderRealm:SetText("");
		TRP3_RegisterListHeaderFlags:SetText(loc.REG_LIST_FLAGS);
	else
		TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER);
		TRP3_RegisterListHeaderRelations:SetText("");
		TRP3_RegisterListHeaderTime:SetText("");
		TRP3_RegisterListHeaderGuild:SetText("");
		TRP3_RegisterListHeaderRealm:SetText("");
		TRP3_RegisterListHeaderFlags:SetText("");
	end
end

local function onIgnoredActions(button, unitID)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		description:CreateTitle(unitID);
		description:CreateButton(loc.CM_EDIT, function()
			TRP3_API.register.ignoreIDConfirm(unitID);
		end);

		description:CreateButton(loc.REG_LIST_IGNORE_REMOVE, function()
			local confirmMessage = string.format(loc.TF_IGNORE_REMOVE_CONFIRM, unitID);

			showConfirmPopup(confirmMessage, function()
				unignoreID(unitID);
				RefreshRegisterList();
			end);
		end);
	end);
end

local function onLineClicked(self, button)
	local id = self:GetParent().id;
	assert(id, "No id on line.");

	if currentMode == MODE_CHARACTER then
		local profile = TRP3_API.register.getProfileOrNil(id);
		if not profile then
			return;
		end

		if button == "LeftButton" then
			if IsShiftKeyDown() then
				TRP3_API.RegisterPlayerChatLinksModule:InsertLink(id);
			else
				openPage(id);
			end
		else
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
		if not getCompanionProfiles()[id] then
			return;
		end

		if IsShiftKeyDown() then
			TRP3_API.ChatLinks:OpenMakeImportablePrompt(loc.CL_COMPANION_PROFILE, function(canBeImported)
				TRP3_API.RegisterCompanionChatLinksModule:InsertLink(id, canBeImported);
			end);
		else
			openCompanionPage(id);
		end
	elseif currentMode == MODE_IGNORE then
		if button == "RightButton" then
			onIgnoredActions(self, id);
		end
	end
end

local function onLineSelected(self)
	local id = self:GetParent().id;
	assert(id, "No id on line.");

	if currentMode == MODE_CHARACTER and not TRP3_API.register.getProfileOrNil(id) then
		self:SetChecked(false);
		return;
	elseif currentMode == MODE_PETS and not getCompanionProfiles()[id] then
		self:SetChecked(false);
		return;
	end

	selectedIDs[id] = self:GetChecked() or nil;
end

local function ResizeLineContents(line)
	local containerWidth = TRP3_MainFramePageContainer:GetWidth();

	local lines = {
		{ field = line.Time,  threshold = 690,  width = 160 },
		{ field = line.GuildOrOwner, threshold = 850,  width = 160 },
		{ field = line.Realm, threshold = 1010, width = 160 },
	}

	for _, lineColumn in ipairs(lines) do
		lineColumn.field:SetWidth(containerWidth < lineColumn.threshold and 2 or lineColumn.width)
	end
end

local function decorateGenericLine(line)
	line.Click:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	line.Click:SetScript("OnClick", onLineClicked);
	line.Select:SetScript("OnClick", onLineSelected);
	ResizeLineContents(line);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : CHARACTERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function decorateCharacterLine(line, elementData)
	decorateGenericLine(line);
	local profileID = elementData.profileID;
	local profile = TRP3_API.register.getProfileOrNil(profileID);
	if not profile then
		return;
	end

	line.id = profileID;

	local name = getCompleteName(profile.characteristics or {}, UNKNOWN, true);
	local leftTooltipTitle, leftTooltipText = name, "";
	local guilds, realms = {}, {};

	line.Name:SetText(name);
	if profile.characteristics and profile.characteristics.IC then
		leftTooltipTitle = Utils.str.icon(profile.characteristics.IC, ICON_SIZE) .. " " .. name;
	end

	local hasNewAbout = profile.about and not profile.about.read;
	local currentNotes = TRP3_API.profile.getPlayerCurrentProfile().notes or {};
	local hasNotes = TRP3_Notes and TRP3_Notes[profileID] or currentNotes[profileID];
	local isWalkupFriendly = profile.character and profile.character.WU == AddOn_TotalRP3.Enums.WALKUP.YES;

	local atLeastOneIgnored = false;
	line.Flags:SetText("");
	local firstLink, firstGuild, firstRealm;
	local lines = {};

	if profile.link and TableHasAnyEntries(profile.link) then
		leftTooltipText = leftTooltipText .. loc.REG_LIST_CHAR_TT_CHAR .. "|cnGREEN_FONT_COLOR:";
		for unitID, _ in pairs(profile.link) do
			local unitName, unitRealm = unitIDToInfo(unitID);
			local character = getUnitIDCharacter(unitID);

			if not firstLink then
				firstLink = unitID;
				firstGuild = character.guild;
				firstRealm = unitRealm;
			end

			if character.guild then
				local exists = false;
				for _, guild in ipairs(guilds) do
					if guild == character.guild then
						exists = true;
						break;
					end
				end

				if not exists then
					table.insert(guilds, character.guild);
				end
			end

			if unitRealm then
				local exists = false;
				for _, realm in ipairs(realms) do
					if realm == unitRealm then
						exists = true;
						break;
					end
				end

				if not exists then
					table.insert(realms, unitRealm);
				end
			end

			local tooltipLine = " - " .. unitName .. " ( " .. unitRealm .. " )";
			if isIDIgnored(unitID) then
				tooltipLine = tooltipLine .. " - " .. IGNORED_ICON .. " " .. loc.REG_LIST_IGNORE_TITLE;
				atLeastOneIgnored = true;
			end
			table.insert(lines, tooltipLine);
		end

		leftTooltipText = leftTooltipText .. "|n" .. table.concat(lines, "|n") .. "|r";
	else
		leftTooltipText = leftTooltipText .. loc.REG_LIST_CHAR_TT_CHAR_NO;
	end

	if profile.time and profile.zone then
		local formatDate = Utils.GenerateFormattedDateString(profile.time);
		leftTooltipText = leftTooltipText .. "|n" .. loc.REG_LIST_CHAR_TT_DATE:format(formatDate, profile.zone);
	end

	local relation, relationColor = getRelationText(profileID, true), getRelationColor(profileID);
	local color = (relationColor or TRP3_API.Colors.White):GenerateHexColorMarkup();
	if #relation > 0 then
		if relationColor then
			relation = relationColor:WrapTextInColorCode(relation);
		end
		setTooltipForSameFrame(line.ClickRelation, "TOPLEFT", 0, 5, loc.REG_RELATION .. ": " .. relation, getRelationTooltipText(profileID, profile));
	else
		setTooltipForSameFrame(line.ClickRelation);
	end
	line.Relations:SetText(color .. relation);

	local timeStr = "";
	if profile.time then
		timeStr = Utils.GenerateFormattedDateString(profile.time);
	end
	line.Time:SetText(timeStr);

	if #guilds > 0 then
		setTooltipForSameFrame(line.ClickGuild, "TOPLEFT", 0, 5, loc.REG_GUILD, "- " .. table.concat(guilds, "|n- "));
	else
		setTooltipForSameFrame(line.ClickGuild);
	end
	line.GuildOrOwner:SetText(firstGuild or "");

	if #realms > 0 then
		setTooltipForSameFrame(line.ClickRealm, "TOPLEFT", 0, 5, loc.REG_REALM, "- " .. table.concat(realms, "|n- "));
	else
		setTooltipForSameFrame(line.ClickRealm);
	end
	line.Realm:SetText(firstRealm);

	-- flags
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
		setTooltipForSameFrame(line.ClickFlags, "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipTexts, "|n"));
	else
		setTooltipForSameFrame(line.ClickFlags);
	end
	line.Flags:SetText(table.concat(flags, " "));

	line.Select:SetChecked(selectedIDs[profileID]);
	line.Select:Show();

	setTooltipForSameFrame(line.ClickName, "TOPLEFT", 0, 5, leftTooltipTitle, leftTooltipText .. "|n|n" ..
		TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_CHARACTER) .. "|n" ..
		TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_CHAR_NAME_COPY) .. "|n" ..
		TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.CL_TOOLTIP));
end

local function CreateCharacterLineBuilder()
	local nameSearch = TRP3_RegisterListFilterCharactName:GetText();
	local nameMatcher = TRP3_StringUtil.CreateMatcher(nameSearch);
	local guildSearch = TRP3_RegisterListFilterCharactGuild:GetText();
	local guildMatcher = TRP3_StringUtil.CreateMatcher(guildSearch);
	local realmOnly = TRP3_RegisterListFilterCharactRealm:GetChecked();
	local notesOnly = TRP3_RegisterListFilterCharactNotes:GetChecked();
	local connectedRealms = tInvert(GetAutoCompleteRealms());
	local currentNotes = TRP3_API.profile.getPlayerCurrentProfile().notes or {};
	local sortingConfiguration = SortingConfigurations[sortingType];
	local sortKeyOptions;

	if sortingConfiguration.sortValue then
		sortKeyOptions = CreateUserStringSortOptions(sortingConfiguration.direction);
	end

	return function(profileID, profile)
		if not profile or TRP3_API.profile.isDefaultProfile(profileID) or not profile.characteristics or next(profile.characteristics) == nil then
			return;
		end

		local nameIsConform, guildIsConform, realmIsConform, notesIsConform = false, false, false, false;
		local firstLink;
		local firstGuild, firstRealm = "", "";
		-- Defines if at least one character is conform to the search criteria
		for unitID, _ in pairs(profile.link or Globals.empty) do
			if not firstLink then
				firstLink = unitID;
			end
			local unitName, unitRealm = unitIDToInfo(unitID);
			if firstLink and isUnitIDKnown(firstLink) then
				firstGuild = getUnitIDCharacter(firstLink).guild or "";
				firstRealm = unitRealm or "";
			end
			if nameMatcher:Matches(unitName) then
				nameIsConform = true;
			end
			if unitRealm == Globals.player_realm_id or connectedRealms[unitRealm] then
				realmIsConform = true;
			end
			local characterData = AddOn_TotalRP3.Directory.getCharacterDataForCharacterId(unitID);
			if characterData and characterData.guild and guildMatcher:Matches(characterData.guild) then
				guildIsConform = true;
			end
			if TRP3_Notes and TRP3_Notes[profileID] or currentNotes[profileID] then
				notesIsConform = true;
			end
		end
		local completeName = getCompleteName(profile.characteristics or {}, "", true);
		if not nameIsConform and nameMatcher:Matches(completeName) then
			nameIsConform = true;
		end

		nameIsConform = nameIsConform or nameSearch == "";
		guildIsConform = guildIsConform or guildSearch == "";
		realmIsConform = realmIsConform or not realmOnly;
		notesIsConform = notesIsConform or not notesOnly;

		if nameIsConform and guildIsConform and realmIsConform and notesIsConform then
			local sortValue = completeName;
			if sortingConfiguration.sortValue == "guild" then
				sortValue = firstGuild;
			elseif sortingConfiguration.sortValue == "realm" then
				sortValue = firstRealm;
			end

			return {
				profileID = profileID,
				name = completeName,
				sortKey = sortKeyOptions and TRP3_StringUtil.GetSortKey(sortValue, sortKeyOptions) or nil,
				relationOrder = getRelationInfo(getRelation(profileID)).order,
				time = profile.time,
				guild = firstGuild,
				realm = firstRealm,
			};
		end
	end;
end

local function ApplyCharacterListState(characterLines)
	local lineSize = #characterLines;
	local fullSize = table.count(getProfileList());
	if lineSize == 0 then
		if fullSize == 0 then
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_CHAR_EMPTY);
		else
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_CHAR_EMPTY2);
		end
	end
	TRP3_RegisterListCharactFilter:SetTitleText(loc.REG_LIST_CHAR_FILTER:format(lineSize, fullSize));
	TRP3_RegisterListCharactFilter:SetTitleWidth(200);

	local nameArrow, relationArrow, timeArrow, guildArrow, realmArrow = getComparatorArrows();
	TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER .. nameArrow);
	TRP3_RegisterListHeaderRelations:SetText(loc.REG_RELATION .. relationArrow);
	TRP3_RegisterListHeaderTime:SetText(loc.REG_TIME .. timeArrow);
	TRP3_RegisterListHeaderGuild:SetText(loc.REG_GUILD .. guildArrow);
	TRP3_RegisterListHeaderRealm:SetText(loc.REG_REALM .. realmArrow);
	TRP3_RegisterListHeaderFlags:SetText(loc.REG_LIST_FLAGS);
	TRP3_RegisterListHeaderNameTT:Enable();
	TRP3_RegisterListHeaderRelationsTT:Enable();
	TRP3_RegisterListHeaderTimeTT:Enable();
	TRP3_RegisterListHeaderGuildTT:Enable();
	TRP3_RegisterListHeaderRealmTT:Enable();
	TRP3_RegisterListHeaderActions:Show();
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
				RefreshRegisterList();
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
				RefreshRegisterList();
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
				RefreshRegisterList();
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
				if TRP3_API.register.getProfileOrNil(profileID) then
					deleteProfile(profileID, true);
				end
			end
			TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED);
			TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILE_DELETED);
			RefreshRegisterList();
		end);
	elseif value == "actions_ignore" then
		local charactToIgnore = {};
		for profileID, _ in pairs(selectedIDs) do
			local profile = TRP3_API.register.getProfileOrNil(profileID);
			if profile then
				for unitID, _ in pairs(profile.link or Globals.empty) do
					charactToIgnore[unitID] = true;
				end
			end
		end
		showTextInputPopup(loc.REG_LIST_ACTIONS_MASS_IGNORE_C:format(CountTable(charactToIgnore)), function(text)
			for unitID, _ in pairs(charactToIgnore) do
				ignoreID(unitID, text);
			end
			RefreshRegisterList();
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
	local profileID = elementData.profileID;
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

	local links, owners = {}, {};
	local fulllinks = getAssociationsForProfile(profileID);
	for _, companionFullID in pairs(fulllinks) do
		local ownerID, companionID = companionIDToInfo(companionFullID);
		links[companionID] = 1;
		owners[ownerID] = 1;
	end

	local companionList = "";
	companionList = companionList .. "|cnGREEN_FONT_COLOR:";
	for companionID, _ in pairs(links) do
		companionList = companionList .. "- " .. getCompanionNameFromSpellID(companionID) .. "|n";
	end
	companionList = companionList .. "|r";
	local ownerList, firstOwner = "", "";
	ownerList = ownerList .. "|cnGREEN_FONT_COLOR:";
	for ownerID, _ in pairs(owners) do
		ownerList = ownerList .. "- " .. ownerID .. "|n";
		if firstOwner == "" then
			firstOwner = ownerID;
		end
	end
	ownerList = ownerList .. "|r";

	if isUnitIDKnown(firstOwner) and  TRP3_API.register.profileExists(firstOwner) then
		firstOwner = getCompleteName(getUnitIDProfile(firstOwner).characteristics or {}, "", true);
	end
	line.GuildOrOwner:SetText(firstOwner);

	local secondLine = loc.REG_LIST_PETS_TOOLTIP .. ":|n" .. companionList .. "|n" .. loc.REG_LIST_PETS_TOOLTIP2 .. ":|n" .. ownerList;
	setTooltipForSameFrame(line.ClickName, "TOPLEFT", 0, 5, tooltip, secondLine .. "|n|n" ..
		TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TF_OPEN_COMPANION) .. "|n" ..
		TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.CL_TOOLTIP));
	setTooltipForSameFrame(line.ClickRelation);

	setTooltipForSameFrame(line.ClickGuild);
	setTooltipForSameFrame(line.ClickRealm);

	-- Flags
	---@type string[]
	local rightTooltipText, flags = {}, {};
	if hasNewAbout then
		table.insert(flags, NEW_ABOUT_ICON);
		table.insert(rightTooltipText, NEW_ABOUT_ICON .. " " .. loc.REG_TT_NOTIF);
	end
	if #rightTooltipText > 0 then
		setTooltipForSameFrame(line.ClickFlags, "TOPLEFT", 0, 5, loc.REG_LIST_FLAGS, table.concat(rightTooltipText, "|n"));
	else
		setTooltipForSameFrame(line.ClickFlags);
	end
	line.Flags:SetText(table.concat(flags, " "));

	line.Select:SetChecked(selectedIDs[profileID]);
	line.Select:Show();

	line.Relations:SetText("");
	line.Time:SetText("");
	line.Realm:SetText("");
end

local function CreateCompanionLineBuilder()
	local nameSearch = TRP3_RegisterListPetFilterName:GetText();
	local nameMatcher = TRP3_StringUtil.CreateMatcher(nameSearch);
	local ownerSearch = TRP3_RegisterListPetFilterOwner:GetText();
	local ownerMatcher = TRP3_StringUtil.CreateMatcher(ownerSearch);
	local sortingConfiguration = SortingConfigurations[sortingType];
	local sortKeyOptions;

	if sortingConfiguration.sortValue then
		sortKeyOptions = CreateUserStringSortOptions(sortingConfiguration.direction);
	end

	return function(profileID, profile)
		if not profile then
			return;
		end

		local nameIsConform, ownerIsConform = false, false;

		if ownerSearch ~= "" then
			for companionFullID, _ in pairs(profile.links) do
				local ownerID = companionIDToInfo(companionFullID);
				if ownerMatcher:Matches(ownerID) then
					ownerIsConform = true;
				end
			end
		end

		local companionName = UNKNOWN;
		if profile.data and profile.data.NA then
			companionName = profile.data.NA;
		end
		if nameSearch ~= "" and profile.data and profile.data.NA and nameMatcher:Matches(profile.data.NA) then
			nameIsConform = true;
		end

		nameIsConform = nameIsConform or nameSearch == "";
		ownerIsConform = ownerIsConform or ownerSearch == "";

		if nameIsConform and ownerIsConform then
			return {
				profileID = profileID,
				name = companionName,
				sortKey = sortKeyOptions and TRP3_StringUtil.GetSortKey(companionName, sortKeyOptions) or nil,
				relationOrder = companionName,
				time = companionName,
			};
		end
	end
end

local function ApplyCompanionListState(companionLines)
	local lineSize = #companionLines;
	local fullSize = table.count(getCompanionProfiles());
	if lineSize == 0 then
		if fullSize == 0 then
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_PETS_EMPTY);
		else
			TRP3_RegisterListEmpty:SetText(loc.REG_LIST_PETS_EMPTY2);
		end
	end
	TRP3_RegisterListPetFilter:SetTitleText(loc.REG_LIST_PETS_FILTER:format(lineSize, fullSize));
	TRP3_RegisterListPetFilter:SetTitleWidth(200);

	local nameArrow = getComparatorArrows();
	TRP3_RegisterListHeaderName:SetText(loc.REG_COMPANION .. nameArrow);
	TRP3_RegisterListHeaderRelations:SetText("");
	TRP3_RegisterListHeaderTime:SetText("");
	TRP3_RegisterListHeaderRealm:SetText("");
	TRP3_RegisterListHeaderFlags:SetText(loc.REG_LIST_FLAGS);
	TRP3_RegisterListHeaderNameTT:Enable();
	TRP3_RegisterListHeaderRelationsTT:Disable();
	TRP3_RegisterListHeaderTimeTT:Disable();
	TRP3_RegisterListHeaderGuildTT:Disable();
	TRP3_RegisterListHeaderRealmTT:Disable();
	TRP3_RegisterListHeaderActions:Show();
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
				if getCompanionProfiles()[profileID] then
					-- We delete the companion profile without fire events to prevent UI freeze
					deleteCompanionProfile(profileID, DO_NOT_FIRE_EVENTS);
				end
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
	line.Relations:SetText("");
	line.Time:SetText("");
	line.Flags:SetText("");
	line.GuildOrOwner:SetText("");
	line.Realm:SetText("");
	line.Select:Hide();
	setTooltipForSameFrame(line.ClickName, "TOPLEFT", 0, 5, unitID, loc.REG_LIST_IGNORE_TT:format(getIgnoredList()[unitID])
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.CM_OPTIONS));
	setTooltipForSameFrame(line.ClickRelation);
	setTooltipForSameFrame(line.ClickGuild);
	setTooltipForSameFrame(line.ClickRealm);
	setTooltipForSameFrame(line.ClickFlags);
end

local function ApplyIgnoredListState(ignoredLines)
	if #ignoredLines == 0 then
		TRP3_RegisterListEmpty:SetText(loc.REG_LIST_IGNORE_EMPTY);
	end
	TRP3_RegisterListHeaderName:SetText(loc.REG_PLAYER);
	TRP3_RegisterListHeaderRelations:SetText("");
	TRP3_RegisterListHeaderTime:SetText("");
	TRP3_RegisterListHeaderGuild:SetText("");
	TRP3_RegisterListHeaderRealm:SetText("");
	TRP3_RegisterListHeaderFlags:SetText("");
	TRP3_RegisterListHeaderNameTT:Disable();
	TRP3_RegisterListHeaderRelationsTT:Disable();
	TRP3_RegisterListHeaderTimeTT:Disable();
	TRP3_RegisterListHeaderGuildTT:Disable();
	TRP3_RegisterListHeaderRealmTT:Disable();
end

local function getIgnoredLines()
	local ignoredArray = GetKeysArray(getIgnoredList());
	local sortKeyOptions = {
		transliterator = TRP3_Transliterators.LettersOnly,
		emptyKeyPosition = TRP3_SortKeyEmptyPosition.Last,
	};
	local sortKeys = {};
	for _, unitID in ipairs(ignoredArray) do
		sortKeys[unitID] = TRP3_StringUtil.GetSortKey(unitID, sortKeyOptions);
	end
	table.sort(ignoredArray, function(a, b)
		return sortKeys[a] < sortKeys[b];
	end);

	return ignoredArray;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI : LIST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

---@alias TRP3.RegisterListRefreshTaskState "pending" | "running" | "finished" | "cancelled"

---@class TRP3.RegisterListRefreshTask
---@field private callbacks TRP3.CallbackDispatcher
---@field private state TRP3.RegisterListRefreshTaskState
---@field private ticker unknown
---@field private worker thread
---@field private searched integer
---@field private total integer
---@field private found integer
---@field private results table
local RegisterListRefreshTask = {};

---@param total integer
---@param update fun(task: TRP3.RegisterListRefreshTask)
---@protected
function RegisterListRefreshTask:__init(total, update)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.state = "pending";
	self.ticker = nil;
	self.worker = coroutine.create(function() update(self); end);
	self.searched = 0;
	self.total = total;
	self.found = 0;
	self.results = {};
end

function RegisterListRefreshTask:Start()
	assert(self.state == "pending", "attempted to restart a register list refresh task");
	self.state = "running";
	self.ticker = C_Timer.NewTicker(0, function() self:OnUpdate(); end);
	self.callbacks:Fire("OnStateChanged", self.state);
end

function RegisterListRefreshTask:Finish()
	if self.state == "finished" or self.state == "cancelled" then
		return;
	end

	if self.ticker then
		self.ticker:Cancel();
		self.ticker = nil;
	end

	self.state = "finished";
	self.callbacks:Fire("OnStateChanged", self.state);
end

function RegisterListRefreshTask:Cancel()
	if self.state ~= "running" and self.state ~= "pending" then
		return;
	end

	if self.ticker then
		self.ticker:Cancel();
		self.ticker = nil;
	end
	self.state = "cancelled";
	self.callbacks:Fire("OnStateChanged", self.state);
end

---@return TRP3.RegisterListRefreshProgress progress
function RegisterListRefreshTask:GetProgress()
	return { found = self.found, searched = self.searched, total = self.total };
end

function RegisterListRefreshTask:GetState()
	return self.state;
end

function RegisterListRefreshTask:GetResults()
	return self.results;
end

---@param result table
function RegisterListRefreshTask:AddResult(result)
	self.found = self.found + 1;
	table.insert(self.results, result);
end

---@param searched integer
function RegisterListRefreshTask:SetSearched(searched)
	self.searched = searched;
end

---@private
function RegisterListRefreshTask:OnUpdate()
	if self.state ~= "running" then
		return;
	end

	local success, errorMessage = coroutine.resume(self.worker);
	if not success then
		self:Cancel();
		securecall(error, errorMessage);
	end

	self.callbacks:Fire("OnProgressChanged", self:GetProgress());

	if coroutine.status(self.worker) == "dead" then
		self:Finish();
	end
end

---@param total integer
---@param update fun(task: TRP3.RegisterListRefreshTask)
---@return TRP3.RegisterListRefreshTask
local function CreateRegisterListRefreshTask(total, update)
	return TRP3_API.CreateObject(RegisterListRefreshTask, total, update);
end

local function CreateRegisterListRefreshTaskFromProfiles(profiles, buildLine)
	local profileIDs = table.keys(profiles);
	local comparator = getCurrentComparator();
	local task;
	local index = 0;

	task = CreateRegisterListRefreshTask(#profileIDs, function(refreshTask)
		if #profileIDs == 0 then
			refreshTask:SetSearched(0);
			return;
		end

		local shouldYieldFromCollection = TRP3_FunctionUtil.CreateAdaptiveTimeBudgetChecker();

		repeat
			index = index + 1;
			local profileID = profileIDs[index];
			local line = buildLine(profileID, profiles[profileID]);

			if line then
				refreshTask:AddResult(line);
			end

			if shouldYieldFromCollection() then
				refreshTask:SetSearched(index);
				coroutine.yield();
			end
		until index >= #profileIDs;

		refreshTask:SetSearched(index);

		local shouldYieldFromSort = TRP3_FunctionUtil.CreateAdaptiveTimeBudgetChecker();
		local results = refreshTask:GetResults();

		local function YieldingComparator(a, b)
			if shouldYieldFromSort() then
				coroutine.yield();
			end

			return comparator(a, b);
		end

		TRP3_SortUtil.MergeSort(results, YieldingComparator);
	end);

	return task;
end

local function CreateCharacterRefreshTask()
	return CreateRegisterListRefreshTaskFromProfiles(getProfileList(), CreateCharacterLineBuilder());
end

local function CreateCompanionRefreshTask()
	return CreateRegisterListRefreshTaskFromProfiles(getCompanionProfiles(), CreateCompanionLineBuilder());
end

local function CreateIgnoredRefreshTask()
	local totalRows = table.count(getIgnoredList());

	-- At present, we don't anticipate ignore lists to be long enough to
	-- require yields across frames. We only use the task infrastructure to
	-- simplify integration elsewhere.
	local function OnUpdate(refreshTask)
		local lines = getIgnoredLines();

		for _, line in ipairs(lines) do
			refreshTask:AddResult(line);
		end

		refreshTask:SetSearched(#lines);
	end

	return CreateRegisterListRefreshTask(totalRows, OnUpdate);
end

local RegisterListModeConfigurations = {
	[MODE_CHARACTER] = {
		CreateRefreshTask = CreateCharacterRefreshTask,
		ApplyListState = ApplyCharacterListState,
		InitializeListElement = decorateCharacterLine,
	},
	[MODE_PETS] = {
		CreateRefreshTask = CreateCompanionRefreshTask,
		ApplyListState = ApplyCompanionListState,
		InitializeListElement = decorateCompanionLine,
	},
	[MODE_IGNORE] = {
		CreateRefreshTask = CreateIgnoredRefreshTask,
		ApplyListState = ApplyIgnoredListState,
		InitializeListElement = decorateIgnoredLine,
	},
};

local activeRefreshTask;
local registerListModels = {};

local function CancelActiveRefreshTask()
	if activeRefreshTask then
		activeRefreshTask:Cancel();
		activeRefreshTask = nil;
	end

	TRP3_RegisterListContainer.RefreshToast:ClearTask();
end

local function CreateRegisterListModel(results, initializer)
	return { results = results, initializer = initializer };
end

local function ApplyRegisterListModel(model)
	if table.isempty(model.results) then
		TRP3_RegisterListEmpty:Show();
	else
		TRP3_RegisterListEmpty:Hide();
	end

	TRP3_RegisterListContainer.ScrollView:SetElementInitializer("TRP3_RegisterListLine", model.initializer);
	TRP3_RegisterListContainer.ScrollView:SetDataProvider(CreateDataProvider(model.results), ScrollBoxConstants.RetainScrollPosition);
end

local function StartRegisterListRefreshTask(task, applyResults)
	activeRefreshTask = task;

	local function PublishResults()
		if activeRefreshTask ~= task or task:GetState() ~= "finished" then
			return;
		end

		activeRefreshTask = nil;
		applyResults(task:GetResults());
	end

	local function OnTaskStateChanged(_, state)
		if state == "finished" then
			PublishResults();
		end
	end

	TRP3_RegisterListContainer.RefreshToast:SetTask(task);
	task.RegisterCallback(TRP3_RegisterListContainer, "OnStateChanged", OnTaskStateChanged);
	task:Start();
end

local function PublishRegisterListModel(mode, results)
	local configuration = RegisterListModeConfigurations[mode];
	local model = CreateRegisterListModel(results, configuration.InitializeListElement);

	registerListModels[mode] = model;
	if currentMode == mode then
		configuration.ApplyListState(results);
		ApplyRegisterListModel(model);
	end
end

function RefreshRegisterList()
	CancelActiveRefreshTask();

	TRP3_RegisterListEmpty:Hide();
	TRP3_RegisterListHeaderActions:Hide();

	local mode = currentMode;
	local configuration = RegisterListModeConfigurations[mode];
	local task = configuration.CreateRefreshTask();

	local function OnTaskResultsReady(results)
		PublishRegisterListModel(mode, results);
	end

	StartRegisterListRefreshTask(task, OnTaskResultsReady);
end

local function changeMode(_, value)
	-- If the tab hasn't changed then we'll trigger an incremental refresh
	-- while preserving the current data.
	if currentMode == value then
		if registerListModels[currentMode] and not activeRefreshTask then
			RefreshRegisterList();
			return;
		elseif activeRefreshTask then
			return;
		end
	end

	currentMode = value;
	wipe(selectedIDs);
	TRP3_RegisterListCharactFilter:Hide();
	TRP3_RegisterListPetFilter:Hide();
	TRP3_RegisterListHeaderGuild:SetText("");
	if currentMode == MODE_CHARACTER then
		TRP3_RegisterListCharactFilter:Show();
		TRP3_RegisterListHeaderGuild:SetText(loc.REG_GUILD);
	elseif currentMode == MODE_PETS then
		TRP3_RegisterListPetFilter:Show();
		TRP3_RegisterListHeaderGuild:SetText(loc.REG_LIST_PET_OWNER);
	end

	TRP3_RegisterListContainer.ScrollBox:ScrollToBegin();

	-- Changing tabs always requests an async refresh. If this is the first
	-- time we've entered a tab, there won't be a model defined - so set an
	-- empty one up. Otherwise, use the most recent model for the tab while
	-- the refresh runs in the background.

	UpdateRegisterListHeaders();
	CancelActiveRefreshTask();

	local mode = currentMode;
	local configuration = RegisterListModeConfigurations[mode];
	local model = registerListModels[mode];
	if model then
		configuration.ApplyListState(model.results);
		ApplyRegisterListModel(model);
	else
		ApplyRegisterListModel(CreateRegisterListModel({}, configuration.InitializeListElement));
	end

	RefreshRegisterList();
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
			RefreshRegisterList();
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
			AnchorUtil.CreateAnchor("TOP", self.Header, "BOTTOM", 0, 0),
			AnchorUtil.CreateAnchor("LEFT", self, "LEFT", 5, 0),
			AnchorUtil.CreateAnchor("RIGHT", self.ScrollBar, "LEFT", -5, 0),
			AnchorUtil.CreateAnchor("BOTTOM", self, "BOTTOM", 0, 90),
		};

		local scrollBoxAnchorsWithoutBar = {
			scrollBoxAnchorsWithBar[1],
			scrollBoxAnchorsWithBar[2],
			AnchorUtil.CreateAnchor("RIGHT", self, "RIGHT", -5, 0),
			scrollBoxAnchorsWithBar[4],
		};

		-- Padding is used to give a small deadzone in the scrollbox for edge
		-- fading. This gives us a small amount of feathering for partially
		-- visible rows, avoiding a hard cutoff at the bottom of the view.
		local paddingTop = 0;
		local paddingBottom = 6;
		local edgeFadeTop = 0;
		local edgeFadeLeft = 0;
		local edgeFadeRight = 0;
		local edgeFadeBottom = paddingBottom;

		self.ScrollBox:SetAlphaGradient(0, CreateVector2D(edgeFadeLeft, edgeFadeTop));
		self.ScrollBox:SetAlphaGradient(1, CreateVector2D(edgeFadeRight, edgeFadeBottom));

		self.ScrollView = CreateScrollBoxListLinearView(paddingTop, paddingBottom);
		ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
		ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
		ScrollUtil.RegisterAlternateRowBehavior(self.ScrollBox, function(frame, isAlternateRow)
			if isAlternateRow then
				frame.Background:SetVertexColor(0.35, 0.25, 0.15, 0.75);
			else
				frame.Background:SetVertexColor(0.35, 0.25, 0.15, 0.6);
			end
		end);
	end

	TRP3_RegisterListFilterCharactNotes:SetChecked(false);
	TRP3_RegisterListFilterCharactName:SetScript("OnEnterPressed", function() RefreshRegisterList(); end);
	TRP3_RegisterListFilterCharactGuild:SetScript("OnEnterPressed", function() RefreshRegisterList(); end);
	TRP3_RegisterListFilterCharactRealm:SetScript("OnClick", function() RefreshRegisterList(); end);
	TRP3_RegisterListFilterCharactNotes:SetScript("OnClick", function() RefreshRegisterList(); end);
	TRP3_RegisterListCharactFilterButton:SetScript("OnClick", function(_, button)
		if button == "RightButton" then
			TRP3_RegisterListFilterCharactName:SetText("");
			TRP3_RegisterListFilterCharactGuild:SetText("");
			TRP3_RegisterListFilterCharactRealm:SetChecked(true);
			TRP3_RegisterListFilterCharactNotes:SetChecked(false);
		end
			RefreshRegisterList();
	end)
	setTooltipForSameFrame(TRP3_RegisterListCharactFilterButton, "RIGHT", 0, 5, loc.REG_LIST_FILTERS, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_LIST_FILTERS_APPLY)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_FILTERS_CLEAR));
	TRP3_RegisterListFilterCharactNameText:SetText(loc.REG_LIST_NAME);
	TRP3_RegisterListFilterCharactGuildText:SetText(loc.REG_LIST_GUILD);
	TRP3_RegisterListFilterCharactRealm:SetText(loc.REG_LIST_REALMONLY);
	TRP3_RegisterListFilterCharactNotes:SetText(loc.REG_LIST_NOTESONLY);
	TRP3_RegisterListHeaderGuild:SetText(loc.REG_GUILD);
	TRP3_RegisterListHeaderRealm:SetText(loc.REG_REALM);
	TRP3_API.ui.frame.setupEditBoxesNavigation({TRP3_RegisterListFilterCharactName, TRP3_RegisterListFilterCharactGuild});

	TRP3_RegisterListPetFilterName:SetScript("OnEnterPressed", function() RefreshRegisterList(); end);
	TRP3_RegisterListPetFilterOwner:SetScript("OnEnterPressed", function() RefreshRegisterList(); end);
	TRP3_RegisterListPetFilterButton:SetScript("OnClick", function(_, button)
		if button == "RightButton" then
			TRP3_RegisterListPetFilterName:SetText("");
			TRP3_RegisterListPetFilterOwner:SetText("");
		end
		RefreshRegisterList();
	end)
	setTooltipForSameFrame(TRP3_RegisterListPetFilterButton, "RIGHT", 0, 5, loc.REG_LIST_FILTERS, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_LIST_FILTERS_APPLY)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_LIST_FILTERS_CLEAR));
	TRP3_RegisterListPetFilterNameText:SetText(loc.REG_LIST_PET_NAME);
	TRP3_RegisterListPetFilterOwnerText:SetText(loc.REG_LIST_PET_OWNER);
	TRP3_API.ui.frame.setupEditBoxesNavigation({TRP3_RegisterListPetFilterName, TRP3_RegisterListPetFilterOwner});

	TRP3_RegisterListHeaderNameTT:SetScript("OnClick", function() switchSorting("Name"); end);
	TRP3_RegisterListHeaderRelationsTT:SetScript("OnClick", function() switchSorting("Info"); end);
	TRP3_RegisterListHeaderTimeTT:SetScript("OnClick", function() switchSorting("Time"); end);
	TRP3_RegisterListHeaderGuildTT:SetScript("OnClick", function() switchSorting("Guild"); end);
	TRP3_RegisterListHeaderRealmTT:SetScript("OnClick", function() switchSorting("Realm"); end);

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

		local headers = {
			{ frame = TRP3_RegisterListHeaderTime,  threshold = 690,  width = 160 },
			{ frame = TRP3_RegisterListHeaderGuild, threshold = 850,  width = 160 },
			{ frame = TRP3_RegisterListHeaderRealm, threshold = 1010, width = 160 },
		}

		for _, headerColumn in ipairs(headers) do
			headerColumn.frame:SetWidth(containerwidth < headerColumn.threshold and 2 or headerColumn.width)
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
