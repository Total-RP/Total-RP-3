----------------------------------------------------------------------------------
--- Total RP 3
--- Register players chat links module
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

-- Total RP 3 imports
local loc = TRP3_API.loc;
local tcopy = TRP3_API.utils.table.copy;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Events = TRP3_API.events;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local RegisterPlayerChatLinksModule = TRP3_API.ChatLinks:InstantiateModule(loc.CL_DIRECTORY_PLAYER_PROFILE, "DIR_PLAYER_PROFILE");

	--- Get a copy of the data for the link, using the information provided when using RegisterChatLinkModule:InsertLink
	function RegisterPlayerChatLinksModule:GetLinkData(profileID, canBeImported)
		Ellyb.Assertions.isType(profileID, "string", "profileID");

		local profile = TRP3_API.register.getProfile(profileID);
		local linkText = TRP3_API.register.getCompleteName(profile.characteristics, UNKNOWN, true);

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
	function RegisterPlayerChatLinksModule:GetTooltipLines(tooltipData)
		assert(tooltipData.profile, "Invalid tooltipData");

		local profile = tooltipData.profile;

		local tooltipLines = TRP3_API.ChatLinkTooltipLines();

		local customColor = TRP3_API.Ellyb.ColorManager.YELLOW;
		if profile.characteristics and profile.characteristics.CH then
			customColor = TRP3_API.Ellyb.Color(profile.characteristics.CH);
		end

		tooltipLines:SetTitle(customColor(Utils.str.icon(profile.characteristics.IC or Globals.icons.profile_default, 20) .. " " .. TRP3_API.register.getCompleteName(profile.characteristics, profile.profileName, true)));

		if profile.characteristics and profile.characteristics.FT then
			tooltipLines:AddLine("< " .. profile.characteristics.FT .. " >", TRP3_API.Ellyb.ColorManager.ORANGE);
		end
		if profile.character and profile.character.CU then
			tooltipLines:AddLine(" ");
			tooltipLines:AddLine(loc.REG_PLAYER_CURRENT .. ": ");
			tooltipLines:AddLine(profile.character.CU, TRP3_API.Ellyb.ColorManager.YELLOW);
		end
		if profile.character and profile.character.CO then
			tooltipLines:AddLine(" ");
			tooltipLines:AddLine(loc.DB_STATUS_CURRENTLY_OOC .. ": ");
			tooltipLines:AddLine(profile.character.CO, TRP3_API.Ellyb.ColorManager.YELLOW);
		end

		return tooltipLines;
	end

	-- Open profile in directory button
	local OpenProfileButton = RegisterPlayerChatLinksModule:NewActionButton("OPEN_REG_PROFILE", loc.CL_OPEN_PROFILE, "REG_P_O_Q", "REG_P_O_A");

	function OpenProfileButton:OnAnswerCommandReceived(profileData)
		local profile, profileID = profileData.profile, profileData.profileID;
		profile.link = {};
		TRP3_API.register.insertProfile(profileID, profile)
		Events.fireEvent(Events.REGISTER_DATA_UPDATED, nil, profileID, nil);

		TRP3_API.register.openPageByProfileID(profileID);
		TRP3_API.navigation.openMainFrame();
	end

	-- Import profile action button
	local ImportRegisterPlayerProfileButton = RegisterPlayerChatLinksModule:NewActionButton("IMPORT_REG_PROFILE", loc.CL_IMPORT_PROFILE, "REG_P_I_Q", "REG_P_I_A");

	function ImportRegisterPlayerProfileButton:IsVisible(tooltipData)
		return tooltipData.profile and tooltipData.profile.link and tooltipData.profile.link[TRP3_API.globals.player_id];
	end

	function ImportRegisterPlayerProfileButton:OnAnswerCommandReceived(profileData)
		local profile = profileData.profile;
		local profileName = UNKNOWN;
		if profile.characteristics and profile.characteristics.FN then
			profileName = profile.characteristics.FN;
		end
		local i = 1;
		while not TRP3_API.profile.isProfileNameAvailable(profileName) and i < 500 do
			i = i + 1;
			profileName = profileName .. " " .. i;
		end
		TRP3_API.profile.duplicateProfile({
			player = profile
		}, profileName);
		TRP3_API.navigation.openMainFrame();
		TRP3_API.navigation.page.setPage("player_profiles", {});
		Events.fireEvent(Events.REGISTER_PROFILES_LOADED);
	end

	TRP3_API.RegisterPlayerChatLinksModule = RegisterPlayerChatLinksModule;

end);
