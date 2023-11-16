-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

if not Prat then
	return;
end

---@type TRP3_API
local _, TRP3_API = ...;

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
		if not message.GUID or not C_PlayerInfo.GUIDIsPlayer(message.GUID) then return end;

		-- If the message has no player, we don't have anything to do with this
		if not TRP3_API.utils.str.emptyToNil(message.PLAYER) then return end;

		-- Do not do any modification if the channel is not handled by TRP3 or customizations has been disabled
		-- for that channel in the settings
		if not TRP3_API.chat.isChannelHandled(event) or not TRP3_API.chat.configIsChannelUsed(event) then return end;

		-- Retrieve all the player info from the message GUID
		local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(message.GUID);

		-- Calling our unitInfoToID() function to get a "Player-Realm" formatted string (handles cases where realm is nil)
		local unitID = TRP3_API.utils.str.unitInfoToID(name, realm);
		local characterName = unitID;

		-- Extract the color if present used by Prat so we use it by default;
		-- can be nil.
		local characterColor = TRP3_API.ParseColorFromHexMarkup(message.PLAYER);

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
			local player = AddOn_TotalRP3.Player.CreateFromCharacterID(unitID);
			local customColor = player:GetCustomColorForDisplay(unitID);

			if customColor then
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
