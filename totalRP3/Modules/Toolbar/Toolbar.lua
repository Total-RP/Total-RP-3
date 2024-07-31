-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Globals, Utils = TRP3_API.globals, TRP3_API.utils;
local loc = TRP3_API.loc;
local color = Utils.str.color;

local CONFIG_CONTENT_PREFIX = "toolbar_content_";

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
	local configuredVisibility = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.Visibility);

	if configuredVisibility == TRP3_ToolbarVisibilityOption.OnlyShowInCharacter then
		self:UpdateVisibility();
	end
end

function ToolbarMixin:OnConfigurationChanged(key)
	if key == TRP3_ToolbarConfigKeys.Visibility then
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
	local configuredVisibility = TRP3_API.configuration.getValue(TRP3_ToolbarConfigKeys.Visibility);
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
		local maxButtonPerLine = getConfigValue(TRP3_ToolbarConfigKeys.RowSize);
		local buttonSize = getConfigValue(TRP3_ToolbarConfigKeys.ButtonSize) + 8; -- Adding 8 to offset the borders making the icon look smaller

		-- Toggle the visibility of the toolbar title as needed.
		TRP3_ToolbarTopFrame:SetShown(not getConfigValue(TRP3_ToolbarConfigKeys.HideTitle));

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
				tooltipTitle = TRP3_ToolbarUtil.GetFormattedTooltipTitle(buttonStructure),
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

		LDBButton.tooltipTitle = TRP3_ToolbarUtil.GetFormattedTooltipTitle(buttonStructure);
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

	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorPoint, "TOP");
	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorOffsetX, 0);
	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorOffsetY, -30);

	do  -- Set initial anchor for toolbar.
		local anchor = TRP3_ToolbarUtil.GetToolbarAnchor();
		local clearAllPoints = true;
		anchor:SetPoint(toolbar, clearAllPoints);
	end

	toolbar:RegisterForDrag("LeftButton");
	toolbar:SetMovable(true);
	toolbar:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);
	toolbar:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		local anchor, _, _, x, y = toolbar:GetPoint(1);
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorPoint, anchor);
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetX, x);
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetY, y);
	end);

	function TRP3_API.toolbar.reset()
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorPoint, "TOP");
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetX, 0);
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetY, -30);
		setConfigValue(TRP3_ToolbarConfigKeys.Visibility, TRP3_ToolbarVisibilityOption.AlwaysShow);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT & TRP3 toolbar content
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		loaded = true;

		TRP3_ToolbarTopFrameText:SetText(Globals.addon_name);

		registerConfigKey(TRP3_ToolbarConfigKeys.Visibility, TRP3_ToolbarVisibilityOption.AlwaysShow);
		registerConfigKey(TRP3_ToolbarConfigKeys.ButtonSize, 25);
		registerConfigKey(TRP3_ToolbarConfigKeys.RowSize, 7);
		registerConfigKey(TRP3_ToolbarConfigKeys.HideTitle, false);

		registerConfigHandler({
			TRP3_ToolbarConfigKeys.ButtonSize,
			TRP3_ToolbarConfigKeys.RowSize,
			TRP3_ToolbarConfigKeys.HideTitle,
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
			configKey = TRP3_ToolbarConfigKeys.Visibility,
			listCancel = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_ICON_SIZE,
			configKey = TRP3_ToolbarConfigKeys.ButtonSize,
			min = 15,
			max = 50,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_MAX,
			help = loc.CO_TOOLBAR_MAX_TT,
			configKey = TRP3_ToolbarConfigKeys.RowSize,
			min = 1,
			max = 25,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_TOOLBAR_HIDE_TITLE,
			help = loc.CO_TOOLBAR_HIDE_TITLE_HELP,
			configKey = TRP3_ToolbarConfigKeys.HideTitle,
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
