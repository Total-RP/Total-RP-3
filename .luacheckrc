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
	"KuiNameplates",
	"KuiNameplatesCore",
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
	"MSA_CloseDropDownMenus",
	"MSA_DropDownMenu_AddButton",
	"MSA_DropDownMenu_Create",
	"MSA_DropDownMenu_CreateInfo",
	"MSA_DROPDOWNMENU_INIT_MENU",
	"MSA_DropDownMenu_Initialize",
	"MSA_DROPDOWNMENU_MENU_LEVEL",
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

		string = {
			fields = {
				"concat",
				"join",
				"split",
				"trim",
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
		"tAppendAll",
		"tContains",
		"tFilter",
		"time",
		"tinsert",
		"tInvert",
		"tremove",
		"wipe",

		-- Global Functions

		AnchorUtil = {
			fields = {
				"CreateAnchor",
				"CreateGridLayout",
				"GridLayout",
			},
		},

		C_ChatInfo = {
			fields = {
				"RegisterAddonMessagePrefix",
				"SwapChatChannelsByChannelIndex",
			},
		},

		C_Item = {
			fields = {
				"DoesItemExistByID",
				"GetItemIconByID",
				"GetItemNameByID",
				"RequestLoadItemDataByID",
			},
		},

		C_LevelSquish = {
			fields = {
				"ConvertPlayerLevel",
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

		C_NamePlate = {
			fields = {
				"GetNamePlateForUnit",
				"GetNamePlates",
			},
		},

		C_PetJournal = {
			fields = {
				"ClearSearchFilter",
				"GetNumPets",
				"GetNumPetSources",
				"GetNumPetTypes",
				"GetPetInfoByIndex",
				"GetPetInfoByPetID",
				"GetPetSortParameter",
				"GetSummonedPetGUID",
				"IsFilterChecked",
				"IsPetSourceChecked",
				"IsPetTypeChecked",
				"SetAllPetSourcesChecked",
				"SetAllPetTypesChecked",
				"SetFilterChecked",
				"SetPetSortParameter",
				"SetPetSourceChecked",
				"SetPetTypeFilter",
				"SetSearchFilter",
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

		C_Spell = {
			fields = {
				"DoesSpellExist",
				"RequestLoadSpellData",
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
		"Clamp",
		"CloseDropDownMenus",
		"CompactUnitFrame_UpdateHealthColor",
		"CompactUnitFrame_UpdateName",
		"CreateColor",
		"CreateFrame",
		"CreateFramePool",
		"CreateFromMixins",
		"CreateTextureMarkup",
		"CreateVector2D",
		"DisableAddOn",
		"FCF_GetCurrentChatFrame",
		"FindInTableIf",
		"FormatLargeNumber",
		"GameTooltip_AddBlankLineToTooltip",
		"GameTooltip_AddColoredLine",
		"GameTooltip_AddNormalLine",
		"GameTooltip_SetDefaultAnchor",
		"GameTooltip_SetTitle",
		"GetAddOnEnableState",
		"GetAddOnMetadata",
		"GetAutoCompleteRealms",
		"GetChannelDisplayInfo",
		"GetChannelName",
		"GetChannelRosterInfo",
		"GetClassColor",
		"GetCurrentRegionName",
		"GetCursorPosition",
		"GetCVar",
		"GetDefaultLanguage",
		"GetFileIDFromPath",
		"GetGuildInfo",
		"GetInventoryItemTexture",
		"GetInventorySlotInfo",
		"GetLanguageByIndex",
		"GetLocale",
		"GetMaxLevelForLatestExpansion",
		"GetMouseFocus",
		"GetNormalizedRealmName",
		"GetNumLanguages",
		"GetPlayerInfoByGUID",
		"GetRealmName",
		"GetSpellDescription",
		"GetSpellInfo",
		"GetSpellTexture",
		"GetStablePetInfo",
		"GetSubZoneText",
		"GetTime",
		"GetZonePVPInfo",
		"GetZoneText",
		"HideUIPanel",
		"hooksecurefunc",
		"InCombatLockdown",
		"IsAddOnLoaded",
		"IsAltKeyDown",
		"IsControlKeyDown",
		"IsInGroup",
		"IsInRaid",
		"IsMounted",
		"IsShiftKeyDown",
		"IsSpellKnown",
		"IsTrialAccount",
		"IsVeteranTrialAccount",
		"JoinChannelByName",
		"Mixin",
		"MouseIsOver",
		"nop",
		"OpenWorldMap",
		"PetCanBeRenamed",
		"PlayMusic",
		"PlaySound",
		"PlaySoundFile",
		"RaidNotice_AddMessage",
		"RaidWarningFrame",
		"RegisterCVar",
		"ReloadUI",
		"RemoveChatWindowChannel",
		"ResetCursor",
		"Saturate",
		"SecondsToClock",
		"SendChatMessage",
		"SetCursor",
		"SetCVar",
		"SetPetStablePaperdoll",
		"SetPortraitToTexture",
		"ShouldShowName",
		"ShowCloak",
		"ShowHelm",
		"ShowingCloak",
		"ShowingHelm",
		"ShowUIPanel",
		"Social_ToggleShow",
		"StaticPopup_Show",
		"StopMusic",
		"StopSound",
		"strcmputf8i",
		"SwapChatChannelByLocalID",
		"UIDropDownMenu_AddButton",
		"UIDropDownMenu_AddSeparator",
		"UIDROPDOWNMENU_INIT_MENU",
		"UIDROPDOWNMENU_MENU_LEVEL",
		"UIDROPDOWNMENU_MENU_VALUE",
		"UIPanelCloseButton_SetBorderAtlas",
		"UnitAffectingCombat",
		"UnitAura",
		"UnitBattlePetLevel",
		"UnitBattlePetType",
		"UnitClass",
		"UnitClassBase",
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
		"UnitIsOwnerOrControllerOfUnit",
		"UnitIsPlayer",
		"UnitIsPVP",
		"UnitIsUnit",
		"UnitLevel",
		"UnitName",
		"UnitPlayerControlled",
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
		"DropDownList1",
		"FontableFrameMixin",
		"GameFontNormal",
		"GameFontNormalHuge",
		"GameFontNormalHuge3",
		"GameFontNormalLarge",
		"GameTooltip",
		"GridLayoutMixin",
		"MapCanvasDataProviderMixin",
		"NamePlateDriverFrame",
		"SystemFont_LargeNamePlate",
		"SystemFont_NamePlate",
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
		"CLOSE",
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
		"LE_PET_JOURNAL_FILTER_COLLECTED",
		"LE_PET_JOURNAL_FILTER_NOT_COLLECTED",
		"LE_SORT_BY_LEVEL",
		"LIST_DELIMITER",
		"LOCALIZED_CLASS_NAMES_MALE",
		"LUNAR_POWER",
		"MAELSTROM",
		"MANA",
		"MAX_CHANNEL_BUTTONS",
		"MAX_WOW_CHAT_CHANNELS",
		"NO",
		"NONE",
		"NUM_PET_ACTIVE_SLOTS",
		"NUM_PET_STABLE_PAGES",
		"NUM_PET_STABLE_SLOTS",
		"OKAY",
		"PAIN",
		"RAGE",
		"RAID_CLASS_COLORS",
		"RED_FONT_COLOR",
		"RUNES",
		"RUNIC_POWER",
		"SAVE",
		"SOUL_SHARDS",
		"SOUNDKIT",
		"TARGET_TOKEN_NOT_FOUND",
		"TOOLTIP_DEFAULT_BACKGROUND_COLOR",
		"TOOLTIP_DEFAULT_COLOR",
		"TOOLTIP_UNIT_LEVEL_TYPE",
		"UNIT_TYPE_LEVEL_TEMPLATE",
		"UNITNAME_TITLE_CHARM",
		"UNITNAME_TITLE_COMPANION",
		"UNITNAME_TITLE_CREATION",
		"UNITNAME_TITLE_GUARDIAN",
		"UNITNAME_TITLE_MINION",
		"UNITNAME_TITLE_PET",
		"UNKNOWN",
		"UNKNOWNOBJECT",
		"UNLOCK",
		"VIDEO_QUALITY_LABEL6",
		"WOW_PROJECT_CLASSIC",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"YES",
	},
};
