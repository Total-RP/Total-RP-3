-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--
-- Interface Icon Data
--

local DEFAULT_ICON_NAME = "inv_misc_questionmark";

TRP3_InterfaceIcons = {
	Default        = { DEFAULT_ICON_NAME },
	DiceRoll       = { "inv_misc_dice_01" },
	Gears          = { "icon_petfamily_mechanical", "inv_misc_gear_01" },
	ProfileDefault = { "inv_misc_grouplooking" },
	ScanCooldown   = { "ability_mage_timewarp", "spell_nature_timestop" },
	ScanReady      = { "icon_treasuremap", "inv_misc_map_01" },
	Unknown        = { DEFAULT_ICON_NAME },

	--
	-- UI Icons
	--

	DirectorySection  = { "inv_misc_book_09" },
	HistorySection    = { "inv_misc_book_12" },
	MiscInfoSection   = { "inv_misc_note_06" },
	PhysicalSection   = { "ability_warrior_strengthofarms" },
	TraitSection      = { "spell_arcane_mindmastery" },
	CharacterMenuItem = { "pet_type_humanoid", "inv_helmet_20" },
	CompanionMenuItem = { "pet_type_beast", "inv_box_petcarrier_01" },
	DefaultScanIcon   = { "inv_misc_enggizmos_20" },
	PlayerScanIcon    = { "achievement_guildperk_everybodysfriend" },

	--
	-- Target Bar Icons
	--

	TargetFlagMature       = { "ability_hunter_mastermarksman" },
	TargetFlagMatureSafe   = { "inv_valentinescard02" },
	TargetFlagMatureUnsafe = { "inv_inscription_parchmentvar03" },
	TargetOpenCharacterA   = { "inv_misc_paperbundle04c", "inv_inscription_scroll" },
	TargetOpenCharacterH   = { "Inv_misc_paperbundle04b", "inv_inscription_scroll" },
	TargetOpenCharacterN   = { "Inv_misc_paperbundle04a", "inv_inscription_scroll" },
	TargetOpenCompanion    = { "inv_box_petcarrier_01" },
	TargetOpenMount        = { "spell_nature_swiftness" },
	TargetPlayMusic        = { "inv_misc_trinket_goldenharp", "inv_misc_drum_06" },
	TargetNotes            = { "inv_misc_notescript1e", "inv_scroll_02" },

	--
	-- Toolbar Icons
	--

	ToolbarNPCTalk    = { "ability_warrior_commandingshout" },
	ToolbarStatusIC   = { "Inv_collections_armor_hood_b_01_white", "spell_shadow_charm" },
	ToolbarStatusOOC  = { "Inv_collections_armor_hood_b_01_black", "achievement_guildperk_everybodysfriend" },
	ToolbarCloakOn    = { "inv_misc_cape_18" },
	ToolbarCloakOff   = { "inv_misc_cape_20" },
	ToolbarHelmetOn   = { "inv_helmet_13" },
	ToolbarHelmetOff  = { "spell_nature_invisibilty" },
	ToolbarLanguage   = { "spell_holy_silence" },
	ToolbarCurrently  = { "ui_chat" },

	--
	-- Player Mode Icons
	--

	ModeNormal = { "inv_misc_grouplooking" },
	ModeAFK    = { "spell_nature_sleep" },
	ModeDND    = { "ability_mage_incantersabsorbtion" },

	--
	-- Relation Icons
	--

	RelationBusiness   = { "achievement_reputation_08" },
	RelationFamily     = { "achievement_reputation_07" },
	RelationFriend     = { "achievement_reputation_06" },
	RelationLove       = { "inv_valentinescandy" },
	RelationNeutral    = { "achievement_reputation_05", "ability_hibernation" },
	RelationNone       = { "ability_rogue_disguise" },
	RelationUnfriendly = { "ability_dualwield" },

	--
	-- Race Icons
	--

	BloodElfFemale           = { "achievement_character_bloodelf_female" },
	BloodElfMale             = { "achievement_character_bloodelf_male" },
	DarkIronDwarfFemale      = { "ability_racial_foregedinflames", DEFAULT_ICON_NAME },
	DarkIronDwarfMale        = { "ability_racial_fireblood", DEFAULT_ICON_NAME },
	DracthyrFemale           = { "inv_dracthyrhead01", DEFAULT_ICON_NAME},
	DracthyrMale             = { "inv_dracthyrhead02", DEFAULT_ICON_NAME},
	DraeneiFemale            = { "achievement_character_draenei_female" },
	DraeneiMale              = { "achievement_character_draenei_male" },
	DwarfFemale              = { "achievement_character_dwarf_female" },
	DwarfMale                = { "achievement_character_dwarf_male" },
	EarthenDwarfFemale       = { "ability_earthen_wideeyedwonder", DEFAULT_ICON_NAME },
	EarthenDwarfMale         = { "achievement_dungeon_ulduarraid_irondwarf_01", DEFAULT_ICON_NAME },
	GnomeFemale              = { "achievement_character_gnome_female" },
	GnomeMale                = { "achievement_character_gnome_male" },
	GoblinFemale             = { "ability_racial_rocketjump", DEFAULT_ICON_NAME },
	GoblinMale               = { "ability_racial_rocketjump", DEFAULT_ICON_NAME },
	HighmountainTaurenFemale = { "achievement_alliedrace_highmountaintauren", DEFAULT_ICON_NAME },
	HighmountainTaurenMale   = { "ability_racial_bullrush", DEFAULT_ICON_NAME },
	HumanFemale              = { "achievement_character_human_female" },
	HumanMale                = { "achievement_character_human_male" },
	KulTiranFemale           = { "ability_racial_childofthesea", DEFAULT_ICON_NAME },
	KulTiranMale             = { "achievement_boss_zuldazar_manceroy_mestrah", DEFAULT_ICON_NAME },
	LightforgedDraeneiFemale = { "achievement_alliedrace_lightforgeddraenei", DEFAULT_ICON_NAME },
	LightforgedDraeneiMale   = { "ability_racial_finalverdict", DEFAULT_ICON_NAME },
	MagharOrcFemale          = { "achievement_character_orc_female_brn", DEFAULT_ICON_NAME },
	MagharOrcMale            = { "achievement_character_orc_male_brn", DEFAULT_ICON_NAME },
	MechagnomeFemale         = { "inv_plate_mechagnome_c_01helm", DEFAULT_ICON_NAME },
	MechagnomeMale           = { "ability_racial_hyperorganiclightoriginator", DEFAULT_ICON_NAME },
	NightborneFemale         = { "ability_racial_masquerade", DEFAULT_ICON_NAME },
	NightborneMale           = { "ability_racial_dispelillusions", DEFAULT_ICON_NAME },
	NightElfFemale           = { "achievement_character_nightelf_female" },
	NightElfMale             = { "achievement_character_nightelf_male" },
	OrcFemale                = { "achievement_character_orc_female" },
	OrcMale                  = { "achievement_character_orc_male" },
	PandarenFemale           = { "achievement_character_pandaren_female", DEFAULT_ICON_NAME },
	PandarenMale             = { "achievement_guild_classypanda", DEFAULT_ICON_NAME },
	ScourgeFemale            = { "achievement_character_undead_female" },
	ScourgeMale              = { "achievement_character_undead_male" },
	TaurenFemale             = { "achievement_character_tauren_female" },
	TaurenMale               = { "achievement_character_tauren_male" },
	TrollFemale              = { "achievement_character_troll_female" },
	TrollMale                = { "achievement_character_troll_male" },
	VoidElfFemale            = { "ability_racial_preturnaturalcalm", DEFAULT_ICON_NAME },
	VoidElfMale              = { "ability_racial_entropicembrace", DEFAULT_ICON_NAME },
	VulperaFemale            = { "ability_racial_nosefortrouble", DEFAULT_ICON_NAME },
	VulperaMale              = { "ability_racial_nosefortrouble", DEFAULT_ICON_NAME },
	WorgenFemale             = { "ability_racial_viciousness", DEFAULT_ICON_NAME },
	WorgenMale               = { "achievement_worganhead", DEFAULT_ICON_NAME },
	ZandalariTrollFemale     = { "inv_zandalarifemalehead", DEFAULT_ICON_NAME },
	ZandalariTrollMale       = { "inv_zandalarimalehead", DEFAULT_ICON_NAME },

	--
	-- Miscellaneous Info Field Icons
	--

	MiscInfoGuildName      = { "vas_guildnamechange", "inv_shirt_guildtabard_01" },
	MiscInfoGuildRank      = { "achievement_guildperk_honorablemention_rank2", "achievement_pvp_o_04" },
	MiscInfoHouse          = { "inv_misc_kingsring1", "inv_jewelry_ring_36" },
	MiscInfoMotto          = { "inv_inscription_scrollofwisdom_01", "inv_scroll_01" },
	MiscInfoNickname       = { "ability_hunter_beastcall" },
	MiscInfoPiercings      = { "inv_jewelry_ring_14" },
	MiscInfoPronouns       = { "vas_namechange" },
	MiscInfoTattoos        = { "inv_inscription_inkblack01" },
	MiscInfoTraits         = { "spell_shadow_mindsteal" },
	MiscInfoVoiceReference = { "spell_holy_silence" },

	--
	-- Personality Trait Icons
	--

	TraitAltruistic    = { "inv_misc_gift_02" },
	TraitAscetic       = { "inv_misc_food_pinenut" },
	TraitBonVivant     = { "inv_misc_food_99" },
	TraitBrutal        = { "ability_warrior_trauma" },
	TraitCautious      = { "spell_shadow_brainwash" },
	TraitChaotic       = { "ability_rogue_wrongfullyaccused" },
	TraitChaste        = { "inv_belt_27" },
	TraitDeceitful     = { "ability_rogue_disguise" },
	TraitForgiving     = { "inv_rosebouquet01" },
	TraitGentle        = { "inv_valentinescandysack" },
	TraitImpulsive     = { "achievement_bg_captureflag_eos" },
	TraitLawful        = { "ability_paladin_sanctifiedwrath" },
	TraitLustful       = { "spell_shadow_summonsuccubus" },
	TraitParagon       = { "inv_misc_groupneedmore" },
	TraitRational      = { "inv_gizmo_02" },
	TraitRenegade      = { "ability_rogue_honoramongstthieves" },
	TraitSelfish       = { "inv_misc_coin_02" },
	TraitSpineless     = { "ability_druid_cower" },
	TraitSuperstitious = { "spell_holy_holyguidance" },
	TraitTruthful      = { "inv_misc_toy_07" },
	TraitValorous      = { "ability_paladin_beaconoflight" },
	TraitVindictive    = { "ability_hunter_snipershot" },

	--
	-- Language Icons
	--

	LanguageCommon        = { "inv_misc_tournaments_banner_human" },
	LanguageDarnassian    = { "inv_misc_tournaments_banner_nightelf" },
	LanguageDemonic       = { "artifactability_havocdemonhunter_anguishofthedeceiver", DEFAULT_ICON_NAME },
	LanguageDraconic      = { "ability_warrior_dragonroar", DEFAULT_ICON_NAME },
	LanguageDraenei       = { "inv_misc_tournaments_banner_draenei", DEFAULT_ICON_NAME },
	LanguageDwarvish      = { "inv_misc_tournaments_banner_dwarf" },
	LanguageForsaken      = { "inv_misc_tournaments_banner_scourge" },
	LanguageFurbolg       = { "inv_gauntlets_02" },
	LanguageGnomish       = { "inv_misc_tournaments_banner_gnome" },
	LanguageGnomishBinary = { "inv_misc_punchcards_blue" },
	LanguageGoblin        = { "achievement_goblinhead", DEFAULT_ICON_NAME },
	LanguageGoblinBinary  = { "inv_misc_punchcards_blue" },
	LanguageKalimag       = { "shaman_talent_elementalblast", DEFAULT_ICON_NAME },
	LanguageMoonkin       = { "ability_druid_improvedmoonkinform" },
	LanguageNerglish      = { "inv_pet_babymurlocs_blue", DEFAULT_ICON_NAME },
	LanguageOrcish        = { "inv_misc_tournaments_banner_orc" },
	LanguagePandaren      = { "achievement_guild_classypanda", DEFAULT_ICON_NAME },
	LanguageShalassian    = { "achievement_alliedrace_nightborne", DEFAULT_ICON_NAME },
	LanguageShathYar      = { "spell_priest_voidform", DEFAULT_ICON_NAME },
	LanguageSprite        = { "inv_pet_sprite_darter_hatchling", DEFAULT_ICON_NAME },
	LanguageTaurahe       = { "inv_misc_tournaments_banner_tauren" },
	LanguageThalassian    = { "inv_misc_tournaments_banner_bloodelf" },
	LanguageTitan         = { "achievement_dungeon_ulduarraid_titan_01" },
	LanguageVulpera       = { "inv_tabard_vulpera", DEFAULT_ICON_NAME },
	LanguageZandali       = { "inv_misc_tournaments_banner_troll" },
	LanguageZombie        = { "icon_petfamily_undead", DEFAULT_ICON_NAME },

	--
	-- Credits Icons
	--

	CreditsAuthors = { "inv_eng_gizmo1", "trade_engineering" },
	CreditsTeam    = { "quest_khadgar", "achievement_general_stayclassy" },
	CreditsOthers  = { "thumbup", "spell_holy_healingaura" },
};

--
-- Data Initialization
--

do
	local function GetFirstValidTexturePath(candidates, root)
		root = root or "";

		for _, path in ipairs(candidates) do
			if GetFileIDFromPath(root .. path) then
				return path;
			end
		end
	end

	for id, candidates in pairs(TRP3_InterfaceIcons) do
		local name = GetFirstValidTexturePath(candidates, [[interface\icons\]]);

		if not name and TRP3_API.globals.DEBUG_MODE then
			securecallfunction(error, string.format("Invalid interface icon %q: No valid texture file found", id));
		end

		TRP3_InterfaceIcons[id] = name or DEFAULT_ICON_NAME;
	end
end
