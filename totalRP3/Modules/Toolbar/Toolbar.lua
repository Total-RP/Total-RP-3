-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Globals, Utils = TRP3_API.globals, TRP3_API.utils;
local loc = TRP3_API.loc;
local color = Utils.str.color;

local CONFIG_ICON_SIZE = "toolbar_icon_size";
local CONFIG_ICON_MAX_PER_LINE = "toolbar_max_per_line";
local CONFIG_CONTENT_PREFIX = "toolbar_content_";
local CONFIG_HIDE_TITLE = "toolbar_hide_title";
local CONFIG_TOOLBAR_VISIBILITY = "toolbar_visibility";

local CONFIG_TOOLBAR_POS_X = "CONFIG_TOOLBAR_POS_X";
local CONFIG_TOOLBAR_POS_Y = "CONFIG_TOOLBAR_POS_Y";
local CONFIG_TOOLBAR_POS_A = "CONFIG_TOOLBAR_POS_A";

local function GetFormattedTooltipTitle(elementData)
	local icon = TRP3_MarkupUtil.GenerateIconMarkup(elementData.icon, { size = 32 });
	local text = elementData.tooltip or elementData.configText;
	return string.trim(string.join(" ", icon, text));
end

TRP3_ToolbarVisibilityOption = {
	AlwaysShow = 1,
	OnlyShowInCharacter = 2,
	AlwaysHidden = 3,
};

TRP3_ToolbarButtonMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_ToolbarButtonMixin:OnLoad()
	self.timeSinceLastUpdate = math.huge;
end

function TRP3_ToolbarButtonMixin:OnShow()
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:OnHide()
	self:SetElementData(nil);
end

function TRP3_ToolbarButtonMixin:OnClick(mouseButtonName)
	local elementData = self:GetElementData();

	if elementData and elementData.onClick then
		securecallfunction(elementData.onClick, self, elementData, mouseButtonName);
	end

	-- Optimistically force an update on click as some actions change state.
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:OnEnter()
	local elementData = self:GetElementData();

	if elementData and elementData.onEnter then
		securecallfunction(elementData.onEnter, self, elementData);
	else
		TRP3_TooltipScriptMixin.OnEnter(self);
	end
end

function TRP3_ToolbarButtonMixin:OnLeave()
	local elementData = self:GetElementData();

	if elementData and elementData.onLeave then
		securecallfunction(elementData.onLeave, self, elementData);
	else
		TRP3_TooltipScriptMixin.OnLeave(self);
	end
end

function TRP3_ToolbarButtonMixin:OnUpdate(elapsed)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;

	if self.timeSinceLastUpdate < 0.2 then
		return;
	end

	local elementData = self:GetElementData();

	if elementData and elementData.onUpdate then
		securecallfunction(elementData.onUpdate, self, elementData);
	end

	self:MarkClean();
	self:UpdateImmediately();
end

function TRP3_ToolbarButtonMixin:OnTooltipShow(description)
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	local title = GetFormattedTooltipTitle(elementData);
	local text = elementData.tooltipSub;
	local instructions = elementData.tooltipInstructions;

	TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);

	-- Tooltip anchoring is special as we want to dodge screen edges without
	-- overlapping the bar.

	local anchor = "TOP";
	local offsetX = 0;
	local offsetY = 5;

	if string.find(TRP3_API.configuration.getValue(CONFIG_TOOLBAR_POS_A), "^TOP") then
		anchor = "BOTTOM";
		offsetY = -offsetY;
	end

	description:SetAnchorWithOffset(anchor, offsetX, offsetY);
end

function TRP3_ToolbarButtonMixin:GetElementData()
	return self.elementData;
end

function TRP3_ToolbarButtonMixin:SetElementData(elementData)
	self.elementData = elementData;
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:UpdateImmediately()
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	self:SetIconTexture(elementData.icon);
	self:RefreshTooltip();
end

function TRP3_ToolbarButtonMixin:MarkDirty()
	self.timeSinceLastUpdate = math.huge;
end

function TRP3_ToolbarButtonMixin:MarkClean()
	self.timeSinceLastUpdate = 0;
end

local ToolbarMixin = {};

function ToolbarMixin:OnLoad()
	TRP3_API.RegisterCallback(TRP3_Addon, "CONFIGURATION_CHANGED", self.OnConfigurationChanged, self);
	TRP3_API.RegisterCallback(TRP3_Addon, "ROLEPLAY_STATUS_CHANGED", self.OnRoleplayStatusChanged, self);

	self:UpdateVisibility();
end

function ToolbarMixin:OnRoleplayStatusChanged()
	local configuredVisibility = TRP3_API.configuration.getValue(CONFIG_TOOLBAR_VISIBILITY);

	if configuredVisibility == TRP3_ToolbarVisibilityOption.OnlyShowInCharacter then
		self:UpdateVisibility();
	end
end

function ToolbarMixin:OnConfigurationChanged(key)
	if key == CONFIG_TOOLBAR_VISIBILITY then
		self:UpdateVisibility();
	end
end

function ToolbarMixin:Toggle()
	self.forcedVisibility = not self:IsShown();
	self:UpdateVisibility();
	self.forcedVisibility = nil;

	if self:IsShown() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);
	end
end

function ToolbarMixin:UpdateVisibility()
	local configuredVisibility = TRP3_API.configuration.getValue(CONFIG_TOOLBAR_VISIBILITY);
	local shouldShow;

	if self.forcedVisibility ~= nil then
		shouldShow = self.forcedVisibility;
	elseif configuredVisibility == TRP3_ToolbarVisibilityOption.AlwaysHidden then
		shouldShow = false;
	elseif configuredVisibility == TRP3_ToolbarVisibilityOption.OnlyShowInCharacter then
		shouldShow = AddOn_TotalRP3.Player.GetCurrentUser():IsInCharacter();
	else
		shouldShow = true;
	end

	self:SetShown(shouldShow);
end

local toolbar;

-- Always build UI on init. Because maybe other modules would like to anchor it on start.
local function onInit()
	toolbar = Mixin(CreateFrame("Frame", "TRP3_Toolbar", UIParent, "TRP3_ToolbarTemplate"), ToolbarMixin);
end

local function onStart()
	-- Public accessor
	TRP3_API.toolbar = {};

	local LDBObjects = {};

	-- imports
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Toolbar Logic
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local ToolbarButtonPool = CreateFramePool("Button", TRP3_ToolbarContainer, "TRP3_ToolbarButtonTemplate");

	local buttonStructures = {};
	local marginLeft = 7;
	local marginTop = 7;

	local function buildToolbar()
		local maxButtonPerLine = getConfigValue(CONFIG_ICON_MAX_PER_LINE);
		local buttonSize = getConfigValue(CONFIG_ICON_SIZE) + 8; -- Adding 8 to offset the borders making the icon look smaller

		-- Toggle the visibility of the toolbar title as needed.
		TRP3_ToolbarTopFrame:SetShown(not getConfigValue(CONFIG_HIDE_TITLE));

		local ids = {};
		for id, buttonStructure in pairs(buttonStructures) do
			if buttonStructure.visible then
				tinsert(ids, id);
			end
		end
		table.sort(ids);

		ToolbarButtonPool:ReleaseAll();

		if #ids == 0 then
			TRP3_ToolbarContainer:Hide();
		else
			TRP3_ToolbarContainer:Show();
			local index = 0;
			local x = marginLeft;
			local y = -marginTop;
			local numLines = 1;
			for _, id in pairs(ids) do
				local buttonStructure = buttonStructures[id];
				local toolbarButton = ToolbarButtonPool:Acquire();
				toolbarButton:SetElementData(buttonStructure);
				toolbarButton:SetPoint("TOPLEFT", x, y);
				toolbarButton:SetWidth(buttonSize);
				toolbarButton:SetHeight(buttonSize);
				toolbarButton:Show();

				index = index + 1;

				if math.fmod(index, maxButtonPerLine) == 0 then
					y = y - buttonSize;
					x = marginLeft;
					if index < #ids then
						numLines = numLines + 1;
					end
				else
					x = x + buttonSize - 4;
				end
			end
			if index <= maxButtonPerLine then
				TRP3_ToolbarContainer:SetWidth(index*buttonSize - 6);
			else
				TRP3_ToolbarContainer:SetWidth(maxButtonPerLine*buttonSize - 6);
			end
			TRP3_ToolbarContainer:SetHeight(14 + numLines*buttonSize);
			toolbar:SetHeight(34 + numLines*buttonSize);
			toolbar:SetWidth(TRP3_ToolbarContainer:GetWidth() + 10);
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Databroker integration
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local LDB = LibStub:GetLibrary("LibDataBroker-1.1");

	---
	-- Register a Databroker plugin using a button structure
	-- @param buttonStructure
	--
	local function registerDatabrokerButton(buttonStructure)
		local LDBObject = LDB:NewDataObject(
			TRP3_API.globals.addon_name_short .. " — " .. buttonStructure.configText,
			{
				type= "data source",
				icon = Utils.getIconTexture(buttonStructure.icon),
				OnClick = function(Uibutton, button)
					if buttonStructure.onClick then
						buttonStructure.onClick(Uibutton, buttonStructure, button);
					end
				end,
				tooltipTitle = GetFormattedTooltipTitle(buttonStructure),
				tooltipSub = buttonStructure.tooltipSub,
				OnTooltipShow = function(tooltip)
					local LDBButton = LDBObjects[buttonStructure.id];
					tooltip:AddLine(color("w") .. LDBButton.tooltipTitle);
					tooltip:AddLine(LDBButton.tooltipSub, nil, nil, nil, true);

					if buttonStructure.tooltipInstructions then
						tooltip:AddLine(" ");

						for _, instruction in ipairs(buttonStructure.tooltipInstructions) do
							local text = TRP3_API.FormatShortcutWithInstruction(instruction[1], instruction[2]);
							tooltip:AddLine(text);
						end
					end
				end
			});
		LDBObjects[buttonStructure.id] = LDBObject;

	end

	--- Refresh the UI of an databroker object corresponding to the given buttonStructure
	-- @param buttonStructure
	--
	local function refreshLDBPLugin(buttonStructure)
		assert(buttonStructure.id, "The buttonStructure given to refreshLDBPLugin does not have an id.")
		local LDBButton = LDBObjects[buttonStructure.id];
		assert(LDBButton, "Could not find a registered LDB object for id " .. buttonStructure.id)

		LDBButton.icon = Utils.getIconTexture(buttonStructure.icon);

		LDBButton.tooltipTitle = GetFormattedTooltipTitle(buttonStructure);
		LDBButton.tooltipSub = buttonStructure.tooltipSub;

	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Toolbar API
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local loaded = false;

	-- Add a new button to the toolbar. The toolbar layout is automatically handled.
	-- Button structure :
	local function toolbarAddButton(buttonStructure)
		assert(not loaded, "All button must be registered on addon load. You're too late !");
		assert(buttonStructure and buttonStructure.id, "Usage: button structure containing 'id' field");
		assert(not buttonStructures[buttonStructure.id], "The toolbar button with id "..buttonStructure.id.." already exists.");
		buttonStructures[buttonStructure.id] = buttonStructure;
		registerDatabrokerButton(buttonStructure);
	end
	TRP3_API.toolbar.toolbarAddButton = toolbarAddButton;

	--- Will refresh the UI of a given button (icon, tooltip) using the data provided in the buttonStructure
	-- @param toolbarButton UI button to refresh
	-- @param buttonStructure Button structure containing the icon and tooltip text
	--
	local function updateToolbarButton(toolbarButton, buttonStructure)
		toolbarButton:SetElementData(buttonStructure);
	end
	TRP3_API.toolbar.updateToolbarButton = updateToolbarButton;

	local function RefreshToolbarButtons()
		for _, buttonStructure in pairs(buttonStructures) do
			if buttonStructure.onModelUpdate then
				securecallfunction(buttonStructure.onModelUpdate, buttonStructure);
				refreshLDBPLugin(buttonStructure);
			end
		end

		for toolbarButton in ToolbarButtonPool:EnumerateActive() do
			toolbarButton:MarkDirty();
		end
	end

	-- Holding off on making toolbutton updates more flexible for now in favour
	-- of *just* relying on periodic updates and a few hand-selected callbacks.

	C_Timer.NewTicker(0.5, RefreshToolbarButtons);
	TRP3_API.RegisterCallback(TRP3_Addon, "ROLEPLAY_STATUS_CHANGED", RefreshToolbarButtons);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	registerConfigKey(CONFIG_TOOLBAR_POS_A, "TOP");
	registerConfigKey(CONFIG_TOOLBAR_POS_X, 0);
	registerConfigKey(CONFIG_TOOLBAR_POS_Y, -30);
	toolbar:SetPoint(getConfigValue(CONFIG_TOOLBAR_POS_A), UIParent, getConfigValue(CONFIG_TOOLBAR_POS_A),
	getConfigValue(CONFIG_TOOLBAR_POS_X), getConfigValue(CONFIG_TOOLBAR_POS_Y));

	toolbar:RegisterForDrag("LeftButton");
	toolbar:SetMovable(true);
	toolbar:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);
	toolbar:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		local anchor, _, _, x, y = toolbar:GetPoint(1);
		setConfigValue(CONFIG_TOOLBAR_POS_A, anchor);
		setConfigValue(CONFIG_TOOLBAR_POS_X, x);
		setConfigValue(CONFIG_TOOLBAR_POS_Y, y);
	end);

	function TRP3_API.toolbar.reset()
		setConfigValue(CONFIG_TOOLBAR_POS_A, "TOP");
		setConfigValue(CONFIG_TOOLBAR_POS_X, 0);
		setConfigValue(CONFIG_TOOLBAR_POS_Y, -30);
		setConfigValue(CONFIG_TOOLBAR_VISIBILITY, TRP3_ToolbarVisibilityOption.AlwaysShow);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT & TRP3 toolbar content
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		loaded = true;

		TRP3_ToolbarTopFrameText:SetText(Globals.addon_name);

		registerConfigKey(CONFIG_TOOLBAR_VISIBILITY, TRP3_ToolbarVisibilityOption.AlwaysShow);
		registerConfigKey(CONFIG_ICON_SIZE, 25);
		registerConfigKey(CONFIG_ICON_MAX_PER_LINE, 7);
		registerConfigKey(CONFIG_HIDE_TITLE, false);

		registerConfigHandler({
			CONFIG_ICON_SIZE,
			CONFIG_ICON_MAX_PER_LINE,
			CONFIG_HIDE_TITLE,
		}, buildToolbar);

		-- Build configuration page
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.CO_TOOLBAR_CONTENT,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigDropDown",
			widgetName = "TRP3_ConfigToolbarVisibility",
			title = loc.CO_TOOLBAR_VISIBILITY,
			help = loc.CO_TOOLBAR_VISIBILITY_HELP,
			listContent = {
				{loc.CM_DO_NOT_SHOW, TRP3_ToolbarVisibilityOption.AlwaysHidden},
				{loc.CO_TOOLBAR_VISIBILITY_2, TRP3_ToolbarVisibilityOption.OnlyShowInCharacter},
				{loc.CO_TOOLBAR_VISIBILITY_1, TRP3_ToolbarVisibilityOption.AlwaysShow}
			},
			configKey = CONFIG_TOOLBAR_VISIBILITY,
			listCancel = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_ICON_SIZE,
			configKey = CONFIG_ICON_SIZE,
			min = 15,
			max = 50,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_MAX,
			help = loc.CO_TOOLBAR_MAX_TT,
			configKey = CONFIG_ICON_MAX_PER_LINE,
			min = 1,
			max = 25,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_TOOLBAR_HIDE_TITLE,
			help = loc.CO_TOOLBAR_HIDE_TITLE_HELP,
			configKey = CONFIG_HIDE_TITLE,
		});

		local ids = {};
		for buttonID, _ in pairs(buttonStructures) do
			tinsert(ids, buttonID);
		end
		table.sort(ids);
		for _, buttonID in pairs(ids) do
			local button = buttonStructures[buttonID];
			local configKey = CONFIG_CONTENT_PREFIX .. buttonID;
			registerConfigKey(configKey, true);
			registerConfigHandler(configKey, function()
				button.visible = getConfigValue(configKey);
				buildToolbar();
			end);
			button.visible = getConfigValue(configKey);
			tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
				inherit = "TRP3_ConfigCheck",
				title = button.configText or buttonID,
				configKey = configKey,
			});
		end

		buildToolbar();
		toolbar:OnLoad();
	end);

	function TRP3_API.toolbar.switch()
		toolbar:Toggle();
	end
end

local MODULE_STRUCTURE = {
	["name"] = "Toolbar",
	["description"] = "Add a toolbar containing several handy actions!",
	["version"] = 1.000,
	["id"] = "trp3_tool_bar",
	["onStart"] = onStart,
	["onInit"] = onInit,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
