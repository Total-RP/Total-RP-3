--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Global variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_ADDON_NAME = "Total RP 3";
TRP3_ADDON_NAME_SHORT = "TRP3";
TRP3_ADDON_NAME_ALT = "TotalRP3";
TRP3_ID_LENGTH = 15;
TRP3_VERSION = 0.1;
TRP3_VERSION_USER = "0.1-SNAPSHOT";
TRP3_PLAYER = UnitName("player");
TRP3_REALM = GetRealmName();
TRP3_USER_ID = TRP3_REALM..'|'..TRP3_PLAYER;
TRP3_RACE_LOC, TRP3_RACE = UnitRace("player");
TRP3_CLASS_LOC, TRP3_CLASS, TRP3_CLASS_I = UnitClass("player");

-- ICONS
TRP3_ICON_EDIT = "INV_Feather_11";
TRP3_ICON_SAVE = "INV_Feather_12";
TRP3_ICON_CANCEL = "INV_Feather_10";
TRP3_ICON_DEFAULT = "TEMP";
TRP3_ICON_PROFILE_DEFAULT = "INV_Misc_GroupLooking";
TRP3_ICON_ADD = "Spell_ChargePositive";