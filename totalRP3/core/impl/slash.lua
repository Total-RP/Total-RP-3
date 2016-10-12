----------------------------------------------------------------------------------
-- Total RP 3
-- Slash commands
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local loc = TRP3_API.locale.getText;
local displayMessage = TRP3_API.utils.message.displayMessage;
local _G, tonumber, math, tinsert, type, assert, tostring, pairs, sort, strconcat = _G, tonumber, math, tinsert, type, assert, tostring, pairs, table.sort, strconcat;

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

function SlashCmdList.TOTALRP3(msg, editbox)
	local args = {strsplit(" ", msg)};
	local cmdID = args[1];
	table.remove(args, 1);

	if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
		COMMANDS[cmdID].handler(unpack(args));
	else
		-- Show command list
		displayMessage(loc("COM_LIST"));
		wipe(sortTable);
		for cmdID, _ in pairs(COMMANDS) do
			tinsert(sortTable, cmdID);
		end
		sort(sortTable);
		for _, cmdID in pairs(sortTable) do
			local cmd, cmdText = COMMANDS[cmdID], "|cff00ff00/trp3 " .. cmdID .. "|r|cffff9900";
			if cmd.helpLine then
				cmdText = cmdText .. cmd.helpLine;
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local DICE_SIGNAL = "DISN";

	local function sendDiceRoll(args)
		if UnitExists("target") and not (UnitInParty("target") or UnitInRaid("target")) then
			TRP3_API.communication.sendObject(DICE_SIGNAL, args, Utils.str.getUnitID("target"));
		end
		if IsInRaid() then
			TRP3_API.communication.sendObject(DICE_SIGNAL, args, "RAID");
		elseif IsInGroup() then
			TRP3_API.communication.sendObject(DICE_SIGNAL, args, "PARTY");
		end
	end

	local function rollDice(diceString)
		local _, _, num, diceCount = diceString:find("(%d+)d(%d+)");
		if num and diceCount then
			num = tonumber(num) or 0;
			diceCount = tonumber(diceCount) or 0;
			local total = 0;
			for i = 1, num do
				local value = math.random(1, diceCount);
				total = total + value;
			end
			Utils.message.displayMessage(loc("DICE_ROLL"):format(Utils.str.icon("inv_misc_dice_02", 20), num, diceCount, total));
			sendDiceRoll({c = num, d = diceCount, t = total});
			return total;
		end
		return 0;
	end

	-- Slash command to switch frames
	TRP3_API.slash.registerCommand({
		id = "roll",
		helpLine = " " .. loc("DICE_HELP"),
		handler = function(...)
			local total = 0;
			local i = 0;
			local args = {...};
			if #args == 0 then
				tinsert(args, "1d100");
			end
			for index, roll in pairs(args) do
				total = total + rollDice(roll);
				i = index;
			end

			local totalMessage = loc("DICE_TOTAL"):format(Utils.str.icon("inv_misc_dice_01", 20), total);
			if i > 1 then
				Utils.message.displayMessage(totalMessage);
				sendDiceRoll({t = total});
			end
			Utils.message.displayMessage(totalMessage, 3);
		end
	});

	TRP3_API.communication.registerProtocolPrefix(DICE_SIGNAL, function(arg, sender)
		if sender ~= Globals.player_id then
			if type(arg) == "table" then
				if arg.c and arg.d and arg.t then
					Utils.message.displayMessage(loc("DICE_ROLL_T"):format(Utils.str.icon("inv_misc_dice_02", 20), sender, arg.c, arg.d, arg.t));
				elseif arg.t then
					local totalMessage = loc("DICE_TOTAL_T"):format(Utils.str.icon("inv_misc_dice_01", 20), sender, arg.t);
					Utils.message.displayMessage(totalMessage);
				end
			end
		end
	end);
end);