--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.target = {};

-- imports
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local tsize = Utils.table.size;
local loc = TRP3_API.locale.getText;
local ui_TargetFrame, ui_TargetFrameGlance = TRP3_TargetFrame, TRP3_TargetFrameGlance;
local UnitName, CreateFrame, UnitIsPlayer = UnitName, CreateFrame, UnitIsPlayer;
local EMPTY = Globals.empty;
local isPlayerIC, isUnitIDKnown;
local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
local assert, pairs, tContains, tinsert, table, math, _G, tostring, type = assert, pairs, tContains, tinsert, table, math, _G, tostring, type;
local getUnitID, unitIDToInfo, companionIDToInfo = Utils.str.getUnitID, Utils.str.unitIDToInfo, Utils.str.companionIDToInfo;
local setTooltipForSameFrame, mainTooltip, refreshTooltip = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_MainTooltip, TRP3_RefreshTooltipForFrame;
local get, getDataDefault = TRP3_API.profile.getData, TRP3_API.profile.getDataDefault;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local getUnitIDCurrentProfile;
local buttonContainer = TRP3_TargetFrame;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getMiscPresetDropListData, setGlanceSlotPreset, setCompanionGlanceSlotPreset;
local hasProfile, isIDIgnored;
local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
local getCompanionRegisterProfile, getCompanionProfile, companionHasProfile;
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;

local CONFIG_TARGET_USE = "target_use";
local CONFIG_CONTENT_PREFIX = "target_content_";

local currentTargetID, currentTargetType, isCurrentMine = nil, nil, nil;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Buttons logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local targetButtons = {};
local uiButtons = {};
local marginLeft = 10;
local loaded = false;

local function createButton(index)
	local uiButton = CreateFrame("Button", "TRP3_TargetFrameButton"..index, buttonContainer, "TRP3_TargetFrameButton");
	uiButton:ClearAllPoints();
	uiButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	uiButton:SetScript("OnEnter", function(self)
		refreshTooltip(self);
	end);
	uiButton:SetScript("OnLeave", function()
		mainTooltip:Hide();
	end);
	uiButton:SetScript("OnClick", function(self, button)
		if self.onClick then
			self.onClick(self.unitID, self.targetType, button, self);
		end
	end);
	return uiButton;
end

local function displayButtonsPanel()
	local buttonSize = 30;

	--Hide all
	for _,uiButton in pairs(uiButtons) do
		uiButton:Hide();
	end

	-- Test which buttons to show
	local ids = {};
	for id, buttonStructure in pairs(targetButtons) do
		if buttonStructure.visible and
		(not buttonStructure.condition or buttonStructure.condition(currentTargetType, currentTargetID)) and
		(not buttonStructure.onlyForType or buttonStructure.onlyForType == currentTargetType) then
			tinsert(ids, id);
		end
	end
	table.sort(ids);

	local index = 0;
	local x = marginLeft;

	for i, id in pairs(ids) do
		local buttonStructure = targetButtons[id];
		local uiButton = uiButtons[index+1];
		-- Create the button
		if uiButton == nil then
			uiButton = createButton(index);
			tinsert(uiButtons, uiButton);
		end

		if buttonStructure.adapter then
			buttonStructure.adapter(buttonStructure, currentTargetID, currentTargetType);
		end

		uiButton:SetNormalTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:SetPushedTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:GetPushedTexture():SetDesaturated(1);
		uiButton:SetPoint("TOPLEFT", x, -12);
		uiButton:SetWidth(buttonSize);
		uiButton:SetHeight(buttonSize);
		uiButton:Show();
		uiButton.buttonId = id;
		uiButton.onClick = buttonStructure.onClick;
		uiButton.unitID = currentTargetID;
		uiButton.targetType = currentTargetType;
		if buttonStructure.tooltip then
			setTooltipForSameFrame(uiButton, "TOP", 0, 5, buttonStructure.tooltip, buttonStructure.tooltipSub);
		else
			setTooltipForSameFrame(uiButton);
		end

		local uiAlert = _G[uiButton:GetName() .. "Alert"];
		uiAlert:Hide();
		if buttonStructure.alert and buttonStructure.alertIcon then
			uiAlert:Show();
			uiAlert:SetWidth(buttonSize / 1.7);
			uiAlert:SetHeight(buttonSize / 1.7);
			uiAlert:SetTexture(buttonStructure.alertIcon);
		end

		index = index + 1;
		x = x + buttonSize + 2;
	end

	buttonContainer:SetWidth(math.max(20 + index * buttonSize, 200));
	buttonContainer:SetHeight(buttonSize + 25);
end

local function registerButton(targetButton)
	assert(not loaded, "All button must be registered on addon load. You're too late !");
	assert(targetButton and targetButton.id, "Usage: button structure containing 'id' field");
	assert(not targetButtons[targetButton.id], "Already registered button id: " .. targetButton.id);
	targetButtons[targetButton.id] = targetButton;
end
TRP3_API.target.registerButton = registerButton;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Display logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPeekSelection(value, button)
	if value then
		if currentTargetType == TYPE_CHARACTER then
			setGlanceSlotPreset(button.slot, value);
		else
			setCompanionGlanceSlotPreset(button.slot, value, currentTargetID);
		end
	end
end

local function onPeekClickMine(button)
	displayDropDown(button, getMiscPresetDropListData(), function(value) onPeekSelection(value, button) end, 0, true);
end

local function getCharacterInfo()
	if currentTargetID == Globals.player_id then
		return get("player") or EMPTY;
	elseif isUnitIDKnown(currentTargetID) and hasProfile(currentTargetID) then
		return getUnitIDCurrentProfile(currentTargetID) or EMPTY;
	end
	return EMPTY;
end

local function getCompanionInfo(owner, companionID, currentTargetID)
	local profile;
	if owner == Globals.player_id then
		profile = getCompanionProfile(companionID) or EMPTY;
	else
		profile = getCompanionRegisterProfile(currentTargetID);
	end
	return profile;
end

local function atLeastOneactivePeek(tab)
	for i, info in pairs(tab) do
		if type(info) == "table" and info.AC then
			return true;
		end
	end
	return false;
end

local function displayPeekSlots()
	ui_TargetFrameGlance:Hide();
	local peekTab = nil;

	if currentTargetType == TYPE_CHARACTER then
		peekTab = getDataDefault("misc/PE", EMPTY, getCharacterInfo());
	elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
		local owner, companionID = companionIDToInfo(currentTargetID);
		peekTab = getCompanionInfo(owner, companionID, currentTargetID).PE;
	end

	if (isCurrentMine and peekTab ~= nil) or (not isCurrentMine and peekTab ~= nil and atLeastOneactivePeek(peekTab)) then
		ui_TargetFrameGlance:Show();
		for i=1,5,1 do
			local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
			local peek = peekTab[tostring(i)];

			local icon = Globals.icons.default;

			if peek and peek.AC then
				slot:SetAlpha(1);
				if peek.IC and peek.IC:len() > 0 then
					icon = peek.IC;
				end
				setTooltipForSameFrame(slot, "LEFT", 0, 0, Utils.str.icon(icon, 30) .. " " .. (peek.TI or "..."), peek.TX);
			else
				slot:SetAlpha(0.25);
				setTooltipForSameFrame(slot);
			end

			Utils.texture.applyRoundTexture("TRP3_TargetFrameGlanceSlot"..i.."Image", "Interface\\ICONS\\" .. icon);

			if isCurrentMine then
				slot:SetScript("OnClick", onPeekClickMine);
			else
				slot:SetScript("OnClick", nil);
			end
		end
	end
end

local TARGET_NAME_WIDTH = 168;

local function displayTargetName()
	if currentTargetType == TYPE_CHARACTER then
		local info = getCharacterInfo(currentTargetID);
		local name, realm = unitIDToInfo(currentTargetID);
		if info.characteristics then
			setupFieldSet(ui_TargetFrame, (info.characteristics.FN or name) .. " " .. (info.characteristics.LN or ""), TARGET_NAME_WIDTH);
		else
			setupFieldSet(ui_TargetFrame, name, TARGET_NAME_WIDTH);
		end
	elseif currentTargetType == TYPE_PET or currentTargetType == TYPE_BATTLE_PET then
		local owner, companionID = companionIDToInfo(currentTargetID);
		local info = getCompanionInfo(owner, companionID, currentTargetID).data or EMPTY;
		setupFieldSet(ui_TargetFrame, info.NA or companionID, TARGET_NAME_WIDTH);
	end
end

local function displayTargetFrame()
	ui_TargetFrame:Show();

	displayTargetName();
	displayPeekSlots();
	displayButtonsPanel();
end

local function getTargetType()
	return originalGetTargetType("target");
end

local function shouldShowTargetFrame(config)
	if currentTargetID == nil or (getConfigValue(config) ~= 1 and (getConfigValue(config) ~= 2 or not isPlayerIC())) then
		return false;
	elseif currentTargetType == TYPE_CHARACTER and (currentTargetID == Globals.player_id or (not isIDIgnored(currentTargetID) and isUnitIDKnown(currentTargetID))) then
		return true;
	elseif (currentTargetType == TYPE_PET or currentTargetType == TYPE_BATTLE_PET) and (isCurrentMine or companionHasProfile(currentTargetID)) then
		return true;
	end
end

local function onTargetChanged(...)
	ui_TargetFrame:Hide();
	currentTargetType, isCurrentMine = getTargetType();
	if currentTargetType == TYPE_CHARACTER then
		currentTargetID = getUnitID("target");
	else
		currentTargetID = getCompanionFullID("target", currentTargetType);
	end
	if shouldShowTargetFrame(CONFIG_TARGET_USE) then
		displayTargetFrame();
	end
end

local function refreshIfNeeded(targetID)
	if not targetID or currentTargetID == targetID then
		onTargetChanged();
	end
end

local function refreshIfNeededTab(unitIDTab)
	if unitIDTab then
		for unitID, _ in pairs(unitIDTab) do
			if currentTargetID == unitID then
				onTargetChanged();
				break;
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	loaded = true;

	-- Config
	registerConfigKey(CONFIG_TARGET_USE, 1);
	registerConfigHandler({CONFIG_TARGET_USE}, onTargetChanged);

	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_TARGETFRAME"),
	});
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigTarget_Usage",
		title = loc("CO_TARGETFRAME_USE"),
		help = loc("CO_TARGETFRAME_USE_TT"),
		listContent = {
			{loc("CO_TARGETFRAME_USE_1"), 1},
			{loc("CO_TARGETFRAME_USE_2"), 2},
			{loc("CO_TARGETFRAME_USE_3"), 3}
		},
		configKey = CONFIG_TARGET_USE,
		listWidth = nil,
		listCancel = true,
	});

	local ids = {};
	for buttonID, button in pairs(targetButtons) do
		tinsert(ids, buttonID);
	end
	table.sort(ids);
	for _, buttonID in pairs(ids) do
		local button = targetButtons[buttonID];
		local configKey = CONFIG_CONTENT_PREFIX .. buttonID;
		registerConfigKey(configKey, true);
		registerConfigHandler(configKey, function()
			button.visible = getConfigValue(configKey);
			onTargetChanged();
		end);
		button.visible = getConfigValue(configKey);
		tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = button.configText or buttonID,
			configKey = configKey,
		});
	end

	TRP3_API.configuration.registerConfigurationPage(TRP3_API.toolbar.CONFIG_STRUCTURE);
end);

TRP3_API.target.init = function()
	setCompanionGlanceSlotPreset = TRP3_API.companions.player.setGlanceSlotPreset;
	setGlanceSlotPreset = TRP3_API.register.player.setGlanceSlotPreset;
	getMiscPresetDropListData = TRP3_API.register.ui.getMiscPresetDropListData;
	isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
	getUnitIDCurrentProfile = TRP3_API.register.getUnitIDCurrentProfile;
	hasProfile = TRP3_API.register.hasProfile
	isPlayerIC = TRP3_API.dashboard.isPlayerIC;
	isIDIgnored = TRP3_API.register.isIDIgnored;
	getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
	getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
	companionHasProfile = TRP3_API.companions.register.companionHasProfile;

	setupFieldSet(TRP3_PeekSAFrame, loc("REG_PLAYER_GLANCE"), 150);

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);

	Events.listenToEvent(Events.REGISTER_DATA_CHANGED, refreshIfNeeded);
	Events.listenToEvent(Events.REGISTER_ABOUT_READ, refreshIfNeededTab);
	Events.listenToEvent(Events.REGISTER_MISC_SAVED, function()
		if currentTargetID == Globals.player_id then
			onTargetChanged();
		end
	end);
	Events.listenToEvents({Events.REGISTER_RPSTATUS_CHANGED, Events.TARGET_SHOULD_REFRESH}, onTargetChanged);

	for i=1,5,1 do
		local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
		slot.slot = tostring(i);
	end
end