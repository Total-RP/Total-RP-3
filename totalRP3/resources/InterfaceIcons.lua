--[[
	Total RP 3

	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--]]

--
-- Interface Data
--

local DEFAULT_ICON_NAME = "inv_misc_questionmark";

TRP3_InterfaceIcons = {
	Default        = { DEFAULT_ICON_NAME },
	DiceRoll       = { "inv_misc_dice_01", "inv_enchant_shardglowingsmall" },
	Gears          = { "icon_petfamily_mechanical", "inv_misc_gear_01" },
	ProfileDefault = { "inv_misc_grouplooking", "achievement_guildperk_everybodysfriend" },
	ScanCooldown   = { "ability_mage_timewarp", "spell_nature_timestop" },
	ScanReady      = { "icon_treasuremap", "inv_misc_map_01" },
	Unknown        = { DEFAULT_ICON_NAME },

	--
	-- UI Icons
	--

	DirectorySection  = { "inv_misc_book_09" },
	HistorySection    = { "inv_misc_book_12" },
	MiscInfoSection   = { "inv_misc_note_06" },
	PhysicalSection   = { "ability_warrior_strengthofarms", "spell_holy_fistofjustice" },
	TraitSection      = { "spell_arcane_mindmastery", "spell_holy_mindsooth" },
	CharacterMenuItem = { "pet_type_humanoid", "inv_helmet_20" },
	CompanionMenuItem = { "pet_type_beast", "inv_box_petcarrier_01" },
	DefaultScanIcon   = { "inv_misc_enggizmos_20" },
	PlayerScanIcon    = { "achievement_guildperk_everybodysfriend" },

	--
	-- Target Bar Icons
	--

	TargetFlagMature       = { "ability_hunter_mastermarksman", "ability_hunter_snipershot" },
	TargetFlagMatureSafe   = { "inv_valentinescard02" },
	TargetFlagMatureUnsafe = { "inv_inscription_parchmentvar03", "inv_scroll_07" },
	TargetIgnoreCharacter  = { "achievement_bg_interruptx_flagcapture_attempts_1game", "spell_holy_silence" },
	TargetOpenCharacter    = { "inv_inscription_scroll", "inv_misc_book_09" },
	TargetOpenMount        = { "ability_mount_charger" },
	TargetPlayMusic        = { "inv_misc_drum_06", "inv_misc_drum_01" },
	TargetNotes            = { "inv_misc_scrollunrolled03b", "inv_scroll_02" },

	--
	-- Toolbar Icons
	--

	ToolbarNPCTalk   = { "ability_warrior_commandingshout", "ability_warrior_battleshout" },
	ToolbarStatusIC  = { "spell_shadow_charm" },
	ToolbarStatusOOC = { "inv_misc_grouplooking", "achievement_guildperk_everybodysfriend" },
	ToolbarCloakOn   = { "inv_misc_cape_18" },
	ToolbarCloakOff  = { "inv_misc_cape_20" },
	ToolbarHelmetOn  = { "inv_helmet_13" },
	ToolbarHelmetOff = { "spell_nature_invisibilty" },
	ToolbarLanguage  = { "spell_holy_silence" },

	--
	-- Player Mode Icons
	--

	ModeNormal = { "ability_rogue_masterofsubtlety", "ability_stealth" },
	ModeAFK    = { "spell_nature_sleep" },
	ModeDND    = { "ability_mage_incantersabsorbtion", "ability_warrior_challange" },

	--
	-- Relation Icons
	--

	RelationBusiness   = { "achievement_reputation_08", "inv_misc_coin_04" },
	RelationFamily     = { "achievement_reputation_07", "spell_holy_spellwarding" },
	RelationFriend     = { "achievement_reputation_06", "spell_holy_prayerofhealing" },
	RelationLove       = { "inv_valentinescandy" },
	RelationNeutral    = { "achievement_reputation_05", "ability_hibernation" },
	RelationNone       = { "ability_rogue_disguise" },
	RelationUnfriendly = { "ability_dualwield" },

	--
	-- Race Icons
	--

	BloodElfFemale           = { "achievement_character_bloodelf_female", "inv_staff_73", DEFAULT_ICON_NAME },
	BloodElfMale             = { "achievement_character_bloodelf_male", "inv_weapon_bow_38", DEFAULT_ICON_NAME },
	DarkIronDwarfFemale      = { "ability_racial_foregedinflames", DEFAULT_ICON_NAME },
	DarkIronDwarfMale        = { "ability_racial_fireblood", DEFAULT_ICON_NAME },
	DraeneiFemale            = { "achievement_character_draenei_female", "inv_offhand_draenei_a_01", DEFAULT_ICON_NAME },
	DraeneiMale              = { "achievement_character_draenei_male", "inv_mace_51", DEFAULT_ICON_NAME },
	DwarfFemale              = { "achievement_character_dwarf_female", "inv_misc_head_dwarf_02" },
	DwarfMale                = { "achievement_character_dwarf_male" },
	GnomeFemale              = { "achievement_character_gnome_female", "inv_misc_head_gnome_02" },
	GnomeMale                = { "achievement_character_gnome_male", "inv_misc_head_gnome_01" },
	GoblinFemale             = { "ability_racial_rocketjump", DEFAULT_ICON_NAME },
	GoblinMale               = { "ability_racial_rocketjump", DEFAULT_ICON_NAME },
	HighmountainTaurenFemale = { "achievement_alliedrace_highmountaintauren", DEFAULT_ICON_NAME },
	HighmountainTaurenMale   = { "ability_racial_bullrush", DEFAULT_ICON_NAME },
	HumanFemale              = { "achievement_character_human_female", "inv_misc_head_human_02" },
	HumanMale                = { "achievement_character_human_male", "ability_warrior_revenge" },
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
	NightElfMale             = { "achievement_character_nightelf_male", "ability_ambush" },
	OrcFemale                = { "achievement_character_orc_female", "inv_misc_head_orc_02" },
	OrcMale                  = { "achievement_character_orc_male", "ability_warrior_warcry" },
	PandarenFemale           = { "achievement_character_pandaren_female", DEFAULT_ICON_NAME },
	PandarenMale             = { "achievement_guild_classypanda", DEFAULT_ICON_NAME },
	ScourgeFemale            = { "achievement_character_undead_female", "inv_misc_head_undead_02" },
	ScourgeMale              = { "achievement_character_undead_male", "inv_misc_head_undead_01" },
	TaurenFemale             = { "achievement_character_tauren_female", "inv_misc_head_tauren_02" },
	TaurenMale               = { "achievement_character_tauren_male", "spell_holy_blessingofstamina" },
	TrollFemale              = { "achievement_character_troll_female", "inv_misc_head_troll_02" },
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

	MiscInfoHouse     = { "inv_misc_kingsring1", "inv_jewelry_ring_36" },
	MiscInfoNickname  = { "ability_hunter_beastcall" },
	MiscInfoMotto     = { "inv_inscription_scrollofwisdom_01", "inv_scroll_01" },
	MiscInfoTraits    = { "spell_shadow_mindsteal" },
	MiscInfoPiercings = { "inv_jewelry_ring_14" },
	MiscInfoPronouns  = { "vas_namechange", "inv_scroll_08" },
	MiscInfoTattoos   = { "inv_inscription_inkblack01", "inv_potion_65" },

	--
	-- Personality Trait Icons
	--

	TraitAltruistic    = { "inv_misc_gift_02" },
	TraitAscetic       = { "inv_misc_food_pinenut", "inv_misc_coin_05" },
	TraitBonVivant     = { "inv_misc_food_99", "inv_misc_coin_02" },
	TraitBrutal        = { "ability_warrior_trauma", "ability_rogue_eviscerate" },
	TraitCautious      = { "spell_shadow_brainwash", "inv_misc_pocketwatch_01" },
	TraitChaotic       = { "ability_rogue_wrongfullyaccused", "spell_shadow_unholyfrenzy" },
	TraitChaste        = { "inv_belt_27" },
	TraitDeceitful     = { "ability_rogue_disguise" },
	TraitForgiving     = { "inv_rosebouquet01" },
	TraitGentle        = { "inv_valentinescandysack" },
	TraitImpulsive     = { "achievement_bg_captureflag_eos", "spell_fire_incinerate" },
	TraitLoyal         = { "ability_paladin_sanctifiedwrath", "spell_holy_righteousfury" },
	TraitLustful       = { "spell_shadow_summonsuccubus" },
	TraitParagon       = { "inv_misc_groupneedmore", "achievement_guildperk_havegroup willtravel" },
	TraitRational      = { "inv_gizmo_02" },
	TraitRenegade      = { "ability_rogue_honoramongstthieves", "ability_rogue_dualweild" },
	TraitSelfish       = { "inv_misc_coin_02", "inv_ingot_03" },
	TraitSpineless     = { "ability_druid_cower" },
	TraitSuperstitious = { "spell_holy_holyguidance", "spell_holy_powerinfusion" },
	TraitTruthful      = { "inv_misc_toy_07", "spell_holy_auraoflight" },
	TraitValorous      = { "ability_paladin_beaconoflight", "ability_warrior_battleshout" },
	TraitVindictive    = { "ability_hunter_snipershot" },

	--
	-- Language Icons
	--

	LanguageCommon        = { "inv_misc_tournaments_banner_human", "spell_arcane_teleportstormwind" },
	LanguageDarnassian    = { "inv_misc_tournaments_banner_nightelf", "spell_arcane_teleportmoonglade" },
	LanguageDemonic       = { "artifactability_havocdemonhunter_anguishofthedeceiver", DEFAULT_ICON_NAME },
	LanguageDraconic      = { "ability_warrior_dragonroar", DEFAULT_ICON_NAME },
	LanguageDraenei       = { "inv_misc_tournaments_banner_draenei", "inv_wand_15", DEFAULT_ICON_NAME },
	LanguageDwarvish      = { "inv_misc_tournaments_banner_dwarf", "spell_arcane_teleportironforge" },
	LanguageForsaken      = { "inv_misc_tournaments_banner_scourge", "spell_arcane_teleportundercity" },
	LanguageGnomish       = { "inv_misc_tournaments_banner_gnome", "inv_misc_enggizmos_01" },
	LanguageGnomishBinary = { "inv_misc_punchcards_blue" },
	LanguageGoblin        = { "achievement_goblinhead", DEFAULT_ICON_NAME },
	LanguageGoblinBinary  = { "inv_misc_punchcards_blue" },
	LanguageKalimag       = { "shaman_talent_elementalblast", DEFAULT_ICON_NAME },
	LanguageMoonkin       = { "ability_druid_improvedmoonkinform", DEFAULT_ICON_NAME },
	LanguageNerglish      = { "inv_pet_babymurlocs_blue", DEFAULT_ICON_NAME },
	LanguageOrcish        = { "inv_misc_tournaments_banner_orc", "spell_arcane_teleportorgrimmar" },
	LanguagePandaren      = { "achievement_guild_classypanda", DEFAULT_ICON_NAME },
	LanguageShalassian    = { "achievement_alliedrace_nightborne", DEFAULT_ICON_NAME },
	LanguageShathYar      = { "spell_priest_voidform", DEFAULT_ICON_NAME },
	LanguageSprite        = { "inv_pet_sprite_darter_hatchling", DEFAULT_ICON_NAME },
	LanguageTaurahe       = { "inv_misc_tournaments_banner_tauren", "spell_arcane_teleportthunderbluff" },
	LanguageThalassian    = { "inv_misc_tournaments_banner_bloodelf", "inv_weapon_crossbow_26", DEFAULT_ICON_NAME },
	LanguageTitan         = { "achievement_dungeon_ulduarraid_titan_01", DEFAULT_ICON_NAME },
	LanguageVulpera       = { "inv_tabard_vulpera", DEFAULT_ICON_NAME },
	LanguageZandali       = { "inv_misc_tournaments_banner_troll", "inv_banner_01" },
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
			CallErrorHandler(string.format("Invalid interface icon %q: No valid texture file found", id));
		end

		TRP3_InterfaceIcons[id] = name or DEFAULT_ICON_NAME;
	end

	-- Legacy compatibility: A few icons are copied to the globals table.
	-- These usages have all been cleaned up internally, but might still be
	-- used by Extended & co.

	TRP3_API.globals.icons = {
		default = TRP3_InterfaceIcons.Default,
		unknown = TRP3_InterfaceIcons.Unknown,
		profile_default = TRP3_InterfaceIcons.ProfileDefault,
	};
end
