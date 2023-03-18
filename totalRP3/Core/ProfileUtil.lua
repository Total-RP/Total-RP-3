-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- Misc. Info Field Utilities

TRP3_API.MiscInfoType = {
	Custom = 1,
	House = 2,
	Nickname = 3,
	Motto = 4,
	Traits = 5,
	Piercings = 6,
	Pronouns = 7,
	GuildName = 8,
	GuildRank = 9,
	Tattoos = 10,
};

local MiscInfoTypeData = {
	[TRP3_API.MiscInfoType.Custom] = {
		type = TRP3_API.MiscInfoType.Custom,
		englishName = "Name",
		localizedName = L.CM_NAME,
		icon = TRP3_InterfaceIcons.Default,
	},
	[TRP3_API.MiscInfoType.House] = {
		type = TRP3_API.MiscInfoType.House,
		englishName = "House name",
		localizedName = L.REG_PLAYER_MSP_HOUSE,
		icon = TRP3_InterfaceIcons.MiscInfoHouse,
	},
	[TRP3_API.MiscInfoType.Nickname] = {
		type = TRP3_API.MiscInfoType.Nickname,
		englishName = "Nickname",
		localizedName = L.REG_PLAYER_MSP_NICK,
		icon = TRP3_InterfaceIcons.MiscInfoNickname,
	},
	[TRP3_API.MiscInfoType.Motto] = {
		type = TRP3_API.MiscInfoType.Motto,
		englishName = "Motto",
		localizedName = L.REG_PLAYER_MSP_MOTTO,
		icon = TRP3_InterfaceIcons.MiscInfoMotto,
	},
	[TRP3_API.MiscInfoType.Traits] = {
		type = TRP3_API.MiscInfoType.Traits,
		englishName = "Physiognomy",
		localizedName = L.REG_PLAYER_TRP2_TRAITS,
		icon = TRP3_InterfaceIcons.MiscInfoTraits,
	},
	[TRP3_API.MiscInfoType.Piercings] = {
		type = TRP3_API.MiscInfoType.Piercings,
		englishName = "Piercings",
		localizedName = L.REG_PLAYER_TRP2_PIERCING,
		icon = TRP3_InterfaceIcons.MiscInfoPiercings,
	},
	[TRP3_API.MiscInfoType.Pronouns] = {
		type = TRP3_API.MiscInfoType.Pronouns,
		englishName = "Pronouns",
		localizedName = L.REG_PLAYER_MISC_PRESET_PRONOUNS,
		icon = TRP3_InterfaceIcons.MiscInfoPronouns,
	},
	[TRP3_API.MiscInfoType.GuildName] = {
		type = TRP3_API.MiscInfoType.GuildName,
		englishName = "Guild name",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_NAME,
		icon = TRP3_InterfaceIcons.MiscInfoGuildName,
	},
	[TRP3_API.MiscInfoType.GuildRank] = {
		type = TRP3_API.MiscInfoType.GuildRank,
		englishName = "Guild rank",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_RANK,
		icon = TRP3_InterfaceIcons.MiscInfoGuildRank,
	},
	[TRP3_API.MiscInfoType.Tattoos] = {
		type = TRP3_API.MiscInfoType.Tattoos,
		englishName = "Tattoos",
		localizedName = L.REG_PLAYER_TRP2_TATTOO,
		icon = TRP3_InterfaceIcons.MiscInfoTattoos,
	},
};

local function CreateMiscFieldInfo(miscType, miscData)
	local typeInfo = MiscInfoTypeData[miscType] or MiscInfoTypeData[TRP3_API.MiscInfoType.Custom];

	return {
		type = miscType,
		englishName = typeInfo.englishName,
		localizedName = miscData.NA or typeInfo.localizedName,
		icon = miscData.IC or typeInfo.icon,
		value = miscData.VA or "",
	};
end

function TRP3_API.GetMiscFieldByType(miscInfo, desiredType)
	for _, miscData in ipairs(miscInfo) do
		local miscType = TRP3_API.GetMiscInfoTypeFromData(miscData);

		if miscType == desiredType then
			return CreateMiscFieldInfo(miscType, miscData);
		end
	end

	return nil;
end

function TRP3_API.GetMiscFieldFromData(miscData)
	local miscType = TRP3_API.GetMiscInfoTypeFromData(miscData);
	return CreateMiscFieldInfo(miscType, miscData);
end

function TRP3_API.GetMiscFields(miscInfo)
	local fields = {};

	for _, miscData in ipairs(miscInfo) do
		local miscType = TRP3_API.GetMiscInfoTypeFromData(miscData);
		table.insert(fields, CreateMiscFieldInfo(miscType, miscData));
	end

	return fields;
end

function TRP3_API.GetMiscInfoTypeByName(miscName)
	-- This is a legacy function that will be removed one day.
	-- Callers should use the GetMiscInfoTypeFromData function instead.

	if miscName == "House name" or miscName == L.REG_PLAYER_MSP_HOUSE then
		return TRP3_API.MiscInfoType.House;
	elseif miscName == "Nickname" or miscName == L.REG_PLAYER_MSP_NICK then
		return TRP3_API.MiscInfoType.Nickname;
	elseif miscName == "Motto" or miscName == L.REG_PLAYER_MSP_MOTTO then
		return TRP3_API.MiscInfoType.Motto;
	elseif miscName == "Physiognomy" or miscName == L.REG_PLAYER_TRP2_TRAITS then
		return TRP3_API.MiscInfoType.Traits;
	elseif miscName == "Piercings" or miscName == L.REG_PLAYER_TRP2_PIERCING then
		return TRP3_API.MiscInfoType.Piercings;
	elseif miscName == "Pronouns" or miscName == L.REG_PLAYER_MISC_PRESET_PRONOUNS then
		return TRP3_API.MiscInfoType.Pronouns;
	elseif miscName == "Guild name" or miscName == L.REG_PLAYER_MISC_PRESET_GUILD_NAME then
		return TRP3_API.MiscInfoType.GuildName;
	elseif miscName == "Guild rank" or miscName == L.REG_PLAYER_MISC_PRESET_GUILD_RANK then
		return TRP3_API.MiscInfoType.GuildRank;
	elseif miscName == "Tattoos" or miscName == L.REG_PLAYER_TRP2_TATTOO then
		return TRP3_API.MiscInfoType.Tattoos;
	else
		return TRP3_API.MiscInfoType.Custom;
	end
end

function TRP3_API.GetMiscInfoTypeFromData(miscData)
	return miscData.ID or TRP3_API.GetMiscInfoTypeByName(miscData.NA);
end

function TRP3_API.GetMiscTypeInfo(miscType)
	local shallow = true;
	return CopyTable(MiscInfoTypeData[miscType], shallow);
end
