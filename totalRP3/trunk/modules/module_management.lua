---
--	Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--	This file stores :
--	- Module management
--

TRP3_MODULE = {};

-- imports
local Globals, Utils = TRP3_GLOBALS, TRP3_UTILS;
local pairs, type, assert, pcall, tinsert, table, _G = pairs, type, assert, pcall, tinsert, table, _G;
local Log = Utils.log;
local loc = TRP3_L;
local MODULE_REGISTRATION = {};
local MODULE_ACTIVATION;
local hasBeenInit = false;
local displayDropDown = TRP3_UI_UTILS.listbox.displayDropDown;
local setTooltipForSameFrame, setTooltipAll = TRP3_UI_UTILS.tooltip.setTooltipForSameFrame, TRP3_UI_UTILS.tooltip.setTooltipAll;
local registerMenu, selectMenu = TRP3_NAVIGATION.menu.registerMenu, TRP3_NAVIGATION.menu.selectMenu;
local registerPage, setPage = TRP3_NAVIGATION.page.registerPage, TRP3_NAVIGATION.page.setPage;
local CreateFrame = CreateFrame;

TRP3_MODULE_STATUS = {
	MISSING_DEPENDENCY = 0,
	OUT_TO_DATE_TRP3 = 1,
	ERROR_ON_INIT = 2,
	ERROR_ON_LOAD = 3,
	DISABLED = 4,
	OK = 5
};
local TRP3_MODULE_STATUS = TRP3_MODULE_STATUS;

--- Register a module structure.
-- 
-- These parameters are mandatory :
-- id : The moduleID. It must be unique. You can't register two modules having the same ID.
-- 
-- These parameters are optional :
-- name : The module name is a non empty string. If nil, equals the module ID.
-- version : The version is a number. If nil, equals 1.
-- minVersion : The minimum version of TRP3 required. If nil, equals 0;
-- autoEnable : Should the module be enabled by default ? If nil equals true.
-- onInit : A callback triggered before Total RP 3 initialization.
-- onLoaded : A callback triggered after Total RP 3 initialization.
TRP3_MODULE.registerModule = function(moduleStructure)
	
	assert(moduleStructure, "Module structure can't be nil");
	assert(moduleStructure.id, "Illegal module structure. Module id: "..moduleStructure.id);
	assert(not MODULE_REGISTRATION[moduleStructure.id], "This module is already register: "..moduleStructure.id);
	assert(not hasBeenInit, "Module structure must be registered before Total RP 3 initialization: "..moduleStructure.id);
	
	if not moduleStructure.name or not type(moduleStructure.name) == "string" or moduleStructure.name:len() == 0 then
		moduleStructure.name = moduleStructure.id;
	end
	
	if not moduleStructure.version then
		moduleStructure.version = 1;
	end
	
	if not moduleStructure.minVersion then
		moduleStructure.minVersion = 0;
	end
	
	MODULE_REGISTRATION[moduleStructure.id] = moduleStructure;
	
	Log.log("Module registered: " .. moduleStructure.id);
end

--- Initializing modules.
-- This is called at the START of the TRP3 loading sequence.
-- The onInit callback from any REGISTERED & ENABLED & DEPENDENCIES module is fired.
-- The onInit is run on a secure environment. If there is any error, the error is silent and will be store into the structure.
TRP3_MODULE.initModules = function()
	for moduleID, module in pairs(MODULE_REGISTRATION) do
		if module.status == TRP3_MODULE_STATUS.OK and module.onInit and type(module.onInit) == "function" then
			local ok, mess = pcall(module.onInit);
			if not ok then
				module.status = TRP3_MODULE_STATUS.ERROR_ON_INIT;
				module.error = mess;
			end
		end
	end
end

--- Loading modules
-- This is called at the END of the TRP3 loading sequence.
-- The onLoaded callback from any REGISTERED & ENABLED & DEPENDENCIES module is fired, only if previous onInit ran without error (if onInit was defined).
-- onLoaded is run on a secure environment. If there is any error, the error is silent and will be store into the structure.
TRP3_MODULE.startModules = function()
	for moduleID, module in pairs(MODULE_REGISTRATION) do
		if module.status == TRP3_MODULE_STATUS.OK and module.onLoaded and type(module.onLoaded) == "function" then
			local ok, mess = pcall(module.onLoaded);
			if not ok then
				module.status = TRP3_MODULE_STATUS.ERROR_ON_LOAD;
				module.error = mess;
			end
		end
	end
end

--- Return an array of all registered module structures. 
local function getModules()
	return MODULE_REGISTRATION;
end


--- Return the requested module structure
local function getModule(moduleID)
	assert(MODULE_REGISTRATION[moduleID], "Unknown module: " .. moduleID);
	return MODULE_REGISTRATION[moduleID];
end


--- Check a module dependency
-- Return true if dependency is OK.
local function checkModuleDependency(moduleID, dependency_id, dependency_version)
	local module = getModule(moduleID);
	return MODULE_REGISTRATION[dependency_id] and MODULE_REGISTRATION[dependency_id].version >= dependency_version and MODULE_ACTIVATION[dependency_id] ~= false;
end

--- Check off dependencies for a module
-- Return true if ALL dependencies are OK.
local function checkModuleDependencies(moduleID)
	local module = getModule(moduleID);
	for _, depTab in pairs(module.requiredDeps) do
		if not checkModuleDependency(moduleID, depTab[1], depTab[2]) then
			return false;
		end
	end
	return true;
end

--- Check the TRP minimum version for a module
-- Return true if TRP version is OK. 
local function checkModuleTRPVersion(moduleID)
	local module = getModule(moduleID);
	return module.minVersion <= Globals.version;
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
	return loc("CO_MODULES_TT_TRP"):format(trp_version_color, module.minVersion);
end

local function getModuleHint_Deps(module)
	local deps = loc("CO_MODULES_TT_DEPS")..": ";
	if module.requiredDeps == nil then
		deps = loc("CO_MODULES_TT_NONE");
	else
		for _, depTab in pairs(module.requiredDeps) do
			local deps_version_color = "|cff00ff00";
			if not checkModuleDependency(module.id, depTab[1], depTab[2]) then
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

local function onActionSelected(value, button)
	local module = button:GetParent().module;
	if value == 1 then
		MODULE_ACTIVATION[module.id] = false;
		ReloadUI();
	elseif value == 2 then
		MODULE_ACTIVATION[module.id] = true;
		ReloadUI();
	end
end

local function onActionClicked(button)
	local module = button:GetParent().module;
	local values = {};
	if MODULE_ACTIVATION[module.id] ~= false then
		tinsert(values, {loc("CO_MODULES_DISABLE"), 1});
	else
		tinsert(values, {loc("CO_MODULES_ENABLE"), 2});
	end
	displayDropDown(button, values, onActionSelected, 0, true);
end

TRP3_MODULE.onModuleStarted = function()
	local modules = getModules();
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
		frame.module = module;
		frame:SetPoint("TOPLEFT", 0, (i * -63) - 8);
		_G[frame:GetName().."ModuleName"]:SetText(module.name);
		_G[frame:GetName().."ModuleVersion"]:SetText(loc("CO_MODULES_VERSION"):format(module.version));
		_G[frame:GetName().."ModuleID"]:SetText(loc("CO_MODULES_ID"):format(moduleID));
		_G[frame:GetName().."Status"]:SetText(loc("CO_MODULES_STATUS"):format(moduleStatusText(module.status)));
		setTooltipForSameFrame(_G[frame:GetName().."Info"], "BOTTOMRIGHT", 0, 0, module.name, getModuleTooltip(module));
		local actionButton = _G[frame:GetName().."Action"];
		setTooltipAll(actionButton, "BOTTOMLEFT", 10, 10, loc("CM_ACTIONS"));
		actionButton:SetScript("OnClick", onActionClicked);
		i = i + 1;
	end
end

--- This is fired on TRP3 init.
-- Get the saved module activation reference.
-- Check the modules dependencies, if any.
-- Once this method has been fired, all future registration are refused !
TRP3_MODULE.init = function()
	assert(TRP3_Configuration, "TRP3_Configuration should be set. Problem in the include sequence ?");
	hasBeenInit = true; -- Refuse all future registration
	if not TRP3_Configuration.MODULE_ACTIVATION then
		TRP3_Configuration.MODULE_ACTIVATION = {};
	end
	MODULE_ACTIVATION = TRP3_Configuration.MODULE_ACTIVATION;
	
	-- If new module (MODULE_ACTIVATION is saved), then activate if autoEnable;
	for moduleID, module in pairs(MODULE_REGISTRATION) do
		module.status = TRP3_MODULE_STATUS.OK;
	
		if MODULE_ACTIVATION[moduleID] == nil then
			MODULE_ACTIVATION[moduleID] = true;
			if module.autoEnable ~= nil then
				MODULE_ACTIVATION[moduleID] = module.autoEnable;
			end
		end
		if MODULE_ACTIVATION[moduleID] == false then
			module.status = TRP3_MODULE_STATUS.DISABLED;
		else
			-- Check TRP requirement
			if not checkModuleTRPVersion(moduleID) then
				module.status = TRP3_MODULE_STATUS.OUT_TO_DATE_TRP3;
			-- Check dependencies
			elseif module.requiredDeps then
				if not checkModuleDependencies(moduleID) then
					module.status = TRP3_MODULE_STATUS.MISSING_DEPENDENCY;
				end
			end
		end
	end
	
	registerPage({
		id = "main_config_module",
		templateName = "TRP3_ConfigurationModule",
		frameName = "TRP3_ConfigurationModule",
		frame = TRP3_ConfigurationModule,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
	});
	registerMenu({
		id = "main_99_config_mod",
		text = loc("CO_MODULES"),
		isChildOf = "main_90_config",
		onSelected = function() setPage("main_config_module"); end,
	});
	
	moduleInit();
end