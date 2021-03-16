---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.SlashCommand then
	return
end

-- Lua imports
local format = string.format;
local uppercase = string.upper;
local lowercase = string.lower;
local strtrim = strtrim;
local assert = assert;
local pairs = pairs;
local unpack = unpack;
local remove = table.remove;
local strsplit = strsplit;
local print = print;
local _G = _G;

-- Ellyb imports
local Logger = Ellyb.Logger("SlashCommand");

local SlashCommand = {};
Ellyb.SlashCommand = SlashCommand;

local SLASH_COMMAND_GLOBAL_FORMAT = "SLASH_%s1";
local COMMANDS = {};

function SlashCommand:InitializeCommand(commandKey)
	local globalName = uppercase(strtrim(commandKey));
	local globalKey = format(SLASH_COMMAND_GLOBAL_FORMAT, globalName);
	local slashCommandName = "/" .. lowercase(strtrim(commandKey));
	_G[globalKey] = slashCommandName;

	_G.SlashCmdList[globalName] = function(text)
		local args = { strsplit(" ", text) };
		local cmdID = args[1];
		remove(args, 1);

		cmdID = lowercase(cmdID);

		if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
			Logger:Info("Running command " .. cmdID, unpack(args));
			COMMANDS[cmdID].handler(unpack(args));
		else
			if cmdID then
				Logger:Info("Command not found " .. cmdID);
			end

			-- Show command list
			print("List of slash commands for " .. Ellyb.addOnName);

			for command, commandInfo in pairs(COMMANDS) do
				local cmdText = Ellyb.ColorManager.GREEN(slashCommandName) .. " " .. Ellyb.ColorManager.ORANGE(command);
				if commandInfo.helpLine then
					cmdText = cmdText .. Ellyb.ColorManager.GREY(commandInfo.helpLine);
				end
				print(cmdText);
			end
		end
	end
end

function SlashCommand:RegisterCommand(command, handler, help)
	Ellyb.Assertions.isType(command, "string", "command");
	Ellyb.Assertions.isType(handler, "function", "handler");
	command = lowercase(command);
	assert(not COMMANDS[command], "Already registered command " .. command);

	COMMANDS[command] = {
		handler = handler,
		helpLine = help,
	};
	Logger:Info("Registered new slash command: " .. command .. ", with helper text: " .. (help or ""));
end

function SlashCommand:UnregisterCommand(commandID)
	COMMANDS[commandID] = nil;
	Logger:Info("Unregistered slash command " .. commandID);
end
