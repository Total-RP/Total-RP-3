----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Inventory Effects
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Effetc structure
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tostring = tostring;

TRP3_API.inventory.EFFECTS = {

	["item_durability"] = {
		codeReplacementFunc = function (args)
			local target = "containerInfo";
			if args[1] == "self" then
				target = "slotInfo";
			end
			return ("lastEffectReturn = changeContainerDurability(args.%s, %s);"):format(target, args[2]);
		end,
		env = {
			changeContainerDurability = "TRP3_API.inventory.changeContainerDurability",
		}
	},

	["item_sheath"] = {
		codeReplacementFunc = function ()
			return "ToggleSheath(); lastEffectReturn = 0;"
		end,
		env = {
			ToggleSheath = "ToggleSheath",
		}
	},

	["item_consumme"] = {
		codeReplacementFunc = function (args)
			return ("lastEffectReturn = consumeItem(args.slotInfo, args.containerInfo, %s);"):format(args[1]);
		end,
		env = {
			consumeItem = "TRP3_API.inventory.consumeItem",
		}
	},

	["item_addItem"] = {
		codeReplacementFunc = function (args)
			local targetContainer = "args.containerInfo"; -- TODO: selectable or new effect for "add in" ?
			local count = args[2] or 1;
			local madeBy = args[3] or false;
			return ("lastEffectReturn = addItem(%s, \"%s\", {count = %d, madeBy = %s});"):format(targetContainer, args[1], count, tostring(madeBy));
		end,
		env = {
			addItem = "TRP3_API.inventory.addItem",
		}
	},

	["item_loot"] = {
		codeReplacementFunc = function (args)
			local lootID = args[1];
			return ("presentLoot(args.class, \"%s\"); lastEffectReturn = 0;"):format(lootID);
		end,
		env = {
			presentLoot = "TRP3_API.inventory.presentLoot",
		}
	},

}