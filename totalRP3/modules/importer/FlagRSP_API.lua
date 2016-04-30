----------------------------------------------------------------------------------
-- Total RP 3
-- FlagRSP API for profile importing (some people are still using it ¯\_(ツ)_/¯ )
-- ---------------------------------------------------------------------------
-- Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	if not FlagRSPData then
		return;
	end
	local tcopy, getDefaultProfile = TRP3_API.utils.table.copy, TRP3_API.profile.getDefaultProfile;

	local FRSP = {};
	local importableData = {
		Fullname = "Name",
		Title = "Title",
		CharDesc = "Description"
	}
	local profilesList;

	local function initProfilesList()
		profilesList = {}
		local profileName = FRSP.addOnVersion().."-"..TRP3_API.globals.player_id
		profilesList[profileName] = {
			name = TRP3_API.globals.player_id,
			info = {}
		};
		for k, v in pairs(importableData) do
			if FlagRSPData[k] then
				profilesList[profileName].info[k] = FlagRSPData[k];
			end
		end
	end

	FRSP.isAvailable = function()
		return FlagRSPData ~= nil;
	end

	FRSP.addOnVersion = function()
		return "flagRSP - " .. GetAddOnMetadata("flagRSP", "Version");
	end


	FRSP.getProfile = function(profileID)
		return profilesList[profileID];
	end

	FRSP.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID].info;

		tcopy(profile, getDefaultProfile());

		profile.player.characteristics.FN = importedProfile.Fullname;
		profile.player.characteristics.FT = importedProfile.Title;

		profile.player.about.T3.PH.TX = importedProfile.CharDesc;
		profile.player.about.TE = 3;

		return profile;
	end

	FRSP.listAvailableProfiles = function()
		initProfilesList()
		local list = {};
		for key, _ in pairs(profilesList) do
			list[key] = FRSP.addOnVersion();
		end
		return list;
	end

	FRSP.getImportableData = function()
		return importableData;
	end

	TRP3_API.importer.addAddOn(FRSP.addOnVersion(), FRSP);
end);