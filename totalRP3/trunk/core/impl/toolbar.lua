--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.toolbar = {};

-- imports
local Globals, Utils = TRP3_API.globals, TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local icon = Utils.str.icon;
local color = Utils.str.color;
local assert, pairs, tContains, tinsert, table, math, _G = assert, pairs, tContains, tinsert, table, math, _G;
local CreateFrame, SendChatMessage, UnitIsDND, UnitIsAFK, GetMouseFocus = CreateFrame, SendChatMessage, UnitIsDND, UnitIsAFK, GetMouseFocus;
local toolbar, toolbarContainer, mainTooltip = TRP3_Toolbar, TRP3_ToolbarContainer, TRP3_MainTooltip;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local setTooltipForFrame = TRP3_API.ui.tooltip.setTooltipForFrame;
local refreshTooltip = TRP3_API.ui.tooltip.refresh;

local CONFIG_ICON_SIZE = "toolbar_icon_size";
local CONFIG_ICON_MAX_PER_LINE = "toolbar_max_per_line";
local CONFIG_CONTENT_PREFIX = "toolbar_content_";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toolbar Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local buttonStructures = {};
local uiButtons = {};
local marginLeft = 7;
local marginTop = 7;

local function buildToolbar()
	local maxButtonPerLine = getConfigValue(CONFIG_ICON_MAX_PER_LINE);
	local buttonSize = getConfigValue(CONFIG_ICON_SIZE);

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
		for i, id in pairs(ids) do
			local buttonStructure = buttonStructures[id];
			local uiButton = uiButtons[index+1];
			if uiButton == nil then -- Create the button
				uiButton = CreateFrame("Button", "TRP3_ToolbarButton"..index, toolbarContainer, "TRP3_ToolbarButtonTemplate");
				uiButton:ClearAllPoints();
				uiButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
				tinsert(uiButtons, uiButton);
			end
			uiButton:SetNormalTexture("Interface\\ICONS\\"..buttonStructure.icon);
			uiButton:SetPushedTexture("Interface\\ICONS\\"..buttonStructure.icon);
			uiButton:GetPushedTexture():SetDesaturated(1);
			uiButton:SetPoint("TOPLEFT", x, y);
			uiButton:SetScript("OnClick", function(self, button)
				if buttonStructure.onClick then
					buttonStructure.onClick(uiButton, buttonStructure, button);
				end
			end);
			uiButton:SetScript("OnEnter", function()
				if buttonStructure.onEnter then
					buttonStructure.onEnter(uiButton, buttonStructure);
				end
			end);
			uiButton:SetScript("OnLeave", function()
				if buttonStructure.onLeave then
					buttonStructure.onLeave(uiButton, buttonStructure);
				end
			end);
			uiButton.TimeSinceLastUpdate = 10;
			uiButton:SetScript("OnUpdate", function(self, elapsed)
				self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
				if (self.TimeSinceLastUpdate > 0.2) then
					self.TimeSinceLastUpdate = 0;
					if buttonStructure.onUpdate then
						buttonStructure.onUpdate(uiButton, buttonStructure);
					end
				end
			end);
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
				x = x + buttonSize;
			end
		end
		if index <= maxButtonPerLine then
			toolbarContainer:SetWidth(14 + index*buttonSize);
		else
			toolbarContainer:SetWidth(14 + maxButtonPerLine*buttonSize);
		end
		toolbarContainer:SetHeight(14 + numLines*buttonSize);
		toolbar:SetHeight(34 + numLines*buttonSize);
		toolbar:SetWidth(toolbarContainer:GetWidth() + 10);
	end
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
end
TRP3_API.toolbar.toolbarAddButton = toolbarAddButton;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT & TRP3 toolbar content
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	loaded = true;

	registerConfigKey(CONFIG_ICON_SIZE, 25);
	registerConfigKey(CONFIG_ICON_MAX_PER_LINE, 7);
	registerConfigHandler({CONFIG_ICON_SIZE, CONFIG_ICON_MAX_PER_LINE}, buildToolbar);

	-- Build configuration page
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_TOOLBAR_CONTENT"),
	});
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc("CO_TOOLBAR_ICON_SIZE"),
		configKey = CONFIG_ICON_SIZE,
		min = 15,
		max = 50,
		step = 1,
		integer = true,
	});
	tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc("CO_TOOLBAR_MAX"),
		help = loc("CO_TOOLBAR_MAX_TT"),
		configKey = CONFIG_ICON_MAX_PER_LINE,
		min = 1,
		max = 25,
		step = 1,
		integer = true,
	});

	local ids = {};
	for buttonID, button in pairs(buttonStructures) do
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
		tinsert(TRP3_API.toolbar.CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = button.configText or buttonID,
			configKey = configKey,
		});
	end

	buildToolbar();
end);

TRP3_API.toolbar.init = function()
	TRP3_API.toolbar.CONFIG_STRUCTURE = {
		id = "main_config_toolbar",
		menuText = loc("CO_TOOLBAR"),
		pageText = loc("CO_TOOLBAR"),
		elements = {},
	};
	TRP3_ToolbarTopFrameText:SetText(Globals.addon_name);
end

-- TODO: via events
function TRP3_SwitchToolbar()
	if toolbar:IsVisible() then
		toolbar:Hide()
	else
		toolbar:Show();
	end
end
