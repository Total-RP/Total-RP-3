-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
local Ellyb = TRP3.Ellyb;

-- Total RP 3 imports
local loc = TRP3.loc;
local tcopy = TRP3.utils.table.copy;
local Utils = TRP3.utils;

TRP3.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	local CompanionProfileChatLinksModule = TRP3.ChatLinks:InstantiateModule(loc.CL_COMPANION_PROFILE, "COMPANION_PROFILE");

	--- Get a copy of the data for the link, using the information provided when using CompanionProfileChatLinksModule:InsertLink
	function CompanionProfileChatLinksModule:GetLinkData(profileID, canBeImported)
		Ellyb.Assertions.isType(profileID, "string", "profileID");

		local profile = TRP3.companions.player.getProfiles()[profileID];

		local tooltipData = {
			profile = {},
		};

		tcopy(tooltipData.profile, profile);
		tooltipData.profileID = profileID;
		tooltipData.canBeImported = canBeImported == true;

		return profile.profileName, tooltipData;
	end

	--- Creates and decorates tooltip lines for the given data
	---@return ChatLinkTooltipLines
	function CompanionProfileChatLinksModule:GetTooltipLines(tooltipData)
		assert(tooltipData.profile, "Invalid tooltipData");

		local profile = tooltipData.profile;

		local tooltipLines = TRP3.ChatLinkTooltipLines();

		local dataTab = profile.data;
		local name = dataTab.NA;
		if dataTab.IC then
			name = Utils.str.icon(dataTab.IC, 30) .. " " .. name;
		end
		tooltipLines:SetTitle(name, TRP3.Colors.White);
		if dataTab.TI then
			tooltipLines:AddLine("< " .. dataTab.TI .. " >", TRP3.Colors.Orange);
		end
		return tooltipLines;
	end

	-- Open profile in directory button
	local OpenCompanionProfileButton = CompanionProfileChatLinksModule:NewActionButton("OPEN_COMPANION", loc.CL_OPEN_COMPANION, "CMPN_O_Q", "CMPN_O_A");

	function OpenCompanionProfileButton:OnAnswerCommandReceived(profileData)
		local profileID, profile = profileData.profileID, profileData.profile;
		-- Check profile exists
		if not TRP3.companions.register.getProfiles()[profileID] then
			TRP3.companions.register.registerCreateProfile(profileID);
		end
		TRP3.companions.register.setProfileData(profileID, profile);

		TRP3.companions.register.openPage(profileID);
		TRP3.navigation.openMainFrame();
	end

	-- Import profile action button
	local ImportCompanionProfileButton = CompanionProfileChatLinksModule:NewActionButton("IMPORT_COMPANION", loc.CL_IMPORT_COMPANION, "CMPN_I_Q", "CMPN_I_A");

	function ImportCompanionProfileButton:IsVisible(tooltipData)
		return tooltipData.canBeImported;
	end

	function ImportCompanionProfileButton:OnAnswerCommandReceived(profileData)
		local profile = profileData.profile;
		local newName = profile.profileName;
		local i = 1;
		while not TRP3.companions.player.isProfileNameAvailable(newName) and i < 500 do
			i = i + 1;
			newName = newName .. " " .. i;
		end
		local profileID = TRP3.companions.player.duplicateProfile(profile, newName);
		TRP3.companions.openPage(profileID);
		TRP3.navigation.openMainFrame();
	end

	TRP3.CompanionProfileChatLinksModule = CompanionProfileChatLinksModule;
end);
