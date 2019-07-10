-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- AddOn_TotalRP3 imports.
local Configuration = AddOn_TotalRP3.Configuration;
local Player = AddOn_TotalRP3.Player;
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Ellyb imports.
local Color = TRP3_API.Ellyb.Color;

-- Returns true if customization of nameplates is globally enabled.
--
-- Returns false if disabled, or if enabled while only in-character and the
-- player is currently out-of-character.
function NamePlates.IsCustomizationEnabled()
	-- If customizations are globally disabled, that's a no.
	if not NamePlates.ShouldCustomizeNamePlates() then
		return false;
	end

	-- Disable customizations if we need to be in-character.
	if NamePlates.ShouldCustomizeNamePlatesOnlyInCharacter() then
		local currentUser = Player.GetCurrentUser();
		if not currentUser:IsInCharacter() then
			return false;
		end
	end

	return true;
end

-- Returns true if customization of nameplates is enabled for the specified
-- unit token.
--
-- Returns false if disabled globally, or disabled for this specific unit.
--
-- @param unitToken The unit token to check.
function NamePlates.IsCustomizationEnabledForUnit(_)
	-- Add in any per-unit logic here if ever needed.
	return NamePlates.IsCustomizationEnabled();
end

-- Returns the custom name text to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no name can be obtained.
function NamePlates.GetUnitCustomName(unitToken)
	-- Don't bother if customization is disabled.
	if not NamePlates.IsCustomizationEnabledForUnit(unitToken) then
		return nil;
	end

	-- Dispatch based on the profile type.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == NamePlates.PROFILE_TYPE_CHARACTER then
		if not NamePlates.ShouldShowCustomPlayerNames() then
			-- Not displaying custom player names.
			return nil;
		end

		-- Get the profile for the player and with it, their name.
		local profile = NamePlates.GetUnitCharacterProfile(unitToken);
		if not profile then
			-- No profile data available.
			return nil;
		end

		return profile:GetRoleplayingName();
	elseif profileType == NamePlates.PROFILE_TYPE_PET then
		if not NamePlates.ShouldShowCustomPetNames() then
			-- Not displaying custom pet names.
			return nil;
		end

		-- Combat pets use companion pet profiles.
		local profile = NamePlates.GetUnitPetProfile(unitToken);
		if not profile then
			-- No profile data available.
			return nil;
		end

		return profile.NA;
	end

	-- No name is available.
	return nil;
end

-- Returns the custom color to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no color can be obtained.
function NamePlates.GetUnitCustomColor(unitToken)
	-- Don't bother if customization is disabled.
	if not NamePlates.IsCustomizationEnabledForUnit(unitToken)
	or not NamePlates.ShouldShowCustomColors() then
		return nil;
	end

	-- Dispatch based on the profile type.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == NamePlates.PROFILE_TYPE_CHARACTER then
		-- Get the profile for the player and with it, their custom color.
		local profile = NamePlates.GetUnitCharacterProfile(unitToken);
		local nameColor = profile and profile:GetCustomColorForDisplay();

		-- If there is no profile or color, use class coloring instead.
		if not nameColor then
			local _, class = UnitClass(unitToken);
			if class then
				nameColor = C_ClassColor.GetClassColor(class);
			end
		end

		return nameColor;
	elseif profileType == NamePlates.PROFILE_TYPE_PET then
		-- Combat pets use companion pet profiles.
		local profile = NamePlates.GetUnitPetProfile(unitToken);
		if not profile then
			-- No profile available.
			return nil;
		end

		local petColor = profile.NH and Color.CreateFromHexa(profile.NH);
		if not petColor then
			-- No color was set.
			return nil;
		end

		-- Apply contrast changes as needed.
		if Configuration.shouldDisplayIncreasedColorContrast() then
			petColor:LightenColorUntilItIsReadableOnDarkBackgrounds();
		end

		return petColor;
	end

	-- No color is available.
	return nil;
end

-- Returns the name of an icon without its path prefix for the given unit
-- token.
--
-- Returns nil if customization is disabled, or if no icon is available.
function NamePlates.GetUnitCustomIcon(unitToken)
	-- If not displaying icons, return early.
	if not NamePlates.IsCustomizationEnabledForUnit(unitToken)
	or not NamePlates.ShouldShowCustomIcons() then
		return nil;
	end

	-- Get the appropriate icon for this unit type.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == NamePlates.PROFILE_TYPE_CHARACTER then
		local profile = NamePlates.GetUnitCharacterProfile(unitToken);
		if profile then
			return profile:GetCustomIcon();
		end
	elseif profileType == NamePlates.PROFILE_TYPE_PET then
		local profile = NamePlates.GetUnitPetProfile(unitToken);
		if profile then
			return profile.IC;
		end
	end

	-- No icon is available.
	return nil;
end

-- Returns the name of an title text of a profile for the given unit token.
--
-- Returns nil if customization is disabled, or if no title is available.
function NamePlates.GetUnitCustomTitle(unitToken)
	-- If not displaying titles, return early.
	if not NamePlates.IsCustomizationEnabledForUnit(unitToken)
	or not NamePlates.ShouldShowCustomTitles() then
		return nil;
	end

	-- Get the appropriate title for this unit type.
	local profileType = NamePlates.GetUnitProfileType(unitToken);
	if profileType == NamePlates.PROFILE_TYPE_CHARACTER then
		local profile = NamePlates.GetUnitCharacterProfile(unitToken);
		local characteristics = profile and profile:GetCharacteristics();
		if characteristics then
			return characteristics.FT;
		end
	elseif profileType == NamePlates.PROFILE_TYPE_PET then
		local profile = NamePlates.GetUnitPetProfile(unitToken);
		if profile then
			return profile.TI;
		end
	end

	-- No title is available.
	return nil;
end

-- Returns an OOC indicator as a string for a profile owned by the given
-- unit token.
--
-- Reutrns nil if customization disabled, or if the unit is in-character.
function NamePlates.GetUnitOOCIndicator(unitToken)
	-- If not displaying OOC indicators, return early.
	if not NamePlates.IsCustomizationEnabledForUnit(unitToken)
	or not NamePlates.ShouldShowOOCIndicators() then
		return nil;
	end

	-- OOC indicators only apply to players.
	if not UnitIsPlayer(unitToken) then
		return nil;
	end

	-- Grab the profile for the player and check if they're in-character.
	local profile = NamePlates.GetUnitCharacterProfile(unitToken);
	if not profile or profile:IsInCharacter() then
		return nil;
	end

	-- Return an appropriate indicator based on the configured style.
	local style = NamePlates.GetConfiguredOOCIndicatorStyle();
	if style == NamePlates.OOC_STYLE_TEXT then
		return NamePlates.OOC_TEXT_INDICATOR;
	elseif style == NamePlates.OOC_STYLE_ICON then
		return tostring(NamePlates.OOC_ICON_INDICATOR);
	end

	-- Unsupported style.
	return nil;
end
