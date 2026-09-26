-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

local DEFAULT_ICON_NAME = "inv_misc_questionmark";
local DEFAULT_ICON_ID = LRPM12:ResolveIconID("inv_misc_questionmark");

---@return TRP3.IconIdentifier?
local function GetFirstValidIcon(...)
	local icons = { n = select("#", ...), ... };

	for index = 1, icons.n do
		local iconID = LRPM12:ResolveIconID(icons[index]);

		if iconID then
			return iconID;
		end
	end

	securecallfunction(error, string.format("Failed to resolve icon ID (candidates: %s)", table.concat(icons, ", ")), 3);
	return DEFAULT_ICON_ID;
end

---@param iconID integer
local function GetIconName(iconID)
	return LRPM12:GetIconNameByID(iconID) or DEFAULT_ICON_NAME;
end

TRP3_InterfaceIconIDs = {
	Default = DEFAULT_ICON_ID,
	DiceRoll = GetFirstValidIcon("inv_misc_dice_01", "inv_enchant_shardglowingsmall"),
	Gears = GetFirstValidIcon("icon_petfamily_mechanical", "inv_misc_gear_01"),
	ProfileDefault = GetFirstValidIcon("inv_misc_grouplooking"),
	CompanionDefault = GetFirstValidIcon("inv_box_petcarrier_01"),
	ScanCooldown = GetFirstValidIcon("ability_mage_timewarp", "spell_nature_timestop"),
	ScanReady = GetFirstValidIcon("icon_treasuremap", "inv_misc_map_01"),
	Unknown = DEFAULT_ICON_ID,

	--
	-- UI Icons
	--

	DirectorySection = GetFirstValidIcon("inv_misc_book_09"),
	HistorySection = GetFirstValidIcon("inv_misc_book_12"),
	MiscInfoSection = GetFirstValidIcon("inv_misc_note_06"),
	PhysicalSection = GetFirstValidIcon("ability_warrior_strengthofarms", "spell_nature_strength"),
	TraitSection = GetFirstValidIcon("spell_arcane_mindmastery"),
	CharacterMenuItem = GetFirstValidIcon("pet_type_humanoid", "inv_helmet_20"),
	CompanionMenuItem = GetFirstValidIcon("pet_type_beast", "inv_box_petcarrier_01"),
	DefaultScanIcon = GetFirstValidIcon("inv_misc_enggizmos_20"),
	PlayerScanIcon = GetFirstValidIcon("achievement_guildperk_everybodysfriend"),

	--
	-- Target Bar Icons
	--

	TargetFlagMature = GetFirstValidIcon("ability_hunter_mastermarksman"),
	TargetFlagMatureSafe = GetFirstValidIcon("inv_valentinescard02"),
	TargetFlagMatureUnsafe = GetFirstValidIcon("inv_inscription_parchmentvar03", "inv_scroll_07"),
	TargetOpenCharacterA = GetFirstValidIcon("inv_misc_paperbundle04c", "inv_inscription_scroll", "inv_misc_scrollunrolled01"),
	TargetOpenCharacterH = GetFirstValidIcon("Inv_misc_paperbundle04b", "inv_inscription_scroll", "inv_misc_scrollunrolled01"),
	TargetOpenCharacterN = GetFirstValidIcon("Inv_misc_paperbundle04a", "inv_inscription_scroll", "inv_misc_scrollunrolled01"),
	TargetOpenCompanion = GetFirstValidIcon("inv_box_petcarrier_01"),
	TargetOpenMount = GetFirstValidIcon("spell_nature_swiftness"),
	TargetPlayMusic = GetFirstValidIcon("inv_misc_trinket_goldenharp", "inv_misc_drum_06"),
	TargetNotes = GetFirstValidIcon("inv_misc_notescript1e", "inv_scroll_02"),

	--
	-- Toolbar Icons
	--

	ToolbarNPCTalk = GetFirstValidIcon("ability_warrior_commandingshout"),
	ToolbarStatusIC = GetFirstValidIcon("Inv_collections_armor_hood_b_01_white", "spell_shadow_charm"),
	ToolbarStatusOOC = GetFirstValidIcon("Inv_collections_armor_hood_b_01_black", "achievement_guildperk_everybodysfriend"),
	ToolbarCloakOn = GetFirstValidIcon("inv_misc_cape_18"),
	ToolbarCloakOff = GetFirstValidIcon("inv_misc_cape_20"),
	ToolbarHelmetOn = GetFirstValidIcon("inv_helmet_13"),
	ToolbarHelmetOff = GetFirstValidIcon("spell_nature_invisibilty"),
	ToolbarLanguage = GetFirstValidIcon("spell_holy_silence"),
	ToolbarCurrently = GetFirstValidIcon("ui_chat"),

	--
	-- Player Mode Icons
	--

	ModeNormal = GetFirstValidIcon("inv_misc_grouplooking"),
	ModeAFK = GetFirstValidIcon("spell_nature_sleep"),
	ModeDND = GetFirstValidIcon("ability_mage_incantersabsorbtion", "ability_druid_challangingroar"),

	--
	-- Relation Icons
	--

	RelationBusiness = GetFirstValidIcon("achievement_reputation_08", "inv_misc_coin_02"),
	RelationFamily = GetFirstValidIcon("achievement_reputation_07", "achievement_guildperk_everybodysfriend"),
	RelationFriend = GetFirstValidIcon("achievement_reputation_06", "spell_nature_massteleport"),
	RelationLove = GetFirstValidIcon("inv_valentinescandy"),
	RelationNeutral = GetFirstValidIcon("achievement_reputation_05", "ability_hibernation", "inv_misc_grouplooking"),
	RelationNone = GetFirstValidIcon("ability_rogue_disguise"),
	RelationUnfriendly = GetFirstValidIcon("ability_dualwield"),

	--
	-- Race Icons
	--

	BloodElfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.BloodElfFemale, "achievement_character_bloodelf_female", "spell_arcane_teleportsilvermoon"),
	BloodElfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.BloodElfMale, "achievement_character_bloodelf_male", "spell_arcane_teleportsilvermoon"),
	DarkIronDwarfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.DarkIronDwarfFemale, "ability_racial_foregedinflames", DEFAULT_ICON_ID),
	DarkIronDwarfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.DarkIronDwarfMale, "ability_racial_fireblood", DEFAULT_ICON_ID),
	DracthyrFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.DracthyrFemale, "inv_dracthyrhead01", DEFAULT_ICON_ID),
	DracthyrMale = GetFirstValidIcon(TRP3_RaceIconAtlases.DracthyrMale, "inv_dracthyrhead02", DEFAULT_ICON_ID),
	DraeneiFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.DraeneiFemale, "achievement_character_draenei_female", "spell_arcane_teleportexodar"),
	DraeneiMale = GetFirstValidIcon(TRP3_RaceIconAtlases.DraeneiMale, "achievement_character_draenei_male", "spell_arcane_teleportexodar"),
	DwarfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.DwarfFemale, "achievement_character_dwarf_female", "spell_arcane_teleportironforge"),
	DwarfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.DwarfMale, "achievement_character_dwarf_male", "spell_arcane_teleportironforge"),
	EarthenDwarfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.EarthenDwarfFemale, "ability_earthen_wideeyedwonder", DEFAULT_ICON_ID),
	EarthenDwarfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.EarthenDwarfMale, "achievement_dungeon_ulduarraid_irondwarf_01", DEFAULT_ICON_ID),
	GnomeFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.GnomeFemale, "achievement_character_gnome_female", "inv_misc_head_gnome_02"),
	GnomeMale = GetFirstValidIcon(TRP3_RaceIconAtlases.GnomeMale, "achievement_character_gnome_male", "inv_misc_head_gnome_01"),
	GoblinFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.GoblinFemale, "ability_racial_rocketjump", DEFAULT_ICON_ID),
	GoblinMale = GetFirstValidIcon(TRP3_RaceIconAtlases.GoblinMale, "ability_racial_rocketjump", DEFAULT_ICON_ID),
	HarronirFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.HarronirFemale, "inv12_haranir_character_creation_female", DEFAULT_ICON_ID),
	HarronirMale = GetFirstValidIcon(TRP3_RaceIconAtlases.HarronirMale, "inv12_haranir_character_creation_male", DEFAULT_ICON_ID),
	HighmountainTaurenFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.HighmountainTaurenFemale, "achievement_alliedrace_highmountaintauren", DEFAULT_ICON_ID),
	HighmountainTaurenMale = GetFirstValidIcon(TRP3_RaceIconAtlases.HighmountainTaurenMale, "ability_racial_bullrush", DEFAULT_ICON_ID),
	HumanFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.HumanFemale, "achievement_character_human_female", "spell_arcane_teleportstormwind"),
	HumanMale = GetFirstValidIcon(TRP3_RaceIconAtlases.HumanMale, "achievement_character_human_male", "spell_arcane_teleportstormwind"),
	KulTiranFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.KulTiranFemale, "ability_racial_childofthesea", DEFAULT_ICON_ID),
	KulTiranMale = GetFirstValidIcon(TRP3_RaceIconAtlases.KulTiranMale, "achievement_boss_zuldazar_manceroy_mestrah", DEFAULT_ICON_ID),
	LightforgedDraeneiFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.LightforgedDraeneiFemale, "achievement_alliedrace_lightforgeddraenei", DEFAULT_ICON_ID),
	LightforgedDraeneiMale = GetFirstValidIcon(TRP3_RaceIconAtlases.LightforgedDraeneiMale, "ability_racial_finalverdict", DEFAULT_ICON_ID),
	MagharOrcFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.MagharOrcFemale, "achievement_character_orc_female_brn", DEFAULT_ICON_ID),
	MagharOrcMale = GetFirstValidIcon(TRP3_RaceIconAtlases.MagharOrcMale, "achievement_character_orc_male_brn", DEFAULT_ICON_ID),
	MechagnomeFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.MechagnomeFemale, "inv_plate_mechagnome_c_01helm", DEFAULT_ICON_ID),
	MechagnomeMale = GetFirstValidIcon(TRP3_RaceIconAtlases.MechagnomeMale, "ability_racial_hyperorganiclightoriginator", DEFAULT_ICON_ID),
	NightborneFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.NightborneFemale, "ability_racial_masquerade", DEFAULT_ICON_ID),
	NightborneMale = GetFirstValidIcon(TRP3_RaceIconAtlases.NightborneMale, "ability_racial_dispelillusions", DEFAULT_ICON_ID),
	NightElfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.NightElfFemale, "achievement_character_nightelf_female", "spell_arcane_teleportdarnassus"),
	NightElfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.NightElfMale, "achievement_character_nightelf_male", "spell_arcane_teleportdarnassus"),
	OrcFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.OrcFemale, "achievement_character_orc_female", "spell_arcane_teleportorgrimmar"),
	OrcMale = GetFirstValidIcon(TRP3_RaceIconAtlases.OrcMale, "achievement_character_orc_male", "spell_arcane_teleportorgrimmar"),
	PandarenFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.PandarenFemale, "achievement_character_pandaren_female", DEFAULT_ICON_ID),
	PandarenMale = GetFirstValidIcon(TRP3_RaceIconAtlases.PandarenMale, "achievement_guild_classypanda", DEFAULT_ICON_ID),
	ScourgeFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.ScourgeFemale, "achievement_character_undead_female", "spell_arcane_teleportundercity"),
	ScourgeMale = GetFirstValidIcon(TRP3_RaceIconAtlases.ScourgeMale, "achievement_character_undead_male", "spell_arcane_teleportundercity"),
	SkyborneFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.SkyborneFemale, "raceicon-skyborne-female", DEFAULT_ICON_ID),
	SkyborneMale = GetFirstValidIcon(TRP3_RaceIconAtlases.SkyborneMale, "raceicon-skyborne-male", DEFAULT_ICON_ID),
	TaurenFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.TaurenFemale, "achievement_character_tauren_female", "spell_arcane_teleportthunderbluff"),
	TaurenMale = GetFirstValidIcon(TRP3_RaceIconAtlases.TaurenMale, "achievement_character_tauren_male", "spell_arcane_teleportthunderbluff"),
	TrollFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.TrollFemale, "achievement_character_troll_female", "inv_misc_head_troll_02"),
	TrollMale = GetFirstValidIcon(TRP3_RaceIconAtlases.TrollMale, "achievement_character_troll_male"),
	VoidElfFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.VoidElfFemale, "ability_racial_preturnaturalcalm", DEFAULT_ICON_ID),
	VoidElfMale = GetFirstValidIcon(TRP3_RaceIconAtlases.VoidElfMale, "ability_racial_entropicembrace", DEFAULT_ICON_ID),
	VulperaFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.VulperaFemale, "ability_racial_nosefortrouble", DEFAULT_ICON_ID),
	VulperaMale = GetFirstValidIcon(TRP3_RaceIconAtlases.VulperaMale, "ability_racial_nosefortrouble", DEFAULT_ICON_ID),
	WorgenFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.WorgenFemale, "ability_racial_viciousness", DEFAULT_ICON_ID),
	WorgenMale = GetFirstValidIcon(TRP3_RaceIconAtlases.WorgenMale, "achievement_worganhead", DEFAULT_ICON_ID),
	ZandalariTrollFemale = GetFirstValidIcon(TRP3_RaceIconAtlases.ZandalariTrollFemale, "inv_zandalarifemalehead", DEFAULT_ICON_ID),
	ZandalariTrollMale = GetFirstValidIcon(TRP3_RaceIconAtlases.ZandalariTrollMale, "inv_zandalarimalehead", DEFAULT_ICON_ID),

	--
	-- Miscellaneous Info Field Icons
	--

	MiscInfoGuildName = GetFirstValidIcon("vas_guildnamechange", "inv_shirt_guildtabard_01"),
	MiscInfoGuildRank = GetFirstValidIcon("achievement_guildperk_honorablemention_rank2", "achievement_pvp_o_04", "achievement_guildperk_havegroup willtravel"),
	MiscInfoHouse = GetFirstValidIcon("inv_misc_kingsring1", "inv_jewelry_ring_36"),
	MiscInfoMotto = GetFirstValidIcon("inv_inscription_scrollofwisdom_01", "inv_scroll_01"),
	MiscInfoNickname = GetFirstValidIcon("ability_hunter_beastcall"),
	MiscInfoPiercings = GetFirstValidIcon("inv_jewelry_ring_14"),
	MiscInfoPronouns = GetFirstValidIcon("vas_namechange"),
	MiscInfoTattoos = GetFirstValidIcon("inv_inscription_inkblack01", "inv_potion_133"),
	MiscInfoTraits = GetFirstValidIcon("spell_shadow_mindsteal"),
	MiscInfoVoiceReference = GetFirstValidIcon("spell_holy_silence"),

	--
	-- Personality Trait Icons
	--

	TraitAltruistic = GetFirstValidIcon("inv_misc_gift_02"),
	TraitAscetic = GetFirstValidIcon("inv_misc_food_pinenut", "inv_misc_food_02"),
	TraitBonVivant = GetFirstValidIcon("inv_misc_food_99"),
	TraitBrutal = GetFirstValidIcon("ability_warrior_trauma", "ability_warrior_bloodfrenzy"),
	TraitCautious = GetFirstValidIcon("spell_shadow_brainwash"),
	TraitChaotic = GetFirstValidIcon("ability_rogue_wrongfullyaccused", "spell_fire_masterofelements"),
	TraitChaste = GetFirstValidIcon("inv_belt_27"),
	TraitDeceitful = GetFirstValidIcon("ability_rogue_disguise"),
	TraitForgiving = GetFirstValidIcon("inv_rosebouquet01"),
	TraitGentle = GetFirstValidIcon("inv_valentinescandysack"),
	TraitImpulsive = GetFirstValidIcon("achievement_bg_captureflag_eos", "spell_fire_burningspeed"),
	TraitLawful = GetFirstValidIcon("ability_paladin_sanctifiedwrath", "inv_shield_35"),
	TraitLustful = GetFirstValidIcon("spell_shadow_summonsuccubus"),
	TraitParagon = GetFirstValidIcon("inv_misc_groupneedmore"),
	TraitRational = GetFirstValidIcon("inv_gizmo_02"),
	TraitRenegade = GetFirstValidIcon("ability_rogue_honoramongstthieves", "ability_warrior_improveddisciplines"),
	TraitSelfish = GetFirstValidIcon("inv_misc_coin_02"),
	TraitSpineless = GetFirstValidIcon("ability_druid_cower"),
	TraitSuperstitious = GetFirstValidIcon("spell_holy_holyguidance"),
	TraitTruthful = GetFirstValidIcon("inv_misc_toy_07"),
	TraitValorous = GetFirstValidIcon("ability_paladin_beaconoflight", "spell_holy_auraoflight"),
	TraitVindictive = GetFirstValidIcon("ability_hunter_snipershot"),

	--
	-- Language Icons
	--

	LanguageCommon = GetFirstValidIcon("inv_misc_tournaments_banner_human", "spell_arcane_teleportstormwind"),
	LanguageDarnassian = GetFirstValidIcon("inv_misc_tournaments_banner_nightelf", "spell_arcane_teleportdarnassus"),
	LanguageDemonic = GetFirstValidIcon("artifactability_havocdemonhunter_anguishofthedeceiver", DEFAULT_ICON_ID),
	LanguageDraconic = GetFirstValidIcon("ability_warrior_dragonroar", DEFAULT_ICON_ID),
	LanguageDraenei = GetFirstValidIcon("inv_misc_tournaments_banner_draenei", "spell_arcane_teleportexodar"),
	LanguageDwarvish = GetFirstValidIcon("inv_misc_tournaments_banner_dwarf", "spell_arcane_teleportironforge"),
	LanguageForsaken = GetFirstValidIcon("inv_misc_tournaments_banner_scourge", "spell_arcane_teleportundercity"),
	LanguageFurbolg = GetFirstValidIcon("inv_gauntlets_02"),
	LanguageGnomish = GetFirstValidIcon("inv_misc_tournaments_banner_gnome", "inv_misc_head_gnome_01"),
	LanguageGnomishBinary = GetFirstValidIcon("inv_misc_punchcards_blue"),
	LanguageGoblin = GetFirstValidIcon("achievement_goblinhead", DEFAULT_ICON_ID),
	LanguageGoblinBinary = GetFirstValidIcon("inv_misc_punchcards_blue"),
	LanguageHarani = GetFirstValidIcon("inv12_achievements_alliedrace_haranir_sigil", DEFAULT_ICON_ID),
	LanguageKalimag = GetFirstValidIcon("shaman_talent_elementalblast", DEFAULT_ICON_ID),
	LanguageMoonkin = GetFirstValidIcon("ability_druid_improvedmoonkinform", "ability_eyeoftheowl"),
	LanguageNerglish = GetFirstValidIcon("inv_pet_babymurlocs_blue", DEFAULT_ICON_ID),
	LanguageOrcish = GetFirstValidIcon("inv_misc_tournaments_banner_orc", "spell_arcane_teleportorgrimmar"),
	LanguagePandaren = GetFirstValidIcon("achievement_guild_classypanda", DEFAULT_ICON_ID),
	LanguageShalassian = GetFirstValidIcon("achievement_alliedrace_nightborne", DEFAULT_ICON_ID),
	LanguageShathYar = GetFirstValidIcon("spell_priest_voidform", DEFAULT_ICON_ID),
	LanguageSprite = GetFirstValidIcon("inv_pet_sprite_darter_hatchling", DEFAULT_ICON_ID),
	LanguageTaurahe = GetFirstValidIcon("inv_misc_tournaments_banner_tauren", "spell_arcane_teleportthunderbluff"),
	LanguageThalassian = GetFirstValidIcon("inv_misc_tournaments_banner_bloodelf", "spell_arcane_teleportsilvermoon"),
	LanguageTitan = GetFirstValidIcon("achievement_dungeon_ulduarraid_titan_01", DEFAULT_ICON_ID),
	LanguageVulpera = GetFirstValidIcon("inv_tabard_vulpera", DEFAULT_ICON_ID),
	LanguageZandali = GetFirstValidIcon("inv_misc_tournaments_banner_troll", "achievement_character_troll_male"),
	LanguageZombie = GetFirstValidIcon("icon_petfamily_undead", DEFAULT_ICON_ID),

	--
	-- Credits Icons
	--

	CreditsAuthors = GetFirstValidIcon("inv_eng_gizmo1", "trade_engineering"),
	CreditsTeam = GetFirstValidIcon("quest_khadgar", "achievement_general_stayclassy"),
	CreditsOthers = GetFirstValidIcon("thumbup", "spell_holy_healingaura"),
};

TRP3_InterfaceIconNames = {
	Default = GetIconName(TRP3_InterfaceIconIDs.Default),
	ProfileDefault = GetIconName(TRP3_InterfaceIconIDs.ProfileDefault),
	Unknown = GetIconName(TRP3_InterfaceIconIDs.Unknown),
};
