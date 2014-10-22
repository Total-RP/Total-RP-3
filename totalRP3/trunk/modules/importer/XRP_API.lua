----------------------------------------------------------------------------------
-- Total RP 3
-- XRP API for profile importing
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
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
	local tcopy, getDefaultProfile = TRP3_API.utils.table.copy, TRP3_API.profile.getDefaultProfile;

	local XRP = {};
	local loc = {
	};
	local importableData = {

	}
	local profilesList;

	-- TODO fill profilesList with available profiles from XRP
	local function initProfilesList()
		profilesList = {};
	end

	-- TODO Check if we have what we need
	XRP.isAvailable = function()
		return "XRPSaved" ~= nil;
	end

	-- TODO Return the version number for XRP
	XRP.addOnVersion = function()

	end


	XRP.getProfile = function(profileID)
		return profilesList[profileID];
	end

	-- TODO Format MSP profile into a TRP3 profile
	XRP.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID];

		tcopy(profile, getDefaultProfile());

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

	if XRP.isAvailable() then
		TRP3_API.importer.addAddOn(XRP.addOnVersion(), XRP);
	end
end);