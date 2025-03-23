-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- imports
local Globals, Utils, Events, Ellyb = TRP3_API.globals, TRP3_API.utils, TRP3_Addon.Events, TRP3_API.Ellyb;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_API.profile.getData;
local getProfile = TRP3_API.register.getProfile;
local tcopy = Utils.table.copy;
local loc = TRP3_API.loc;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local getPlayerCurrentProfile = TRP3_API.profile.getPlayerCurrentProfile;
local getRelationTexture = TRP3_API.register.relation.getRelationTexture;
local RELATIONS = TRP3_API.register.relation;
local getRelationText, getRelationTooltipText, setRelation = RELATIONS.getRelationText, RELATIONS.getRelationTooltipText, RELATIONS.setRelation;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local showConfirmPopup, showTextInputPopup = TRP3_API.popup.showConfirmPopup, TRP3_API.popup.showTextInputPopup;
local deleteProfile = TRP3_API.register.deleteProfile;
local ignoreID = TRP3_API.register.ignoreID;
local buildZoneText = Utils.str.buildZoneText;
local setupEditBoxesNavigation = TRP3_API.ui.frame.setupEditBoxesNavigation;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local getRelationList = TRP3_API.register.relation.getRelationList;

local showIconBrowser = function(callback, selectedIcon)
	TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {callback, nil, nil, selectedIcon});
end;

local PSYCHO_PRESETS_UNKOWN;
local PSYCHO_PRESETS;
local PSYCHO_PRESETS_DROPDOWN;

local RELATIONSHIP_STATUS_DROPDOWN;

TRP3_PARCHMENT_BACKGROUND_COLOR = TRP3_API.CreateColor(0.37, 0.32, 0.21);

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
	"RA", "CL", "FN", "LN", "FT", "TI", "EC", "AG", "HE", "RE", "BP"
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
			-- Sanitizing misc traits
			if structure.MI then
				for _, trait in pairs(structure.MI) do
					-- Sanitizing value
					local sanitizedValue = Utils.str.sanitize(trait.VA);
					if sanitizedValue ~= trait.VA then
						trait.VA = sanitizedValue;
						somethingWasSanitized = true;
					end
					-- Sanitizing name
					sanitizedValue = Utils.str.sanitize(trait.NA);
					if sanitizedValue ~= trait.NA then
						trait.NA = sanitizedValue;
						somethingWasSanitized = true;
					end
				end
			end
			-- Sanitizing personality traits
			if structure.PS then
				for _, trait in pairs(structure.PS) do
					-- Sanitizing value
					local sanitizedValue = Utils.str.sanitize(trait.RT);
					if sanitizedValue ~= trait.RT then
						trait.RT = sanitizedValue;
						somethingWasSanitized = true;
					end
					-- Sanitizing name
					sanitizedValue = Utils.str.sanitize(trait.LT);
					if sanitizedValue ~= trait.LT then
						trait.LT = sanitizedValue;
						somethingWasSanitized = true;
					end
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

function TRP3_API.register.player.getCharacteristicsExchangeData()
	return get("player/characteristics");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - CONSULT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local registerCharLocals = {
	RA = "REG_PLAYER_RACE",
	CL = "REG_PLAYER_CLASS",
	AG = "REG_PLAYER_AGE",
	EC = "REG_PLAYER_EYE",
	HE = "REG_PLAYER_HEIGHT",
	WE = "REG_PLAYER_WEIGHT",
	BP = "REG_PLAYER_BIRTHPLACE",
	RE = "REG_PLAYER_RESIDENCE",
	RS = "REG_PLAYER_RELATIONSHIP_STATUS"
};

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

local function getPsychoStructureValue(psychoStructure)
	if psychoStructure.V2 then
		return psychoStructure.V2;
	else
		return Globals.PSYCHO_DEFAULT_VALUE_V2;
	end
end

local function refreshPsycho(psychoLine, value)
	-- Update value and then go on to update the stack count indicators.
	psychoLine.Bar:SetValue(value);

	local leftCount = value;
	local rightCount = Globals.PSYCHO_MAX_VALUE_V2 - value;

	-- If in edit mode and we have a visible custom icon, update that string
	-- and clear the normal one.
	if psychoLine.CustomLeftIcon and psychoLine.CustomLeftIcon:IsShown() then
		psychoLine.CustomLeftIcon.Count:SetText(leftCount);
		psychoLine.LeftCount:SetText("");
	else
		psychoLine.LeftCount:SetText(leftCount);
	end

	if psychoLine.CustomRightIcon and psychoLine.CustomRightIcon:IsShown() then
		psychoLine.CustomRightIcon.Count:SetText(rightCount);
		psychoLine.LeftCount:SetText("");
	else
		psychoLine.RightCount:SetText(rightCount);
	end

	-- The slider calls this function, so only update it if present and
	-- the value is different.
	if psychoLine.Slider and psychoLine.Slider:GetValue() ~= value then
		psychoLine.Slider:SetValue(value);
	end

	psychoLine.V2 = value;
end

-- TODO One day I'm gonna refactor all this and make a nice pretty mixin for TRP3_RegisterCharact_PsychoInfoDisplayLine, but not today
function TRP3_API.register.togglePsychoCountText(frame, isCursorOnFrame)
	local context = getCurrentContext();
	if isCursorOnFrame or context.isEditMode then
		frame.LeftCount:Show();
		frame.RightCount:Show();
	else
		frame.LeftCount:Hide();
		frame.RightCount:Hide();
	end
end

--- refreshPsychoColor refreshes the color shown on a line item, updating
--  the given named color field.
--  @param psychoLine The line item to update.
--  @param psychoColorField The color field being updated. Either LC or RC.
--  @param color The color to be applied. Must be an instance of Ellyb.Color,
--               or nil if resetting the color to a default.
local function refreshPsychoColor(psychoLine, psychoColorField, color)
	psychoLine[psychoColorField] = color;
	psychoLine:SetLeftColor(psychoLine.LC or TRP3_API.MiscColors.PersonalityTraitColorLeft);
	psychoLine:SetRightColor(psychoLine.RC or TRP3_API.MiscColors.PersonalityTraitColorRight);
end

local function setBkg(backgroundIndex)
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterCharact_CharactPanel, backgroundIndex);
end

local CHAR_KEYS = { "RA", "CL", "AG", "EC", "HE", "WE", "BP", "RE", "RS" };
local FIELD_TITLE_SCALE = 0.3;

local function scaleField(field, containerSize)
	field.NameField:SetWidth(containerSize * FIELD_TITLE_SCALE);
end

-- Create the pin template, above group members
---@type BaseMapPoiPinMixin|MapCanvasPinMixin|{Texture: Texture, GetMap: fun():MapCanvasMixin}
TRP3_PlayerHousePinMixin = AddOn_TotalRP3.MapPoiMixins.createPinTemplate(
		AddOn_TotalRP3.MapPoiMixins.AnimatedPinMixin -- Use animated icons (bounce in)
);

-- Expose template name, so the scan can use it for the MapDataProvider
TRP3_PlayerHousePinMixin.TEMPLATE_NAME = "TRP3_PlayerHousePinTemplate";

function TRP3_PlayerHousePinMixin:GetDisplayDataFromPoiInfo(poiInfo)
	local player
	if poiInfo.characterID then
		player = AddOn_TotalRP3.Player.CreateFromCharacterID(poiInfo.characterID);
	elseif poiInfo.profileID then
		player = AddOn_TotalRP3.Player.CreateFromProfileID(poiInfo.profileID);
	else
		error("Cannot get display data for this player house.");
	end
	return {
		iconAtlas = "poi-town",
		tooltip = player:GetCustomColoredRoleplayingNamePrefixedWithIcon()
	}
end

function TRP3_PlayerHousePinMixin:Decorate(displayData)
	self.Texture:SetSize(16, 16);
	self:SetSize(16, 16);

	if displayData.tooltip then
		Ellyb.Tooltips.getTooltip(self)
				:SetTitle(loc.REG_PLAYER_RESIDENCE, TRP3_API.Colors.Orange)
				:ClearLines()
				:AddLine(displayData.tooltip)
	end
end

local ConsultFramePools = CreateFramePoolCollection();
ConsultFramePools:CreatePool("Frame", TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoLine");
ConsultFramePools:CreatePool("Frame", TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_RegisterInfoSwatchLine");
ConsultFramePools:CreatePool("Frame", TRP3_RegisterCharact_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoDisplayLine");

local function setConsultDisplay(context)
	local dataTab = context.profile.characteristics or Globals.empty;
	local hasCharac, hasPsycho, hasMisc, margin;
	assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
	-- Icon, complete name and titles
	local completeName = getCompleteName(dataTab, UNKNOWN);
	TRP3_RegisterCharact_NamePanel_Name:SetText(completeName);
	TRP3_RegisterCharact_NamePanel_Name:SetReadableTextColor(TRP3_API.CreateColorFromHexString(dataTab.CH or "ffffff"));
	TRP3_RegisterCharact_NamePanel_Name:SetFixedColor(true);
	TRP3_RegisterCharact_NamePanel_Title:SetText((string.gsub(dataTab.FT or "", "%s+", " ")));
	TRP3_RegisterCharact_NamePanel.Icon:SetIconTexture(dataTab.IC);

	setBkg(dataTab.bkg or 1);

	-- hide all
	ConsultFramePools:ReleaseAll();
	TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:Hide();
	TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:Hide();
	TRP3_RegisterCharact_CharactPanel_ResidenceButton:Hide();
	TRP3_RegisterCharact_NamePanel_WalkupButton:Hide();

	if context.profile.character and context.profile.character.WU == AddOn_TotalRP3.Enums.WALKUP.YES then
		TRP3_RegisterCharact_NamePanel_WalkupButton:Show();
		setTooltipForSameFrame(TRP3_RegisterCharact_NamePanel_WalkupButton, "RIGHT", 0, 5, loc.DB_STATUS_WU, loc.REG_PLAYER_WALKUP_TT);
	end

	-- Previous var helps for layout building
	local previous = TRP3_RegisterCharact_CharactPanel_Container.RegisterTitle;
	TRP3_RegisterCharact_CharactPanel_Container.RegisterTitle:Hide();

	-- Which directory chars must be shown ?
	local shownCharacteristics = {};
	local shownValues = {};
	for _, attribute in pairs(CHAR_KEYS) do
		if attribute == "RS" then
			if dataTab[attribute] and dataTab[attribute] > 0 then
				local relationshipToDisplay = RELATIONSHIP_STATUS_DROPDOWN[dataTab[attribute] + 1];
				if relationshipToDisplay then
					tinsert(shownCharacteristics, attribute);
					shownValues[attribute] = relationshipToDisplay[1];
				end
			end
		elseif strtrim(dataTab[attribute] or ""):len() > 0 then
			tinsert(shownCharacteristics, attribute);
			shownValues[attribute] = dataTab[attribute];
		end
	end
	if #shownCharacteristics > 0 then
		hasCharac = true;
		TRP3_RegisterCharact_CharactPanel_Container.RegisterTitle:Show();
		margin = -5;
	else
		margin = 50;
	end

	-- Show directory chars values
	for _, charName in pairs(shownCharacteristics) do
		local frame;

		if charName == "EC" or charName == "CL" then
			frame = ConsultFramePools:Acquire("TRP3_RegisterCharact_RegisterInfoSwatchLine");
		else
			frame = ConsultFramePools:Acquire("TRP3_RegisterCharact_RegisterInfoLine");
		end

		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 5);
		frame:SetPoint("RIGHT", 0, 0);
		frame:SetIconShown(false);
		frame:SetTitleText(loc:GetText(registerCharLocals[charName]));
		frame:SetValueText(shownValues[charName]);
		frame:Show();

		if charName == "EC" then
			frame:SetValueColorFromHexString(dataTab.EH);
		elseif charName == "CL" then
			frame:SetValueColorFromHexString(dataTab.CH);
		end

		if charName == "RE" and dataTab.RC and # dataTab.RC >= 4 then
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:Show();
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:ClearAllPoints();
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:SetPoint("RIGHT", frame.Value, "LEFT", -5, 0);
			setTooltipForSameFrame(TRP3_RegisterCharact_CharactPanel_ResidenceButton, "RIGHT", 0, 5, loc.REG_PLAYER_RESIDENCE_SHOW, dataTab.RC[4] .. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_RESIDENCE_SHOW_TT));
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:SetScript("OnClick", function()
				if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
					-- Bug: https://github.com/Stanzilla/WoWUIBugs/issues/124
					ShowUIPanel(WorldMapFrame);
					WorldMapFrame:SetMapID(dataTab.RC[1]);
				else
					OpenWorldMap(dataTab.RC[1]);
				end

				local characterID;
				local profileID;
				if context.source == "player" then
					characterID = TRP3_API.globals.player_id
				elseif context.unitID then
					characterID = context.unitID
				elseif context.profileID then
					profileID = context.profileID
				else
					error("Could not retrieve unit from this profile.")
				end
				AddOn_TotalRP3.Map.placeSingleMarker(dataTab.RC[2], dataTab.RC[3], { characterID = characterID, profileID = profileID }, TRP3_PlayerHousePinMixin.TEMPLATE_NAME)
			end);
		end
		previous = frame;
	end

	-- Misc chars
	if type(dataTab.MI) == "table" and #dataTab.MI > 0 then
		hasMisc = true;
		TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:Show();
		TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, margin);
		TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:SetPoint("RIGHT", -10, 0);
		previous = TRP3_RegisterCharact_CharactPanel_Container.MiscTitle;

		for frameIndex, miscStructure in ipairs(dataTab.MI) do
			local field = TRP3_API.GetMiscFieldFromData(miscStructure);
			local frame = ConsultFramePools:Acquire("TRP3_RegisterCharact_RegisterInfoLine");
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, frameIndex == 1 and -5 or 0);
			frame:SetPoint("RIGHT", 0, 0);
			frame:SetIcon(field.icon);
			frame:SetIconShown(true);
			frame:SetTitleText(field.localizedName);
			frame:SetValueText(field.value);
			frame:Show();
			previous = frame;
		end
	end

	-- Psycho chars
	if type(dataTab.PS) == "table" and #dataTab.PS > 0 then
		hasPsycho = true;
		TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:Show();
		TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:ClearAllPoints();
		TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, margin);
		TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:SetPoint("RIGHT", -10, 0);
		previous = TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle;

		for _, psychoStructure in ipairs(dataTab.PS) do
			local frame = ConsultFramePools:Acquire("TRP3_RegisterCharact_PsychoInfoDisplayLine");
			local value = getPsychoStructureValue(psychoStructure);

			-- Preset pointer
			if psychoStructure.ID then
				psychoStructure = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			end

			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
			frame:SetPoint("RIGHT", 0, 0);

			-- Applying custom colors to attribute names.
			frame:SetLeftText(psychoStructure.LT);
			frame:SetRightText(psychoStructure.RT);
			frame:SetLeftIcon(psychoStructure.LI);
			frame:SetRightIcon(psychoStructure.RI);

			frame.Bar:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);

			refreshPsycho(frame, value);
			refreshPsychoColor(frame, "LC", psychoStructure.LC and TRP3_API.CreateColorFromTable(psychoStructure.LC));
			refreshPsychoColor(frame, "RC", psychoStructure.RC and TRP3_API.CreateColorFromTable(psychoStructure.RC));
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
	draftData.RS = tonumber(TRP3_RegisterCharact_Dropdown_RelationshipField:GetSelectedValue());

	-- Save psycho values
	for index, psychoStructure in pairs(draftData.PS) do
		local psychoLine = psychoEditCharFrame[index];
		psychoStructure.V2 = psychoLine.V2;

		-- Clear out the colors prior to persistence.
		psychoStructure.LC = nil;
		psychoStructure.RC = nil;

		if not psychoStructure.ID then
			-- If not a preset
			psychoStructure.LT = stEtN(psychoLine.CustomLeftField:GetText()) or loc.REG_PLAYER_LEFTTRAIT;
			psychoStructure.RT = stEtN(psychoLine.CustomRightField:GetText()) or loc.REG_PLAYER_RIGHTTRAIT;


			local lc = psychoLine.LC;
			if lc then
				local r = RoundToSignificantDigits(lc.r, 2);
				local g = RoundToSignificantDigits(lc.g, 2);
				local b = RoundToSignificantDigits(lc.b, 2);
				psychoStructure.LC = { r = r, g = g, b = b };
			end

			local rc = psychoLine.RC;
			if rc then
				local r = RoundToSignificantDigits(rc.r, 2);
				local g = RoundToSignificantDigits(rc.g, 2);
				local b = RoundToSignificantDigits(rc.b, 2);
				psychoStructure.RC = { r = r, g = g, b = b };
			end
		else
			-- Don't save preset data !
			psychoStructure.LT = nil;
			psychoStructure.RT = nil;
			psychoStructure.LI = nil;
			psychoStructure.RI = nil;
			psychoStructure.LC = nil;
			psychoStructure.RC = nil;
		end
	end
	-- Save Misc
	for index, miscStructure in pairs(draftData.MI) do
		miscStructure.VA = stEtN(miscEditCharFrame[index].ValueField:GetText()) or loc.CM_VALUE;
		miscStructure.NA = stEtN(miscEditCharFrame[index].NameField:GetText()) or loc.CM_NAME;
	end

end

local function onPlayerIconSelected(icon)
	draftData.IC = icon;
	setupIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or TRP3_InterfaceIcons.ProfileDefault);
end

--- pasteCopiedIcon handles receiving an icon from the right-click menu.
---@param frame Frame The frame the icon belongs to.
---@param fields string To identify the required fields to modify.
---@param structure Frame The draftData frame that holds all the info.
local function pasteCopiedIcon(frame, fields, structure)
	local icon = TRP3_API.GetLastCopiedIcon() or TRP3_InterfaceIcons.Default;
	if fields == "misc" then
		structure.IC = icon;
	elseif fields == "psychoLeft" then
		structure.LI = icon;
	elseif fields == "psychoRight" then
		structure.RI = icon;
	end
	setupIconButton(frame, icon);
end

local function onEyeColorSelected(red, green, blue)
	if red and green and blue then
		local hexa = TRP3_API.CreateColorFromBytes(red, green, blue):GenerateHexColorOpaque();
		draftData.EH = hexa;
	else
		draftData.EH = nil;
	end
end

local function onClassColorSelected(red, green, blue)
	if red and green and blue then
		local hexa = TRP3_API.CreateColorFromBytes(red, green, blue):GenerateHexColorOpaque();
		draftData.CH = hexa;
	else
		draftData.CH = nil;
	end
end

local function onPsychoValueChanged(frame, value)
	refreshPsycho(frame:GetParent(), math.max(math.min(value, Globals.PSYCHO_MAX_VALUE_V2), 0));
end

local function refreshEditIcon(frame)
	setupIconButton(frame, frame.IC or TRP3_InterfaceIcons.ProfileDefault);
end

local function onMiscDelete(self)
	assert(self and self:GetParent(), "Badly initialized remove, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.MI[frame.frameIndex], "Badly initialized remove, index");
	saveInDraft();
	wipe(draftData.MI[frame.frameIndex]);
	tremove(draftData.MI, frame.frameIndex);
	setEditDisplay();
end

local function miscAdd(ID, NA, VA, IC)
	saveInDraft();
	tinsert(draftData.MI, {
		ID = ID,
		NA = NA,
		VA = VA,
		IC = IC,
	});
	setEditDisplay();
end

local function onMiscDuplicate(self)
	assert(self and self:GetParent(), "Badly initialized duplicate, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.MI[frame.frameIndex], "Badly initialized duplicate, index");
	saveInDraft();
	tinsert(draftData.MI, CopyTable(draftData.MI[frame.frameIndex]));
	setEditDisplay();
end

local function onMiscConvert(self)
	assert(self and self:GetParent(), "Badly initialized convert, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.MI[frame.frameIndex], "Badly initialized convert, index");
	saveInDraft();
	draftData.MI[frame.frameIndex]["ID"] = 1;
	setEditDisplay();
end

local MISC_PRESET = {
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.House),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Nickname),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Motto),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.FacialFeatures),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Piercings),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Pronouns),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.GuildName),
	Mixin(TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.GuildRank), {
		value = loc.DEFAULT_GUILD_RANK,
	}),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Tattoos),
	TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.VoiceReference),
	Mixin(TRP3_API.GetMiscTypeInfo(TRP3_API.MiscInfoType.Custom), {
		list = "|cnGREEN_FONT_COLOR:" .. loc.REG_PLAYER_ADD_NEW,
		value = loc.CM_VALUE,
	}),
};

local function miscAddDropDownSelection(index)
	local preset = MISC_PRESET[index];
	miscAdd(preset.type, preset.localizedName, preset.value or "", preset.icon);
end

local function SortCompareMiscEntries(a, b)
	a = MISC_PRESET[a[2]];
	b = MISC_PRESET[b[2]];

	if a.list ~= b.list then
		return a.list == nil;  -- Force "Create new" to end of list.
	else
		return strcmputf8i(a.localizedName, b.localizedName) < 0;
	end
end

local function miscAddDropDown()
	local values = {};
	for index, preset in pairs(MISC_PRESET) do
		table.insert(values, { preset.list or preset.localizedName, index, preset.shownOnTooltip });
	end
	table.sort(values, SortCompareMiscEntries);

	TRP3_MenuUtil.CreateContextMenu(TRP3_RegisterCharact_Edit_MiscAdd, function(_, description)
		description:CreateTitle(loc.REG_PLAYER_MISC_ADD);
		for _, preset in pairs(values) do
			local addOption = description:CreateButton(preset[1], miscAddDropDownSelection, preset[2]);
			if preset[3] then
				TRP3_MenuUtil.AttachTexture(addOption, "transmog-icon-chat");
				TRP3_MenuUtil.SetElementTooltip(addOption, loc.REG_PLAYER_MISC_ADD_TOOLTIP);
			end
		end
	end);
end

local function psychoAdd(presetID)
	saveInDraft();
	if presetID == "new" then
		tinsert(draftData.PS, {
			LT = loc.REG_PLAYER_LEFTTRAIT,
			LI = "INV_Misc_QuestionMark",
			RT = loc.REG_PLAYER_RIGHTTRAIT,
			RI = "INV_Misc_QuestionMark",
			V2 = Globals.PSYCHO_DEFAULT_VALUE_V2,
		});
	else
		tinsert(draftData.PS, {
			ID = presetID,
			V2 = Globals.PSYCHO_DEFAULT_VALUE_V2,
		});
	end
	setEditDisplay();
end

local function onPsychoDelete(self)
	assert(self and self:GetParent(), "Badly initialized remove, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.PS[frame.frameIndex], "Badly initialized remove button, index");
	saveInDraft();
	wipe(draftData.PS[frame.frameIndex]);
	tremove(draftData.PS, frame.frameIndex);
	setEditDisplay();
end

local function onPsychoDuplicate(self)
	assert(self and self:GetParent(), "Badly initialized duplicate, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.PS[frame.frameIndex], "Badly initialized duplicate, index");
	saveInDraft();
	tinsert(draftData.PS, CopyTable(draftData.PS[frame.frameIndex]));
	setEditDisplay();
end

local function onPsychoConvert(self)
	assert(self and self:GetParent(), "Badly initialized convert, reference");
	local frame = self:GetParent();
	assert(frame.frameIndex and draftData.PS[frame.frameIndex], "Badly initialized convert, index");
	saveInDraft();
	local newPsycho = CopyTable(draftData.PS[frame.frameIndex])

	-- Grab psycho text and icons through its preset ID
	local preset = PSYCHO_PRESETS[newPsycho.ID] or PSYCHO_PRESETS_UNKOWN;

	-- Use that data to fill in the blanks of the psycho field.
	draftData.PS[frame.frameIndex]["ID"] = nil;

	draftData.PS[frame.frameIndex]["LT"] = preset.LT or "";
	draftData.PS[frame.frameIndex]["RT"] = preset.RT or "";

	draftData.PS[frame.frameIndex]["LI"] = preset.LI;
	draftData.PS[frame.frameIndex]["RI"] = preset.RI;
	setEditDisplay();
end

local function refreshDraftHouseCoordinates()
	local houseTT = TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_HERE_HOME_TT_CURRENT) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_HERE_HOME_TT_DISCARD);
	if draftData.RC and #draftData.RC == 4 then
		houseTT = loc.REG_PLAYER_HERE_HOME_PRE_TT:format(draftData.RC[4]) .. "|n|n" .. houseTT;
	else
		houseTT = loc.REG_PLAYER_HERE_TT .. "|n|n" .. houseTT;
	end
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceButton, "RIGHT", 0, 5, loc.REG_PLAYER_HERE, houseTT);
	TRP3_RegisterCharact_Edit_ResidenceButton:Hide();
	TRP3_RegisterCharact_Edit_ResidenceButton:Show(); -- Hax to refresh tooltip
end

--- MISC_DRAG_UPDATE_PERIOD is the rate at which we'll test other
--- Misc. items in the list to update their positions in a drag/drop reorder
--- operation.
local MISC_DRAG_UPDATE_PERIOD = 0.01;

--- MISC_DRAG_SCROLL_DELTA is the amount of pixels to scroll by when
--- the cursor is outside of the scroll frame.
---
--- Increasing this gives you a faster scroll, but be mindful - it gets
--- re-checked every time the update period elapses.
local MISC_DRAG_SCROLL_DELTA = 1;

local function reorderInfoTestRectangleCoord(y1, y2, cy)
	if cy >= y2 then
		return 1;
	elseif cy <= y1 then
		return -1;
	else
		-- Logically it's impossible at this point for (cx, cy) to be anywhere
		-- but within bounds of the rectangle.
		return 0;
	end
end

--- reorderInfoQueryCursorIndexPosition calculates out the index of which item
--- in the character info sheet list that the mouse is presently located over.
---
--- If the mouse is not over any item, nil is returned. If the mouse is within
--- the X coordinate boundaries of the first or last items but above or below
--- the first or last items in the list, the indices of those items are
--- returned respectively.
---@param data table The info data it requires: draftData.MI or draftData.PS.
---@param editCharFrame Frame miscEditCharFrame or psychoEditCharFrame to check.
local function reorderInfoQueryCursorIndexPosition(data, editCharFrame)
	-- Grab the cursor position early on, since we don't need to keep
	-- asking for it in one update.
	local _, mouseY = GetCursorPosition();

	-- We need to know the total number of characteristics for a bit later.
	local lastItemIndex = 0;
	for frameIndex in ipairs(data) do
		if frameIndex > lastItemIndex then
			lastItemIndex = frameIndex;
		end
	end

	-- Iterate over each of the misc info items and process them in turn.
	for i = 1, lastItemIndex do
		local frame = editCharFrame[i];

		local _, bottom, _, height = frame:GetRect();
		local y1 = bottom;
		local y2 = bottom + height;

		local frameScale = frame:GetEffectiveScale();
		local my = mouseY / frameScale;

		local relativeMousePosition = reorderInfoTestRectangleCoord(y1, y2, my);
		if relativeMousePosition then
			if relativeMousePosition == 0 then
				-- You're directly over this item.
				return i;
			elseif relativeMousePosition < 0 and i == lastItemIndex then
				-- The relative index of the last item is lesser, which
				-- means you've moved your cursor below it.
				return lastItemIndex;
			elseif relativeMousePosition > 0 and i == 1 then
				-- The relative index of the first item is greater, which
				-- means you've moved your cursor above it.
				return i;
			end
		end
	end
end

--- reorderInfoScrollParentTowardCursor updates the vertical scroll position
--- of the edit character panel, adjusting it so that the position is moving
--- toward the location of the cursor.
local function reorderInfoScrollParentTowardCursor()
	-- Get the scroll frame and query its current position.
	local frame = TRP3_RegisterCharact_Edit_CharactPanel_Scroll;

	-- Work out our mouse position, calculate to effective scale of the frame.
	local _, my = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	my = my / scale;

	-- Only adjust positioning if the mouse is outside of the frame bounds
	-- from a vertical perspective.
	local _, y1, _, height = frame:GetRect();
	local y2 = y1 + height;
	local relativeMousePosition = reorderInfoTestRectangleCoord(y1, y2, my);
	if not relativeMousePosition or relativeMousePosition == 0 then
		-- Either you're not within the bounds from an X coordinate perspective
		-- or you're mousing over the frame.
		return;
	end

	-- Work out the center Y coordinate of the frame.
	local bottom = frame:GetBottom();
	local center = bottom + height;

	-- If you're above the center then we want to scroll up, otherwise down.
	local position = frame:GetVerticalScroll();
	if my > center then
		position = position - MISC_DRAG_SCROLL_DELTA;
	else
		position = position + MISC_DRAG_SCROLL_DELTA;
	end

	frame:SetVerticalScroll(position);
end

--- reorderInfoFixupPosition adjusts the points on a given frame, altering
--- the starting with TOP anchor point such that it is made relative to a
--- different frame.
---
--- This operation preserves all other points, as well as the offsets of the
--- starting with TOP point.
---@param frame Frame The frame to alter the starting with TOP point on.
---@param relative Frame The frame to make the starting with TOP point relative to.
local function reorderInfoFixupPosition(frame, relative)
	-- We could abstract the positioning into a separate function but
	-- in this case it should happen infrequently enough.
	--
	-- Check the anchor points of the frame and find the TOP point anchor.
	-- When we do, we'll re-assign that point to the given relative frame
	-- and preserve all the other attributes.
	for i = 1, frame:GetNumPoints() do
		local point, _, relPoint, x, y = frame:GetPoint(i);
		if point:find("^TOP") and relPoint:find("^BOTTOM") then
			frame:SetPoint(point, relative, relPoint, x, y);
			return;
		end
	end
end

--- reorderInfoPerformReorder reorders the character frame info list, moving
--- the item at a given source index to that of a target index, and updating
--- the layout of the UI.
---@param data table The info data it requires: draftData.MI or draftData.PS.
---@param editCharFrame Frame miscEditCharFrame or psychoEditCharFrame to check.
---@param sourceIndex number The index of the node being moved.
---@param targetIndex number The index to place the node at.
---@param editTitle Frame The character edit title.
---@param addBtn Button The add more button.
local function reorderInfoPerformReorder(data, editCharFrame, sourceIndex, targetIndex, editTitle, addBtn)
	-- We'll just do a flat table order change here with a tinsert/tremove.
	local source = table.remove(data, sourceIndex);
	table.insert(data, targetIndex, source);

	-- Reorder the frame too. Means we don't need to transfer all the values,
	-- which fixes issues with icons not persisting correctly when reordering.
	local sourceFrame = table.remove(editCharFrame, sourceIndex);
	table.insert(editCharFrame, targetIndex, sourceFrame);

	-- Now fix up all the frames in terms of their referenced indices.
	local previous = editTitle;
	for frameIndex in ipairs(data) do
		local frame = editCharFrame[frameIndex];
		frame.frameIndex = frameIndex;

		reorderInfoFixupPosition(frame, previous);
		previous = frame;
	end

	reorderInfoFixupPosition(addBtn, previous);
end

--- onInfoDragUpdate is called when the timer associated with a handle
--- drag ticks. This is responsible for checking the position of the
--- mouse relative to items in the list.
---@param ticker userdata|cbObject The ticker associated with the handle being dragged.
---@param choice string Whether we are interacting with "misc" or "psycho".
---@param data table The info data it requires: draftData.MI or draftData.PS.
---@param editCharFrame Frame miscEditCharFrame or psychoEditCharFrame to check.
---@param editTitle Frame The character edit title.
---@param addBtn Button The add more button.
local function onInfoDragUpdate(ticker, data, editCharFrame, editTitle, addBtn)
	-- Ensure the scroll frame moves with the cursor.
	reorderInfoScrollParentTowardCursor();

	-- Grab the handle when we tick and, from that, we can get the source
	-- node.
	local handle = ticker.handle;
	local source = handle.node;

	-- Work out the index of the frame to swap with, if any. Skip if the
	-- source and target are identical, or if there is no target.
	local targetIndex = reorderInfoQueryCursorIndexPosition(data, editCharFrame);
	if not targetIndex or targetIndex == source.frameIndex then
		return;
	end

	reorderInfoPerformReorder(data, editCharFrame, source.frameIndex, targetIndex, editTitle, addBtn);
end

--- onInfoDragStart is called when a handle begins being dragged.
--- This is responsible for starting a ticker to control the reorder operation.
---@param handle table The handle being dragged by the user.
---@param choice string Whether we are interacting with "misc" or "psycho".
---@param data table The info data it requires: draftData.MI or draftData.PS.
---@param editCharFrame Frame miscEditCharFrame or psychoEditCharFrame to check.
---@param editTitle Frame The character edit title.
---@param addBtn Button The add more button.
local function onInfoDragStart(handle, data, editCharFrame, editTitle, addBtn)
	if handle.infoTicker then
		handle.infoTicker:Cancel();
	end

	local ticker = C_Timer.NewTicker(MISC_DRAG_UPDATE_PERIOD, function(ticker) onInfoDragUpdate(ticker, data, editCharFrame, editTitle, addBtn) end);

	ticker.handle = handle;
	handle.infoTicker = ticker;

	SetCursor("Interface\\CURSOR\\UI-Cursor-Move");
	PlaySound(TRP3_InterfaceSounds.DragPickup);
end

--- onInfoDragStop is called when a handle is no longer being dragged.
--- This is responsible for stopping the drag/drop operation ticker.
---@param handle table The handle being dragged by the user.
local function onInfoDragStop(handle)
	if not handle.infoTicker then
		return;
	end

	handle.infoTicker:Cancel();
	handle.infoTicker = nil;

	SetCursor(nil);
	PlaySound(TRP3_InterfaceSounds.DragDrop);
end

--- setInfoReorderable installs the necessary script handlers to enable
--- a handle frame to control the drag and drop operations of a given node
--- frame.
---@param handle table The frame that, when dragged, will start repositioning the associated node.
---@param node table The info item to be reordered when the handle is dragged.
---@param choice string Whether we are interacting with "misc" or "psycho".
---@param editTitle Frame The character edit title.
---@param addBtn Button The add more button.
local function setInfoReorderable(handle, node, choice, editTitle, addBtn)
	-- Store a reference to the node that we're controlling on the handle.
	-- The handle needs this when updating in the drag events.
	handle.node = node;

	-- This'll hold our drag/drop ticker so we can stop it later. The field
	-- is initialised here more for documentational purposes.
	handle.infoTicker = nil;

	handle:EnableMouse(true);
	handle:RegisterForClicks("AnyDown", "AnyUp");

	-- Differentiate between misc or pyscho here, as draftData and the
	-- editCharFrame have to be fed in here so the data is always current
	-- as soon as the user starts to reorder.
	if choice == "misc" then
		handle:SetScript("OnMouseDown", function() onInfoDragStart(handle, draftData.MI, miscEditCharFrame, editTitle, addBtn) end);
	else
		handle:SetScript("OnMouseDown", function() onInfoDragStart(handle, draftData.PS, psychoEditCharFrame, editTitle, addBtn) end);
	end
	handle:SetScript("OnMouseUp", onInfoDragStop);

	-- If the handle stops being shown we should kill the drag.
	handle:SetScript("OnHide", onInfoDragStop);
end

--- updatePsychoLineEditorFieldVisibility toggles the shown state of all
--  given child widgets or regions based upon the presents of a pair boolean
--  flags (HideOnPreset and HideOnCustom).
--
--  @param isPreset Is the current line representative of a preset structure?
--  @param ... The frames or regions to update the visibility of.
local function updatePsychoLineEditorFieldVisibility(isPreset, ...)
	for i = 1, select("#", ...) do
		local child = select(i, ...);

		-- Be strict on the check here since we're going to get elements that
		-- can have neither set.
		local shouldHide = (isPreset and child.HideOnPreset) or (not isPreset and child.HideOnCustom);
		if not child.IgnoreVisibilityUpdates then
			child:SetShown(not shouldHide);
		end
	end
end

function setEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/characteristics");
		assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end

	setupIconButton(TRP3_RegisterCharact_Edit_NamePanel_Icon, draftData.IC or TRP3_InterfaceIcons.ProfileDefault);
	TRP3_RegisterCharact_Edit_TitleField:SetText(draftData.TI or "");
	TRP3_RegisterCharact_Edit_FirstField:SetText(draftData.FN or Globals.player);
	TRP3_RegisterCharact_Edit_LastField:SetText(draftData.LN or "");
	TRP3_RegisterCharact_Edit_FullTitleField:SetText(draftData.FT or "");

	TRP3_RegisterCharact_Edit_RaceField:SetText(draftData.RA or "");
	TRP3_RegisterCharact_Edit_ClassField:SetText(draftData.CL or "");
	TRP3_RegisterCharact_Edit_AgeField:SetText(draftData.AG or "");
	TRP3_RegisterCharact_Edit_EyeField:SetText(draftData.EC or "");

	if draftData.EH then
		TRP3_RegisterCharact_Edit_EyeButton.setColor(TRP3_API.CreateColorFromHexString(draftData.EH):GetRGBAsBytes());
	else
		TRP3_RegisterCharact_Edit_EyeButton.setColor(nil, nil, nil);
	end

	if draftData.CH then
		TRP3_RegisterCharact_Edit_ClassButton.setColor(TRP3_API.CreateColorFromHexString(draftData.CH):GetRGBAsBytes());
	else
		TRP3_RegisterCharact_Edit_ClassButton.setColor(nil, nil, nil);
	end

	TRP3_RegisterCharact_Edit_HeightField:SetText(draftData.HE or "");
	TRP3_RegisterCharact_Edit_WeightField:SetText(draftData.WE or "");
	TRP3_RegisterCharact_Edit_ResidenceField:SetText(draftData.RE or "");
	TRP3_RegisterCharact_Edit_BirthplaceField:SetText(draftData.BP or "");

	TRP3_RegisterCharact_Dropdown_RelationshipField:SetSelectedValue(draftData.RS or AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN)

	refreshDraftHouseCoordinates();

	-- Misc
	local previous = TRP3_RegisterCharact_Edit_CharactPanel_Container.MiscTitle;
	for _, frame in pairs(miscEditCharFrame) do frame:Hide(); end
	for frameIndex, miscStructure in pairs(draftData.MI) do
		local frame = miscEditCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_MiscEditLine");
			frame.NameField:SetText(loc.CM_NAME);
			frame.ValueField:SetText(loc.CM_VALUE);
			setTooltipForSameFrame(frame.Action, "RIGHT", 0, 5, loc.CM_OPTIONS, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPTIONS_ADDITIONAL));
			scaleField(frame, TRP3_RegisterCharact_Edit_CharactPanel_Container:GetWidth(), "NameField");

			-- Register the drag/drop handlers for reordering. Use the
			-- icon as our handle, and make it control this frame.
			setInfoReorderable(frame.DragButton, frame, "misc", TRP3_RegisterCharact_Edit_CharactPanel_Container.MiscTitle, TRP3_RegisterCharact_Edit_MiscAdd);
			setTooltipForSameFrame(frame.Icon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));

			tinsert(miscEditCharFrame, frame);
		end

		frame.Action:SetScript("OnMouseDown", function(self)
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				-- If not custom, allow convert to custom.
				if miscStructure.ID ~= TRP3_API.MiscInfoType.Custom then
					local convertOption = description:CreateButton(loc.REG_PLAYER_CONVERT, onMiscConvert, self);
					if TRP3_API.GetMiscTypeInfo(miscStructure.ID).shownOnTooltip then
						TRP3_MenuUtil.SetElementTooltip(convertOption, loc.REG_PLAYER_CONVERT_WARNING);
					end
				end
				description:CreateButton(loc.CM_DUPLICATE, onMiscDuplicate, self);
				description:CreateButton("|cnRED_FONT_COLOR:" .. loc.CM_REMOVE .. "|r", onMiscDelete, self);
			end);
		end);

		frame.Icon:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				showIconBrowser(function(icon)
					miscStructure.IC = icon;
					setupIconButton(frame.Icon, icon or TRP3_InterfaceIcons.Default);
				end, miscStructure.IC);
			elseif button == "RightButton" then
				local icon = miscStructure.IC or TRP3_InterfaceIcons.Default;
				TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
					description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
					description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
					description:CreateButton(loc.UI_ICON_PASTE, function() pasteCopiedIcon(frame.Icon, "misc", miscStructure); end);
				end);
			end
		end);

		frame.frameIndex = frameIndex;
		frame.Icon.IC = miscStructure.IC or TRP3_InterfaceIcons.Default;
		frame.NameField:SetText(miscStructure.NA or loc.CM_NAME);
		-- Disable name editing on presets
		if miscStructure.ID == TRP3_API.MiscInfoType.Custom then
			frame.NameField:Show();
			frame.PresetName:Hide();
		else
			frame.NameField:Hide();
			frame.PresetName:Show();
			frame.PresetName:SetText(miscStructure.NA or loc.CM_NAME);
		end
		frame.ValueField:SetText(miscStructure.VA or loc.CM_VALUE);
		refreshEditIcon(frame.Icon);
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
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:ClearAllPoints();
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:SetPoint("TOP", previous, "BOTTOM", 0, -5);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:SetPoint("LEFT", 10, 0);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:SetPoint("RIGHT", -10, 0);
	previous = TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle;
	for _, frame in pairs(psychoEditCharFrame) do frame:Hide(); end
	for frameIndex, psychoStructure in pairs(draftData.PS) do
		local frame = psychoEditCharFrame[frameIndex];
		local value = getPsychoStructureValue(psychoStructure);

		if frame == nil then
			-- Create psycho attribute widget if not already exists
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoEditLine");

			frame.CustomLeftField.title:SetText(loc.REG_PLAYER_LEFTTRAIT);
			frame.CustomRightField.title:SetText(loc.REG_PLAYER_RIGHTTRAIT);

			frame.LeftCount:Show();
			frame.RightCount:Show();

			frame.Bar:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);
			frame.Bar.Thumb:Hide();

			frame.Slider:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);
			frame.Slider:SetScript("OnValueChanged", onPsychoValueChanged);

			setTooltipForSameFrame(frame.CustomLeftIcon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, loc.REG_PLAYER_PSYCHO_LEFTICON_TT .. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
			setTooltipForSameFrame(frame.CustomRightIcon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, loc.REG_PLAYER_PSYCHO_RIGHTICON_TT.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
			setTooltipForSameFrame(frame.ActionButton, "RIGHT", 0, 5, loc.CM_OPTIONS, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPTIONS_ADDITIONAL));

			setTooltipForSameFrame(frame.CustomLeftColor, "RIGHT", 0, 5, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR_LEFT_TT
			.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_COLOR_TT_SELECT)
			.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_COLOR_TT_OPTIONS)
			.. "|n" .. TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.REG_PLAYER_COLOR_TT_DEFAULTPICKER));
			setTooltipForSameFrame(frame.CustomRightColor, "RIGHT", 0, 5, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR_RIGHT_TT
			.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_COLOR_TT_SELECT)
			.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_COLOR_TT_OPTIONS)
			.. "|n" .. TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.REG_PLAYER_COLOR_TT_DEFAULTPICKER));

			-- Only need to set up the closure for color pickers once, as it
			-- just needs a reference to the frame itself.
			--
			-- FIXME: When the feature/color_picker_button_mixin branch
			--        lands we can drop these closures and swap to methods,
			--        as well as not worry about all the TRP3_API.CreateColorFromHexString -> rgb
			--        conversion nonsense.
			frame.CustomLeftColor.onSelection = function(r, g, b)
				psychoStructure.LC = r and TRP3_API.CreateColorFromBytes(r, g, b):GetRGBTable();
				refreshPsychoColor(frame, "LC", r and TRP3_API.CreateColorFromBytes(r, g, b));
			end

			frame.CustomRightColor.onSelection = function(r, g, b)
				psychoStructure.RC = r and TRP3_API.CreateColorFromBytes(r, g, b):GetRGBTable();
				refreshPsychoColor(frame, "RC", r and TRP3_API.CreateColorFromBytes(r, g, b));
			end

			-- Register the drag/drop handlers for reordering. Use the
			-- icon as our handle, and make it control this frame.
			setInfoReorderable(frame.DragButton, frame, "psycho", TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle, TRP3_RegisterCharact_Edit_PsychoAdd);

			tinsert(psychoEditCharFrame, frame);
		end

		frame.ActionButton:SetScript("OnMouseDown", function(self)
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				-- If not custom, allow convert to custom.
				if psychoStructure.ID then
					description:CreateButton(loc.REG_PLAYER_CONVERT, onPsychoConvert, self);
				end
				description:CreateButton(loc.CM_DUPLICATE, onPsychoDuplicate, self);
				description:CreateButton("|cnRED_FONT_COLOR:" .. loc.CM_REMOVE .. "|r", onPsychoDelete, self);
			end);
		end);

		frame.CustomLeftIcon:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				showIconBrowser(function(icon)
					psychoStructure.LI = icon;
					setupIconButton(self, icon or TRP3_InterfaceIcons.Default);
				end, psychoStructure.LI);
			elseif button == "RightButton" then
				local icon = psychoStructure.LI or TRP3_InterfaceIcons.Default;
				TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
					description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
					description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
					description:CreateButton(loc.UI_ICON_PASTE, function() pasteCopiedIcon(frame.CustomLeftIcon, "psychoLeft", psychoStructure); end);
				end);
			end
		end);

		frame.CustomRightIcon:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				showIconBrowser(function(icon)
					psychoStructure.RI = icon;
					setupIconButton(self, icon or TRP3_InterfaceIcons.Default);
				end, psychoStructure.RI);
			elseif button == "RightButton" then
				local icon = psychoStructure.RI or TRP3_InterfaceIcons.Default;
				TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
					description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
					description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
					description:CreateButton(loc.UI_ICON_PASTE, function() pasteCopiedIcon(frame.CustomRightIcon, "psychoRight", psychoStructure); end);
				end);
			end
		end);

		-- Run through all the child elements. If they've got a hide set flag
		-- that corresponds to our structure type (preset or custom), then
		-- update the visibility accordingly.
		--
		-- The XML UI definition includes these fields where appropriate.
		updatePsychoLineEditorFieldVisibility(psychoStructure.ID, frame:GetChildren());
		updatePsychoLineEditorFieldVisibility(psychoStructure.ID, frame:GetRegions());

		if psychoStructure.ID then
			local preset = PSYCHO_PRESETS[psychoStructure.ID] or PSYCHO_PRESETS_UNKOWN;
			frame.LeftText:SetText(preset.LT or "");
			frame.RightText:SetText(preset.RT or "");

			frame.LeftIcon:SetIconTexture(preset.LI);
			frame.RightIcon:SetIconTexture(preset.RI);
		else
			frame.CustomLeftField:SetText(psychoStructure.LT or "");
			frame.CustomRightField:SetText(psychoStructure.RT or "");

			frame.CustomLeftIcon.IC = psychoStructure.LI or TRP3_InterfaceIcons.Default;
			frame.CustomRightIcon.IC = psychoStructure.RI or TRP3_InterfaceIcons.Default;

			refreshEditIcon(frame.CustomLeftIcon);
			refreshEditIcon(frame.CustomRightIcon);
		end

		-- Update the color swatches and the bars. Calling setColor seems to
		-- invoke onSelected anyway, which means we'll update the bars through
		-- that handler.
		if psychoStructure.LC then
			frame.CustomLeftColor.setColor(TRP3_API.CreateColorFromTable(psychoStructure.LC):GetRGBAsBytes());
		else
			frame.CustomLeftColor.setColor(nil);
		end

		if psychoStructure.RC then
			frame.CustomRightColor.setColor(TRP3_API.CreateColorFromTable(psychoStructure.RC):GetRGBAsBytes());
		else
			frame.CustomRightColor.setColor(nil);
		end

		frame.frameIndex = frameIndex;
		frame:SetLeftColor(psychoStructure.LC and TRP3_API.CreateColorFromTable(psychoStructure.LC) or TRP3_API.MiscColors.PersonalityTraitColorLeft);
		frame:SetRightColor(psychoStructure.RC and TRP3_API.CreateColorFromTable(psychoStructure.RC) or TRP3_API.MiscColors.PersonalityTraitColorRight);
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		refreshPsycho(frame, value);
		frame:Show();
		previous = frame;
	end
	TRP3_RegisterCharact_Edit_PsychoAdd:ClearAllPoints();
	TRP3_RegisterCharact_Edit_PsychoAdd:SetPoint("TOP", previous, "BOTTOM", 0, -5);
end

local function setupRelationButton(profileID, profile)
	setupIconButton(TRP3_RegisterCharact_ActionButton, getRelationTexture(profileID));
	local relationColoredName = getRelationText(profileID);
	local relationColor = TRP3_API.register.relation.getRelationColor(profileID);
	if relationColor then
		relationColoredName = relationColor:WrapTextInColorCode(relationColoredName);
	end
	setTooltipAll(TRP3_RegisterCharact_ActionButton, "RIGHT", 0, 5, loc.CM_ACTIONS, loc.REG_RELATION_BUTTON_TT:format(relationColoredName, getRelationTooltipText(profileID, profile)));
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

	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getCurrentContext().profileID, "characteristics");
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
	ConsultFramePools:ReleaseAll();

	-- IsSelf ?
	TRP3_RegisterCharact_NamePanel_EditButton:Hide();
	TRP3_ProfileReportButton:Hide()
	if context.isPlayer then
		TRP3_RegisterCharact_NamePanel_EditButton:Show();
	else
		assert(context.profileID, "No profileID in context");
		TRP3_RegisterCharact_ActionButton:Show();
		setupRelationButton(context.profileID, context.profile);
		if context.profile and context.profile.link then
			TRP3_ProfileReportButton:Show()
		end
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

local function onActionSelected(value)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");
	assert(context.profileID, "No profileID in context");

	if value == 1 then
		local profil = getProfile(context.profileID);
		showConfirmPopup(loc.REG_DELETE_WARNING:format(Utils.str.color("g") .. getCompleteName(profil.characteristics or {}, UNKNOWN, true) .. "|r"),
			function()
				deleteProfile(context.profileID);
			end);
	elseif value == 2 then
		showTextInputPopup(loc.REG_PLAYER_IGNORE_WARNING:format(strjoin("\n", unpack(GetKeysArray(context.profile.link)))), function(text)
			for unitID, _ in pairs(context.profile.link) do
				ignoreID(unitID, text);
			end
			toast(loc.REG_IGNORE_TOAST, 2);
		end);
	elseif type(value) == "string" then
		setRelation(context.profileID, value);
		setupRelationButton(context.profileID, context.profile);
		TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, nil, context.profileID, "characteristics");
	end
end

local function onActionClicked(button)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");

	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		if context.profile.link and TableHasAnyEntries(context.profile.link) then
			description:CreateButton(loc.REG_PLAYER_IGNORE:format(CountTable(context.profile.link)), onActionSelected, 2);
		end
		local relations = getRelationList(true);
		local relationValues = description:CreateButton(loc.REG_RELATION);
		for _, relation in ipairs(relations) do
			relationValues:CreateButton(relation.name or loc["REG_RELATION_"..relation.id], onActionSelected, relation.id);
		end
		description:CreateDivider();
		description:CreateButton("|cnRED_FONT_COLOR:" .. loc.PR_DELETE_PROFILE .. "|r", onActionSelected, 1);
	end);
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
	PlaySound(TRP3_InterfaceSounds.ButtonClick);
end

local function onSave()
	saveCharacteristics();
	showCharacteristicsTab();
end

local function onRelationshipStatusSelection(choice)
	draftData.RS = choice;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHARACTERISTICS - INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function initStructures()
	PSYCHO_PRESETS_UNKOWN = {
		LT = loc.CM_UNKNOWN,
		RT = loc.CM_UNKNOWN,
		LI = TRP3_InterfaceIcons.Default,
		RI = TRP3_InterfaceIcons.Default,
	};

	PSYCHO_PRESETS = {
		{
			LT = loc.REG_PLAYER_PSYCHO_CHAOTIC,
			RT = loc.REG_PLAYER_PSYCHO_LAWFUL,
			LI = TRP3_InterfaceIcons.TraitChaotic,
			RI = TRP3_InterfaceIcons.TraitLawful,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_CHASTE,
			RT = loc.REG_PLAYER_PSYCHO_LUSTFUL,
			LI = TRP3_InterfaceIcons.TraitChaste,
			RI = TRP3_InterfaceIcons.TraitLustful,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_FORGIVING,
			RT = loc.REG_PLAYER_PSYCHO_VINDICTIVE,
			LI = TRP3_InterfaceIcons.TraitForgiving,
			RI = TRP3_InterfaceIcons.TraitVindictive,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_ALTRUISTIC,
			RT = loc.REG_PLAYER_PSYCHO_SELFISH,
			LI = TRP3_InterfaceIcons.TraitAltruistic,
			RI = TRP3_InterfaceIcons.TraitSelfish,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_TRUTHFUL,
			RT = loc.REG_PLAYER_PSYCHO_DECEITFUL,
			LI = TRP3_InterfaceIcons.TraitTruthful,
			RI = TRP3_InterfaceIcons.TraitDeceitful,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_GENTLE,
			RT = loc.REG_PLAYER_PSYCHO_BRUTAL,
			LI = TRP3_InterfaceIcons.TraitGentle,
			RI = TRP3_InterfaceIcons.TraitBrutal,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_SUPERSTITIOUS,
			RT = loc.REG_PLAYER_PSYCHO_RATIONAL,
			LI = TRP3_InterfaceIcons.TraitSuperstitious,
			RI = TRP3_InterfaceIcons.TraitRational,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_RENEGADE,
			RT = loc.REG_PLAYER_PSYCHO_PARAGON,
			LI = TRP3_InterfaceIcons.TraitRenegade,
			RI = TRP3_InterfaceIcons.TraitParagon,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_CAUTIOUS,
			RT = loc.REG_PLAYER_PSYCHO_IMPULSIVE,
			LI = TRP3_InterfaceIcons.TraitCautious,
			RI = TRP3_InterfaceIcons.TraitImpulsive,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_ASCETIC,
			RT = loc.REG_PLAYER_PSYCHO_BONVIVANT,
			LI = TRP3_InterfaceIcons.TraitAscetic,
			RI = TRP3_InterfaceIcons.TraitBonVivant,
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_VALOROUS,
			RT = loc.REG_PLAYER_PSYCHO_SPINELESS,
			LI = TRP3_InterfaceIcons.TraitValorous,
			RI = TRP3_InterfaceIcons.TraitSpineless,
		},
	};

	PSYCHO_PRESETS_DROPDOWN = {
		{ loc.REG_PLAYER_PSYCHO_SOCIAL },
		{ loc.REG_PLAYER_PSYCHO_CHAOTIC .. " - " .. loc.REG_PLAYER_PSYCHO_LAWFUL, 1 },
		{ loc.REG_PLAYER_PSYCHO_FORGIVING .. " - " .. loc.REG_PLAYER_PSYCHO_VINDICTIVE, 3 },
		{ loc.REG_PLAYER_PSYCHO_ALTRUISTIC .. " - " .. loc.REG_PLAYER_PSYCHO_SELFISH, 4 },
		{ loc.REG_PLAYER_PSYCHO_TRUTHFUL .. " - " .. loc.REG_PLAYER_PSYCHO_DECEITFUL, 5 },
		{ loc.REG_PLAYER_PSYCHO_GENTLE .. " - " .. loc.REG_PLAYER_PSYCHO_BRUTAL, 6 },
		{ loc.REG_PLAYER_PSYCHO_SUPERSTITIOUS .. " - " .. loc.REG_PLAYER_PSYCHO_RATIONAL, 7 },
		{ loc.REG_PLAYER_PSYCHO_PERSONAL },
		{ loc.REG_PLAYER_PSYCHO_RENEGADE .. " - " .. loc.REG_PLAYER_PSYCHO_PARAGON, 8 },
		{ loc.REG_PLAYER_PSYCHO_CAUTIOUS .. " - " .. loc.REG_PLAYER_PSYCHO_IMPULSIVE, 9 },
		{ loc.REG_PLAYER_PSYCHO_ASCETIC .. " - " .. loc.REG_PLAYER_PSYCHO_BONVIVANT, 10 },
		{ loc.REG_PLAYER_PSYCHO_VALOROUS .. " - " .. loc.REG_PLAYER_PSYCHO_SPINELESS, 11 },
		{ loc.REG_PLAYER_PSYCHO_CUSTOM },
		{ "|cnGREEN_FONT_COLOR:" .. loc.REG_PLAYER_PSYCHO_CREATENEW .. "|r", "new" },
	};

	RELATIONSHIP_STATUS_DROPDOWN = {
		{loc.CM_DO_NOT_SHOW, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN},
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_SINGLE, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.SINGLE},
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_TAKEN, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.TAKEN},
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_MARRIED, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.MARRIED},
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_DIVORCED, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.DIVORCED},
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_WIDOWED, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.WIDOWED},
	};
end

function TRP3_API.register.inits.characteristicsInit()
	initStructures();

	-- UI
	TRP3_RegisterCharact_Edit_MiscAdd:SetScript("OnClick", miscAddDropDown);
	TRP3_RegisterCharact_Edit_NamePanel_Icon:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			showIconBrowser(onPlayerIconSelected, draftData.IC);
		elseif button == "RightButton" then
			local icon = draftData.IC or TRP3_InterfaceIcons.ProfileDefault;
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
				description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
				description:CreateButton(loc.UI_ICON_PASTE, function() onPlayerIconSelected(TRP3_API.GetLastCopiedIcon()); end);
			end);
		end
	end);
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetScript("OnClick", showCharacteristicsTab);
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetScript("OnClick", onSave);
	TRP3_RegisterCharact_NamePanel_EditButton:SetScript("OnClick", onEdit);
	TRP3_RegisterCharact_ActionButton:SetScript("OnMouseDown", onActionClicked);
	TRP3_RegisterCharact_Edit_ResidenceButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	TRP3_RegisterCharact_Edit_ResidenceButton:SetScript("OnClick", function(_, button)
		if button == "LeftButton" then
			if AddOn_TotalRP3.Map.getPlayerCoordinates() then
				local x, y= AddOn_TotalRP3.Map.getPlayerCoordinates();
				local mapId = AddOn_TotalRP3.Map.getPlayerMapID()
				draftData.RC = { mapId, x, y };
				tinsert(draftData.RC, Utils.str.buildZoneText());
				TRP3_RegisterCharact_Edit_ResidenceField:SetText(buildZoneText());
			else
				draftData.RC = nil;
				TRP3_RegisterCharact_Edit_ResidenceField:SetText(buildZoneText());
			end
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

	TRP3_RegisterCharact_Edit_PsychoAdd:SetScript("OnClick", function(button)
		TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
			for _, preset in pairs(PSYCHO_PRESETS_DROPDOWN) do
				-- If there is no index or action, it is a title
				if not preset[2] then
					description:CreateTitle(preset[1]);
				else
					description:CreateButton(preset[1], psychoAdd, preset[2]);
				end
			end
		end);
	end);

	-- Localz
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_NamePanel_Icon, "RIGHT", 0, 5, loc.REG_PLAYER_ICON, loc.REG_PLAYER_ICON_TT
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_TitleFieldHelp, "RIGHT", 0, 5, loc.REG_TITLE, loc.REG_PLAYER_TITLE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_FirstFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_FIRSTNAME, loc.REG_PLAYER_FIRSTNAME_TT:format(Globals.player));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_LastFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_LASTNAME, loc.REG_PLAYER_LASTNAME_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_FullTitleFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_FULLTITLE, loc.REG_PLAYER_FULLTITLE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_RaceFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_RACE, loc.REG_PLAYER_RACE_TT:format(Globals.player_race_loc));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_CLASS, loc.REG_PLAYER_CLASS_TT:format(Globals.player_class_loc));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_AgeFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_AGE, loc.REG_PLAYER_AGE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_BIRTHPLACE, loc.REG_PLAYER_BIRTHPLACE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_RESIDENCE, loc.REG_PLAYER_RESIDENCE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_EYE, loc.REG_PLAYER_EYE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_HeightFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_HEIGHT, loc.REG_PLAYER_HEIGHT_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_WeightFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_WEIGHT, loc.REG_PLAYER_WEIGHT_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceButton, "RIGHT", 0, 5, loc.REG_PLAYER_HERE, loc.REG_PLAYER_HERE_TT
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_HERE_HOME_TT_CURRENT)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_HERE_HOME_TT_DISCARD));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeButton, "RIGHT", 0, 5, loc.REG_PLAYER_EYE, loc.REG_PLAYER_EYE_TT
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_COLOR_TT_SELECT)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_COLOR_TT_OPTIONS)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.REG_PLAYER_COLOR_TT_DEFAULTPICKER));
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassButton, "RIGHT", 0, 5, loc.REG_PLAYER_COLOR_CLASS, loc.REG_PLAYER_COLOR_CLASS_TT
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_COLOR_TT_SELECT)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_COLOR_TT_OPTIONS)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.REG_PLAYER_COLOR_TT_DEFAULTPICKER));

	TRP3_RegisterCharact_NamePanel:SetTitleText(loc.REG_PLAYER_NAMESTITLES);
	TRP3_RegisterCharact_Edit_NamePanel:SetTitleText(loc.REG_PLAYER_NAMESTITLES);
	TRP3_RegisterCharact_CharactPanel:SetTitleText(loc.REG_PLAYER_CHARACTERISTICS);
	TRP3_RegisterCharact_Edit_CharactPanel:SetTitleText(loc.REG_PLAYER_CHARACTERISTICS);

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

	TRP3_RegisterCharact_CharactPanel_Empty:SetText(loc.REG_PLAYER_NO_CHAR);
	TRP3_RegisterCharact_Edit_MiscAdd:SetText(loc.REG_PLAYER_MISC_ADD);
	TRP3_RegisterCharact_Edit_PsychoAdd:SetText(loc.REG_PLAYER_PSYCHO_ADD);
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetText(loc.CM_CANCEL);
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetText(loc.CM_SAVE);
	TRP3_RegisterCharact_Edit_TitleFieldText:SetText(loc.REG_TITLE);
	TRP3_RegisterCharact_Edit_FirstFieldText:SetText(loc.REG_PLAYER_FIRSTNAME);
	TRP3_RegisterCharact_Edit_LastFieldText:SetText(loc.REG_PLAYER_LASTNAME);
	TRP3_RegisterCharact_Edit_FullTitleFieldText:SetText(loc.REG_PLAYER_FULLTITLE);

	TRP3_RegisterCharact_CharactPanel_Container.RegisterTitle:SetText(loc.REG_PLAYER_REGISTER);
	TRP3_RegisterCharact_CharactPanel_Container.RegisterTitle:SetIconTexture(TRP3_InterfaceIcons.DirectorySection);
	TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:SetText(loc.REG_PLAYER_MORE_INFO);
	TRP3_RegisterCharact_CharactPanel_Container.MiscTitle:SetIconTexture(TRP3_InterfaceIcons.MiscInfoSection);
	TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:SetText(loc.REG_PLAYER_PSYCHO);
	TRP3_RegisterCharact_CharactPanel_Container.TraitsTitle:SetIconTexture(TRP3_InterfaceIcons.TraitSection);

	TRP3_RegisterCharact_Edit_CharactPanel_Container.RegisterTitle:SetText(loc.REG_PLAYER_REGISTER);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.RegisterTitle:SetIconTexture(TRP3_InterfaceIcons.DirectorySection);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.MiscTitle:SetText(loc.REG_PLAYER_MORE_INFO);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.MiscTitle:SetIconTexture(TRP3_InterfaceIcons.MiscInfoSection);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:SetText(loc.REG_PLAYER_PSYCHO);
	TRP3_RegisterCharact_Edit_CharactPanel_Container.TraitsTitle:SetIconTexture(TRP3_InterfaceIcons.TraitSection);

	TRP3_RegisterCharact_Edit_RaceFieldText:SetText(loc.REG_PLAYER_RACE);
	TRP3_RegisterCharact_Edit_ClassFieldText:SetText(loc.REG_PLAYER_CLASS);
	TRP3_RegisterCharact_Edit_AgeFieldText:SetText(loc.REG_PLAYER_AGE);
	TRP3_RegisterCharact_Edit_EyeFieldText:SetText(loc.REG_PLAYER_EYE);
	TRP3_RegisterCharact_Edit_HeightFieldText:SetText(loc.REG_PLAYER_HEIGHT);
	TRP3_RegisterCharact_Edit_WeightFieldText:SetText(loc.REG_PLAYER_WEIGHT);
	TRP3_RegisterCharact_Edit_ResidenceFieldText:SetText(loc.REG_PLAYER_RESIDENCE);
	TRP3_RegisterCharact_Edit_BirthplaceFieldText:SetText(loc.REG_PLAYER_BIRTHPLACE);

	setupListBox(TRP3_RegisterCharact_Dropdown_RelationshipField, RELATIONSHIP_STATUS_DROPDOWN, onRelationshipStatusSelection, loc.CM_DO_NOT_SHOW, 200, false);
	Ellyb.Tooltips.getTooltip(TRP3_RegisterCharact_Dropdown_RelationshipField)
		:SetTitle(loc.REG_PLAYER_RELATIONSHIP_STATUS)
		:AddLine(loc.REG_PLAYER_RELATIONSHIP_STATUS_TT);
	TRP3_RegisterCharact_Dropdown_RelationshipFieldTitle:SetText(loc.REG_PLAYER_RELATIONSHIP_STATUS);

	-- Resizing
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.NAVIGATION_RESIZED, function(_, containerWidth)
		local finalContainerWidth = containerWidth - 70;
		TRP3_RegisterCharact_CharactPanel_Container:SetSize(finalContainerWidth, 50);
		TRP3_RegisterCharact_Edit_CharactPanel_Container:SetSize(finalContainerWidth, 50);
		for _, frame in pairs(miscEditCharFrame) do
			scaleField(frame, finalContainerWidth, "NameField");
		end
		TRP3_RegisterCharact_Edit_FirstField:SetSize((finalContainerWidth - 100) * 0.3, 18);
	end);

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.REGISTER_PROFILE_OPENED, function()
		TRP3_RegisterCharact_CharactPanel_Scroll.ScrollBar:ScrollToBegin();
		TRP3_RegisterCharact_Edit_CharactPanel_Scroll.ScrollBar:ScrollToBegin();
	end);
end
