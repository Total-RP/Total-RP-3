----------------------------------------------------------------------------------
-- Total RP 3
-- Character page : Characteristics
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

-- imports
local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local stEtN = Utils.str.emptyToNil;
local stNtE = Utils.str.nilToEmpty;
local get = TRP3_API.profile.getData;
local getProfile = TRP3_API.register.getProfile;
local tcopy, tsize = Utils.table.copy, Utils.table.size;
local numberToHexa, hexaToNumber = Utils.color.numberToHexa, Utils.color.hexaToNumber;
local loc = TRP3_API.locale.getText;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local assert, type, wipe, strconcat, pairs, tinsert, tremove, _G, strtrim = assert, type, wipe, strconcat, pairs, tinsert, tremove, _G, strtrim;
local strjoin, unpack, getKeys = strjoin, unpack, Utils.table.keys;
local getTiledBackground = TRP3_API.ui.frame.getTiledBackground;
local setupDropDownMenu = TRP3_API.ui.listbox.setupDropDownMenu;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getUnitIDCharacter = TRP3_API.register.getUnitIDCharacter;
local getUnitIDProfile, getPlayerCurrentProfile = TRP3_API.register.getUnitIDProfile, TRP3_API.profile.getPlayerCurrentProfile;
local hasProfile, getRelationTexture = TRP3_API.register.hasProfile, TRP3_API.register.relation.getRelationTexture;
local RELATIONS = TRP3_API.register.relation;
local getRelationText, getRelationTooltipText, setRelation = RELATIONS.getRelationText, RELATIONS.getRelationTooltipText, RELATIONS.setRelation;
local CreateFrame = CreateFrame;
local TRP3_RegisterCharact_CharactPanel_Empty = TRP3_RegisterCharact_CharactPanel_Empty;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local showConfirmPopup, showTextInputPopup = TRP3_API.popup.showConfirmPopup, TRP3_API.popup.showTextInputPopup;
local showAlertPopup = TRP3_API.popup.showAlertPopup;
local deleteProfile = TRP3_API.register.deleteProfile;
local selectMenu = TRP3_API.navigation.menu.selectMenu;
local unregisterMenu = TRP3_API.navigation.menu.unregisterMenu;
local ignoreID = TRP3_API.register.ignoreID;
local buildZoneText = Utils.str.buildZoneText;
local setupEditBoxesNavigation = TRP3_API.ui.frame.setupEditBoxesNavigation;

local showIconBrowser = function(callback)
	TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {callback});
end;

local PSYCHO_PRESETS_UNKOWN;
local PSYCHO_PRESETS;
local PSYCHO_PRESETS_DROPDOWN;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

getDefaultProfile().player.characteristics = {
	v = 1,
	RA = Globals.player_race_loc,
	CL = Globals.player_class_loc,
	FN = Globals.player,
	IC = TRP3_API.ui.misc.getUnitTexture(Globals.player_character.race, UnitSex("player")),
	MI = {},
	PS = {}
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SANITIZE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDS_TO_SANITIZE = {
	"RA", "CL", "FN", "LN", "FT", "TI"
}

---@param structure table
---@return boolean
local function sanitizeCharacteristics(structure)
	local somethingWasSanitized = false;

	if structure then
		for _, field in pairs(FIELDS_TO_SANITIZE) do
			if structure[field] then
				local sanitizedValue = Utils.str.sanitize(structure[field]);
				if sanitizedValue ~= structure[field] then
					structure[field] = sanitizedValue;
					somethingWasSanitized = true;
				end
			end
		end
	end

	return somethingWasSanitized
end
TRP3_API.register.ui.sanitizeCharacteristics = sanitizeCharacteristics;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentCompressed;

local function compressData()
	local dataTab = get("player/characteristics");
	local serial = Utils.serial.serialize(dataTab);
	local compressed = Utils.serial.safeEncodeCompressMessage(serial);

	if compressed and compressed:len() < serial:len() then
		currentCompressed = compressed;
	else
		currentCompressed = nil;
	end
end

function TRP3_API.register.player.getCharacteristicsExchangeData()
	if currentCompressed ~= nil then
		return currentCompressed;
	else
		return get("player/characteristics");
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - CONSULT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local registerCharFrame = {};
local registerCharLocals = {
	RA = "REG_PLAYER_RACE",
	CL = "REG_PLAYER_CLASS",
	AG = "REG_PLAYER_AGE",
	EC = "REG_PLAYER_EYE",
	HE = "REG_PLAYER_HEIGHT",
	WE = "REG_PLAYER_WEIGHT",
	BP = "REG_PLAYER_BIRTHPLACE",
	RE = "REG_PLAYER_RESIDENCE"
};
local miscCharFrame = {};
local psychoCharFrame = {};

local function getCompleteName(characteristicsTab, name, hideTitle)
	if not characteristicsTab then
		return name;
	end
	local text = "";
	if not hideTitle and characteristicsTab.TI then
		text = strconcat(characteristicsTab.TI, " ");
	end
	text = strconcat(text, characteristicsTab.FN or name);
	if characteristicsTab.LN then
		text = strconcat(text, " ", characteristicsTab.LN);
	end
	return text;
end

TRP3_API.register.getCompleteName = getCompleteName;

local function getPlayerCompleteName(hideTitle)
	local profile = getPlayerCurrentProfile();
	return getCompleteName(profile.player.characteristics, Globals.player, hideTitle);
end

TRP3_API.register.getPlayerCompleteName = getPlayerCompleteName;

local function refreshPsycho(psychoLine, value)
	local dotIndex;
	for dotIndex = 1, 6 do
		_G[psychoLine:GetName() .. "JaugeDot" .. dotIndex]:Show();
		if dotIndex <= value then
			_G[psychoLine:GetName() .. "JaugeDot" .. dotIndex]:SetTexCoord(0.375, 0.5, 0, 0.125);
		else
			_G[psychoLine:GetName() .. "JaugeDot" .. dotIndex]:SetTexCoord(0, 0.125, 0, 0.125);
		end
	end
	psychoLine.VA = value;
end

local function setBkg(backgroundIndex)
	local backdrop = TRP3_RegisterCharact_CharactPanel:GetBackdrop();
	backdrop.bgFile = getTiledBackground(backgroundIndex);
	TRP3_RegisterCharact_CharactPanel:SetBackdrop(backdrop);
end

local CHAR_KEYS = { "RA", "CL", "AG", "EC", "HE", "WE", "BP", "RE" };
local FIELD_TITLE_SCALE = 0.3;

local function scaleField(field, containerSize, fieldName)
	_G[field:GetName() .. (fieldName or "FieldName")]:SetSize(containerSize * FIELD_TITLE_SCALE, 18);
end

local function setConsultDisplay(context)
	local dataTab = context.profile.characteristics or Globals.empty;
	local hasCharac, hasPsycho, hasMisc, margin;
	assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
	-- Icon, complete name and titles
	local completeName = getCompleteName(dataTab, UNKNOWN);
	TRP3_RegisterCharact_NamePanel_Name:SetText("|cff" .. (dataTab.CH or "ffffff") .. completeName);
	TRP3_RegisterCharact_NamePanel_Title:SetText(dataTab.FT or "");
	setupIconButton(TRP3_RegisterCharact_NamePanel_Icon, dataTab.IC or Globals.icons.profile_default);

	setBkg(dataTab.bkg or 1);

	-- hide all
	for _, regCharFrame in pairs(registerCharFrame) do
		regCharFrame:Hide();
	end
	TRP3_RegisterCharact_CharactPanel_PsychoTitle:Hide();
	TRP3_RegisterCharact_CharactPanel_MiscTitle:Hide();
	TRP3_RegisterCharact_CharactPanel_ResidenceButton:Hide();

	-- Previous var helps for layout building
	local previous = TRP3_RegisterCharact_CharactPanel_RegisterTitle;
	TRP3_RegisterCharact_CharactPanel_RegisterTitle:Hide();

	-- Which directory chars must be shown ?
	local shownCharacteristics = {};
	local shownValues = {};
	for _, attribute in pairs(CHAR_KEYS) do
		if strtrim(dataTab[attribute] or ""):len() > 0 then
			tinsert(shownCharacteristics, attribute);
			shownValues[attribute] = dataTab[attribute];
		end
	end
	if #shownCharacteristics > 0 then
		hasCharac = true;
		TRP3_RegisterCharact_CharactPanel_RegisterTitle:Show();
		margin = 0;
	else
		margin = 50;
	end

	-- Show directory chars values
	for frameIndex, charName in pairs(shownCharacteristics) do
		local frame = registerCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_RegisterInfoLine" .. frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoLine");
			scaleField(frame, TRP3_RegisterCharact_CharactPanel_Container:GetWidth());
			tinsert(registerCharFrame, frame);
		end
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 10);
		frame:SetPoint("RIGHT", 0, 0);
		_G[frame:GetName() .. "FieldName"]:SetText(loc(registerCharLocals[charName]));
		if charName == "EC" then
			local hexa = dataTab.EH or "ffffff"
			_G[frame:GetName() .. "FieldValue"]:SetText("|cff" .. hexa .. shownValues[charName] .. "|r");
		elseif charName == "CL" then
			local hexa = dataTab.CH or "ffffff";
			_G[frame:GetName() .. "FieldValue"]:SetText("|cff" .. hexa .. shownValues[charName] .. "|r");
		else
			_G[frame:GetName() .. "FieldValue"]:SetText(shownValues[charName]);
		end
		if charName == "RE" and dataTab.RC and # dataTab.RC >= 4 then
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:Show();
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:ClearAllPoints();
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:SetPoint("RIGHT", frame:GetName() .. "FieldValue", "LEFT", -5, 0);
			setTooltipForSameFrame(TRP3_RegisterCharact_CharactPanel_ResidenceButton, "RIGHT", 0, 5,
				loc("REG_PLAYER_RESIDENCE_SHOW"), loc("REG_PLAYER_RESIDENCE_SHOW_TT"):format(dataTab.RC[4]));
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:SetScript("OnClick", function()
				MiniMapWorldMapButton:GetScript("OnClick")(MiniMapWorldMapButton, "LeftButton");
				SetMapByID(dataTab.RC[1]);
				TRP3_API.map.placeSingleMarker(dataTab.RC[2], dataTab.RC[3], completeName, TRP3_API.map.DECORATION_TYPES.HOUSE);
			end);
		end
		frame:Show();
		previous = frame;
	end

	-- Misc chars
	if type(dataTab.MI) == "table" and #dataTab.MI > 0 then
		hasMisc = true;
		TRP3_RegisterCharact_CharactPanel_MiscTitle:Show();
		TRP3_RegisterCharact_CharactPanel_MiscTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_MiscTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, margin);
		previous = TRP3_RegisterCharact_CharactPanel_MiscTitle;

		for frameIndex, miscStructure in pairs(dataTab.MI) do
			local frame = miscCharFrame[frameIndex];
			if frame == nil then
				frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscInfoLine" .. frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoLine");
				scaleField(frame, TRP3_RegisterCharact_CharactPanel_Container:GetWidth());
				tinsert(miscCharFrame, frame);
			end
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 7);
			frame:SetPoint("RIGHT", 0, 0);
			_G[frame:GetName() .. "FieldName"]:SetText(strconcat(Utils.str.icon(miscStructure.IC, 18), " ", miscStructure.NA or ""));
			_G[frame:GetName() .. "FieldValue"]:SetText(miscStructure.VA or "");
			frame:Show();
			previous = frame;
		end
	end

	-- Psycho chars
	if type(dataTab.PS) == "table" and #dataTab.PS > 0 then
		hasPsycho = true;
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:Show();
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, margin);
		margin = 0;
		previous = TRP3_RegisterCharact_CharactPanel_PsychoTitle;

		for frameIndex, psychoStructure in pairs(dataTab.PS) do
			local frame = psychoCharFrame[frameIndex];
			local value = psychoStructure.VA;
			if frame == nil then
				frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoInfoLine" .. frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoDisplayLine");
				tinsert(psychoCharFrame, frame);
			end

			-- Preset pointer
			if psychoStructure.ID then
				psychoStructure = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			end

			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
			frame:SetPoint("RIGHT", 0, 0);
			_G[frame:GetName() .. "LeftText"]:SetText(psychoStructure.LT or "");
			_G[frame:GetName() .. "RightText"]:SetText(psychoStructure.RT or "");
			_G[frame:GetName() .. "JaugeLeftIcon"]:SetTexture("Interface\\ICONS\\" .. (psychoStructure.LI or Globals.icons.default));
			_G[frame:GetName() .. "JaugeRightIcon"]:SetTexture("Interface\\ICONS\\" .. (psychoStructure.RI or Globals.icons.default));
			refreshPsycho(frame, value or 3);
			frame:Show();
			previous = frame;
		end
	end

	if not hasCharac and not hasPsycho and not hasMisc then
		TRP3_RegisterCharact_CharactPanel_Empty:Show();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - EDIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- function def
local setEditDisplay;

local draftData;
local psychoEditCharFrame = {};
local miscEditCharFrame = {};


local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.TI = stEtN(strtrim(TRP3_RegisterCharact_Edit_TitleField:GetText()));
	draftData.FN = stEtN(strtrim(TRP3_RegisterCharact_Edit_FirstField:GetText())) or Globals.player;
	draftData.LN = stEtN(strtrim(TRP3_RegisterCharact_Edit_LastField:GetText()));
	draftData.FT = stEtN(strtrim(TRP3_RegisterCharact_Edit_FullTitleField:GetText()));
	draftData.RA = stEtN(TRP3_RegisterCharact_Edit_RaceField:GetText());
	draftData.CL = stEtN(TRP3_RegisterCharact_Edit_ClassField:GetText());
	draftData.AG = stEtN(strtrim(TRP3_RegisterCharact_Edit_AgeField:GetText()));
	draftData.EC = stEtN(strtrim(TRP3_RegisterCharact_Edit_EyeField:GetText()));
	draftData.HE = stEtN(strtrim(TRP3_RegisterCharact_Edit_HeightField:GetText()));
	draftData.WE = stEtN(strtrim(TRP3_RegisterCharact_Edit_WeightField:GetText()));
	draftData.RE = stEtN(strtrim(TRP3_RegisterCharact_Edit_ResidenceField:GetText()));
	draftData.BP = stEtN(strtrim(TRP3_RegisterCharact_Edit_BirthplaceField:GetText()));

	if sanitizeCharacteristics(draftData) then
		-- Yell at the user about their mischieves
		showAlertPopup(loc("REG_CODE_INSERTION_WARNING"));
	end

	-- Save psycho values
	for index, psychoStructure in pairs(draftData.PS) do
		psychoStructure.VA = psychoEditCharFrame[index].VA;
		if not psychoStructure.ID then
			-- If not a preset
			psychoStructure.LT = stEtN(_G[psychoEditCharFrame[index]:GetName() .. "LeftField"]:GetText()) or loc("REG_PLAYER_LEFTTRAIT");
			psychoStructure.RT = stEtN(_G[psychoEditCharFrame[index]:GetName() .. "RightField"]:GetText()) or loc("REG_PLAYER_RIGHTTRAIT");
		else
			-- Don't save preset data !
			psychoStructure.LT = nil;
			psychoStructure.RT = nil;
			psychoStructure.LI = nil;
			psychoStructure.RI = nil;
		end
	end
	-- Save Misc
	for index, miscStructure in pairs(draftData.MI) do
		miscStructure.VA = stEtN(_G[miscEditCharFrame[index]:GetName() .. "ValueField"]:GetText()) or loc("CM_VALUE");
		miscStructure.NA = stEtN(_G[miscEditCharFrame[index]:GetName() .. "NameField"]:GetText()) or loc("CM_NAME");
	end

end

local function onPlayerIconSelected(icon)
	draftData.IC = icon;
	setupIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or Globals.icons.profile_default);
end

local function onEyeColorSelected(red, green, blue)
	if red and green and blue then
		local hexa = strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue))
		draftData.EH = hexa;
	else
		draftData.EH = nil;
	end
end

local function onClassColorSelected(red, green, blue)
	if red and green and blue then
		local hexa = strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue))
		draftData.CH = hexa;
	else
		draftData.CH = nil;
	end
end

local function onPsychoClick(frame, value, modif)
	if value + modif < 6 and value + modif > 0 then
		refreshPsycho(frame, value + modif);
	end
end

local function onLeftClick(button)
	onPsychoClick(button:GetParent(), button:GetParent().VA or 3, 1);
end

local function onRightClick(button)
	onPsychoClick(button:GetParent(), button:GetParent().VA or 3, -1);
end

local function refreshEditIcon(frame)
	setupIconButton(frame, frame.IC or Globals.icons.profile_default);
end

local function onMiscDelete(self)
	assert(self and self:GetParent(), "Badly initialiazed remove button, reference");
	local frame = self:GetParent();
	assert(frame.miscIndex and draftData.MI[frame.miscIndex], "Badly initialiazed remove button, index");
	saveInDraft();
	wipe(draftData.MI[frame.miscIndex]);
	tremove(draftData.MI, frame.miscIndex);
	setEditDisplay();
end

local function miscAdd(NA, VA, IC)
	saveInDraft();
	tinsert(draftData.MI, {
		NA = NA,
		VA = VA,
		IC = IC,
	});
	setEditDisplay();
end

local MISC_PRESET = {
	{
		NA = loc("REG_PLAYER_MSP_HOUSE"),
		VA = "",
		IC = "inv_misc_kingsring1"
	},
	{
		NA = loc("REG_PLAYER_MSP_NICK"),
		VA = "",
		IC = "Ability_Hunter_BeastCall"
	},
	{
		NA = loc("REG_PLAYER_MSP_MOTTO"),
		VA = "",
		IC = "INV_Inscription_ScrollOfWisdom_01"
	},
	{
		NA = loc("REG_PLAYER_TRP2_TRAITS"),
		VA = "",
		IC = "spell_shadow_mindsteal"
	},
	{
		NA = loc("REG_PLAYER_TRP2_PIERCING"),
		VA = "",
		IC = "inv_jewelry_ring_14"
	},
	{
		NA = loc("REG_PLAYER_TRP2_TATTOO"),
		VA = "",
		IC = "INV_Inscription_inkblack01"
	},
	{
		list = "|cff00ff00" .. loc("REG_PLAYER_ADD_NEW"),
		NA = loc("CM_NAME"),
		VA = loc("CM_VALUE"),
		IC = "TEMP"
	},
}

local function miscAddDropDownSelection(index)
	local preset = MISC_PRESET[index];
	miscAdd(preset.NA, preset.VA, preset.IC);
end

local function miscAddDropDown()
	local values = {};
	tinsert(values, { loc("REG_PLAYER_MISC_ADD") });
	for index, preset in pairs(MISC_PRESET) do
		tinsert(values, { preset.list or preset.NA, index });
	end
	displayDropDown(TRP3_RegisterCharact_Edit_MiscAdd, values, miscAddDropDownSelection, 0, true);
end

local function psychoAdd(presetID)
	saveInDraft();
	if presetID == "new" then
		tinsert(draftData.PS, {
			LT = loc("REG_PLAYER_LEFTTRAIT"),
			LI = "TEMP",
			RT = loc("REG_PLAYER_RIGHTTRAIT"),
			RI = "TEMP",
			VA = 3,
		});
	else
		tinsert(draftData.PS, { ID = presetID, VA = 3 });
	end
	setEditDisplay();
end

local function onPsychoDelete(self)
	assert(self and self:GetParent(), "Badly initialiazed remove button, reference");
	local frame = self:GetParent();
	assert(frame.psychoIndex and draftData.PS[frame.psychoIndex], "Badly initialiazed remove button, index");
	saveInDraft();
	wipe(draftData.PS[frame.psychoIndex]);
	tremove(draftData.PS, frame.psychoIndex);
	setEditDisplay();
end

local function refreshDraftHouseCoordinates()
	local houseTT = loc("REG_PLAYER_HERE_HOME_TT");
	if draftData.RC and #draftData.RC == 4 then
		houseTT = loc("REG_PLAYER_HERE_HOME_PRE_TT"):format(draftData.RC[4]) .. "\n\n" .. houseTT;
	end
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceButton, "RIGHT", 0, 5, loc("REG_PLAYER_HERE"), houseTT);
	TRP3_RegisterCharact_Edit_ResidenceButton:Hide();
	TRP3_RegisterCharact_Edit_ResidenceButton:Show(); -- Hax to refresh tooltip
end

function setEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/characteristics");
		assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end

	setupIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or Globals.icons.profile_default);
	TRP3_RegisterCharact_Edit_TitleField:SetText(draftData.TI or "");
	TRP3_RegisterCharact_Edit_FirstField:SetText(draftData.FN or Globals.player);
	TRP3_RegisterCharact_Edit_LastField:SetText(draftData.LN or "");
	TRP3_RegisterCharact_Edit_FullTitleField:SetText(draftData.FT or "");

	TRP3_RegisterCharact_Edit_RaceField:SetText(draftData.RA or "");
	TRP3_RegisterCharact_Edit_ClassField:SetText(draftData.CL or "");
	TRP3_RegisterCharact_Edit_AgeField:SetText(draftData.AG or "");
	TRP3_RegisterCharact_Edit_EyeField:SetText(draftData.EC or "");

	TRP3_RegisterCharact_Edit_EyeButton.setColor(hexaToNumber(draftData.EH))
	TRP3_RegisterCharact_Edit_ClassButton.setColor(hexaToNumber(draftData.CH));

	TRP3_RegisterCharact_Edit_HeightField:SetText(draftData.HE or "");
	TRP3_RegisterCharact_Edit_WeightField:SetText(draftData.WE or "");
	TRP3_RegisterCharact_Edit_ResidenceField:SetText(draftData.RE or "");
	TRP3_RegisterCharact_Edit_BirthplaceField:SetText(draftData.BP or "");

	refreshDraftHouseCoordinates();

	-- Misc
	local previous = TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle;
	for _, frame in pairs(miscEditCharFrame) do frame:Hide(); end
	for frameIndex, miscStructure in pairs(draftData.MI) do
		local frame = miscEditCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_MiscEditLine");
			_G[frame:GetName() .. "NameFieldText"]:SetText(loc("CM_NAME"));
			_G[frame:GetName() .. "ValueFieldText"]:SetText(loc("CM_VALUE"));
			_G[frame:GetName() .. "Delete"]:SetScript("OnClick", onMiscDelete);
			setTooltipForSameFrame(_G[frame:GetName() .. "Delete"], "TOP", 0, 5, loc("CM_REMOVE"));
			scaleField(frame, TRP3_RegisterCharact_Edit_CharactPanel_Container:GetWidth(), "NameField");
			tinsert(miscEditCharFrame, frame);
		end
		_G[frame:GetName() .. "Icon"]:SetScript("OnClick", function()
			showIconBrowser(function(icon)
				miscStructure.IC = icon;
				setupIconButton(_G[frame:GetName() .. "Icon"], icon or Globals.icons.default);
			end);
		end);

		frame.miscIndex = frameIndex;
		_G[frame:GetName() .. "Icon"].IC = miscStructure.IC or Globals.icons.default;
		_G[frame:GetName() .. "NameField"]:SetText(miscStructure.NA or loc("CM_NAME"));
		_G[frame:GetName() .. "ValueField"]:SetText(miscStructure.VA or loc("CM_VALUE"));
		refreshEditIcon(_G[frame:GetName() .. "Icon"]);
		frame:ClearAllPoints();
		frame:SetPoint("TOP", previous, "BOTTOM", 0, 0);
		frame:SetPoint("LEFT", 10, 0);
		frame:SetPoint("RIGHT", -10, 0);
		frame:Show();
		previous = frame;
	end
	TRP3_RegisterCharact_Edit_MiscAdd:ClearAllPoints();
	TRP3_RegisterCharact_Edit_MiscAdd:SetPoint("TOP", previous, "BOTTOM", 0, -5);
	previous = TRP3_RegisterCharact_Edit_MiscAdd;

	-- Psycho
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:ClearAllPoints();
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetPoint("TOP", previous, "BOTTOM", 0, -5);
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetPoint("LEFT", 10, 0);
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetPoint("RIGHT", -10, 0);
	previous = TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle;
	for _, frame in pairs(psychoEditCharFrame) do frame:Hide(); end
	for frameIndex, psychoStructure in pairs(draftData.PS) do
		local frame = psychoEditCharFrame[frameIndex];
		if frame == nil then
			-- Create psycho attribute widget if not already exists
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoEditLine");
			_G[frame:GetName() .. "LeftButton"]:SetScript("OnClick", onLeftClick);
			_G[frame:GetName() .. "RightButton"]:SetScript("OnClick", onRightClick);
			_G[frame:GetName() .. "Delete"]:SetScript("OnClick", onPsychoDelete);
			_G[frame:GetName() .. "LeftFieldText"]:SetText(loc("REG_PLAYER_LEFTTRAIT"));
			_G[frame:GetName() .. "RightFieldText"]:SetText(loc("REG_PLAYER_RIGHTTRAIT"));
			setTooltipForSameFrame(_G[frame:GetName() .. "LeftIcon"], "TOP", 0, 5, loc("UI_ICON_SELECT"), loc("REG_PLAYER_PSYCHO_LEFTICON_TT"));
			setTooltipForSameFrame(_G[frame:GetName() .. "RightIcon"], "TOP", 0, 5, loc("UI_ICON_SELECT"), loc("REG_PLAYER_PSYCHO_RIGHTICON_TT"));
			setTooltipForSameFrame(_G[frame:GetName() .. "Delete"], "TOP", 0, 5, loc("CM_REMOVE"));
			tinsert(psychoEditCharFrame, frame);
		end
		_G[frame:GetName() .. "LeftIcon"]:SetScript("OnClick", function(self)
			showIconBrowser(function(icon)
				psychoStructure.LI = icon;
				setupIconButton(self, icon or Globals.icons.default);
			end);
		end);
		_G[frame:GetName() .. "RightIcon"]:SetScript("OnClick", function(self)
			showIconBrowser(function(icon)
				psychoStructure.RI = icon;
				setupIconButton(self, icon or Globals.icons.default);
			end);
		end);

		if psychoStructure.ID then
			_G[frame:GetName() .. "JaugeLeftIcon"]:Show();
			_G[frame:GetName() .. "JaugeRightIcon"]:Show();
			_G[frame:GetName() .. "LeftText"]:Show();
			_G[frame:GetName() .. "RightText"]:Show();
			_G[frame:GetName() .. "LeftField"]:Hide();
			_G[frame:GetName() .. "RightField"]:Hide();
			_G[frame:GetName() .. "LeftIcon"]:Hide();
			_G[frame:GetName() .. "RightIcon"]:Hide();
			_G[frame:GetName() .. "JaugeLeftIcon"]:ClearAllPoints();
			_G[frame:GetName() .. "JaugeLeftIcon"]:SetPoint("RIGHT", _G[frame:GetName() .. "Jauge"], "LEFT", -22, 2);
			_G[frame:GetName() .. "JaugeRightIcon"]:ClearAllPoints();
			_G[frame:GetName() .. "JaugeRightIcon"]:SetPoint("LEFT", _G[frame:GetName() .. "Jauge"], "RIGHT", 22, 2);
			local preset = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			_G[frame:GetName() .. "LeftText"]:SetText(preset.LT or "");
			_G[frame:GetName() .. "RightText"]:SetText(preset.RT or "");
			_G[frame:GetName() .. "JaugeLeftIcon"]:SetTexture("Interface\\ICONS\\" .. (preset.LI or Globals.icons.default));
			_G[frame:GetName() .. "JaugeRightIcon"]:SetTexture("Interface\\ICONS\\" .. (preset.RI or Globals.icons.default));
			setTooltipForSameFrame(_G[frame:GetName() .. "LeftButton"], "TOP", 0, 5, loc("REG_PLAYER_PSYCHO_POINT"), loc("REG_PLAYER_PSYCHO_MORE"):format(preset.LT));
			setTooltipForSameFrame(_G[frame:GetName() .. "RightButton"], "TOP", 0, 5, loc("REG_PLAYER_PSYCHO_POINT"), loc("REG_PLAYER_PSYCHO_MORE"):format(preset.RT));
		else
			_G[frame:GetName() .. "JaugeLeftIcon"]:Hide();
			_G[frame:GetName() .. "JaugeRightIcon"]:Hide();
			_G[frame:GetName() .. "LeftText"]:Hide();
			_G[frame:GetName() .. "RightText"]:Hide();
			_G[frame:GetName() .. "LeftField"]:Show();
			_G[frame:GetName() .. "RightField"]:Show();
			_G[frame:GetName() .. "LeftIcon"]:Show();
			_G[frame:GetName() .. "RightIcon"]:Show();
			_G[frame:GetName() .. "LeftField"]:SetText(psychoStructure.LT or "");
			_G[frame:GetName() .. "RightField"]:SetText(psychoStructure.RT or "");
			_G[frame:GetName() .. "LeftIcon"].IC = psychoStructure.LI or Globals.icons.default;
			_G[frame:GetName() .. "RightIcon"].IC = psychoStructure.RI or Globals.icons.default;
			refreshEditIcon(_G[frame:GetName() .. "LeftIcon"]);
			refreshEditIcon(_G[frame:GetName() .. "RightIcon"]);
			setTooltipForSameFrame(_G[frame:GetName() .. "LeftButton"], "TOP", 0, 5, loc("REG_PLAYER_PSYCHO_POINT"), loc("REG_PLAYER_PSYCHO_MORE"):format(loc("REG_PLAYER_LEFTTRAIT")));
			setTooltipForSameFrame(_G[frame:GetName() .. "RightButton"], "TOP", 0, 5, loc("REG_PLAYER_PSYCHO_POINT"), loc("REG_PLAYER_PSYCHO_MORE"):format(loc("REG_PLAYER_RIGHTTRAIT")));
		end

		frame.psychoIndex = frameIndex;
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		refreshPsycho(frame, psychoStructure.VA or 3);
		frame:Show();
		previous = frame;
	end
	TRP3_RegisterCharact_Edit_PsychoAdd:ClearAllPoints();
	TRP3_RegisterCharact_Edit_PsychoAdd:SetPoint("TOP", previous, "BOTTOM", 0, -5);
	previous = TRP3_RegisterCharact_Edit_PsychoAdd;
end

local function setupRelationButton(profileID, profile)
	setupIconButton(TRP3_RegisterCharact_ActionButton, getRelationTexture(profileID));
	setTooltipAll(TRP3_RegisterCharact_ActionButton, "LEFT", 0, 0, loc("CM_ACTIONS"), loc("REG_RELATION_BUTTON_TT"):format(getRelationText(profileID), getRelationTooltipText(profileID, profile)));
end

local function saveCharacteristics()
	saveInDraft();

	local dataTab = get("player/characteristics");
	assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);

	compressData();
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getCurrentContext().profileID, "characteristics");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function refreshDisplay()
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");

	-- Hide all
	TRP3_RegisterCharact_NamePanel:Hide();
	TRP3_RegisterCharact_CharactPanel:Hide();
	TRP3_RegisterCharact_ActionButton:Hide();
	TRP3_RegisterCharact_CharactPanel_Empty:Hide();
	TRP3_RegisterCharact_Edit_NamePanel:Hide();
	TRP3_RegisterCharact_Edit_CharactPanel:Hide();
	for _, frame in pairs(registerCharFrame) do frame:Hide(); end
	for _, frame in pairs(psychoCharFrame) do frame:Hide(); end
	for _, frame in pairs(miscCharFrame) do frame:Hide(); end

	-- IsSelf ?
	TRP3_RegisterCharact_NamePanel_EditButton:Hide();
	if context.isPlayer then
		TRP3_RegisterCharact_NamePanel_EditButton:Show();
	else
		assert(context.profileID, "No profileID in context");
		TRP3_RegisterCharact_ActionButton:Show();
		setupRelationButton(context.profileID, context.profile);
	end

	if context.isEditMode then
		assert(context.isPlayer, "Trying to show Characteristics edition but is not mine ...");
		TRP3_RegisterCharact_Edit_NamePanel:Show();
		TRP3_RegisterCharact_Edit_CharactPanel:Show();
		setEditDisplay();
	else
		TRP3_RegisterCharact_NamePanel:Show();
		TRP3_RegisterCharact_CharactPanel:Show();
		setConsultDisplay(context);
	end
end

local toast = TRP3_API.ui.tooltip.toast;

local function onActionSelected(value, button)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");
	assert(context.profileID, "No profileID in context");

	if value == 1 then
		local profil = getProfile(context.profileID);
		showConfirmPopup(loc("REG_DELETE_WARNING"):format(Utils.str.color("g") .. getCompleteName(profil.characteristics or {}, UNKNOWN, true) .. "|r"),
			function()
				deleteProfile(context.profileID);
			end);
	elseif value == 2 then
		showTextInputPopup(loc("REG_PLAYER_IGNORE_WARNING"):format(strjoin("\n", unpack(getKeys(context.profile.link)))), function(text)
			for unitID, _ in pairs(context.profile.link) do
				ignoreID(unitID, text);
			end
			toast(loc("REG_IGNORE_TOAST"), 2);
		end);
	elseif type(value) == "string" then
		setRelation(context.profileID, value);
		setupRelationButton(context.profileID, context.profile);
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, nil, context.profileID, "characteristics");
	end
end

local function onActionClicked(button)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");

	local values = {};
	tinsert(values, { loc("PR_DELETE_PROFILE"), 1 });
	if context.profile.link and tsize(context.profile.link) > 0 then
		tinsert(values, { loc("REG_PLAYER_IGNORE"):format(tsize(context.profile.link)), 2 });
	end
	local relationRows = {}
	for id, relation in pairs(RELATIONS.relations) do
		tinsert(relationRows, {relation.humanReadable or loc("REG_RELATION_" .. id), id});
	end
	tinsert(values, {
		loc("REG_RELATION"),
		relationRows
	});
	displayDropDown(button, values, onActionSelected, 0, true);
end



local function showCharacteristicsTab()
	TRP3_RegisterCharact:Show();
	getCurrentContext().isEditMode = false;
	refreshDisplay();
end

TRP3_API.register.ui.showCharacteristicsTab = showCharacteristicsTab;

local function onEdit()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	getCurrentContext().isEditMode = true;
	refreshDisplay();
end

local function onSave()
	saveCharacteristics();
	showCharacteristicsTab();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function initStructures()
	PSYCHO_PRESETS_UNKOWN = {
		LT = loc("CM_UNKNOWN"),
		RT = loc("CM_UNKNOWN"),
		LI = "INV_Misc_QuestionMark",
		RI = "INV_Misc_QuestionMark"
	};

	PSYCHO_PRESETS = {
		{
			LT = loc("REG_PLAYER_PSYCHO_CHAOTIC"),
			RT = loc("REG_PLAYER_PSYCHO_Loyal"),
			LI = "Ability_Rogue_WrongfullyAccused",
			RI = "Ability_Paladin_SanctifiedWrath",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Chaste"),
			RT = loc("REG_PLAYER_PSYCHO_Luxurieux"),
			LI = "INV_Belt_27",
			RI = "Spell_Shadow_SummonSuccubus",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Indulgent"),
			RT = loc("REG_PLAYER_PSYCHO_Rencunier"),
			LI = "INV_RoseBouquet01",
			RI = "Ability_Hunter_SniperShot",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Genereux"),
			RT = loc("REG_PLAYER_PSYCHO_Egoiste"),
			LI = "INV_Misc_Gift_02",
			RI = "INV_Misc_Coin_02",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Sincere"),
			RT = loc("REG_PLAYER_PSYCHO_Trompeur"),
			LI = "INV_Misc_Toy_07",
			RI = "Ability_Rogue_Disguise",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Misericordieux"),
			RT = loc("REG_PLAYER_PSYCHO_Cruel"),
			LI = "INV_ValentinesCandySack",
			RI = "Ability_Warrior_Trauma",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Pieux"),
			RT = loc("REG_PLAYER_PSYCHO_Rationnel"),
			LI = "Spell_Holy_HolyGuidance",
			RI = "INV_Gizmo_02",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Pragmatique"),
			RT = loc("REG_PLAYER_PSYCHO_Conciliant"),
			LI = "Ability_Rogue_HonorAmongstThieves",
			RI = "INV_Misc_GroupNeedMore",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Reflechi"),
			RT = loc("REG_PLAYER_PSYCHO_Impulsif"),
			LI = "Spell_Shadow_Brainwash",
			RI = "Achievement_BG_CaptureFlag_EOS",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Acete"),
			RT = loc("REG_PLAYER_PSYCHO_Bonvivant"),
			LI = "INV_Misc_Food_PineNut",
			RI = "INV_Misc_Food_99",
		},
		{
			LT = loc("REG_PLAYER_PSYCHO_Valeureux"),
			RT = loc("REG_PLAYER_PSYCHO_Couard"),
			LI = "Ability_Paladin_BeaconofLight",
			RI = "Ability_Druid_Cower",
		},
	};

	PSYCHO_PRESETS_DROPDOWN = {
		{ loc("REG_PLAYER_PSYCHO_SOCIAL") },
		{ loc("REG_PLAYER_PSYCHO_CHAOTIC") .. " - " .. loc("REG_PLAYER_PSYCHO_Loyal"), 1 },
		{ loc("REG_PLAYER_PSYCHO_Chaste") .. " - " .. loc("REG_PLAYER_PSYCHO_Luxurieux"), 2 },
		{ loc("REG_PLAYER_PSYCHO_Indulgent") .. " - " .. loc("REG_PLAYER_PSYCHO_Rencunier"), 3 },
		{ loc("REG_PLAYER_PSYCHO_Genereux") .. " - " .. loc("REG_PLAYER_PSYCHO_Egoiste"), 4 },
		{ loc("REG_PLAYER_PSYCHO_Sincere") .. " - " .. loc("REG_PLAYER_PSYCHO_Trompeur"), 5 },
		{ loc("REG_PLAYER_PSYCHO_Misericordieux") .. " - " .. loc("REG_PLAYER_PSYCHO_Cruel"), 6 },
		{ loc("REG_PLAYER_PSYCHO_Pieux") .. " - " .. loc("REG_PLAYER_PSYCHO_Rationnel"), 7 },
		{ loc("REG_PLAYER_PSYCHO_PERSONAL") },
		{ loc("REG_PLAYER_PSYCHO_Pragmatique") .. " - " .. loc("REG_PLAYER_PSYCHO_Conciliant"), 8 },
		{ loc("REG_PLAYER_PSYCHO_Reflechi") .. " - " .. loc("REG_PLAYER_PSYCHO_Impulsif"), 9 },
		{ loc("REG_PLAYER_PSYCHO_Acete") .. " - " .. loc("REG_PLAYER_PSYCHO_Bonvivant"), 10 },
		{ loc("REG_PLAYER_PSYCHO_Valeureux") .. " - " .. loc("REG_PLAYER_PSYCHO_Couard"), 11 },
		{ loc("REG_PLAYER_PSYCHO_CUSTOM") },
		{ loc("REG_PLAYER_PSYCHO_CREATENEW"), "new" },
	};
end

function TRP3_API.register.inits.characteristicsInit()
	initStructures();

	-- UI
	TRP3_RegisterCharact_Edit_MiscAdd:SetScript("OnClick", miscAddDropDown);
	TRP3_RegisterCharact_Edit_NamePanel_Icon:SetScript("OnClick", function() showIconBrowser(onPlayerIconSelected) end);
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetScript("OnClick", showCharacteristicsTab);
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetScript("OnClick", onSave);
	TRP3_RegisterCharact_NamePanel_EditButton:SetScript("OnClick", onEdit);
	TRP3_RegisterCharact_ActionButton:SetScript("OnClick", onActionClicked);
	TRP3_RegisterCharact_Edit_ResidenceButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	TRP3_RegisterCharact_Edit_ResidenceButton:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			draftData.RC = {TRP3_API.map.getCurrentCoordinates()};
			tinsert(draftData.RC, Utils.str.buildZoneText());
			TRP3_RegisterCharact_Edit_ResidenceField:SetText(buildZoneText());
		else
			draftData.RC = nil;
			TRP3_RegisterCharact_Edit_ResidenceField:SetText("");
		end
		refreshDraftHouseCoordinates();
	end);
	TRP3_RegisterCharact_Edit_BirthplaceButton:SetScript("OnClick", function()
		TRP3_RegisterCharact_Edit_BirthplaceField:SetText(buildZoneText());
	end);
	TRP3_RegisterCharact_Edit_ClassButton.onSelection = onClassColorSelected;
	TRP3_RegisterCharact_Edit_EyeButton.onSelection = onEyeColorSelected;

	setupDropDownMenu(TRP3_RegisterCharact_Edit_PsychoAdd, PSYCHO_PRESETS_DROPDOWN, psychoAdd, 0, true, false);

	-- Localz
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_NamePanel_Icon, "RIGHT", 0, 5, loc("REG_PLAYER_ICON"), loc("REG_PLAYER_ICON_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_TitleFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_TITLE"), loc("REG_PLAYER_TITLE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_FirstFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_FIRSTNAME"), loc("REG_PLAYER_FIRSTNAME_TT"):format(Globals.player));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_LastFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_LASTNAME"), loc("REG_PLAYER_LASTNAME_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_FullTitleFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_FULLTITLE"), loc("REG_PLAYER_FULLTITLE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_RaceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_RACE"), loc("REG_PLAYER_RACE_TT"):format(Globals.player_race_loc));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_CLASS"), loc("REG_PLAYER_CLASS_TT"):format(Globals.player_class_loc));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_AgeFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_AGE"), loc("REG_PLAYER_AGE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_BIRTHPLACE"), loc("REG_PLAYER_BIRTHPLACE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_RESIDENCE"), loc("REG_PLAYER_RESIDENCE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_EYE"), loc("REG_PLAYER_EYE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_HeightFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_HEIGHT"), loc("REG_PLAYER_HEIGHT_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_WeightFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_WEIGHT"), loc("REG_PLAYER_WEIGHT_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceButton, "RIGHT", 0, 5, loc("REG_PLAYER_HERE"), loc("REG_PLAYER_HERE_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeButton, "RIGHT", 0, 5, loc("REG_PLAYER_EYE"), loc("REG_PLAYER_COLOR_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassButton, "RIGHT", 0, 5, loc("REG_PLAYER_COLOR_CLASS"), loc("REG_PLAYER_COLOR_CLASS_TT") .. loc("REG_PLAYER_COLOR_TT"));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeButton, "RIGHT", 0, 5, loc("REG_PLAYER_EYE"), loc("REG_PLAYER_COLOR_TT"));

	setupFieldSet(TRP3_RegisterCharact_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	setupFieldSet(TRP3_RegisterCharact_Edit_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	setupFieldSet(TRP3_RegisterCharact_CharactPanel, loc("REG_PLAYER_CHARACTERISTICS"), 150);
	setupFieldSet(TRP3_RegisterCharact_Edit_CharactPanel, loc("REG_PLAYER_CHARACTERISTICS"), 150);

	setupEditBoxesNavigation({
		TRP3_RegisterCharact_Edit_RaceField,
		TRP3_RegisterCharact_Edit_ClassField,
		TRP3_RegisterCharact_Edit_AgeField,
		TRP3_RegisterCharact_Edit_ResidenceField,
		TRP3_RegisterCharact_Edit_EyeField,
		TRP3_RegisterCharact_Edit_BirthplaceField,
		TRP3_RegisterCharact_Edit_HeightField,
		TRP3_RegisterCharact_Edit_WeightField
	})

	setupEditBoxesNavigation({
		TRP3_RegisterCharact_Edit_TitleField,
		TRP3_RegisterCharact_Edit_FirstField,
		TRP3_RegisterCharact_Edit_LastField,
		TRP3_RegisterCharact_Edit_FullTitleField
	});

	TRP3_RegisterCharact_CharactPanel_Empty:SetText(loc("REG_PLAYER_NO_CHAR"));
	TRP3_RegisterCharact_Edit_MiscAdd:SetText(loc("REG_PLAYER_MISC_ADD"));
	TRP3_RegisterCharact_Edit_PsychoAdd:SetText(loc("REG_PLAYER_PSYCHO_ADD"));
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetText(loc("CM_SAVE"));
	TRP3_RegisterCharact_NamePanel_EditButton:SetText(loc("CM_EDIT"));
	TRP3_RegisterCharact_Edit_TitleFieldText:SetText(loc("REG_PLAYER_TITLE"));
	TRP3_RegisterCharact_Edit_FirstFieldText:SetText(loc("REG_PLAYER_FIRSTNAME"));
	TRP3_RegisterCharact_Edit_LastFieldText:SetText(loc("REG_PLAYER_LASTNAME"));
	TRP3_RegisterCharact_Edit_FullTitleFieldText:SetText(loc("REG_PLAYER_FULLTITLE"));
	TRP3_RegisterCharact_CharactPanel_RegisterTitle:SetText(Utils.str.icon("INV_Misc_Book_09", 25) .. " " .. loc("REG_PLAYER_REGISTER"));
	TRP3_RegisterCharact_CharactPanel_Edit_RegisterTitle:SetText(Utils.str.icon("INV_Misc_Book_09", 25) .. " " .. loc("REG_PLAYER_REGISTER"));
	TRP3_RegisterCharact_CharactPanel_PsychoTitle:SetText(Utils.str.icon("Spell_Arcane_MindMastery", 25) .. " " .. loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetText(Utils.str.icon("Spell_Arcane_MindMastery", 25) .. " " .. loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterCharact_CharactPanel_MiscTitle:SetText(Utils.str.icon("INV_MISC_NOTE_06", 25) .. " " .. loc("REG_PLAYER_MORE_INFO"));
	TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle:SetText(Utils.str.icon("INV_MISC_NOTE_06", 25) .. " " .. loc("REG_PLAYER_MORE_INFO"));
	TRP3_RegisterCharact_Edit_RaceFieldText:SetText(loc("REG_PLAYER_RACE"));
	TRP3_RegisterCharact_Edit_ClassFieldText:SetText(loc("REG_PLAYER_CLASS"));
	TRP3_RegisterCharact_Edit_AgeFieldText:SetText(loc("REG_PLAYER_AGE"));
	TRP3_RegisterCharact_Edit_EyeFieldText:SetText(loc("REG_PLAYER_EYE"));
	TRP3_RegisterCharact_Edit_HeightFieldText:SetText(loc("REG_PLAYER_HEIGHT"));
	TRP3_RegisterCharact_Edit_WeightFieldText:SetText(loc("REG_PLAYER_WEIGHT"));
	TRP3_RegisterCharact_Edit_ResidenceFieldText:SetText(loc("REG_PLAYER_RESIDENCE"));
	TRP3_RegisterCharact_Edit_BirthplaceFieldText:SetText(loc("REG_PLAYER_BIRTHPLACE"));

	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, compressData); -- On profile change, compress the new data
	compressData();

	-- Resizing
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		local finalContainerWidth = containerwidth - 70;
		TRP3_RegisterCharact_CharactPanel_Container:SetSize(finalContainerWidth, 50);
		TRP3_RegisterCharact_Edit_CharactPanel_Container:SetSize(finalContainerWidth, 50);
		for _, frame in pairs(registerCharFrame) do
			scaleField(frame, finalContainerWidth);
		end
		for _, frame in pairs(miscCharFrame) do
			scaleField(frame, finalContainerWidth);
		end
		for _, frame in pairs(miscEditCharFrame) do
			scaleField(frame, finalContainerWidth, "NameField");
		end
		TRP3_RegisterCharact_Edit_FirstField:SetSize((finalContainerWidth - 100) * 0.3, 18);
	end);
end