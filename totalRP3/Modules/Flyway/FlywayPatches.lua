-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_API.flyway.patches = {};

local Globals, Utils = TRP3_API.globals, TRP3_API.utils;

local function SafeGet(t, k, ...)
	if t == nil then
		return nil;
	end

	local v = t[k];

	if ... ~= nil then
		return SafeGet(v, ...);
	else
		return v;
	end
end

-- Delete notification system
TRP3_API.flyway.patches["3"] = function()
	if TRP3_Characters then
		for _, character in pairs(TRP3_Characters) do
			if 	character.notifications then
				wipe(character.notifications);
			end
			character.notifications = nil;
		end
	end
end

TRP3_API.flyway.patches["4"] = function()
	if TRP3_Configuration and TRP3_Configuration["register_mature_filter"] and TRP3_Configuration["register_mature_filter"] == "0" then
		TRP3_Configuration["register_mature_filter"] = false;
	end
end

TRP3_API.flyway.patches["5"] = function()
	-- Sanitize existing profiles
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		local sanitizeFullProfile = TRP3_API.register.sanitizeFullProfile;
		for _, profile in pairs(TRP3_Register.profiles) do
			sanitizeFullProfile(profile);
		end
	end)
end

TRP3_API.flyway.patches["6"] = function()
	if not TRP3_Profiles then return end
	-- Run through all the profiles and upgrade the personality traits
	-- structure to upscale the values and copy them to a new field.
	--
	-- As the old maximum doesn't easily divide (or multiply) into whole
	-- numbers at most of the steps, we'll round the value to the nearest
	-- whole integer.
	--
	-- The field with the new value is called V2; we leave VA intact for
	-- backwards compatibility.
	--
	-- If for some reason there's already a V2 present, we leave it alone
	-- and don't migrate the value over.
	local scale = Globals.PSYCHO_MAX_VALUE_V2 / Globals.PSYCHO_MAX_VALUE_V1;
	for _, profile in pairs(TRP3_Profiles) do
		if profile.player then
			local characteristics = profile.player.characteristics;
			local psycho = characteristics and characteristics.PS;

			if psycho then
				for i = 1, #psycho do
					local trait = psycho[i];
					local value = trait.VA or Globals.PSYCHO_DEFAULT_VALUE_V1;

					trait.V2 = trait.V2 or math.floor((value * scale) + 0.5);
				end
			end
		end
	end
end

-- Patches potentially badly created profiles from chat links
TRP3_API.flyway.patches["7"] = function()
	if not (TRP3_Register and TRP3_Register.profiles) then return end
	for _, profile in pairs(TRP3_Register.profiles) do
		if not profile.link then
			profile.link = {};
		end
	end
end

-- Remove voting feature
TRP3_API.flyway.patches["8"] = function()
	if not TRP3_Profiles then return end
	for _, profile in pairs(TRP3_Profiles) do
		if profile.about then
			profile.about.vote = nil;
		end
	end
end

-- Reset glance bar coordinates
TRP3_API.flyway.patches["9"] = function()
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		if TRP3_API.register.resetGlanceBar then
			TRP3_API.register.resetGlanceBar();
		end
	end)
end

TRP3_API.flyway.patches["10"] = function()
	-- Migrate contrast settings to the new common one
	if TRP3_Configuration then
		if TRP3_Configuration["chat_color_contrast"] or TRP3_Configuration["tooltip_char_contrast"] then
			TRP3_Configuration["increase_color_contrast"] = true;
		end

		TRP3_Configuration["chat_color_contrast"] = nil;
		TRP3_Configuration["tooltip_char_contrast"] = nil;
	end

	-- Migrate music paths to music IDs
	if TRP3_Profiles then
		for _, profile in pairs(TRP3_Profiles) do
			if profile.player and profile.player.about and profile.player.about.MU and type(profile.player.about.MU) == "string" then
				profile.player.about.MU = Utils.music.convertPathToID(profile.player.about.MU);
			end
		end
	end

	if TRP3_Register and TRP3_Register.profiles then
		for _, profile in pairs(TRP3_Register.profiles) do
			if profile.about and profile.about.MU and type(profile.about.MU) == "string" then
				profile.about.MU = Utils.music.convertPathToID(profile.about.MU) or tonumber(profile.about.MU);
			end
		end
	end
end

TRP3_API.flyway.patches["11"] = function()
	-- This patch used to add the Roleplay Language (LC) field, however this
	-- has been removed as of 2021/04.
end

-- Migrate from register from "BlackList" to "BlockList" and "WhiteList" to "SafeList" naming conventions.
TRP3_API.flyway.patches["12"] = function()
	if TRP3_Register and TRP3_Register.blackList then
		TRP3_Register.blockList = TRP3_Register.blackList;
		TRP3_Register.blackList = nil;
	end
	if TRP3_MatureFilter and TRP3_MatureFilter.whitelist then
		TRP3_MatureFilter.safeList = TRP3_MatureFilter.whitelist;
		TRP3_MatureFilter.whitelist = nil;
	end
end

TRP3_API.flyway.patches["13"] = function()
	-- Migrate the toolbar show on login setting to the new display conditions
	if TRP3_Configuration then
		if TRP3_Configuration["toolbar_show_on_login"] then
			TRP3_Configuration["toolbar_visibility"] = TRP3_ToolbarVisibilityOption.AlwaysShow;
		else
			TRP3_Configuration["toolbar_visibility"] = TRP3_ToolbarVisibilityOption.AlwaysHidden;
		end

		TRP3_Configuration["toolbar_show_on_login"] = nil;
	end
end

TRP3_API.flyway.patches["14"] = function()
	-- Add a new "ID" field to all Misc. Info fields which will be used
	-- in preference to name lookups going forward. This won't be applied
	-- to the register - we'll just let that update passively.

	if not TRP3_Profiles then
		return;
	end

	for _, profile in pairs(TRP3_Profiles) do
		local miscInfo = SafeGet(profile, "player", "characteristics", "MI");

		if miscInfo then
			for _, miscData in ipairs(miscInfo) do
				miscData.ID = TRP3_API.GetMiscInfoTypeFromData(miscData);
			end
		end
	end
end

TRP3_API.flyway.patches["15"] = function()
	-- Migrate contrast setting to a more flexible level system. This just
	-- deletes the old setting; the old system had a tendency to white out
	-- colors in quite a nasty manner however with our new levels it should
	-- make more sense to just allow its default "Low" level be used, which
	-- is very conservative in the colors it'll attempt to adjust.

	if TRP3_Configuration then
		TRP3_Configuration["increase_color_contrast"] = nil;
	end
end

TRP3_API.flyway.patches["16"] = function()
	-- Migrate minimap settings to launcher settings.

	if TRP3_Configuration then
		if TRP3_Configuration["minimap_show"] ~= nil then
			TRP3_Configuration["Launcher_ShowMinimapButton"] = TRP3_Configuration["minimap_show"];
		end

		if TRP3_Configuration["minimap_icon_position"] and TRP3_Configuration["minimap_icon_position"]["minimapPos"] then
			TRP3_Configuration["Launcher_MinimapButtonPosition"] = TRP3_Configuration["minimap_icon_position"]["minimapPos"];
		end
	end

	-- This patch migrates a few nameplates settings from separated booleans
	-- to enums.

	if not TRP3_Configuration then
		return;
	end

	local customizeNonRoleplayUnits;
	local customizeNPCUnits;
	local customizeOOCUnits;
	local customizeNames;

	if TRP3_Configuration["NamePlates_DisableOutOfCharacterUnits"] then
		customizeOOCUnits = TRP3_NamePlateUnitCustomizationState.Disable;
	elseif TRP3_Configuration["NamePlates_HideOutOfCharacterUnits"] then
		customizeOOCUnits = TRP3_NamePlateUnitCustomizationState.Hide;
	else
		customizeOOCUnits = TRP3_NamePlateUnitCustomizationState.Show;
	end

	if TRP3_Configuration["NamePlates_DisableNonPlayableUnits"] then
		customizeNPCUnits = TRP3_NamePlateUnitCustomizationState.Disable;
	else
		customizeNPCUnits = TRP3_NamePlateUnitCustomizationState.Show;
	end

	if TRP3_Configuration["NamePlates_HideNonRoleplayUnits"] then
		customizeNonRoleplayUnits = TRP3_NamePlateUnitCustomizationState.Hide;
	else
		customizeNonRoleplayUnits = TRP3_NamePlateUnitCustomizationState.Show;
	end

	if TRP3_Configuration["NamePlates_CustomizeNames"] == false then
		customizeNames = TRP3_NamePlateUnitNameDisplayMode.OriginalName;
	elseif TRP3_Configuration["NamePlates_CustomizeFirstNames"] then
		customizeNames = TRP3_NamePlateUnitNameDisplayMode.FirstName;
	else
		customizeNames = TRP3_NamePlateUnitNameDisplayMode.FullName;
	end

	TRP3_Configuration["NamePlates_CustomizeNonRoleplayUnits"] = customizeNonRoleplayUnits;
	TRP3_Configuration["NamePlates_CustomizeNPCUnits"] = customizeNPCUnits;
	TRP3_Configuration["NamePlates_CustomizeOOCUnits"] = customizeOOCUnits;
	TRP3_Configuration["NamePlates_CustomizeNames"] = customizeNames;

	TRP3_Configuration["NamePlates_DisableNonPlayableUnits"] = nil;
	TRP3_Configuration["NamePlates_HideNonRoleplayUnits"] = nil;
	TRP3_Configuration["NamePlates_DisableOutOfCharacterUnits"] = nil;
	TRP3_Configuration["NamePlates_HideOutOfCharacterUnits"] = nil;
	TRP3_Configuration["NamePlates_CustomizeFirstName"] = nil;
end

TRP3_API.flyway.patches["17"] = function()
	-- Check all non-custom Misc. Info fields
	-- Names not matching localized or non-localized preset name are turned into custom fields

	if not TRP3_Profiles then
		return;
	end

	for _, profile in pairs(TRP3_Profiles) do
		local miscInfo = SafeGet(profile, "player", "characteristics", "MI");

		if miscInfo then
			for _, miscData in ipairs(miscInfo) do
				if miscData.ID ~= TRP3_API.MiscInfoType.Custom then
					miscData.ID = TRP3_API.GetMiscInfoTypeByName(miscData.NA);
				end
			end
		end
	end
end

TRP3_API.flyway.patches["18"] = function()
	-- Modify default profile ID to include an identifier

	if not TRP3_Profiles or not TRP3_Configuration then
		return;
	end

	if TRP3_Configuration["default_profile_id"] then
		local oldDefaultProfileID = TRP3_Configuration["default_profile_id"];
		local newDefaultProfileID = string.sub(oldDefaultProfileID, 1, -2) .. "*";

		-- Replacing the config key
		TRP3_Configuration["default_profile_id"] = newDefaultProfileID;

		-- Replacing the profile entry
		TRP3_Profiles[newDefaultProfileID] = TRP3_Profiles[oldDefaultProfileID];
		TRP3_Profiles[oldDefaultProfileID] = nil;
	end
end

TRP3_API.flyway.patches["19"] = function()
	-- Modify default profile ID to be OOC.

	if not TRP3_Profiles or not TRP3_Configuration then
		return;
	end

	if TRP3_Configuration["default_profile_id"] then
		local profile = TRP3_Profiles[TRP3_Configuration["default_profile_id"]];
		local character = SafeGet(profile, "player", "character");

		if character then
			character.RP = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
			character.v = TRP3_API.utils.math.incrementNumber(character.v or 1, 2);
		end
	end
end

TRP3_API.flyway.patches["20"] = function()
	-- Roleplay experience is now a global setting and should be removed
	-- from all player-owned profiles. Register profiles will retain the
	-- XP field as they're expected to passively shed it as resynchronization
	-- occurs across the network, or until the point they're pruned.

	if not TRP3_Profiles then
		return;
	end

	for _, profile in pairs(TRP3_Profiles) do
		local character = profile.player and profile.player.character;

		if character then
			character.XP = nil;
			character.v = TRP3_API.utils.math.incrementNumber(character.v or 1, 2);
		end
	end
end

TRP3_API.flyway.patches["21"] = function()
	-- First handles the following:
	-- About changes were always marked as unread, which is fine 9/10 of the
	-- time. However due to an incorrect check in `onAboutReceived` we also
	-- applied unread to empty abouts. These should not marked as unread.
	--
	-- Then we continue on to handling:
	-- We were sending disabled glances data to other players unintentionally.

	if not TRP3_Register then
		return;
	end

	local profileList = TRP3_Register.profiles;
	for profileID, profile in pairs(profileList) do
		-- Don't check default profiles
		if not TRP3_API.profile.isDefaultProfile(profileID) and profile.characteristics and next(profile.characteristics) ~= nil then
			-- Handle the wrong about unread situation first.
			local aboutData = profile.about;

			-- Skip profiles that have no about data, they do not have
			-- an unread notification as-is.
			if aboutData then
				-- Check if anything is filled at all in any template.
				local filledDescription = false;
				if aboutData.TE == 1 then
					local templateData = aboutData.T1 or {};
					filledDescription = templateData.TX and strtrim(templateData.TX):len() > 0;
				elseif aboutData.TE == 2 then
					local templateData = aboutData.T2 or {};
					for _, frameTab in pairs(templateData) do
						if frameTab.TX and strtrim(frameTab.TX):len() > 0 then
							filledDescription = true;
							break;
						end
					end
				elseif aboutData.TE == 3 then
					local templateData = aboutData.T3 or {};
					local datas = {templateData.PH, templateData.PS, templateData.HI};
					for i=1, 3 do
						local data = datas[i] or {};
						if data.TX and strtrim(data.TX):len() > 0 then
							filledDescription = true;
							break;
						end
					end
				end

				-- If a profile has both an empty description but is also
				-- marked as unread, it should be marked as read.
				if not filledDescription and not profile.about.read then
					profile.about.read = true;
				end
			end

			-- Handle the inactive glance situation next.
			local miscData = profile.misc;

			-- Skip profiles without miscData or no glances set up.
			if miscData and miscData.PE then
				for i=1,5 do
					local index = tostring(i);
					-- If glance is inactive, wipe its data.
					if miscData.PE[index] and miscData.PE[index].AC == false then
						miscData.PE[index] = nil;
					end
				end
			end
		end
	end
end
