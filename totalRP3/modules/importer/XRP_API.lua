----------------------------------------------------------------------------------
--- Total RP 3
--- XRP API for profile importing
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	if not xrpSaved then
		return;
	end

	local tcopy, getDefaultProfile = TRP3_API.utils.table.copy, TRP3_API.profile.getDefaultProfile;
	local loc = TRP3_API.loc;

	local XRP = {};

	local importableData = {
		HH = XRP_HH,
		HI = XRP_HI,
		DE = XRP_DE,
		AE = XRP_AE,
		FC = XRP_FC,
		HB = XRP_HB,
		AH = XRP_AH,
		NA = XRP_NA,
		RA = XRP_RA,
		AW = XRP_AW,
		NT = XRP_NT,
		FR = XRP_FR,
		NH = XRP_NH,
		NI = XRP_NI,
		RC = XRP_RC,
		MO = XRP_MO,
		AG = XRP_AG,
		CU = XRP_CU
	}
	local profilesList;

	local function initProfilesList()
		profilesList = {};

		for name, profile in pairs(xrpSaved.profiles) do
			if name == "Default" then
				name = TRP3_API.globals.player_id;
			end
			local profileName = XRP.addOnVersion().."-"..name;
			profilesList[profileName] = { name = name };
			local infoTemp = {};
			for k, v in pairs(profile.fields) do
				infoTemp[k] = v;
			end
			profilesList[profileName].info = infoTemp;
		end
	end

	XRP.isAvailable = function()
		return xrpSaved.profiles ~= nil;
	end

	XRP.addOnVersion = function()
		return "XRP - " .. GetAddOnMetadata("xrp", "Version");
	end


	XRP.getProfile = function(profileID)
		return profilesList[profileID];
	end

	XRP.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID].info;

		tcopy(profile, getDefaultProfile());
		profile.player.characteristics.FN = importedProfile.NA;
		profile.player.characteristics.FT = importedProfile.NT;
		profile.player.characteristics.RA = importedProfile.RA;
		profile.player.characteristics.CL = importedProfile.CL;
		profile.player.characteristics.AG = importedProfile.AG;
		profile.player.characteristics.RE = importedProfile.HH;
		profile.player.characteristics.BP = importedProfile.HB;
		profile.player.characteristics.EC = importedProfile.AE;
		profile.player.characteristics.HE = importedProfile.AH;
		profile.player.characteristics.WE = importedProfile.AW;
		if importedProfile.MO then
			tinsert(profile.player.characteristics.MI, {
				NA = loc.REG_PLAYER_MSP_MOTTO;
				VA = "\"" .. importedProfile.MO .. "\"";
				IC = "INV_Inscription_ScrollOfWisdom_01";
			});
		end
		if importedProfile.NI then
			tinsert(profile.player.characteristics.MI, {
				NA = loc.REG_PLAYER_MSP_NICK;
				VA = importedProfile.NI;
				IC = "Ability_Hunter_BeastCall";
			});
		end
		if importedProfile.NH then
			tinsert(profile.player.characteristics.MI, {
				NA = loc.REG_PLAYER_MSP_HOUSE;
				VA = importedProfile.NH;
				IC = "inv_misc_kingsring1";
			});
		end
		profile.player.character.CU = importedProfile.CU;
		profile.player.about.T3.PH.TX = importedProfile.DE;
		profile.player.about.T3.HI.TX = importedProfile.HI;
		profile.player.about.TE = 3;

		-- TODO Custom RP styles

		return profile;
	end

	XRP.listAvailableProfiles = function()
		initProfilesList()
		local list = {};
		for key, _ in pairs(profilesList) do
			list[key] = XRP.addOnVersion();
		end
		return list;
	end

	XRP.getImportableData = function()
		return importableData;
	end

	TRP3_API.importer.addAddOn(XRP.addOnVersion(), XRP);
end);
