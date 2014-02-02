--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Unit testing, module testing
-- This is Telkostrasz's test file, don't touch it ! ;)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

assert(TRP3_GetAddon, "Unable to find TRP3_GetAddon.");

local log = TRP3_Log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_TEST()
	print(string.format('%x %x %x', 255, 125, 12));
end

function TRP3_DEBUG_CLEAR()
	TRP3_Profiles = nil;
	TRP3_ProfileLinks = nil;
	TRP3_Flyway = nil;
	TRP3_Register = nil;
	ReloadUI();
end

local function onInit()
	log("onInit test module");
end

local function onLoaded()
	log("onLoaded test module");
	
--	TRP3_RegisterToEvent("UPDATE_MOUSEOVER_UNIT", function()
--		if UnitIsPlayer("mouseover") then
--			TRP3_RegisterAddCharacter(UnitName("mouseover"))
--		end
--	end);
end

local MODULE_STRUCTURE = {
	["module_name"] = "Unit testing",
	["module_version"] = 1.000,
	["module_id"] = "unit_testing",
	["onInit"] = onInit,
	["onLoaded"] = onLoaded,
	["min_version"] = 0.1,
	["requiredDeps"] = {
		{"dyn_locale", 1},
--		{"test", 0.57}
	}
};

TRP3_RegisterModule(MODULE_STRUCTURE);

