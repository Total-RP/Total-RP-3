local function onStart()
	-- Stop right here if Prat is not installed
	if not Prat then return false, "Prat not found." end;

	Prat:AddModuleToLoad(function()

		-- Create Prat module
		local PRAT_MODULE = Prat:RequestModuleName("Total RP 3")
		local pratModule = Prat:NewModule(PRAT_MODULE);
	
		-- Import Total RP 3 functions
		local unitInfoToID                      = TRP3_API.utils.str.unitInfoToID; -- Get "Player-Realm" unit ID
		local getUnitColor                      = TRP3_API.utils.color.getUnitColor; -- Get unit color (custom or default)
		local getFullnameForUnitUsingChatMethod = TRP3_API.chat.getFullnameForUnitUsingChatMethod; -- Get full name using settings
		local isChannelHandled                  = TRP3_API.chat.isChannelHandled; -- Check if Total RP 3 handles this channel
		local configIsChannelUsed               = TRP3_API.chat.configIsChannelUsed; -- Check if a channel is enable in settings
	
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
			
			-- Get the unit color and name
			local color = getUnitColor(unitID);
			local characterName = getFullnameForUnitUsingChatMethod(unitID, name);

			-- Replace the message player name with the colored character name
			message.PLAYER = color:WrapTextInColorCode(characterName);
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
	["name"] = "Prat support",
	["description"] = "Add support for the Prat add-on.",
	["version"] = 1.1,
	["id"] = "trp3_prat",
	["onStart"] = onStart,
	["minVersion"] = 25,
	["requiredDeps"] = {
		{"trp3_chatframes",  1.100},
	}
});