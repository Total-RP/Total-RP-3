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
	local cmdID, arg1, arg2, arg3, arg4, arg5, arg6 = strsplit(" ", msg);

	if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
		COMMANDS[cmdID].handler(arg1, arg2, arg3, arg4, arg5, arg6);
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