max_line_length = false

exclude_files = {
	"Scripts/mature_dictionary_template.lua",
	"totalRP3/libs",
};

ignore = {
	-- Ignore global writes/accesses/mutations on anything prefixed with
	-- "TRP3_". This is the standard prefix for all of our global frame names
	-- and mixins.
	"11./^TRP3_",

	-- Ignore unused self. This would popup for Mixins and Objects
	"212/self",
};

globals = {
	"AddOn_TotalRP3",
	"Ellyb",

	-- Globals
	"BINDING_HEADER_TRP3",
	"BINDING_NAME_TRP3_OPEN_TARGET_PROFILE",
	"BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS",
	"BINDING_NAME_TRP3_TOGGLE",
	"BINDING_NAME_TRP3_TOOLBAR_TOGGLE",
	"msp_RPAddOn",
	"msp",
	"SLASH_TOTALRP31",
	"SLASH_TOTALRP32",

	-- AddOn Overrides
	WIM = {
		fields={
			constants = {
				fields = {
					classes = {
						fields = {
							"GetColoredNameByChatEvent",
							"GetMyColoredName",
						},
					},
				},
			},
		},
	},
};

read_globals = {
	-- Libraries/AddOns
	"AddOn_Chomp",
	"ElvUI",
	"LibStub",
	"mrp",
	"mrpSaved",
	"Prat",
	"TinyTooltip",
	"TipTac",
	"WoWUnit",
	"xrpSaved",

	-- XRP Globals
	"XRP_AE",
	"XRP_AG",
	"XRP_AH",
	"XRP_AW",
	"XRP_CU",
	"XRP_DE",
	"XRP_FC",
	"XRP_FR",
	"XRP_HB",
	"XRP_HH",
	"XRP_HI",
	"XRP_MO",
	"XRP_NA",
	"XRP_NH",
	"XRP_NI",
	"XRP_NT",
	"XRP_RA",
	"XRP_RC",

	-- MSA-DropDownMenu-1.0
	"MSA_DropDownMenu_AddButton",
	"MSA_DropDownMenu_Create",
	"MSA_DropDownMenu_CreateInfo",
	"MSA_DROPDOWNMENU_INIT_MENU",
	"MSA_DropDownMenu_Initialize",
	"MSA_DROPDOWNMENU_OPEN_MENU",
	"MSA_DropDownMenu_RefreshAll",
	"MSA_DropDownMenu_SetSelectedValue",
	"MSA_DropDownMenu_SetText",
	"MSA_DropDownMenu_SetWidth",
	"MSA_HideDropDownMenu",
	"MSA_ToggleDropDownMenu",
};

std = "lua51+wow";

stds.wow = {
	-- Globals that we mutate.
	globals = {
		ColorPickerFrame = {
			fields = {
				"hasOpacity",
				"opacity",
				"func",
				"opacityFunc",
				"cancelFunc",
			},
		},

		"GetColoredName",
		"ItemRefTooltip",
		"SetChannelPassword",
		"SlashCmdList",
		"StaticPopupDialogs",
	},

	-- Globals that we access.
	read_globals = {
		-- Lua function aliases and extensions

		bit = {
			fields = {
				"band",
				"bor",
			},
		},

		table = {
			fields = {
				"wipe",
			},
		},

		"date",
		"floor",
		"format",
		"sort",
		"strconcat",
		"strjoin",
		"strlen",
		"strsplit",
		"strtrim",
		"strupper",
		"tContains",
		"time",
		"tinsert",
		"tInvert",
		"tremove",
		"wipe",

		-- Global Functions

		C_ChatInfo = {
			fields = {
				"RegisterAddonMessagePrefix",
				"SwapChatChannelsByChannelIndex",
			},
		},

		C_Map = {
			fields = {
				"GetBestMapForUnit",
				"GetPlayerMapPosition",
			},
		},

		C_MountJournal = {
			fields = {
				"GetMountIDs",
				"GetMountInfoByID",
				"GetMountInfoExtraByID",
			},
		},

		C_PetJournal = {
			fields = {
				"GetNumPets",
				"GetPetInfoByIndex",
				"GetPetInfoByPetID",
				"GetSummonedPetGUID",
			},
		},

		C_PlayerInfo = {
			fields = {
				"GUIDIsPlayer",
			},
		},

		C_PvP = {
			fields = {
				"IsWarModeActive",
			},
		},

		C_StorePublic = {
			fields = {
				"IsDisabledByParentalControls",
			},
		},

		C_Timer = {
			fields = {
				"After",
				"NewTicker",
				"NewTimer",
			},
		},

		"Ambiguate",
		"BNGetInfo",
		"CallErrorHandler",
		"ChatEdit_FocusActiveWindow",
		"ChatEdit_GetActiveWindow",
		"ChatFrame_AddMessageEventFilter",
		"ChatFrame_OpenChat",
		"ChatFrame_RemoveMessageEventFilter",
		"CreateColor",
		"CreateFrame",
		"CreateFromMixins",
		"CreateTextureMarkup",
		"CreateVector2D",
		"FCF_GetCurrentChatFrame",
		"GameTooltip_AddNormalLine",
		"GameTooltip_SetDefaultAnchor",
		"GameTooltip_SetTitle",
		"GetAddOnMetadata",
		"GetAutoCompleteRealms",
		"GetChannelDisplayInfo",
		"GetChannelName",
		"GetChannelRosterInfo",
		"GetCurrentRegionName",
		"GetCursorPosition",
		"GetCVar",
		"GetDefaultLanguage",
		"GetGuildInfo",
		"GetInventoryItemTexture",
		"GetInventorySlotInfo",
		"GetLanguageByIndex",
		"GetLocale",
		"GetMouseFocus",
		"GetNumLanguages",
		"GetPlayerInfoByGUID",
		"GetRealmName",
		"GetSpellInfo",
		"GetSubZoneText",
		"GetTime",
		"GetZonePVPInfo",
		"GetZoneText",
		"hooksecurefunc",
		"InCombatLockdown",
		"IsAltKeyDown",
		"IsControlKeyDown",
		"IsInGroup",
		"IsInRaid",
		"IsMounted",
		"IsShiftKeyDown",
		"IsTrialAccount",
		"IsVeteranTrialAccount",
		"JoinChannelByName",
		"Mixin",
		"MouseIsOver",
		"OpenWorldMap",
		"PetCanBeRenamed",
		"PlayMusic",
		"PlaySound",
		"PlaySoundFile",
		"RaidNotice_AddMessage",
		"RaidWarningFrame",
		"ReloadUI",
		"RemoveChatWindowChannel",
		"ResetCursor",
		"SendChatMessage",
		"SetCursor",
		"SetCVar",
		"SetPortraitToTexture",
		"ShowCloak",
		"ShowHelm",
		"ShowingCloak",
		"ShowingHelm",
		"ShowUIPanel",
		"Social_ToggleShow",
		"StaticPopup_Show",
		"StopMusic",
		"StopSound",
		"SwapChatChannelByLocalID",
		"UnitAffectingCombat",
		"UnitAura",
		"UnitBattlePetLevel",
		"UnitBattlePetType",
		"UnitClass",
		"UnitCreatureType",
		"UnitExists",
		"UnitFactionGroup",
		"UnitFullName",
		"UnitGUID",
		"UnitInParty",
		"UnitInRaid",
		"UnitIsAFK",
		"UnitIsBattlePetCompanion",
		"UnitIsDND",
		"UnitIsOtherPlayersBattlePet",
		"UnitIsOtherPlayersPet",
		"UnitIsPlayer",
		"UnitIsPVP",
		"UnitIsUnit",
		"UnitLevel",
		"UnitName",
		"UnitPVPName",
		"UnitRace",
		"UnitSex",

		-- Global Mixins and UI Objects

		ColorPickerFrame = {
			fields = {
				"GetColorRGB",
				"SetColorRGB",
			},
		},

		"BackdropTemplateMixin",
		"BaseMapPoiPinMixin",
		"ChatFrame1EditBox",
		"ChatTypeInfo",
		"GameFontNormal",
		"GameFontNormalHuge",
		"GameFontNormalHuge3",
		"GameFontNormalLarge",
		"GameTooltip",
		"MapCanvasDataProviderMixin",
		"TargetFrame",
		"UIErrorsFrame",
		"UIParent",
		"WorldFrame",
		"WorldMapFrame",

		-- Global Constants

		"ACCEPT",
		"AMMOSLOT",
		"ARCANE_CHARGES",
		"CANCEL",
		"CHI",
		"COMBO_POINTS",
		"DEFAULT_CHAT_FRAME",
		"ENABLE_COLORBLIND_MODE",
		"ENERGY",
		"ERR_TOO_MANY_CHAT_CHANNELS",
		"FOCUS_TOKEN_NOT_FOUND",
		"FOCUS",
		"FUEL",
		"FURY",
		"HOLY_POWER",
		"INSANITY",
		"ITEM_QUALITY0_DESC",
		"ITEM_QUALITY1_DESC",
		"ITEM_QUALITY2_DESC",
		"ITEM_QUALITY3_DESC",
		"ITEM_QUALITY4_DESC",
		"ITEM_QUALITY5_DESC",
		"ITEM_QUALITY6_DESC",
		"ITEM_QUALITY7_DESC",
		"ITEM_QUALITY8_DESC",
		"LIST_DELIMITER",
		"LOCALIZED_CLASS_NAMES_MALE",
		"LUNAR_POWER",
		"MAELSTROM",
		"MANA",
		"MAX_CHANNEL_BUTTONS",
		"MAX_WOW_CHAT_CHANNELS",
		"NO",
		"NONE",
		"OKAY",
		"PAIN",
		"RAGE",
		"RAID_CLASS_COLORS",
		"RUNES",
		"RUNIC_POWER",
		"SAVE",
		"SOUL_SHARDS",
		"SOUNDKIT",
		"TARGET_TOKEN_NOT_FOUND",
		"TOOLTIP_DEFAULT_BACKGROUND_COLOR",
		"TOOLTIP_DEFAULT_COLOR",
		"TOOLTIP_UNIT_LEVEL_TYPE",
		"UNITNAME_TITLE_CHARM",
		"UNITNAME_TITLE_COMPANION",
		"UNITNAME_TITLE_CREATION",
		"UNITNAME_TITLE_GUARDIAN",
		"UNITNAME_TITLE_MINION",
		"UNITNAME_TITLE_PET",
		"UNKNOWN",
		"UNKNOWNOBJECT",
		"VIDEO_QUALITY_LABEL6",
		"WOW_PROJECT_CLASSIC",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"YES",
	},
};
