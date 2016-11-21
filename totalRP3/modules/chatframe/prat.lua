if Prat then
	local PRAT_MODULE = Prat:RequestModuleName("Total RP 3")
	local pratModule = Prat:NewModule(PRAT_MODULE);

	local TRP3GetColoredName = TRP3_API.utils.customGetColoredName;
	local Globals = TRP3_API.globals;
	local unitInfoToID = TRP3_API.utils.str.unitInfoToID;
	local get = TRP3_API.profile.getData;
	local getColoredName = TRP3_API.chat.getColoredName;
	local getFullName = TRP3_API.chat.getFullnameUsingChatMethod;
	local numberToHexa = TRP3_API.utils.color.numberToHexa;
	local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
	local getUnitIDCurrentProfile = TRP3_API.register.getUnitIDCurrentProfile;
	local getFullnameUsingChatMethod = TRP3_API.chat.getFullnameUsingChatMethod;

	local function getCharacterInfoTab(unitID)
		if unitID == Globals.player_id then
			return get("player");
		elseif isUnitIDKnown(unitID) then
			return getUnitIDCurrentProfile(unitID) or {};
		end
		return {};
	end

	Prat:SetModuleDefaults(pratModule.moduleName, {
		profile = {
			on = true,
		},
	})
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

	function pratModule:Prat_PreAddMessage(arg, message, frame, event)
		local class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID(message.GUID);
		if not realm or realm == "" then -- Thanks Blizzard to not always send a full character ID
			realm = Globals.player_realm_id;
			if realm == nil then
				return
			end
		end
		local characterID = unitInfoToID(name, realm);
		local info = getCharacterInfoTab(characterID);
		local characterName = getFullnameUsingChatMethod(info, name);
		local color = getColoredName(info);
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
end