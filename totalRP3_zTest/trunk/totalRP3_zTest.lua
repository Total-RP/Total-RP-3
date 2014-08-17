--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Unit testing, module testing
-- This is Telkostrasz's test file, don't touch it ! ;)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

assert(TRP3_API, "Unable to find TRP3.");
local globals = TRP3_API.globals;

local Utils = TRP3_API.utils;
local Log = Utils.log;
local Comm = TRP3_API.communication;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_DUMP_API()
	Utils.table.dump(TRP3_API);
end

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

local function onStart()
	Log.log("onStart test module");

	--	TRP3_API.dashboard.registerNotificationType({
	--		id = "ma notif",
	--		callback = function(unitID)
	--			TRP3_API.navigation.page.setPage("player_main", {unitID = unitID});
	--		end,
	--		removeOnShown = true
	--	});
	--	TRP3_API.dashboard.registerNotificationType({
	--		id = "ma notif2"
	--	});
--	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", function()
--		print("UnitIsOtherPlayersPet: " .. tostring(UnitIsOtherPlayersPet("target")));
--		print("UnitIsBattlePetCompanion: " .. tostring(UnitIsBattlePetCompanion("target")));
--		print("UnitIsOtherPlayersBattlePet: " .. tostring(UnitIsOtherPlayersBattlePet("target")));
--		print("Target NPC ID:", tonumber((UnitGUID("target")):sub(-12, -9), 16))
--		local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetSummonedPetGUID());
--		print("Current pet ID:", creatureID);
--	end);
--	
--	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", function()
--		print(GameTooltip:GetUnit());
--	end);
end

local MODULE_STRUCTURE = {
	["name"] = "Unit testing",
	["description"] = "Telkos private module to test the world !",
	["version"] = 1.000,
	["id"] = "unit_testing",
	["onInit"] = onInit,
	["onStart"] = onStart,
	["minVersion"] = 0.1,
	["requiredDeps"] = {
		{"dyn_locale", 1},
	--		{"test", 0.57}
	}
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);

