----------------------------------------------------------------------------------
--- Total RP 3
--- Register companions chat links module
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---   http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local tcopy = TRP3_API.utils.table.copy;
local Utils = TRP3_API.utils;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local RegisterCompanionChatLinksModule = TRP3_API.ChatLinks:InstantiateModule(loc.CL_DIRECTORY_COMPANION_PROFILE, "DIR_COMPANION_PROFILE");

	--- Get a copy of the data for the link, using the information provided when using RegisterChatLinkModule:InsertLink
	function RegisterCompanionChatLinksModule:GetLinkData(profileID, canBeImported)
		Ellyb.Assertions.isType(profileID, "string", "profileID");

		local profile = TRP3_API.companions.register.getProfiles()[profileID];
		local linkText = UNKNOWN;
		if profile.data and profile.data.NA then
			linkText = profile.data.NA;
		end

		local tooltipData = {
			profile = {},
		};

		tcopy(tooltipData.profile, profile);
		tooltipData.profileID = profileID;
		tooltipData.canBeImported = canBeImported == true;

		return linkText, tooltipData;
	end

	--- Creates and decorates tooltip lines for the given data
	---@return ChatLinkTooltipLines
	function RegisterCompanionChatLinksModule:GetTooltipLines(tooltipData)
		assert(tooltipData.profile, "Invalid tooltipData");

		local profile = tooltipData.profile;

		local tooltipLines = TRP3_API.ChatLinkTooltipLines();

		local dataTab = profile.data;
		local name = dataTab.NA;
		if dataTab.IC then
			name = Utils.str.icon(dataTab.IC, 30) .. " " .. name;
		end
		tooltipLines:SetTitle(name, TRP3_API.Ellyb.ColorManager.WHITE);
		if dataTab.TI then
			tooltipLines:AddLine("< " .. dataTab.TI .. " >", TRP3_API.Ellyb.ColorManager.ORANGE);
		end
		return tooltipLines;
	end

	-- Open profile in directory button
	local OpenRegisterCompanionProfileButton = RegisterCompanionChatLinksModule:NewActionButton("OPEN_REG_COMPANION", loc.CL_OPEN_COMPANION, "REG_C_O_Q","REG_C_O_A");

	function OpenRegisterCompanionProfileButton:OnAnswerCommandReceived(profileData)
		local profileID, profile = profileData.profileID, profileData.profileData;
		-- Check profile exists
		if not TRP3_API.companions.register.getProfiles()[profileID] then
			TRP3_API.companions.register.registerCreateProfile(profileID);
		end
		TRP3_API.companions.register.setProfileData(profileID, profile);

		TRP3_API.companions.register.openPage(profileID);
		TRP3_API.navigation.openMainFrame();
	end

	-- Import profile action button
	local ImportRegisterCompanionProfileButton = RegisterCompanionChatLinksModule:NewActionButton("IMPORT_REG_COMPANION", loc.CL_IMPORT_COMPANION, "REG_C_I_Q", "REG_C_I_A");

	function ImportRegisterCompanionProfileButton:IsVisible(tooltipData)
		return tooltipData.canBeImported;
	end

	function ImportRegisterCompanionProfileButton:OnAnswerCommandReceived(profileData)
		local profile = profileData.profileData;
		local newName = UNKNOWN;
		if profile.data and profile.data.NA then
			newName = profile.data.NA;
		end
		local i = 1;
		while not TRP3_API.companions.player.isProfileNameAvailable(newName) and i < 500 do
			i = i + 1;
			newName = newName .. " " .. i;
		end
		local profileID = TRP3_API.companions.player.duplicateProfile(profile, newName);
		TRP3_API.companions.openPage(profileID);
		TRP3_API.navigation.openMainFrame();
	end

	TRP3_API.RegisterCompanionChatLinksModule = RegisterCompanionChatLinksModule;
end);
