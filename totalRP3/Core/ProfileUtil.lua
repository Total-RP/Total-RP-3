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
	FacialFeatures = 5,
	Piercings = 6,
	Pronouns = 7,
	GuildName = 8,
	GuildRank = 9,
	Tattoos = 10,
	VoiceReference = 11,
};

local MiscInfoTypeData = {
	[TRP3_API.MiscInfoType.Custom] = {
		type = TRP3_API.MiscInfoType.Custom,
		englishName = "Name",
		localizedName = L.CM_NAME,
		icon = TRP3_InterfaceIcons.Default,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.House] = {
		type = TRP3_API.MiscInfoType.House,
		englishName = "House name",
		localizedName = L.REG_PLAYER_MSP_HOUSE,
		icon = TRP3_InterfaceIcons.MiscInfoHouse,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.Nickname] = {
		type = TRP3_API.MiscInfoType.Nickname,
		englishName = "Nickname",
		localizedName = L.REG_PLAYER_MSP_NICK,
		icon = TRP3_InterfaceIcons.MiscInfoNickname,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.Motto] = {
		type = TRP3_API.MiscInfoType.Motto,
		englishName = "Motto",
		localizedName = L.REG_PLAYER_MSP_MOTTO,
		icon = TRP3_InterfaceIcons.MiscInfoMotto,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.FacialFeatures] = {
		type = TRP3_API.MiscInfoType.FacialFeatures,
		englishName = "Facial features",
		localizedName = L.REG_PLAYER_TRP2_TRAITS,
		icon = TRP3_InterfaceIcons.MiscInfoTraits,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.Piercings] = {
		type = TRP3_API.MiscInfoType.Piercings,
		englishName = "Piercings",
		localizedName = L.REG_PLAYER_TRP2_PIERCING,
		icon = TRP3_InterfaceIcons.MiscInfoPiercings,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.Pronouns] = {
		type = TRP3_API.MiscInfoType.Pronouns,
		englishName = "Pronouns",
		localizedName = L.REG_PLAYER_MISC_PRESET_PRONOUNS,
		icon = TRP3_InterfaceIcons.MiscInfoPronouns,
		shownOnTooltip = true,
	},
	[TRP3_API.MiscInfoType.GuildName] = {
		type = TRP3_API.MiscInfoType.GuildName,
		englishName = "Guild name",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_NAME,
		icon = TRP3_InterfaceIcons.MiscInfoGuildName,
		shownOnTooltip = true,
	},
	[TRP3_API.MiscInfoType.GuildRank] = {
		type = TRP3_API.MiscInfoType.GuildRank,
		englishName = "Guild rank",
		localizedName = L.REG_PLAYER_MISC_PRESET_GUILD_RANK,
		icon = TRP3_InterfaceIcons.MiscInfoGuildRank,
		shownOnTooltip = true,
	},
	[TRP3_API.MiscInfoType.Tattoos] = {
		type = TRP3_API.MiscInfoType.Tattoos,
		englishName = "Tattoos",
		localizedName = L.REG_PLAYER_TRP2_TATTOO,
		icon = TRP3_InterfaceIcons.MiscInfoTattoos,
		shownOnTooltip = false,
	},
	[TRP3_API.MiscInfoType.VoiceReference] = {
		type = TRP3_API.MiscInfoType.VoiceReference,
		englishName = "Voice reference",
		localizedName = L.REG_PLAYER_MISC_PRESET_VOICE_REFERENCE,
		icon = TRP3_InterfaceIcons.MiscInfoVoiceReference,
		shownOnTooltip = true,
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
	for miscType, typeInfo in pairs(MiscInfoTypeData) do
		if miscName == typeInfo.englishName or miscName == typeInfo.localizedName then
			return miscType;
		end
	end

	return TRP3_API.MiscInfoType.Custom;
end

function TRP3_API.GetMiscInfoTypeFromData(miscData)
	return miscData.ID or TRP3_API.GetMiscInfoTypeByName(miscData.NA);
end

function TRP3_API.GetMiscTypeInfo(miscType)
	local shallow = true;
	return CopyTable(MiscInfoTypeData[miscType], shallow);
end

local RoleplayExperienceIcons = {
	[AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER] = {
		atlas = "newplayerchat-chaticon-newcomer",
		file = "interface/targetingframe/ui-targetingframe-seal",
	},
	[AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE] = {
		atlas = "newplayerchat-chaticon-guide",
		file = "interface/targetingframe/portraitquestbadge",
	},
};

function TRP3_API.GetRoleplayExperienceIcon(experience)
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

function TRP3_API.GetRoleplayExperienceIconMarkup(experience)
	local iconTexture = TRP3_API.GetRoleplayExperienceIcon(experience);
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

function TRP3_API.GetRoleplayExperienceText(experience)
	if experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER then
		return L.DB_STATUS_XP_NEWCOMER;
	elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN then
		return L.DB_STATUS_XP_VETERAN;
	elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE then
		return L.DB_STATUS_XP_NEWCOMER_GUIDE;
	else
		return L.DB_STATUS_XP_NORMAL;
	end
end

function TRP3_API.GetRoleplayExperienceTooltipText(experience)
	if experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER then
		return L.DB_STATUS_XP_NEWCOMER_TT;
	elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.VETERAN then
		return L.DB_STATUS_XP_VETERAN_TT;
	elseif experience == AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE.NEWCOMER_GUIDE then
		return L.DB_STATUS_XP_NEWCOMER_GUIDE_TT;
	else
		return L.DB_STATUS_XP_NORMAL_TT;
	end
end
