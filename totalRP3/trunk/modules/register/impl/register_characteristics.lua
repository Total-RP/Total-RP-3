--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local stNtE = TRP3_StringNilToEmpty;
local log = TRP3_Log;
local color = TRP3_Color;
local get = TRP3_Profile_DataGetter;
local tcopy = TRP3_DupplicateTab;
local loc = TRP3_L;

local PSYCHO_PRESETS_UNKOWN;
local PSYCHO_PRESETS;
local PSYCHO_PRESETS_DROPDOWN;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--TRP3_GetDefaultProfile().player.characteristics = {
--	v = 1,
--	RA = TRP3_RACE_LOC,
--	CL = TRP3_CLASS_LOC,
--	MI = {},
--	PS = {}
--};

-- Mock
TRP3_GetDefaultProfile().player.characteristics = {
	v = 1,
	FN = "Telkos le fou",
	LN = "Arkale",
	TI = "Sir",
	FT = UnitPVPName("player"),
	IC = "ABILITY_SEAL",
	RA = "Drrrrrragon",
	CL = "Ingénieur",
	RE = "Hurlevent",
	BP = "Berceau de l'hiver",
	AG = "47 balais",
	EC = "Emerald green",
	HE = "182 cm",
	WE = "92 kg",
	MI = {
		{
			NA = "Strength",
			VA = "Very strong !",
			IC = "Ability_Warrior_StrengthOfArms",
		},
		{
			NA = "Intelligence",
			VA = "Very smart either !",
			IC = "Spell_Holy_ArcaneIntellect",
		},
		{
			NA = "Mon custom avec un nom foutrement trop long juste pour faire chier",
			VA = "Very smart either ! Very smart either ! Very smart either ! Very smart either ! Very smart either !",
			IC = "Spell_Holy_ArcaneIntellect",
		},
	},
	PS = {
		{
			LT = "Chaotic",
			LI = "INV_Inscription_TarotChaos",
			RT = "Loyal",
			RI = "Spell_Shaman_AncestralAwakening",
			VA = 2,
		},
		{
			LT = "A very very long left term",
			LI = "INV_Inscription_TarotChaos",
			RT = "A very very long right term",
			RI = "Spell_Shaman_AncestralAwakening",
			VA = 5,
		},
		{
			ID = 1,
			VA = 4
		},
		{
			ID = 10,
			VA = 1
		}
	},
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentCompressed;

local function compressData()
	local dataTab = get("player/characteristics");
	local serial = TRP3_Serialize(dataTab);
	local compressed = TRP3_EncodeCompressMessage(serial);
	if compressed:len() < serial:len() then
		currentCompressed = compressed;
--		log(("Compressed data is better: %s / %s (%i%%)"):format(compressed:len(), serial:len(), compressed:len() / serial:len() * 100));
	else
		currentCompressed = nil;
	end
end

function TRP3_RegisterCharacteristicsGetExchangeData()
	if currentCompressed ~= nil then
		return currentCompressed;
	else
		return get("player/characteristics");
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - CONSULT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local isEditMode;
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

function TRP3_GetCompleteName(characteristicsTab, name, hideTitle)
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

local function refreshPsycho(psychoLine, value)
	local dotIndex;
	for dotIndex=1, 6 do
		_G[psychoLine:GetName().."JaugeDot"..dotIndex]:Show();
		if dotIndex <= value then
			_G[psychoLine:GetName().."JaugeDot"..dotIndex]:SetTexCoord(0.375, 0.5, 0, 0.125);
		else
			_G[psychoLine:GetName().."JaugeDot"..dotIndex]:SetTexCoord(0, 0.125, 0, 0.125);
		end
	end
	psychoLine.VA = value;
end

local function setBkg(backgroundIndex)
	local backdrop = TRP3_RegisterCharact_CharactPanel:GetBackdrop();
	backdrop.bgFile = TRP3_getTiledBackground(backgroundIndex);
	TRP3_RegisterCharact_CharactPanel:SetBackdrop(backdrop);
end

local function setConsultDisplay()
	local dataTab = get("player/characteristics");
	assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
	
	-- Icon, complete name and titles
	local completeName = TRP3_GetCompleteName(dataTab, TRP3_PLAYER);
	TRP3_RegisterCharact_NamePanel_Name:SetText(completeName);
	TRP3_RegisterCharact_NamePanel_Title:SetText(dataTab.FT or "");
	TRP3_InitIconButton(TRP3_RegisterCharact_NamePanel_Icon, dataTab.IC or TRP3_ICON_PROFILE_DEFAULT);
	
	setBkg(dataTab.bkg or 1);
	
	-- hide all
	for _, regCharFrame in pairs(registerCharFrame) do
		regCharFrame:Hide();
	end
	TRP3_RegisterCharact_CharactPanel_PsychoTitle:Hide();
	TRP3_RegisterCharact_CharactPanel_MiscTitle:Hide();
	
	-- Previous var helps for layout building
	local previous = TRP3_RegisterCharact_CharactPanel_RegisterTitle;

	-- Which directory chars must be shown ?
	local shownCharacteristics = {"RA", "CL"}; -- Race and class are mandatory values
	local shownValues = {
		RA = stEtN(dataTab.RA) or TRP3_RACE_LOC,
		CL = stEtN(dataTab.CL) or TRP3_CLASS_LOC,
	};
	for _,attribute in pairs({"AG", "EC", "HE", "WE", "BP", "RE"}) do -- Optional values
		if stEtN(dataTab[attribute]) then
			tinsert(shownCharacteristics, attribute);
			shownValues[attribute] = dataTab[attribute];
		end
	end
	
	-- Show directory chars values
	for frameIndex, charName in pairs(shownCharacteristics) do
		local frame = registerCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_RegisterInfoLine"..frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoLine");
			tinsert(registerCharFrame, frame);
		end
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 10);
		frame:SetPoint("RIGHT", 0, 0);
		_G[frame:GetName().."FieldValue"]:SetText(shownValues[charName]);
		_G[frame:GetName().."FieldName"]:SetText(loc(registerCharLocals[charName]));
		frame:Show();
		previous = frame;
	end
	
	-- Psycho chars
	assert(type(dataTab.PS) == "table", "Error: Nil psycho data or not a table.");
	if #dataTab.PS > 0 then
		assert(type(dataTab.PS) == "table", "Error: Nil psycho data or not a table.");
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:Show();
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_PsychoTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		previous = TRP3_RegisterCharact_CharactPanel_PsychoTitle;
		
		for frameIndex, psychoStructure in pairs(dataTab.PS) do
			local frame = psychoCharFrame[frameIndex];
			local value = psychoStructure.VA;
			if frame == nil then
				frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoInfoLine"..frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoDisplayLine");
				tinsert(psychoCharFrame, frame);
			end

			-- Preset pointer
			if psychoStructure.ID then
				psychoStructure = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			end
			
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
			frame:SetPoint("RIGHT", 0, 0);
			_G[frame:GetName().."LeftText"]:SetText(psychoStructure.LT or "");
			_G[frame:GetName().."RightText"]:SetText(psychoStructure.RT or "");
			_G[frame:GetName().."JaugeLeftIcon"]:SetTexture("Interface\\ICONS\\"..(psychoStructure.LI or TRP3_ICON_DEFAULT));
			_G[frame:GetName().."JaugeRightIcon"]:SetTexture("Interface\\ICONS\\"..(psychoStructure.RI or TRP3_ICON_DEFAULT));
			refreshPsycho(frame, value or 3);
			frame:Show();
			previous = frame;
		end
	end
	
	-- Misc chars
	assert(type(dataTab.MI) == "table", "Error: Nil misc data or not a table.");
	if #dataTab.MI > 0 then
		TRP3_RegisterCharact_CharactPanel_MiscTitle:Show();
		TRP3_RegisterCharact_CharactPanel_MiscTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_MiscTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		previous = TRP3_RegisterCharact_CharactPanel_MiscTitle;
		
		for frameIndex, miscStructure in pairs(dataTab.MI) do
			local frame = miscCharFrame[frameIndex];
			if frame == nil then
				frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscInfoLine"..frameIndex, TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoLine");
				tinsert(miscCharFrame, frame);
			end
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 7);
			frame:SetPoint("RIGHT", 0, 0);
			_G[frame:GetName().."FieldName"]:SetText(strconcat(TRP3_Icon(miscStructure.IC, 18)," ", miscStructure.NA or ""));
			_G[frame:GetName().."FieldValue"]:SetText(miscStructure.VA or "");
			frame:Show();
			previous = frame;
		end
	end
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - EDIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- function def
local setEditDisplay;

local draftData = nil;
local psychoEditCharFrame = {};
local miscEditCharFrame = {};


local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.TI = stEtN(strtrim(TRP3_RegisterCharact_Edit_TitleField:GetText()));
	draftData.FN = stEtN(strtrim(TRP3_RegisterCharact_Edit_FirstField:GetText()));
	draftData.LN = stEtN(strtrim(TRP3_RegisterCharact_Edit_LastField:GetText()));
	draftData.FT = stEtN(strtrim(TRP3_RegisterCharact_Edit_FullTitleField:GetText()));
	draftData.RA = stEtN(strtrim(TRP3_RegisterCharact_Edit_RaceField:GetText()));
	draftData.CL = stEtN(strtrim(TRP3_RegisterCharact_Edit_ClassField:GetText()));
	draftData.AG = stEtN(strtrim(TRP3_RegisterCharact_Edit_AgeField:GetText()));
	draftData.EC = stEtN(strtrim(TRP3_RegisterCharact_Edit_EyeField:GetText()));
	draftData.HE = stEtN(strtrim(TRP3_RegisterCharact_Edit_HeightField:GetText()));
	draftData.WE = stEtN(strtrim(TRP3_RegisterCharact_Edit_WeightField:GetText()));
	draftData.RE = stEtN(strtrim(TRP3_RegisterCharact_Edit_ResidenceField:GetText()));
	draftData.BP = stEtN(strtrim(TRP3_RegisterCharact_Edit_BirthplaceField:GetText()));
	-- Save psycho values
	for index, psychoStructure in pairs(draftData.PS) do
		psychoStructure.VA = psychoEditCharFrame[index].VA;
		if not psychoStructure.ID then
			-- If not a preset
			psychoStructure.LT = stEtN(_G[psychoEditCharFrame[index]:GetName().."LeftField"]:GetText()) or loc("REG_PLAYER_LEFTTRAIT");
			psychoStructure.RT = stEtN(_G[psychoEditCharFrame[index]:GetName().."RightField"]:GetText()) or loc("REG_PLAYER_RIGHTTRAIT");
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
		miscStructure.VA = stEtN(_G[miscEditCharFrame[index]:GetName().."ValueField"]:GetText()) or loc("CM_VALUE");
		miscStructure.NA = stEtN(_G[miscEditCharFrame[index]:GetName().."NameField"]:GetText()) or loc("CM_NAME");
	end
end

local function onPlayerIconSelected(icon)
	draftData.IC = icon;
	TRP3_InitIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or TRP3_ICON_PROFILE_DEFAULT);
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
	TRP3_InitIconButton(frame, frame.IC or TRP3_ICON_PROFILE_DEFAULT);
end

local function onMiscDelete(self)
	assert(self and self:GetParent(), "Badly initialiazed remove button, reference");
	local frame = self:GetParent();
	assert(frame.miscIndex and draftData.misc[frame.miIndex], "Badly initialiazed remove button, index");
	saveInDraft();
	wipe(draftData.MI[frame.miscIndex]);
	tremove(draftData.MI, frame.miscIndex);
	setEditDisplay();
end

local function miscAdd()
	saveInDraft();
	tinsert(draftData.MI, {
		NA = loc("CM_NAME"),
		VA = loc("CM_VALUE"),
		IC = "TEMP",
	});
	setEditDisplay();
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
		tinsert(draftData.PS, {ID = presetID, VA = 3});
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

setEditDisplay = function()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/characteristics");
		assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end
	
	TRP3_InitIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or TRP3_ICON_PROFILE_DEFAULT);
	TRP3_RegisterCharact_Edit_TitleField:SetText(draftData.TI or "");
	TRP3_RegisterCharact_Edit_FirstField:SetText(draftData.FN or TRP3_PLAYER);
	TRP3_RegisterCharact_Edit_LastField:SetText(draftData.LN or "");
	TRP3_RegisterCharact_Edit_FullTitleField:SetText(draftData.FT or "");
	
	TRP3_RegisterCharact_Edit_RaceField:SetText(draftData.RA or TRP3_RACE_LOC);
	TRP3_RegisterCharact_Edit_ClassField:SetText(draftData.CL or TRP3_CLASS_LOC);
	TRP3_RegisterCharact_Edit_AgeField:SetText(draftData.AG or "");
	TRP3_RegisterCharact_Edit_EyeField:SetText(draftData.EC or "");
	TRP3_RegisterCharact_Edit_HeightField:SetText(draftData.HE or "");
	TRP3_RegisterCharact_Edit_WeightField:SetText(draftData.WE or "");
	TRP3_RegisterCharact_Edit_ResidenceField:SetText(draftData.RE or "");
	TRP3_RegisterCharact_Edit_BirthplaceField:SetText(draftData.BP or "");
	
	-- Psycho
	local previous = TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle;
	for _, frame in pairs(psychoEditCharFrame) do frame:Hide(); end
	for frameIndex, psychoStructure in pairs(draftData.PS) do
		local frame = psychoEditCharFrame[frameIndex];
		if frame == nil then
			-- Create psycho attribute widget if not already exists
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoEditLine"..frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoEditLine");
			_G[frame:GetName().."LeftButton"]:SetScript("OnClick", onLeftClick);
			_G[frame:GetName().."RightButton"]:SetScript("OnClick", onRightClick);
			_G[frame:GetName().."Delete"]:SetScript("OnClick", onPsychoDelete);
			_G[frame:GetName().."LeftFieldText"]:SetText(loc("REG_PLAYER_LEFTTRAIT"));
			_G[frame:GetName().."RightFieldText"]:SetText(loc("REG_PLAYER_RIGHTTRAIT"));
			TRP3_SetTooltipForSameFrame(_G[frame:GetName().."LeftIcon"], "TOP", 0, 5, loc("UI_ICON_SELECT"), loc("REG_PLAYER_PSYCHO_LEFTICON_TT"));
			TRP3_SetTooltipForSameFrame(_G[frame:GetName().."RightIcon"], "TOP", 0, 5, loc("UI_ICON_SELECT"), loc("REG_PLAYER_PSYCHO_RIGHTICON_TT"));
			TRP3_SetTooltipForSameFrame(_G[frame:GetName().."Delete"], "TOP", 0, 5, loc("CM_REMOVE"));
			tinsert(psychoEditCharFrame, frame);
		end
		_G[frame:GetName().."LeftIcon"]:SetScript("OnClick", function(self) 
			TRP3_OpenIconBrowser(function(icon)
				psychoStructure.LI = icon;
				TRP3_InitIconButton(self, icon or TRP3_ICON_DEFAULT);
			end);
		end);
		_G[frame:GetName().."RightIcon"]:SetScript("OnClick", function(self) 
			TRP3_OpenIconBrowser(function(icon)
				psychoStructure.RI = icon;
				TRP3_InitIconButton(self, icon or TRP3_ICON_DEFAULT);
			end);
		end);
		
		if psychoStructure.ID then
			_G[frame:GetName().."JaugeLeftIcon"]:Show();
			_G[frame:GetName().."JaugeRightIcon"]:Show();
			_G[frame:GetName().."LeftText"]:Show();
			_G[frame:GetName().."RightText"]:Show();
			_G[frame:GetName().."LeftField"]:Hide();
			_G[frame:GetName().."RightField"]:Hide();
			_G[frame:GetName().."LeftIcon"]:Hide();
			_G[frame:GetName().."RightIcon"]:Hide();
			_G[frame:GetName().."JaugeLeftIcon"]:ClearAllPoints();
			_G[frame:GetName().."JaugeLeftIcon"]:SetPoint("RIGHT", _G[frame:GetName().."Jauge"], "LEFT", -22, 2);
			_G[frame:GetName().."JaugeRightIcon"]:ClearAllPoints();
			_G[frame:GetName().."JaugeRightIcon"]:SetPoint("LEFT", _G[frame:GetName().."Jauge"], "RIGHT", 22, 2);
			
			local preset = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			_G[frame:GetName().."LeftText"]:SetText(preset.LT or "");
			_G[frame:GetName().."RightText"]:SetText(preset.RT or "");
			_G[frame:GetName().."JaugeLeftIcon"]:SetTexture("Interface\\ICONS\\"..(preset.LI or TRP3_ICON_DEFAULT));
			_G[frame:GetName().."JaugeRightIcon"]:SetTexture("Interface\\ICONS\\"..(preset.RI or TRP3_ICON_DEFAULT));
		else
			_G[frame:GetName().."JaugeLeftIcon"]:Hide();
			_G[frame:GetName().."JaugeRightIcon"]:Hide();
			_G[frame:GetName().."LeftText"]:Hide();
			_G[frame:GetName().."RightText"]:Hide();
			_G[frame:GetName().."LeftField"]:Show();
			_G[frame:GetName().."RightField"]:Show();
			_G[frame:GetName().."LeftIcon"]:Show();
			_G[frame:GetName().."RightIcon"]:Show();
			
			_G[frame:GetName().."LeftField"]:SetText(psychoStructure.LT or "");
			_G[frame:GetName().."RightField"]:SetText(psychoStructure.RT or "");
			_G[frame:GetName().."LeftIcon"].IC = psychoStructure.LI or TRP3_ICON_DEFAULT;
			_G[frame:GetName().."RightIcon"].IC = psychoStructure.RI or TRP3_ICON_DEFAULT;
			refreshEditIcon(_G[frame:GetName().."LeftIcon"]);
			refreshEditIcon(_G[frame:GetName().."RightIcon"]);
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
	
	-- Misc
	TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle:ClearAllPoints();
	TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle:SetPoint("TOP", previous, "BOTTOM", 0, -5);
	previous = TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle;
	for _, frame in pairs(miscEditCharFrame) do frame:Hide(); end
	for frameIndex, miscStructure in pairs(draftData.MI) do
		local frame = miscEditCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscEditLine"..frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_MiscEditLine");
			_G[frame:GetName().."NameFieldText"]:SetText(loc("CM_NAME"));
			_G[frame:GetName().."ValueFieldText"]:SetText(loc("CM_VALUE"));
			_G[frame:GetName().."Delete"]:SetScript("OnClick", onMiscDelete);
			tinsert(miscEditCharFrame, frame);
		end
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function() 
			TRP3_OpenIconBrowser(function(icon)
				miscStructure.IC = icon;
				TRP3_InitIconButton(_G[frame:GetName().."Icon"], icon or TRP3_ICON_DEFAULT);
			end);
		end);
		
		frame.miscIndex = frameIndex;
		_G[frame:GetName().."Icon"].IC = miscStructure.IC or TRP3_ICON_DEFAULT;
		_G[frame:GetName().."NameField"]:SetText(miscStructure.NA or loc("CM_NAME"));
		_G[frame:GetName().."ValueField"]:SetText(miscStructure.VA or loc("CM_VALUE"));
		refreshEditIcon(_G[frame:GetName().."Icon"]);
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		frame:Show();
		previous = frame;
	end
	TRP3_RegisterCharact_Edit_MiscAdd:ClearAllPoints();
	TRP3_RegisterCharact_Edit_MiscAdd:SetPoint("TOP", previous, "BOTTOM", 0, -5);
end

local function saveCharacteristics()
	saveInDraft();
	
	--TODO: check size and warn if too long
	local characteristicsSize = TRP3_EstimateStructureLoad(draftData);
	
	local dataTab = get("player/characteristics");
	assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = TRP3_IncrementVersion(dataTab.v, 2);
	
	compressData();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function refreshDisplay()
	-- Hide all
	TRP3_RegisterCharact_NamePanel:Hide();
	TRP3_RegisterCharact_CharactPanel:Hide();
	TRP3_RegisterCharact_Edit_NamePanel:Hide();
	TRP3_RegisterCharact_Edit_CharactPanel:Hide();
	for _, frame in pairs(registerCharFrame) do frame:Hide(); end
	for _, frame in pairs(psychoCharFrame) do frame:Hide(); end
	for _, frame in pairs(miscCharFrame) do frame:Hide(); end
	
	if isEditMode then
		TRP3_RegisterCharact_Edit_NamePanel:Show();
		TRP3_RegisterCharact_Edit_CharactPanel:Show();
		setEditDisplay();
	else
		TRP3_RegisterCharact_NamePanel:Show();
		TRP3_RegisterCharact_CharactPanel:Show();
		setConsultDisplay();
	end
end

function TRP3_onCharacteristicsShown()
	TRP3_RegisterCharact:Show();
	isEditMode = false;
	refreshDisplay();
end

function TRP3_UI_CharacteristicsEditButton()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	isEditMode = true;
	refreshDisplay();
end

function TRP3_UI_CharacteristicsSaveButton()
	saveCharacteristics();
	TRP3_onCharacteristicsShown();
end

function TRP3_UI_CharacteristicsCancelButton()
	TRP3_onCharacteristicsShown();
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
		{loc("REG_PLAYER_PSYCHO_SOCIAL")},
		{loc("REG_PLAYER_PSYCHO_CHAOTIC") .. " - " .. loc("REG_PLAYER_PSYCHO_Loyal"), 1},
		{loc("REG_PLAYER_PSYCHO_Chaste") .. " - " .. loc("REG_PLAYER_PSYCHO_Luxurieux"), 2},
		{loc("REG_PLAYER_PSYCHO_Indulgent") .. " - " .. loc("REG_PLAYER_PSYCHO_Rencunier"), 3},
		{loc("REG_PLAYER_PSYCHO_Genereux") .. " - " .. loc("REG_PLAYER_PSYCHO_Egoiste"), 4},
		{loc("REG_PLAYER_PSYCHO_Sincere") .. " - " .. loc("REG_PLAYER_PSYCHO_Trompeur"), 5},
		{loc("REG_PLAYER_PSYCHO_Misericordieux") .. " - " .. loc("REG_PLAYER_PSYCHO_Cruel"), 6},
		{loc("REG_PLAYER_PSYCHO_Pieux") .. " - " .. loc("REG_PLAYER_PSYCHO_Rationnel"), 7},
		{loc("REG_PLAYER_PSYCHO_PERSONAL")},
		{loc("REG_PLAYER_PSYCHO_Pragmatique") .. " - " .. loc("REG_PLAYER_PSYCHO_Conciliant"), 8},
		{loc("REG_PLAYER_PSYCHO_Reflechi") .. " - " .. loc("REG_PLAYER_PSYCHO_Impulsif"), 9},
		{loc("REG_PLAYER_PSYCHO_Acete") .. " - " .. loc("REG_PLAYER_PSYCHO_Bonvivant"), 10},
		{loc("REG_PLAYER_PSYCHO_Valeureux") .. " - " .. loc("REG_PLAYER_PSYCHO_Couard"), 11},
		{loc("REG_PLAYER_PSYCHO_CUSTOM")},
		{loc("REG_PLAYER_PSYCHO_CREATENEW"), "new"},
	};
end

function TRP3_Register_CharInit()
	initStructures();
	
	-- UI
	TRP3_RegisterCharact_Edit_MiscAdd:SetScript("OnClick", miscAdd);
	TRP3_RegisterCharact_Edit_NamePanel_Icon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onPlayerIconSelected) end );
	
	TRP3_SetupDropDownMenu(TRP3_RegisterCharact_Edit_PsychoAdd, PSYCHO_PRESETS_DROPDOWN, psychoAdd, 0, true, false);
	
	-- Localz
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_NamePanel_Icon, "RIGHT", 0, 5, loc("REG_PLAYER_ICON"), loc("REG_PLAYER_ICON_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_TitleFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_TITLE"), loc("REG_PLAYER_TITLE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_FirstFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_FIRSTNAME"), loc("REG_PLAYER_FIRSTNAME_TT"):format(TRP3_PLAYER));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_LastFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_LASTNAME"), loc("REG_PLAYER_LASTNAME_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_FullTitleFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_FULLTITLE"), loc("REG_PLAYER_FULLTITLE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_RaceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_RACE"), loc("REG_PLAYER_RACE_TT"):format(TRP3_RACE_LOC));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_CLASS"), loc("REG_PLAYER_CLASS_TT"):format(TRP3_CLASS_LOC));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_AgeFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_AGE"), loc("REG_PLAYER_AGE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_BIRTHPLACE"), loc("REG_PLAYER_BIRTHPLACE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_RESIDENCE"), loc("REG_PLAYER_RESIDENCE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_EYE"), loc("REG_PLAYER_EYE_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_HeightFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_HEIGHT"), loc("REG_PLAYER_HEIGHT_TT"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterCharact_Edit_WeightFieldHelp, "RIGHT", 0, 5, loc("REG_PLAYER_WEIGHT"), loc("REG_PLAYER_WEIGHT_TT"));

	TRP3_FieldSet_SetCaption(TRP3_RegisterCharact_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterCharact_Edit_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterCharact_CharactPanel, loc("REG_PLAYER_CHARACTERISTICS"), 150);
	TRP3_FieldSet_SetCaption(TRP3_RegisterCharact_Edit_CharactPanel, loc("REG_PLAYER_CHARACTERISTICS"), 150);
	
	TRP3_RegisterCharact_Edit_MiscAdd:SetText(loc("REG_PLAYER_MISC_ADD"));
	TRP3_RegisterCharact_Edit_PsychoAdd:SetText(loc("REG_PLAYER_PSYCHO_ADD"));
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetText(loc("CM_SAVE"));
	TRP3_RegisterCharact_NamePanel_EditButton:SetText(loc("CM_EDIT"));
	TRP3_RegisterCharact_Edit_TitleFieldText:SetText(loc("REG_PLAYER_TITLE"));
	TRP3_RegisterCharact_Edit_FirstFieldText:SetText(loc("REG_PLAYER_FIRSTNAME"));
	TRP3_RegisterCharact_Edit_LastFieldText:SetText(loc("REG_PLAYER_LASTNAME"));
	TRP3_RegisterCharact_Edit_FullTitleFieldText:SetText(loc("REG_PLAYER_FULLTITLE"));
	TRP3_RegisterCharact_CharactPanel_RegisterTitle:SetText(TRP3_Icon("INV_Misc_Book_09", 25).." "..loc("REG_PLAYER_REGISTER"));
	TRP3_RegisterCharact_CharactPanel_Edit_RegisterTitle:SetText(TRP3_Icon("INV_Misc_Book_09", 25).." "..loc("REG_PLAYER_REGISTER"));
	TRP3_RegisterCharact_CharactPanel_PsychoTitle:SetText(TRP3_Icon("Spell_Arcane_MindMastery", 25).." "..loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetText(TRP3_Icon("Spell_Arcane_MindMastery", 25).." "..loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterCharact_CharactPanel_MiscTitle:SetText(TRP3_Icon("INV_MISC_NOTE_06", 25).." "..loc("REG_PLAYER_MISC"));
	TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle:SetText(TRP3_Icon("INV_MISC_NOTE_06", 25).." "..loc("REG_PLAYER_MISC"));
	TRP3_RegisterCharact_Edit_RaceFieldText:SetText(loc("REG_PLAYER_RACE"));
	TRP3_RegisterCharact_Edit_ClassFieldText:SetText(loc("REG_PLAYER_CLASS"));
	TRP3_RegisterCharact_Edit_AgeFieldText:SetText(loc("REG_PLAYER_AGE"));
	TRP3_RegisterCharact_Edit_EyeFieldText:SetText(loc("REG_PLAYER_EYE"));
	TRP3_RegisterCharact_Edit_HeightFieldText:SetText(loc("REG_PLAYER_HEIGHT"));
	TRP3_RegisterCharact_Edit_WeightFieldText:SetText(loc("REG_PLAYER_WEIGHT"));
	TRP3_RegisterCharact_Edit_ResidenceFieldText:SetText(loc("REG_PLAYER_RESIDENCE"));
	TRP3_RegisterCharact_Edit_BirthplaceFieldText:SetText(loc("REG_PLAYER_BIRTHPLACE"));
	
	TRP3_RegisterProfileSelectionHandler(compressData); -- On profile change, compress the new data
	compressData();
end