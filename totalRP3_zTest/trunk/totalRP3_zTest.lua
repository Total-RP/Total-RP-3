--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Unit testing, module testing
-- This is Telkostrasz's test file, don't touch it ! ;)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local globals = TRP3_GLOBALS;
assert(globals and globals.addon, "Unable to find TRP3.");

local Utils = TRP3_UTILS;
local Log = Utils.log;
local Comm = TRP3_COMM;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_TEST()
	print(string.format('%x %x %x', 255, 125, 12));
end

function TRP3_DEBUG_CLEAR()
	TRP3_Profiles = nil;
	TRP3_Characters = nil;
	TRP3_Flyway = nil;
	TRP3_Register = nil;
	ReloadUI();
end

local function onInit()
	Log.log("onInit test module");
end

local function onLoaded()
	Log.log("onLoaded test module");
	
--	TRP3_DASHBOARD.registerNotificationType({
--		id = "ma notif",
--		callback = function(unitID)
--			TRP3_NAVIGATION.page.setPage("player_main", {unitID = unitID});
--		end,
--		removeOnShown = true
--	});
--	TRP3_DASHBOARD.registerNotificationType({
--		id = "ma notif2"
--	});
--	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", function()
--		if UnitName("target") then
--			TRP3_DASHBOARD.notify("ma notif", ("%s has been added to the directory"):format(UnitName("target")), Utils.str.getUnitID("target"));
--		else
--			TRP3_DASHBOARD.notify("ma notif2", "Voici un beau petit texte pour juste notifier bien comme il faut.");
--		end
--		
--	end);
	
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", function()
--		if UnitIsPlayer("mouseover") and not TRP3_IsUnitIDKnown(Utils.str.getUnitID("mouseover")) then
--			TRP3_RegisterAddCharacter(Utils.str.getUnitID("mouseover"))
--		end
	end);

end

local MODULE_STRUCTURE = {
	["name"] = "Unit testing",
	["version"] = 1.000,
	["id"] = "unit_testing",
	["onInit"] = onInit,
	["onLoaded"] = onLoaded,
	["minVersion"] = 0.1,
	["requiredDeps"] = {
		{"dyn_locale", 1},
--		{"test", 0.57}
	}
};

TRP3_MODULE.registerModule(MODULE_STRUCTURE);

