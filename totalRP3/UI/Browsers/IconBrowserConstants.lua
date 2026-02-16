-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;
local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

TRP3_IconBrowserConstants = {
	ClassCategories = {
		{ category = LRPM12.IconCategory.Warrior, name = L.CM_CLASS_WARRIOR, color = TRP3_API.ClassColors.WARRIOR },
		{ category = LRPM12.IconCategory.Paladin, name = L.CM_CLASS_PALADIN, color = TRP3_API.ClassColors.PALADIN },
		{ category = LRPM12.IconCategory.Hunter, name = L.CM_CLASS_HUNTER, color = TRP3_API.ClassColors.HUNTER },
		{ category = LRPM12.IconCategory.Rogue, name = L.CM_CLASS_ROGUE, color = TRP3_API.ClassColors.ROGUE },
		{ category = LRPM12.IconCategory.Priest, name = L.CM_CLASS_PRIEST, color = TRP3_API.ClassColors.PRIEST },
		{ category = LRPM12.IconCategory.DeathKnight, name = L.CM_CLASS_DEATHKNIGHT, color = TRP3_API.ClassColors.DEATHKNIGHT },
		{ category = LRPM12.IconCategory.Shaman, name = L.CM_CLASS_SHAMAN, color = TRP3_API.ClassColors.SHAMAN },
		{ category = LRPM12.IconCategory.Mage, name = L.CM_CLASS_MAGE, color = TRP3_API.ClassColors.MAGE },
		{ category = LRPM12.IconCategory.Warlock, name = L.CM_CLASS_WARLOCK, color = TRP3_API.ClassColors.WARLOCK },
		{ category = LRPM12.IconCategory.Monk, name = L.CM_CLASS_MONK, color = TRP3_API.ClassColors.MONK },
		{ category = LRPM12.IconCategory.Druid, name = L.CM_CLASS_DRUID, color = TRP3_API.ClassColors.DRUID },
		{ category = LRPM12.IconCategory.DemonHunter, name = L.CM_CLASS_DEMONHUNTER, color = TRP3_API.ClassColors.DEMONHUNTER },
		{ category = LRPM12.IconCategory.Evoker, name = L.CM_CLASS_EVOKER, color = TRP3_API.ClassColors.EVOKER },
	};

	CultureCategories = {
		{ category = LRPM12.IconCategory.Dracthyr, name = L.ICON_CATEGORY_DRACTHYR },
		{ category = LRPM12.IconCategory.Draenei, name = L.ICON_CATEGORY_DRAENEI },
		{ category = LRPM12.IconCategory.Dwarven, name = L.ICON_CATEGORY_DWARVEN },
		{ category = LRPM12.IconCategory.Elven, name = L.ICON_CATEGORY_ELVEN },
		{ category = LRPM12.IconCategory.Gnomish, name = L.ICON_CATEGORY_GNOMISH },
		{ category = LRPM12.IconCategory.Goblin, name = L.ICON_CATEGORY_GOBLIN },
		{ category = LRPM12.IconCategory.Haranir, name = L.ICON_CATEGORY_HARANIR },
		{ category = LRPM12.IconCategory.Human, name = L.ICON_CATEGORY_HUMAN },
		{ category = LRPM12.IconCategory.Orcish, name = L.ICON_CATEGORY_ORCISH },
		{ category = LRPM12.IconCategory.Pandaren, name = L.ICON_CATEGORY_PANDAREN },
		{ category = LRPM12.IconCategory.Tauren, name = L.ICON_CATEGORY_TAUREN },
		{ category = LRPM12.IconCategory.Troll, name = L.ICON_CATEGORY_TROLL },
		{ category = LRPM12.IconCategory.Undead, name = L.ICON_CATEGORY_UNDEAD },
		{ category = LRPM12.IconCategory.Vulpera, name = L.ICON_CATEGORY_VULPERA },
		{ category = LRPM12.IconCategory.Worgen, name = L.ICON_CATEGORY_WORGEN },
	};

	MeleeWeaponCategories = {
		{ category = LRPM12.IconCategory.WeaponTypeAxe, name = L.ICON_CATEGORY_AXE },
		{ category = LRPM12.IconCategory.WeaponTypeDagger, name = L.ICON_CATEGORY_DAGGER },
		{ category = LRPM12.IconCategory.WeaponTypeFists, name = L.ICON_CATEGORY_FIST_WEAPON },
		{ category = LRPM12.IconCategory.WeaponTypeMace, name = L.ICON_CATEGORY_MACE },
		{ category = LRPM12.IconCategory.WeaponTypePolearm, name = L.ICON_CATEGORY_POLEARM },
		{ category = LRPM12.IconCategory.WeaponTypeStaff, name = L.ICON_CATEGORY_STAFF },
		{ category = LRPM12.IconCategory.WeaponTypeSword, name = L.ICON_CATEGORY_SWORD },
		{ category = LRPM12.IconCategory.WeaponTypeWand, name = L.ICON_CATEGORY_WAND },
		{ category = LRPM12.IconCategory.WeaponTypeWarglaive, name = L.ICON_CATEGORY_WARGLAIVE },
	};

	RangedWeaponCategories = {
		{ category = LRPM12.IconCategory.WeaponTypeAmmo, name = L.ICON_CATEGORY_AMMO },
		{ category = LRPM12.IconCategory.WeaponTypeBow, name = L.ICON_CATEGORY_BOW },
		{ category = LRPM12.IconCategory.WeaponTypeCrossbow, name = L.ICON_CATEGORY_CROSSBOW },
		{ category = LRPM12.IconCategory.WeaponTypeGun, name = L.ICON_CATEGORY_GUN },
		{ category = LRPM12.IconCategory.WeaponTypeThrown, name = L.ICON_CATEGORY_THROWN },
	};

	ArmorTypeCategories = {
		{ category = LRPM12.IconCategory.ClothArmor, name = L.ICON_CATEGORY_CLOTH_ARMOR, sortIndex = 1 },
		{ category = LRPM12.IconCategory.LeatherArmor, name = L.ICON_CATEGORY_LEATHER_ARMOR, sortIndex = 2 },
		{ category = LRPM12.IconCategory.MailArmor, name = L.ICON_CATEGORY_MAIL_ARMOR, sortIndex = 3 },
		{ category = LRPM12.IconCategory.PlateArmor, name = L.ICON_CATEGORY_PLATE_ARMOR, sortIndex = 4 },
		{ category = LRPM12.IconCategory.Jewelry, name = L.ICON_CATEGORY_JEWELRY, sortIndex = 5 },
	};

	InventorySlotCategories = {
		{ category = LRPM12.IconCategory.InventorySlotHead, name = L.ICON_CATEGORY_HEAD, sortIndex = 1 },
		{ category = LRPM12.IconCategory.InventorySlotNeck, name = L.ICON_CATEGORY_NECK, sortIndex = 2 },
		{ category = LRPM12.IconCategory.InventorySlotShoulders, name = L.ICON_CATEGORY_SHOULDERS, sortIndex = 3 },
		{ category = LRPM12.IconCategory.InventorySlotBack, name = L.ICON_CATEGORY_BACK, sortIndex = 4 },
		{ category = LRPM12.IconCategory.InventorySlotChest, name = L.ICON_CATEGORY_CHEST, sortIndex = 5 },
		{ category = LRPM12.IconCategory.InventorySlotShirt, name = L.ICON_CATEGORY_SHIRT, sortIndex = 6 },
		{ category = LRPM12.IconCategory.InventorySlotTabard, name = L.ICON_CATEGORY_TABARD, sortIndex = 7 },
		{ category = LRPM12.IconCategory.InventorySlotWrists, name = L.ICON_CATEGORY_WRISTS, sortIndex = 8 },
		{ category = LRPM12.IconCategory.InventorySlotHands, name = L.ICON_CATEGORY_HANDS, sortIndex = 9 },
		{ category = LRPM12.IconCategory.InventorySlotWaist, name = L.ICON_CATEGORY_WAIST, sortIndex = 10 },
		{ category = LRPM12.IconCategory.InventorySlotLegs, name = L.ICON_CATEGORY_LEGS, sortIndex = 11 },
		{ category = LRPM12.IconCategory.InventorySlotFeet, name = L.ICON_CATEGORY_FEET, sortIndex = 12 },
		{ category = LRPM12.IconCategory.InventorySlotRing, name = L.ICON_CATEGORY_RING, sortIndex = 13 },
		{ category = LRPM12.IconCategory.InventorySlotTrinket, name = L.ICON_CATEGORY_TRINKET, sortIndex = 14 },
		{ category = LRPM12.IconCategory.InventorySlotOffHand, name = L.ICON_CATEGORY_OFF_HAND, sortIndex = 15 },
		{ category = LRPM12.IconCategory.InventorySlotShield, name = L.ICON_CATEGORY_SHIELD, sortIndex = 16 },
	};

	MagicCategories = {
		{ category = LRPM12.IconCategory.ArcaneMagic, name = L.ICON_CATEGORY_ARCANE },
		{ category = LRPM12.IconCategory.FelMagic, name = L.ICON_CATEGORY_FEL },
		{ category = LRPM12.IconCategory.FireMagic, name = L.ICON_CATEGORY_FIRE },
		{ category = LRPM12.IconCategory.FrostMagic, name = L.ICON_CATEGORY_FROST },
		{ category = LRPM12.IconCategory.HolyMagic, name = L.ICON_CATEGORY_HOLY },
		{ category = LRPM12.IconCategory.NatureMagic, name = L.ICON_CATEGORY_NATURE },
		{ category = LRPM12.IconCategory.ShadowMagic, name = L.ICON_CATEGORY_SHADOW },
		{ category = LRPM12.IconCategory.VoidMagic, name = L.ICON_CATEGORY_VOID },
	};

	FactionCategories = {
		{ category = LRPM12.IconCategory.Alliance, name = L.ICON_CATEGORY_ALLIANCE, sortIndex = 1 };
		{ category = LRPM12.IconCategory.Horde, name = L.ICON_CATEGORY_HORDE, sortIndex = 2 };
		{ category = LRPM12.IconCategory.OtherFactions, name = L.ICON_CATEGORY_OTHER_FACTIONS, sortIndex = 3 };
	};

	ProfessionCategories = {
		{ category = LRPM12.IconCategory.Alchemy, name = L.ICON_CATEGORY_ALCHEMY },
		{ category = LRPM12.IconCategory.Archaeology, name = L.ICON_CATEGORY_ARCHAEOLOGY },
		{ category = LRPM12.IconCategory.Blacksmithing, name = L.ICON_CATEGORY_BLACKSMITHING },
		{ category = LRPM12.IconCategory.Cooking, name = L.ICON_CATEGORY_COOKING },
		{ category = LRPM12.IconCategory.Enchanting, name = L.ICON_CATEGORY_ENCHANTING },
		{ category = LRPM12.IconCategory.Engineering, name = L.ICON_CATEGORY_ENGINEERING },
		{ category = LRPM12.IconCategory.FirstAid, name = L.ICON_CATEGORY_FIRST_AID },
		{ category = LRPM12.IconCategory.Fishing, name = L.ICON_CATEGORY_FISHING },
		{ category = LRPM12.IconCategory.Herbalism, name = L.ICON_CATEGORY_HERBALISM },
		{ category = LRPM12.IconCategory.Inscription, name = L.ICON_CATEGORY_INSCRIPTION },
		{ category = LRPM12.IconCategory.Jewelcrafting, name = L.ICON_CATEGORY_JEWELCRAFTING },
		{ category = LRPM12.IconCategory.Leatherworking, name = L.ICON_CATEGORY_LEATHERWORKING },
		{ category = LRPM12.IconCategory.Mining, name = L.ICON_CATEGORY_MINING },
		{ category = LRPM12.IconCategory.Skinning, name = L.ICON_CATEGORY_SKINNING },
		{ category = LRPM12.IconCategory.Tailoring, name = L.ICON_CATEGORY_TAILORING },
	};

	ItemCategories = {
		{ category = LRPM12.IconCategory.Drink, name = L.ICON_CATEGORY_DRINK },
		{ category = LRPM12.IconCategory.Food, name = L.ICON_CATEGORY_FOOD },
		{ category = LRPM12.IconCategory.Mount, name = L.ICON_CATEGORY_MOUNT },
		{ category = LRPM12.IconCategory.Pet, name = L.ICON_CATEGORY_PET },
		{ category = LRPM12.IconCategory.Potion, name = L.ICON_CATEGORY_POTION },
		{ category = LRPM12.IconCategory.TradeGoods, name = L.ICON_CATEGORY_TRADE_GOODS },
	};
};
