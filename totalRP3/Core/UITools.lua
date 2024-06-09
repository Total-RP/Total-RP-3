-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type
local _, TRP3_API = ...;

TRP3_API.ui = {
	tooltip = {},
	listbox = {},
	list = {},
	misc = {},
	frame = {},
	text = {}
}

-- imports
local globals = TRP3_API.globals;
local loc = TRP3_API.loc;
local getUnitID = TRP3_API.utils.str.getUnitID;
local TRP3_Enums = AddOn_TotalRP3.Enums;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Frame utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Note: Background index is stored in profile data. Do not reorder!
local tiledBackgrounds = {
	[1] = { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 64 },
	[2] = { bgFile = "Interface\\BankFrame\\Bank-Background", tile = true, tileSize = 256 },
	[3] = { bgFile = "Interface\\FrameGeneral\\UI-Background-Marble", tile = true, tileSize = 256 },
	[4] = { bgFile = "Interface\\FrameGeneral\\UI-Background-Rock", tile = true, tileSize = 1024 },
	[5] = { bgFile = "Interface\\GuildBankFrame\\GuildVaultBG", tile = true, tileSize = 256 },
	[6] = { bgFile = "Interface\\HELPFRAME\\DarkSandstone-Tile", tile = true, tileSize = 256 },
	[7] = { bgFile = "Interface\\HELPFRAME\\Tileable-Parchment", tile = true, tileSize = 256 },
	[8] = { bgFile = "Interface\\QuestionFrame\\question-background", tile = true, tileSize = 256 },
	[9] = { bgFile = "Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg", tile = false },
	[10] = { bgFile = "Interface\\Destiny\\EndscreenBG", tile = false },
	[11] = { bgFile = "Interface\\Stationery\\AuctionStationery1", tile = false },
	[12] = { bgFile = "Interface\\Stationery\\Stationery_ill1", tile = false },
	[13] = { bgFile = "Interface\\Stationery\\Stationery_OG1", tile = false },
	[14] = { bgFile = "Interface\\Stationery\\Stationery_TB1", tile = false },
	[15] = { bgFile = "Interface\\Stationery\\Stationery_UC1", tile = false },
	[16] = { bgFile = "Interface\\Stationery\\StationeryTest1", tile = false },
	[17] = { bgFile = "Interface\\WorldMap\\UI-WorldMap-Middle1", tile = false },
	[18] = { bgFile = "Interface\\WorldMap\\UI-WorldMap-Middle2", tile = false },
	[19] = { bgFile = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground", tile = false },
	[20] = { bgFile = "interface\\adventuremap\\adventuremapparchmenttile", tile = true, tileSize = 512 },
	[21] = { bgFile = "interface\\collections\\collectionsbackgroundtile", tile = true, tileSize = 256 },
	[22] = { bgFile = "interface\\framegeneral\\uiframealliancebackground", tile = true, tileSize = 256 },
	[23] = { bgFile = "interface\\framegeneral\\uiframedragonflightbackground", tile = true, tileSize = 256 },
	[24] = { bgFile = "interface\\framegeneral\\uiframehordebackground", tile = true, tileSize = 256 },
	[25] = { bgFile = "interface\\framegeneral\\uiframekyrianbackground", tile = true, tileSize = 256 },
	[26] = { bgFile = "interface\\framegeneral\\uiframemarinebackground", tile = true, tileSize = 256 },
	[27] = { bgFile = "interface\\framegeneral\\uiframemechagonbackground", tile = true, tileSize = 256 },
	[28] = { bgFile = "interface\\framegeneral\\uiframenecrolordbackground", tile = true, tileSize = 256 },
	[29] = { bgFile = "interface\\framegeneral\\uiframeneutralbackground", tile = true, tileSize = 256 },
	[30] = { bgFile = "interface\\framegeneral\\uiframenightfaebackground", tile = true, tileSize = 256 },
	[31] = { bgFile = "interface\\framegeneral\\uiframeoribosbackground", tile = true, tileSize = 256 },
	[32] = { bgFile = "interface\\framegeneral\\uiframeventhyrbackground", tile = true, tileSize = 256 },
	[33] = { bgFile = "interface\\garrison\\classhallbackground", tile = true, tileSize = 256 },
	[34] = { bgFile = "interface\\garrison\\classhallinternalbackground", tile = true, tileSize = 256 },
	[35] = { bgFile = "interface\\garrison\\garrisonlandingpagemiddletile", tile = true, tileSize = 256 },
	[36] = { bgFile = "interface\\garrison\\garrisonmissionuiinfoboxbackgroundtile", tile = true, tileSize = 256 },
	[37] = { bgFile = "interface\\garrison\\garrisonshipmissionparchment", tile = true, tileSize = 256 },
	[38] = { bgFile = "interface\\garrison\\garrisonuibackground", tile = true, tileSize = 256 },
	[39] = { bgFile = "interface\\garrison\\garrisonuibackground2", tile = true, tileSize = 256 },
};

function TRP3_API.ui.frame.getTiledBackground(index)
	local backgroundInfo = tiledBackgrounds[index];

	if not backgroundInfo then
		backgroundInfo = tiledBackgrounds[1];
	end

	return backgroundInfo.bgFile;
end

function TRP3_API.ui.frame.setBackdropToBackground(frame, index)
	local backgroundInfo = tiledBackgrounds[index];

	if not backgroundInfo then
		backgroundInfo = tiledBackgrounds[1];
	end

	-- Applying a background retains any properties on existing backdrops and
	-- replaces those present within the background definition. Only a few
	-- keys are supported so as to not wipe out any border information.

	local backdropInfo = CreateFromMixins(frame:GetBackdrop());
	backdropInfo.bgFile = backgroundInfo.bgFile;
	backdropInfo.tile = backgroundInfo.tile;
	backdropInfo.tileSize = backgroundInfo.tileSize;

	local borderColor = TRP3_API.CreateColor(frame:GetBackdropBorderColor());
	frame:SetBackdrop(backdropInfo);
	frame:SetBackdropBorderColor(borderColor:GetRGBA());
end

function TRP3_API.ui.frame.getTiledBackgroundList()
	local tab = {};
	for index, info in ipairs(tiledBackgrounds) do
		if GetFileIDFromPath(info.bgFile) then
			tinsert(tab, {loc.UI_BKG:format(tostring(index)), index, "|T" .. info.bgFile .. ":200:200|t"});
		end
	end
	return tab;
end

function TRP3_API.ui.frame.showIfMouseOverFrame(frame, frameOver)
	assert(frame and frameOver, "Frames can't be nil");
	if MouseIsOver(frameOver) then
		frame:Show();
	else
		frame:Hide();
	end
end

function TRP3_API.ui.frame.createRefreshOnFrame(frame, time, callback)
	assert(frame and time and callback, "Argument must be not nil");
	frame.refreshTimer = 1000;
	frame:SetScript("OnUpdate", function(_, elapsed)
		frame.refreshTimer = frame.refreshTimer + elapsed;
		if frame.refreshTimer > time then
			frame.refreshTimer = 0;
			callback(frame, frame.refreshTimer);
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Drop down
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.listbox.displayDropDown(ownerRegion, rootMenuItems, onClickFunction)
	local function OnButtonClick(elementData)
		if onClickFunction then
			local value = elementData[2];
			securecallfunction(onClickFunction, value, ownerRegion);
		end
	end

	local function GenerateMenuDescription(menuItems, menuDescription)
		for _, elementData in ipairs(menuItems) do
			local text, value, tooltipText = unpack(elementData, 1, 3);
			local elementDescription;

			if text == nil or text == "" then
				elementDescription = menuDescription:CreateDivider();
			elseif value == nil then
				elementDescription = menuDescription:CreateTitle(text);
			elseif type(value) ~= "table" then
				elementDescription = menuDescription:CreateButton(text, OnButtonClick, elementData);
			else
				elementDescription = menuDescription:CreateButton(text);
			end

			if tooltipText ~= nil and tooltipText ~= "" then
				TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText);
			end

			if type(value) == "table" then
				GenerateMenuDescription(value, elementDescription);
			end
		end
	end

	local function GenerateRootMenuDescription(_, rootDescription)
		GenerateMenuDescription(rootMenuItems, rootDescription);
	end

	if TRP3_MenuUtil.CreateContextMenu(ownerRegion, GenerateRootMenuDescription) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end
end

--- Setup a drop down menu for a clickable (Button ...)
function TRP3_API.ui.listbox.setupDropDownMenu(hasClickFrame, values, callback, _, _, rightClick)
	hasClickFrame:SetScript("OnClick", function(_, button)
		if (rightClick and button ~= "RightButton") or (not rightClick and button ~= "LeftButton") then return; end
		TRP3_API.ui.listbox.displayDropDown(hasClickFrame, values, callback);
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ListBox tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Setup a ListBox. When the player choose a value, it triggers the function passing the value of the selected element
function TRP3_API.ui.listbox.setupListBox(dropdown, rootMenuItems, onClickFunction, defaultText, dropdownWidth)
	local function IsSelectedElement(elementData)
		local value = elementData[2];
		return dropdown.selectedValue == value;
	end

	local function SetSelectedElement(elementData)
		local value = elementData[2];
		dropdown:SetSelectedValue(value);
	end

	local function GenerateMenuDescription(menuItems, menuDescription)
		for _, elementData in ipairs(menuItems) do
			local text, value, tooltipText = unpack(elementData, 1, 3);
			local elementDescription;

			if text == nil or text == "" then
				elementDescription = menuDescription:CreateDivider();
			elseif value == nil then
				elementDescription = menuDescription:CreateTitle(text);
			elseif type(value) ~= "table" then
				elementDescription = menuDescription:CreateRadio(text, IsSelectedElement, SetSelectedElement, elementData);
			else
				elementDescription = menuDescription:CreateButton(text);
			end

			if tooltipText ~= nil and tooltipText ~= "" then
				TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText);
			end

			if type(value) == "table" then
				GenerateMenuDescription(value, elementDescription);
			end
		end
	end

	local function GenerateRootMenuDescription(_, rootDescription)
		if dropdownWidth then
			rootDescription:SetMinimumWidth(dropdownWidth);
		end

		GenerateMenuDescription(rootMenuItems, rootDescription);
	end

	function dropdown:GetSelectedValue()
		return self.selectedValue;
	end

	function dropdown:SetSelectedValue(value)
		self.selectedValue = value;
		self:Update();

		if onClickFunction then
			securecallfunction(onClickFunction, value, dropdown);
		end
	end

	function dropdown:SetSelectedIndex(index)
		local value = rootMenuItems[index] and rootMenuItems[index][2] or nil;
		self:SetSelectedValue(value);
	end

	dropdown:SetDefaultText(defaultText or loc.CM_UNKNOWN);
	dropdown:SetupMenu(GenerateRootMenuDescription);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Handle the mouse wheel for the frame in order to slide the slider
TRP3_API.ui.list.handleMouseWheel = function(frame, slider)
	frame:SetScript("OnMouseWheel",function(_, delta)
		if slider:IsEnabled() then
			local mini,maxi = slider:GetMinMaxValues();
			if delta == 1 and slider:GetValue() > mini then
				slider:SetValue(slider:GetValue()-1);
			elseif delta == -1 and slider:GetValue() < maxi then
				slider:SetValue(slider:GetValue()+1);
			end
		end
	end);
	frame:EnableMouseWheel(1);
end

local function listShowPage(infoTab, pageNum)
	assert(infoTab.uiTab, "Error : no uiTab in infoTab.");

	-- Hide all widgets
	for k=1,infoTab.maxPerPage do
		infoTab.widgetTab[k]:Hide();
	end

	-- Show list
	for widgetIndex=1, infoTab.maxPerPage do
		local dataIndex = pageNum*infoTab.maxPerPage + widgetIndex;
		if dataIndex <= #infoTab.uiTab then
			infoTab.widgetTab[widgetIndex]:Show();
			infoTab.decorate(infoTab.widgetTab[widgetIndex], infoTab.uiTab[dataIndex]);
		else
			break;
		end
	end
end

-- Init a list.
-- Arguments :
-- 		infoTab, a structure containing :
-- 			- A widgetTab (the list of all widget used in a full page)
-- 			- A decorate function, which will receive 3 arguments : a widget and an ID. Decorate will be called on every couple "widget from widgetTab" and "id from dataTab".
--- 	dataTab, all the possible values
--- 	slider, the slider :3
TRP3_API.ui.list.initList = function(infoTab, dataTab, slider)
	assert(infoTab and dataTab and slider, "Error : no argument can be nil.");
	assert(infoTab.widgetTab, "Error : no widget tab in infoTab.");
	assert(infoTab.decorate, "Error : no decorate function in infoTab.");

	local maxPerPage = #infoTab.widgetTab;
	infoTab.maxPerPage = maxPerPage;

	if not infoTab.uiTab then
		infoTab.uiTab = {};
	end

	slider:Disable();
	slider:SetValueStep(1);
	slider:SetObeyStepOnDrag(true);
	wipe(infoTab.uiTab);

	if type(dataTab) == "table" then
		for key,_ in pairs(dataTab) do
			tinsert(infoTab.uiTab, key);
		end
	else
		for i=1, dataTab, 1 do
			tinsert(infoTab.uiTab, i);
		end
	end
	local count = #infoTab.uiTab;

	table.sort(infoTab.uiTab);

	local checkUpDown = function(self)
		local minValue, maxValue = self:GetMinMaxValues();
		local value = self:GetValue();
		if self.downButton then
			self.downButton:Disable();
			if value < maxValue then
				self.downButton:Enable();
			end
		end
		if self.upButton then
			self.upButton:Disable();
			if value > minValue then
				self.upButton:Enable();
			end
		end
	end

	slider:SetScript("OnValueChanged", nil);
	if count > maxPerPage then
		slider:Enable();
		local total = floor((count-1)/maxPerPage);
		slider:SetMinMaxValues(0, total);
	else
		slider:SetMinMaxValues(0, 0);
		slider:SetValue(0);
	end
	checkUpDown(slider);
	slider:SetScript("OnValueChanged",function(self)
		if self:IsVisible() then
			listShowPage(infoTab, floor(self:GetValue()));
			checkUpDown(self);
		end
	end);
	listShowPage(infoTab, slider:GetValue());
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tooltip tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local getConfigValue = function() end;

-- Show the tooltip for this Frame (the frame must have been set up with setTooltipForFrame).
-- If already shown, the tooltip text will be refreshed.
local function refreshTooltip(Frame)
	if Frame.titleText and Frame.GenFrame and Frame.GenFrameX and Frame.GenFrameY and Frame.GenFrameAnch then
		TRP3_MainTooltip:SetOwner(Frame.GenFrame, Frame.GenFrameAnch, Frame.GenFrameX, Frame.GenFrameY);
		GameTooltip_SetTitle(TRP3_MainTooltip, Frame.titleText);

		if Frame.bodyText then
			GameTooltip_AddNormalLine(TRP3_MainTooltip, Frame.bodyText, true);
		end

		TRP3_MainTooltip:Show();
	end
end
TRP3_API.ui.tooltip.refresh = refreshTooltip;
TRP3_RefreshTooltipForFrame = refreshTooltip; -- For XML integration without too much perf' issue

local function tooltipSimpleOnEnter(self)
	refreshTooltip(self);
end

local function tooltipSimpleOnLeave()
	TRP3_MainTooltip:Hide();
end

-- Setup the frame tooltip (position and text)
-- The tooltip can be shown by using refreshTooltip(Frame)
local function setTooltipForFrame(Frame, GenFrame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	assert(Frame and GenFrame, "Frame and GenFrame cannot be nil.");
	if Frame and GenFrame then
		Frame.GenFrame = GenFrame;
		Frame.GenFrameX = GenFrameX;
		Frame.GenFrameY = GenFrameY;
		Frame.titleText = titleText;
		Frame.bodyText = bodyText;
		Frame.rightText = rightText;
		if GenFrameAnch then
			Frame.GenFrameAnch = "ANCHOR_"..GenFrameAnch;
		else
			Frame.GenFrameAnch = "ANCHOR_RIGHT";
		end
	end
end
TRP3_API.ui.tooltip.setTooltipForFrame = setTooltipForFrame;

-- Setup the frame tooltip (position and text)
-- The tooltip can be shown by using refreshTooltip(Frame)
TRP3_API.ui.tooltip.setTooltipForSameFrame = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

-- Setup the frame tooltip and add the Enter and Leave scripts
TRP3_API.ui.tooltip.setTooltipAll = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	Frame:SetScript("OnEnter", tooltipSimpleOnEnter);
	Frame:SetScript("OnLeave", tooltipSimpleOnLeave);
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion ID
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TODO (10.0): Remove the following backwards compatibility aliases.
TRP3_API.ui.misc.TYPE_CHARACTER = TRP3_Enums.UNIT_TYPE.CHARACTER;
TRP3_API.ui.misc.TYPE_PET = TRP3_Enums.UNIT_TYPE.PET;
TRP3_API.ui.misc.TYPE_BATTLE_PET = TRP3_Enums.UNIT_TYPE.BATTLE_PET;
TRP3_API.ui.misc.TYPE_MOUNT = TRP3_Enums.UNIT_TYPE.MOUNT;
TRP3_API.ui.misc.TYPE_NPC = TRP3_Enums.UNIT_TYPE.NPC;

function TRP3_API.ui.misc.isTargetTypeACompanion(unitType)
	return unitType == TRP3_Enums.UNIT_TYPE.BATTLE_PET or unitType == TRP3_Enums.UNIT_TYPE.PET;
end

local function IsBattlePetUnit(unitToken)
	if UnitIsBattlePetCompanion then
		return UnitIsBattlePetCompanion(unitToken);
	end

	-- Fallback for Classic; we can approximate companion pets with the
	-- following API tests.

	if not UnitPlayerControlled(unitToken) then
		return false;
	end

	local unitGUID = UnitGUID(unitToken);
	local guidType, _, _, _, _, creatureID = string.split("-", unitGUID or "", 7);

	return guidType == "Creature" and TRP3_API.utils.resources.IsPetCreature(tonumber(creatureID));
end

local function IsPetUnit(unitToken)
	if UnitPlayerControlled(unitToken) and UnitCreatureFamily(unitToken) ~= nil then
		return true;
	elseif not TRP3_ClientFeatures.WaterElementalWorkaround then
		return false;
	end

	-- Classic Wrath seems to dispute the idea that Mages' Water Elementals
	-- are pets, and they report nil for UnitCreatureFamily too. For these
	-- clients we'll just hardcode the creature ID and be done with it.

	local unitGUID = UnitGUID(unitToken);
	local guidType, _, _, _, _, creatureID = string.split("-", unitGUID or "", 7);

	return guidType == "Creature" and (creatureID == "510" or creatureID == "37994");
end

---
-- Returns target type as first return value and boolean isMine as second.
function TRP3_API.ui.misc.getTargetType(unitType)
	if UnitIsPlayer(unitType) then
		return TRP3_Enums.UNIT_TYPE.CHARACTER, getUnitID(unitType) == globals.player_id;
	elseif IsBattlePetUnit(unitType) then
		return TRP3_Enums.UNIT_TYPE.BATTLE_PET, UnitIsOwnerOrControllerOfUnit("player", unitType);
	elseif IsPetUnit(unitType) then
		return TRP3_Enums.UNIT_TYPE.PET, UnitIsOwnerOrControllerOfUnit("player", unitType);
	end
	if TRP3_API.utils.str.getUnitNPCID(unitType) then
		return TRP3_Enums.UNIT_TYPE.NPC, false;
	end
end

local ScanningTooltip = CreateFrame("GameTooltip", "TRP3_ScanningTooltip", nil, "GameTooltipTemplate");

local COMBAT_PET_OWNER_PATTERNS;
local COMPANION_PET_OWNER_PATTERNS;

do
	local function GenerateDeformattingPattern(text)
		-- For French locales the "|2" needs to match both "de <name>" and
		-- "d'<name>".
		--
		-- Additionally for UNITNAME_TITLE_COMPANION specifically, the
		-- generated pattern is ambiguous with the template used for the
		-- pet type and level line. This is avoided by making the match
		-- pattern refuse to match spaces _and_ including start/end anchors.

		text = string.gsub(text, "%%s", "([^%%s]+)");
		text = string.gsub(text, "|2 ", "d[e'] ?");
		return "^" .. text .. "$";
	end

	COMBAT_PET_OWNER_PATTERNS =
	{
		GenerateDeformattingPattern(UNITNAME_TITLE_CHARM),
		GenerateDeformattingPattern(UNITNAME_TITLE_CREATION),
		GenerateDeformattingPattern(UNITNAME_TITLE_GUARDIAN),
		GenerateDeformattingPattern(UNITNAME_TITLE_MINION),
		GenerateDeformattingPattern(UNITNAME_TITLE_PET),
	};

	COMPANION_PET_OWNER_PATTERNS =
	{
		GenerateDeformattingPattern(UNITNAME_TITLE_COMPANION),
		GenerateDeformattingPattern(UNITNAME_TITLE_SQUIRE),
	};
end

function ScanningTooltip:GetLeftLineText(lineNumber)
	local region = _G[self:GetName() .. "TextLeft" .. lineNumber];
	return region and region:GetText() or "";
end

function ScanningTooltip:FindMatchingLine(patternList)
	for lineNumber = 1, self:NumLines() do
		local leftText = self:GetLeftLineText(lineNumber);

		for _, pattern in ipairs(patternList) do
			local ownerName = string.match(leftText or "", pattern);

			if ownerName then
				return ownerName;
			end
		end
	end

	return nil;
end

local function getCompanionOwner(unitType, targetType)
	local ownerName;
	local ownerRealm;

	if C_TooltipInfo then
		local tooltipData = C_TooltipInfo.GetUnit(unitType);
		local ownerGUID;

		if not tooltipData then
			return;
		end

		for _, line in ipairs(tooltipData.lines) do
			if line.type == Enum.TooltipDataLineType.UnitOwner then
				ownerGUID = line.guid;
				break;
			end
		end

		if ownerGUID ~= nil then
			ownerName, ownerRealm = select(6, GetPlayerInfoByGUID(ownerGUID));
		end
	else
		-- TODO: Remove the old tooltip scanning stuff in 3.4.2.
		ScanningTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
		ScanningTooltip:SetUnit(unitType);
		ScanningTooltip:Show();

		if targetType == TRP3_Enums.UNIT_TYPE.PET then
			ownerName = ScanningTooltip:FindMatchingLine(COMBAT_PET_OWNER_PATTERNS);
		elseif targetType == TRP3_Enums.UNIT_TYPE.BATTLE_PET then
			ownerName = ScanningTooltip:FindMatchingLine(COMPANION_PET_OWNER_PATTERNS);
		end

		ScanningTooltip:Hide();
	end

	if not ownerName or ownerName == "" or ownerName == UNKNOWNOBJECT then
		return nil;
	elseif not ownerRealm or ownerRealm == "" then
		return ownerName;
	else
		return string.join("-", ownerName, ownerRealm);
	end
end
TRP3_API.ui.misc.getCompanionOwner = getCompanionOwner;

function TRP3_API.ui.misc.getCompanionShortID(unitToken, unitType)
	local shortID = UnitName(unitToken);

	if not C_PetJournal and unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.BATTLE_PET then
		-- Classic: Companions can't be renamed nor can their names be
		-- localized ahead of summoning, so we don't use the unit name but
		-- instead tie their short IDs to a name inferred from how they're
		-- summoned.

		local unitGUID = UnitGUID(unitToken);
		local creatureID = tonumber((select(6, string.split("-", unitGUID or "", 7))));
		shortID = TRP3_API.utils.resources.GetPetNameByCreatureID(creatureID);
	end

	return shortID;
end

function TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType)
	local shortID = TRP3_API.ui.misc.getCompanionShortID(unitToken, unitType);

	if shortID then
		local owner = getCompanionOwner(unitToken, unitType);
		if owner ~= nil then
			if not owner:find("-") then
				owner = owner .. "-" .. globals.player_realm_id;
			end
			return owner .. "_" .. shortID, owner;
		end
	end
	return nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toast
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function toastUpdate(self, elapsed)
	self.delay = self.delay - elapsed;
	if self.delay <= 0 and not self.isFading then
		self.isFading = true;
		self:FadeOut();
	end
end

TRP3_Toast.delay = 0;
TRP3_Toast:SetScript("OnUpdate", toastUpdate);

function TRP3_API.ui.tooltip.toast(text, duration)
	TRP3_Toast:SetOwner(TRP3_MainFramePageContainer, "ANCHOR_BOTTOM", 0, 60);
	GameTooltip_AddHighlightLine(TRP3_Toast, text, true);
	TRP3_Toast:Show();
	TRP3_Toast.delay = duration or 3;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

---@param icon string|EllybTexture
function TRP3_API.ui.frame.setupIconButton(self, icon)
	assert(self, "Frame is nil");
	assert(self.Icon or (self:GetName() and _G[self:GetName() .. "Icon"]), "Frame must have a Icon");

	---@type Texture
	local iconWidget = (self.Icon or _G[self:GetName() .. "Icon"]);
	if type(icon) == "table" and icon.Apply then
		icon:Apply(iconWidget);
	else
		iconWidget:SetTexture("Interface\\ICONS\\" .. icon);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Editboxes
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.frame.setupEditBoxesNavigation(tabEditBoxes)
	local maxBound = # tabEditBoxes;
	local minBound = 1;
	for index, editbox in pairs(tabEditBoxes) do
		editbox:SetScript("OnTabPressed", function()
			local cursor = index
			if IsShiftKeyDown() then
				if cursor == minBound then
					cursor = maxBound
				else
					cursor = cursor -1
				end
			else
				if cursor == maxBound then
					cursor = minBound
				else
					cursor = cursor + 1
				end
			end
			tabEditBoxes[cursor]:SetFocus();
		end)
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tab bar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabBar_index = 0;

local function tabBar_onSelect(tabGroup, index)
	assert(#tabGroup.tabs >= index, "Index out of bound.");
	for i=1, #tabGroup.tabs do
		local widget = tabGroup.tabs[i];
		if i == index then
			widget:SetTabSelected(true);
			tabGroup.current = index;
		else
			widget:SetTabSelected(false);
		end
	end
end

local function tabBar_redraw(tabGroup)
	local lastWidget;
	for _, tabWidget in pairs(tabGroup.tabs) do
		if tabWidget:IsShown() then
			tabWidget:ClearAllPoints();
			if lastWidget == nil then
				tabWidget:SetPoint("LEFT", 0, 0);
			else
				tabWidget:SetPoint("LEFT", lastWidget, "RIGHT", 2, 0);
			end
			lastWidget = tabWidget;
		end
	end
end

local function tabBar_size(tabGroup)
	return #tabGroup.tabs;
end

local function tabBar_setTabVisible(tabGroup, index, isVisible)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	if isVisible then
		tabGroup.tabs[index]:Show();
	else
		tabGroup.tabs[index]:Hide();
	end
	tabGroup:Redraw();
end

local function tabBar_setAllTabsVisible(tabGroup, isVisible)
	for index=1, #tabGroup.tabs do
		if isVisible then
			tabGroup.tabs[index]:Show();
		else
			tabGroup.tabs[index]:Hide();
		end
	end
	tabGroup:Redraw();
end

local function tabBar_selectTab(tabGroup, index)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	assert(tabGroup.tabs[index]:IsShown(), "Try to select a hidden tab.");
	ExecuteFrameScript(tabGroup.tabs[index], "OnClick");
end

function TRP3_API.ui.frame.createTabPanel(tabBar, data, callback, confirmCallback)
	assert(tabBar, "The tabBar can't be nil");

	local tabGroup = {};
	tabGroup.tabs = {};
	for index, tabData in pairs(data) do
		local text = tabData[1];
		local value = tabData[2];
		local width = tabData[3];
		local tabWidget = CreateFrame("Button", "TRP3_TabBar_Tab_" .. tabBar_index, tabBar, "TRP3_TabButtonTemplate");
		tabWidget:SetText(text);
		tabWidget:SetWidth(width or (text:len() * 11));
		local clickFunction = function()
			tabBar_onSelect(tabGroup, index);
			if callback then
				callback(tabWidget, value);
			end
		end
		tabWidget:SetScript("OnClick", function()
			if not confirmCallback then
				clickFunction();
			else
				confirmCallback(function() clickFunction() end);
			end
			TRP3_API.ui.misc.playUISound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
		end);
		tinsert(tabGroup.tabs, tabWidget);
		tabBar_index = tabBar_index + 1;
	end

	tabGroup.Redraw = tabBar_redraw;
	tabGroup.Size = tabBar_size;
	tabGroup.SetTabVisible = tabBar_setTabVisible;
	tabGroup.SelectTab = tabBar_selectTab;
	tabGroup.SetAllTabsVisible = tabBar_setAllTabsVisible;
	tabGroup:Redraw();

	return tabGroup;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Textures tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.ui.misc.getUnitTexture = function(race, gender)
	local raceToken = race;
	local genderToken = (gender == 3) and "Female" or "Male";

	return TRP3_InterfaceIcons[raceToken .. genderToken] or TRP3_InterfaceIcons.Default;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Text toolbar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TAGS_INFO = {
	{
		openTags = {"{h1}", "{h1:c}", "{h1:r}"},
		closeTag = "{/h1}",
	},
	{
		openTags = {"{h2}", "{h2:c}", "{h2:r}"},
		closeTag = "{/h2}",
	},
	{
		openTags = {"{h3}", "{h3:c}", "{h3:r}"},
		closeTag = "{/h3}",
	},
	{
		openTags = {"{p:c}", "{p:r}"},
		closeTag = "{/p}",
	}
}

local function insertTag(tag, index, frame)
	local text = frame:GetText();
	local pre = text:sub(1, index);
	local post = text:sub(index + 1);
	text = strconcat(pre, tag, post);
	frame:SetText(text);
end

local function postInsertHighlight(index, tagSize, textSize, frame)
	frame:SetCursorPosition(index + tagSize + textSize);
	frame:HighlightText(index + tagSize, index + tagSize + textSize);
	frame:SetFocus();
end

local function insertContainerTag(alignIndex, button, frame)
	assert(button.tagIndex and TAGS_INFO[button.tagIndex], "Button is not properly init with a tag index");
	local tagInfo = TAGS_INFO[button.tagIndex];
	local cursorIndex = frame:GetCursorPosition();
	insertTag(strconcat(tagInfo.openTags[alignIndex], loc.REG_PLAYER_ABOUT_T1_YOURTEXT, tagInfo.closeTag), cursorIndex, frame);
	postInsertHighlight(cursorIndex, tagInfo.openTags[alignIndex]:len(), loc.REG_PLAYER_ABOUT_T1_YOURTEXT:len(), frame);
end

local function onColorTagSelected(red, green, blue, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{col:%s}"):format(TRP3_API.CreateColorFromBytes(red, green, blue):GenerateHexColorOpaque());
	insertTag(tag .. "{/col}", cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
	frame:SetFocus();
end

local function onIconTagSelected(icon, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{icon:%s:25}"):format(icon);
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
	frame:SetFocus();
end

local function onImageTagSelected(image, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{img:%s:%s:%s}"):format(image.url, math.min(image.width, 512), math.min(image.height, 512));
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
	frame:SetFocus();
end

local function onLinkTagClicked(frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{link*%s*%s}"):format(loc.UI_LINK_URL, loc.UI_LINK_TEXT);
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + 6);
	frame:HighlightText(cursorIndex + 6, cursorIndex + 6 + loc.UI_LINK_URL:len());
	frame:SetFocus();
end

-- Drop down
local function onContainerTagClicked(button, frame, isP)
	local values = {};
	if not isP then
		tinsert(values, {loc.REG_PLAYER_ABOUT_HEADER});
		tinsert(values, {loc.CM_LEFT, 1});
		tinsert(values, {loc.CM_CENTER, 2});
		tinsert(values, {loc.CM_RIGHT, 3});
	else
		tinsert(values, {loc.REG_PLAYER_ABOUT_P});
		tinsert(values, {loc.CM_CENTER, 1});
		tinsert(values, {loc.CM_RIGHT, 2});
	end
	TRP3_API.ui.listbox.displayDropDown(button, values, function(alignIndex, mouseButton)
		insertContainerTag(alignIndex, mouseButton, frame);
	end);
end

function TRP3_API.ui.text.setupToolbar(toolbar, textFrame, parentFrame, point, parentPoint)
	toolbar.title:SetText(loc.REG_PLAYER_ABOUT_TAGS);
	toolbar.image:SetText(loc.CM_IMAGE);
	toolbar.icon:SetText(loc.CM_ICON);
	toolbar.color:SetText(loc.CM_COLOR);
	toolbar.link:SetText(loc.CM_LINK);
	toolbar.textFrame = textFrame;
	toolbar.h1.tagIndex = 1;
	toolbar.h2.tagIndex = 2;
	toolbar.h3.tagIndex = 3;
	toolbar.p.tagIndex = 4;
	toolbar.h1:SetScript("OnClick", function(button) if toolbar.textFrame then onContainerTagClicked(button, toolbar.textFrame) end end);
	toolbar.h2:SetScript("OnClick", function(button) if toolbar.textFrame then onContainerTagClicked(button, toolbar.textFrame) end end);
	toolbar.h3:SetScript("OnClick", function(button) if toolbar.textFrame then onContainerTagClicked(button, toolbar.textFrame) end end);
	toolbar.p:SetScript("OnClick", function(button) if toolbar.textFrame then onContainerTagClicked(button, toolbar.textFrame, true) end end);
	toolbar.icon:SetScript("OnClick", function()
		if toolbar.textFrame then
			TRP3_API.popup.showPopup(
				TRP3_API.popup.ICONS,
				{parent = parentFrame, point = point, parentPoint = parentPoint},
				{function(icon) onIconTagSelected(icon, toolbar.textFrame) end});
		end
	end);
	toolbar.color:SetScript("OnClick", function()
		if toolbar.textFrame then
			if IsShiftKeyDown() or (getConfigValue and getConfigValue("default_color_picker")) then
				TRP3_API.popup.showDefaultColorPicker({function(red, green, blue) onColorTagSelected(red, green, blue, toolbar.textFrame) end});
			else
				TRP3_API.popup.showPopup(
					TRP3_API.popup.COLORS,
					{parent = parentFrame, point = point, parentPoint = parentPoint},
					{function(red, green, blue) onColorTagSelected(red, green, blue, toolbar.textFrame) end});
			end
		end
	end);
	toolbar.image:SetScript("OnClick", function()
		if toolbar.textFrame then
			TRP3_API.popup.showPopup(
				TRP3_API.popup.IMAGES,
				{parent = parentFrame, point = point, parentPoint = parentPoint},
				{function(image) onImageTagSelected(image, toolbar.textFrame) end});
		end
	end);
	toolbar.link:SetScript("OnClick", function() if toolbar.textFrame then onLinkTagClicked(toolbar.textFrame) end end);
end

function TRP3_API.ui.text.changeToolbarTextFrame(toolbar, textFrame)
	toolbar.textFrame = textFrame;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Sounds
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.misc.playUISound(pathToSound, url)
	if url then
		PlaySoundFile(pathToSound, "SFX");
	else
		PlaySound(pathToSound,"SFX");
	end
end

function TRP3_API.ui.misc.playSoundKit(soundID, channel)
	local _, handlerID = PlaySound(soundID, channel or "SFX");
	return handlerID;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function playAnimation(animationGroup, callback)
	animationGroup:Stop();
	animationGroup:Play();
	if callback then
		animationGroup:SetScript("OnFinished", callback)
	end
end
TRP3_API.ui.misc.playAnimation = playAnimation;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Hovered frames
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.frame.configureHoverFrame(frame, hoveredFrame, arrowPosition, x, y, noStrataChange, parent)
	x = x or 0;
	y = y or 0;
	frame:ClearAllPoints();
	if not noStrataChange then
		frame:SetParent(parent or hoveredFrame:GetParent());
		frame:SetFrameStrata("HIGH");
	else
		frame:SetParent(parent or hoveredFrame);
		frame:Raise();
	end
	frame.ArrowRIGHT:Hide();
	frame.ArrowUP:Hide();
	frame.ArrowDOWN:Hide();
	frame.ArrowLEFT:Hide();

	local animation;

	if arrowPosition == "RIGHT" then
		frame:SetPoint("RIGHT", hoveredFrame, "LEFT", -10 + x, 0 + y);
		frame.ArrowLEFT:Show();
		animation = "showAnimationFromRight";
	elseif arrowPosition == "LEFT" then
		frame:SetPoint("LEFT", hoveredFrame, "RIGHT", 10 + x, 0 + y);
		frame.ArrowRIGHT:Show();
		animation = "showAnimationFromLeft";
	elseif arrowPosition == "TOP" then
		frame:SetPoint("TOP", hoveredFrame, "BOTTOM", 0 + x, -20 + y);
		frame.ArrowDOWN:Show();
		animation = "showAnimationFromTop";
	elseif arrowPosition == "BOTTOM" then
		frame:SetPoint("BOTTOM", hoveredFrame, "TOP", 0 + x, 20 + y);
		frame.ArrowUP:Show();
		animation = "showAnimationFromBottom";
	else
		frame:SetPoint("CENTER", hoveredFrame, "CENTER", 0 + x, 0 + y);
	end

	frame:Show();

	if frame[animation] then
		playAnimation(frame[animation]);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Resize button
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local resizeShadowFrame = TRP3_ResizeShadowFrame;

function TRP3_API.ui.frame.initResize(resizeButton)
	resizeButton.resizableFrame = resizeButton.resizableFrame or resizeButton:GetParent();
	assert(resizeButton.minWidth, "minWidth key is not set.");
	assert(resizeButton.minHeight, "minHeight key is not set.");
	TRP3_API.ui.tooltip.setTooltipAll(resizeButton, "BOTTOMLEFT", 0, 0, loc.CM_RESIZE, loc.CM_RESIZE_TT);
	local parentFrame = resizeButton.resizableFrame;
	resizeButton:RegisterForDrag("LeftButton");
	resizeButton:SetScript("OnDragStart", function(self)
		if not self.onResizeStart or not self.onResizeStart() then
			resizeShadowFrame.minWidth = self.minWidth;
			resizeShadowFrame.minHeight = self.minHeight;
			resizeShadowFrame:ClearAllPoints();
			resizeShadowFrame:SetPoint("CENTER", self.resizableFrame, "CENTER", 0, 0);
			resizeShadowFrame:SetWidth(parentFrame:GetWidth());
			resizeShadowFrame:SetHeight(parentFrame:GetHeight());
			resizeShadowFrame:Show();
			resizeShadowFrame:StartSizing();
			parentFrame.isSizing = true;
		end
	end);
	resizeButton:SetScript("OnDragStop", function(self)
		if parentFrame.isSizing then
			resizeShadowFrame:StopMovingOrSizing();
			parentFrame.isSizing = false;
			local height, width = resizeShadowFrame:GetHeight(), resizeShadowFrame:GetWidth()
			resizeShadowFrame:Hide();
			if height < self.minHeight then
				height = self.minHeight;
			end
			if width < self.minWidth then
				width = self.minWidth;
			end
			parentFrame:SetSize(width, height);
			if self.onResizeStop then
				C_Timer.After(0.1, function()
					self.onResizeStop(width, height);
				end);
			end
		end
	end);
end

local VALID_SIZE_COLOR = TRP3_API.Colors.Green;
local INVALID_SIZE_COLOR = TRP3_API.Colors.Red;
resizeShadowFrame:SetScript("OnUpdate", function(self)
	local height, width = self:GetHeight(), self:GetWidth();
	local heightColor, widthColor = VALID_SIZE_COLOR, VALID_SIZE_COLOR;
	if height < self.minHeight then
		heightColor = INVALID_SIZE_COLOR;
	end
	if width < self.minWidth then
		widthColor = INVALID_SIZE_COLOR;
	end
	resizeShadowFrame.text:SetText(widthColor(math.ceil(width)) .. " x " .. heightColor(math.ceil(height)));
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Move frame
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.frame.setupMove(frame)
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
	end)
end
