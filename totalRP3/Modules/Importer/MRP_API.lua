-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	if not mrpSaved then
		return;
	end

	local tcopy, getDefaultProfile = TRP3_API.utils.table.copy, TRP3_API.profile.getDefaultProfile;
	local loc = TRP3_API.loc;

	local MRP = {};
	local L = mrp.L;
	local importableData = {
		HH = L.HH,
		HI = L.HI,
		DE = L.DE,
		AE = L.AE,
		AG = L.AG,
		HB = L.HB,
		AH = L.AH,
		NA = L.NA,
		RA = L.RA,
		AW = L.AW,
		FC = L.FC,
		NH = L.NH,
		NI = L.NI,
		NT = L.NT,
		MO = L.MO,
		FR = L.FR,
		CU = L.CU
	};
	local profilesList;

	local function initProfilesList()
		profilesList = {};
		for name, profile in pairs(mrpSaved.Profiles) do
			if name == "Default" then
				name = TRP3_API.globals.player_id;
			end
			local profileName = MRP.addOnVersion().."-"..name;
			profilesList[profileName] = { name = name, info = {}};
			for field, value in pairs(profile) do
				profilesList[profileName]["info"][field] = value;
			end
		end
	end

	MRP.isAvailable = function()
		return mrpSaved ~= nil;
	end

	MRP.addOnVersion = function()
		local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata;
		return "MyRolePlay - " .. GetAddOnMetadata("MyRolePlay", "Version");
	end


	MRP.getProfile = function(profileID)
		return profilesList[profileID];
	end

	MRP.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID].info;

		tcopy(profile, getDefaultProfile());
		profile.player.characteristics.FN = importedProfile.NA;
		profile.player.characteristics.FT = importedProfile.NT;
		profile.player.characteristics.RA = importedProfile.RA;
		profile.player.characteristics.AG = importedProfile.AG;
		profile.player.characteristics.RE = importedProfile.HH;
		profile.player.characteristics.BP = importedProfile.HB;
		profile.player.characteristics.EC = importedProfile.AE;
		profile.player.characteristics.HE = importedProfile.AH;
		profile.player.characteristics.WE = importedProfile.AW;
		if importedProfile.MO then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.Motto,
				NA = loc.REG_PLAYER_MSP_MOTTO;
				VA = "\"" .. importedProfile.MO .. "\"";
				IC = TRP3_InterfaceIcons.MiscInfoMotto;
			});
		end
		if importedProfile.NI then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.Nickname,
				NA = loc.REG_PLAYER_MSP_NICK;
				VA = importedProfile.NI;
				IC = TRP3_InterfaceIcons.MiscInfoNickname;
			});
		end
		if importedProfile.NH then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.House,
				NA = loc.REG_PLAYER_MSP_HOUSE;
				VA = importedProfile.NH;
				IC = TRP3_InterfaceIcons.MiscInfoHouse;
			});
		end
		if importedProfile.PN then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.Pronouns,
				NA = loc.REG_PLAYER_MISC_PRESET_PRONOUNS;
				VA = importedProfile.PN;
				IC = TRP3_InterfaceIcons.MiscInfoPronouns;
			});
		end
		if importedProfile.PG then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.GuildName,
				NA = loc.REG_PLAYER_MISC_PRESET_GUILD_NAME;
				VA = importedProfile.PG;
				IC = TRP3_InterfaceIcons.MiscInfoGuildName;
			});
		end
		if importedProfile.PR then
			tinsert(profile.player.characteristics.MI, {
				ID = TRP3_API.MiscInfoType.GuildRank,
				NA = loc.REG_PLAYER_MISC_PRESET_GUILD_RANK;
				VA = importedProfile.PR;
				IC = TRP3_InterfaceIcons.MiscInfoGuildRank;
			});
		end
		profile.player.character.CU = importedProfile.CU;
		profile.player.about.T3.PH.TX = importedProfile.DE;
		profile.player.about.T3.HI.TX = importedProfile.HI;
		profile.player.about.TE = 3;

		-- TODO Custom RP styles

		return profile;
	end

	MRP.listAvailableProfiles = function()
		initProfilesList()
		local list = {};
		for key, _ in pairs(profilesList) do
			list[key] = MRP.addOnVersion();
		end
		return list;
	end

	MRP.getImportableData = function()
		return importableData;
	end

	TRP3_API.importer.addAddOn(MRP.addOnVersion(), MRP);
end);
