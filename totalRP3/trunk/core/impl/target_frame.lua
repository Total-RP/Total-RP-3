--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_TARGET_FRAME = {};

-- imports
local Utils, Events, Globals = TRP3_UTILS, TRP3_EVENTS, TRP3_GLOBALS;
local loc = TRP3_L;
local ui_TargetFrame = TRP3_TargetFrame;
local UnitName, CreateFrame = UnitName, CreateFrame;
local EMPTY = Globals.empty;
local getMiscData, isPlayerIC, isUnitIDKnown;
local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_CONFIG.getValue, TRP3_CONFIG.registerConfigKey, TRP3_CONFIG.registerHandler, TRP3_CONFIG.setValue;
local assert, pairs, tContains, tinsert, table, math, _G, tostring = assert, pairs, tContains, tinsert, table, math, _G, tostring;
local getUnitID, unitIDToInfo = Utils.str.getUnitID, Utils.str.unitIDToInfo;
local setTooltipForSameFrame, mainTooltip, refreshTooltip = TRP3_UI_UTILS.tooltip.setTooltipForSameFrame, TRP3_MainTooltip, TRP3_RefreshTooltipForFrame;
local get = TRP3_PROFILE.getData;
local displayDropDown = TRP3_UI_UTILS.listbox.displayDropDown;
local getCurrentProfile;
local buttonContainer = TRP3_TargetFrame;
local TRP3_FieldSet_SetCaption = TRP3_FieldSet_SetCaption;

local CONFIG_TARGET_USE = "target_use";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Buttons logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local targetButtons = {};
local uiButtons = {};
local marginLeft = 10;

local function createButton(index)
	local uiButton = CreateFrame("Button", "TRP3_TargetFrameButton"..index, buttonContainer, "TRP3_ToolbarButtonTemplate");
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
			self.onClick(self.unitID, self.targetInfo);
		end
	end);
	return uiButton;
end

local function displayButtonsPanel(unitID, targetInfo)
	local buttonSize = 25;

	--Hide all
	for _,uiButton in pairs(uiButtons) do
		uiButton:Hide();
	end
	
	-- Test which buttons to show
	local ids = {};
	for id, buttonStructure in pairs(targetButtons) do
		if buttonStructure.condition and buttonStructure.condition(unitID, targetInfo) then
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
		uiButton:SetNormalTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:SetPushedTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:GetPushedTexture():SetDesaturated(1);
		uiButton:SetPoint("TOPLEFT", x, -12);
		uiButton:SetWidth(buttonSize);
		uiButton:SetHeight(buttonSize);
		uiButton:Show();
		uiButton.buttonId = id;
		uiButton.onClick = buttonStructure.onClick;
		uiButton.getTooltip = buttonStructure.getTooltip;
		uiButton.unitID = unitID;
		uiButton.targetInfo = targetInfo;
		setTooltipForSameFrame(uiButton, "BOTTOM", 0, -5, buttonStructure.getTooltip(unitID, targetInfo));
		
		index = index + 1;
		x = x + buttonSize + 2;
	end
	
	buttonContainer:SetWidth(math.max(20 + index * buttonSize, 200));
end

local function registerButton(targetButton)
	assert(targetButton and targetButton.id, "Usage: button structure containing 'id' field");
	assert(not targetButtons[targetButton.id], "Already registered button id: " .. targetButton.id);
	targetButtons[targetButton.id] = targetButton;
end
TRP3_TARGET_FRAME.registerButton = registerButton;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Display logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentTarget = nil;

local function onPeekSelection(value, button)
	if value then
		TRP3_RegisterMiscSetPeek(button.slot, value);
	end
end

local function onPeekClickMine(button)
	displayDropDown(button, TRP3_RegisterMiscGetPeekPresetStructure(), function(value) onPeekSelection(value, button) end, 0, true);
end

local function getInfo(unitID)
	if unitID == Globals.player_id then
		return get("player") or EMPTY;
	elseif isUnitIDKnown(unitID) then
		return getCurrentProfile(unitID) or EMPTY;
	end
	return EMPTY;
end

local function displayPeekSlots(unitID, targetInfo)
	if UnitIsPlayer("target") then
		local peekTab = EMPTY;
		if unitID == Globals.player_id then
			peekTab = get("player/misc").PE or EMPTY;
		elseif isUnitIDKnown(unitID) then
			peekTab = getMiscData(unitID).PE or EMPTY;
		end
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
		TRP3_FieldSet_SetCaption(ui_TargetFrame, (info.characteristics.FN or name) .. " " .. (info.characteristics.LN or ""), 168);
	else
		TRP3_FieldSet_SetCaption(ui_TargetFrame, name, 168);
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
	return unitID and (isUnitIDKnown(unitID) or unitID == Globals.player_id) and (getConfigValue(config) == 1 or (getConfigValue(config) == 2 and isPlayerIC()));
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_TARGET_FRAME.init = function()
	getMiscData = TRP3_REGISTER.getMiscData;
	isUnitIDKnown = TRP3_REGISTER.isUnitIDKnown;
	getCurrentProfile = TRP3_REGISTER.getCurrentProfile;
	isPlayerIC = TRP3_DASHBOARD.isPlayerIC;
	
	TRP3_FieldSet_SetCaption(TRP3_PeekSAFrame, loc("REG_PLAYER_GLANCE"), 150);

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	
	Events.listenToEvents({Events.REGISTER_EXCHANGE_PROFILE_CHANGED, Events.REGISTER_EXCHANGE_RECEIVED_INFO}, refreshIfNeeded);
	Events.listenToEvent(Events.REGISTER_MISC_SAVED, function()
		if currentTarget == Globals.player_id then
			onTargetChanged();
		end
	end);
	
	for i=1,5,1 do
		local slot = _G["TRP3_TargetFrameGlanceSlot"..i];
		slot.slot = tostring(i);
	end
	
	-- Config
	registerConfigKey(CONFIG_TARGET_USE, 1);
	registerConfigHandler({CONFIG_TARGET_USE}, onTargetChanged);
	
	tinsert(TRP3_TOOLBARS_CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_TARGETFRAME"),
	});
	tinsert(TRP3_TOOLBARS_CONFIG_STRUCTURE.elements, {
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
	TRP3_CONFIG.registerConfigurationPage(TRP3_TOOLBARS_CONFIG_STRUCTURE);
end