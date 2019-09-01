----------------------------------------------------------------------------------
--- Total RP 3
--- Character page : Characteristics
------------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

-- imports
local ipairs = ipairs;
local Globals, Utils, Events, UI, Ellyb = TRP3_API.globals, TRP3_API.utils, TRP3_API.events, TRP3_API.ui, TRP3_API.Ellyb;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_API.profile.getData;
local getProfile = TRP3_API.register.getProfile;
local tcopy, tsize = Utils.table.copy, Utils.table.size;
local numberToHexa, hexaToNumber = Utils.color.numberToHexa, Utils.color.hexaToNumber;
local loc = TRP3_API.loc;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local assert, type, wipe, strconcat, pairs, tinsert, tremove, _G, strtrim = assert, type, wipe, strconcat, pairs, tinsert, tremove, _G, strtrim;
local strjoin, unpack, getKeys = strjoin, unpack, Utils.table.keys;
local getTiledBackground = TRP3_API.ui.frame.getTiledBackground;
local setupDropDownMenu = TRP3_API.ui.listbox.setupDropDownMenu;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getPlayerCurrentProfile = TRP3_API.profile.getPlayerCurrentProfile;
local getRelationTexture = TRP3_API.register.relation.getRelationTexture;
local RELATIONS = TRP3_API.register.relation;
local getRelationText, getRelationTooltipText, setRelation = RELATIONS.getRelationText, RELATIONS.getRelationTooltipText, RELATIONS.setRelation;
local CreateFrame = CreateFrame;
local TRP3_RegisterCharact_CharactPanel_Empty = TRP3_RegisterCharact_CharactPanel_Empty;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local showConfirmPopup, showTextInputPopup = TRP3_API.popup.showConfirmPopup, TRP3_API.popup.showTextInputPopup;
local showAlertPopup = TRP3_API.popup.showAlertPopup;
local deleteProfile = TRP3_API.register.deleteProfile;
local ignoreID = TRP3_API.register.ignoreID;
local buildZoneText = Utils.str.buildZoneText;
local setupEditBoxesNavigation = TRP3_API.ui.frame.setupEditBoxesNavigation;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local is_classic = TRP3_API.globals.is_classic;

local showIconBrowser = function(callback)
	TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {callback});
end;

local PSYCHO_PRESETS_UNKOWN;
local PSYCHO_PRESETS;
local PSYCHO_PRESETS_DROPDOWN;

local RELATIONSHIP_STATUS_DROPDOWN;

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

function TRP3_API.register.player.getCharacteristicsExchangeData()
	return get("player/characteristics");
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
	RE = "REG_PLAYER_RESIDENCE",
	RS = "REG_PLAYER_RELATIONSHIP_STATUS"
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

local function getPsychoStructureValue(psychoStructure)
	-- If this structure has a V2 field already then yield that, otherwise
	-- upscale the VA field.
	if psychoStructure.V2 then
		return psychoStructure.V2;
	elseif psychoStructure.VA then
		local scale = Globals.PSYCHO_MAX_VALUE_V2 / Globals.PSYCHO_MAX_VALUE_V1;
		return math.floor((psychoStructure.VA * scale) + 0.5);
	end

	-- In really broken cases we'll return the default.
	return Globals.PSYCHO_DEFAULT_VALUE_V2;
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
--
--  @param psychoLine The line item to update.
--  @param psychoColorField The color field being updated. Either LC or RC.
--  @param color The color to be applied. Must be an instance of Ellyb.Color,
--               or nil if resetting the color to a default.
local function refreshPsychoColor(psychoLine, psychoColorField, color)
	-- Store the coloring on the line item itself for persistence later.
	if color then
		psychoLine[psychoColorField] = color;
	else
		psychoLine[psychoColorField] = nil;
	end

	-- Grab the now-updated color objects for both ends and update the UI.
	local lc = psychoLine.LC or Globals.PSYCHO_DEFAULT_LEFT_COLOR;
	local rc = psychoLine.RC or Globals.PSYCHO_DEFAULT_RIGHT_COLOR;

	if psychoLine.Bar then
		psychoLine.Bar:SetStatusBarColor(lc:GetRGBA());
		psychoLine.Bar.OppositeFill:SetVertexColor(rc:GetRGBA());
	end
end

local function setBkg(backgroundIndex)
	local backdrop = TRP3_RegisterCharact_CharactPanel:GetBackdrop();
	backdrop.bgFile = getTiledBackground(backgroundIndex);
	TRP3_RegisterCharact_CharactPanel:SetBackdrop(backdrop);
end

local CHAR_KEYS = { "RA", "CL", "AG", "EC", "HE", "WE", "BP", "RE", "RS" };
local FIELD_TITLE_SCALE = 0.3;

local function scaleField(field, containerSize, fieldName)
	_G[field:GetName() .. (fieldName or "FieldName")]:SetSize(containerSize * FIELD_TITLE_SCALE, 18);
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
				:SetTitle(loc.REG_PLAYER_RESIDENCE, Ellyb.ColorManager.ORANGE)
				:ClearLines()
				:AddLine(displayData.tooltip)
	end
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
		_G[frame:GetName() .. "FieldName"]:SetText(loc:GetText(registerCharLocals[charName]));
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
			setTooltipForSameFrame(TRP3_RegisterCharact_CharactPanel_ResidenceButton, "RIGHT", 0, 5, loc.REG_PLAYER_RESIDENCE_SHOW, loc.REG_PLAYER_RESIDENCE_SHOW_TT:format(dataTab.RC[4]));
			TRP3_RegisterCharact_CharactPanel_ResidenceButton:SetScript("OnClick", function()
				OpenWorldMap(dataTab.RC[1])
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

			setTooltipForSameFrame(TRP3_RegisterCharact_CharactPanel_ResidenceButton, "RIGHT", 0, 5,
				loc.REG_PLAYER_RESIDENCE_SHOW, Ellyb.ColorManager.GREEN(dataTab.RC[4]));
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

		for frameIndex, miscStructure in ipairs(dataTab.MI) do
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
		previous = TRP3_RegisterCharact_CharactPanel_PsychoTitle;

		for frameIndex, psychoStructure in ipairs(dataTab.PS) do
			local frame = psychoCharFrame[frameIndex];
			local value = getPsychoStructureValue(psychoStructure);
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
			frame.LeftText:SetText(psychoStructure.LT or "");
			frame.RightText:SetText(psychoStructure.RT or "");

			frame.LeftIcon:SetTexture("Interface\\ICONS\\" .. (psychoStructure.LI or Globals.icons.default));
			frame.RightIcon:SetTexture("Interface\\ICONS\\" .. (psychoStructure.RI or Globals.icons.default));

			frame.Bar:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);

			refreshPsycho(frame, value);
			refreshPsychoColor(frame, "LC", psychoStructure.LC and Ellyb.Color(psychoStructure.LC));
			refreshPsychoColor(frame, "RC", psychoStructure.RC and Ellyb.Color(psychoStructure.RC));
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

	if sanitizeCharacteristics(draftData) then
		-- Yell at the user about their mischieves
		showAlertPopup(loc.REG_CODE_INSERTION_WARNING);
	end

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
				psychoStructure.LC = lc:GetRGBTable();
			end

			local rc = psychoLine.RC;
			if rc then
				psychoStructure.RC = rc:GetRGBTable();
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

		-- We'll also update the VA field so that changes made in newer versions
		-- can, to some degree, be shown to older clients.
		--
		-- Floating point numbers get rounded to nearest integers.
		local downscale = Globals.PSYCHO_MAX_VALUE_V1 / Globals.PSYCHO_MAX_VALUE_V2;
		psychoStructure.VA = math.floor((psychoStructure.V2 * downscale) + 0.5);
	end
	-- Save Misc
	for index, miscStructure in pairs(draftData.MI) do
		miscStructure.VA = stEtN(_G[miscEditCharFrame[index]:GetName() .. "ValueField"]:GetText()) or loc.CM_VALUE;
		miscStructure.NA = stEtN(_G[miscEditCharFrame[index]:GetName() .. "NameField"]:GetText()) or loc.CM_NAME;
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

local function onPsychoValueChanged(frame, value)
	refreshPsycho(frame:GetParent(), math.max(math.min(value, Globals.PSYCHO_MAX_VALUE_V2), 0));
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
		NA = loc.REG_PLAYER_MSP_HOUSE,
		VA = "",
		IC = is_classic and "INV_Jewelry_Ring_36" or "inv_misc_kingsring1"
	},
	{
		NA = loc.REG_PLAYER_MSP_NICK,
		VA = "",
		IC = "Ability_Hunter_BeastCall"
	},
	{
		NA = loc.REG_PLAYER_MSP_MOTTO,
		VA = "",
		IC = is_classic and "INV_Scroll_01" or "INV_Inscription_ScrollOfWisdom_01"
	},
	{
		NA = loc.REG_PLAYER_TRP2_TRAITS,
		VA = "",
		IC = "spell_shadow_mindsteal"
	},
	{
		NA = loc.REG_PLAYER_TRP2_PIERCING,
		VA = "",
		IC = "inv_jewelry_ring_14"
	},
	{
		NA = loc.REG_PLAYER_TRP2_TATTOO,
		VA = "",
		IC = is_classic and "INV_Potion_65" or "INV_Inscription_inkblack01"
	},
	{
		list = "|cff00ff00" .. loc.REG_PLAYER_ADD_NEW,
		NA = loc.CM_NAME,
		VA = loc.CM_VALUE,
		IC = "INV_Misc_QuestionMark"
	},
}

local function miscAddDropDownSelection(index)
	local preset = MISC_PRESET[index];
	miscAdd(preset.NA, preset.VA, preset.IC);
end

local function miscAddDropDown()
	local values = {};
	tinsert(values, { loc.REG_PLAYER_MISC_ADD });
	for index, preset in pairs(MISC_PRESET) do
		tinsert(values, { preset.list or preset.NA, index });
	end
	displayDropDown(TRP3_RegisterCharact_Edit_MiscAdd, values, miscAddDropDownSelection, 0, true);
end

local function psychoAdd(presetID)
	saveInDraft();
	if presetID == "new" then
		tinsert(draftData.PS, {
			LT = loc.REG_PLAYER_LEFTTRAIT,
			LI = "INV_Misc_QuestionMark",
			RT = loc.REG_PLAYER_RIGHTTRAIT,
			RI = "INV_Misc_QuestionMark",
			VA = Globals.PSYCHO_DEFAULT_VALUE_V1,
			V2 = Globals.PSYCHO_DEFAULT_VALUE_V2,
		});
	else
		tinsert(draftData.PS, {
			ID = presetID,
			VA = Globals.PSYCHO_DEFAULT_VALUE_V1,
			V2 = Globals.PSYCHO_DEFAULT_VALUE_V2,
		});
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
	local houseTT = loc.REG_PLAYER_HERE_HOME_TT;
	if draftData.RC and #draftData.RC == 4 then
		houseTT = loc.REG_PLAYER_HERE_HOME_PRE_TT:format(draftData.RC[4]) .. "\n\n" .. houseTT;
	end
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ResidenceButton, "RIGHT", 0, 5, loc.REG_PLAYER_HERE, houseTT);
	TRP3_RegisterCharact_Edit_ResidenceButton:Hide();
	TRP3_RegisterCharact_Edit_ResidenceButton:Show(); -- Hax to refresh tooltip
end

--- MISC_INFO_DRAG_UPDATE_PERIOD is the rate at which we'll test other
--  Misc. items in the list to update their positions in a drag/drop reorder
--  operation.
local MISC_INFO_DRAG_UPDATE_PERIOD = 0.01;

--- MISC_INFO_DRAG_SCROLL_DELTA is the amount of pixels to scroll by when
--  the cursor is outside of the scroll frame.
--
--  Increasing this gives you a faster scroll, but be mindful - it gets
--  re-checked every time the update period elapses.
local MISC_INFO_DRAG_SCROLL_DELTA = 1;

--- miscInfoTestRectangleCoord takes a bounding rectangle of a widget in
--  (x1, y1)(x2, y2) coordinate pairs, and a (cx, cy) coordinate pair, and
--  tests if the bounding rectangle contains the point or not.
--
--  If the point is within the rectangle, 0 is returned. If the point is
--  above, -1 is returned, and if the point is below then 1 is returned.
--
--  If the point is not within the X coordinate boundaries, nil is returned.
--
--  The parameters assume that the coordinates passed match the convention
--  used by the API, such that (0, 0) represents the bottom-left of the screen.
--
--  @param x1 Bottom-left corner X coordinate of the rectangle.
--  @param y1 Bottom-left corner Y coordinate of the rectangle.
--  @param x2 Top-right corner X coordinate of the rectangle.
--  @param y2 Top-right corner Y coordinate of the rectangle.
--  @param cx X coordinate to test.
--  @param cy Y coordinate to test.
local function miscInfoTestRectangleCoord(x1, y1, x2, y2, cx, cy)
	-- Skip if the given coords aren't within the width of the rectangle.
	if cx < x1 or cx > x2 then
		return;
	end

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

--- miscInfoQueryCursorIndexPosition calculates out the index of which item
--  in the character info sheet list that the mouse is presently located over.
--
--  If the mouse is not over any item, nil is returned. If the mouse is within
--  the X coordinate boundaries of the first or last items but above or below
--  the first or last items in the list, the indices of those items are
--  returned respectively.
local function miscInfoQueryCursorIndexPosition()
	-- Grab the cursor position early on, since we don't need to keep
	-- asking for it in one update.
	local mouseX, mouseY = GetCursorPosition();

	-- We need to know the total number of characteristics for a bit later.
	local lastItemIndex = 0;
	for frameIndex, _ in pairs(draftData.MI) do
		if frameIndex > lastItemIndex then
			lastItemIndex = frameIndex;
		end
	end

	-- Iterate over each of the misc info items and process them in turn.
	for i = 1, lastItemIndex do
		local frame = miscEditCharFrame[i];

		-- We can work out the actual bounding coordinates now. The
		-- coords we'll get are the bottom and left of the frame, and as
		-- the width and height are always positive we can just add them
		-- to get the other corners.
		--
		-- The (x1, y1) point refers to the bottom-left corner, as is standard
		-- with the API.
		local left, bottom, width, height = frame:GetRect();
		local x1, y1 = left, bottom;
		local x2, y2 = left + width, bottom + height;

		-- Now grab our mouse position and fix it according to the scale
		-- of the target frame.
		local frameScale = frame:GetEffectiveScale();
		local mx, my = mouseX / frameScale, mouseY / frameScale;

		-- So, why not use IsMouseOver to test if this node is of any interest?
		-- Because you've got the problem of the first and last items. If you
		-- drag your cursor above or below them you'd expect the one you're
		-- moving to go to the first or last position.
		--
		-- So we'll roll our own bounds checker that tells us if you're
		-- on an item, or above/below one.
		local relativeMousePosition = miscInfoTestRectangleCoord(x1, y1, x2, y2, mx, my);
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

--- miscInfoScrollParentTowardCursor updates the vertical scroll position of
--  the edit character panel, adjusting it so that the position is moving
--  toward the location of the cursor.
local function miscInfoScrollParentTowardCursor()
	-- Get the scroll frame and query its current position.
	local frame = TRP3_RegisterCharact_Edit_CharactPanel_Scroll;

	-- Work out our mouse position, calculate to effective scale of the frame.
	local mx, my = GetCursorPosition();
	local scale = frame:GetEffectiveScale();
	mx, my = mx / scale, my / scale;

	-- Only adjust positioning if the mouse is outside of the frame bounds
	-- from a vertical perspective.
	local x1, y1, width, height = frame:GetRect();
	local x2, y2 = x1 + width, y1 + height;
	local relativeMousePosition = miscInfoTestRectangleCoord(x1, y1, x2, y2, mx, my);
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
		position = position - MISC_INFO_DRAG_SCROLL_DELTA;
	else
		position = position + MISC_INFO_DRAG_SCROLL_DELTA;
	end

	frame:SetVerticalScroll(position);
end

--- miscInfoFixupPosition adjusts the points on a given frame, altering
--  the TOP anchor point such that it is made relative to a different
--  frame.
--
--  This operation preserves all other points, as well as the offsets of the
--  TOP point.
--
--  @param frame The frame to alter the TOP point on.
--  @param relative The frame to make the TOP point relative to.
local function miscInfoFixupPosition(frame, relative)
	-- We could abstract the positioning into a separate function but
	-- in this case it should happen infrequently enough.
	--
	-- Check the anchor points of the frame and find the TOP point anchor.
	-- When we do, we'll re-assign that point to the given relative frame
	-- and preserve all the other attributes.
	for i = 1, frame:GetNumPoints() do
		local point, _, relPoint, x, y = frame:GetPoint(i);
		if point == "TOP" and relPoint == "BOTTOM" then
			frame:SetPoint(point, relative, relPoint, x, y);
			return;
		end
	end
end

--- miscInfoPerformReorder reorders the character frame info list, moving
--  the item at a given source index to that of a target index, and updating
--  the layout of the UI.
--
--  @param sourceIndex The index of the node being moved.
--  @param targetIndex The index to place the node at.
local function miscInfoPerformReorder(sourceIndex, targetIndex)
	-- We'll just do a flat table order change here with a tinsert/tremove.
	local source = table.remove(draftData.MI, sourceIndex);
	table.insert(draftData.MI, targetIndex, source);

	-- Reorder the frame too. Means we don't need to transfer all the values,
	-- which fixes issues with icons not persisting correctly when reordering.
	local sourceFrame = table.remove(miscEditCharFrame, sourceIndex);
	table.insert(miscEditCharFrame, targetIndex, sourceFrame);

	-- Now fix up all the frames in terms of their referenced indices.
	local previous = TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle;
	for frameIndex, _ in pairs(draftData.MI) do
		local frame = miscEditCharFrame[frameIndex];
		frame.miscIndex = frameIndex;

		miscInfoFixupPosition(frame, previous);
		previous = frame;
	end

	-- The add characteristic button needs to be moved to the last item.
	miscInfoFixupPosition(TRP3_RegisterCharact_Edit_MiscAdd, previous);
end

--- onMiscInfoDragUpdate is called when the timer associated with a handle
--  drag ticks. This is responsible for checking the position of the
--  mouse relative to items in the list.
--
--  @param ticker The ticker associated with the handle being dragged.
local function onMiscInfoDragUpdate(ticker)
	-- Ensure the scroll frame moves with the cursor.
	miscInfoScrollParentTowardCursor();

	-- Grab the handle when we tick and, from that, we can get the source
	-- node.
	local handle = ticker.handle;
	local source = handle.node;

	-- Work out the index of the frame to swap with, if any. Skip if the
	-- source and target are identical, or if there is no target.
	local targetIndex = miscInfoQueryCursorIndexPosition();
	if not targetIndex or targetIndex == source.miscIndex then
		return;
	end

	miscInfoPerformReorder(source.miscIndex, targetIndex);
end

--- onMiscInfoDragStop is called when a handle begins being dragged.
--  This is responsible for starting a ticker to control the reorder operation.
--
--  @param handle The handle being dragged by the user.
local function onMiscInfoDragStart(handle)
	-- In theory it'll be impossible to have a ticker (you'd need this
	-- handler to be called twice), but let's be safe. Would rather not
	-- assert since there's no real harm otherwise.
	if handle.miscInfoTicker then
		handle.miscInfoTicker:Cancel();
	end

	-- Keep a reference to the handle on the ticker that we create.
	local ticker = C_Timer.NewTicker(MISC_INFO_DRAG_UPDATE_PERIOD, onMiscInfoDragUpdate);
	ticker.handle = handle;
	handle.miscInfoTicker = ticker;

	-- Stick the icon of the item in question onto the cursor for some feedback.
	-- Also throw in some sound cues a-la spellbook drag/drop.
	local node = handle.node;
	SetCursor(node.Icon.Icon:GetTexture());

	-- For some reason there's no constant for the pickup sound effect
	-- used by ability icons. Logically this'd be present as
	-- IG_ABILITY_ICON_PICKUP.
	UI.misc.playUISound(837);
end

--- onMiscInfoDragStop is called when a handle is no longer being dragged.
--  This is responsible for stopping the drag/drop operation ticker.

--  @param handle The handle being dragged by the user.
local function onMiscInfoDragStop(handle)
	-- Expect a ticker. We won't assert since there's no harm in not having one.
	if not handle.miscInfoTicker then
		return;
	end

	-- Kill the ticker as we no longer need it.
	handle.miscInfoTicker:Cancel();
	handle.miscInfoTicker = nil;

	-- Kill the icon following the cursor.
	SetCursor(nil);
	UI.misc.playUISound(SOUNDKIT.IG_ABILITY_ICON_DROP);
end

--- setMiscInfoReorderable installs the necessary script handlers to enable
--  a handle frame to control the drag and drop operations of a given node
--  frame.
--
--  @param handle The frame that, when dragged, will start repositioning the
--                associated node.
--  @param node   The info item to be reordered when the handle is dragged.
local function setMiscInfoReorderable(handle, node)
	-- Store a reference to the node that we're controlling on the handle.
	-- The handle needs this when updating in the drag events.
	handle.node = node;

	-- This'll hold our drag/drop ticker so we can stop it later. The field
	-- is initialised here more for documentational purposes.
	handle.miscInfoTicker = nil;

	handle:EnableMouse(true);
	handle:RegisterForDrag("LeftButton");
	handle:SetScript("OnDragStart", onMiscInfoDragStart);
	handle:SetScript("OnDragStop", onMiscInfoDragStop);

	-- If the handle stops being shown we should kill the drag.
	handle:SetScript("OnHide", onMiscInfoDragStop);
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

	TRP3_RegisterCharact_Dropdown_RelationshipField:SetSelectedValue(draftData.RS or AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN)

	refreshDraftHouseCoordinates();

	-- Misc
	local previous = TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle;
	for _, frame in pairs(miscEditCharFrame) do frame:Hide(); end
	for frameIndex, miscStructure in pairs(draftData.MI) do
		local frame = miscEditCharFrame[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_MiscEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_MiscEditLine");
			_G[frame:GetName() .. "NameFieldText"]:SetText(loc.CM_NAME);
			_G[frame:GetName() .. "ValueFieldText"]:SetText(loc.CM_VALUE);
			_G[frame:GetName() .. "Delete"]:SetScript("OnClick", onMiscDelete);
			setTooltipForSameFrame(_G[frame:GetName() .. "Delete"], "TOP", 0, 5, loc.CM_REMOVE);
			scaleField(frame, TRP3_RegisterCharact_Edit_CharactPanel_Container:GetWidth(), "NameField");

			-- Register the drag/drop handlers for reordering. Use the
			-- icon as our handle, and make it control this frame.
			setMiscInfoReorderable(frame.Icon, frame);

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
		_G[frame:GetName() .. "NameField"]:SetText(miscStructure.NA or loc.CM_NAME);
		_G[frame:GetName() .. "ValueField"]:SetText(miscStructure.VA or loc.CM_VALUE);
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
		local value = getPsychoStructureValue(psychoStructure);

		if frame == nil then
			-- Create psycho attribute widget if not already exists
			frame = CreateFrame("Frame", "TRP3_RegisterCharact_PsychoEditLine" .. frameIndex, TRP3_RegisterCharact_Edit_CharactPanel_Container, "TRP3_RegisterCharact_PsychoInfoEditLine");
			frame.DeleteButton:SetScript("OnClick", onPsychoDelete);
			frame.CustomLeftField.title:SetText(loc.REG_PLAYER_LEFTTRAIT);
			frame.CustomRightField.title:SetText(loc.REG_PLAYER_RIGHTTRAIT);

			frame.LeftCount:Show();
			frame.RightCount:Show();

			frame.Bar:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);

			frame.Slider:SetMinMaxValues(0, Globals.PSYCHO_MAX_VALUE_V2);
			frame.Slider:SetScript("OnValueChanged", onPsychoValueChanged);

			setTooltipForSameFrame(frame.CustomLeftIcon, "TOP", 0, 5, loc.UI_ICON_SELECT, loc.REG_PLAYER_PSYCHO_LEFTICON_TT);
			setTooltipForSameFrame(frame.CustomRightIcon, "TOP", 0, 5, loc.UI_ICON_SELECT, loc.REG_PLAYER_PSYCHO_RIGHTICON_TT);
			setTooltipForSameFrame(frame.DeleteButton, "TOP", 0, 5, loc.CM_REMOVE);
			setTooltipForSameFrame(frame.CustomLeftColor, "TOP", 0, 5, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR_LEFT_TT);
			setTooltipForSameFrame(frame.CustomRightColor, "TOP", 0, 5, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR, loc.REG_PLAYER_PSYCHO_CUSTOMCOLOR_RIGHT_TT);

			-- Only need to set up the closure for color pickers once, as it
			-- just needs a reference to the frame itself.
			--
			-- FIXME: When the feature/color_picker_button_mixin branch
			--        lands we can drop these closures and swap to methods,
			--        as well as not worry about all the Ellyb.Color -> rgb
			--        conversion nonsense.
			frame.CustomLeftColor.onSelection = function(r, g, b)
				refreshPsychoColor(frame, "LC", r and Ellyb.Color.CreateFromRGBAAsBytes(r, g, b));
			end

			frame.CustomRightColor.onSelection = function(r, g, b)
				refreshPsychoColor(frame, "RC", r and Ellyb.Color.CreateFromRGBAAsBytes(r, g, b));
			end

			tinsert(psychoEditCharFrame, frame);
		end

		frame.CustomLeftIcon:SetScript("OnClick", function(self)
			showIconBrowser(function(icon)
				psychoStructure.LI = icon;
				setupIconButton(self, icon or Globals.icons.default);
			end);
		end);

		frame.CustomRightIcon:SetScript("OnClick", function(self)
			showIconBrowser(function(icon)
				psychoStructure.RI = icon;
				setupIconButton(self, icon or Globals.icons.default);
			end);
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

			frame.LeftIcon:SetTexture("Interface\\ICONS\\" .. (preset.LI or Globals.icons.default));
			frame.RightIcon:SetTexture("Interface\\ICONS\\" .. (preset.RI or Globals.icons.default));
		else
			frame.CustomLeftField:SetText(psychoStructure.LT or "");
			frame.CustomRightField:SetText(psychoStructure.RT or "");

			frame.CustomLeftIcon.IC = psychoStructure.LI or Globals.icons.default;
			frame.CustomRightIcon.IC = psychoStructure.RI or Globals.icons.default;

			refreshEditIcon(frame.CustomLeftIcon);
			refreshEditIcon(frame.CustomRightIcon);
		end

		-- Update the color swatches and the bars. Calling setColor seems to
		-- invoke onSelected anyway, which means we'll update the bars through
		-- that handler.
		if psychoStructure.LC then
			frame.CustomLeftColor.setColor(Ellyb.Color(psychoStructure.LC):GetRGBAsBytes());
		else
			frame.CustomLeftColor.setColor(nil);
		end

		if psychoStructure.RC then
			frame.CustomRightColor.setColor(Ellyb.Color(psychoStructure.RC):GetRGBAsBytes());
		else
			frame.CustomRightColor.setColor(nil);
		end

		frame.psychoIndex = frameIndex;
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
	setTooltipAll(TRP3_RegisterCharact_ActionButton, "LEFT", 0, 0, loc.CM_ACTIONS, loc.REG_RELATION_BUTTON_TT:format(getRelationText(profileID), getRelationTooltipText(profileID, profile)));
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
		showTextInputPopup(loc.REG_PLAYER_IGNORE_WARNING:format(strjoin("\n", unpack(getKeys(context.profile.link)))), function(text)
			for unitID, _ in pairs(context.profile.link) do
				ignoreID(unitID, text);
			end
			toast(loc.REG_IGNORE_TOAST, 2);
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
	tinsert(values, { loc.PR_DELETE_PROFILE, 1 });
	if context.profile.link and tsize(context.profile.link) > 0 then
		tinsert(values, { loc.REG_PLAYER_IGNORE:format(tsize(context.profile.link)), 2 });
	end
	tinsert(values, {
		loc.REG_RELATION,
		{
			{ loc.REG_RELATION_NONE, RELATIONS.NONE },
			{ loc.REG_RELATION_UNFRIENDLY, RELATIONS.UNFRIENDLY },
			{ loc.REG_RELATION_NEUTRAL, RELATIONS.NEUTRAL },
			{ loc.REG_RELATION_BUSINESS, RELATIONS.BUSINESS },
			{ loc.REG_RELATION_FRIEND, RELATIONS.FRIEND },
			{ loc.REG_RELATION_LOVE, RELATIONS.LOVE },
			{ loc.REG_RELATION_FAMILY, RELATIONS.FAMILY },
		},
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
		LI = "INV_Misc_QuestionMark",
		RI = "INV_Misc_QuestionMark"
	};

	PSYCHO_PRESETS = {
		{
			LT = loc.REG_PLAYER_PSYCHO_CHAOTIC,
			RT = loc.REG_PLAYER_PSYCHO_Loyal,
			LI = is_classic and "Spell_Shadow_UnholyFrenzy" or "Ability_Rogue_WrongfullyAccused",
			RI = is_classic and "Spell_Holy_RighteousFury" or "Ability_Paladin_SanctifiedWrath",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Chaste,
			RT = loc.REG_PLAYER_PSYCHO_Luxurieux,
			LI = "INV_Belt_27",
			RI = "Spell_Shadow_SummonSuccubus",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Indulgent,
			RT = loc.REG_PLAYER_PSYCHO_Rencunier,
			LI = "INV_RoseBouquet01",
			RI = "Ability_Hunter_SniperShot",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Genereux,
			RT = loc.REG_PLAYER_PSYCHO_Egoiste,
			LI = "INV_Misc_Gift_02",
			RI = is_classic and "INV_Ingot_03" or "INV_Misc_Coin_02",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Sincere,
			RT = loc.REG_PLAYER_PSYCHO_Trompeur,
			LI = is_classic and "Spell_Holy_AuraOfLight" or "INV_Misc_Toy_07",
			RI = "Ability_Rogue_Disguise",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Misericordieux,
			RT = loc.REG_PLAYER_PSYCHO_Cruel,
			LI = "INV_ValentinesCandySack",
			RI = is_classic and "Ability_Rogue_Eviscerate" or "Ability_Warrior_Trauma",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Pieux,
			RT = loc.REG_PLAYER_PSYCHO_Rationnel,
			LI = is_classic and "Spell_Holy_PowerInfusion" or "Spell_Holy_HolyGuidance",
			RI = "INV_Gizmo_02",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Pragmatique,
			RT = loc.REG_PLAYER_PSYCHO_Conciliant,
			LI = is_classic and "Ability_Rogue_DualWeild" or "Ability_Rogue_HonorAmongstThieves",
			RI = is_classic and "ACHIEVEMENT_GUILDPERK_HAVEGROUP WILLTRAVEL" or "INV_Misc_GroupNeedMore",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Reflechi,
			RT = loc.REG_PLAYER_PSYCHO_Impulsif,
			LI = is_classic and "INV_Misc_PocketWatch_01" or "Spell_Shadow_Brainwash",
			RI = is_classic and "SPELL_FIRE_INCINERATE" or "Achievement_BG_CaptureFlag_EOS",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Acete,
			RT = loc.REG_PLAYER_PSYCHO_Bonvivant,
			LI = is_classic and "INV_Misc_Coin_05" or "INV_Misc_Food_PineNut",
			RI = is_classic and "INV_Misc_Coin_02" or "INV_Misc_Food_99",
		},
		{
			LT = loc.REG_PLAYER_PSYCHO_Valeureux,
			RT = loc.REG_PLAYER_PSYCHO_Couard,
			LI = is_classic and "Ability_Warrior_BattleShout" or "Ability_Paladin_BeaconofLight",
			RI = "Ability_Druid_Cower",
		},
	};

	PSYCHO_PRESETS_DROPDOWN = {
		{ loc.REG_PLAYER_PSYCHO_SOCIAL },
		{ loc.REG_PLAYER_PSYCHO_CHAOTIC .. " - " .. loc.REG_PLAYER_PSYCHO_Loyal, 1 },
		{ loc.REG_PLAYER_PSYCHO_Chaste .. " - " .. loc.REG_PLAYER_PSYCHO_Luxurieux, 2 },
		{ loc.REG_PLAYER_PSYCHO_Indulgent .. " - " .. loc.REG_PLAYER_PSYCHO_Rencunier, 3 },
		{ loc.REG_PLAYER_PSYCHO_Genereux .. " - " .. loc.REG_PLAYER_PSYCHO_Egoiste, 4 },
		{ loc.REG_PLAYER_PSYCHO_Sincere .. " - " .. loc.REG_PLAYER_PSYCHO_Trompeur, 5 },
		{ loc.REG_PLAYER_PSYCHO_Misericordieux .. " - " .. loc.REG_PLAYER_PSYCHO_Cruel, 6 },
		{ loc.REG_PLAYER_PSYCHO_Pieux .. " - " .. loc.REG_PLAYER_PSYCHO_Rationnel, 7 },
		{ loc.REG_PLAYER_PSYCHO_PERSONAL },
		{ loc.REG_PLAYER_PSYCHO_Pragmatique .. " - " .. loc.REG_PLAYER_PSYCHO_Conciliant, 8 },
		{ loc.REG_PLAYER_PSYCHO_Reflechi .. " - " .. loc.REG_PLAYER_PSYCHO_Impulsif, 9 },
		{ loc.REG_PLAYER_PSYCHO_Acete .. " - " .. loc.REG_PLAYER_PSYCHO_Bonvivant, 10 },
		{ loc.REG_PLAYER_PSYCHO_Valeureux .. " - " .. loc.REG_PLAYER_PSYCHO_Couard, 11 },
		{ loc.REG_PLAYER_PSYCHO_CUSTOM },
		{ loc.REG_PLAYER_PSYCHO_CREATENEW, "new" },
	};

	RELATIONSHIP_STATUS_DROPDOWN = {
		{loc.REG_PLAYER_RELATIONSHIP_STATUS_UNKNOWN, AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS.UNKNOWN},
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
	TRP3_RegisterCharact_Edit_NamePanel_Icon:SetScript("OnClick", function() showIconBrowser(onPlayerIconSelected) end);
	TRP3_RegisterCharact_NamePanel_Edit_CancelButton:SetScript("OnClick", showCharacteristicsTab);
	TRP3_RegisterCharact_NamePanel_Edit_SaveButton:SetScript("OnClick", onSave);
	TRP3_RegisterCharact_NamePanel_EditButton:SetScript("OnClick", onEdit);
	TRP3_RegisterCharact_ActionButton:SetScript("OnClick", onActionClicked);
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

	setupDropDownMenu(TRP3_RegisterCharact_Edit_PsychoAdd, PSYCHO_PRESETS_DROPDOWN, psychoAdd, 0, true, false);

	-- Localz
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_NamePanel_Icon, "RIGHT", 0, 5, loc.REG_PLAYER_ICON, loc.REG_PLAYER_ICON_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_TitleFieldHelp, "RIGHT", 0, 5, loc.REG_PLAYER_TITLE, loc.REG_PLAYER_TITLE_TT);
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
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_BirthplaceButton, "RIGHT", 0, 5, loc.REG_PLAYER_HERE, loc.REG_PLAYER_HERE_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_EyeButton, "RIGHT", 0, 5, loc.REG_PLAYER_EYE, loc.REG_PLAYER_COLOR_TT);
	setTooltipForSameFrame(TRP3_RegisterCharact_Edit_ClassButton, "RIGHT", 0, 5, loc.REG_PLAYER_COLOR_CLASS, loc.REG_PLAYER_COLOR_CLASS_TT .. loc.REG_PLAYER_COLOR_TT);

	setupFieldSet(TRP3_RegisterCharact_NamePanel, loc.REG_PLAYER_NAMESTITLES, 150);
	setupFieldSet(TRP3_RegisterCharact_Edit_NamePanel, loc.REG_PLAYER_NAMESTITLES, 150);
	setupFieldSet(TRP3_RegisterCharact_CharactPanel, loc.REG_PLAYER_CHARACTERISTICS, 150);
	setupFieldSet(TRP3_RegisterCharact_Edit_CharactPanel, loc.REG_PLAYER_CHARACTERISTICS, 150);

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
	TRP3_RegisterCharact_NamePanel_EditButton:SetText(loc.CM_EDIT);
	TRP3_RegisterCharact_Edit_TitleFieldText:SetText(loc.REG_PLAYER_TITLE);
	TRP3_RegisterCharact_Edit_FirstFieldText:SetText(loc.REG_PLAYER_FIRSTNAME);
	TRP3_RegisterCharact_Edit_LastFieldText:SetText(loc.REG_PLAYER_LASTNAME);
	TRP3_RegisterCharact_Edit_FullTitleFieldText:SetText(loc.REG_PLAYER_FULLTITLE);
	TRP3_RegisterCharact_CharactPanel_RegisterTitle:SetText(Utils.str.icon("INV_Misc_Book_09", 25) .. " " .. loc.REG_PLAYER_REGISTER);
	TRP3_RegisterCharact_CharactPanel_Edit_RegisterTitle:SetText(Utils.str.icon("INV_Misc_Book_09", 25) .. " " .. loc.REG_PLAYER_REGISTER);
	local PSYCHO_ICON = is_classic and "Spell_Holy_MindSooth" or "Spell_Arcane_MindMastery";
	TRP3_RegisterCharact_CharactPanel_PsychoTitle:SetText(Utils.str.icon(PSYCHO_ICON, 25) .. " " .. loc.REG_PLAYER_PSYCHO);
	TRP3_RegisterCharact_CharactPanel_Edit_PsychoTitle:SetText(Utils.str.icon(PSYCHO_ICON, 25) .. " " .. loc.REG_PLAYER_PSYCHO);
	TRP3_RegisterCharact_CharactPanel_MiscTitle:SetText(Utils.str.icon("INV_MISC_NOTE_06", 25) .. " " .. loc.REG_PLAYER_MORE_INFO);
	TRP3_RegisterCharact_CharactPanel_Edit_MiscTitle:SetText(Utils.str.icon("INV_MISC_NOTE_06", 25) .. " " .. loc.REG_PLAYER_MORE_INFO);
	TRP3_RegisterCharact_Edit_RaceFieldText:SetText(loc.REG_PLAYER_RACE);
	TRP3_RegisterCharact_Edit_ClassFieldText:SetText(loc.REG_PLAYER_CLASS);
	TRP3_RegisterCharact_Edit_AgeFieldText:SetText(loc.REG_PLAYER_AGE);
	TRP3_RegisterCharact_Edit_EyeFieldText:SetText(loc.REG_PLAYER_EYE);
	TRP3_RegisterCharact_Edit_HeightFieldText:SetText(loc.REG_PLAYER_HEIGHT);
	TRP3_RegisterCharact_Edit_WeightFieldText:SetText(loc.REG_PLAYER_WEIGHT);
	TRP3_RegisterCharact_Edit_ResidenceFieldText:SetText(loc.REG_PLAYER_RESIDENCE);
	TRP3_RegisterCharact_Edit_BirthplaceFieldText:SetText(loc.REG_PLAYER_BIRTHPLACE);

	setupListBox(TRP3_RegisterCharact_Dropdown_RelationshipField, RELATIONSHIP_STATUS_DROPDOWN, onRelationshipStatusSelection, loc.REG_PLAYER_RELATIONSHIP_STATUS_UNKNOWN, 200, false);
	Ellyb.Tooltips.getTooltip(TRP3_RegisterCharact_Dropdown_RelationshipField)
		:SetTitle(loc.REG_PLAYER_RELATIONSHIP_STATUS)
		:AddLine(loc.REG_PLAYER_RELATIONSHIP_STATUS_TT);
	TRP3_RegisterCharact_Dropdown_RelationshipFieldTitle:SetText(loc.REG_PLAYER_RELATIONSHIP_STATUS);

	-- Resizing
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerWidth)
		local finalContainerWidth = containerWidth - 70;
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
