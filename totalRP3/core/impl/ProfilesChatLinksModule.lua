----------------------------------------------------------------------------------
--- Total RP 3
--- Profiles chat links module
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

-- Lua imports
local assert = assert;

-- Ellyb imports
local YELLOW = Ellyb.ColorManager.YELLOW;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local tcopy = TRP3_API.utils.table.copy;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Events = TRP3_API.events;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local ProfilesChatLinkModule = TRP3_API.ChatLinks:InstantiateModule(loc.CL_PLAYER_PROFILE, "PLAYER_PROFILE");

	--- Get a copy of the data for the link, using the information provided when using ProfilesChatLinkModule:InsertLink
	function ProfilesChatLinkModule:GetLinkData(profileID, canBeImported)
		Ellyb.Assertions.isType(profileID, "string", "profileID");

		local profile = TRP3_API.profile.getProfileByID(profileID);

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
		local info = TRP3_API.profile.getData("player", profile);

		local tooltipLines = TRP3_API.ChatLinkTooltipLines();

		local customColor = YELLOW;
		if info.characteristics.CH then
			customColor = TRP3_API.Ellyb.Color(info.characteristics.CH);
		end

		tooltipLines:SetTitle(customColor(Utils.str.icon(info.characteristics.IC or Globals.icons.profile_default, 20) .. " " .. TRP3_API.register.getCompleteName(info.characteristics, profile.profileName, true)));

		if info.characteristics.FT then
			tooltipLines:AddLine("< " .. info.characteristics.FT .. " >", TRP3_API.Ellyb.ColorManager.ORANGE);
		end
		if info.character.CU and info.character.CU ~= "" then
			tooltipLines:AddLine(" ");
			tooltipLines:AddLine(loc.REG_PLAYER_CURRENT .. ": ");
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
		while not TRP3_API.profile.isProfileNameAvailable(profileName) and i < 500 do
			i = i + 1;
			profileName = profileName .. " " .. i;
		end
		TRP3_API.profile.duplicateProfile(profile, profileName);
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.page.setPage("player_profiles", {});
		Events.fireEvent(Events.REGISTER_PROFILES_LOADED);
	end

	-- Open profile in directory button
	local OpenProfileButton = ProfilesChatLinkModule:NewActionButton("OPEN_PLAYER_PROFILE", loc.CL_OPEN_PROFILE, "PROF_O_Q", "PROF_O_A");

	function OpenProfileButton:OnAnswerCommandReceived(profileData)
		local profile, profileID = profileData.profile, profileData.profileID;
		profile.link = {};
		TRP3_API.register.insertProfile(profileID, profile.player)
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, nil, profileID, nil);

		TRP3_API.register.openPageByProfileID(profileID);
		TRP3_API.navigation.openMainFrame();
	end

	TRP3_API.ProfilesChatLinkModule = ProfilesChatLinkModule;
end);
