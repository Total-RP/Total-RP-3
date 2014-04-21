--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_TOOLBAR = {};

-- imports
local Globals, Utils = TRP3_GLOBALS, TRP3_UTILS;
local loc = TRP3_L;
local icon = Utils.str.icon;
local color = Utils.str.color;
local assert, pairs, tContains, tinsert, table, math, _G = assert, pairs, tContains, tinsert, table, math, _G;
local ShowingHelm, ShowingCloak = ShowingHelm, ShowingCloak;
local CreateFrame, SendChatMessage, UnitIsDND, UnitIsAFK, GetMouseFocus = CreateFrame, SendChatMessage, UnitIsDND, UnitIsAFK, GetMouseFocus;
local toolbar, toolbarContainer, mainTooltip = TRP3_Toolbar, TRP3_ToolbarContainer, TRP3_MainTooltip;
local getConfigValue, registerConfigKey, registerConfigHandler = TRP3_CONFIG.getValue, TRP3_CONFIG.registerConfigKey, TRP3_CONFIG.registerHandler;
local setTooltipForFrame = TRP3_UI_UTILS.tooltip.setTooltipForFrame;
local refreshTooltip = TRP3_UI_UTILS.tooltip.refresh;

local CONFIG_ICON_SIZE = "toolbar_icon_size"; 
local CONFIG_ICON_MAX_PER_LINE = "toolbar_max_per_line";
local CONFIG_CONTENT_CAPE = "toolbar_content_cape";
local CONFIG_CONTENT_HELMET = "toolbar_content_helmet";
local CONFIG_CONTENT_STATUS = "toolbar_content_status";
local CONFIG_CONTENT_RPSTATUS = "toolbar_content_rpstatus";

local Button_Cape, Button_Helmet, Button_Status, Button_RPStatus;

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
TRP3_TOOLBAR.buildToolbar = buildToolbar;

local function onConfigContentChanged()
	Button_Cape.visible = getConfigValue(CONFIG_CONTENT_CAPE);
	Button_Helmet.visible = getConfigValue(CONFIG_CONTENT_HELMET);
	Button_Status.visible = getConfigValue(CONFIG_CONTENT_STATUS);
	buildToolbar();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toolbar API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Add a new button to the toolbar. The toolbar layout is automatically handled.
-- Button structure :
-- { id [string], icon [string], onClick [function(button, buttonStructure)] };
local function toolbarAddButton(buttonStructure)
	assert(buttonStructure and buttonStructure.id, "Usage: button structure containing 'id' field");
	assert(not buttonStructures[buttonStructure.id], "The toolbar button with id "..buttonStructure.id.." already exists.");
	buttonStructures[buttonStructure.id] = buttonStructure;
	buildToolbar();
end
TRP3_TOOLBAR.toolbarAddButton = toolbarAddButton;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT & TRP3 toolbar content
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_TOOLBAR.init = function()

	registerConfigKey(CONFIG_ICON_SIZE, 25);
	registerConfigKey(CONFIG_ICON_MAX_PER_LINE, 7);
	registerConfigKey(CONFIG_CONTENT_CAPE, true);
	registerConfigKey(CONFIG_CONTENT_HELMET, true);
	registerConfigKey(CONFIG_CONTENT_STATUS, true);
	registerConfigKey(CONFIG_CONTENT_RPSTATUS, true);
	
	registerConfigHandler({CONFIG_ICON_SIZE, CONFIG_ICON_MAX_PER_LINE}, buildToolbar);
	registerConfigHandler({CONFIG_CONTENT_CAPE, CONFIG_CONTENT_HELMET, CONFIG_CONTENT_STATUS}, onConfigContentChanged);
	
	
	-- Build configuration page
	local CONFIG_STRUCTURE = {
		id = "main_config_toolbar",
		marginLeft = 10,
		menuText = loc("CO_TOOLBAR"),
		pageText = loc("CO_TOOLBAR"),
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_TOOLBAR_GENERAL"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLBAR_ICON_SIZE"),
				configKey = CONFIG_ICON_SIZE,
				min = 15,
				max = 50,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_TOOLBAR_MAX"),
				configKey = CONFIG_ICON_MAX_PER_LINE,
				min = 1,
				max = 25,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_TOOLBAR_CONTENT"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLBAR_CONTENT_CAPE"),
				configKey = CONFIG_CONTENT_CAPE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLBAR_CONTENT_HELMET"),
				configKey = CONFIG_CONTENT_HELMET,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLBAR_CONTENT_STATUS"),
				configKey = CONFIG_CONTENT_STATUS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_TOOLBAR_CONTENT_RPSTATUS"),
				configKey = CONFIG_CONTENT_RPSTATUS,
			},
		},
	};
	TRP3_CONFIG.registerConfigurationPage(CONFIG_STRUCTURE);

	TRP3_ToolbarTopFrameText:SetText(Globals.addon_name);
	
	-- Show/hide cape
	local capeTextOn = icon("INV_Misc_Cape_18", 25) .. " ".. loc("TB_SWITCH_CAPE_ON");
	local capeTextOff = icon("item_icecrowncape", 25) .. " ".. loc("TB_SWITCH_CAPE_OFF");
	local capeText2 = strconcat(color("y"), loc("CM_CLICK"), ": ", color("w"), loc("TB_SWITCH_CAPE_1"));
	local capeText3 = strconcat(color("y"), loc("CM_CLICK"), ": ", color("w"), loc("TB_SWITCH_CAPE_2"));
	Button_Cape = {
		id = "aa_trp3_a",
		icon = "INV_Misc_Cape_18",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if not ShowingCloak() then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\item_icecrowncape");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOff, capeText2);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\INV_Misc_Cape_18");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, capeTextOn, capeText3);
			end
			if GetMouseFocus() == Uibutton then
				refreshTooltip(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			ShowCloak(not ShowingCloak());
		end,
		onLeave = function()
			mainTooltip:Hide();
		end,
	};
	toolbarAddButton(Button_Cape);
	
	-- Show / hide helmet
	local helmTextOn = icon("INV_Helmet_13", 25) .. " ".. loc("TB_SWITCH_HELM_ON");
	local helmTextOff = icon("INV_Helmet_13", 25) .. " ".. loc("TB_SWITCH_HELM_OFF");
	local helmText2 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_1");
	local helmText3 = color("y")..loc("CM_CLICK")..": "..color("w")..loc("TB_SWITCH_HELM_2");
	Button_Helmet = {
		id = "aa_trp3_b",
		icon = "INV_Helmet_13",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if not ShowingHelm() then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Spell_Arcane_MindMastery");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOff, helmText2);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\INV_Helmet_13");
				setTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, helmTextOn, helmText3);
			end
			if GetMouseFocus() == Uibutton then
				refreshTooltip(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			ShowHelm(not ShowingHelm());
		end,
		onLeave = function()
			mainTooltip:Hide();
		end,
	};
	toolbarAddButton(Button_Helmet);
	
	-- away/dnd
	local status1Text = icon("Ability_Mage_IncantersAbsorbtion", 25).." "..color("w")..loc("TB_STATUS")..": "..color("r")..loc("TB_DND_MODE");
	local status1SubText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
	local status2Text = icon("Spell_Nature_Sleep", 25).." "..color("w")..loc("TB_STATUS")..": "..color("o")..loc("TB_AFK_MODE");
	local status2SubText = color("y")..loc("CM_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("g")..loc("TB_NORMAL_MODE")..color("w")));
	local status3Text = icon("Ability_Rogue_MasterOfSubtlety", 25).." "..color("w")..loc("TB_STATUS")..": "..color("g")..loc("TB_NORMAL_MODE");
	local status3SubText = color("y")..loc("CM_L_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("o")..loc("TB_AFK_MODE")..color("w"))).."\n"..color("y")..loc("CM_R_CLICK")..": "..color("w")..(loc("TB_GO_TO_MODE"):format(color("r")..loc("TB_DND_MODE")..color("w")));
	Button_Status = {
		id = "aa_trp3_c",
		icon = "Ability_Rogue_MasterOfSubtlety",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if UnitIsDND("player") then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion");
				setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status1Text, status1SubText);
			elseif UnitIsAFK("player") then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Spell_Nature_Sleep");
				setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status2Text, status2SubText);
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety");
				setTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, status3Text, status3SubText);
			end
			if GetMouseFocus() == Uibutton then
				refreshTooltip(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			if UnitIsAFK("player") then
				SendChatMessage("","AFK");
			elseif UnitIsDND("player") then
				SendChatMessage("","DND");
			else
				if button == "LeftButton" then
					SendChatMessage("","AFK");
				else
					SendChatMessage("","DND");
				end
			end
		end,
		onLeave = function()
			mainTooltip:Hide();
		end,
	};
	toolbarAddButton(Button_Status);
	
	onConfigContentChanged();
end

-- TODO: via events
function TRP3_SwitchToolbar()
	if toolbar:IsVisible() then
		toolbar:Hide()
	else
		toolbar:Show();
	end
end
