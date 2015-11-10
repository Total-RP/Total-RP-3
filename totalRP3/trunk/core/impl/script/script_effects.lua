----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Effects
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local assert, type, tostring, error, tonumber, pairs, unpack, wipe = assert, type, tostring, error, tonumber, pairs, unpack, wipe;
local escape = TRP3_API.script.escapeArguments;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Effetc structure
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local EFFECTS = {

	["MISSING"] = {
		codeReplacementFunc = function (_, id)
			return ("message(\"|cffff0000Script error, unknown FX: %s\", 1);"):format(id); -- TODO: local
		end,
		env = {
			message = "TRP3_API.utils.message.displayMessage",
		}
	},

	-- Graphic
	["text"] = {
		codeReplacementFunc = function (args)
			local text = args[1] or "";
			local type = args[2] or 1;
			return ("message(\"%s\", %s);"):format(text, type);
		end,
		args = 1,
		env = {
			message = "TRP3_API.utils.message.displayMessage",
		}
	},

	-- Sounds

	-- Inventory

	["durability"] = {
		codeReplacementFunc = function (args)
			local target = "containerInfo";
			if args[1] == "self" then
				target = "slotInfo";
			end
			return ("changeContainerDurability(args.%s, %s);"):format(target, args[2]);
		end,
		env = {
			changeContainerDurability = "TRP3_API.inventory.changeContainerDurability",
		}
	},

	["sheath"] = {
		codeReplacementFunc = function ()
			return "ToggleSheath();"
		end,
		env = {
			ToggleSheath = "ToggleSheath",
		}
	},

	["consumme"] = {
		codeReplacementFunc = function (args)
			return ("consumeItem(args.slotInfo, args.containerInfo, %s);"):format(args[1]);
		end,
		env = {
			consumeItem = "TRP3_API.inventory.consumeItem",
		}
	},

	["addItem"] = {
		codeReplacementFunc = function (args)
			local targetContainer = "args.containerInfo"; -- TODO: selectable or new effect for "add in" ?
			return ("addItem(%s, \"%s\");"):format(targetContainer, args[1]);
		end,
		env = {
			addItem = "TRP3_API.inventory.addItem",
		}
	},

	-- Companions

	["dismissMount"] = {
		codeReplacementFunc = function ()
			return "DismissCompanion(\"MOUNT\");"
		end,
		env = {
			DismissCompanion = "DismissCompanion",
		}
	},

	["dismissCritter"] = {
		codeReplacementFunc = function ()
			return "DismissCompanion(\"CRITTER\");"
		end,
		env = {
			DismissCompanion = "DismissCompanion",
		}
	},

	-- DEBUG EFFECTs
	["debugText"] = {
		codeReplacementFunc = function (args)
			return ("debug(\"%s\", DEBUG);"):format(unpack(args));
		end,
		args = 1,
		env = {
			debug = "TRP3_API.utils.log.log",
			DEBUG = "TRP3_API.utils.log.level.DEBUG",
		}
	},

	["debugDumpArg"] = {
		codeReplacementFunc = function (args)
			local value = tostring(args[1]);
			return ("debug(\"Dumping arg %s\", DEBUG); dump(args.%s);"):format(value, value);
		end,
		env = {
			dump = "TRP3_API.utils.table.dump",
			debug = "TRP3_API.utils.log.log",
			DEBUG = "TRP3_API.utils.log.level.DEBUG",
		}
	},

	["debugDumpArgs"] = {
		codeReplacementFunc = function ()
			return "dump(args);";
		end,
		env = {
			dump = "TRP3_API.utils.table.dump",
		}
	},
}


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.script.registerEffect = function(effect)
	assert(type(effect) == "table" and effect.id, "Effect must have an id.");
	assert(not EFFECTS[effect.id], "Already registered effect id: " .. effect.id);
	EFFECTS[effect.id] = effect;
end

TRP3_API.script.getEffect = function(effectID)
	return EFFECTS[effectID];
end