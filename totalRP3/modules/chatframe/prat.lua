local function onStart()
	-- Stop right here if Prat is not installed
	if not Prat then return false, "Prat not found." end;

	Prat:AddModuleToLoad(function()

		local PRAT_MODULE = Prat:RequestModuleName("Total RP 3")
		local pratModule = Prat:NewModule(PRAT_MODULE);

		local tContains = tContains;

		local Globals = TRP3_API.globals;
		local unitInfoToID = TRP3_API.utils.str.unitInfoToID;
		local get = TRP3_API.profile.getData;
		local getColoredName = TRP3_API.chat.getColoredName;
		local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
		local getUnitIDCurrentProfile = TRP3_API.register.getUnitIDCurrentProfile;
		local getFullnameUsingChatMethod = TRP3_API.chat.getFullnameUsingChatMethod;

		local getConfigValue = TRP3_API.configuration.getValue;
		local getHandledChannels = TRP3_API.chat.getPossibleChannels;
		local CONFIG_USAGE = "chat_use_";

		local function getCharacterInfoTab(unitID)
			if unitID == Globals.player_id then
				return get("player");
			elseif isUnitIDKnown(unitID) then
				return getUnitIDCurrentProfile(unitID) or {};
			end
			return {};
		end

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

		Prat:SetModuleDefaults(pratModule.name, {
			profile = {
				on = true,
			},
		});

		function pratModule:Prat_PreAddMessage(arg, message, frame, event)

			-- If the message has no GUID (system?) we don't have anything to do with this
			if not message.GUID then return end;

			-- Do not do any modification if the channel is not handled by TRP3 or customizations has been disabled
			-- for that channel in the settings
			if not tContains(getHandledChannels(), event) or not getConfigValue(CONFIG_USAGE .. event) then return end;

			-- Retrieve all the player info from the message GUID
			local class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID(message.GUID);

			if not realm or realm == "" then -- Thanks Blizzard for not always sending a full character ID
				realm = Globals.player_realm_id;
				if realm == nil then
					return
				end
			end

			local characterID = unitInfoToID(name, realm);
			local info = getCharacterInfoTab(characterID);
			local characterName = getFullnameUsingChatMethod(info, name);
			local color = getColoredName(info);

			if characterName == name and not color then return end;

			if color then
				characterName = ("|cff%s%s|r"):format(color, characterName);
			end

			message.PLAYER = characterName;
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

local MODULE_STRUCTURE = {
	["name"] = "Prat support",
	["description"] = "Add support for the Prat add-on.",
	["version"] = 1.000,
	["id"] = "trp3_prat",
	["onStart"] = onStart,
	["minVersion"] = 25,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);