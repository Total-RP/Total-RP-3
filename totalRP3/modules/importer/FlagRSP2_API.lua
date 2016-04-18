----------------------------------------------------------------------------------
-- Total RP 3
-- FlagRSP2 API for profile importing (some people are still using it ¯\_(ツ)_/¯ )
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

	if not flagRSP2 or not flagRSP2.db  or not flagRSP2.db.sv or not flagRSP2.db.sv.char then
		return;
	end

	local tcopy, getDefaultProfile = TRP3_API.utils.table.copy, TRP3_API.profile.getDefaultProfile;

	local FRSP2 = {};
	local importableData = {
		flagRSP2OptionsCharName = "Name",
		flagRSP2OptionsCharTitle = "Title",
		flagRSP2OptionsPhysDesc = "Description"
	}
	local profilesList;

	local function initProfilesList()
		profilesList = {};
		for key, profile in pairs(flagRSP2.db.sv.char) do
			local profileName = FRSP2.addOnVersion().."-"..key;
			profilesList[profileName] = {
				name = key,
				info = {}
			}
			for key, value in pairs(importableData) do
				if profile[key] then
					profilesList[profileName].info[key] = profile[key];
				end
			end
		end
	end

	FRSP2.isAvailable = function()
		return flagRSP2 ~= nil;
	end

	FRSP2.addOnVersion = function()
		return "flagRSP2 - " .. GetAddOnMetadata("flagRSP2", "Version");
	end


	FRSP2.getProfile = function(profileID)
		return profilesList[profileID];
	end

	FRSP2.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID].info;

		tcopy(profile, getDefaultProfile());

		profile.player.characteristics.FN = importedProfile.flagRSP2OptionsCharName
		profile.player.characteristics.FT = importedProfile.flagRSP2OptionsCharTitle

		profile.player.about.T3.PH.TX = importedProfile.flagRSP2OptionsPhysDesc;
		profile.player.about.TE = 3;

		return profile;
	end

	FRSP2.listAvailableProfiles = function()
		initProfilesList()
		local list = {};
		for key, _ in pairs(profilesList) do
			list[key] = FRSP2.addOnVersion();
		end
		return list;
	end

	FRSP2.getImportableData = function()
		return importableData;
	end

	TRP3_API.importer.addAddOn(FRSP2.addOnVersion(), FRSP2);
end);