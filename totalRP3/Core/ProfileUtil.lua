-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3.loc;

-- Misc. Info Field Utilities

TRP3.MiscInfoType = {
	Custom = 1,
	House = 2,
	Nickname = 3,
	Motto = 4,
	FacialFeatures = 5,
	Piercings = 6,
	Pronouns = 7,
	GuildName = 8,
	GuildRank = 9,
	Tattoos = 10,
	VoiceReference = 11,
};

local MiscInfoTypeData = {
	[TRP3.MiscInfoType.Custom] = {
		type = TRP3.MiscInfoType.Custom,
		englishName = "Name",
		localizedName = L.CM_NAME,
		icon = TRP3_InterfaceIcons.Default,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.House] = {
		type = TRP3.MiscInfoType.House,
		englishName = "House name",
		localizedName = L.REG_PLAYER_MSP_HOUSE,
		icon = TRP3_InterfaceIcons.MiscInfoHouse,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.Nickname] = {
		type = TRP3.MiscInfoType.Nickname,
		englishName = "Nickname",
		localizedName = L.REG_PLAYER_MSP_NICK,
		icon = TRP3_InterfaceIcons.MiscInfoNickname,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.Motto] = {
		type = TRP3.MiscInfoType.Motto,
		englishName = "Motto",
		localizedName = L.REG_PLAYER_MSP_MOTTO,
		icon = TRP3_InterfaceIcons.MiscInfoMotto,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.FacialFeatures] = {
		type = TRP3.MiscInfoType.FacialFeatures,
		englishName = "Facial features",
		localizedName = L.REG_PLAYER_TRP2_TRAITS,
		icon = TRP3_InterfaceIcons.MiscInfoTraits,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.Piercings] = {
		type = TRP3.MiscInfoType.Piercings,
		englishName = "Piercings",
		localizedName = L.REG_PLAYER_TRP2_PIERCING,
		icon = TRP3_InterfaceIcons.MiscInfoPiercings,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.Pronouns] = {
		type = TRP3.MiscInfoType.Pronouns,
		englishName = "Pronouns",
		localizedName = L.REG_PLAYER_MISC_PRESET_PRONOUNS,
		icon = TRP3_InterfaceIcons.MiscInfoPronouns,
		shownOnTooltip = true,
	},
	[TRP3.MiscInfoType.GuildName] = {
		type = TRP3.MiscInfoType.GuildName,
		englishName = "Guild name",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_NAME,
		icon = TRP3_InterfaceIcons.MiscInfoGuildName,
		shownOnTooltip = true,
	},
	[TRP3.MiscInfoType.GuildRank] = {
		type = TRP3.MiscInfoType.GuildRank,
		englishName = "Guild rank",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_RANK,
		icon = TRP3_InterfaceIcons.MiscInfoGuildRank,
		shownOnTooltip = true,
	},
	[TRP3.MiscInfoType.Tattoos] = {
		type = TRP3.MiscInfoType.Tattoos,
		englishName = "Tattoos",
		localizedName = L.REG_PLAYER_TRP2_TATTOO,
		icon = TRP3_InterfaceIcons.MiscInfoTattoos,
		shownOnTooltip = false,
	},
	[TRP3.MiscInfoType.VoiceReference] = {
		type = TRP3.MiscInfoType.VoiceReference,
		englishName = "Voice reference",
		localizedName = L.REG_PLAYER_MISC_PRESET_VOICE_REFERENCE,
		icon = TRP3_InterfaceIcons.MiscInfoVoiceReference,
		shownOnTooltip = true,
	},
};

local function CreateMiscFieldInfo(miscType, miscData)
	local typeInfo = MiscInfoTypeData[miscType] or MiscInfoTypeData[TRP3.MiscInfoType.Custom];

	return {
		type = miscType,
		englishName = typeInfo.englishName,
		localizedName = miscData.NA or typeInfo.localizedName,
		icon = miscData.IC or typeInfo.icon,
		value = miscData.VA or "",
	};
end

function TRP3.GetMiscFieldByType(miscInfo, desiredType)
	for _, miscData in ipairs(miscInfo) do
		local miscType = TRP3.GetMiscInfoTypeFromData(miscData);

		if miscType == desiredType then
			return CreateMiscFieldInfo(miscType, miscData);
		end
	end

	return nil;
end

function TRP3.GetMiscFieldFromData(miscData)
	local miscType = TRP3.GetMiscInfoTypeFromData(miscData);
	return CreateMiscFieldInfo(miscType, miscData);
end

function TRP3.GetMiscFields(miscInfo)
	local fields = {};

	for _, miscData in ipairs(miscInfo) do
		local miscType = TRP3.GetMiscInfoTypeFromData(miscData);
		table.insert(fields, CreateMiscFieldInfo(miscType, miscData));
	end

	return fields;
end

function TRP3.GetMiscInfoTypeByName(miscName)
	for miscType, typeInfo in pairs(MiscInfoTypeData) do
		if miscName == typeInfo.englishName or miscName == typeInfo.localizedName then
			return miscType;
		end
	end

	return TRP3.MiscInfoType.Custom;
end

function TRP3.GetMiscInfoTypeFromData(miscData)
	return miscData.ID or TRP3.GetMiscInfoTypeByName(miscData.NA);
end

function TRP3.GetMiscTypeInfo(miscType)
	local shallow = true;
	return CopyTable(MiscInfoTypeData[miscType], shallow);
end

local RoleplayExperienceIcons = {
	[TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER] = {
		atlas = "newplayerchat-chaticon-newcomer",
		file = "interface/targetingframe/ui-targetingframe-seal",
	},
	[TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE] = {
		atlas = "newplayerchat-chaticon-guide",
		file = "interface/targetingframe/portraitquestbadge",
	},
};

function TRP3.GetRoleplayExperienceIcon(experience)
	local iconInfo = RoleplayExperienceIcons[experience];
	local iconTexture;

	if iconInfo then
		if iconInfo.atlas and C_Texture.GetAtlasInfo(iconInfo.atlas) then
			iconTexture = iconInfo.atlas;
		elseif iconInfo.file and GetFileIDFromPath(iconInfo.file) then
			iconTexture = iconInfo.file;
		end
	end

	return iconTexture;
end

function TRP3.GetRoleplayExperienceIconMarkup(experience)
	local iconTexture = TRP3.GetRoleplayExperienceIcon(experience);
	local iconMarkup;

	if iconTexture ~= nil then
		if string.find(iconTexture, "/") then
			iconMarkup = string.format("|T%s:%d:%d|t", iconTexture, 16, 16);
		else
			iconMarkup = string.format("|A:%s:%d:%d|a", iconTexture, 16, 16)
		end
	end

	return iconMarkup;
end

function TRP3.GetRoleplayExperienceText(experience)
	if experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER then
		return L.DB_STATUS_XP_NEWCOMER;
	elseif experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN then
		return L.DB_STATUS_XP_VETERAN;
	elseif experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE then
		return L.DB_STATUS_XP_NEWCOMER_GUIDE;
	else
		return L.DB_STATUS_XP_NORMAL;
	end
end

function TRP3.GetRoleplayExperienceTooltipText(experience)
	if experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER then
		return L.DB_STATUS_XP_NEWCOMER_TT;
	elseif experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN then
		return L.DB_STATUS_XP_VETERAN_TT;
	elseif experience == TRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE then
		return L.DB_STATUS_XP_NEWCOMER_GUIDE_TT;
	else
		return L.DB_STATUS_XP_NORMAL_TT;
	end
end

TRP3_ProfileUtil = {};

function TRP3_ProfileUtil.SerializeProfile(addonVersion, profileID, profileData)
	local packedData = { addonVersion, profileID, profileData };
	local serializedData;

	local label = "TRP3 PROFILE";
	local data = TRP3_EncodingUtil.CompressString(C_EncodingUtil.SerializeCBOR(packedData));
	local headers = {
		{ key = "Name", value = profileData.profileName },
		{ key = "Exported", value = date("%Y-%m-%d %H:%M:%S") },
		{ key = "AddOn-Version", value = TRP3.globals.version_display },
	};

	serializedData = TRP3_EncodingUtil.EncodePEM(label, data, headers);
	return serializedData;
end

function TRP3_ProfileUtil.DeserializeProfile(serializedData)
	local ok, packedData;

	-- Exports that begin with an "^1" are AceSerializer-based exports.
	if string.find(serializedData, "^^1") then
		ok, packedData = pcall(TRP3.utils.serial.deserialize, serializedData);

		if not ok then
			return nil, L.PR_IMPORT_ERROR_DESERIALIZE_ACE;
		end
	else
		local decodedLabel, decodedData;
		ok, decodedLabel, decodedData = pcall(TRP3_EncodingUtil.DecodePEM, serializedData);

		if not ok then
			return nil, L.PR_IMPORT_ERROR_PEM_DECODE;
		end

		if decodedLabel ~= "TRP3 PROFILE" then
			return nil, L.PR_IMPORT_ERROR_PEM_LABEL;
		end

		local decompressedData;
		ok, decompressedData = pcall(C_EncodingUtil.DecompressString, decodedData);

		if not ok then
			return nil, L.PR_IMPORT_ERROR_DECOMPRESS;
		end

		ok, packedData = pcall(C_EncodingUtil.DeserializeCBOR, decompressedData);

		if not ok then
			return nil, L.PR_IMPORT_ERROR_DESERIALIZE_CBOR;
		end
	end

	if type(packedData) ~= "table" or #packedData < 3 then
		return nil, L.PR_IMPORT_ERROR_PACKED_DATA_INVALID;
	end

	local addonVersion, profileID, profileData = unpack(packedData, 1, 3);
	return addonVersion, profileID, profileData;
end
