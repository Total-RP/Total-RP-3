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

TRP3_ToolbarVisibilityOption = {
	AlwaysShow = 1,
	OnlyShowInCharacter = 2,
	AlwaysHidden = 3,
};

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
		TRP3_API.ui.misc.playUISound(SOUNDKIT.IG_MAINMENU_OPEN);
	else
		TRP3_API.ui.misc.playUISound(SOUNDKIT.IG_MAINMENU_CLOSE);
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
	local toolbarContainer, mainTooltip = TRP3_ToolbarContainer, TRP3_MainTooltip;
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
	local setTooltipForFrame = TRP3_API.ui.tooltip.setTooltipForFrame;
	local refreshTooltip = TRP3_API.ui.tooltip.refresh;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Toolbar Logic
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local buttonStructures = {};
	local uiButtons = {};
	local marginLeft = 7;
	local marginTop = 7;


	--- Small tool function to create a title string with the icon of the button in front of it, for the tooltip
	--- @param buttonStructure {icon: string|Icon, tooltip: string, configText: string}
	--- @return string
	local function getTooltipTitleWithIcon(buttonStructure)
		return TRP3_MarkupUtil.GenerateIconMarkup(buttonStructure.icon, { size = 32 }) .. " " .. (buttonStructure.tooltip or buttonStructure.configText);
	end


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
		--Hide all
		for _,uiButton in pairs(uiButtons) do
			uiButton:Hide();
		end

		if #ids == 0 then
			toolbarContainer:Hide();
		else
			toolbarContainer:Show();
			local index = 0;
			local x = marginLeft;
			local y = -marginTop;
			local numLines = 1;
			for _, id in pairs(ids) do
				local buttonStructure = buttonStructures[id];
				local uiButton = uiButtons[index+1];
				if uiButton == nil then -- Create the button
					uiButton = CreateFrame("Button", "TRP3_ToolbarButton"..index, toolbarContainer, "TRP3_ToolbarButtonTemplate");
					uiButton:ClearAllPoints();
					uiButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
					tinsert(uiButtons, uiButton);
				end
				uiButton:SetIconTexture(buttonStructure.icon or TRP3_InterfaceIcons.Default);
				uiButton:SetPoint("TOPLEFT", x, y);
				uiButton:SetScript("OnClick", function(self, button)
					if buttonStructure.onClick then
						buttonStructure.onClick(self, buttonStructure, button);
					end
				end);
				uiButton:SetScript("OnMouseDown", function(self, button)
					if buttonStructure.onMouseDown then
						buttonStructure.onMouseDown(self, buttonStructure, button);
					end
				end);
				uiButton:SetScript("OnEnter", function(self)
					if buttonStructure.onEnter then
						buttonStructure.onEnter(self, buttonStructure);
					else
						refreshTooltip(self);
					end
				end);
				uiButton:SetScript("OnLeave", function(self)
					if buttonStructure.onLeave then
						buttonStructure.onLeave(self, buttonStructure);
					else
						mainTooltip:Hide();
					end
				end);
				uiButton.TimeSinceLastUpdate = 10;
				uiButton:SetScript("OnUpdate", function(self, elapsed)
					self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
					if (self.TimeSinceLastUpdate > 0.2) then
						self.TimeSinceLastUpdate = 0;
						if buttonStructure.onUpdate then
							buttonStructure.onUpdate(self, buttonStructure);
						end
					end
				end);
				if buttonStructure.tooltip then
					setTooltipForFrame(uiButton, uiButton, "TOP", 0, 5, getTooltipTitleWithIcon(buttonStructure), buttonStructure.tooltipSub);
				end
				uiButton:SetWidth(buttonSize);
				uiButton:SetHeight(buttonSize);
				uiButton:Show();
				uiButton.buttonId = id;

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
				toolbarContainer:SetWidth(index*buttonSize - 6);
			else
				toolbarContainer:SetWidth(maxButtonPerLine*buttonSize - 6);
			end
			toolbarContainer:SetHeight(14 + numLines*buttonSize);
			toolbar:SetHeight(34 + numLines*buttonSize);
			toolbar:SetWidth(toolbarContainer:GetWidth() + 10);
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
				OnMouseDown = function(Uibutton, button)
					if buttonStructure.onMouseDown then
						buttonStructure.onMouseDown(Uibutton, buttonStructure, button);
					end
				end,
				tooltipTitle = getTooltipTitleWithIcon(buttonStructure),
				tooltipSub = buttonStructure.tooltipSub,
				OnTooltipShow = function(tooltip)
					local LDBButton = LDBObjects[buttonStructure.id];
					tooltip:AddLine(color("w") .. LDBButton.tooltipTitle);
					tooltip:AddLine(LDBButton.tooltipSub, nil, nil, nil, true);
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

		LDBButton.tooltipTitle = getTooltipTitleWithIcon(buttonStructure);
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
		-- Setting the textures
		toolbarButton:SetIconTexture(buttonStructure.icon);

		-- Refreshing the tooltip
		setTooltipForFrame(toolbarButton, toolbarButton, "TOP", 0, 5, getTooltipTitleWithIcon(buttonStructure), buttonStructure.tooltipSub);
	end
	TRP3_API.toolbar.updateToolbarButton = updateToolbarButton;

	local function RefreshToolbarButtons()
		for _, buttonStructure in pairs(buttonStructures) do
			if buttonStructure.onModelUpdate then
				buttonStructure:onModelUpdate();
				refreshLDBPLugin(buttonStructure);
			end
		end

		for _, uiButton in pairs(uiButtons) do
			uiButton.TimeSinceLastUpdate = math.huge;
		end
	end

	-- Holding off on making toolbutton updates more flexible for now in favour
	-- of *just* relying on periodic updates and a few hand-selected callbacks.

	C_Timer.NewTicker(0.5, RefreshToolbarButtons);
	TRP3_API.RegisterCallback(TRP3_Addon, "ROLEPLAY_STATUS_CHANGED", RefreshToolbarButtons);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local CONFIG_TOOLBAR_POS_X = "CONFIG_TOOLBAR_POS_X";
	local CONFIG_TOOLBAR_POS_Y = "CONFIG_TOOLBAR_POS_Y";
	local CONFIG_TOOLBAR_POS_A = "CONFIG_TOOLBAR_POS_A";

	registerConfigKey(CONFIG_TOOLBAR_POS_A, "TOP");
	registerConfigKey(CONFIG_TOOLBAR_POS_X, 0);
	registerConfigKey(CONFIG_TOOLBAR_POS_Y, -30);
	toolbar:SetPoint(getConfigValue("CONFIG_TOOLBAR_POS_A"), UIParent, getConfigValue("CONFIG_TOOLBAR_POS_A"),
	getConfigValue("CONFIG_TOOLBAR_POS_X"), getConfigValue("CONFIG_TOOLBAR_POS_Y"));

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
				{loc.CO_TOOLBAR_VISIBILITY_1, TRP3_ToolbarVisibilityOption.AlwaysShow},
				{loc.CO_TOOLBAR_VISIBILITY_2, TRP3_ToolbarVisibilityOption.OnlyShowInCharacter},
				{loc.CO_TOOLBAR_VISIBILITY_3, TRP3_ToolbarVisibilityOption.AlwaysHidden}
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
