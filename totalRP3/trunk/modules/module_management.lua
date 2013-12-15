---
--	Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--	This file stores :
--	- Module management
--

TRP3_MODULE_STATUS = {
	MISSING_DEPENDENCY = 0,
	OUT_TO_DATE_TRP3 = 1,
	ERROR_ON_INIT = 2,
	ERROR_ON_LOAD = 3,
	DISABLED = 4,
	OK = 5
};

local log = TRP3_Log;
local loc = TRP3_L;
local MODULE_REGISTRATION = {};
local MODULE_ACTIVATION;
local hasBeenInit = false;

--- Register a module structure.
-- 
-- These parameters are mandatory :
-- module_id : The moduleID. It must be unique. You can't register two modules having the same ID.
-- 
-- These parameters are optional :
-- module_name : The module name is a non empty string. If nil, equals the module ID.
-- module_version : The version is a number. If nil, equals 1.
-- min_version : The minimum version of TRP3 required. If nil, equals 0;
-- autoEnable : Should the module be enabled by default ? If nil equals true.
-- onInit : A callback triggered before Total RP 3 initialization.
-- onLoaded : A callback triggered after Total RP 3 initialization.
function TRP3_RegisterModule(moduleStructure)
	
	assert(moduleStructure, "Module structure can't be nil");
	assert(moduleStructure.module_id, "Illegal module structure. Module id: "..moduleStructure.module_id);
	assert(not MODULE_REGISTRATION[moduleStructure.module_id], "This module is already register: "..moduleStructure.module_id);
	assert(not hasBeenInit, "Module structure must be registered before Total RP 3 initialization: "..moduleStructure.module_id);
	
	if not moduleStructure.module_name or not type(moduleStructure.module_name) == "string" or moduleStructure.module_name:len() == 0 then
		moduleStructure.module_name = moduleStructure.module_id;
	end
	
	if not moduleStructure.module_version then
		moduleStructure.module_version = 1;
	end
	
	if not moduleStructure.min_version then
		moduleStructure.min_version = 0;
	end
	
	MODULE_REGISTRATION[moduleStructure.module_id] = moduleStructure;
	
	log("Module registered: " .. moduleStructure.module_id);
end

--- This is fired on TRP3 init.
-- Get the saved module activation reference.
-- Check the modules dependencies, if any.
-- Once this method has been fired, all future registration are refused !
function TRP3_ModuleManagement_Init()
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
			MODULE_ACTIVATION[moduleID] = module.autoEnable or true;
		end
		if MODULE_ACTIVATION[moduleID] == false then
			module.status = TRP3_MODULE_STATUS.DISABLED;
		else
			-- Check TRP requirement
			if not TRP3_CheckModuleTRPVersion(moduleID) then
				module.status = TRP3_MODULE_STATUS.OUT_TO_DATE_TRP3;
			-- Check dependencies
			elseif module.requiredDeps then
				if not TRP3_CheckModuleDependencies(moduleID) then
					module.status = TRP3_MODULE_STATUS.MISSING_DEPENDENCY;
				end
			end
		end
	end
end

--- Initializing modules.
-- This is called at the START of the TRP3 loading sequence.
-- The onInit callback from any REGISTERED & ENABLED & DEPENDENCIES module is fired.
-- The onInit is run on a secure environment. If there is any error, the error is silent and will be store into the structure.
function TRP3_InitModules()
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
function TRP3_StartModules()
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
function TRP3_GetModules()
	return MODULE_REGISTRATION; -- TODO: Maybe return a clone of the structures to force read-only ?
end


--- Return the requested module structure
function TRP3_GetModule(moduleID)
	assert(MODULE_REGISTRATION[moduleID], "Unknown module: " .. moduleID);
	return MODULE_REGISTRATION[moduleID]; -- TODO: Maybe return a clone of the structure to force read-only ?
end

--- Check off dependencies for a module
-- Return true if ALL dependencies are OK.
function TRP3_CheckModuleDependencies(moduleID)
	local module = TRP3_GetModule(moduleID);
	for _, depTab in pairs(module.requiredDeps) do
		if not TRP3_CheckModuleDependency(moduleID, depTab[1], depTab[2]) then
			return false;
		end
	end
	return true;
end

--- Check a module dependency
-- Return true if dependency is OK.
function TRP3_CheckModuleDependency(moduleID, dependency_id, dependency_version)
	local module = TRP3_GetModule(moduleID);
	return MODULE_REGISTRATION[dependency_id] and MODULE_REGISTRATION[dependency_id].module_version >= dependency_version;
end

--- Check the TRP minimum version for a module
-- Return true if TRP version is OK. 
function TRP3_CheckModuleTRPVersion(moduleID)
	local module = TRP3_GetModule(moduleID);
	return module.min_version <= TRP3_VERSION;
end