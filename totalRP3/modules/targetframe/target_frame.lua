----------------------------------------------------------------------------------
--- Total RP 3
--- Target widget module
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local ui_TargetFrame;

-- Always build UI on init. Because maybe other modules would like to anchor it on start.
local function onInit()
	ui_TargetFrame = CreateFrame("Frame", "TRP3_TargetFrame", UIParent, "TRP3_TargetFrameTemplate");
end

local function onStart()
	-- Public accessor
	TRP3_API.target = {};

	-- imports
	local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
	local CreateFrame, EMPTY = CreateFrame, Globals.empty;
	local loc = TRP3_API.loc;
	local isPlayerIC, isUnitIDKnown, getUnitIDCurrentProfile, hasProfile, isIDIgnored;
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
	local assert, pairs, tinsert, table, math, _G = assert, pairs, tinsert, table, math, _G;
	local getUnitID, unitIDToInfo, companionIDToInfo = Utils.str.getUnitID, Utils.str.unitIDToInfo, Utils.str.companionIDToInfo;
	local setTooltipForSameFrame, mainTooltip, refreshTooltip = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_MainTooltip, TRP3_API.ui.tooltip.refresh;
	local get = TRP3_API.profile.getData;
	local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
	local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
	local getCompanionRegisterProfile, getCompanionProfile, companionHasProfile, isCurrentMine;
	local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
	local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
	local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
	local TYPE_NPC = TRP3_API.ui.misc.TYPE_NPC;

	local CONFIG_TARGET_USE = "target_use";
	local CONFIG_TARGET_ICON_SIZE = "target_icon_size";
	local CONFIG_CONTENT_PREFIX = "target_content_";

	local currentTargetID, currentTargetType;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Buttons logic
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local targetButtons = {};
	local uiButtons = {};
	local marginLeft = 10;
	local loaded = false;

	local function createButton(index)
		local uiButton = CreateFrame("Button", "TRP3_TargetFrameButton"..index, ui_TargetFrame, "TRP3_TargetFrameButton");
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
		local buttonSize = getConfigValue(CONFIG_TARGET_ICON_SIZE);

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

		for _, id in pairs(ids) do
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

			if type(buttonStructure.icon) == "table" and buttonStructure.icon.Apply then
				uiButton:SetNormalTexture(buttonStructure.icon:GetFileID())
				uiButton:SetPushedTexture(buttonStructure.icon:GetFileID());
			else
				uiButton:SetNormalTexture("Interface\\ICONS\\"..buttonStructure.icon);
				uiButton:SetPushedTexture("Interface\\ICONS\\"..buttonStructure.icon);
			end

			if uiButton:GetPushedTexture() then
				uiButton:GetPushedTexture():SetDesaturated(1);
			end
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

		local oldWidth = ui_TargetFrame:GetWidth();
		ui_TargetFrame:SetWidth(math.max(30 + index * buttonSize, 200));
		-- Updating anchors so the toolbar expands from the center
		local anchor, _, _, tfX, tfY = ui_TargetFrame:GetPoint();
		if anchor == "LEFT" then
			tfX = tfX - (ui_TargetFrame:GetWidth() - oldWidth) / 2;
		elseif anchor == "RIGHT" then
			tfX = tfX + (ui_TargetFrame:GetWidth() - oldWidth) / 2;
		end
		ui_TargetFrame:ClearAllPoints();
		ui_TargetFrame:SetPoint(anchor, tfX, tfY);
		ui_TargetFrame:SetHeight(buttonSize + 23);
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

	local function getCharacterInfo()
		if currentTargetID == Globals.player_id then
			return get("player") or EMPTY;
		elseif isUnitIDKnown(currentTargetID) and hasProfile(currentTargetID) then
			return getUnitIDCurrentProfile(currentTargetID) or EMPTY;
		end
		return EMPTY;
	end

	local function getCompanionInfo(owner, companionID, currentTargetId)
		local profile;
		if owner == Globals.player_id then
			profile = getCompanionProfile(companionID) or EMPTY;
		else
			profile = getCompanionRegisterProfile(currentTargetId);
		end
		return profile;
	end

	local TARGET_NAME_WIDTH = 168;

	local function displayTargetName()
		if currentTargetType == TYPE_CHARACTER then
			local info = getCharacterInfo(currentTargetID);
			local name = unitIDToInfo(currentTargetID);
			if info.characteristics then
				setupFieldSet(ui_TargetFrame, (info.characteristics.FN or name) .. " " .. (info.characteristics.LN or ""), TARGET_NAME_WIDTH);
			else
				setupFieldSet(ui_TargetFrame, name, TARGET_NAME_WIDTH);
			end
		elseif currentTargetType == TYPE_PET or currentTargetType == TYPE_BATTLE_PET then
			local owner, companionID = companionIDToInfo(currentTargetID);
			local companionInfo = getCompanionInfo(owner, companionID, currentTargetID);
			local info = companionInfo and companionInfo.data or EMPTY;
			setupFieldSet(ui_TargetFrame, info.NA or companionID, TARGET_NAME_WIDTH);
		elseif currentTargetType == TYPE_NPC then
			setupFieldSet(ui_TargetFrame, UnitName("target"), TARGET_NAME_WIDTH);
		end
	end

	local function displayTargetFrame()
		ui_TargetFrame:Show();

		displayTargetName();
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
		elseif currentTargetType == TYPE_PET or currentTargetType == TYPE_BATTLE_PET then
			local owner = companionIDToInfo(currentTargetID);
			return not isIDIgnored(owner) and (isCurrentMine or companionHasProfile(currentTargetID));
		elseif currentTargetType == TYPE_NPC then
			return TRP3_API.quest and TRP3_API.quest.getActiveCampaignLog();
		end
	end

	local function onTargetChanged()
		ui_TargetFrame:Hide();
		currentTargetType, isCurrentMine = getTargetType();
		if currentTargetType == TYPE_CHARACTER then
			currentTargetID = getUnitID("target");
		elseif currentTargetType == TYPE_NPC then
			currentTargetID = TRP3_API.utils.str.getUnitNPCID("target");
		else
			currentTargetID = getCompanionFullID("target", currentTargetType);
		end
		if shouldShowTargetFrame(CONFIG_TARGET_USE) then
			displayTargetFrame();
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local CONFIG_TARGET_POS_X = "CONFIG_TARGET_POS_X";
	local CONFIG_TARGET_POS_Y = "CONFIG_TARGET_POS_Y";
	local CONFIG_TARGET_POS_A = "CONFIG_TARGET_POS_A";

	registerConfigKey(CONFIG_TARGET_POS_A, "BOTTOM");
	registerConfigKey(CONFIG_TARGET_POS_X, 0);
	registerConfigKey(CONFIG_TARGET_POS_Y, 200);

	local function reposition()
		ui_TargetFrame:SetPoint(getConfigValue("CONFIG_TARGET_POS_A"), UIParent, getConfigValue("CONFIG_TARGET_POS_A"),
			getConfigValue("CONFIG_TARGET_POS_X"), getConfigValue("CONFIG_TARGET_POS_Y"));
	end
	reposition();

	function TRP3_API.target.reset()
		setConfigValue(CONFIG_TARGET_POS_A, "BOTTOM");
		setConfigValue(CONFIG_TARGET_POS_X, 0);
		setConfigValue(CONFIG_TARGET_POS_Y, 200);
	end

	ui_TargetFrame:RegisterForDrag("LeftButton");
	ui_TargetFrame:SetMovable(true);
	ui_TargetFrame:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);
	ui_TargetFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		local anchor, _, _, x, y = ui_TargetFrame:GetPoint(1);
		setConfigValue(CONFIG_TARGET_POS_A, anchor);
		setConfigValue(CONFIG_TARGET_POS_X, x);
		setConfigValue(CONFIG_TARGET_POS_Y, y);
	end);

	ui_TargetFrame.caption:ClearAllPoints();
	ui_TargetFrame.caption:SetPoint("TOP", 0, 15);
	ui_TargetFrame.caption:EnableMouse(true);
	ui_TargetFrame.caption:RegisterForDrag("LeftButton");
	ui_TargetFrame.caption:SetScript("OnDragStart", function(self)
		ui_TargetFrame:GetScript("OnDragStart")(ui_TargetFrame);
	end);
	ui_TargetFrame.caption:SetScript("OnDragStop", function(self)
		ui_TargetFrame:GetScript("OnDragStop")(ui_TargetFrame);
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Config
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_FINISH, function()
		loaded = true;

		-- Config
		registerConfigKey(CONFIG_TARGET_USE, 1);
		registerConfigKey(CONFIG_TARGET_ICON_SIZE, 30);
		registerConfigHandler({CONFIG_TARGET_USE, CONFIG_TARGET_ICON_SIZE}, onTargetChanged);

		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.CO_TARGETFRAME,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigDropDown",
			widgetName = "TRP3_ConfigTarget_Usage",
			title = loc.CO_TARGETFRAME_USE,
			help = loc.CO_TARGETFRAME_USE_TT,
			listContent = {
				{loc.CO_TARGETFRAME_USE_1, 1},
				{loc.CO_TARGETFRAME_USE_2, 2},
				{loc.CO_TARGETFRAME_USE_3, 3}
			},
			configKey = CONFIG_TARGET_USE,
			listWidth = nil,
			listCancel = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TARGETFRAME_ICON_SIZE,
			configKey = CONFIG_TARGET_ICON_SIZE,
			min = 15,
			max = 50,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
			inherit = "TRP3_ConfigButton",
			title = loc.CO_MINIMAP_BUTTON_RESET,
			text = loc.CO_MINIMAP_BUTTON_RESET_BUTTON,
			callback = function()
				setConfigValue(CONFIG_TARGET_POS_A, "CENTER");
				setConfigValue(CONFIG_TARGET_POS_X, 0);
				setConfigValue(CONFIG_TARGET_POS_Y, 0);
				ui_TargetFrame:ClearAllPoints();
				ui_TargetFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
			end,
		});

		local ids = {};
		for buttonID, _ in pairs(targetButtons) do
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
			tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
				inherit = "TRP3_ConfigCheck",
				title = button.configText or buttonID,
				configKey = configKey,
			});
		end
	end);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
	getUnitIDCurrentProfile = TRP3_API.register.getUnitIDCurrentProfile;
	hasProfile = TRP3_API.register.hasProfile
	isPlayerIC = TRP3_API.dashboard.isPlayerIC;
	isIDIgnored = TRP3_API.register.isIDIgnored;
	getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
	getCompanionRegisterProfile = TRP3_API.companions.register.getCompanionProfile;
	companionHasProfile = TRP3_API.companions.register.companionHasProfile;

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	Utils.event.registerHandler("PLAYER_MOUNT_DISPLAY_CHANGED", onTargetChanged);
	Events.listenToEvent(Events.REGISTER_ABOUT_READ, onTargetChanged);
	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
		if (not unitID or (currentTargetID == unitID)) and (not dataType or dataType == "characteristics" or dataType == "about") then
			onTargetChanged();
		end
	end);
end

local MODULE_STRUCTURE = {
	["name"] = "Target bar",
	["description"] = "Add a target bar containing several handy buttons about your target !",
	["version"] = 1.000,
	["id"] = "trp3_target_bar",
	["onStart"] = onStart,
	["onInit"] = onInit,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
