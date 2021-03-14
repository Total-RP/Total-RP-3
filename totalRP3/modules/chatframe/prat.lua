----------------------------------------------------------------------------------
--- Total RP 3
--- Prat plugin
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Morgane "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

if not Prat then
	return;
end

---@type TRP3_API
local _, TRP3_API = ...;

local function GUIDIsPlayer(guid)
	if type(guid) ~= "string" then
		return false;
	end

	if C_PlayerInfo.GUIDIsPlayer then
		return C_PlayerInfo.GUIDIsPlayer(guid);
	else
		-- Classic: Lacks C_PlayerInfo.GUIDIsPlayer, this is how it works though.
		return string.find(guid, "^Player%-") ~= nil;
	end
end

Prat:AddModuleToLoad(function()
	local PRAT_MODULE = Prat:RequestModuleName("Total RP 3")
	local pratModule = Prat:NewModule(PRAT_MODULE);
	local PL = pratModule.PL;

	PL:AddLocale(PRAT_MODULE, "enUS", {
		module_name = "Total RP 3",
		module_desc = "Total RP 3 customizations for Prat",
	});

	Prat:SetModuleOptions(pratModule, {
		name = "Total RP 3",
		desc = "Total RP 3 customizations for Prat",
		type = "group",
		args = {
			info = {
				name = "Total RP 3 customizations for Prat",
				type = "description",
			}
		}
	});

	-- Enable Total RP 3's module by default
	Prat:SetModuleDefaults(pratModule.name, {
		profile = {
			on = true,
		},
	});

	-- Runs before Prat add the message to the chat frames
	function pratModule:Prat_PreAddMessage(_, message, _, event)
		if TRP3_API.chat.disabledByOOC() then return end;

		-- If the message has no GUID (system?) or an invalid GUID (WIM >:( ) we don't have anything to do with this
		if not message.GUID or not GUIDIsPlayer(message.GUID) then return end;

		-- Do not do any modification if the channel is not handled by TRP3 or customizations has been disabled
		-- for that channel in the settings
		if not TRP3_API.chat.isChannelHandled(event) or not TRP3_API.chat.configIsChannelUsed(event) then return end;

		-- Retrieve all the player info from the message GUID
		local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(message.GUID);

		-- Calling our unitInfoToID() function to get a "Player-Realm" formatted string (handles cases where realm is nil)
		local unitID = TRP3_API.utils.str.unitInfoToID(name, realm);
		local characterName = unitID;

		--- Extract the color used by Prat so we use it by default
		---@type ColorMixin
		local characterColor = TRP3_API.utils.color.extractColorFromText(message.PLAYER);

		-- Character name is without the server name is they are from the same realm or if the option to remove realm info is enabled
		if realm == TRP3_API.globals.player_realm_id or TRP3_API.configuration.getValue("remove_realm") then
			characterName = name;
		end

		-- Get the unit color and name
		local customizedName = TRP3_API.chat.getFullnameForUnitUsingChatMethod(unitID);

		if customizedName then
			characterName = customizedName;
		end

		-- We retrieve the custom color if the option for custom colored names in chat is enabled
		if TRP3_API.chat.configShowNameCustomColors() then
			local customColor = TRP3_API.utils.color.getUnitCustomColor(unitID);

			-- If we do have a custom
			if customColor then
				-- Check if the option to increase the color contrast is enabled
				if AddOn_TotalRP3.Configuration.shouldDisplayIncreasedColorContrast() then
					-- And lighten the color if it is
					customColor:LightenColorUntilItIsReadable();
				end

				-- And finally, use the color
				characterColor = customColor;
			end
		end

		if characterColor then
			-- If we have a valid color in the end, wrap the name around the color's code
			characterName = characterColor:WrapTextInColorCode(characterName);
		end

		if TRP3_API.configuration.getValue("chat_show_icon") then
			local info = TRP3_API.utils.getCharacterInfoTab(unitID);
			if info and info.characteristics and info.characteristics.IC then
				characterName = TRP3_API.utils.str.icon(info.characteristics.IC, 15) .. " " .. characterName;
			end
		end

		-- Check if this message was flagged as containing a 's at the beggning.
		-- To avoid having a space between the name of the player and the 's we previously removed the 's
		-- from the message. We now need to insert it after the player's name, without a space.
		if TRP3_API.chat.getOwnershipNameID() == message.GUID then
			characterName = characterName .. "'s";
		end

		-- Replace the message player name with the colored character name
		message.PLAYER = characterName
		message.sS = nil
		message.SERVER = nil
		message.Ss = nil
	end

	function pratModule:OnModuleEnable()
		Prat.RegisterChatEvent(pratModule, "Prat_PreAddMessage");
	end

	function pratModule:OnModuleDisable()
		Prat.UnregisterChatEvent(pratModule, "Prat_PreAddMessage");
	end
end);
