--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local loc = TRP3_L;
local Utils = TRP3_UTILS;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if TRP3_Configuration == nil then
	TRP3_Configuration = {};
end

local defaultValues = {
	["Locale"] = GetLocale(),
	["MiniMapToUse"] = "Minimap",
	["MiniMapIconDegree"] = 210,
	["MiniMapIconPosition"] = 80,
	
};

-- Copy all absent keys from the default values to the effective configuration map.
function TRP3_InitConfiguration()
	for key,defaultValue in pairs(defaultValues) do
		if not TRP3_Configuration[key] then
			TRP3_Configuration[key] = defaultValue;
		end
	end
	-- Localization
	TRP3_ConfigurationGeneralTitle:SetText(loc("CO_GENERAL"));
end

function TRP3_GetConfigValue(key)
	return TRP3_Configuration[key];
end

-------------------------
-- GENERAL SETTINGS
------------------------

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
	-- localization
	local localeTab = {};
	for _, locale in pairs(TRP3_GetLocales()) do
		tinsert(localeTab, {TRP3_GetLocaleText(locale), locale});
	end
	TRP3_ListBox_Setup(TRP3_ConfigurationGeneral_LangWidget,
		localeTab,
		changeLocale, 
		TRP3_GetLocaleText(TRP3_GetCurrentLocale()), nil, true
	);
end

-------------------------
-- MODULES STATUS
------------------------

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

-------------------------
-- INIT
------------------------

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