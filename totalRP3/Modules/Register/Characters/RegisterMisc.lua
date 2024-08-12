-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- imports
local Utils, Events, Globals, Ellyb = TRP3_API.utils, TRP3_Addon.Events, TRP3_API.globals, TRP3_API.Ellyb;
local loc = TRP3_API.loc;
local get = TRP3_API.profile.getData;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;

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
	-- Note: If changing anything here, make corresponding changes to
	-- the RP_STYLE_FIELDS table in RegisterMSP. Additionally, any values
	-- assigned to options are fed through MSP as-is - so don't change them.
	STYLE_FIELDS = {
		{
			id = "2",
			name = loc.REG_PLAYER_STYLE_INJURY,
			tooltipText = loc.REG_PLAYER_STYLE_INJURY_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{NO, 2},
				{loc.REG_PLAYER_STYLE_PERMI, 3},
				{YES, 1},
			}
		},
		{
			id = "3",
			name = loc.REG_PLAYER_STYLE_DEATH,
			tooltipText = loc.REG_PLAYER_STYLE_DEATH_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{NO, 2},
				{loc.REG_PLAYER_STYLE_PERMI, 3},
				{YES, 1},
			}
		},
		{
			id = "4",
			name = loc.REG_PLAYER_STYLE_ROMANCE,
			tooltipText = loc.REG_PLAYER_STYLE_ROMANCE_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{NO, 2},
				{loc.REG_PLAYER_STYLE_PERMI, 3},
				{YES, 1},
			}
		},
		{
			id = "7",
			name = loc.REG_PLAYER_STYLE_CRIME,
			tooltipText = loc.REG_PLAYER_STYLE_CRIME_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{NO, 2},
				{loc.REG_PLAYER_STYLE_PERMI, 3},
				{YES, 1},
			}
		},
		{
			id = "8",
			name = loc.REG_PLAYER_STYLE_LOSSOFCONTROL,
			tooltipText = loc.REG_PLAYER_STYLE_LOSSOFCONTROL_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{NO, 2},
				{loc.REG_PLAYER_STYLE_PERMI, 3},
				{YES, 1},
			}
		},
		{
			id = "6",
			name = loc.REG_PLAYER_STYLE_GUILD,
			tooltipText = loc.REG_PLAYER_STYLE_GUILD_TT,
			values = {
				{loc.CM_DO_NOT_SHOW, 0},
				{loc.REG_PLAYER_STYLE_GUILD_OOC, 2},
				{loc.REG_PLAYER_STYLE_GUILD_IC, 1},
			}
		},
	};
end

local styleLines = {};

local function onEditStyle(choice, frame)
	frame = frame:GetParent();
	assert(frame.fieldData, "No data in frame !");
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	if context.isPlayer then
		local dataTab = get("player/misc");
		local old = dataTab.ST[frame.fieldData.id];
		dataTab.ST[frame.fieldData.id] = choice;
		if old ~= choice then
			-- version increment
			assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
			dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
			TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getPlayerCurrentProfileID(), "misc");
		end
	end
end

local function displayRPStyle(context)
	local dataTab = context.profile.misc or Globals.empty;
	local styleData = dataTab.ST or {};

	-- Hide all
	for _, frame in pairs(styleLines) do
		frame:Hide();
	end

	-- Roleplay proficiency is displayed on its own line in consult-mode.

	local previous;
	TRP3_RegisterMiscViewRPStyle.RoleplayExperience:Hide();

	if not context.isPlayer then
		local frame = TRP3_RegisterMiscViewRPStyle.RoleplayExperience;
		local player = AddOn_TotalRP3.Player.CreateFromProfileID(context.profileID);
		local experience = player:GetRoleplayExperience();

		if experience then
			local text = TRP3_API.GetRoleplayExperienceText(experience);
			local icon = TRP3_API.GetRoleplayExperienceIconMarkup(experience);

			frame.FieldName:SetText(loc.DB_STATUS_XP);
			frame.FieldValue:SetText(string.trim(string.join(" ", icon or "", text)));
			frame:Show(true);
			previous = frame;
		end
	end

	for index, fieldData in pairs(STYLE_FIELDS) do
		local frame = styleLines[index];
		if frame == nil then
			frame = CreateFrame("Frame", nil, TRP3_RegisterMiscViewRPStyle, "TRP3_RegisterRPStyleMain_Edit_Line");
			setupListBox(frame.Values, fieldData.values, onEditStyle, nil, 180, true);
			frame.fieldData = fieldData;
			tinsert(styleLines, frame);
		end

		local selectedValue = styleData[fieldData.id] or 0;

		if context.isPlayer or selectedValue ~= 0 then
			-- Position
			frame:ClearAllPoints();
			if previous == nil then
				frame:SetPoint("TOP", TRP3_RegisterMiscViewRPStyle, "TOP", 0, -12);
			else
				frame:SetPoint("TOP", previous, "BOTTOM", 0, 0);
			end

			-- Value
			frame.FieldName:SetText(fieldData.name);
			local dropDown = frame.Values;
			local readOnlyValue = frame.FieldValue;
			local tooltipFrame;
			if context.isPlayer then
				frame:SetHeight(30);
				dropDown:SetSelectedValue(selectedValue);
				dropDown:Show();
				readOnlyValue:Hide();
				tooltipFrame = dropDown;
			else
				frame:SetHeight(24);
				dropDown:Hide();
				readOnlyValue:Show();
				tooltipFrame = readOnlyValue;
				local valueText;
				for _, data in pairs(fieldData.values) do
					if data[2] == selectedValue then
						valueText = data[1];
						break;
					end
				end
				readOnlyValue:SetText(valueText);
			end

			-- Set tooltip
			if fieldData.tooltipText and fieldData.tooltipText ~= "" then
				Ellyb.Tooltips.getTooltip(tooltipFrame)
				:ClearLines()
				:SetTitle(fieldData.name)
				:AddLine(fieldData.tooltipText);
			end

			frame:Show();
			previous = frame;
		end
	end

	TRP3_RegisterMiscViewRPStyleEmpty:Hide();
	if not context.isPlayer and previous == nil then
		TRP3_RegisterMiscViewRPStyleEmpty:Show();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- PEEK
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GLANCE_NOT_USED_ICON = TRP3_InterfaceIcons.Default;

local function setupGlanceButton(button, active, icon, title, text, isMine)
	button:Enable();
	button.isCurrentMine = isMine;

	if active then
		button:SetAlpha(1);
		button:SetIconTexture(icon or GLANCE_NOT_USED_ICON);
		button.Icon:SetAlpha(1);
		button.Icon:SetDesaturated(false);
		setTooltipForSameFrame(button, "BOTTOM", 0, -5, title or "...", text);
	else
		button:SetAlpha(isMine and 1 or 0.1);
		button:SetIconTexture(isMine and icon or GLANCE_NOT_USED_ICON);
		button.Icon:SetAlpha(isMine and 0.75 or 1);
		button.Icon:SetDesaturated(true);
		if not isMine then
			button:Disable();
		else
			setTooltipForSameFrame(button, "BOTTOM", 0, -5, title or loc.REG_PLAYER_GLANCE_UNUSED, text);
		end
	end
end
TRP3_API.register.setupGlanceButton = setupGlanceButton;

local function displayPeek(context)
	TRP3_AtFirstGlanceEditor:Hide();
	local dataTab = context.profile.misc or Globals.empty;
	for i=1,5 do
		local glanceData = (dataTab.PE or {})[tostring(i)] or {};
		local button = _G["TRP3_RegisterMiscViewGlanceSlot" .. i];
		button.data = glanceData;

		setupGlanceButton(button, glanceData.AC, glanceData.IC, glanceData.TI, glanceData.TX, context.isPlayer);
	end
	if context.isPlayer then
		TRP3_RegisterMiscViewGlanceHelp:Show();
	else
		TRP3_RegisterMiscViewGlanceHelp:Hide();
	end
end


function TRP3_API.register.checkGlanceActivation(dataTab)
	for i=1, 5, 1 do
		if dataTab[tostring(i)] and dataTab[tostring(i)].AC then
			return true
		end
	end
	return false;
end

function TRP3_API.register.getGlanceIconTextures(dataTab, size)
	local text = "";
	for i=1, 5, 1 do
		local index = tostring(i);
		if dataTab[index] and dataTab[index].AC then
			text = text .. Utils.str.icon(dataTab[index].IC, size) .. " ";
		end
	end
	return text;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SANITIZE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function sanitizeMisc(structure)
	local somethingWasSanitized = false;
	if structure and structure.PE then
		for i=1, 5 do
			local index = tostring(i);
			if structure.PE[index] then
				local sanitizedTIValue = Utils.str.sanitize(structure.PE[index].TI);
				local sanitizedTXValue = Utils.str.sanitize(structure.PE[index].TX, true);
				if sanitizedTIValue ~= structure.PE[index].TI then
					structure.PE[index].TI = sanitizedTIValue;
					somethingWasSanitized = true;
				end
				if sanitizedTXValue ~= structure.PE[index].TX then
					structure.PE[index].TX = sanitizedTXValue;
					somethingWasSanitized = true;
				end
			end
		end
	end
	return somethingWasSanitized;
end
TRP3_API.register.ui.sanitizeMisc = sanitizeMisc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peek editor
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function applyPeekSlot(slot, ic, ac, ti, tx, swap)
	TRP3_AtFirstGlanceEditor:Hide();
	assert(slot, "No selection ...");
	local dataTab = get("player/misc");
	if not dataTab.PE then
		dataTab.PE = {};
	end
	if not dataTab.PE[slot] then
		dataTab.PE[slot] = {};
	end
	local peekTab = dataTab.PE[slot];
	if swap then
		peekTab.AC = not peekTab.AC;
	else
		peekTab.IC = ic;
		peekTab.AC = ac;
		peekTab.TI = ti;
		peekTab.TX = tx;
	end

	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	-- Refresh display & target frame
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getPlayerCurrentProfileID(), "misc");

end
TRP3_API.register.applyPeekSlot = applyPeekSlot;

local function swapGlanceSlot(from, to)
	TRP3_AtFirstGlanceEditor:Hide();
	local dataTab = get("player/misc");
	TRP3_API.register.glance.swapDataFromSlots(dataTab, from, to);
	-- Refresh display & target frame
	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getPlayerCurrentProfileID(), "misc");
end
TRP3_API.register.swapGlanceSlot = swapGlanceSlot;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Currently
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function displayCurrently(context)
	TRP3_RegisterMiscViewCurrentlyIC:SetReadOnly(not context.isPlayer);
	TRP3_RegisterMiscViewCurrentlyIC.HelpButton:SetShown(context.isPlayer);

	TRP3_RegisterMiscViewCurrentlyOOC:SetReadOnly(not context.isPlayer);
	TRP3_RegisterMiscViewCurrentlyOOC.HelpButton:SetShown(context.isPlayer);


	local dataTab = context.profile.character or Globals.empty;
	TRP3_RegisterMiscViewCurrentlyIC:SetText(dataTab.CU or "");
	TRP3_RegisterMiscViewCurrentlyOOC:SetText(dataTab.CO or "");
end

local function onCurrentlyChanged()
	if not getCurrentContext().isPlayer then
		return;
	end

	local multiLine = true;
	local text = Utils.str.sanitize(TRP3_RegisterMiscViewCurrentlyIC:GetInputText(), multiLine);

	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	player:SetCurrentlyText(text);
end

local function onOOCInfoChanged()
	if not getCurrentContext().isPlayer then
		return;
	end

	local multiLine = true;
	local text = Utils.str.sanitize(TRP3_RegisterMiscViewCurrentlyOOC:GetInputText(), multiLine);

	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	player:SetOutOfCharacterInfo(text);
end

local UpdateCurrentlyText = TRP3_FunctionUtil.Debounce(0.2, onCurrentlyChanged);

local function OnCurrentlyTextChanged(_, userInput)
	if userInput then
		UpdateCurrentlyText();
	end
end

local UpdateOOCText = TRP3_FunctionUtil.Debounce(0.2, onOOCInfoChanged);

local function OnOOCTextChanged(_, userInput)
	if userInput then
		UpdateOOCText();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Misc logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function showMiscTab()
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");
	context.isEditMode = false;
	TRP3_RegisterMisc:Show();
	displayPeek(context);
	displayRPStyle(context);
	displayCurrently(context);
	TRP3_ProfileReportButton:Hide();
	if not context.isPlayer and context.profile and context.profile.link then
		TRP3_ProfileReportButton:Show();
	end
end
TRP3_API.register.ui.showMiscTab = showMiscTab;

function TRP3_API.register.player.getMiscExchangeData()
	local miscData = CopyTable(get("player/misc"));

	-- Remove data from disabled glances
	if miscData.PE then
		for i=1,5 do
			local index = tostring(i);
			if miscData.PE[index] and miscData.PE[index].AC == false then
				miscData.PE[index] = nil;
			end
		end
	end

	return miscData;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TUTORIAL
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TUTORIAL_EDIT;

local function createTutorialStructure()
	TUTORIAL_EDIT = {
		{
			box = {
				allPoints = TRP3_RegisterMiscViewGlance
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_PLAYER_TUTO_ABOUT_MISC_1,
				textWidth = 400,
				arrow = "DOWN"
			}
		},
		{
			box = {
				allPoints = TRP3_RegisterMiscViewCurrently
			},
			button = {
				x = 0, y = 10, anchor = "CENTER",
				text = loc.DB_STATUS_CURRENTLY_COMMON .. "|r\n\n" .. "|cnGREEN_FONT_COLOR:" .. loc.DB_STATUS_CURRENTLY .. "|r\n" .. loc.DB_STATUS_CURRENTLY_TT .. "\n\n|cnGREEN_FONT_COLOR:" .. loc.DB_STATUS_CURRENTLY_OOC .. "|r\n" .. loc.DB_STATUS_CURRENTLY_OOC_TT,
				textWidth = 400,
				arrow = "DOWN"
			}
		},
		{
			box = {
				allPoints = TRP3_RegisterMiscViewRPStyle
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_PLAYER_TUTO_ABOUT_MISC_3,
				textWidth = 300,
				arrow = "UP"
			}
		}
	}
end

function TRP3_API.register.ui.miscTutorialProvider()
	local context = getCurrentContext();
	if context and context.isPlayer then
		return TUTORIAL_EDIT;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.inits.miscInit()
	buildStyleStructure();
	createTutorialStructure();

	TRP3_RegisterMiscViewGlance:SetTitleText(loc.REG_PLAYER_GLANCE);
	TRP3_RegisterMiscViewCurrently:SetTitleText(loc.REG_PLAYER_STATUS);
	TRP3_AtFirstGlanceEditorApply:SetText(loc.CM_APPLY);
	TRP3_AtFirstGlanceEditorNameText:SetText(loc.REG_PLAYER_GLANCE_TITLE);
	TRP3_RegisterMiscViewRPStyleEmpty:SetText(loc.REG_PLAYER_STYLE_EMPTY);

	TRP3_API.ui.tooltip.setTooltipAll(TRP3_AtFirstGlanceEditorActive, "RIGHT", 0, 5, loc.CM_ACTIVATE, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_GLANCE_USE));

	TRP3_RegisterMiscViewCurrentlyIC.Title:SetText(loc.DB_STATUS_CURRENTLY);
	setTooltipForSameFrame(TRP3_RegisterMiscViewCurrentlyIC.HelpButton, "RIGHT", 0, 5, loc.DB_STATUS_CURRENTLY, loc.DB_STATUS_CURRENTLY_TT);
	TRP3_RegisterMiscViewCurrentlyIC:RegisterCallback("OnTextChanged", OnCurrentlyTextChanged);

	TRP3_RegisterMiscViewCurrentlyOOC.Title:SetText(loc.DB_STATUS_CURRENTLY_OOC);
	setTooltipForSameFrame(TRP3_RegisterMiscViewCurrentlyOOC.HelpButton, "RIGHT", 0, 5, loc.DB_STATUS_CURRENTLY_OOC, loc.DB_STATUS_CURRENTLY_OOC_TT);
	TRP3_RegisterMiscViewCurrentlyOOC:RegisterCallback("OnTextChanged", OnOOCTextChanged);

	setTooltipForSameFrame(TRP3_RegisterMiscViewGlanceHelp, "RIGHT", 0, 5, loc.REG_PLAYER_GLANCE, TRP3_API.register.glance.addClickHandlers(loc.REG_PLAYER_GLANCE_CONFIG));

	for index=1,5,1 do
		-- DISPLAY
		local button = _G["TRP3_RegisterMiscViewGlanceSlot" .. index];
		button:SetScript("OnClick", TRP3_API.register.glance.onGlanceSlotClick);
		button:SetScript("OnDoubleClick", TRP3_API.register.glance.onGlanceDoubleClick);
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		button:RegisterForDrag("LeftButton");
		button:SetScript("OnDragStart", TRP3_API.register.glance.onGlanceDragStart);
		button:SetScript("OnDragStop", TRP3_API.register.glance.onGlanceDragStop);
		button.slot = tostring(index);
		button.targetType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER;
	end

	-- RP style
	TRP3_RegisterMiscViewRPStyle:SetTitleText(loc.REG_PLAYER_STYLE_RPSTYLE);

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_DATA_UPDATED, function(_, unitID, _, dataType)
		if getCurrentPageID() == "player_main" and unitID == Globals.player_id and (not dataType or dataType == "misc") then
			TRP3_API.popup.hidePopups();
			local context = getCurrentContext();
			assert(context, "No context for page player_main !");
			displayPeek(context);
		end
	end);

	-- Resizing
	TRP3_AtFirstGlanceEditorResizeButton.onResizeStop = function()
		TRP3_AtFirstGlanceEditorTextScrollText:SetSize(TRP3_AtFirstGlanceEditor:GetWidth() - 100, 10);
	end;
end
