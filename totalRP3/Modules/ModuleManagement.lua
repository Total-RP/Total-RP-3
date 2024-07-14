-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_API.module = {};

-- imports
local Globals = TRP3_API.globals;
local loc = TRP3_API.loc;
local MODULE_REGISTRATION = {};
local MODULE_ACTIVATION;
local hasBeenInit = false;
local setTooltipForSameFrame, setTooltipAll = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.setTooltipAll;
local registerMenu = TRP3_API.navigation.menu.registerMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local initModule;
local startModule;
local onModuleStarted;

TRP3_API.module.status = {
	MISSING_DEPENDENCY = 0,
	OUT_TO_DATE_TRP3 = 1,
	ERROR_ON_INIT = 2,
	ERROR_ON_LOAD = 3,
	DISABLED = 4,
	OK = 5
};
local MODULE_STATUS = TRP3_API.module.status;

function TRP3_API.module.isModuleLoaded(moduleID)
	return MODULE_REGISTRATION[moduleID] and MODULE_REGISTRATION[moduleID].status == MODULE_STATUS.OK;
end

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
-- onStart : A callback triggered after Total RP 3 initialization.
TRP3_API.module.registerModule = function(moduleStructure)

	assert(moduleStructure, "Module structure can't be nil");
	assert(moduleStructure.id, "Illegal module structure. Module id: " .. moduleStructure.id);
	assert(not MODULE_REGISTRATION[moduleStructure.id], "This module is already register: " .. moduleStructure.id);
	assert(not hasBeenInit, "Module structure must be registered before Total RP 3 initialization: " .. moduleStructure.id);

	if not moduleStructure.name or type(moduleStructure.name) ~= "string" or moduleStructure.name:len() == 0 then
		moduleStructure.name = moduleStructure.id;
	end

	if not moduleStructure.version then
		moduleStructure.version = 1;
	end

	if not moduleStructure.minVersion then
		moduleStructure.minVersion = 0;
	end

	MODULE_REGISTRATION[moduleStructure.id] = moduleStructure;

	TRP3_API.Log("Module registered: " .. moduleStructure.id);
end

--- Initializing modules.
-- This is called at the START of the TRP3 loading sequence.
-- The onInit callback from any REGISTERED & ENABLED & DEPENDENCIES module is fired.
-- The onInit is run on a secure environment. If there is any error, the error is silent and will be store into the structure.
TRP3_API.module.initModules = function()
	for _, module in pairs(MODULE_REGISTRATION) do
		initModule(module);
	end
end

--- Loading modules
-- This is called at the END of the TRP3 loading sequence.
-- The onStart callback from any REGISTERED & ENABLED & DEPENDENCIES module is fired, only if previous onInit ran without error (if onInit was defined).
-- onStart is run on a secure environment. If there is any error, the error is silent and will be store into the structure.
TRP3_API.module.startModules = function()
	for _, module in pairs(MODULE_REGISTRATION) do
		startModule(module);
	end

	onModuleStarted();
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
local function checkModuleDependency(_, dependency)
	local dependency_id = dependency[1];
	local dependency_version = dependency[2];

	if dependency_version ~= "external" then
		return MODULE_REGISTRATION[dependency_id] and MODULE_REGISTRATION[dependency_id].version >= dependency_version and
			MODULE_ACTIVATION[dependency_id] ~= false;
	else
		return TRP3_API.utils.IsAddOnEnabled(dependency_id);
	end
end

--- Check off dependencies for a module
-- Return true if ALL dependencies are OK.
local function checkModuleDependencies(moduleID)
	local module = getModule(moduleID);
	for _, depTab in pairs(module.requiredDeps) do
		if not checkModuleDependency(moduleID, depTab) then
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
-- MODULES LIFECYCLE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Invokes a given module function with any additional given parameters,
--  capturing error information and returning it as if via pcall or xpcall.
--
--  In release builds, error information is not reported via the global
--  error handler (as if it were called via pcall).
--
--  In debug builds, error information is forwarded to the global error
--  handler, and is additionally returned.
--
--  If a function does not fail with an error but returns an explicit false,
--  the function is treated as failed and any additional message is returned.
--
--  @param module   The module to invoke a function upon.
--  @param funcName The module function name to be invoked.
--  @param ...      Additional arguments to pass to the function.
--
--  @return true if no error occurred, false and an error message if not.
local function callModuleFunction(module, funcName, ...)
	local ok, message = false, nil;
	securecallfunction(function(...) ok, message = module[funcName](...); end, ...);

	if ok == nil then
		ok = true;
		message = nil;
	elseif ok == false and message == nil then
		message = loc.MO_SCRIPT_ERROR;
	end

	return ok, message;
end

--- Initializes the given module.
--
--  This will invoke the onInit function on the module if present and, if it
--  fails, will capture error information and update the module status
--  appropriately.
--
--  This function does nothing if the module status already indicates a
--  failure has occurred.
--
--  @param module The module to initialize.
--
--  @return true if no errors occurred, false and an error message if not.
function initModule(module)
	-- Disregard failed modules and yield their current error information.
	if module.status ~= MODULE_STATUS.OK then
		return false, module.error;
	end

	-- No need to do anything if the lifecycle function isn't present.
	if module.onInit == nil then
		return true;
	end

	-- Call the lifecycle function and update the module status on failure.
	local ok, err = callModuleFunction(module, "onInit");
	if not ok then
		module.error = err;
		module.status = MODULE_STATUS.ERROR_ON_INIT;
	end

	return ok, err;
end

--- Starts the given module.
--
--  This will invoke the onStart function on the module if present and, if it
--  fails, will capture error information and update the module status
--  appropriately.
--
--  This function does nothing if the module status already indicates a
--  failure has occurred.
--
--  @param module The module to start.
function startModule(module)
	-- Disregard failed modules and yield their current error information.
	if module.status ~= MODULE_STATUS.OK then
		return false, module.error;
	end

	-- No need to do anything if the lifecycle function isn't present.
	if module.onStart == nil then
		return true;
	end

	-- Call the lifecycle function and update the module status on failure.
	local ok, err = callModuleFunction(module, "onStart");
	if not ok then
		module.error = err;
		module.status = MODULE_STATUS.ERROR_ON_LOAD;
	end

	return ok, err;
end

--- Disables the given module.
--
--  This will invoke the onDisable function on the module if present and, if it
--  fails, will capture error information and update the module status
--  appropriately.
--
--  This function does nothing if the module status already indicates a
--  failure has occurred.
--
--  @param module The module to disable.
local function disableModule(module)
	-- No need to do anything if the lifecycle function isn't present.
	if module.onDisable == nil then
		return true;
	end

	-- Call the lifecycle function and update the module status on failure.
	local ok, err = callModuleFunction(module, "onDisable");
	if not ok then
		module.error = err;
		module.status = MODULE_STATUS.ERROR_ON_LOAD;
	end

	return ok, err;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MODULES STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function moduleStatusText(statusCode)
	if statusCode == MODULE_STATUS.OK then
		return "|cff00ff00" .. loc.CO_MODULES_STATUS_1;
	elseif statusCode == MODULE_STATUS.DISABLED then
		return "|cff999999" .. loc.CO_MODULES_STATUS_2;
	elseif statusCode == MODULE_STATUS.OUT_TO_DATE_TRP3 then
		return "|cffff0000" .. loc.CO_MODULES_STATUS_3;
	elseif statusCode == MODULE_STATUS.ERROR_ON_INIT then
		return "|cffff0000" .. loc.CO_MODULES_STATUS_4;
	elseif statusCode == MODULE_STATUS.ERROR_ON_LOAD then
		return "|cffff0000" .. loc.CO_MODULES_STATUS_5;
	elseif statusCode == MODULE_STATUS.MISSING_DEPENDENCY then
		return "|cff999999" .. loc.CO_MODULES_STATUS_0;
	end
	error("Unknown status code");
end

local function getModuleHint_TRP(module)
	local trp_version_color = "|cff00ff00";
	if module.status == MODULE_STATUS.OUT_TO_DATE_TRP3 then
		trp_version_color = "|cffff0000";
	end
	return loc.CO_MODULES_TT_TRP:format(trp_version_color, module.minVersion);
end

local function getModuleHint_Deps(module)
	local deps = loc.CO_MODULES_TT_DEPS .. ": ";
	if module.requiredDeps == nil then
		deps = loc.CO_MODULES_TT_NONE;
	else
		for _, depTab in pairs(module.requiredDeps) do
			local deps_version_color = "|cff00ff00";
			if not checkModuleDependency(module.id, depTab) then
				deps_version_color = "|cffff0000";
			end
			deps = deps .. (loc.CO_MODULES_TT_DEP:format(deps_version_color, depTab[1], depTab[2]));
		end
	end
	return deps;
end

local function getModuleTooltip(module)
	local message = "";

	if module.description and module.description:len() > 0 then
		message = message .. module.description .. "|n|n";
	end

	if module.hotReload then
		message = message .. loc.CO_MODULES_SUPPORTS_HOTRELOAD .. "|n|n";
	end

	message = message .. getModuleHint_TRP(module) .. "|n|n" .. getModuleHint_Deps(module);

	if module.error ~= nil then
		message = message .. "|n|n" .. (loc.CO_MODULES_TT_ERROR:format(module.error));
	end

	return message;
end

local function GetSuggestedBorderColor(status)
	local RED_BORDER_COLOR = TRP3_API.CreateColor(0.6, 0.1, 0.1);
	local GREEN_BORDER_COLOR = TRP3_API.CreateColor(0.1, 0.8, 0.1);
	local GREY_BORDER_COLOR = TRP3_API.CreateColor(0.5, 0.5, 0.5);
	local GOLD_BORDER_COLOR = TRP3_API.CreateColor(1, 0.675, 0.125);

	local STATUS_BORDER_COLORS = {
		[MODULE_STATUS.MISSING_DEPENDENCY] = GREY_BORDER_COLOR,
		[MODULE_STATUS.OUT_TO_DATE_TRP3] = RED_BORDER_COLOR,
		[MODULE_STATUS.ERROR_ON_INIT] = RED_BORDER_COLOR,
		[MODULE_STATUS.ERROR_ON_LOAD] = RED_BORDER_COLOR,
		[MODULE_STATUS.DISABLED] = GREY_BORDER_COLOR,
		[MODULE_STATUS.OK] = GREEN_BORDER_COLOR,
	};

	return STATUS_BORDER_COLORS[status] or GOLD_BORDER_COLOR;
end

TRP3_ModuleManagerListElementMixin = {};

function TRP3_ModuleManagerListElementMixin:Init(module)
	self.ModuleName:SetText(module.name);
	self.ModuleVersion:SetText(loc.CO_MODULES_VERSION:format(module.version));
	self.ModuleID:SetText(loc.CO_MODULES_ID:format(module.id));
	self.Status:SetText(loc.CO_MODULES_STATUS:format(moduleStatusText(module.status)));
	self.Border:SetVertexColor(GetSuggestedBorderColor(module.status):GetRGB());
	setTooltipForSameFrame(self.Info, "RIGHT", 0, 5, module.name, getModuleTooltip(module));
end

local function moduleInit()
	TRP3_ConfigurationModule.Title:SetText(loc.CO_MODULES);
end

-- There's a lot of reused code from onModuleStarted() and this can probably be simplified significantly
-- This function reloads the module frame to show it's new state after enabling/disabling a module that supports hot reload
-- Should only be called (currently) from onActionSelected()
-- To assist people from the future, here's a quick run down on how to make a module hot-reloadable
-- In your 'registerModule' parameters, ensure that you set 'hotReload' to true and define an 'onDisable' callback
-- Make sure your `onStart` callback is self-sufficient and doesn't depend on any other state or on a UI reload to work properly
-- In your `onDisable` callback make sure you clean up after yourself and don't leave unnecessary baggage lying around
-- FIXME: When modules are loaded, if hotReload is set to true, there's no check for whether `onDisable` is defined.
local function moduleHotReload(frame, value)
	local module = frame.module;

	TRP3_API.Log("Hot reloading module: " .. module.id)
	module.status = MODULE_STATUS.OK
	if MODULE_ACTIVATION[module.id] == nil then
		MODULE_ACTIVATION[module.id] = true;
		if module.autoEnable ~= nil then
			MODULE_ACTIVATION[module.id] = module.autoEnable;
		end
	end
	if MODULE_ACTIVATION[module.id] == false then
		module.status = MODULE_STATUS.DISABLED;
	else
		-- Check TRP requirement
		if not checkModuleTRPVersion(module.id) then
			module.status = MODULE_STATUS.OUT_TO_DATE_TRP3;
			-- Check dependencies
		elseif module.requiredDeps then
			if not checkModuleDependencies(module.id) then
				module.status = MODULE_STATUS.MISSING_DEPENDENCY;
			end
		end
	end

	if value == 1 then
		disableModule(module);
	elseif value == 2 then
		startModule(module);
	end

	frame:Init(module);
end

local function onActionSelected(data)
	local button, module, state = unpack(data);
	if state == 1 then
		MODULE_ACTIVATION[module.id] = false;

		if module.hotReload then
			moduleHotReload(button:GetParent(), state); -- this handles reloading the module display when hot reloading, also calls disableModule()
		else
			ReloadUI();
		end

	elseif state == 2 then
		MODULE_ACTIVATION[module.id] = true;
		if module.hotReload then
			moduleHotReload(button:GetParent(), state); -- this handles reloading the module display when hot reloading, also calls startModule()
		else
			ReloadUI();
		end
	end
end

local function onActionClicked(button)
	local module = button:GetParent().module;

	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		if MODULE_ACTIVATION[module.id] ~= false then
			description:CreateButton(loc.CO_MODULES_DISABLE, onActionSelected, {button, module, 1});
		else
			description:CreateButton(loc.CO_MODULES_ENABLE, onActionSelected, {button, module, 2});
		end
	end);
end

function onModuleStarted()
	local modules = getModules();
	local i = 0;
	local sortedID = {};

	-- Sort module id
	for moduleID, _ in pairs(modules) do
		tinsert(sortedID, moduleID);
	end
	table.sort(sortedID);

	local previous;
	for _, moduleID in pairs(sortedID) do
		local module = modules[moduleID];
		local frame = CreateFrame("Frame", nil, TRP3_ConfigurationModule.ScrollFrame.Content, "TRP3_ConfigurationModuleFrame");
		frame.module = module;
		frame:SetPoint("LEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		if previous then
			frame:SetPoint("TOP", previous, "BOTTOM", 0, 0);
		else
			frame:SetPoint("TOP", 0, 0);
		end
		previous = frame;
		frame:Init(module);
		local actionButton = frame.Action;
		setTooltipAll(actionButton, "RIGHT", 0, 5, loc.CM_OPTIONS, TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CM_OPTIONS_ADDITIONAL));
		actionButton:SetScript("OnMouseDown", onActionClicked);
		i = i + 1;
	end
end

--- This is fired on TRP3 init.
-- Get the saved module activation reference.
-- Check the modules dependencies, if any.
-- Once this method has been fired, all future registration are refused !
TRP3_API.module.init = function()
	assert(TRP3_Configuration, "TRP3_Configuration should be set. Problem in the include sequence ?");
	hasBeenInit = true; -- Refuse all future registration
	if not TRP3_Configuration.MODULE_ACTIVATION then
		TRP3_Configuration.MODULE_ACTIVATION = {};
	end
	MODULE_ACTIVATION = TRP3_Configuration.MODULE_ACTIVATION;

	-- If new module (MODULE_ACTIVATION is saved), then activate if autoEnable;
	for moduleID, module in pairs(MODULE_REGISTRATION) do
		module.status = MODULE_STATUS.OK;

		if MODULE_ACTIVATION[moduleID] == nil then
			MODULE_ACTIVATION[moduleID] = true;
			if module.autoEnable ~= nil then
				MODULE_ACTIVATION[moduleID] = module.autoEnable;
			end
		end
		if MODULE_ACTIVATION[moduleID] == false then
			module.status = MODULE_STATUS.DISABLED;
		else
			-- Check TRP requirement
			if not checkModuleTRPVersion(moduleID) then
				module.status = MODULE_STATUS.OUT_TO_DATE_TRP3;
			-- Check dependencies
			elseif module.requiredDeps then
				if not checkModuleDependencies(moduleID) then
					module.status = MODULE_STATUS.MISSING_DEPENDENCY;
				end
			end
		end
	end

	local TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_ConfigurationModule.ScrollFrame,
			},
			button = {
				x = 0, y = 10, anchor = "BOTTOM",
				text = loc.CO_MODULES_TUTO,
				textWidth = 425,
				arrow = "UP"
			}
		},
	}

	registerPage({
		id = "main_config_module",
		templateName = "TRP3_ConfigurationModule",
		frameName = "TRP3_ConfigurationModule",
		frame = TRP3_ConfigurationModule,
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end,
	});
	registerMenu({
		id = "main_99_config_mod",
		text = loc.CO_MODULES,
		isChildOf = "main_90_config",
		onSelected = function() setPage("main_config_module"); end,
	});

	moduleInit();

	-- Resizing
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.NAVIGATION_RESIZED, function(_, containerWidth)
		TRP3_ConfigurationModule.ScrollFrame.Content:SetSize(containerWidth - 55, 50);
	end);
end
