-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = Ellyb(...);

-- Imports.
local Enums = AddOn_TotalRP3.Enums;

---@class Player : Object
local Player, _private = Ellyb.Class("Player")
---@type Player
local currentUser;

---@private
function Player:initialize()
	_private[self] = {};
end

---@return string|nil characterID
function Player:GetCharacterID()
	return _private[self].characterID;
end

---@return string|nil playerName
function Player:GetName()
	if self:GetCharacterID() then
		local name = strsplit("-", self:GetCharacterID());
		return name
	end
end

function Player:GetProfileID()
	if _private[self].profileID then
		return _private[self].profileID
	end
	local characterInfo = TRP3_Register.character[self:GetCharacterID()]
	if characterInfo then
		return characterInfo.profileID
	end
end

---@return {characteristics: {FN: string, LN: string}}|nil profile
function Player:GetProfile()
	return TRP3_Register.profiles[self:GetProfileID()];
end

---@return {FN: string, LN: string, CH:string, IC:string}|nil characteristics
function Player:GetCharacteristics()
	local profile = self:GetProfile();
	if profile then
		return profile.characteristics;
	end
end

---@return string|nil firstName
function Player:GetFirstName()
	local characteristics = self:GetCharacteristics();
	if characteristics  then
		return characteristics.FN;
	end
end

---@return string|nil lastName
function Player:GetLastName()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.LN;
	end
end

---@return string|nil fullName
function Player:GetFullName()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		local firstName = characteristics.FN;
		local lastName = characteristics.LN;

		if firstName then
			return string.join(" ", firstName, lastName or "");
		end
	end
end

---@return string|nil lastName
function Player:GetTitle()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.TI;
	end
end

---@return string|nil lastName
function Player:GetFullTitle()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.FT;
	end
end

--- Get the roleplaying name of the player.
---@return string|nil playerRoleplayingName @ Will only be nil if the player is not valid, otherwise the game name is used
function Player:GetRoleplayingName()
	local name = self:GetFirstName() or self:GetName();

	if self:GetLastName() then
		name = name .. " " .. self:GetLastName();
	end

	return name;
end

---@return string relationship
function Player:GetRelationshipWithPlayer()
	return TRP3_API.register.relation.getRelation(TRP3_API.register.getUnitIDProfileID(self:GetCharacterID()));
end

---@return Ellyb_Color|nil customColor
function Player:GetCustomColor()
	local characteristics = self:GetCharacteristics();
	if characteristics and characteristics.CH then
		return Ellyb.Color.CreateFromHexa(characteristics.CH);
	end
end


--- Returns a suitable for display custom color for the player.
--- If the current user has the option to increase color contrast on darker names, the color will be affected.
--- @ return Ellyb_Color|nil
function Player:GetCustomColorForDisplay()
	local color = self:GetCustomColor()
	if color and AddOn_TotalRP3.Configuration.shouldDisplayIncreasedColorContrast() then
		color:LightenColorUntilItIsReadableOnDarkBackgrounds()
	end
	return color
end

---@return string|nil
function Player:GetCustomIcon()
	local characteristics = self:GetCharacteristics();
	if characteristics then
		return characteristics.IC
	end
end

TRP3_PlayerNameFormat =
{
	Plain = { useCustomColor = false, useCustomIcon = false },
	Colored = { useCustomColor = true, useCustomIcon = false },
	Fancy = { useCustomColor = true, useCustomIcon = true, iconSize = 15 },
};

function Player:GenerateFormattedName(format)
	assert(format, "Usage: Player:GenerateFormattedName(format)");

	local name = self:GetRoleplayingName();

	if format.useCustomColor then
		local color = self:GetCustomColorForDisplay();

		if color then
			name = color:WrapTextInColorCode(name);
		end
	end

	if format.useCustomIcon then
		local icon = self:GetCustomIcon();

		if icon then
			name = TRP3_API.utils.str.icon(icon, format.iconSize) .. " " .. name;
		end
	end

	return name;
end

--- Get a colored version of the roleplaying name prefixed with the custom icon
---@return string
function Player:GetCustomColoredRoleplayingNamePrefixedWithIcon(iconSize)
	local format = CreateFromMixins(TRP3_PlayerNameFormat.Fancy, { iconSize = iconSize });
	return self:GenerateFormattedName(format);
end

function Player:IsCurrentUser()
	return self:GetCharacterID() == currentUser:GetCharacterID();
end

function Player:IsInCharacter()
	return self:GetRoleplayStatus() ~= Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

function Player:GetRoleplayLanguage()
	return nil;  -- Deprecated, will remove soon.
end

function Player:GetRoleplayExperience()
	return self:GetInfo("character/XP");
end

function Player:GetRoleplayStatus()
	return self:GetInfo("character/RP");
end

function Player:GetCurrentlyText()
	return self:GetInfo("character/CU");
end

function Player:GetMiscFieldByType(miscType)
	local miscInfo = self:GetInfo("characteristics/MI");

	if miscInfo then
		return TRP3_API.GetMiscFieldByType(miscInfo, miscType);
	else
		return nil;
	end
end

function Player:GetMiscFields()
	local miscInfo = self:GetInfo("characteristics/MI");

	if miscInfo then
		return TRP3_API.GetMiscFields(miscInfo);
	else
		return {};
	end
end

function Player:GetCustomGuildMembership()
	local guildNameField = self:GetMiscFieldByType(TRP3_API.MiscInfoType.GuildName);
	local guildRankField = self:GetMiscFieldByType(TRP3_API.MiscInfoType.GuildRank);

	return {
		name = guildNameField and guildNameField.value or nil,
		rank = guildRankField and guildRankField.value or nil,
	};
end

function Player:GetCustomPronouns()
	local fieldInfo = self:GetMiscFieldByType(TRP3_API.MiscInfoType.Pronouns);
	return fieldInfo and fieldInfo.value or nil;
end

function Player:GetAccountType()
	local characterInfo = TRP3_API.register.getUnitIDCharacter(self:GetCharacterID());
	return characterInfo.isTrial
end

function Player:IsOnATrialAccount()
	local accountType = self:GetAccountType()
	if type(accountType) == "number" then
		return accountType == AddOn_TotalRP3.Enums.ACCOUNT_TYPE.TRIAL or accountType == AddOn_TotalRP3.Enums.ACCOUNT_TYPE.VETERAN
	else
		-- Backward compatible check, for versions where the trial flag was true or false
		return accountType == true
	end
end

-- TODO Deprecate GetInfo(path) in favor of proper type safe methods to access profile data
function Player:GetInfo(path)
	return TRP3_API.profile.getData(path, self:GetProfile())
end

--- Creates a new Player for a character ID ("PlayerName-ServerName")
--- @param characterID string
---@return Player player
function Player.static.CreateFromCharacterID(characterID)
	Ellyb.Assertions.isType(characterID, "string", "characterID");

	if characterID == currentUser:GetCharacterID() then
		return Player.GetCurrentUser();
	end

	local player = Player();

	_private[player].characterID = characterID;

	return player;
end

--- Create a new player from a Total RP 3 profile ID.
--- Will throw an error if the profile doesn't exist.
---@return Player player
function Player.static.CreateFromProfileID(profileID)
	Ellyb.Assertions.isType(profileID, "string", "profileID");
	assert(TRP3_Register.profiles[profileID], ("Unknown profile ID %s"):format(profileID));

	local player = Player();

	_private[player].profileID = profileID;
	local profile = player:GetProfile();
	local characterID = UNKNOWN;
	if profile.link then
		characterID = next(profile.link, nil)
	end
	_private[player].characterID = characterID

	return player;
end

--- Create a new Player using a name and a realm.
--- The realm can be nil, in which case the current realm of the user will be used.
--- @param name string Name of the player
--- @param realm string|nil The server of the player, default to the server of the current user
--- @return Player
function Player.static.CreateFromNameAndRealm(name, realm)
	name = (name ~= "") and name or UNKNOWNOBJECT;
	realm = (realm ~= "") and realm or TRP3_API.globals.player_realm_id;

	return Player.static.CreateFromCharacterID(name .. "-" .. realm)
end

--- Create a new Player using a player GUID
--- @param guid string The player GUID to use
--- @return Player
function Player.static.CreateFromGUID(guid)
	local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
	return Player.static.CreateFromNameAndRealm(name, realm)
end

function Player.static.CreateFromUnit(unit)
	local guid = UnitGUID(unit);
	return Player.static.CreateFromGUID(guid);
end

--{{{ Current user
---@class CurrentUser
local CurrentUser = Ellyb.Class("CurrentUser", Player)

function CurrentUser:GetProfile()
	return TRP3_API.profile.getPlayerCurrentProfile().player;
end

function CurrentUser:GetProfileID()
	return TRP3_API.profile.getPlayerCurrentProfileID();
end

function CurrentUser:GetProfileName()
	return TRP3_API.profile.getPlayerCurrentProfile().profileName;
end

function CurrentUser:IsProfileDefault()
	local profileID = self:GetProfileID();
	local defaultID = TRP3_API.configuration.getValue("default_profile_id");

	return profileID == defaultID;
end

function CurrentUser:SetProfileID(profileID)
	TRP3_API.profile.selectProfile(profileID);
end

function CurrentUser:GetCharacterID()
	return TRP3_API.globals.player_id;
end

function CurrentUser:GetRelationshipWithPlayer()
	return TRP3_API.globals.RELATIONS.NONE;
end

function CurrentUser:GetAccountType()
	if IsTrialAccount() then
		return AddOn_TotalRP3.Enums.ACCOUNT_TYPE.TRIAL;
	elseif IsVeteranTrialAccount() then
		return AddOn_TotalRP3.Enums.ACCOUNT_TYPE.VETERAN;
	else
		return AddOn_TotalRP3.Enums.ACCOUNT_TYPE.REGULAR;
	end
end

local function ShouldAllowFieldModification(player, subtableName, fieldName)
	return (subtableName == "character" and fieldName == "RP")
		or (subtableName == "character" and fieldName == "XP")
		or (not player:IsProfileDefault());
end

local function UpdateProfileField(player, subtableName, fieldName, value)
	if not ShouldAllowFieldModification(player, subtableName, fieldName) then
		return;
	end

	local subtable = player:GetInfo(subtableName);

	if subtable[fieldName] == value then
		return;
	end

	subtable[fieldName] = value;
	subtable.v = TRP3_API.utils.math.incrementNumber(subtable.v or 1, 2);

	local playerName = TRP3_API.globals.player_id;
	local profileID = player:GetProfileID();
	TRP3_API.events.fireEvent(TRP3_API.events.REGISTER_DATA_UPDATED, playerName, profileID, subtableName);
end

function CurrentUser:SetRoleplayStatus(roleplayStatus)
	UpdateProfileField(self, "character", "RP", roleplayStatus);
end

function CurrentUser:SetOutOfCharacterInfo(oocInfo)
	UpdateProfileField(self, "character", "CO", oocInfo);
end

function CurrentUser:SetCurrentlyText(currentlyText)
	UpdateProfileField(self, "character", "CU", currentlyText);
end

function CurrentUser:SetFirstName(firstName)
	UpdateProfileField(self, "characteristics", "FN", firstName);
end

function CurrentUser:SetLastName(lastName)
	UpdateProfileField(self, "characteristics", "LN", lastName);
end

function CurrentUser:SetCustomIcon(icon)
	UpdateProfileField(self, "characteristics", "IC", icon);
end

function CurrentUser:SetTitle(title)
	UpdateProfileField(self, "characteristics", "TI", title);
end

function CurrentUser:SetFullTitle(fullTitle)
	UpdateProfileField(self, "characteristics", "FT", fullTitle);
end

function CurrentUser:SetCustomClass(class)
	UpdateProfileField(self, "characteristics", "CL", class);
end

function CurrentUser:SetCustomClassColor(color)
	local hexcolor;

	if type(color) == "string" and #color == 6 then
		hexcolor = color;
	elseif type(color) == "table" and color.GetRGBAsBytes then
		hexcolor = string.format("%02x%02x%02x", color:GetRGBAsBytes());
	else
		error("bad argument #2 to 'SetCustomClassColor': expected hex color string or color object", 2);
	end

	UpdateProfileField(self, "characteristics", "CH", hexcolor);
end

function CurrentUser:SetCustomRace(race)
	UpdateProfileField(self, "characteristics", "RA", race);
end

currentUser = CurrentUser()

--- Returns a reference to the current user as a Player model.
--- The current user has some specific behavior due to data not being stored in the same places.
---@return Player currentUser
--[[ static ]] function Player.GetCurrentUser()
	return currentUser;
end
--}}}

AddOn_TotalRP3.Player = Player
