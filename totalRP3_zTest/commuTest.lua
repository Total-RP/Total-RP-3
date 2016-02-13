--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Unit testing, module testing
-- This is Telkostrasz's test file, don't touch it ! ;)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

assert(TRP3_API, "Unable to find TRP3.");
local globals = TRP3_API.globals;

globals.DEBUG_MODE = true;

local Utils = TRP3_API.utils;
local Log = Utils.log;
local Comm = TRP3_API.communication;

local assert, type, tostring, print = assert, type, tostring, print;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Telkos il teste
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local test1, test2, test3;

-- Test 1: Serialize primitives
function test1()
	print("Test1: start ...");
	local to = "osef-OsefRealm";
	local stringVal = "Mon\\beau\nstring^\"{};end nil\t";
	local number1 = 127.54;
	local number2 = 50;
	local number3 = -27;
	local boolean1 = true;
	local boolean2 = false;
	local testStruct = {stringVal, number1, number2, number3, boolean1, boolean2};
	local compress = Utils.serial.encodeCompressMessage(Utils.serial.serialize(testStruct));
	print("Test1: sending ...");

	local callback = function(object, sender)
		print("Test1: receiving ...");
		local again = true;

		if type(object) == "string" then
			print("Test1: decoding ...");
			object = Utils.serial.decompressCodedStructure(object);
			again = false;
		end

		assert(to == sender, "Bad sender");
		assert(type(object) == "table", "Value is not a table.");
		assert(#object == 6, "Bad table size.");
		assert(type(object[1]) == "string" and object[1] == stringVal, "Bad value stringVal:" .. tostring(object[1]));
		assert(type(object[2]) == "number" and object[2] == number1, "Bad value number1:" .. tostring(object[2]));
		assert(type(object[3]) == "number" and object[3] == number2, "Bad value number1:" .. tostring(object[3]));
		assert(type(object[4]) == "number" and object[4] == number3, "Bad value number1:" .. tostring(object[4]));
		assert(type(object[5]) == "boolean" and object[5] == boolean1, "Bad value boolean1:" .. tostring(object[5]));
		assert(type(object[6]) == "boolean" and object[6] == boolean2, "Bad value boolean2:" .. tostring(object[6]));
		print("Test1: OK !");


		-- Compress version
		if again then
			Comm.sendObject("Test1", compress, to);
		else
			test2();
		end

	end

	Comm.registerProtocolPrefix("Test1", callback);
	Comm.sendObject("Test1", testStruct, to);
end

function test2()
	print("Test2: start ...");
	local to = "osef-OsefRealm";
	local testStruct = {
		"SI",
		{
			"characteristics",
			{
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
	local compress = Utils.serial.encodeCompressMessage(Utils.serial.serialize(testStruct));
	print("Test2: sending ...");

	local callback = function(object, sender)
		print("Test2: receiving ...");
		local again = true;

		if type(object) == "string" then
			print("Test2: decoding ...");
			object = Utils.serial.decompressCodedStructure(object);
			again = false;
		end

		assert(to == sender, "Bad sender");
		assert(type(object) == "table", "Value is not a table.");
		assert(object[2][2][true] and testStruct[2][2][true] == object[2][2][true], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(testStruct[2][2][true]), tostring(object[2][2][true])));
		assert(object[2][2][12.54] and testStruct[2][2][12.54] == object[2][2][12.54], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(testStruct[2][2][12.54]), tostring(object[2][2][12.54])));

		print("Test2: OK !");


		-- Compress version
		if again then
			Comm.sendObject("Test2", compress, to);
		else
			test3();
		end

	end

	Comm.registerProtocolPrefix("Test2", callback);
	Comm.sendObject("Test2", testStruct, to);
end

function test3()
	print("Test3: start ...");
	local to = "osef-OsefRealm";
	local testStruct = {
		["SI"] = {
			["c"] = {
				["BK"] = "{img:Interface\PETBATTLES\Weather-Sunlight:512:128}",
				["P"] = "coucou\n\n\ncuicui",
				["d"] = "  oo    ooo    ~~~   ~    ~~~    ~",
				[true] = "lol^Sprout~||}",
				[12.54] = "^^",
			}
		}
	};
	local compress = Utils.serial.encodeCompressMessage(Utils.serial.serialize(testStruct));
	print("Test3: sending ...");

	local callback = function(object, sender)
		print("Test3: receiving ...");
		local again = true;

		if type(object) == "string" then
			print("Test3: decoding ...");
			object = Utils.serial.decompressCodedStructure(object);
			again = false;
		end

		assert(to == sender, "Bad sender");
		assert(type(object) == "table", "Value is not a table.");
		assert(object["SI"]["c"][true] and testStruct["SI"]["c"][true] == object["SI"]["c"][true], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(testStruct["SI"]["c"][true]), tostring(object["SI"]["c"][true])));
		assert(object["SI"]["c"][12.54] and testStruct["SI"]["c"][12.54] == object["SI"]["c"][12.54], ("Unmatching: \"%s\" vs \"%s\""):format(tostring(testStruct["SI"]["c"][12.54]), tostring(object["SI"]["c"][12.54])));

		print("Test3: OK !");


		-- Compress version
		if again then
			Comm.sendObject("Test3", compress, to);
		else
			message("All test are ok");
		end

	end

	Comm.registerProtocolPrefix("Test3", callback);
	Comm.sendObject("Test3", testStruct, to);
end

-- /run TRP3_CommTest();
function TRP3_CommTest()
	Comm.setInterfaceID(Comm.interface_id.DIRECT_RELAY);
	test1();
end

local function onStart()

end

local MODULE_STRUCTURE = {
	["name"] = "Communicatio testing",
	["description"] = "Test for communication",
	["version"] = 1.000,
	["id"] = "com_testing",
	["onStart"] = onStart,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);

