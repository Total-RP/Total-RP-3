--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.target = {};

-- imports
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local loc = TRP3_API.locale.getText;
local ui_TargetFrame = TRP3_TargetFrame;
local UnitName, CreateFrame, UnitIsPlayer = UnitName, CreateFrame, UnitIsPlayer;
local EMPTY = Globals.empty;
local isPlayerIC, isUnitIDKnown;
local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
local assert, pairs, tContains, tinsert, table, math, _G, tostring = assert, pairs, tContains, tinsert, table, math, _G, tostring;
local getUnitID, unitIDToInfo = Utils.str.getUnitID, Utils.str.unitIDToInfo;
local setTooltipForSameFrame, mainTooltip, refreshTooltip = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_MainTooltip, TRP3_RefreshTooltipForFrame;
local get, getDataDefault = TRP3_API.profile.getData, TRP3_API.profile.getDataDefault;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local getUnitIDCurrentProfile;
local buttonContainer = TRP3_TargetFrame;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local getMiscPresetDropListData, setGlanceSlotPreset;
local hasProfile, isIDIgnored;

local CONFIG_TARGET_USE = "target_use";
local CONFIG_CONTENT_PREFIX = "target_content_";

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
			self.onClick(self.unitID, self.targetInfo, button);
		end
	end);
	return uiButton;
end

local function displayButtonsPanel(unitID, targetInfo)
	local buttonSize = 30;

	--Hide all
	for _,uiButton in pairs(uiButtons) do
		uiButton:Hide();
	end
	
	-- Test which buttons to show
	local ids = {};
	for id, buttonStructure in pairs(targetButtons) do
		if buttonStructure.visible and buttonStructure.condition and buttonStructure.condition(unitID, targetInfo) then
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
			buttonStructure.adapter(buttonStructure, unitID, targetInfo);
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
		uiButton.unitID = unitID;
		uiButton.targetInfo = targetInfo;
		if buttonStructure.tooltip then
			setTooltipForSameFrame(uiButton, "BOTTOM", 0, -5, buttonStructure.tooltip, buttonStructure.tooltipSub);
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

local currentTarget = nil;

local function onPeekSelection(value, button)
	if value then
		setGlanceSlotPreset(button.slot, value);
	end
end

local function onPeekClickMine(button)
	displayDropDown(button, getMiscPresetDropListData(), function(value) onPeekSelection(value, button) end, 0, true);
end

local function getInfo(unitID)
	if unitID == Globals.player_id then
		return get("player") or EMPTY;
	elseif isUnitIDKnown(unitID) and hasProfile(unitID) then
		return getUnitIDCurrentProfile(unitID) or EMPTY;
	end
	return EMPTY;
end

local function displayPeekSlots(unitID, targetInfo)
	if UnitIsPlayer("target") then
		local peekTab = getDataDefault("misc/PE", EMPTY, getInfo(unitID));
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
			Utils.texture.applyRoundTexture("TRP3_TargetFrameGlanceSlot"..i.."Image", "Interface\\ICONS\\" .. icon, "Interface\\ICONS\\" .. Globals.icons.default);
			if unitID == Globals.player_id then
				slot:SetScript("OnClick", onPeekClickMine);
			else
				slot:SetScript("OnClick", nil);
			end
		end
	end
end

local function displayTargetName(unitID, targetInfo)
	local info = getInfo(unitID);
	local name, realm = unitIDToInfo(unitID);
	if info.characteristics then
		setupFieldSet(ui_TargetFrame, (info.characteristics.FN or name) .. " " .. (info.characteristics.LN or ""), 168);
	else
		setupFieldSet(ui_TargetFrame, name, 168);
	end
end

local function displayTargetFrame(unitID, targetInfo)
	ui_TargetFrame:Show();
	
	displayTargetName(unitID, targetInfo);
	displayPeekSlots(unitID, targetInfo);
	displayButtonsPanel(unitID, targetInfo);
end

local function getTargetInformation(unitID)
	return EMPTY;
end

local function shouldShowTargetFrame(unitID, config)
	return unitID
		and not isIDIgnored(unitID)
		and (isUnitIDKnown(unitID) or unitID == Globals.player_id)
		and (getConfigValue(config) == 1 or (getConfigValue(config) == 2 and isPlayerIC()));
end

local function onTargetChanged(...)
	local unitID = getUnitID("target");
	currentTarget = unitID;
	ui_TargetFrame:Hide();
	if shouldShowTargetFrame(unitID, CONFIG_TARGET_USE) then
		local targetInfo = getTargetInformation(unitID);
		if targetInfo then
			displayTargetFrame(unitID, targetInfo);
		end
	end
end

local function refreshIfNeeded(targetID)
	if currentTarget == targetID then
		onTargetChanged();
	end
end

local function refreshIfNeededTab(unitIDTab)
	if unitIDTab then
		for unitID, _ in pairs(unitIDTab) do
			if currentTarget == unitID then
				onTargetChanged();
				break;
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onLoaded()
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
end

TRP3_API.target.init = function()
	setGlanceSlotPreset = TRP3_API.register.player.setGlanceSlotPreset;
	getMiscPresetDropListData = TRP3_API.register.ui.getMiscPresetDropListData;
	isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
	getUnitIDCurrentProfile = TRP3_API.register.getUnitIDCurrentProfile;
	hasProfile = TRP3_API.register.hasProfile
	isPlayerIC = TRP3_API.dashboard.isPlayerIC;
	isIDIgnored = TRP3_API.register.isIDIgnored;
	
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, onLoaded);
	
	setupFieldSet(TRP3_PeekSAFrame, loc("REG_PLAYER_GLANCE"), 150);

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	
	Events.listenToEvents({Events.REGISTER_EXCHANGE_PROFILE_CHANGED, Events.REGISTER_EXCHANGE_RECEIVED_INFO}, refreshIfNeeded);
	Events.listenToEvents({Events.REGISTER_ABOUT_READ}, refreshIfNeededTab);
	Events.listenToEvent(Events.REGISTER_MISC_SAVED, function()
		if currentTarget == Globals.player_id then
			onTargetChanged();
		end
	end);
	
	for i=1,5,1 do
		local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
		slot.slot = tostring(i);
	end
end