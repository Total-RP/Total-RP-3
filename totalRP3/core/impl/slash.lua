----------------------------------------------------------------------------------
--- Total RP 3
--- Slash commands
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

local loc = TRP3_API.loc;
local displayMessage = TRP3_API.utils.message.displayMessage;
local tonumber, math, tinsert, type, assert, tostring, pairs, sort = tonumber, math, tinsert, type, assert, tostring, pairs, table.sort;
local IsInGroup, IsInRaid = IsInGroup, IsInRaid;

TRP3_API.slash = {}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Command management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local COMMANDS = {};

function TRP3_API.slash.registerCommand(commandStructure)
	assert(commandStructure and commandStructure.id, "Command structure must have and id.");
	assert(commandStructure.id ~= "help", "The command id \"help\" is reserved.");
	assert(not COMMANDS[commandStructure.id], "Already registered command id: " .. tostring(commandStructure.id));
	COMMANDS[commandStructure.id] = commandStructure;
end

function TRP3_API.slash.unregisterCommand(commandID)
	COMMANDS[commandID] = nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Command handling
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

SLASH_TOTALRP31, SLASH_TOTALRP32 = '/trp3', '/totalrp3';
local sortTable = {};

function SlashCmdList.TOTALRP3(msg)
	local args = {strsplit(" ", msg)};
	local cmdID = args[1];
	table.remove(args, 1);

	if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
		COMMANDS[cmdID].handler(unpack(args));
	else
		-- Show command list
		displayMessage(loc.COM_LIST);
		wipe(sortTable);
		for commandId, _ in pairs(COMMANDS) do
			tinsert(sortTable, commandId);
		end
		sort(sortTable);
		for _, commandId in pairs(sortTable) do
			local cmd, cmdText = COMMANDS[commandId], TRP3_API.Ellyb.ColorManager.GREEN("/trp3 " .. commandId);
			if cmd.helpLine then
				cmdText = cmdText .. TRP3_API.Ellyb.ColorManager.ORANGE(cmd.helpLine);
			end
			displayMessage(cmdText);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Dices roll
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local UnitExists, UnitInParty, UnitInRaid = UnitExists, UnitInParty, UnitInRaid;

local DICE_SIGNAL = "DISN";

--- isTargetValidForDiceRoll checks if the target unit is valid for sending
--  the outcome of a dice roll to.
--
--  Returns true if the target is a friendly player who is not in your raid or
--  party.
local function isTargetValidForDiceRoll()
	return UnitExists("target")
		and not (UnitInParty("target") or UnitInRaid("target"))
		and UnitIsPlayer("target")
		and UnitFactionGroup("player") == UnitFactionGroup("target");
end

local function sendDiceRoll(args)
	if isTargetValidForDiceRoll() then
		AddOn_TotalRP3.Communications.sendObject(DICE_SIGNAL, args, Utils.str.getUnitID("target"));
	end
	if IsInRaid() then
		AddOn_TotalRP3.Communications.sendObject(DICE_SIGNAL, args, "RAID");
	elseif IsInGroup() then
		AddOn_TotalRP3.Communications.sendObject(DICE_SIGNAL, args, "PARTY");
	end
end

local function rollDice(diceString)
	local _, _, num, diceCount, modifierOperator, modifierValue = diceString:find("(%d*)d(%d+)([-+]?)(%d*)");
	num = tonumber(num) or 1;
	diceCount = tonumber(diceCount) or 0;

	modifierOperator = modifierOperator or "+";
	modifierValue = tonumber(modifierValue) or 0;
	if modifierOperator == "-" then
		modifierValue = -modifierValue
	end

	if num > 0 and diceCount > 0 then
		local total = 0;
		for _ = 1, num do
			local value = math.random(1, diceCount);
			total = total + value;
		end

		total = total + modifierValue;

		Utils.message.displayMessage(loc.DICE_ROLL:format(Utils.str.icon(TRP3_API.globals.is_classic and "inv_enchant_shardglowingsmall" or "inv_misc_dice_02", 20), num, diceCount, total));
		sendDiceRoll({c = num, d = diceCount, t = total, m = modifierValue});
		return total;
	end
	return 0;
end

function TRP3_API.slash.rollDices(...)
	local args = {...};
	local total = 0;
	local i = 0;

	if #args == 0 then
		tinsert(args, "1d100");
	end
	for index, roll in pairs(args) do
		total = total + rollDice(roll);
		i = index;
	end

	local totalMessage = loc.DICE_TOTAL:format(Utils.str.icon(TRP3_API.globals.is_classic and "inv_enchant_shardglowingsmall" or "inv_misc_dice_01", 20), total);
	if i > 1 then
		Utils.message.displayMessage(totalMessage);
		sendDiceRoll({t = total});
	end
	Utils.message.displayMessage(totalMessage, 3);
	TRP3_API.ui.misc.playSoundKit(36629, "SFX");
	Events.fireEvent("TRP3_ROLL", strjoin(" ", unpack(args)), total);

	return total, i;
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()



	-- Slash command to switch frames
	TRP3_API.slash.registerCommand({
		id = "roll",
		helpLine = " " .. loc.DICE_HELP,
		handler = function(...)
			TRP3_API.slash.rollDices(...);
		end
	});

	AddOn_TotalRP3.Communications.registerSubSystemPrefix(DICE_SIGNAL, function(arg, sender)
		if sender ~= Globals.player_id then
			if type(arg) == "table" then
				if arg.c and arg.d and arg.t then
					Utils.message.displayMessage(loc.DICE_ROLL_T:format(Utils.str.icon(TRP3_API.globals.is_classic and "inv_enchant_shardglowingsmall" or "inv_misc_dice_02", 20), sender, arg.c, arg.d, arg.t));
				elseif arg.t then
					local totalMessage = loc.DICE_TOTAL_T:format(Utils.str.icon(TRP3_API.globals.is_classic and "inv_enchant_shardglowingsmall" or "inv_misc_dice_01", 20), sender, arg.t);
					Utils.message.displayMessage(totalMessage);
				end
				Utils.music.playSoundID(36629, "SFX", sender);
			end
		end
	end);
end);
