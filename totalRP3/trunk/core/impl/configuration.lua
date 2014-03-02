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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if TRP3_Configuration == nil then
	TRP3_Configuration = {};
end

local defaultValues = {};

Config.setValue = function(key, value)
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	TRP3_Configuration[key] = value;
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
		
		-- Specific for EditBox
		if _G[widget:GetName().."Box"] then
			local box = _G[widget:GetName().."Box"];
			if element.configKey then
				box:SetScript("OnTextChanged", function(self, value)
					Config.setValue(element.configKey, self:GetText());
					if element.onChange then
						element.onChange();
					end
				end);
				box:SetText(tostring(Config.getValue(element.configKey)));
			else
				box:SetScript("OnTextChanged", element.onChange);
			end
			box:SetNumeric(element.numeric);
			box:SetMaxLetters(element.maxLetters or 0);
			local boxTitle = _G[widget:GetName().."BoxText"];
			if boxTitle then
				boxTitle:SetText(element.boxTitle);
			end
		end

		lastWidget = widget;
		GENERATED_WIDGET_INDEX = GENERATED_WIDGET_INDEX + 1;
	end
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- GENERAL SETTINGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function changeLocale(newLocale)
	if newLocale ~= TRP3_GetCurrentLocale() then
		TRP3_Configuration["Locale"] = newLocale;
		TRP3_ShowConfirmPopup(loc("CO_GENERAL_CHANGELOCALE_ALERT"):format(Utils.str.color("g")..TRP3_GetLocaleText(newLocale).."|r"),
		function()
			ReloadUI();
		end);
	end
end

local function generalInit()
	-- Build widgets
	local CONFIG_STRUCTURE_GENERAL = {
		marginLeft = 10,
		parent = TRP3_ConfigurationGeneralContainer,
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_GENERAL_LOCALE"),
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationGeneral_LangWidget",
				title = loc("CO_GENERAL_LOCALE"),
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_GENERAL_MM"),
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc("CO_GENERAL_MM_USE"),
				configKey = "MiniMapToUse",
			},
		}
	}
	buildConfigurationPage(CONFIG_STRUCTURE_GENERAL);
	
	-- Texts
	TRP3_ConfigurationGeneralTitle:SetText(loc("CO_GENERAL"));
	
	-- localization
	local localeTab = {};
	for _, locale in pairs(TRP3_GetLocales()) do
		tinsert(localeTab, {TRP3_GetLocaleText(locale), locale});
	end
	TRP3_ListBox_Setup(
		TRP3_ConfigurationGeneral_LangWidgetDropDown,
		localeTab,
		changeLocale,
		TRP3_GetLocaleText(TRP3_GetCurrentLocale()), nil, true
	);
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
		id = "main_config_general",
		templateName = "TRP3_ConfigurationGeneral",
		frameName = "TRP3_ConfigurationGeneral",
		frame = TRP3_ConfigurationGeneral,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
	});
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
		onSelected = function() TRP3_SelectMenu("main_91_config_gen") end,
	});
	TRP3_RegisterMenu({
		id = "main_91_config_gen",
		text = loc("CO_GENERAL"),
		isChildOf = "main_90_config",
		onSelected = function() TRP3_SetPage("main_config_general"); end,
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