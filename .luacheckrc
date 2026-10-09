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

	-- Unused variables beginning with "_" are ignored.
	"211/^_",
	"212/^_",
	"231/^_",
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
	"LibStub",
	"mrp",
	"mrpSaved",
	"msp_RPNameplatesAddOn",
	"Plater",
	"Platynator",
	"Prat",
	"TinyTooltip",
	"TipTac",
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

		math = {
			fields = {
				"wrap",
			},
		},

		string = {
			fields = {
				"contains",
				"join",
				"split",
				"startswith",
				"trim",
				"utf8sub", -- Added by the UTF8 library.
			},
		},

		table = {
			fields = {
				"count",
				"isempty",
				"keys",
				"wipe",
			},
		},

		"assertsafe",
		"date",
		"floor",
		"format",
		"ipairs_reverse",
		"strconcat",
		"strjoin",
		"strlen",
		"strlenutf8",
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

		AddOnUtil = {
			fields = {
				"IsAddOnEnabledForCurrentCharacter",
			},
		},

		AnchorUtil = {
			fields = {
				"CreateAnchor",
				"CreateGridLayout",
				"GridLayout",
			},
		},

		ChatFrameUtil = {
			fields = {
				"AddMessageEventFilter",
				"AddSenderNameFilter",
				"FocusActiveWindow",
				"GetActiveWindow",
				"GetChatFrame",
				"OpenChat",
				"RemoveMessageEventFilter",
			},
		},

		Constants = {
			fields = {
				CharacterNameSeparatorConsts = {
					fields = {
						"CHARACTERNAME_REALMNAME_SEPARATOR",
						"CHARACTERNAME_SURNAME_SEPARATOR",
					},
				},
				ChatFrameConstants = {
					fields = {
						"MaxChatChannels",
						"MaxChatWindows",
					},
				},
			},
		},

		C_AddOns = {
			fields = {
				"GetAddOnMetadata",
				"IsAddOnLoaded",
			},
		},

		C_AutoComplete = {
			fields = {
				"GetAutoCompleteRealms",
			},
		},

		C_BattleNet = {
			fields = {
				"GetAccountInfoByGUID",
				"GetGameAccountInfoByGUID",
			},
		},

		C_ChatInfo = {
			fields = {
				"GetChannelShortcut",
				"RegisterAddonMessagePrefix",
				"SendChatMessage",
				"SwapChatChannelsByChannelIndex",
			},
		},

		C_ClassColor = {
			fields = {
				"GetClassColor",
			},
		},

		C_ColorUtil = {
			fields = {
				"ConvertHSLToHSV",
				"ConvertHSVToHSL",
				"ConvertHSVToRGB",
				"ConvertRGBToHSV",
				"WrapTextInColor",
			},
		},

		C_CreatureInfo = {
			fields = {
				"GetFactionInfo",
				"GetRaceInfo",
			},
		},

		C_CVar = {
			fields = {
				"GetCVar",
				"SetCVar",
				"SetTempCVar",
			},
		},

		C_EncodingUtil = {
			fields = {
				"CompressString",
				"DecodeBase64",
				"DecompressString",
				"DeserializeCBOR",
				"EncodeBase64",
				"SerializeCBOR",
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

		C_GameRules = {
			fields = {
				"IsGameRuleActive",
			},
		},

		C_Housing = {
			fields = {
				"GetCurrentHouseInfo",
				"GetCurrentNeighborhoodGUID",
				"GetHousingAccessFlags",
				"GetUIMapIDForNeighborhood",
			},
		},

		C_HousingNeighborhood = {
			fields = {
				"GetNeighborhoodMapData",
			},
		},

		C_Intl = {
			fields = {
				"CompareStrings",
				"FindStringMatches",
				"FoldCase",
				"GetSortKey",
				"Transliterate",
				"ToUpper",
			},
		},

		C_Item = {
			fields = {
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
				"OpenWorldMap",
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
				"GetOwnedPetIDs",
				"GetPetInfoByPetID",
				"GetSummonedPetGUID",
			},
		},

		C_PlayerInfo = {
			fields = {
				"GetAlternateFormInfo",
				"GetClass",
				"GetRace",
				"GetSex",
				"GUIDIsPlayer",
			},
		},

		C_PvP = {
			fields = {
				"GetZonePVPInfo",
				"IsWarModeActive",
				"IsWarModeFeatureEnabled",
			},
		},

		C_RestrictedActions = {
			fields = {
				"IsAddOnRestrictionActive",
			},
		},

		C_Secrets = {
			fields = {
				"ShouldAurasBeSecret",
				"ShouldUnitIdentityBeSecret",
			},
		},

		C_SocialRestrictions = {
			fields = {
				"IsChatDisabled",
			},
		},

		C_Spell = {
			fields = {
				"GetSpellTexture",
				"GetSpellName",
				"RequestLoadSpellData",
			},
		},

		C_StableInfo = {
			fields = {
				"GetStablePetInfo",
			},
		},

		C_Texture = {
			fields = {
				"GetAtlasExists",
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
				"GetWorldCursor",
			},
		},

		C_UIFileAsset = {
			fields = {
				"GetFileID",
				"IsKnownFile",
			},
		},

		C_UnitAuras = {
			fields = {
				"GetAuraDataBySlot",
				"GetAuraSlots",
				"GetPlayerAuraBySpellID",
			},
		},

		C_Weather = {
			fields = {
				"GetCurrentWeather",
			},
		},

		CurveConstants = {
			fields = {
				"ScaleTo100",
			},
		},

		Enum = {
			fields = {
				AddOnRestrictionType = {
					fields = {
						"PvPMatch",
					},
				},

				CollationStrength = {
					fields = {
						"Primary",
					},
				},

				Cursormode = {
					fields = {
						"ItemCursor",
					},
				},

				GameRule = {
					fields = {
						"TransmogEnabled",
					},
				},

				HouseSettingFlags = {
					fields = {
						"HouseAccessAnyone",
					},
				},

				StatusBarInterpolation = {
					fields = {
						"ExponentialEaseOut",
						"Immediate",
					},
				},

				OnUpdateMode = {
					fields = {
						"RunAlways",
						"RunOnce",
						"RunWhenVisible",
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

				UnitSex = {
					fields = {
					},
				},

				WeatherType = {
					fields = {
						"Clear",
						"Rain",
						"Sandstorm",
						"Snow",
					},
				},
			},
		},

		EnumUtil = {
			fields = {
				"GenerateNameTranslation",
			},
		},

		FlagsUtil = {
			fields = {
				"IsSet",
			},
		},

		FrameUtil = {
			fields = {
				"SpecializeFrameWithMixins",
			},
		},

		InputUtil = {
			fields = {
				"IsMouseOver",
			}
		},

		MathUtil = {
			fields = {
				"ApproxZero",
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
				"CreateContextMenu",
				"GetElementText",
				"HideTooltipEx",
				"ShowTooltipEx",
			},
		},

		NamePlateConstants = {
			fields = {
				NAME_ANCHOR_STYLES = {
					fields = {
						"InsideHealthBar",
					},
				},
			},
		},

		PixelUtil = {
			fields = {
				"SetPoint",
			},
		},

		PlayerLocation = {
			fields = {
				"CreateFromUnit",
			},
		},

		RaidWarningUtil = {
			fields = {
				"AddMessage",
			},
		},

		ResizeLayoutMixin = {
			fields = {
				"OnShow",
			},
		},

		ScrollBoxConstants = {
			fields = {
				"NoScrollInterpolation",
				"RetainScrollPosition",
			},
		},

		DragIntersectionArea = {
			fields = {
				"Above",
				"Below",
				"Inside",
			},
		},

		ScrollUtil = {
			fields = {
				"AddManagedScrollBarVisibilityBehavior",
				"InitDefaultLinearDragBehavior",
				"InitScrollBoxListWithScrollBar",
				"InitScrollBoxWithScrollBar",
				"RegisterAlternateRowBehavior",
				"RegisterScrollBoxWithScrollBar",
			},
		},

		TimerUtil = {
			fields = {
				"CreateTimedSignalCallbackMap",
			},
		},

		"AbbreviateLargeNumbers",
		"Ambiguate",
		"BNGetGameAccountInfoByGUID",
		"CalculateStringEditDistance",
		"canaccessallvalues",
		"canaccessvalue",
		"ChatConfigChannelSettings_SwapChannelsByIndex",
		"CheckInteractDistance",
		"Clamp",
		"ClampedPercentageBetween",
		"CopyTable",
		"CountTable",
		"CreateAndInitFromMixin",
		"CreateAtlasMarkup",
		"CreateCounter",
		"CreateDataProvider",
		"CreateFont",
		"CreateFrame",
		"CreateFramePool",
		"CreateFramePoolCollection",
		"CreateFromMixins",
		"CreateMinimalSliderFormatter",
		"CreateScrollBoxLinearView",
		"CreateScrollBoxListGridView",
		"CreateScrollBoxListLinearView",
		"CreateVector2D",
		"ExecuteFrameScript",
		"fastrandom",
		"FCF_GetCurrentChatFrame",
		"FindInTableIf",
		"GameTooltip_AddBlankLineToTooltip",
		"GameTooltip_AddHighlightLine",
		"GameTooltip_AddNormalLine",
		"GameTooltip_SetDefaultAnchor",
		"GameTooltip_SetTitle",
		"GenerateClosure",
		"GetAppropriateTooltip",
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
		"GetEditBoxMetatable",
		"GetFrameMetatable",
		"GetGameTime",
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
		"GetStablePetInfo",
		"GetSubZoneText",
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
		"IsMounted",
		"IsShiftKeyDown",
		"IsTrialAccount",
		"IsVeteranTrialAccount",
		"JoinChannelByName",
		"Lerp",
		"Mixin",
		"MouseIsOver",
		"NamePlateSetupOptions",
		"NeutralPlayerSelectFaction",
		"nop",
		"OpenWorldMap",
		"PetCanBeAbandoned",
		"PlayMusic",
		"PlaySound",
		"PlaySoundFile",
		"RegionalUniqueNamesEnabled",
		"RegisterStateDriver",
		"ReloadUI",
		"RemoveChatWindowChannel",
		"ResetCursor",
		"RoundToSignificantDigits",
		"RunNextFrame",
		"Saturate",
		"ScrollingEdit_OnCursorChanged",
		"ScrollingEdit_OnLoad",
		"ScrollingEdit_OnTextChanged",
		"scrubsecretvalues",
		"SearchBoxTemplate_OnLoad",
		"SearchBoxTemplate_OnTextChanged",
		"SecondsFormatter",
		"SecondsFormatterMixin",
		"securecall",
		"securecallfunction",
		"SecureCmdOptionParse",
		"secureexecuterange",
		"SendSystemMessage",
		"SetCursor",
		"SetCursorByMode",
		"SetCVar",
		"ShouldShowName",
		"ShowCloak",
		"ShowHelm",
		"ShowingCloak",
		"ShowingHelm",
		"ShowUIPanel",
		"StaticPopup_OnClick",
		"StaticPopup_Show",
		"StopMusic",
		"StopSound",
		"StringToBoolean",
		"TableHasAnyEntries",
		"TableIsEmpty",
		"tostringall",
		"UnitBattlePetLevel",
		"UnitBattlePetType",
		"UnitClass",
		"UnitClassBase",
		"UnitCreatureFamily",
		"UnitCreatureType",
		"UnitExists",
		"UnitFactionGroup",
		"UnitGUID",
		"UnitHealth",
		"UnitHealthMax",
		"UnitHealthPercent",
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
		"UnitIsVisible",
		"UnitLevel",
		"UnitName",
		"UnitNameUnmodified",
		"UnitOwnerGUID",
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
				"IsShown",
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
		"GameFontDisableSmall",
		"GameFontHighlight",
		"GameFontHighlightSmall",
		"GameFontNormal",
		"GameFontNormalHuge",
		"GameFontNormalHuge3",
		"GameFontNormalLarge",
		"GameTooltip",
		"GameTooltipHeaderText",
		"GameTooltipText",
		"GridLayoutMixin",
		"MapCanvasDataProviderMixin",
		"ModelFrameMixin",
		"NamePlateDriverFrame",
		"SystemFont_NamePlate_Outlined",
		"SystemFont_Shadow_Huge1",
		"SystemFont_Shadow_Huge3",
		"SystemFont_Shadow_Large",
		"SystemFont_Shadow_Med1",
		"TargetFrame",
		"UIErrorsFrame",
		"UIParent",
		"UISpecialFrames",
		"WorldMapFrame",

		-- Global Constants

		"ACCEPT",
		"AMMOSLOT",
		"BATTLENET_FONT_COLOR",
		"BNET_CLIENT_WOW",
		"CANCEL",
		"CHI",
		"CLOSE",
		"COMBO_POINTS",
		"DELETE",
		"DISABLE",
		"DISABLED_FONT_COLOR",
		"ERR_TOO_MANY_CHAT_CHANNELS",
		"FOCUS_TOKEN_NOT_FOUND",
		"GENERIC_FRACTION_STRING",
		"GREEN_FONT_COLOR",
		"HEALTH",
		"HIGHLIGHT_FONT_COLOR",
		"HOLY_POWER",
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
		"LE_EXPANSION_LEVEL_CURRENT",
		"LE_PARTY_CATEGORY_HOME",
		"LINK_FONT_COLOR",
		"LIST_DELIMITER",
		"LOCALE_enGB",
		"LOCALIZED_CLASS_NAMES_MALE",
		"LOWER_RIGHT_VERTEX",
		"MAX_CHANNEL_BUTTONS",
		"MODELFRAME_MAX_PLAYER_ZOOM",
		"NO",
		"NONE",
		"NORMAL_FONT_COLOR",
		"NOT_BOUND",
		"OKAY",
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
		"UNIT_TYPE_LEVEL_TEMPLATE",
		"UNKNOWN",
		"UNKNOWNOBJECT",
		"UPPER_LEFT_VERTEX",
		"WARNING_FONT_COLOR",
		"WHITE_FONT_COLOR",
		"WOW_PROJECT_ID",
		"WOW_PROJECT_MAINLINE",
		"YELLOW_FONT_COLOR",
		"YES",
		"COLOR",
	},
};
