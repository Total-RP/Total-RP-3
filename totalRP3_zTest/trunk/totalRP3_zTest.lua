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
-- Telkos il serialise
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local serializeObject;

local function serializeString(string)
	return "\"".. string:gsub("([\\\"\10\13%c])", "\\%1") .. "\"";
end

local function serializeNumber(number)
	return tostring(number);
end

local function serializeBoolean(boolean)
	if boolean then
		return "true";
	end
	return "false";
end

local function serializeNil()
	return "nil";
end

local function serializeTable(table)
	local serial = "{";
	for key, value in pairs(table) do
		-- generate the key
		local key = serializeObject(key);
		local value = serializeObject(value);
		serial = serial .. "[" .. key .. "] = " .. value .. ",";
	end
	return serial .. "}";
end

function serializeObject(object)
	if type(object) == "nil" then
		return serializeNil();
	elseif type(object) == "string" then
		return serializeString(object);
	elseif type(object) == "number" then
		return serializeNumber(object);
	elseif type(object) == "boolean" then
		return serializeBoolean(object);
	elseif type(object) == "table" then
		return serializeTable(object);
	end
end

-- The idea is simple : convert structure to LUA code in string format.
local function serialize(structure)
	return serializeObject(structure);
end

-- Interpret the lua code as a function returning the structure.
local function deserialize(serial)
	local deserializer = "return " .. serial .. ";";
	-- Generating factory
	local func, errorMessage = loadstring(deserializer, "Deserializer");
	if not func then
		print(errorMessage);
		return nil, deserializer;
	end
	return func();
end

local function testSerial()

	-- Test for string, number, boolean
	for _, value in pairs({"Mon\\beau\nstring^\"{};end nil\t", 127.54, 50, -27, true, false}) do
		local var = value;
		local varSerial = serialize(var);
		local varFinal = deserialize(varSerial);
		assert(var == varFinal, ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var), tostring(varFinal)));
	end
	print("Tests on primitives : OK !");

	do
		-- Test on nil
		local var = nil;
		local varSerial = serialize(var);
		local varFinal = deserialize(varSerial);
		assert(var == varFinal, ("Unmatching numbers: \"%s\" vs \"%s\""):format(tostring(var), tostring(varFinal)));
	end
	print("Tests on nil : OK !");

	-- Test on table
	local var = {
		"SI",
		{
			"characteristics"
			, {
				["BK"] = 5,
				["T3"] = {
					["PH"] = {
						["IC"] = "Ability_Warrior_StrengthOfArms",
						["BK"] = 1,
						["TX"] = "Compared to the average height. Akarus is far smaller and has a calm polite voice. Having a mild Tanari accent to the point where people can atleast understand him. He carries two almost blunt blades. Although having a sharp point as thing as a needle to inject paralyze poisons. Akarus also has a alchemy belt around his waist where he carries countless green and mostly unharmless potions. He wears a thing but wide robe which he can wrap around him to cover almost his entire body. His shoulderpads have zips on each level of them. Sometimes carrying keys, silver and tools. He has a thick bushy mustache and curly thin hair. Slightly become bald, the only possible tell of this is due to a tiny bald patch on the top of his head. Akarus on his blades has Tanari runes one saying \"Oris'Kais\" (Home) and the other Tanaris in runes. Not to mention contaning countless runic letters on a thin piece of paper containing countless potions for alcholic beverages not to mention countless other paper full of runes.",
					},
					["HI"] = {
						["IC"] = "INV_Misc_Book_17",
						["BK"] = 1,
						["TX"] = "Akarus was born and raised in the secluded valley of Oris'Kais, a sacred and religous place surrounded by a hostile desert even more than the Blasted lands. Akarus was raised up to be a Sandstrider, survivalists who were trained in the ways of hidden movement, wise judgement and knowledge of the desert Flora. After being fully trained, Akarus wanted to see more of the world and set sail to Stormwind, where he found people unlike the ones he met in Tanaris.",
					},
				},
				["TE"] = 3,
				["read"] = false,
				["v"] = 11,
				["CL"] = "Shaman",
				["CH"] = "ff4bbd",
				["IC"] = "Ability_Cro\\wn_of_the_Heaven^$µùé\"s_Icon",
				["FN"] = "Ellypse",
				["FT"] = "(Developer for Total RP 2 & 3)",
				["HE"] = "Really tall !",
				[true] = "lol^Sprout~||}",
				[12.54] = "^^",
			}
		}
	};
	do
		local varSerial = serialize(var);
		local varFinal = deserialize(varSerial);
		assert(varFinal[2][2][true] and var[2][2][true] == varFinal[2][2][true], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][true]), tostring(varFinal[2][2][true])));
		assert(varFinal[2][2][12.54] and var[2][2][12.54] == varFinal[2][2][12.54], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][12.54]), tostring(varFinal[2][2][12.54])));
	end
	print("Tests on table : OK !");

	do
		-- ACE + Serial
		local aceSerial = Utils.serial.serialize(var);
		TRP3_Flyway.test = aceSerial;
		local varSerial = serialize({"PREFIX", aceSerial});
		local varDeserial = deserialize(varSerial);
		assert(type(varDeserial) == "table" and type(varDeserial[2]) == "string", "Boum");
		local varFinal = Utils.serial.deserialize(varDeserial[2]);
		assert(varFinal[2][2][true] and var[2][2][true] == varFinal[2][2][true], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][true]), tostring(varFinal[2][2][true])));
		assert(varFinal[2][2][12.54] and var[2][2][12.54] == varFinal[2][2][12.54], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][12.54]), tostring(varFinal[2][2][12.54])));
	end
	print("Tests on ACE + serial : OK !");

	do
		-- Serial + Compress + ACE
		local varSerial = Utils.serial.serialize(Utils.serial.encodeCompressMessage(serialize(var)));
		local varFinal = deserialize(Utils.serial.decompressCodedMessage(Utils.serial.deserialize(varSerial)));
		assert(varFinal[2][2][true] and var[2][2][true] == varFinal[2][2][true], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][true]), tostring(varFinal[2][2][true])));
		assert(varFinal[2][2][12.54] and var[2][2][12.54] == varFinal[2][2][12.54], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(var[2][2][12.54]), tostring(varFinal[2][2][12.54])));
	end
	print("Tests on Serial + compress + ACE : OK !");

	print("testSerial all tests OK ! Well done Telkos !");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_DUMP_API()
	Utils.table.dump(TRP3_API);
end

function TRP3_PATTERN()
	local pattern = "[^%-]+%-[^%-]+";
	-- Normal
	assert(not ("Faedora-"):match(pattern), "Ca ne doit pas passer ...");
	assert(not ("Faedora"):match(pattern), "Ca ne doit pas passer ...");
	assert(not ("-"):match(pattern), "Ca ne doit pas passer ...");
	assert(not (""):match(pattern), "Ca ne doit pas passer ...");
	assert(not ("-KirinTor"):match(pattern), "Ca ne doit pas passer ...");
	assert(("Faedora-KirinTor"):match(pattern), "Ca doit passer ...");
	-- Accents chelou
	assert(not ("Fäedora-"):match(pattern), "Ca ne doit pas passer ...");
	assert(not ("Fäedora"):match(pattern), "Ca ne doit pas passer ...");
	assert(not ("-KïrinTür"):match(pattern), "Ca ne doit pas passer ...");
	assert(("Fäedora-KïrinTür"):match(pattern), "Ca doit passer ...");
end

function TRP3_PATTERN2()
	local pattern = "[^%-]+%-[^%-]+";
	local characterID = "Ellypse-KirinTor";
	local phrase = "Ellëpse-KirinTor est super sexy.";
	print(phrase:find(characterID:gsub("%-", "%%-")));
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

	--	testSerial();

-- TRP-54
--	local data = {
--		["RA"] = "Draeneï",
--		["MI"] = {
--		},
--		["PS"] = {
--			{
--				["ID"] = 3,
--				["VA"] = 3,
--			}, -- [1]
--		},
--		["v"] = 11,
--		["CL"] = "Shaman",
--		["CH"] = "ff4bbd",
--		["IC"] = "Ability_Crown_of_the_Heavens_Icon",
--		["FN"] = "Ellypse",
--		["FT"] = "(Developer for Total RP 2 & 3)",
--		["HE"] = "Really tall !!",
--	}
--	Comm.sendObject("SI", {TRP3_API.register.registerInfoTypes.CHARACTERISTICS, data}, "Telkostrasz-KirinTor", "BULK");
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
	--		{"dyn_locale", 1},
	--		{"test", 0.57}
	}
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);

