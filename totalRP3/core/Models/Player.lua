----------------------------------------------------------------------------------
--- Total RP 3
--- Player model
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---  http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

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
		return characteristics.LN
	end
end

--- Get the roleplaying name of the player.
---@return string|nil playerRoleplayingName @ Will only be nil if the player is not valid, otherwise the game name is used
function Player:GetRoleplayingName()
	local name = self:GetFirstName() or self:GetName();

	if self:GetLastName() then
		name = name .. " " .. self:GetLastName();
	end

	return name
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

--- Get a colored version of the roleplaying name prefixed with the custom icon
---@return string
function Player:GetCustomColoredRoleplayingNamePrefixedWithIcon(iconSize)
	iconSize = iconSize or 15;
	local name, color, icon = self:GetRoleplayingName(), self:GetCustomColorForDisplay(), self:GetCustomIcon();

	if color ~= nil then
		name = color:WrapTextInColorCode(name);
	end
	if icon ~= nil then
		name = TRP3_API.utils.str.icon(icon, iconSize) .. " " .. name;
	end
	return name
end

function Player:IsCurrentUser()
	return self:GetCharacterID() == currentUser:GetCharacterID();
end

function Player:IsInCharacter()
	return self:GetRoleplayStatus() ~= Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

function Player:GetRoleplayLanguage()
	return self:GetInfo("character/LC");
end

function Player:GetRoleplayExperience()
	return self:GetInfo("character/XP");
end

function Player:GetRoleplayStatus()
	return self:GetInfo("character/RP");
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
	if not realm or realm == "" then
		realm = TRP3_API.globals.player_realm_id
	end
	return Player.static.CreateFromCharacterID(name .. "-" .. realm)
end

--- Create a new Player using a player GUID
--- @param guid string The player GUID to use
--- @return Player
function Player.static.CreateFromGUID(guid)
	local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
	return Player.static.CreateFromNameAndRealm(name, realm)
end

--{{{ Current user
---@class CurrentUser
local CurrentUser = Ellyb.Class("CurrentUser", Player)

function CurrentUser:GetProfile()
	return TRP3_API.profile.getPlayerCurrentProfile().player;
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

currentUser = CurrentUser()

--- Returns a reference to the current user as a Player model.
--- The current user has some specific behavior due to data not being stored in the same places.
---@return Player currentUser
--[[ static ]] function Player.GetCurrentUser()
	return currentUser;
end
--}}}

AddOn_TotalRP3.Player = Player
