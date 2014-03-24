--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- public accessor
TRP3_CONFIG = {};

local pairs = pairs;
local tostring = tostring;
local assert = assert;
local loc = TRP3_L;
local type = type;
local Utils = TRP3_UTILS;
local Config = TRP3_CONFIG;
local tinsert = tinsert;
local math = math;
local tonumber = tonumber;
local _G = _G;
local getLocaleText = TRP3_LOCALE.getLocaleText;
local getLocales = TRP3_LOCALE.getLocales;
local getCurrentLocale = TRP3_LOCALE.getCurrentLocale;

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

Config.setValue = function(key, value)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	local old = TRP3_Configuration[key];
	TRP3_Configuration[key] = value;
	if configHandlers[key] and old ~= value then
		for _, callback in pairs(configHandlers[key]) do
			callback(key, value);
		end
	end
end

Config.getValue = function(key)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	return TRP3_Configuration[key];
end

Config.registerConfigKey = function (key, defaultValue)
	assert(type(key) == "string" and defaultValue ~= nil, "Must be a string key and a not nil default value.");
	assert(not defaultValues[key], "Config key already registered: " .. tostring(key));
	defaultValues[key] = defaultValue;
	if not TRP3_Configuration[key] then
		Config.setValue(key, defaultValue);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration builder
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GENERATED_WIDGET_INDEX = 0;

local function buildConfigurationPage(structure)
	local lastWidget = nil;
	local marginLeft = structure.marginLeft or 0;
	for index, element in pairs(structure.elements) do
		local widget = element.widget or CreateFrame("Frame", element.widgetName or ("TRP3_ConfigurationWidget"..GENERATED_WIDGET_INDEX), structure.parent, element.inherit);
		widget:SetParent(structure.parent);
		widget:ClearAllPoints();
		widget:SetPoint("LEFT", structure.parent, "LEFT", marginLeft + (element.marginLeft or 0), 0);
		if lastWidget ~= nil then
			widget:SetPoint("TOP", lastWidget, "BOTTOM", 0, element.marginTop or 0);
		else
			widget:SetPoint("TOP", structure.parent, "TOP", 0, element.marginTop or 0);
		end

		if element.title and _G[widget:GetName().."Title"] then
			_G[widget:GetName().."Title"]:SetText(element.title);
		end
		
		-- Specific for Dropdown
		if _G[widget:GetName().."DropDown"] then
			local dropDown = _G[widget:GetName().."DropDown"];
			TRP3_ListBox_Setup(
				dropDown,
				element.listContent or {},
				element.listCallback,
				element.listDefault or "", 
				element.listWidth or 134,
				element.listCancel
			);
		end
		
		-- Specific for EditBox
		if _G[widget:GetName().."Box"] then
			local box = _G[widget:GetName().."Box"];
			if element.configKey then
				box:SetScript("OnTextChanged", function(self)
					local value = self:GetText();
					Config.setValue(element.configKey, value);
				end);
				box:SetText(tostring(Config.getValue(element.configKey)));
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
					local value = self:GetChecked();
					Config.setValue(element.configKey, value);
				end);
				box:SetChecked(Config.getValue(element.configKey));
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
					Config.setValue(element.configKey, value);
				end
			end
			slider:SetScript("OnValueChanged", onChange);
			
			if element.configKey then
				slider:SetValue(tonumber(Config.getValue(element.configKey)) or min);
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

	TRP3_RegisterPage({
		id = pageStructure.id,
		frame = pageStructure.frame,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
	});
	
	TRP3_RegisterMenu({
		id = "main_91_config_" .. configurationPageCount,
		text = pageStructure.menuText,
		isChildOf = "main_90_config",
		onSelected = function() TRP3_SetPage(pageStructure.id); end,
	});
	
	buildConfigurationPage(pageStructure);
end
Config.registerConfigurationPage = registerConfigurationPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- GENERAL SETTINGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function changeLocale(newLocale)
	if newLocale ~= getCurrentLocale() then
		Config.setValue("AddonLocale", newLocale);
		TRP3_ShowConfirmPopup(loc("CO_GENERAL_CHANGELOCALE_ALERT"):format(Utils.str.color("g")..getLocaleText(newLocale).."|r"),
		function()
			ReloadUI();
		end);
	end
end

local function generalInit()
	-- localization
	local localeTab = {};
	for _, locale in pairs(getLocales()) do
		tinsert(localeTab, {getLocaleText(locale), locale});
	end
	
	-- Build widgets
	local CONFIG_STRUCTURE_GENERAL = {
		id = "main_config_general",
		marginLeft = 10,
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
		}
	}
	registerConfigurationPage(CONFIG_STRUCTURE_GENERAL);
	
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MODULES STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function moduleInit()
	TRP3_ConfigurationModuleTitle:SetText(loc("CO_MODULES"));
end

local function moduleStatusText(statusCode)
	if statusCode == TRP3_MODULE_STATUS.OK then
		return "|cff00ff00"..loc("CO_MODULES_STATUS_1");
	elseif statusCode == TRP3_MODULE_STATUS.DISABLED then
		return "|cff999999"..loc("CO_MODULES_STATUS_2");
	elseif statusCode == TRP3_MODULE_STATUS.OUT_TO_DATE_TRP3 then
		return "|cffff0000"..loc("CO_MODULES_STATUS_3");
	elseif statusCode == TRP3_MODULE_STATUS.ERROR_ON_INIT then
		return "|cffff0000"..loc("CO_MODULES_STATUS_4");
	elseif statusCode == TRP3_MODULE_STATUS.ERROR_ON_LOAD then
		return "|cffff0000"..loc("CO_MODULES_STATUS_5");
	elseif statusCode == TRP3_MODULE_STATUS.MISSING_DEPENDENCY then
		return "|cffff0000"..loc("CO_MODULES_STATUS_0");
	end
	error("Unknown status code");
end

local function getModuleHint_TRP(module)
	local trp_version_color = "|cff00ff00";
	if module.status == TRP3_MODULE_STATUS.OUT_TO_DATE_TRP3 then
		trp_version_color = "|cffff0000";
	end
	return loc("CO_MODULES_TT_TRP"):format(trp_version_color, module.min_version);
end

local function getModuleHint_Deps(module)
	local deps = loc("CO_MODULES_TT_DEPS")..": ";
	if module.requiredDeps == nil then
		deps = loc("CO_MODULES_TT_NONE");
	else
		for _, depTab in pairs(module.requiredDeps) do
			local deps_version_color = "|cff00ff00";
			if not TRP3_CheckModuleDependency(module.module_id, depTab[1], depTab[2]) then
				deps_version_color = "|cffff0000";
			end
			deps = deps..(loc("CO_MODULES_TT_DEP"):format(deps_version_color, depTab[1], depTab[2]));
		end
	end
	return deps;
end

local function getModuleTooltip(module)
	local message = getModuleHint_TRP(module) .. "\n\n" .. getModuleHint_Deps(module);

	if module.error ~= nil then
		message = message .. (loc("CO_MODULES_TT_ERROR"):format(module.error));
	end

	return message;
end

function TRP3_Configuration_OnModuleLoaded()
	local modules = TRP3_GetModules();
	local i=0;
	local sortedID = {};

	-- Sort module id
	for moduleID, module in pairs(modules) do
		tinsert(sortedID, moduleID);
	end
	table.sort(sortedID);

	for _, moduleID in pairs(sortedID) do
		local module = modules[moduleID];
		local frame = CreateFrame("Frame", "TRP3_ConfigurationModule_"..i, TRP3_ConfigurationModuleContainer, "TRP3_ConfigurationModuleFrame");
		frame:SetPoint("TOPLEFT", 0, (i * -63) - 8);
		_G[frame:GetName().."ModuleName"]:SetText(module.module_name);
		_G[frame:GetName().."ModuleVersion"]:SetText(loc("CO_MODULES_VERSION"):format(module.module_version));
		_G[frame:GetName().."ModuleID"]:SetText(loc("CO_MODULES_ID"):format(moduleID));
		_G[frame:GetName().."Status"]:SetText(loc("CO_MODULES_STATUS"):format(moduleStatusText(module.status)));
		TRP3_SetTooltipForFrame(_G[frame:GetName().."Info"], _G[frame:GetName().."Info"], "BOTTOMLEFT", 0, -15, module.module_name, getModuleTooltip(module));

		i = i + 1;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_UI_InitConfiguration()
	-- Page and menu
	TRP3_RegisterPage({
		id = "main_config_module",
		templateName = "TRP3_ConfigurationModule",
		frameName = "TRP3_ConfigurationModule",
		frame = TRP3_ConfigurationModule,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
	});
	TRP3_RegisterMenu({
		id = "main_90_config",
		text = loc("CO_CONFIGURATION"),
		onSelected = function() TRP3_SelectMenu("main_91_config_1") end,
	});
	TRP3_RegisterMenu({
		id = "main_99_config_mod",
		text = loc("CO_MODULES"),
		isChildOf = "main_90_config",
		onSelected = function() TRP3_SetPage("main_config_module"); end,
	});

	generalInit();
	moduleInit();
end