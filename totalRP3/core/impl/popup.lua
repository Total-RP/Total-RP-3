----------------------------------------------------------------------------------
-- Total RP 3
-- Popups API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- Public accessor
TRP3_API.popup = {};

-- imports
local Utils = TRP3_API.utils;
local loc, table = TRP3_API.locale.getText, table;
local initList = TRP3_API.ui.list.initList;
local tinsert, tremove, _G, pairs, wipe, math, assert = tinsert, tremove, _G, pairs, wipe, math, assert;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local setTooltipForFrame, setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForFrame, TRP3_API.ui.tooltip.setTooltipForSameFrame;
local hooksecurefunc, GetItemIcon, IsControlKeyDown = hooksecurefunc, GetItemIcon, IsControlKeyDown;
local getIconList, getIconListSize, getImageList, getImageListSize, getMusicList, getMusicListSize;
local hexaToNumber, numberToHexa = TRP3_API.utils.color.hexaToNumber, TRP3_API.utils.color.numberToHexa;
local strconcat = strconcat;
local safeMatch = TRP3_API.utils.str.safeMatch;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups definition
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

StaticPopupDialogs["TRP3_INFO"] = {
	button1 = OKAY,
	timeout = false,
	whileDead = true,
	hideOnEscape = true
};

StaticPopupDialogs["TRP3_CONFIRM"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept();
		end
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel();
		end
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
};

StaticPopupDialogs["TRP3_INPUT_TEXT"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(false);
		-- Remove letters limit that other add-ons might have added but not cleaned
		_G[self:GetName().."EditBox"]:SetMaxLetters(0);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept(_G[self:GetName().."EditBox"]:GetText());
		end
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel();
		end
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent().button1:GetScript("OnClick")(self:GetParent().button1);
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent().button2:GetScript("OnClick")(self:GetParent().button2);
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = true,
};

StaticPopupDialogs["TRP3_INPUT_NUMBER"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(true);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept(_G[self:GetName().."EditBox"]:GetNumber());
		end
	end,
	OnHide = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(false);
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel();
		end
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent().button1:GetScript("OnClick")(self:GetParent().button1);
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent().button2:GetScript("OnClick")(self:GetParent().button2);
	end,
	timeout = false,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox = true,
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- local POPUP_HEAD = "|TInterface\\AddOns\\totalRP3\\resources\\trp3logo:113:263|t\n \n";
local POPUP_HEAD = "Total RP 3\n \n";

-- Show a simple alert with a OK button.
function TRP3_API.popup.showAlertPopup(text)
	StaticPopupDialogs["TRP3_INFO"].text = POPUP_HEAD..text;
	local dialog = StaticPopup_Show("TRP3_INFO");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showConfirmPopup(text, onAccept, onCancel)
	StaticPopupDialogs["TRP3_CONFIRM"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_CONFIRM");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
	end
end

function TRP3_API.popup.showTextInputPopup(text, onAccept, onCancel, default)
	StaticPopupDialogs["TRP3_INPUT_TEXT"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_TEXT");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
		_G[dialog:GetName().."EditBox"]:SetText(default or "");
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

function TRP3_API.popup.showNumberInputPopup(text, onAccept, onCancel, default)
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_NUMBER");
	if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER", UIParent, "CENTER");
		_G[dialog:GetName().."EditBox"]:SetNumber(default or false);
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Dynamic popup
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_PopupsFrame = TRP3_PopupsFrame;

local function showPopup(popup)
	for _, frame in pairs({TRP3_PopupsFrame:GetChildren()}) do
		frame:Hide();
	end
	TRP3_PopupsFrame:Show();
	popup:Show();
end

local function hidePopups()
	TRP3_PopupsFrame:Hide();
end
TRP3_API.popup.hidePopups = hidePopups;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Music browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local TRP3_MusicBrowser = TRP3_MusicBrowser;
local musicWidgetTab = {};
local filteredMusicList;

local function decorateMusic(lineFrame, musicURL)
	musicURL = filteredMusicList[musicURL];
	local musicName = musicURL:reverse();
	musicName = (musicName:sub(1, musicName:find("%\\")-1)):reverse();

	setTooltipForFrame(lineFrame, lineFrame, "RIGHT", 0, -30, musicName,
	("|cff00ff00%s\n\n|cffff9900%s: |cffffffff%s\n|cffff9900%s: |cffffffff%s"):format(musicURL, loc("CM_L_CLICK"), loc("REG_PLAYER_ABOUT_MUSIC_SELECT2"), loc("CM_R_CLICK"), loc("REG_PLAYER_ABOUT_MUSIC_LISTEN")));
	_G[lineFrame:GetName().."Text"]:SetText(musicName);
	lineFrame.musicURL = musicURL;
end

local function onMusicClick(lineFrame, mousebutton)
	if mousebutton == "LeftButton" then
		hidePopups();
		TRP3_MusicBrowser:Hide();
		if TRP3_MusicBrowserContent.callback then
			TRP3_MusicBrowserContent.callback(lineFrame.musicURL);
		end
	elseif lineFrame.musicURL then
		Utils.music.playMusic(lineFrame.musicURL);
	end
end

local function filteredMusicBrowser()
	local filter = TRP3_MusicBrowserFilterBox:GetText();
	if filteredMusicList and filteredMusicList ~= getMusicList() then  -- Remove previous filtering if is not full list
		wipe(filteredMusicList);
		filteredMusicList = nil;
	end
	filteredMusicList = getMusicList(filter); -- Music tab is unfiltered

	TRP3_MusicBrowserTotal:SetText( (#filteredMusicList) .. " / " .. getMusicListSize() );
	initList(
		{
			widgetTab = musicWidgetTab,
			decorate = decorateMusic
		},
		filteredMusicList,
		TRP3_MusicBrowserContentSlider
	);
end

local function initMusicBrowser()
	handleMouseWheel(TRP3_MusicBrowserContent, TRP3_MusicBrowserContentSlider);
	TRP3_MusicBrowserContentSlider:SetValue(0);
	-- Create lines
	for line = 0, 8 do
		local lineFrame = CreateFrame("Button", "TRP3_MusicBrowserButton_"..line, TRP3_MusicBrowserContent, "TRP3_MusicBrowserLine");
		lineFrame:SetPoint("TOP", TRP3_MusicBrowserContent, "TOP", 0, -10 + (line * (-31)));
		lineFrame:SetScript("OnClick", onMusicClick);
		tinsert(musicWidgetTab, lineFrame);
	end

	TRP3_MusicBrowserFilterBox:SetScript("OnTextChanged", filteredMusicBrowser);

	TRP3_MusicBrowserTitle:SetText(loc("UI_MUSIC_BROWSER"));
	TRP3_MusicBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	TRP3_MusicBrowserFilterStop:SetText(loc("REG_PLAYER_ABOUT_MUSIC_STOP"));
	filteredMusicBrowser();
end

local function showMusicBrowser(callback)
	TRP3_MusicBrowserContent.callback = callback;
	TRP3_MusicBrowserFilterBox:SetText("");
	TRP3_MusicBrowserFilterBox:SetFocus();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_IconBrowser = TRP3_IconBrowser;
local iconWidgetTab = {};
local filteredIconList;
local ui_IconBrowserContent = TRP3_IconBrowserContent;

local function decorateIcon(icon, index)
	icon:SetNormalTexture("Interface\\ICONS\\"..filteredIconList[index]);
	icon:SetPushedTexture("Interface\\ICONS\\"..filteredIconList[index]);
	setTooltipForFrame(icon, TRP3_IconBrowser, "RIGHT", 0, -100, Utils.str.icon(filteredIconList[index], 75), filteredIconList[index]);
	icon.index = index;
end

local function onIconClick(icon)
	TRP3_API.popup.hideIconBrowser();
	if ui_IconBrowserContent.onSelectCallback then
		ui_IconBrowserContent.onSelectCallback(filteredIconList[icon.index], icon);
	end
end

local function onIconClose()
	TRP3_API.popup.hideIconBrowser();
	if ui_IconBrowserContent.onCancelCallback then
		ui_IconBrowserContent.onCancelCallback();
	end
end

local function filteredIconBrowser()
	local filter = TRP3_IconBrowserFilterBox:GetText();
	if filteredIconList and filteredIconList ~= getIconList() then -- Remove previous filtering if is not full list
		wipe(filteredIconList);
		filteredIconList = nil;
	end
	filteredIconList = getIconList(filter);
	TRP3_IconBrowserTotal:SetText( (#filteredIconList) .. " / " .. getIconListSize() );
	initList(
		{
			widgetTab = iconWidgetTab,
			decorate = decorateIcon
		},
		filteredIconList,
		TRP3_IconBrowserContentSlider
	);
end

local function initIconBrowser()
	handleMouseWheel(ui_IconBrowserContent, TRP3_IconBrowserContentSlider);
	TRP3_IconBrowserContentSlider:SetValue(0);
	-- Create icons
	local row, column;

	for row = 0, 5 do
		for column = 0, 7 do
			local button = CreateFrame("Button", "TRP3_IconBrowserButton_"..row.."_"..column, ui_IconBrowserContent, "TRP3_IconBrowserButton");
			button:ClearAllPoints();
			button:SetPoint("TOPLEFT", ui_IconBrowserContent, "TOPLEFT", 15 + (column * 45), -15 + (row * (-45)));
			button:SetScript("OnClick", onIconClick);
			tinsert(iconWidgetTab, button);
		end
	end

	TRP3_IconBrowserFilterBox:SetScript("OnTextChanged", filteredIconBrowser);
	TRP3_IconBrowserClose:SetScript("OnClick", onIconClose);

	TRP3_IconBrowserTitle:SetText(loc("UI_ICON_BROWSER"));
	TRP3_IconBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	filteredIconBrowser();
end

local function showIconBrowser(onSelectCallback, onCancelCallback, scale)
	ui_IconBrowserContent.onSelectCallback = onSelectCallback;
	ui_IconBrowserContent.onCancelCallback = onCancelCallback;
	TRP3_IconBrowserFilterBox:SetText("");
	TRP3_IconBrowserFilterBox:SetFocus();
	TRP3_IconBrowser:SetScale(scale or 1);
end

function TRP3_API.popup.hideIconBrowser()
	hidePopups();
	TRP3_IconBrowser:Hide();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_CompanionBrowser = TRP3_CompanionBrowser;
local companionWidgetTab = {};
local filteredCompanionList = {};
local ui_CompanionBrowserContent = TRP3_CompanionBrowserContent;
local GetNumPets, GetPetInfoByIndex = C_PetJournal.GetNumPets, C_PetJournal.GetPetInfoByIndex;
local GetMountIDs, GetMountInfoByID = C_MountJournal.GetMountIDs, C_MountJournal.GetMountInfoByID;
local currentCompanionType;

local function onCompanionClick(button)
	TRP3_CompanionBrowser:Hide();
	hidePopups();
	if ui_CompanionBrowserContent.onSelectCallback then
		ui_CompanionBrowserContent.onSelectCallback(filteredCompanionList[button.index], currentCompanionType, button);
	end
end

local function onCompanionClose()
	TRP3_CompanionBrowser:Hide();
	hidePopups();
	if ui_CompanionBrowserContent.onCancelCallback then
		ui_CompanionBrowserContent.onCancelCallback();
	end
end

local function decorateCompanion(button, index)
	local name, icon = filteredCompanionList[index][1], filteredCompanionList[index][2];
	local description, speciesName = filteredCompanionList[index][3], filteredCompanionList[index][4];
	button:SetNormalTexture(icon);
	button:SetPushedTexture(icon);
	local text = "|cffffff00" .. speciesName .. "|r";
	if description and description:len() > 0 then
		text = text .. "\n\"" .. description .. "\"";
	end
	setTooltipForFrame(button, TRP3_CompanionBrowser, "RIGHT", 0, -100,
		"|T" .. icon .. ":40|t " .. name, text);
	button.index = index;
end

local function nameComparator(elem1, elem2)
	return elem1[1] < elem2[1];
end

local function getWoWCompanionFilteredList(filter)
	local count = 0;
	wipe(filteredCompanionList);

	if currentCompanionType == TRP3_API.ui.misc.TYPE_BATTLE_PET then
		-- Battle pets
		local numPets, numOwned = GetNumPets();
		for i = 1, numPets do
			local petID, speciesID, owned, customName, level, favorite, isRevoked, speciesName, icon, petType, companionID, tooltip, description = GetPetInfoByIndex(i);
			-- Only renamed pets can be bound
			if customName and (filter:len() == 0 or safeMatch(customName:lower(), filter)) then
				tinsert(filteredCompanionList, {customName, icon, description, speciesName});
				count = count + 1;
			end
		end
	elseif currentCompanionType == TRP3_API.ui.misc.TYPE_MOUNT then
		-- Mounts
		for i, id in pairs(GetMountIDs()) do
			local creatureName, spellID, icon, active, _, _, _, _, _, _, isCollected = GetMountInfoByID(id);
			if isCollected and creatureName and (filter:len() == 0 or safeMatch(creatureName:lower(), filter)) then
				local _, description = C_MountJournal.GetMountInfoExtraByID(id);
				tinsert(filteredCompanionList, {creatureName, icon, description, loc("PR_CO_MOUNT"), spellID, id});
				count = count + 1;
			end
		end
	end

	table.sort(filteredCompanionList, nameComparator);

	return count;
end

local function filteredCompanionBrowser()
	local filter = TRP3_CompanionBrowserFilterBox:GetText():lower();
	local isOk = TRP3_API.utils.str.safeMatch("", filter) ~= nil;
	local totalCompanionCount = getWoWCompanionFilteredList(isOk and filter or "");
	TRP3_CompanionBrowserTotal:SetText( (#filteredCompanionList) .. " / " .. totalCompanionCount );
	initList(
		{
			widgetTab = companionWidgetTab,
			decorate = decorateCompanion
		},
		filteredCompanionList,
		TRP3_CompanionBrowserContentSlider
	);
end

local function initCompanionBrowser()
	handleMouseWheel(ui_CompanionBrowserContent, TRP3_CompanionBrowserContentSlider);
	TRP3_CompanionBrowserContentSlider:SetValue(0);
	-- Create icons
	local row, column;

	for row = 0, 5 do
		for column = 0, 7 do
			local button = CreateFrame("Button", "TRP3_CompanionBrowserButton_"..row.."_"..column, ui_CompanionBrowserContent, "TRP3_IconBrowserButton");
			button:ClearAllPoints();
			button:SetPoint("TOPLEFT", ui_CompanionBrowserContent, "TOPLEFT", 15 + (column * 45), -15 + (row * (-45)));
			button:SetScript("OnClick", onCompanionClick);
			tinsert(companionWidgetTab, button);
		end
	end

	TRP3_CompanionBrowserFilterBox:SetScript("OnTextChanged", filteredCompanionBrowser);
	TRP3_CompanionBrowserClose:SetScript("OnClick", onCompanionClose);
	setTooltipForSameFrame(TRP3_CompanionBrowserFilterHelp, "TOPLEFT", 0, 0,
		"|TInterface\\ICONS\\icon_petfamily_beast:25|t " .. loc("UI_COMPANION_BROWSER_HELP") ,loc("UI_COMPANION_BROWSER_HELP_TT"));

	TRP3_CompanionBrowserFilterBoxText:SetText(loc("UI_FILTER"));
end

function TRP3_API.popup.showCompanionBrowser(onSelectCallback, onCancelCallback, companionType)
	currentCompanionType = companionType or TRP3_API.ui.misc.TYPE_BATTLE_PET;
	if currentCompanionType == TRP3_API.ui.misc.TYPE_BATTLE_PET then
		TRP3_CompanionBrowserTitle:SetText(loc("REG_COMPANION_BROWSER_BATTLE"));
		TRP3_CompanionBrowserFilterHelp:Show();
		TRP3_RefreshTooltipForFrame(TRP3_CompanionBrowserFilterHelp);
	else
		TRP3_CompanionBrowserTitle:SetText(loc("REG_COMPANION_BROWSER_MOUNT"));
		TRP3_CompanionBrowserFilterHelp:Hide();
	end
	ui_CompanionBrowserContent.onSelectCallback = onSelectCallback;
	ui_CompanionBrowserContent.onCancelCallback = onCancelCallback;
	TRP3_CompanionBrowserFilterBox:SetText("");
	filteredCompanionBrowser();
	showPopup(TRP3_CompanionBrowser);
	TRP3_CompanionBrowserFilterBox:SetFocus();

	if currentCompanionType == TRP3_API.ui.misc.TYPE_BATTLE_PET then
		TRP3_RefreshTooltipForFrame(TRP3_CompanionBrowserFilterHelp);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Color browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_ColorBrowser, TRP3_ColorBrowserColor = TRP3_ColorBrowser, TRP3_ColorBrowserColor;
local toast = TRP3_API.ui.tooltip.toast;
local Color, ColorManager = TRP3_API.Ellyb.Color, TRP3_API.Ellyb.ColorManager;

local COLOR_PRESETS_BASIC = {
	{ CO = ColorManager.RED, TX = loc("CM_RED")},
	{ CO = ColorManager.ORANGE, TX = loc("CM_ORANGE")},
	{ CO = ColorManager.YELLOW, TX = loc("CM_YELLOW")},
	{ CO = ColorManager.GREEN, TX = loc("CM_GREEN")},
	{ CO = ColorManager.CYAN, TX = loc("CM_CYAN")},
	{ CO = ColorManager.BLUE, TX = loc("CM_BLUE")},
	{ CO = ColorManager.PURPLE, TX = loc("CM_PURPLE")},
	{ CO = ColorManager.PINK, TX = loc("CM_PINK")},
	{ CO = ColorManager.WHITE, TX = loc("CM_WHITE")},
	{ CO = ColorManager.GREY, TX = loc("CM_GREY")},
	{ CO = ColorManager.BLACK, TX = loc("CM_BLACK")},
}

local COLOR_PRESETS_CLASS = {
	{ CO = ColorManager.HUNTER, TX = ({GetClassInfo(3)})[1]},
	{ CO = ColorManager.WARLOCK, TX = ({GetClassInfo(9)})[1]},
	{ CO = ColorManager.PRIEST, TX = ({GetClassInfo(5)})[1]},
	{ CO = ColorManager.PALADIN, TX = ({GetClassInfo(2)})[1]},
	{ CO = ColorManager.MAGE, TX = ({GetClassInfo(8)})[1]},
	{ CO = ColorManager.ROGUE, TX = ({GetClassInfo(4)})[1]},
	{ CO = ColorManager.DRUID, TX = ({GetClassInfo(11)})[1]},
	{ CO = ColorManager.SHAMAN, TX = ({GetClassInfo(7)})[1]},
	{ CO = ColorManager.WARRIOR, TX = ({GetClassInfo(1)})[1]},
	{ CO = ColorManager.DEATHKNIGHT, TX = ({GetClassInfo(6)})[1]},
	{ CO = ColorManager.MONK, TX = ({GetClassInfo(10)})[1]},
	{ CO = ColorManager.DEMONHUNTER, TX = ({GetClassInfo(12)})[1]},
}
table.sort(COLOR_PRESETS_CLASS, function(a,b) return a.TX<b.TX end)

local COLOR_PRESETS_RESOURCES = {
	{ CO = ColorManager.POWER_MANA, TX = MANA},
	{ CO = ColorManager.POWER_RAGE, TX = RAGE},
	{ CO = ColorManager.POWER_FOCUS, TX = FOCUS},
	{ CO = ColorManager.POWER_ENERGY, TX = ENERGY},
	{ CO = ColorManager.POWER_COMBO_POINTS, TX = COMBO_POINTS},
	{ CO = ColorManager.POWER_RUNES, TX = RUNES},
	{ CO = ColorManager.POWER_RUNIC_POWER, TX = RUNIC_POWER},
	{ CO = ColorManager.POWER_SOUL_SHARDS, TX = SOUL_SHARDS},
	{ CO = ColorManager.POWER_LUNAR_POWER, TX = LUNAR_POWER},
	{ CO = ColorManager.POWER_HOLY_POWER, TX = HOLY_POWER},
	{ CO = ColorManager.POWER_MAELSTROM, TX = MAELSTROM},
	{ CO = ColorManager.POWER_INSANITY, TX = INSANITY},
	{ CO = ColorManager.POWER_CHI, TX = CHI},
	{ CO = ColorManager.POWER_ARCANE_CHARGES, TX = ARCANE_CHARGES},
	{ CO = ColorManager.POWER_FURY, TX = FURY},
	{ CO = ColorManager.POWER_PAIN, TX = PAIN},
	{ CO = ColorManager.POWER_AMMOSLOT, TX = AMMOSLOT},
	{ CO = ColorManager.POWER_FUEL, TX = FUEL},
}
table.sort(COLOR_PRESETS_RESOURCES, function(a,b) return a.TX<b.TX end)

local COLOR_PRESETS_ITEMS = {
	{ CO = ColorManager.ITEM_POOR, TX = ITEM_QUALITY0_DESC},
	{ CO = ColorManager.ITEM_COMMON, TX = ITEM_QUALITY1_DESC},
	{ CO = ColorManager.ITEM_UNCOMMON, TX = ITEM_QUALITY2_DESC},
	{ CO = ColorManager.ITEM_RARE, TX = ITEM_QUALITY3_DESC},
	{ CO = ColorManager.ITEM_EPIC, TX = ITEM_QUALITY4_DESC},
	{ CO = ColorManager.ITEM_LEGENDARY, TX = ITEM_QUALITY5_DESC},
	{ CO = ColorManager.ITEM_ARTIFACT, TX = ITEM_QUALITY6_DESC},
	{ CO = ColorManager.ITEM_HEIRLOOM, TX = ITEM_QUALITY7_DESC},
	{ CO = ColorManager.ITEM_WOW_TOKEN, TX = ITEM_QUALITY8_DESC},
}

local function colorPresetsDropDownSelection(hexValue)
	local r, g, b = ColorManager.hexaToNumber(hexValue);
	TRP3_ColorBrowser.red = r;
	TRP3_ColorBrowser.green = g;
	TRP3_ColorBrowser.blue = b;
	TRP3_ColorBrowserColor:SetColorRGB(r, g, b);
	TRP3_ColorBrowserSwatch:SetColorTexture(r, g, b);
end

local function colorPresetsDropDown()
	local values = {};

	local values_basic = {};
	for index, preset in pairs(COLOR_PRESETS_BASIC) do
		tinsert(values_basic, { preset.CO:WrapTextInColorCode(preset.TX), preset.CO:GenerateHexadecimalColor() });
	end
	tinsert(values, {loc("UI_COLOR_BROWSER_PRESETS_BASIC"), values_basic});

	local values_classes = {};
	for index, preset in pairs(COLOR_PRESETS_CLASS) do
		tinsert(values_classes, { preset.CO:WrapTextInColorCode(preset.TX), preset.CO:GenerateHexadecimalColor() });
	end
	tinsert(values, {loc("UI_COLOR_BROWSER_PRESETS_CLASSES"), values_classes});

	local values_resources = {};
	for index, preset in pairs(COLOR_PRESETS_RESOURCES) do
		tinsert(values_resources, { preset.CO:WrapTextInColorCode(preset.TX), preset.CO:GenerateHexadecimalColor() });
	end
	tinsert(values, {loc("UI_COLOR_BROWSER_PRESETS_RESOURCES"), values_resources});

	local values_items = {};
	for index, preset in pairs(COLOR_PRESETS_ITEMS) do
		tinsert(values_items, { preset.CO:WrapTextInColorCode(preset.TX), preset.CO:GenerateHexadecimalColor() });
	end
	tinsert(values, {loc("UI_COLOR_BROWSER_PRESETS_ITEMS"), values_items});

	local values_custom = {};
	for index, preset in pairs(TRP3_Colors) do
		tinsert(values_custom, { Color(preset.CO):WrapTextInColorCode(preset.TX), preset.CO });
	end
	tinsert(values, {loc("UI_COLOR_BROWSER_PRESETS_CUSTOM"), values_custom});

	displayDropDown(TRP3_ColorBrowserPresets, values, colorPresetsDropDownSelection, 0, true);
end

local function saveCustomColor(color, name)
	TRP3_ColorBrowserEditBox:ClearFocus();
	TRP3_ColorBrowserNameEditBox:ClearFocus();

	local hexaColorCode = "#" .. color:GenerateHexadecimalColor(true);
	if (name == "") then
		name = hexaColorCode;
	end

	local indexToUpdate;
	for index, preset in pairs(TRP3_Colors) do
		if (Color(preset.CO):IsEqualTo(color)) then
			indexToUpdate = index;
			break
		end
	end

	if (indexToUpdate) then
		TRP3_Colors[indexToUpdate].TX = name;
	else
		tinsert(TRP3_Colors, { CO = hexaColorCode, TX = name });
		table.sort(TRP3_Colors, function(a,b) return ColorManager.compareHSL(Color(a.CO),Color(b.CO)) end)
	end
end

local function deleteCustomColor(color)
	TRP3_ColorBrowserEditBox:ClearFocus();
	TRP3_ColorBrowserNameEditBox:ClearFocus();

	local indexToDelete;
	for index, preset in pairs(TRP3_Colors) do
		if (Color(preset.CO):IsEqualTo(color)) then
			indexToDelete = index;
			break
		end
	end
	if (indexToDelete) then
		tremove(TRP3_Colors, indexToDelete);
		TRP3_ColorBrowserNameEditBox:SetText("");
	end
end

local function initColorBrowser()
	TRP3_ColorBrowserSelect:SetText(loc("UI_COLOR_BROWSER_SELECT"));
	TRP3_ColorBrowserTitle:SetText(loc("UI_COLOR_BROWSER"));
	TRP3_ColorBrowserPresets:SetText(loc("UI_COLOR_BROWSER_PRESETS"));
	TRP3_ColorBrowserSave:SetText(loc("CM_SAVE"));
	TRP3_ColorBrowserDelete:SetText(loc("CM_DELETE"));

	if not TRP3_Colors then
		TRP3_Colors = {};
	end

	TRP3_ColorBrowserEditBoxText:SetText("Code");
	setTooltipForSameFrame(TRP3_ColorBrowserEditBoxHelp, "RIGHT", 0, 5, loc("BW_COLOR_CODE"), loc("BW_COLOR_CODE_TT"));

	TRP3_ColorBrowserNameEditBoxText:SetText(loc("CM_NAME"));
	setTooltipForSameFrame(TRP3_ColorBrowserNameEditBoxHelp, "RIGHT", 0, 5, loc("BW_CUSTOM_NAME"), loc("BW_CUSTOM_NAME_TT"));

	TRP3_ColorBrowserEditBox:SetScript("OnEnterPressed", function(self)
		if self:GetText():match("^%x%x%x%x%x%x$") or self:GetText():match("^#%x%x%x%x%x%x$") then -- Checks that it is a 6 figures hexadecimal number (with or without a #)
			local r, g, b = ColorManager.hexaToNumber(self:GetText());
			TRP3_ColorBrowser.red = r;
			TRP3_ColorBrowser.green = g;
			TRP3_ColorBrowser.blue = b;
			TRP3_ColorBrowserColor:SetColorRGB(r, g, b);
			TRP3_ColorBrowserSwatch:SetColorTexture(r, g, b);
			self:ClearFocus();
		else
			toast(loc("BW_COLOR_CODE_ALERT"), 1);
		end
	end);

	TRP3_ColorBrowserNameEditBox:SetScript("OnEnterPressed", function(self)
		if (self:GetText() ~= "") then
			saveCustomColor(Color(TRP3_ColorBrowser.red, TRP3_ColorBrowser.green, TRP3_ColorBrowser.blue), TRP3_ColorBrowserNameEditBox:GetText());
			TRP3_ColorBrowserDelete:Enable();
		else
			self:ClearFocus();
		end
	end);

	TRP3_ColorBrowserColor:SetScript("OnColorSelect", function(self, r, g, b)
		TRP3_ColorBrowserEditBox:ClearFocus();
		TRP3_ColorBrowserNameEditBox:ClearFocus();

		TRP3_ColorBrowserSwatch:SetColorTexture(r, g, b);
		TRP3_ColorBrowser.red = r;
		TRP3_ColorBrowser.green = g;
		TRP3_ColorBrowser.blue = b;
		TRP3_ColorBrowserEditBox:SetText(("#%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255):upper());

		TRP3_ColorBrowserNameEditBox:SetText("");
		TRP3_ColorBrowserDelete:Disable();
		for index, preset in pairs(TRP3_Colors) do
			if (Color(preset.CO):IsEqualTo(Color(r, g, b))) then
				local name = preset.TX;
				if (name == preset.CO) then
					name = "";
				end
				TRP3_ColorBrowserNameEditBox:SetText(name);

				TRP3_ColorBrowserDelete:Enable();
				break
			end
		end
	end);

	TRP3_ColorBrowserSelect:SetScript("OnClick", function()
		hidePopups();
		TRP3_ColorBrowser:Hide();
		if TRP3_ColorBrowser.callback ~= nil then
			TRP3_ColorBrowser.callback((TRP3_ColorBrowser.red or 1) * 255, (TRP3_ColorBrowser.green or 1) * 255, (TRP3_ColorBrowser.blue or 1) * 255);
		end
	end);

	TRP3_ColorBrowserPresets:SetScript("OnClick", colorPresetsDropDown);

	TRP3_ColorBrowserSave:SetScript("OnClick", function()
		saveCustomColor(Color(TRP3_ColorBrowser.red, TRP3_ColorBrowser.green, TRP3_ColorBrowser.blue), TRP3_ColorBrowserNameEditBox:GetText());
		TRP3_ColorBrowserDelete:Enable();
	end);

	TRP3_ColorBrowserDelete:SetScript("OnClick", function()
		deleteCustomColor(Color(TRP3_ColorBrowser.red, TRP3_ColorBrowser.green, TRP3_ColorBrowser.blue));
		TRP3_ColorBrowserDelete:Disable();
	end);
end

local function showColorBrowser(callback, red, green, blue)
	TRP3_ColorBrowserColor:SetColorRGB((red or 255) / 255, (green or 255) / 255, (blue or 255) / 255);
	TRP3_ColorBrowser.callback = callback;
end

function TRP3_ColorButtonLoad(self)
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	self.setColor = function(red, green, blue)
		self.red = red;
		self.green = green;
		self.blue = blue;
		if red and green and blue then
			_G[self:GetName() .. "SwatchBg"]:SetColorTexture(red / 255, green / 255, blue / 255);
			_G[self:GetName() .. "SwatchBgHighlight"]:SetVertexColor(red / 255, green / 255, blue / 255);
		else
			_G[self:GetName() .. "SwatchBg"]:SetTexture("Interface\\ICONS\\icon_petfamily_mechanical");
			_G[self:GetName() .. "SwatchBgHighlight"]:SetVertexColor(1.0, 1.0, 1.0);
		end
		if self.onSelection then
			self.onSelection(red, green, blue);
		end
		_G[self:GetName() .. "BlinkAnimate"]:Play();
		_G[self:GetName() .. "BlinkAnimate"]:Finish();
	end
	self.setColor();
end

function TRP3_API.popup.showDefaultColorPicker(popupArgs)
	local setColor, r, g, b = unpack(popupArgs);

	ColorPickerFrame:SetColorRGB((r or 255) / 255, (g or 255) / 255, (b or 255) / 255);
	ColorPickerFrame.hasOpacity = false;
	ColorPickerFrame.opacity = 1;

	-- func is called every time the color is changed, whereas opacityFunc is only called when changing opacity or pressing OKAY
	-- Since we don't have opacity, I put the callback on opacityFunc to have the same behaviour as TRP3 color picker.
	ColorPickerFrame.func = function()
	end

	ColorPickerFrame.opacityFunc = function()
		local newR, newG, newB = ColorPickerFrame:GetColorRGB();
		setColor(newR * 255, newG * 255, newB * 255);
	end

	ColorPickerFrame.cancelFunc = function()
		setColor(r, g, b);
	end

	ShowUIPanel(ColorPickerFrame);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Image browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local imageWidgetTab = {};
local filteredImageList = {};
local TRP3_ImageBrowser = TRP3_ImageBrowser;

local function onImageSelect()
	assert(TRP3_ImageBrowserContent.currentImage, "No current image ...");
	hidePopups();
	TRP3_ImageBrowser:Hide();
	if TRP3_ImageBrowser.callback then
		TRP3_ImageBrowser.callback(filteredImageList[TRP3_ImageBrowserContent.currentImage]);
	end
end

local function decorateImage(texture, index)
	local image = filteredImageList[index];
	local ratio = image.height / image.width;
	texture:SetHeight(texture:GetWidth() * ratio);
	texture:SetTexture(image.url);
	TRP3_ImageBrowserContentURL:SetText(image.url:sub(11));
	TRP3_ImageBrowserContent.currentImage = index;
end

local function filteredImageBrowser()
	local filter = TRP3_ImageBrowserFilterBox:GetText();
	filteredImageList = getImageList(filter);
	local size = #filteredImageList;
	TRP3_ImageBrowserTotal:SetText( size .. " / " .. getImageListSize() );
	if size > 0 then
		TRP3_ImageBrowserSelect:Enable();
	else
		TRP3_ImageBrowserSelect:Disable();
	end
	initList(
		{
			widgetTab = imageWidgetTab,
			decorate = decorateImage
		},
		filteredImageList,
		TRP3_ImageBrowserContentSlider
	);
end

local function initImageBrowser()
	handleMouseWheel(TRP3_ImageBrowserContent, TRP3_ImageBrowserContentSlider);
	TRP3_ImageBrowserContentSlider:SetValue(0);
	TRP3_ImageBrowserFilterBox:SetScript("OnTextChanged", filteredImageBrowser);
	TRP3_ImageBrowserSelect:SetScript("OnClick", onImageSelect);

	tinsert(imageWidgetTab, TRP3_ImageBrowserContentTexture);

	TRP3_ImageBrowserTitle:SetText(loc("UI_IMAGE_BROWSER"));
	TRP3_ImageBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	TRP3_ImageBrowserSelect:SetText(loc("UI_IMAGE_SELECT"));
	filteredImageBrowser();
end

local function showImageBrowser(callback, externalFrame)
	TRP3_ImageBrowser.callback = callback;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.popup.init()
	getIconList, getIconListSize = TRP3_API.utils.resources.getIconList, TRP3_API.utils.resources.getIconListSize;
	getImageList, getImageListSize = TRP3_API.utils.resources.getImageList, TRP3_API.utils.resources.getImageListSize;
	getMusicList, getMusicListSize = TRP3_API.utils.resources.getMusicList, TRP3_API.utils.resources.getMusicListSize;

	initIconBrowser();
	initCompanionBrowser();
	initMusicBrowser();
	initColorBrowser();
	initImageBrowser();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- POPUP REFACTOR
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tostring, type, unpack = tostring, type, unpack;

TRP3_API.popup.IMAGES = "images";
TRP3_API.popup.ICONS = "icons";
TRP3_API.popup.COLORS = "colors";
TRP3_API.popup.MUSICS = "musics";
TRP3_API.popup.COMPANIONS = "companions";

local POPUP_STRUCTURE = {
	[TRP3_API.popup.IMAGES] = {
		frame = TRP3_ImageBrowser,
		showMethod = showImageBrowser,
	},
	[TRP3_API.popup.COLORS] = {
		frame = TRP3_ColorBrowser,
		showMethod = showColorBrowser,
	},
	[TRP3_API.popup.ICONS] = {
		frame = TRP3_IconBrowser,
		showMethod = showIconBrowser,
	},
	[TRP3_API.popup.MUSICS] = {
		frame = TRP3_MusicBrowser,
		showMethod = showMusicBrowser,
	},
	[TRP3_API.popup.COMPANIONS] = {
		frame = TRP3_CompanionBrowser,
		showMethod = TRP3_API.popup.showCompanionBrowser,
	}
}
TRP3_API.popup.POPUPS = POPUP_STRUCTURE;

function TRP3_API.popup.showPopup(popupID, popupPosition, popupArgs)
	assert(popupID and POPUP_STRUCTURE[popupID], "Unknown popupID: " .. tostring(popupID));
	assert(popupPosition == nil or type(popupPosition) == "table", "PopupPosition must be a table or be nil");
	assert(popupArgs == nil or type(popupArgs) == "table", "PopupArgs must be a table or be nil");

	local popup = POPUP_STRUCTURE[popupID];

	popup.frame:ClearAllPoints();

	if popupPosition and popupPosition.parent then
		popup.frame:SetParent(popupPosition.parent);
		popup.frame:SetPoint(popupPosition.point or "CENTER", popupPosition.parent, popupPosition.parentPoint or "CENTER", 0, 0);
		popup.frame:SetFrameLevel(popupPosition.parent:GetFrameLevel() + 20);
		popup.frame:Show();
	else
		popup.frame:SetParent(TRP3_PopupsFrame);
		popup.frame:SetPoint("CENTER", 0, 0);
		for _, frame in pairs({TRP3_PopupsFrame:GetChildren()}) do
			frame:Hide();
		end
		TRP3_PopupsFrame:Show();
		popup.frame:Show();
	end

	if popup.showMethod then
		popup.showMethod(unpack(popupArgs));
	end

end