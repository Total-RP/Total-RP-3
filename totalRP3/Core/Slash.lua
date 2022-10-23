-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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

		local modifierString = (modifierValue == 0) and "" or format("%+d", modifierValue); -- we add a + to positive modifiers and don't render a 0 value
		Utils.message.displayMessage(loc.DICE_ROLL:format(Utils.str.icon(TRP3_InterfaceIcons.DiceRoll, 20), num, diceCount, modifierString, total));
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

	local totalMessage = loc.DICE_TOTAL:format(Utils.str.icon(TRP3_InterfaceIcons.DiceRoll, 20), total);
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
	-- TODO: The "set" command below will be refactored and moved elsewhere in
	--       a future update, and expanded to accommodate more fields.

	local KNOWN_FIELDS_LIST = {
		"class", "classcolor", "currently", "firstname", "fulltitle", "icon", "lastname", "oocinfo", "race", "title",
	};

	local KNOWN_FIELDS_MAP = tInvert(KNOWN_FIELDS_LIST);

	-- Deliberately not localizing these because we want flexibility to change
	-- them later if the syntax changes without invalidating a lot of locales.

	local EXAMPLE_COMMANDS = {
		"|cffffffff/trp3 set|r |cffffcc00currently|r |cff82c5ffDaydreaming about butterflies|r",
		"|cffffffff/trp3 set|r |cffffcc00title|r |cffcccccc[form:1]|r |cff82c5ffHappy Bear; Angry Elf|r",
		"|cffffffff/trp3 set|r |cffffcc00classcolor|r |cff82c5ff#ff0000|r",
	};

	TRP3_API.slash.registerCommand({
		id = "set",
		helpLine = " " .. loc.SLASH_CMD_SET_HELP,
		handler = function(field, ...)
			local data = string.trim(string.join(" ", ...));
			field = string.trim(field or "");

			-- Only parse macro options if the given string appears to start
			-- with one; this is because ParseMacroOption if called on a
			-- string that doesn't have a conditional will always only ever
			-- return a string up to the first semicolon - as such if you
			-- executed "/trp3 set field a;b;c" you'd only set "a".

			if string.find(data, "^%[") then
				data = AddOn_TotalRP3.ParseMacroOption(data);
			end

			local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();

			-- In terms of errors we prioritise feedback regarding unknown
			-- fields over errors about the default profile.

			if field == "" or field == "help" then
				local usage = "|cffffffff/trp3 set|r |cffffcc00<field>|r |cffcccccc[macro conditionals]|r |cff82c5ff<value...>|r";
				local fields = string.format("|cffffcc00%s|r", table.concat(KNOWN_FIELDS_LIST, ", "));
				local examples = table.concat(EXAMPLE_COMMANDS, "\n  ");
				SendSystemMessage(string.format(loc.SLASH_CMD_SET_HELP_DETAILED, usage, fields, examples));
			elseif not KNOWN_FIELDS_MAP[field] then
				SendSystemMessage(string.format(loc.SLASH_CMD_SET_FAILED_INVALID_FIELD, field));
			elseif currentUser:IsProfileDefault() then
				SendSystemMessage(string.format(loc.SLASH_CMD_SET_FAILED_DEFAULT_PROFILE, field));
			else
				local success = true;

				if field == "class" then
					currentUser:SetCustomClass(data);
				elseif field == "classcolor" then
					local hexcolor = string.match(data, "^#?(%x%x%x%x%x%x)$");

					if not hexcolor then
						SendSystemMessage(string.format(loc.SLASH_CMD_SET_FAILED_INVALID_COLOR, field, data));
						success = false;
					else
						currentUser:SetCustomClassColor(hexcolor);
					end
				elseif field == "currently" then
					currentUser:SetCurrentlyText(data);
				elseif field == "firstname" then
					currentUser:SetFirstName(data);
				elseif field == "fulltitle" then
					currentUser:SetFullTitle(data);
				elseif field == "icon" then
					local iconIndex = LibStub:GetLibrary("LibRPMedia-1.0"):GetIconIndexByName(data);

					if not iconIndex then
						SendSystemMessage(string.format(loc.SLASH_CMD_SET_FAILED_INVALID_ICON, field, data));
						success = false;
					else
						currentUser:SetCustomIcon(data);
					end
				elseif field == "lastname" then
					currentUser:SetLastName(data);
				elseif field == "oocinfo" then
					currentUser:SetOutOfCharacterInfo(data);
				elseif field == "race" then
					currentUser:SetCustomRace(data);
				elseif field == "title" then
					currentUser:SetTitle(data);
				end

				if success then
					SendSystemMessage(string.format(loc.SLASH_CMD_SET_SUCCESS, field));
				end
			end
		end
	});

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
					local modifierString = (arg.m == 0) and "" or format("%+d", arg.m); -- we add a + to positive modifiers and don't render a 0 value
					Utils.message.displayMessage(loc.DICE_ROLL_T:format(Utils.str.icon(TRP3_InterfaceIcons.DiceRoll, 20), sender, arg.c, arg.d, modifierString, arg.t));
				elseif arg.t then
					local totalMessage = loc.DICE_TOTAL_T:format(Utils.str.icon(TRP3_InterfaceIcons.DiceRoll, 20), sender, arg.t);
					Utils.message.displayMessage(totalMessage);
				end
				Utils.music.playSoundID(36629, "SFX", sender);
			end
		end
	end);
end);
