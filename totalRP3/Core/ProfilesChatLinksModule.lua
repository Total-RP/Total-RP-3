-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0
local Ellyb = TRP3.Ellyb;

-- Lua imports
local assert = assert;

-- Ellyb imports
local YELLOW = TRP3.Colors.Yellow;

-- Total RP 3 imports
local loc = TRP3.loc;
local tcopy = TRP3.utils.table.copy;
local Utils = TRP3.utils;
local Events = TRP3_Addon.Events;

TRP3.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()

	local ProfilesChatLinkModule = TRP3.ChatLinks:InstantiateModule(loc.CL_PLAYER_PROFILE, "PLAYER_PROFILE");

	--- Get a copy of the data for the link, using the information provided when using ProfilesChatLinkModule:InsertLink
	function ProfilesChatLinkModule:GetLinkData(profileID, canBeImported)
		Ellyb.Assertions.isType(profileID, "string", "profileID");

		local profile = TRP3.profile.getProfileByID(profileID);

		local tooltipData = {
			profile = {},
		};

		tcopy(tooltipData.profile, profile);
		tooltipData.profileID = profileID;
		tooltipData.canBeImported = canBeImported == true;

		return tooltipData.profile.profileName, tooltipData;
	end

	--- Creates and decorates tooltip lines for the given data
	---@return ChatLinkTooltipLines
	function ProfilesChatLinkModule:GetTooltipLines(tooltipData)
		assert(tooltipData.profile, "Invalid tooltipData");

		local profile = tooltipData.profile;
		local info = TRP3.profile.getData("player", profile);

		local tooltipLines = TRP3.ChatLinkTooltipLines();

		local customColor = YELLOW;
		if info.characteristics.CH then
			customColor = TRP3.CreateColorFromHexString(info.characteristics.CH);
		end

		tooltipLines:SetTitle(customColor(Utils.str.icon(info.characteristics.IC or TRP3_InterfaceIcons.ProfileDefault, 20) .. " " .. TRP3.register.getCompleteName(info.characteristics, profile.profileName, true)));

		if info.characteristics.FT then
			tooltipLines:AddLine("< " .. info.characteristics.FT .. " >", TRP3.Colors.Orange);
		end
		if info.character.CU and info.character.CU ~= "" then
			tooltipLines:AddLine(" ");
			tooltipLines:AddLine(loc.DB_STATUS_CURRENTLY .. ": ");
			tooltipLines:AddLine(info.character.CU, YELLOW);
		end
		if info.character.CO and info.character.CO ~= "" then
			tooltipLines:AddLine(" ");
			tooltipLines:AddLine(loc.DB_STATUS_CURRENTLY_OOC .. ": ");
			tooltipLines:AddLine(info.character.CO, YELLOW);
		end

		return tooltipLines;
	end

	-- Import profile action button
	---@type ChatLinkActionButton
	local ImportProfileButton = ProfilesChatLinkModule:NewActionButton("IMPORT_PLAYER_PROFILE", loc.CL_IMPORT_PROFILE, "PROF_I_Q", "PROF_I_A");

	function ImportProfileButton:IsVisible(tooltipData)
		return tooltipData.canBeImported;
	end

	function ImportProfileButton:OnAnswerCommandReceived(data)
		local profile = data.profile;
		local profileName = profile.profileName;
		local i = 1;
		while not TRP3.profile.isProfileNameAvailable(profileName) and i < 500 do
			i = i + 1;
			profileName = profileName .. " " .. i;
		end
		TRP3.profile.duplicateProfile(profile, profileName);
		TRP3.navigation.openMainFrame();
		TRP3.navigation.page.setPage("player_profiles", {});
		TRP3_Addon:TriggerEvent(Events.REGISTER_PROFILES_LOADED);
	end

	-- Open profile in directory button
	local OpenProfileButton = ProfilesChatLinkModule:NewActionButton("OPEN_PLAYER_PROFILE", loc.CL_OPEN_PROFILE, "PROF_O_Q", "PROF_O_A");

	function OpenProfileButton:OnAnswerCommandReceived(profileData)
		local profile, profileID = profileData.profile, profileData.profileID;
		profile.link = {};
		TRP3.register.insertProfile(profileID, profile.player)
		TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, nil, profileID, nil);

		TRP3.register.openPageByProfileID(profileID);
		TRP3.navigation.openMainFrame();
	end

	TRP3.ProfilesChatLinkModule = ProfilesChatLinkModule;
end);
