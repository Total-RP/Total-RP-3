----------------------------------------------------------------------------------
-- Total RP 3
-- Settings API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- public accessor
TRP3_API.configuration = {};

-- imports
local loc = TRP3_API.locale.getText;
local Utils = TRP3_API.utils;
local Config = TRP3_API.configuration;
local _G, tonumber, math, tinsert, type, assert, tostring, pairs, sort, strconcat = _G, tonumber, math, tinsert, type, assert, tostring, pairs, table.sort, strconcat;
local numberToHexa, hexaToNumber = Utils.color.numberToHexa, Utils.color.hexaToNumber;
local CreateFrame = CreateFrame;
local getLocaleText = TRP3_API.locale.getLocaleText;
local getLocales = TRP3_API.locale.getLocales;
local getCurrentLocale = TRP3_API.locale.getCurrentLocale;
local setTooltipForFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if TRP3_Configuration == nil then
	TRP3_Configuration = {};
end

local defaultValues = {};
local configHandlers = {};

local function registerHandler(key, callback)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	if not configHandlers[key] then
		configHandlers[key] = {};
	end
	tinsert(configHandlers[key], callback);
end

Config.registerHandler =  function (key, callback)
	if type(key) == "table" then
		for _, k in pairs(key) do
			registerHandler(k, callback);
		end
	else
		registerHandler(key, callback);
	end
end

local function setValue(key, value)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	local old = TRP3_Configuration[key];
	TRP3_Configuration[key] = value;
	if configHandlers[key] and old ~= value then
		for _, callback in pairs(configHandlers[key]) do
			callback(key, value);
		end
	end
end
Config.setValue = setValue;

local function getValue(key)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	return TRP3_Configuration[key];
end
Config.getValue = getValue;

local function registerConfigKey(key, defaultValue)
	assert(type(key) == "string" and defaultValue ~= nil, "Must be a string key and a not nil default value.");
	assert(not defaultValues[key], "Config key already registered: " .. tostring(key));
	defaultValues[key] = defaultValue;
	if TRP3_Configuration[key] == nil then
		setValue(key, defaultValue);
	end
end
Config.registerConfigKey = registerConfigKey;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration builder
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GENERATED_WIDGET_INDEX = 0;

local function buildConfigurationPage(structure)
	local lastWidget = nil;
	local marginLeft = structure.marginLeft or 5;
	for index, element in pairs(structure.elements) do
		local widget = element.widget or CreateFrame("Frame", element.widgetName or ("TRP3_ConfigurationWidget"..GENERATED_WIDGET_INDEX), structure.parent, element.inherit);
		widget:SetParent(structure.parent);
		widget:ClearAllPoints();
		widget:SetPoint("LEFT", structure.parent, "LEFT", marginLeft + (element.marginLeft or 5), 0);
		if lastWidget ~= nil then
			widget:SetPoint("TOP", lastWidget, "BOTTOM", 0, element.marginTop or 0);
		else
			widget:SetPoint("TOP", structure.parent, "TOP", 0, element.marginTop or 0);
		end

		-- Titles
		if element.title then
			if _G[widget:GetName().."Title"] then
				_G[widget:GetName().."Title"]:SetText(element.title);
			elseif element.title and _G[widget:GetName().."Text"] then
				_G[widget:GetName().."Text"]:SetText(element.title);
			end
		end

		-- Help
		if _G[widget:GetName().."Help"] then
			local help = _G[widget:GetName().."Help"];
			if element.help then
				help:Show();
				setTooltipForFrame(help, "RIGHT", 0, 5, element.title, element.help);
			else
				help:Hide();
			end
		end

		-- Specific for Dropdown
		if _G[widget:GetName().."DropDown"] then
			local dropDown = _G[widget:GetName().."DropDown"];
			if element.configKey then
				if not element.listCallback then
					element.listCallback = function(value)
						setValue(element.configKey, value);
					end
				end
			end
			setupListBox(
			dropDown,
			element.listContent or {},
			element.listCallback,
			element.listDefault or "",
			element.listWidth or 134,
			element.listCancel
			);
			if element.configKey and not element.listDefault then
				dropDown:SetSelectedValue(getValue(element.configKey));
			end
		end

		-- Specific for Color picker
		if _G[widget:GetName().."Picker"] then
			if element.configKey then
				local button = _G[widget:GetName().."Picker"];
				button.setColor(hexaToNumber(getValue(element.configKey)));
				button.onSelection = function(red, green, blue)
					if red and green and blue then
						local hexa = strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue))
						setValue(element.configKey, hexa);
					else
						button.setColor(hexaToNumber(defaultValues[element.configKey]));
					end
				end;
			end
		end

		-- Specific for Button
		if _G[widget:GetName().."Button"] then
			local button = _G[widget:GetName().."Button"];
			if element.callback then
				button:SetScript("OnClick", element.callback);
			end
			button:SetText(element.text or "");
		end

		-- Specific for EditBox
		if _G[widget:GetName().."Box"] then
			local box = _G[widget:GetName().."Box"];
			if element.configKey then
				box:SetScript("OnTextChanged", function(self)
					local value = self:GetText();
					setValue(element.configKey, value);
				end);
				box:SetText(tostring(getValue(element.configKey)));
			end
			box:SetNumeric(element.numeric);
			box:SetMaxLetters(element.maxLetters or 0);
			local boxTitle = _G[widget:GetName().."BoxText"];
			if boxTitle then
				boxTitle:SetText(element.boxTitle);
			end
		end

		-- Specific for Check
		if _G[widget:GetName().."Check"] then
			local box = _G[widget:GetName().."Check"];
			if element.configKey then
				box:SetScript("OnClick", function(self)
					setValue(element.configKey, self:GetChecked());
				end);
				box:SetChecked(getValue(element.configKey));
			end
		end

		-- Specific for Sliders
		if _G[widget:GetName().."Slider"] then
			local slider = _G[widget:GetName().."Slider"];
			local text = _G[widget:GetName().."SliderValText"];
			local min = element.min or 0;
			local max = element.max or 100;

			slider:SetMinMaxValues(min, max);
			_G[widget:GetName().."SliderLow"]:SetText(min);
			_G[widget:GetName().."SliderHigh"]:SetText(max);
			slider:SetValueStep(element.step);
			slider:SetObeyStepOnDrag(element.integer);

			local onChange = function(self, value)
				if element.integer then
					value = math.floor(value);
				end
				text:SetText(value);
				if element.configKey then
					setValue(element.configKey, value);
				end
			end
			slider:SetScript("OnValueChanged", onChange);

			if element.configKey then
				slider:SetValue(tonumber(getValue(element.configKey)) or min);
			else
				slider:SetValue(0);
			end

			onChange(slider, slider:GetValue());
		end

		lastWidget = widget;
		GENERATED_WIDGET_INDEX = GENERATED_WIDGET_INDEX + 1;
	end
end

local configurationPageCount = 0;
local registeredConfiPage = {};

local function registerConfigurationPage(pageStructure)
	assert(not registeredConfiPage[pageStructure.id], "Already registered page id: " .. pageStructure.id);
	registeredConfiPage[pageStructure.id] = pageStructure;

	configurationPageCount = configurationPageCount + 1;
	pageStructure.frame = CreateFrame("Frame", "TRP3_ConfigurationPage" .. configurationPageCount, TRP3_MainFramePageContainer, "TRP3_ConfigurationPage");
	pageStructure.frame:Hide();
	pageStructure.parent = _G["TRP3_ConfigurationPage" .. configurationPageCount .. "InnerScrollContainer"];
	_G["TRP3_ConfigurationPage" .. configurationPageCount .. "Title"]:SetText(pageStructure.pageText);

	registerPage({
		id = pageStructure.id,
		frame = pageStructure.frame,
	});

	registerMenu({
		id = "main_91_config_" .. pageStructure.id,
		text = pageStructure.menuText,
		isChildOf = "main_90_config",
		onSelected = function() setPage(pageStructure.id); end,
	});

	buildConfigurationPage(pageStructure);
end
Config.registerConfigurationPage = registerConfigurationPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- GENERAL SETTINGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function changeLocale(newLocale)
	if newLocale ~= getCurrentLocale() then
		setValue("AddonLocale", newLocale);
		TRP3_API.popup.showConfirmPopup(loc("CO_GENERAL_CHANGELOCALE_ALERT"):format(Utils.str.color("g")..getLocaleText(newLocale).."|r"),
		function()
			ReloadUI();
		end);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	-- Page and menu
	registerMenu({
		id = "main_90_config",
		text = loc("CO_CONFIGURATION"),
		onSelected = function() selectMenu("main_91_config_main_config_aaa_general") end,
	});

	TRP3_API.configuration.CONFIG_FRAME_PAGE = {
		id = "main_config_toolbar",
		menuText = loc("CO_TOOLBAR"),
		pageText = loc("CO_TOOLBAR"),
		elements = {},
	};
	
	-- GENERAL SETTINGS INIT
	-- localization
	local localeTab = {};
	for _, locale in pairs(getLocales()) do
		tinsert(localeTab, {getLocaleText(locale), locale});
	end

	registerConfigKey("comm_broad_use", true);
	registerConfigKey("heavy_profile_alert", true);
	registerConfigKey("new_version_alert", true);
	registerConfigKey("ui_sounds", true);
	registerConfigKey("comm_broad_chan", "xtensionxtooltip2");

	-- Build widgets
	TRP3_API.configuration.CONFIG_STRUCTURE_GENERAL = {
		id = "main_config_aaa_general",
		menuText = loc("CO_GENERAL"),
		pageText = loc("CO_GENERAL"),
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_GENERAL_LOCALE"),
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationGeneral_LangWidget",
				title = loc("CO_GENERAL_LOCALE"),
				listContent = localeTab,
				listCallback = changeLocale,
				listDefault = getLocaleText(getCurrentLocale()),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_GENERAL_COM"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_GENERAL_BROADCAST"),
				configKey = "comm_broad_use",
				help = loc("CO_GENERAL_BROADCAST_TT"),
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc("CO_GENERAL_BROADCAST_C"),
				configKey = "comm_broad_chan",
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_GENERAL_MISC"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc("CO_GENERAL_TT_SIZE"),
				configKey = TRP3_API.ui.tooltip.CONFIG_TOOLTIP_SIZE,
				min = 6,
				max = 25,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_GENERAL_HEAVY"),
				configKey = "heavy_profile_alert",
				help = loc("CO_GENERAL_HEAVY_TT"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_GENERAL_NEW_VERSION"),
				configKey = "new_version_alert",
				help = loc("CO_GENERAL_NEW_VERSION_TT"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_GENERAL_UI_SOUNDS"),
				configKey = "ui_sounds",
				help = loc("CO_GENERAL_UI_SOUNDS_TT"),
			},
		}
	}
end);

function TRP3_API.configuration.constructConfigPage()
	TRP3_API.configuration.registerConfigurationPage(TRP3_API.configuration.CONFIG_FRAME_PAGE);
	TRP3_API.configuration.registerConfigurationPage(TRP3_API.configuration.CONFIG_STRUCTURE_GENERAL);
end