max_line_length = false

exclude_files = {
	"Scripts/mature_dictionary_template.lua",
	"totalRP3/Libs",
	"Types",
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
		fields = {
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
	"DLAPI.DebugLog",
	"ElvUI",
	"KuiNameplates",
	"KuiNameplatesCore",
	"LibStub",
	"mrp",
	"mrpSaved",
	"Plater",
	"Prat",
	"TinyTooltip",
	"TipTac",
	"WagoAnalytics",
	"WoWUnit",
	"xrpSaved",

	-- Common protocol globals
	"CUSTOM_CLASS_COLORS",
	"GAME_LOCALE",

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
				"arshift",
				"band",
				"bor",
				"bxor",
			},
		},

		string = {
			fields = {
				"concat",
				"join",
				"split",
				"trim",
				"utf8lower", -- Added by the UTF8 library.
				"utf8sub", -- Added by the UTF8 library.
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
		"strlenutf8",
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

		Constants = {
			fields = {
				PetConsts = {
					fields = {
						"NUM_PET_SLOTS",
					},
				},
			},
		},

		C_AddOns = {
			fields = {
				"DisableAddOn",
				"GetAddOnEnableState",
				"GetAddOnMetadata",
				"IsAddOnLoaded",
			},
		},

		C_BattleNet = {
			fields = {
				"GetAccountInfoByGUID",
			},
		},

		C_ChatInfo = {
			fields = {
				"GetChannelShortcut",
				"IsTimerunningPlayer",
				"RegisterAddonMessagePrefix",
				"SwapChatChannelsByChannelIndex",
			},
		},

		C_CVar = {
			fields = {
				"GetCVarBool",
				"SetCVar",
			},
		},

		C_EquipmentSet = {
			fields = {
				"GetEquipmentSetID",
				"GetEquipmentSetInfo",
				"UseEquipmentSet",
			},
		},

		C_EventUtils = {
			fields = {
				"IsEventValid",
			},
		},

		C_FriendList = {
			fields = {
				"IsFriend",
			},
		},

		C_Item = {
			fields = {
				"DoesItemExistByID",
				"GetItemIconByID",
				"GetItemNameByID",
				"IsItemInRange",
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
				"GetMapInfo",
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
				"SetCustomName",
				"SetFilterChecked",
				"SetPetSortParameter",
				"SetPetSourceChecked",
				"SetPetTypeFilter",
				"SetSearchFilter",
			},
		},

		C_PlayerInfo = {
			fields = {
				"GetAlternateFormInfo",
				"GUIDIsPlayer",
			},
		},

		C_PvP = {
			fields = {
				"GetZonePVPInfo",
				"IsWarModeActive",
			},
		},

		C_Spell = {
			fields = {
				"DoesSpellExist",
				"GetSpellInfo",
				"RequestLoadSpellData",
			},
		},

		C_StableInfo = {
			fields = {
				"GetStablePetInfo",
			},
		},

		C_StorePublic = {
			fields = {
				"IsDisabledByParentalControls",
			},
		},

		C_Texture = {
			fields = {
				"GetAtlasInfo",
			},
		},

		C_Timer = {
			fields = {
				"After",
				"NewTicker",
				"NewTimer",
			},
		},

		C_TooltipInfo = {
			fields = {
				"GetUnit",
				"GetWorldCursor",
			},
		},

		C_UnitAuras = {
			fields = {
				"GetAuraDataByIndex",
			},
		},

		Enum = {
			fields = {
				TooltipDataLineType = {
					fields = {
						"UnitOwner",
					},
				},

				TooltipDataType = {
					fields = {
						"Unit",
					},
				},

				TooltipTextureAnchor = {
					fields = {
						"LeftCenter",
					},
				},
			},
		},

		EventTrace = {
			fields = {
				"CanLogEvent",
				"IsLoggingCREvents",
				"LogLine",
			},
		},

		EventUtil = {
			fields = {
				"ContinueOnAddOnLoaded",
			},
		},

		Menu = {
			fields = {
				"ModifyMenu",
			},
		},

		MenuUtil = {
			fields = {
				"CreateButton",
				"CreateCheckbox",
				"CreateContextMenu",
				"CreateDivider",
				"CreateRadio",
				"CreateTitle",
				"GetElementText",
				"HideTooltip",
				"SetElementText",
				"ShowTooltip",
			},
		},

		ScrollUtil = {
			fields = {
				"AddManagedScrollBarVisibilityBehavior",
				"InitScrollBoxListWithScrollBar",
				"RegisterScrollBoxWithScrollBar",
			},
		},

		TimerunningUtil = {
		    fields = {
                "AddSmallIcon",
            },
		},

		"AbbreviateLargeNumbers",
		"Ambiguate",
		"BNGetGameAccountInfoByGUID",
		"BNGetInfo",
		"CalculateStringEditDistance",
		"Chat_GetChatFrame",
		"ChatConfigChannelSettings_SwapChannelsByIndex",
		"ChatEdit_FocusActiveWindow",
		"ChatEdit_GetActiveWindow",
		"ChatFrame_AddMessageEventFilter",
		"ChatFrame_OpenChat",
		"ChatFrame_RemoveMessageEventFilter",
		"CheckInteractDistance",
		"Clamp",
		"ClampedPercentageBetween",
		"CloseDropDownMenus",
		"CopyTable",
		"CreateAndInitFromMixin",
		"CreateAtlasMarkup",
		"CreateCircularBuffer",
		"CreateFont",
		"CreateFrame",
		"CreateFramePool",
		"CreateFromMixins",
		"CreateIndexRangeDataProvider",
		"CreateMinimalSliderFormatter",
		"CreateScrollBoxListGridView",
		"CreateTextureMarkup",
		"CreateVector2D",
		"DisableAddOn",
		"DoesTemplateExist",
		"EventRegistry",
		"ExecuteFrameScript",
		"fastrandom",
		"FCF_GetCurrentChatFrame",
		"FindInTableIf",
		"FormatPercentage",
		"GameTooltip_AddBlankLineToTooltip",
		"GameTooltip_AddColoredLine",
		"GameTooltip_AddHighlightLine",
		"GameTooltip_AddNormalLine",
		"GameTooltip_SetDefaultAnchor",
		"GameTooltip_SetTitle",
		"GameTooltip_ShowDisabledTooltip",
		"GenerateClosure",
		"GetAutoCompleteRealms",
		"GetBindingText",
		"GetChannelDisplayInfo",
		"GetChannelList",
		"GetChannelName",
		"GetChannelRosterInfo",
		"GetChatWindowInfo",
		"GetConvertedKeyOrButton",
		"GetCursorPosition",
		"GetCVar",
		"GetDefaultLanguage",
		"GetFileIDFromPath",
		"GetGuildInfo",
		"GetInventoryItemTexture",
		"GetInventorySlotInfo",
		"GetKeysArray",
		"GetLanguageByIndex",
		"GetLocale",
		"GetMaxLevelForLatestExpansion",
		"GetMinimapZoneText",
		"GetMouseFoci",
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
		"GetTickTime",
		"GetTime",
		"GetTimePreciseSec",
		"GetUnitName",
		"GetValueOrCallFunction",
		"GetZoneText",
		"hooksecurefunc",
		"InCombatLockdown",
		"IsAltKeyDown",
		"IsChatAFK",
		"IsChatDND",
		"IsControlKeyDown",
		"IsGuildMember",
		"IsInGroup",
		"IsInGuild",
		"IsInInstance",
		"IsInRaid",
		"IsKeyDown",
		"IsMacClient",
		"IsMetaKeyDown",
		"IsModifierKeyDown",
		"IsMounted",
		"IsShiftKeyDown",
		"IsSpellKnown",
		"IsTrialAccount",
		"IsVeteranTrialAccount",
		"JoinChannelByName",
		"Lerp",
		"Mixin",
		"MouseIsOver",
		"NeutralPlayerSelectFaction",
		"nop",
		"OpenWorldMap",
		"PetCanBeAbandoned",
		"PlayMusic",
		"PlaySound",
		"PlaySoundFile",
		"RaidNotice_AddMessage",
		"RaidWarningFrame",
		"ReloadUI",
		"RemoveChatWindowChannel",
		"ResetCursor",
		"SafePack",
		"Saturate",
		"ScrollingEdit_OnCursorChanged",
		"ScrollingEdit_OnLoad",
		"ScrollingEdit_OnTextChanged",
		"securecall",
		"securecallfunction",
		"SecureCmdOptionParse",
		"secureexecuterange",
		"SendChatMessage",
		"SendSystemMessage",
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
		"StaticPopup_Show",
		"StopMusic",
		"StopSound",
		"strcmputf8i",
		"StringToBoolean",
		"SwapChatChannelByLocalID",
		"ToggleDropDownMenu",
		"tostringall",
		"UIDropDownMenu_AddButton",
		"UIDropDownMenu_GetText",
		"UIDROPDOWNMENU_INIT_MENU",
		"UIDropDownMenu_Initialize",
		"UIDropDownMenu_IsEnabled",
		"UIDropDownMenu_RefreshAll",
		"UIDropDownMenu_SetAnchor",
		"UIDropDownMenu_SetDisplayMode",
		"UIDropDownMenu_SetDropDownEnabled",
		"UIDropDownMenu_SetInitializeFunction",
		"UIDropDownMenu_SetText",
		"UIDropDownMenu_SetWidth",
		"UIPanelCloseButton_SetBorderAtlas",
		"UnitAffectingCombat",
		"UnitBattlePetLevel",
		"UnitBattlePetType",
		"UnitClass",
		"UnitClassBase",
		"UnitCreatureFamily",
		"UnitCreatureType",
		"UnitExists",
		"UnitFactionGroup",
		"UnitFullName",
		"UnitGUID",
		"UnitHealth",
		"UnitHealthMax",
		"UnitInParty",
		"UnitInRaid",
		"UnitIsAFK",
		"UnitIsBattlePetCompanion",
		"UnitIsDND",
		"UnitIsOtherPlayersPet",
		"UnitIsOwnerOrControllerOfUnit",
		"UnitIsPlayer",
		"UnitIsPVP",
		"UnitIsUnit",
		"UnitLevel",
		"UnitName",
		"UnitNameUnmodified",
		"UnitPlayerControlled",
		"UnitPVPName",
		"UnitRace",
		"UnitSex",
		"UnitTokenFromGUID",
		"Wrap",
		"WrapTextInColorCode",

		-- Global Mixins and UI Objects

		BackdropTemplateMixin = {
			fields = {
				"SetBackdropBorderColor",
			},
		},

		ColorPickerFrame = {
			fields = {
				"GetColorRGB",
				"SetColorRGB",
				"SetupColorPickerAndShow",
			},
		},

		MinimalSliderWithSteppersMixin = {
			fields = {
				Label = {
					fields = {
						"Left",
					},
				},
			},
		},

		"BackdropTemplateMixin",
		"BaseMapPoiPinMixin",
		"CallbackRegistryMixin",
		"ChatFrame1EditBox",
		"ChatTypeInfo",
		"FontableFrameMixin",
		"GameFontDisableSmall",
		"GameFontHighlight",
		"GameFontHighlightSmall",
		"GameFontNormal",
		"GameFontNormalHuge",
		"GameFontNormalHuge3",
		"GameFontNormalLarge",
		"GameTooltip",
		"GameTooltipText",
		"GridLayoutMixin",
		"MapCanvasDataProviderMixin",
		"MenuInputContext",
		"MenuResponse",
		"ModelFrameMixin",
		"NamePlateDriverFrame",
		"SystemFont_LargeNamePlate",
		"SystemFont_Shadow_Huge1",
		"SystemFont_Shadow_Huge3",
		"SystemFont_Shadow_Large",
		"SystemFont_Shadow_Med1",
		"SystemFont_NamePlate",
		"TargetFrame",
		"UIErrorsFrame",
		"UIParent",
		"UISpecialFrames",
		"WorldFrame",
		"WorldMapFrame",

		-- Global Constants

		"ACCEPT",
		"AMMOSLOT",
		"ARCANE_CHARGES",
		"BATTLENET_FONT_COLOR",
		"BNET_CLIENT_WOW",
		"CANCEL",
		"CHI",
		"CLOSE",
		"COMBO_POINTS",
		"DEFAULT_CHAT_FRAME",
		"DELETE",
		"DISABLE",
		"DISABLED_FONT_COLOR",
		"ENABLE_COLORBLIND_MODE",
		"ENERGY",
		"ERR_TOO_MANY_CHAT_CHANNELS",
		"FOCUS_TOKEN_NOT_FOUND",
		"FOCUS",
		"FUEL",
		"FURY",
		"GENERIC_FRACTION_STRING",
		"GREEN_FONT_COLOR",
		"HEALTH",
		"HIGHLIGHT_FONT_COLOR",
		"HOLY_POWER",
		"INSANITY",
		"ITEM_ARTIFACT_COLOR",
		"ITEM_EPIC_COLOR",
		"ITEM_GOOD_COLOR",
		"ITEM_LEGENDARY_COLOR",
		"ITEM_POOR_COLOR",
		"ITEM_QUALITY0_DESC",
		"ITEM_QUALITY1_DESC",
		"ITEM_QUALITY2_DESC",
		"ITEM_QUALITY3_DESC",
		"ITEM_QUALITY4_DESC",
		"ITEM_QUALITY5_DESC",
		"ITEM_QUALITY6_DESC",
		"ITEM_QUALITY7_DESC",
		"ITEM_QUALITY8_DESC",
		"ITEM_STANDARD_COLOR",
		"ITEM_SUPERIOR_COLOR",
		"ITEM_WOW_TOKEN_COLOR",
		"ITEM_WOW_TOKEN_COLOR",
		"KEY_BINDING_NAME_AND_KEY",
		"KEY_BINDING_TOOLTIP",
		"LE_EXPANSION_BATTLE_FOR_AZEROTH",
		"LE_EXPANSION_BURNING_CRUSADE",
		"LE_EXPANSION_CATACLYSM",
		"LE_EXPANSION_CLASSIC",
		"LE_EXPANSION_LEGION",
		"LE_EXPANSION_LEVEL_CURRENT",
		"LE_EXPANSION_MISTS_OF_PANDARIA",
		"LE_EXPANSION_SHADOWLANDS",
		"LE_EXPANSION_WARLORDS_OF_DRAENOR",
		"LE_EXPANSION_WRATH_OF_THE_LICH_KING",
		"LE_PARTY_CATEGORY_HOME",
		"LE_PET_JOURNAL_FILTER_COLLECTED",
		"LE_PET_JOURNAL_FILTER_NOT_COLLECTED",
		"LE_SORT_BY_LEVEL",
		"LIGHTBLUE_FONT_COLOR",
		"LINK_FONT_COLOR",
		"LIST_DELIMITER",
		"LOCALE_enGB",
		"LOCALIZED_CLASS_NAMES_MALE",
		"LUNAR_POWER",
		"MAELSTROM",
		"MANA",
		"MAX_CHANNEL_BUTTONS",
		"MAX_WOW_CHAT_CHANNELS",
		"MODELFRAME_MAX_PLAYER_ZOOM",
		"NO",
		"NONE",
		"NORMAL_FONT_COLOR",
		"NOT_BOUND",
		"NUM_CHAT_WINDOWS",
		"OKAY",
		"PAIN",
		"PLAYER_FACTION_COLOR_ALLIANCE",
		"PLAYER_FACTION_COLOR_HORDE",
		"POWER_TYPE_ARCANE_CHARGES",
		"POWER_TYPE_ENERGY",
		"POWER_TYPE_FOCUS",
		"POWER_TYPE_FUEL",
		"POWER_TYPE_FURY",
		"POWER_TYPE_INSANITY",
		"POWER_TYPE_LUNAR_POWER",
		"POWER_TYPE_MAELSTROM",
		"POWER_TYPE_MANA",
		"POWER_TYPE_PAIN",
		"POWER_TYPE_RUNIC_POWER",
		"RAGE",
		"RAID_CLASS_COLORS",
		"RED_FONT_COLOR",
		"RESET",
		"RUNES",
		"RUNIC_POWER",
		"SAVE",
		"SOUL_SHARDS",
		"SOUNDKIT",
		"TARGET_TOKEN_NOT_FOUND",
		"TOOLTIP_DEFAULT_BACKGROUND_COLOR",
		"TOOLTIP_DEFAULT_COLOR",
		"TOOLTIP_UNIT_LEVEL_TYPE",
		"TRANSMOGRIFY_FONT_COLOR",
		"UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING",
		"UIDROPDOWNMENU_OPEN_MENU",
		"UNIT_TYPE_LEVEL_TEMPLATE",
		"UNITNAME_TITLE_CHARM",
		"UNITNAME_TITLE_COMPANION",
		"UNITNAME_TITLE_CREATION",
		"UNITNAME_TITLE_GUARDIAN",
		"UNITNAME_TITLE_MINION",
		"UNITNAME_TITLE_PET",
		"UNITNAME_TITLE_SQUIRE",
		"UNKNOWN",
		"UNKNOWNOBJECT",
		"UNLOCK",
		"VIDEO_QUALITY_LABEL6",
		"WARNING_FONT_COLOR",
		"WHITE_FONT_COLOR",
		"WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
		"WOW_PROJECT_CLASSIC",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"YES",
	},
};
