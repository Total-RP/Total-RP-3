--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Peek section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local stEtN = Utils.str.emptyToNil;
local color = Utils.str.color;
local loc = TRP3_L;
local get = TRP3_PROFILE.getData;
local tcopy = Utils.table.copy;
local assert = assert;
local getDefaultProfile = TRP3_PROFILE.getDefaultProfile;
local openIconBrowser = TRP3_POPUPS.openIconBrowser;
local tinsert = tinsert;
local pairs = pairs;
local type = type;
local tostring = tostring;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

getDefaultProfile().player.misc = {
	v = 1,
	PE = {},
	ST = {},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- RP Style
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local STYLE_FIELDS;
local function buildStyleStructure()
	STYLE_FIELDS = {
		{
			id = "1",
			name = loc("REG_PLAYER_STYLE_FREQ"),
			values = {
				{loc("REG_PLAYER_STYLE_FREQ_1"), 1},
				{loc("REG_PLAYER_STYLE_FREQ_2"), 2},
				{loc("REG_PLAYER_STYLE_FREQ_3"), 3},
				{loc("REG_PLAYER_STYLE_FREQ_4"), 4},
				{loc("REG_PLAYER_STYLE_FREQ_5"), 5},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "2",
			name = loc("REG_PLAYER_STYLE_INJURY"),
			values = {
				{YES, 1},
				{NO, 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "3",
			name = loc("REG_PLAYER_STYLE_DEATH"),
			values = {
				{YES, 1},
				{"No", 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "4",
			name = loc("REG_PLAYER_STYLE_ROMANCE"),
			values = {
				{YES, 1},
				{NO, 2},
				{loc("REG_PLAYER_STYLE_PERMI"), 3},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
		{
			id = "5",
			name = loc("REG_PLAYER_STYLE_BATTLE"),
			values = {
				{loc("REG_PLAYER_STYLE_BATTLE_1"), 1},
				{loc("REG_PLAYER_STYLE_BATTLE_2"), 2},
				{loc("REG_PLAYER_STYLE_BATTLE_3"), 3},
				{loc("REG_PLAYER_STYLE_BATTLE_4"), 4},
				{loc("REG_PLAYER_STYLE_HIDE"), 0},
			}
		},
	};
end

local styleLines = {};

local function onEditStyle(choice, frame)
	frame = frame:GetParent();
	assert(frame.fieldData, "No data in frame !");
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	if context.unitID == Globals.player_id then
		local dataTab = get("player/misc");
		dataTab.ST[frame.fieldData.id] = choice;
		-- version increment
		assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
		dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	end
end

local function displayRPStyle(context)
	local dataTab = nil;
	if context.unitID == Globals.player_id then
		dataTab = get("player/misc");
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).misc then
			dataTab = TRP3_GetUnitProfile(context.unitID).misc;
		else
			dataTab = {};
		end
	end
	local styleData = dataTab.ST or {};
	
	-- Hide all
	for _, frame in pairs(styleLines) do
		frame:Hide();
	end
	
	local previous = nil;
	local count = 0;
	for index, fieldData in pairs(STYLE_FIELDS) do
		local frame = styleLines[index];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterMiscViewRPStyle_line"..index, TRP3_RegisterMiscViewRPStyle, "TRP3_RegisterRPStyleMain_Edit_Line");
			TRP3_ListBox_Setup(_G[frame:GetName().."Values"], fieldData.values, onEditStyle, nil, 180, true);
			frame.fieldData = fieldData;
			tinsert(styleLines, frame);
		end
		
		local selectedValue = styleData[fieldData.id] or 0;
		
		if context.unitID == Globals.player_id or selectedValue ~= 0 then
			-- Position
			frame:ClearAllPoints();
			if previous == nil then
				frame:SetPoint("TOPLEFT", TRP3_RegisterMiscViewRPStyle, "TOPLEFT", 25, -20);
			else
				frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, 0);
			end
			frame:SetPoint("LEFT", 0, 0);
			frame:SetPoint("RIGHT", 0, 0);
			
			-- Value
			_G[frame:GetName().."FieldName"]:SetText(fieldData.name);
			local dropDown = _G[frame:GetName().."Values"];
			local readOnlyValue = _G[frame:GetName().."FieldValue"];
			if context.unitID == Globals.player_id then
				dropDown:SetSelectedValue(selectedValue);
				dropDown:Show();
				readOnlyValue:Hide();
			else
				dropDown:Hide();
				readOnlyValue:Show();
				local valueText = nil;
				for _, data in pairs(fieldData.values) do
					if data[2] == selectedValue then
						valueText = data[1];
						break;
					end
				end
				readOnlyValue:SetText(valueText);
			end
			
			frame:Show();
			previous = frame;
			count = count + 1;
		end
	end
	
	TRP3_RegisterMiscViewRPStyleEmpty:Hide();
	if context.unitID ~= Globals.player_id and count == 0 then
		TRP3_RegisterMiscViewRPStyleEmpty:Show();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- PEEK
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_NOT_USED_ICON = "INV_Misc_QuestionMark";

local function setupGlanceButton(button, active, icon, title, text, isMine)
	button:Enable();
	button:SetNormalTexture("Interface\\ICONS\\" .. (icon or GLANCE_NOT_USED_ICON));
	if active then
		button:SetAlpha(1);
		if not isMine then
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title or "...", text);
		else
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, title or "...", (text or "...") .. "\n" .. color("y") .. loc("REG_PLAYER_GLANCE_CONFIG"));
		end
	else
		button:SetAlpha(0.1);
		if not isMine then
			button:Disable();
		else
			TRP3_SetTooltipForSameFrame(button, "RIGHT", 0, 5, loc("REG_PLAYER_GLANCE_UNUSED"), color("y") .. loc("REG_PLAYER_GLANCE_CONFIG"));
		end
	end
end

local function displayPeek(context)
	local dataTab = nil;
	if context.unitID == Globals.player_id then
		dataTab = get("player/misc");
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).misc then
			dataTab = TRP3_GetUnitProfile(context.unitID).misc;
		else
			dataTab = {};
		end
	end
	
	for i=1,5 do
		local glanceData = (dataTab.PE or {})[tostring(i)] or {};
		local button = _G["TRP3_RegisterMiscViewGlanceSlot" .. i];
		setupGlanceButton(button, glanceData.AC, glanceData.IC, glanceData.TI, glanceData.TX, context.unitID == Globals.player_id);
	end
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peek editor
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentSelected;
local draftData = {};

local function onIconSelected(icon)
	icon = icon or Globals.icons.default;
	TRP3_InitIconButton(TRP3_RegisterMiscEdit_Glance_Icon, icon);
	TRP3_RegisterMiscEdit_Glance_Icon.icon = icon;
	TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
end

local function onIconClosed()
	TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
end

local function onSlotClick(button)
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	if context.unitID == Globals.player_id then
		currentSelected = button.index;
		local dataTab = get("player/misc");
		draftData = (dataTab.PE or {})[currentSelected] or {};
		TRP3_RegisterMiscEdit_Glance_Active:SetChecked(draftData.AC);
		TRP3_RegisterMiscEdit_Glance_TextScrollText:SetText(draftData.TX or "");
		TRP3_RegisterMiscEdit_Glance_Title:SetText(draftData.TI or "");
		onIconSelected(draftData.IC);
		TRP3_ShowPopup(TRP3_RegisterGlanceEditor);
	end
end

local function applyPeek()
	assert(currentSelected, "No selection ...");
	local dataTab = get("player/misc");
	if not dataTab.PE then
		dataTab.PE = {};
	end
	if not dataTab.PE[currentSelected] then
		dataTab.PE[currentSelected] = {};
	end
	local peekTab = dataTab.PE[currentSelected];
	peekTab.IC = TRP3_RegisterMiscEdit_Glance_Icon.icon;
	peekTab.AC = TRP3_RegisterMiscEdit_Glance_Active:GetChecked();
	peekTab.TI = stEtN(TRP3_RegisterMiscEdit_Glance_Title:GetText());
	peekTab.TX = stEtN(TRP3_RegisterMiscEdit_Glance_TextScrollText:GetText());
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	-- Refresh display
	TRP3_HidePopups();
	TRP3_onPlayerPeekShow();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_onPlayerPeekShow()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	TRP3_RegisterMisc:Show();
	displayPeek(context);
	displayRPStyle(context);
end

function TRP3_RegisterMiscGetExchangeData()
	return get("player/misc");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Presets
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local PEEK_PRESETS;

local function buildPresetListData()
	PEEK_PRESETS = {
		humor1 = {
			icon = "Spell_Shadow_MindSteal",
			name = "Apathetic",
			text = "This character is dispassionate and nonchalant."
		}
	};

	local listData = {};
	local tmp = {};
	tinsert(listData, {loc("REG_PLAYER_GLANCE_PRESET_SELECT"), nil});
	for presetID,_ in pairs(PEEK_PRESETS) do
		tinsert(tmp, presetID);
	end
	table.sort(tmp);
	for _, presetID in pairs(tmp) do
		local preset = PEEK_PRESETS[presetID];
		tinsert(listData, {preset.name, presetID});
	end
	
	return listData;
end

local function onPresetSelected(presetID)
	assert(presetID == nil or PEEK_PRESETS[presetID], "Unknown peek preset: " .. tostring(presetID));
	if presetID ~= nil then
		TRP3_RegisterMiscEdit_Glance_PresetList:SetSelectedIndex(1);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_PeekInit()
	buildStyleStructure();
	
	TRP3_FieldSet_SetCaption(TRP3_RegisterMiscViewGlance, loc("REG_PLAYER_GLANCE"), 150);
	TRP3_RegisterMiscEdit_Glance_ActiveText:SetText(loc("REG_PLAYER_GLANCE_USE"));
	TRP3_RegisterMiscEdit_Glance_Apply:SetText(loc("CM_APPLY"));
	TRP3_RegisterMiscEdit_Glance_TitleText:SetText(loc("REG_PLAYER_GLANCE_TITLE"));
	TRP3_RegisterGlanceEditorTitle:SetText(loc("REG_PLAYER_GLANCE_EDITOR"));
	TRP3_RegisterMiscViewRPStyleEmpty:SetText(loc("REG_PLAYER_STYLE_EMPTY"));
	TRP3_RegisterMiscEdit_Glance_PresetText:SetText(loc("REG_PLAYER_GLANCE_PRESET"));
	
	TRP3_RegisterMiscEdit_Glance_Icon:SetScript("OnClick", function() openIconBrowser(onIconSelected, onIconClosed); end);
	TRP3_RegisterMiscEdit_Glance_Apply:SetScript("OnClick", applyPeek);
	for index=1,5,1 do
		-- DISPLAY
		local button = _G["TRP3_RegisterMiscViewGlanceSlot" .. index];
		button:SetDisabledTexture("Interface\\ICONS\\" .. GLANCE_NOT_USED_ICON);
		button:GetDisabledTexture():SetDesaturated(1);
		button:SetScript("OnClick", onSlotClick);
		button.index = tostring(index);
	end
	
	TRP3_ListBox_Setup(TRP3_RegisterMiscEdit_Glance_PresetList, buildPresetListData(), onPresetSelected, nil, 180, true);
	TRP3_RegisterMiscEdit_Glance_PresetList:SetSelectedIndex(1);
	
	-- RP style
	TRP3_FieldSet_SetCaption(TRP3_RegisterMiscViewRPStyle, loc("REG_PLAYER_STYLE_RPSTYLE"), 150);
end