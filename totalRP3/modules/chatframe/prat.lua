----------------------------------------------------------------------------------
--- Total RP 3
--- Prat plugin
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

local loc = TRP3_API.locale.getText;

local function onStart()
	-- Stop right here if Prat is not installed
	if not Prat then
		return false, loc("MO_ADDON_NOT_INSTALLED"):format("Prat");
	end;

	Prat:AddModuleToLoad(function()

		-- Create Prat module
		local PRAT_MODULE = Prat:RequestModuleName("Total RP 3")
		local pratModule = Prat:NewModule(PRAT_MODULE);
	
		-- Import Total RP 3 functions
		local Globals 							= TRP3_API.globals;
		local unitInfoToID                      = TRP3_API.utils.str.unitInfoToID; -- Get "Player-Realm" unit ID
		local getFullnameForUnitUsingChatMethod = TRP3_API.chat.getFullnameForUnitUsingChatMethod; -- Get full name using settings
		local isChannelHandled                  = TRP3_API.chat.isChannelHandled; -- Check if Total RP 3 handles this channel
		local configIsChannelUsed               = TRP3_API.chat.configIsChannelUsed; -- Check if a channel is enable in settings
		local configIncreaseNameColorContrast   = TRP3_API.chat.configIncreaseNameColorContrast; -- Check if the config is to increase color contrast for custom colored names
		local configShowNameCustomColors        = TRP3_API.chat.configShowNameCustomColors; -- Check if the config is to use custom color for names
		local getUnitCustomColor                = TRP3_API.utils.color.getUnitCustomColor; -- Get the custom color of a unit using its Unit ID
		local extractColorFromText              = TRP3_API.utils.color.extractColorFromText; -- Get a Color object from a colored text
		local getOwnershipNameID                = TRP3_API.chat.getOwnershipNameID; -- Get the latest message ID associated to an ownership mark ('s)
		local getConfigValue 					= TRP3_API.configuration.getValue;
		local getCharacterInfoTab 				= TRP3_API.utils.getCharacterInfoTab;
		local icon 								= TRP3_API.utils.str.icon;
		-- WoW imports
		local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
	

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
		function pratModule:Prat_PreAddMessage(arg, message, frame, event)

			-- If the message has no GUID (system?) we don't have anything to do with this
			if not message.GUID then return end;

			-- Do not do any modification if the channel is not handled by TRP3 or customizations has been disabled
			-- for that channel in the settings
			if not isChannelHandled(event) or not configIsChannelUsed(event) then return end;


			-- Retrieve all the player info from the message GUID
			local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(message.GUID);
		
			-- Calling our unitInfoToID() function to get a "Player-Realm" formatted string (handles cases where realm is nil)
			local unitID = unitInfoToID(name, realm);
			local characterName = unitID;

			--- Extract the color used by Prat so we use it by default
			---@type ColorMixin
			local characterColor = extractColorFromText(message.PLAYER);

			-- Character name is without the server name is they are from the same realm or if the option to remove realm info is enabled
			if realm == Globals.player_realm_id or getConfigValue("remove_realm") then
				characterName = name;
			end

			-- Get the unit color and name
			characterName = getFullnameForUnitUsingChatMethod(unitID, characterName);

			-- We retrieve the custom color if the option for custom colored names in chat is enabled
			if configShowNameCustomColors() then
				local customColor = getUnitCustomColor(unitID);

				-- If we do have a custom
				if customColor then
					-- Check if the option to increase the color contrast is enabled
					if configIncreaseNameColorContrast() then
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

			if getConfigValue("chat_show_icon") then
				local info = getCharacterInfoTab(unitID);
				if info and info.characteristics and info.characteristics.IC then
					characterName = icon(info.characteristics.IC, 15) .. " " .. characterName;
				end
			end

			-- Check if this message was flagged as containing a 's at the beggning.
			-- To avoid having a space between the name of the player and the 's we previously removed the 's
			-- from the message. We now need to insert it after the player's name, without a space.
			if getOwnershipNameID() == message.GUID then
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
end

-- Register a Total RP 3 module that can be disabled in the settings
TRP3_API.module.registerModule({
	["name"] = "Prat",
	["description"] = loc("MO_CHAT_CUSTOMIZATIONS_DESCRIPTION"):format("TinyTooltip"),
	["version"] = 1.1,
	["id"] = "trp3_prat",
	["onStart"] = onStart,
	["minVersion"] = 25,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});