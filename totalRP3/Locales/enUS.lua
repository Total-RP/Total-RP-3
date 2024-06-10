-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L;

L = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- GENERAL
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	GEN_WELCOME_MESSAGE = "Thank you for using Total RP 3 (v %s)! Have fun!",
	GEN_VERSION = "Version: %s (Build %s)",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- REGISTER
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	REG_PLAYER = "Character",
	REG_PLAYER_CHANGE_CONFIRM = "You may have unsaved data changes.\nDo you want to change page anyway?\n|cffff9900Any changes will be lost.",
	REG_PLAYER_CARACT = "Characteristics",
	REG_PLAYER_NAMESTITLES = "Names and titles",
	REG_PLAYER_CHARACTERISTICS = "Characteristics",
	REG_PLAYER_REGISTER = "Directory Information",
	REG_PLAYER_ICON = "Character's icon",
	REG_PLAYER_ICON_TT = "Select a graphic representation for your character.",
	REG_PLAYER_TITLE = "Title",
	REG_PLAYER_TITLE_TT = "Your character's title is the title by which your character is usually called. Avoid long titles, as for those you should use the Full title attribute below.\n\nExample of |c0000ff00appropriate titles|r:\n|c0000ff00- Countess,\n- Marquis,\n- Magus,\n- Lord,\n- etc.\n|rExample of |cffff0000inappropriate titles|r:\n|cffff0000- Countess of the North Marshes,\n- Magus of the Stormwind Tower,\n- Diplomat for the Draenei Government,\n- etc.",
	REG_PLAYER_FIRSTNAME = "First name",
	REG_PLAYER_FIRSTNAME_TT = "This is your character's first name. This is a mandatory field, so if you don't specify a name, the default character's name (|cffffff00%s|r) will be used.\n\nYou can use a |c0000ff00nickname|r!",
	REG_PLAYER_LASTNAME = "Last name",
	REG_PLAYER_LASTNAME_TT = "This is your character's family name.",
	REG_PLAYER_HERE = "Set position",
	REG_PLAYER_HERE_TT = "|cffffff00Click|r: Set to your current position",
	REG_PLAYER_HERE_HOME_TT = "|cffffff00Click|r: Use your current coordinates as your house position.\n|cffffff00Right-click|r: Discard your house position.",
	REG_PLAYER_HERE_HOME_PRE_TT = "Current house map coordinates:\n|cff00ff00%s|r.",
	REG_PLAYER_RESIDENCE_SHOW = "Residence coordinates",
	REG_PLAYER_RESIDENCE_SHOW_TT = "|cff00ff00%s\n\n|rClick to show on map",
	REG_PLAYER_COLOR_CLASS = "Class color",
	REG_PLAYER_COLOR_CLASS_TT = "This will also determine the name color.\n\n",
	REG_PLAYER_COLOR_TT = "|cffffff00Click:|r Select a color\n|cffffff00Right-click:|r Discard color\n|cffffff00Shift-Click:|r Use the default color picker",
	REG_PLAYER_COLOR_ALWAYS_DEFAULT_TT = "|cffffff00Click:|r Select a color\n|cffffff00Right-click:|r Discard color",
	REG_PLAYER_FULLTITLE = "Full title",
	REG_PLAYER_FULLTITLE_TT = "Here you can write down your character's full title. It can either be a longer version of the Title or another title entirely.\n\nHowever, you may want to avoid repetitions, in case there's no additional info to mention.",
	REG_PLAYER_RACE = "Race",
	REG_PLAYER_RACE_TT = "Here goes your character's race. It doesn't have to be restricted to playable races. There are many Warcraft races that can assume common shapes...",
	REG_PLAYER_BKG = "Background layout",
	REG_PLAYER_BKG_TT = "This represents the graphical background to use for your Characteristics layout.",
	REG_PLAYER_CLASS = "Class",
	REG_PLAYER_CLASS_TT = "This is your character's custom class.\n\n|cff00ff00For instance :|r\nKnight, Pyrotechnist, Necromancer, Elite shooter, Arcanist...",
	REG_PLAYER_AGE = "Age",
	REG_PLAYER_AGE_TT = "Here you can indicate how old your character is.\n\nThere are several ways to do this:|c0000ff00\n- Either use years,\n- Or an adjective (Young, Mature, Adult, Venerable, etc.).",
	REG_PLAYER_EYE = "Eye color",
	REG_PLAYER_EYE_TT = "Here you can indicate the color of your character's eyes.\n\nKeep in mind that, even if your character's face is constantly hidden, that might still be worth mentioning, just in case.",
	REG_PLAYER_HEIGHT = "Height",
	REG_PLAYER_HEIGHT_TT = "This is your character's height.\nThere are several ways to do this:|c0000ff00\n- A precise number: 170 cm, 6'5\"...\n- A qualificative: Tall, short...",
	REG_PLAYER_WEIGHT = "Body shape",
	REG_PLAYER_WEIGHT_TT = "This is your character's body shape.\nFor instance they could be |c0000ff00slim, fat or muscular...|r Or they could simply be regular!",
	REG_PLAYER_BIRTHPLACE = "Birthplace",
	REG_PLAYER_BIRTHPLACE_TT = "Here you can indicate the birthplace of your character. This can either be a region, a zone, or even a continent. It's for you to decide how accurate you want to be.\n\n|c00ffff00You can use the button to the right to easily set your current location as Birthplace.",
	REG_PLAYER_RESIDENCE = "Residence",
	REG_PLAYER_RESIDENCE_TT = "Here you can indicate where your character normally lives. This could be their personal address (their home) or a place they can crash.\nNote that if your character is a wanderer or even homeless, you will need to change the information accordingly.\n\n|c00ffff00You can use the button to the right to easily set your current location as Residence.",
	REG_PLAYER_MSP_MOTTO = "Motto",
	REG_PLAYER_MSP_HOUSE = "House name",
	REG_PLAYER_MSP_NICK = "Nickname",
	REG_PLAYER_TRP2_TRAITS = "Facial features",
	REG_PLAYER_TRP2_PIERCING = "Piercings",
	REG_PLAYER_TRP2_TATTOO = "Tattoos",
	REG_PLAYER_PSYCHO = "Personality Traits",
	REG_PLAYER_ADD_NEW = "Create new",
	REG_PLAYER_HISTORY = "History",
	REG_PLAYER_MORE_INFO = "Additional Information",
	REG_PLAYER_PHYSICAL = "Physical Description",
	REG_PLAYER_NO_CHAR = "No characteristics",
	REG_PLAYER_SHOWPSYCHO = "Show personality frame",
	REG_PLAYER_SHOWPSYCHO_TT = "Check if you want to use the personality description.\n\nIf you don't want to indicate your character's personality this way, keep this box unchecked and the personality frame will remain totally hidden.",
	REG_PLAYER_PSYCHO_ADD = "Add a personality trait",
	REG_PLAYER_PSYCHO_POINT = "Add a point",
	REG_PLAYER_PSYCHO_MORE = "Add a point to \"%s\"",
	REG_PLAYER_PSYCHO_ATTIBUTENAME_TT = "Attribute name",
	REG_PLAYER_PSYCHO_RIGHTICON_TT = "Set the right attribute icon.",
	REG_PLAYER_PSYCHO_LEFTICON_TT = "Set the left attribute icon.",
	REG_PLAYER_PSYCHO_SOCIAL = "Social traits",
	REG_PLAYER_PSYCHO_PERSONAL = "Personal traits",
	REG_PLAYER_PSYCHO_CHAOTIC = "Chaotic";
	REG_PLAYER_PSYCHO_Loyal = "Lawful";
	REG_PLAYER_PSYCHO_Chaste = "Chaste";
	REG_PLAYER_PSYCHO_Luxurieux = "Lustful";
	REG_PLAYER_PSYCHO_Indulgent = "Forgiving";
	REG_PLAYER_PSYCHO_Rencunier = "Vindictive";
	REG_PLAYER_PSYCHO_Genereux = "Altruistic";
	REG_PLAYER_PSYCHO_Egoiste = "Selfish";
	REG_PLAYER_PSYCHO_Sincere = "Truthful";
	REG_PLAYER_PSYCHO_Trompeur = "Deceitful";
	REG_PLAYER_PSYCHO_Misericordieux = "Gentle";
	REG_PLAYER_PSYCHO_Cruel = "Brutal";
	REG_PLAYER_PSYCHO_Pieux = "Superstitious";
	REG_PLAYER_PSYCHO_Pragmatique = "Renegade";
	REG_PLAYER_PSYCHO_Conciliant = "Paragon";
	REG_PLAYER_PSYCHO_Rationnel = "Rational";
	REG_PLAYER_PSYCHO_Reflechi = "Cautious";
	REG_PLAYER_PSYCHO_Impulsif = "Impulsive";
	REG_PLAYER_PSYCHO_Acete = "Ascetic";
	REG_PLAYER_PSYCHO_Bonvivant = "Bon vivant";
	REG_PLAYER_PSYCHO_Valeureux = "Valorous";
	REG_PLAYER_PSYCHO_Couard = "Spineless";
	REG_PLAYER_PSYCHO_CUSTOM = "Custom trait",
	REG_PLAYER_PSYCHO_CREATENEW = "Create a trait",
	REG_PLAYER_PSYCHO_CUSTOMCOLOR = "Select attribute color",
	REG_PLAYER_PSYCHO_CUSTOMCOLOR_LEFT_TT = "Select a color used by the bar for the left attribute.\n\n|cffffff00Click:|r Select a color\n|cffffff00Right-click:|r Discard color\n|cffffff00Shift-Click:|r Use the default color picker",
	REG_PLAYER_PSYCHO_CUSTOMCOLOR_RIGHT_TT = "Select a color used by the bar for the right attribute.\n\n|cffffff00Click:|r Select a color\n|cffffff00Right-click:|r Discard color\n|cffffff00Shift-Click:|r Use the default color picker",
	REG_PLAYER_LEFTTRAIT = "Left attribute",
	REG_PLAYER_RIGHTTRAIT = "Right attribute",
	REG_DELETE_WARNING = "Are you sure you want to delete %s's profile?\n",
	REG_IGNORE_TOAST = "Character ignored",
	REG_PLAYER_IGNORE = "Ignore linked characters (%s)",
	REG_PLAYER_IGNORE_WARNING = "Do you want to ignore those characters?\n\n|cffff9900%s\n\n|rYou can optionally enter the reason below. This is a personal note that will serve as reminder.",
	REG_PLAYER_SHOWMISC = "Show miscellaneous frame",
	REG_PLAYER_SHOWMISC_TT = "Check if you want to show custom fields for your character.\n\nIf you don't want to show custom fields, keep this box unchecked and the miscellaneous frame will remain totally hidden.",
	REG_PLAYER_MISC_ADD = "Add an additional field",
	REG_PLAYER_ABOUT = "About",
	REG_PLAYER_ABOUTS = "About %s",
	REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900No theme",
	REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900Unknown theme",
	REG_PLAYER_ABOUT_MUSIC_SELECT = "Select character theme",
	REG_PLAYER_ABOUT_MUSIC_REMOVE = "Unselect theme",
	REG_PLAYER_ABOUT_MUSIC_LISTEN = "Play theme",
	REG_PLAYER_ABOUT_MUSIC_STOP = "Stop theme",
	REG_PLAYER_ABOUT_MUSIC_SELECT2 = "Select theme",
	REG_PLAYER_ABOUT_T1_YOURTEXT = "Your text here",
	REG_PLAYER_ABOUT_HEADER = "Title tag",
	REG_PLAYER_ABOUT_ADD_FRAME = "Add a frame",
	REG_PLAYER_ABOUT_REMOVE_FRAME = "Remove this frame",
	REG_PLAYER_ABOUT_P = "Paragraph tag",
	REG_PLAYER_ABOUT_TAGS = "Formatting tools",
	REG_PLAYER_ABOUT_SOME = "Some text...",
	REG_PLAYER_ABOUT_EMPTY = "No description",
	REG_PLAYER_STYLE_RPSTYLE_SHORT = "RP style",
	REG_PLAYER_STYLE_RPSTYLE = "Roleplay style",
	REG_PLAYER_STYLE_HIDE = "Do not show",
	REG_PLAYER_STYLE_WOWXP = "World of Warcraft experience",
	REG_PLAYER_STYLE_FREQ = "In-character frequence",
	REG_PLAYER_STYLE_FREQ_1 = "Full-time, no OOC",
	REG_PLAYER_STYLE_FREQ_2 = "Most of the time",
	REG_PLAYER_STYLE_FREQ_3 = "Mid-time",
	REG_PLAYER_STYLE_FREQ_4 = "Casual",
	REG_PLAYER_STYLE_FREQ_5 = "Full-time OOC, not a RP character",
	REG_PLAYER_STYLE_PERMI = "With player permission",
	REG_PLAYER_STYLE_ASSIST = "Roleplay assistance",
	REG_PLAYER_STYLE_INJURY = "Accept character injury",
	REG_PLAYER_STYLE_DEATH = "Accept character death",
	REG_PLAYER_STYLE_ROMANCE = "Accept character romance",
	REG_PLAYER_STYLE_BATTLE = "Roleplay battle resolution",
	REG_PLAYER_STYLE_BATTLE_1 = "World of Warcraft PvP",
	REG_PLAYER_STYLE_BATTLE_2 = "TRP roll battle",
	REG_PLAYER_STYLE_BATTLE_3 = "/roll battle",
	REG_PLAYER_STYLE_BATTLE_4 = "Emote battle",
	REG_PLAYER_STYLE_EMPTY = "No roleplay attribute shared",
	REG_PLAYER_STYLE_GUILD = "Guild membership",
	REG_PLAYER_STYLE_GUILD_IC = "IC membership",
	REG_PLAYER_STYLE_GUILD_OOC = "OOC membership",
	REG_PLAYER_ALERT_HEAVY_SMALL = "|cffff0000The total size of your profile is quite big.\n|cffff9900You should reduce it.",
	CO_GENERAL_HEAVY = "Heavy profile alert",
	CO_GENERAL_HEAVY_TT = "Get an alert when your profile total size exceed a reasonable value.",
	REG_PLAYER_PEEK = "Miscellaneous",
	REG_PLAYER_CURRENT = "Currently",
	REG_PLAYER_CURRENTOOC = "Currently (OOC)",
	REG_PLAYER_CURRENT_OOC = "This is OOC information";
	REG_PLAYER_GLANCE = "At first glance",
	REG_PLAYER_GLANCE_USE = "Activate this slot",
	REG_PLAYER_GLANCE_TITLE = "Attribute name",
	REG_PLAYER_GLANCE_UNUSED = "Unused slot",
	REG_PLAYER_GLANCE_CONFIG = "|cff00ff00\"At first glance\"|r is a set of slots you can use to define important information about this character.\n\nYou can use these actions on the slots:\n|cffffff00Click:|r configure slot\n|cffffff00Double-click:|r toggle slot activation\n|cffffff00Right-click:|r slot presets\n|cffffff00Drag & drop:|r reorder slots",
	REG_PLAYER_GLANCE_EDITOR = "Glance editor: Slot %s",
	REG_PLAYER_GLANCE_BAR_TARGET = "\"At first glance\" presets",
	REG_PLAYER_GLANCE_BAR_LOAD_SAVE = "Group presets",
	REG_PLAYER_GLANCE_BAR_SAVE = "Save group as a preset",
	REG_PLAYER_GLANCE_BAR_LOAD = "Group preset",
	REG_PLAYER_GLANCE_BAR_EMPTY = "The preset name can't be empty.",
	REG_PLAYER_GLANCE_BAR_NAME = "Please enter the preset name.\n\n|cff00ff00Note: If the name is already used by another group preset, this other group will be replaced.",
	REG_PLAYER_GLANCE_BAR_SAVED = "Group preset |cff00ff00%s|r has been created.",
	REG_PLAYER_GLANCE_BAR_DELETED = "Group preset |cffff9900%s|r deleted.",
	REG_PLAYER_GLANCE_PRESET = "Load a preset",
	REG_PLAYER_GLANCE_PRESET_SELECT = "Select a preset",
	REG_PLAYER_GLANCE_PRESET_SAVE = "Save information as a preset",
	REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Save as a preset",
	REG_PLAYER_GLANCE_PRESET_CATEGORY = "Preset category",
	REG_PLAYER_GLANCE_PRESET_NAME = "Preset name",
	REG_PLAYER_GLANCE_PRESET_CREATE = "Create preset",
	REG_PLAYER_GLANCE_PRESET_REMOVE = "Removed preset |cff00ff00%s|r.";
	REG_PLAYER_GLANCE_PRESET_ADD = "Created preset |cff00ff00%s|r.";
	REG_PLAYER_GLANCE_PRESET_ALERT1 = "You must enter a preset category.",
	REG_PLAYER_GLANCE_PRESET_GET_CAT = "%s\n\nPlease enter the category name for this preset.",
	REG_PLAYER_GLANCE_MENU_COPY = "Copy slot",
	REG_PLAYER_GLANCE_MENU_PASTE = "Paste slot: %s",
	REG_PLAYER_TUTO_ABOUT_COMMON = [[|cff00ff00Character theme:|r
You can choose a |cffffff00theme|r for your character. Think of it as an |cffffff00ambiance music for reading your character description|r.

|cff00ff00Background:|r
This is a |cffffff00background texture|r for your character description.

|cff00ff00Template:|r
The chosen template defines |cffffff00the general layout and writing possibilities|r for your description.
|cffff9900Only the selected template is visible by others, so you don't have to fill them all.|r
Once a template is selected, you can open this tutorial again to have more help about each template.]],
	REG_PLAYER_TUTO_ABOUT_T1 = [[This template allows you to |cff00ff00freely structure your description|r.

The description doesn't have to be limited to your character's |cffff9900physical description|r. Feel free to indicate parts from their |cffff9900background|r or details about their |cffff9900personality|r.

With this template you can use the formatting tools to access several layout parameters like |cffffff00text sizes, colors, and alignments|r.
These tools also allow you to insert |cffffff00images, icons, or links to external web sites|r.]],
	REG_PLAYER_TUTO_ABOUT_T2 = [[This template is more structured and consists of |cff00ff00a list of independent frames|r.

Each frame is caracterized by an |cffffff00icon, a background and a text|r. Note that you can use some text tags in these frames, like the color and the icon text tags.

The description doesn't have to be limited to your character's |cffff9900physical description|r. Feel free to indicate parts from their |cffff9900background|r or details about their |cffff9900personality|r.]],
	REG_PLAYER_TUTO_ABOUT_T3 = [[This template is cut in 3 sections: |cff00ff00Physical description, personality and history|r.

You don't have to fill all the frames, |cffff9900if you leave an empty frame it won't be shown on your description|r.

Each frame is caracterized by an |cffffff00icon, a background and a text|r. Note that you can use some text tags in these frames, like the color and the icon text tags.]],
	REG_PLAYER_TUTO_ABOUT_MISC_1 = [[This section provides you |cffffff005 slots|r with which you can describe |cff00ff00the most important pieces of information about your character|r.

These slots will be visible on the |cffffff00"At first glance bar"|r when someone selects your character.

|cff00ff00Hint: You can drag & drop slots to reorder them.|r
It also works on the |cffffff00"At first glance" bar|r!]],
	REG_PLAYER_TUTO_ABOUT_MISC_3 = [[This section contains |cffffff00a list of flags|r to answer a lot of |cffffff00common questions people could ask about you, your character and the way you want to play him/her|r.]],
	REG_RELATION = "Relationship",
	REG_RELATION_BUTTON_TT = "Relation: %s\n|cff00ff00%s\n\n|cffffff00Click to display possible actions",
	REG_RELATION_UNFRIENDLY = "Unfriendly",
	REG_RELATION_NONE = "None",
	REG_RELATION_NEUTRAL = "Neutral",
	REG_RELATION_BUSINESS = "Business",
	REG_RELATION_FRIEND = "Friendly",
	REG_RELATION_LOVE = "Love",
	REG_RELATION_FAMILY = "Family",
	REG_RELATION_UNFRIENDLY_TT = "%s clearly doesn't like %s.",
	REG_RELATION_NONE_TT = "%s doesn't know %s.",
	REG_RELATION_NEUTRAL_TT = "%s doesn't feel anything particular toward %s.",
	REG_RELATION_BUSINESS_TT = "%s and %s are in a business relationship.",
	REG_RELATION_FRIEND_TT = "%s considers %s a friend.",
	REG_RELATION_LOVE_TT = "%s is in love with %s!",
	REG_RELATION_FAMILY_TT = "%s shares blood ties with %s.",
	REG_RELATION_TARGET = "|cffffff00Click:|r Change relation",
	REG_TIME = "Time last seen",
	REG_REGISTER = "Directory",
	REG_REGISTER_CHAR_LIST = "Characters list",
	REG_TRIAL_ACCOUNT = "Trial Account",
	REG_TT_GUILD_IC = "IC member",
	REG_TT_GUILD_OOC = "OOC member",
	REG_TT_LEVEL = "Level %s %s",
	REG_TT_REALM = "Realm: |cffff9900%s",
	REG_TT_GUILD = "%s of |cffff9900%s",
	REG_TT_TARGET = "Target: |cffff9900%s",
	REG_TT_ZONE = "Zone",
	REG_TT_NOTIF = "Unread description",
	REG_TT_IGNORED = "< Character is ignored >",
	REG_TT_IGNORED_OWNER = "< Owner is ignored >",
	REG_LIST_CHAR_TITLE = "Character list",
	REG_LIST_CHAR_SEL = "Selected character",
	REG_LIST_CHAR_TT = "Click to show page",
	REG_LIST_CHAR_TT_RELATION = "Relation:\n|cff00ff00%s",
	REG_LIST_CHAR_TT_CHAR = "Linked WoW character(s):",
	REG_LIST_CHAR_TT_CHAR_NO = "Not linked to any character",
	REG_LIST_CHAR_TT_DATE = "Last seen date: |cff00ff00%s|r\nLast seen location: |cff00ff00%s|r",
	REG_LIST_CHAR_TT_GLANCE = "At first glance",
	REG_LIST_CHAR_TT_NEW_ABOUT = "Unread description",
	REG_LIST_CHAR_TT_IGNORE = "Ignored character(s)",
	REG_LIST_CHAR_FILTER = "Characters: %s/%s",
	REG_LIST_CHAR_EMPTY = "No character",
	REG_LIST_CHAR_EMPTY2 = "No character matches your selection",
	REG_LIST_CHAR_IGNORED = "Ignored",
	REG_LIST_CHAR_NAME_COPY = "Copy character name",
	REG_LIST_IGNORE_TITLE = "Ignored list",
	REG_LIST_IGNORE_EMPTY = "No ignored character",
	REG_LIST_IGNORE_TT = "Reason:\n|cff00ff00%s\n\n|cffffff00Click to remove from ignore list",
	REG_LIST_PETS_FILTER = "Companions: %s/%s",
	REG_LIST_PETS_TITLE = "Companion list",
	REG_LIST_PETS_EMPTY = "No companion",
	REG_LIST_PETS_EMPTY2 = "No companion matches your selection",
	REG_LIST_PETS_TOOLTIP = "Has been seen on",
	REG_LIST_PETS_TOOLTIP2 = "Has been seen with",
	REG_LIST_PET_NAME = "Companion's name",
	REG_LIST_PET_TYPE = "Companion's type",
	REG_LIST_PET_MASTER = "Master's name",
	REG_LIST_FILTERS = "Filters",
	REG_LIST_FILTERS_TT = "|cffffff00Click:|r Apply filters\n|cffffff00Right-Click:|r Clear filters",
	REG_LIST_REALMONLY = "This realm only",
	REG_LIST_NOTESONLY = "Has notes only",
	REG_LIST_GUILD = "Character's guild",
	REG_LIST_NAME = "Character's name",
	REG_LIST_FLAGS = "Flags",
	REG_LIST_ADDON = "Profile type",
	REG_LIST_ACTIONS_PURGE = "Purge register",
	REG_LIST_ACTIONS_PURGE_ALL = "Remove all profiles",
	REG_LIST_ACTIONS_PURGE_ALL_COMP_C = "This purge will remove all companions from the directory.\n\n|cff00ff00%s companions.",
	REG_LIST_ACTIONS_PURGE_ALL_C = "This purge will remove all profiles and linked characters from the directory.\n\n|cff00ff00%s characters.",
	REG_LIST_ACTIONS_PURGE_TIME = "Profiles not seen for 1 month",
	REG_LIST_ACTIONS_PURGE_TIME_C = "This purge will remove all profiles that have not been seen for a month.\n\n|cff00ff00%s",
	REG_LIST_ACTIONS_PURGE_UNLINKED = "Profiles not linked to a character",
	REG_LIST_ACTIONS_PURGE_UNLINKED_C = "This purge will remove all profiles that are not linked to a WoW character.\n\n|cff00ff00%s",
	REG_LIST_ACTIONS_PURGE_IGNORE = "Profiles from ignored characters",
	REG_LIST_ACTIONS_PURGE_IGNORE_C = "This purge will remove all profiles linked to an ignored WoW character.\n\n|cff00ff00%s",
	REG_LIST_ACTIONS_PURGE_EMPTY = "No profile to purge.",
	REG_LIST_ACTIONS_PURGE_COUNT = "%s profiles will be removed.",
	REG_LIST_ACTIONS_MASS = "Action on %s selected profiles",
	REG_LIST_ACTIONS_MASS_REMOVE = "Remove profiles",
	REG_LIST_ACTIONS_MASS_REMOVE_C = "This action will remove |cff00ff00%s selected profile(s)|r.",
	REG_LIST_ACTIONS_MASS_IGNORE = "Ignore profiles",
	REG_LIST_ACTIONS_MASS_IGNORE_C = [[This action will add |cff00ff00%s character(s)|r to the ignore list.

You can optionally enter the reason below. This is a personal note, it will serve as a reminder.]],
	REG_LIST_CHAR_TUTO_ACTIONS = "This column allows you to select multiple characters and perform an action on all of them.",
	REG_LIST_CHAR_TUTO_LIST = [[The first column shows the character's name.

The second column shows the relation between these characters and your current character.

The last column is for various flags. (ignored ..etc.)]],
	REG_LIST_CHAR_TUTO_FILTER = [[You can filter the character list.

The |cff00ff00name filter|r will perform a search on the profile full name (first name + last name) but also on any linked WoW characters.

The |cff00ff00guild filter|r will search on guild name from linked WoW characters.

The |cff00ff00realm only filter|r will show only profiles linked to a WoW character of your current realm.]],
	REG_LIST_NOTIF_ADD = "New profile discovered for |cff00ff00%s",
	REG_LIST_NOTIF_ADD_CONFIG = "New profile discovered",
	REG_LIST_NOTIF_ADD_NOT = "This profile doesn't exist anymore.",
	REG_COMPANION_LINKED = "The companion %s is now linked to the profile %s.",
	REG_COMPANION = "Companion",
	REG_COMPANIONS = "Companions",
	REG_COMPANION_BOUNDS = "Links",
	REG_COMPANION_TARGET_NO = "Your target is not a valid pet, minion, ghoul, mage elemental or a renamed battle pet.",
	REG_COMPANION_BOUND_TO = "Link to...",
	REG_COMPANION_UNBOUND = "Unlink from...",
	REG_COMPANION_LINKED_NO = "The companion %s is no longer linked to any profile.",
	REG_COMPANION_BOUND_TO_TARGET = "Target",
	REG_COMPANION_BROWSER_BATTLE = "Battle pet browser",
	REG_COMPANION_BROWSER_MOUNT = "Mount browser",
	REG_COMPANION_PROFILES = "Companions profiles",
	REG_COMPANION_TF_PROFILE = "Companion profile",
	REG_COMPANION_TF_PROFILE_MOUNT = "Mount profile",
	REG_COMPANION_TF_NO = "No profile",
	REG_COMPANION_TF_CREATE = "Create new profile",
	REG_COMPANION_TF_UNBOUND = "Unlink from profile",
	REG_COMPANION_TF_BOUND_TO = "Select a profile",
	REG_COMPANION_TF_OPEN = "Open page",
	REG_COMPANION_TF_OWNER = "Owner: %s",
	REG_COMPANION_INFO = "Information",
	REG_COMPANION_NAME = "Name",
	REG_COMPANION_TITLE = "Title",
	REG_COMPANION_NAME_COLOR = "Name color",
	REG_MSP_ALERT = [[|cffff0000WARNING

You can't have simultaneously more than one addon using the Mary Sue Protocol, as they would be in conflict.|r

Currently loaded: |cff00ff00%s

|cffff9900Therefore the MSP support for Total RP3 will be disabled.|r

If you don't want TRP3 to be your MSP addon and don't want to see this alert again, you can disable the Mary Sue Protocol module in the TRP3 Settings -> Module status.]],
	REG_COMPANION_PAGE_TUTO_C_1 = "Consult",
	REG_COMPANION_PAGE_TUTO_E_1 = "This is |cff00ff00your companion main information|r.\n\nAll these information will appear on |cffff9900your companion's tooltip|r.",
	REG_COMPANION_PAGE_TUTO_E_2 = [[This is |cff00ff00your companion description|r.

It isn't limited to |cffff9900physical description|r. Feel free to indicate parts from their |cffff9900background|r or details about their |cffff9900personality|r.

There are a lot of ways to customize the description.
You can choose a |cffffff00background texture|r for the description. You can also use the formatting tools to access several layout parameters like |cffffff00texts sizes, colors and alignments|r.
These tools also allow you to insert |cffffff00images, icons or links to external web sites|r.]],

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CONFIGURATION
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	CO_CONFIGURATION = "Settings",
	CO_GENERAL = "General settings",
	CO_GENERAL_CHANGELOCALE_ALERT = "Reload the interface in order to change the language to %s now?\n\nIf not, the language will be changed on the next connection.",
	CO_GENERAL_LOCALE = "Addon locale",
	CO_GENERAL_COM = "Communication",
	CO_GENERAL_MISC = "Miscellaneous",
	CO_GENERAL_TT_SIZE = "Info tooltip text size",
	CO_GENERAL_NEW_VERSION = "Update alert",
	CO_GENERAL_NEW_VERSION_TT = "Get an alert when a new version is available.",
	CO_GENERAL_UI_SOUNDS = "UI sounds",
	CO_GENERAL_UI_SOUNDS_TT = "Activate the UI sounds (when opening windows, switching tabs, clicking buttons).",
	CO_GENERAL_UI_ANIMATIONS = "UI animations",
	CO_GENERAL_UI_ANIMATIONS_TT = "Activate the UI animations.",
	CO_GENERAL_BROADCAST = "Use broadcast channel",
	CO_GENERAL_BROADCAST_TT = "The broadcast channel is used by a lot of features. Disabling it will disable all the features like characters position on the map, playing local sounds, stashes and signposts access...",
	CO_GENERAL_DEFAULT_COLOR_PICKER = "Default color picker",
	CO_GENERAL_DEFAULT_COLOR_PICKER_TT = "Activate to always use the default color picker. Useful if you're using a color picker addon.",
	CO_GENERAL_RESET_CUSTOM_COLORS = "Reset custom colors",
	CO_GENERAL_RESET_CUSTOM_COLORS_TT = "Removes all custom colors saved in the color picker.",
	CO_GENERAL_RESET_CUSTOM_COLORS_WARNING = "Are you sure you want to remove all custom colors saved in the color picker?",
	CO_GENERAL_CONTRAST_LEVEL = "Color contrast level",
	CO_GENERAL_CONTRAST_LEVEL_HELP = "Controls how aggressively custom colors will be adjusted for readability against dark backgrounds.|n|nThe 'Low' setting is the recommended default and will generally only affect very dark colors.",
	CO_GENERAL_CONTRAST_LEVEL_NONE = "None",
	CO_GENERAL_CONTRAST_LEVEL_VERY_LOW = "Very low",
	CO_GENERAL_CONTRAST_LEVEL_LOW = "Low",
	CO_GENERAL_CONTRAST_LEVEL_MEDIUM_LOW = "Medium low",
	CO_GENERAL_CONTRAST_LEVEL_MEDIUM_HIGH = "Medium high",
	CO_GENERAL_CONTRAST_LEVEL_HIGH = "High",
	CO_GENERAL_CONTRAST_LEVEL_VERY_HIGH = "Very high",
	CO_GENERAL_HIDE_MAXIMIZE_BUTTON = "Hide maximize button",
	CO_GENERAL_HIDE_MAXIMIZE_BUTTON_HELP = "Hides the minimize and maximize buttons on the Total RP 3 window.",
	CO_TOOLTIP = "Tooltip settings",
	CO_TOOLTIP_USE = "Use characters/companions tooltip",
	CO_TOOLTIP_COMBAT = "Hide during combat",
	CO_TOOLTIP_COLOR = "Show custom colors",
	CO_TOOLTIP_CONTRAST = "Increase color contrast",
	CO_TOOLTIP_CONTRAST_TT = "Enable this option to allow Total RP 3 to modify the custom colors to make the text more readable if the color is too dark.",
	CO_TOOLTIP_CROP_TEXT = "Crop unreasonably long texts",
	CO_TOOLTIP_CROP_TEXT_TT = [[Limit the number of characters that can be displayed by each field in the tooltip to prevent unreasonably long texts and possible layout issues.

|cfffff569Limit details:
Name: 100 characters
Title: 150 characters
Race: 50 characters
Class: 50 characters|r]],
	CO_TOOLTIP_CHARACTER = "Characters tooltip",
	CO_TOOLTIP_ANCHORED = "Anchored frame",
	CO_TOOLTIP_ANCHOR = "Anchor point",
	CO_TOOLTIP_HIDE_ORIGINAL = "Hide original tooltip",
	CO_TOOLTIP_MAINSIZE = "Main font size",
	CO_TOOLTIP_SUBSIZE = "Secondary font size",
	CO_TOOLTIP_TERSIZE = "Tertiary font size",
	CO_TOOLTIP_SPACING = "Show spacing",
	CO_TOOLTIP_SPACING_TT = "Place spaces to lighten the tooltip, in the style of MyRoleplay tooltip.",
	CO_TOOLTIP_NO_FADE_OUT = "Hide immediately instead of fading",
	CO_TOOLTIP_PETS = "Companions tooltip",
	CO_TOOLTIP_OWNER = "Show owner",
	CO_TOOLTIP_PETS_INFO = "Show companion info",
	CO_TOOLTIP_COMMON = "Common settings",
	CO_TOOLTIP_ICONS = "Show icons",
	CO_TOOLTIP_FT = "Show full title",
	CO_TOOLTIP_RACE = "Show race, class and level",
	CO_TOOLTIP_REALM = "Show realm",
	CO_TOOLTIP_GUILD = "Show guild info",
	CO_TOOLTIP_PRONOUNS = "Show pronouns",
	CO_TOOLTIP_TARGET = "Show target",
	CO_TOOLTIP_TITLE = "Show title",
	CO_TOOLTIP_CLIENT = "Show client",
	CO_TOOLTIP_NOTIF = "Show notifications",
	CO_TOOLTIP_NOTIF_TT = "The notifications line is the line containing the client version, the unread description marker and the 'At first glance' marker.",
	CO_TOOLTIP_RELATION = "Show relationship color",
	CO_TOOLTIP_RELATION_TT = "Set the character tooltip border to a color representing the relation.",
	CO_TOOLTIP_CURRENT = "Show \"current\" information",
	CO_TOOLTIP_CURRENT_SIZE = "Max \"current\" information length",
	CO_TOOLTIP_PROFILE_ONLY = "Use only if target has a profile",
	CO_TOOLTIP_IN_CHARACTER_ONLY = "Hide when out of character",
	CO_TOOLTIP_HIDE_IN_INSTANCE = "Hide while in instance",
	CO_TOOLTIP_HIDE_ON_MODIFIER = "Hide on modifier key",
	CO_TOOLTIP_HIDE_ON_MODIFIER_TT = "Hide the customized tooltip while a modifier key such as Ctrl or Alt is held.",
	CO_TOOLTIP_HIDE_ON_MODIFIED_NEVER = "Never",
	CO_TOOLTIP_ZONE = "Show zone",
	CO_TOOLTIP_ZONE_TT = "This will only show if the target is not in the same zone as you.",
	CO_TOOLTIP_HEALTH = "Show health",
	CO_TOOLTIP_HEALTH_TT = "This will only show if the target is not at full health.",
	CO_TOOLTIP_HEALTH_DISABLED = "Disabled",
	CO_TOOLTIP_HEALTH_NUMBER = "Number",
	CO_TOOLTIP_HEALTH_PERCENT = "Percentage",
	CO_TOOLTIP_HEALTH_BOTH = "Number + Percentage",
	CO_TOOLTIP_TITLE_COLOR = "Title text color",
	CO_TOOLTIP_TITLE_COLOR_HELP = [[The color used in the tooltip to display full-length character titles.]],
	CO_TOOLTIP_MAIN_COLOR = "Main text color",
	CO_TOOLTIP_MAIN_COLOR_HELP = [[The color used in the tooltip to display text such as the race, level, and currently and OOC headers.]],
	CO_TOOLTIP_SECONDARY_COLOR = "Secondary text color",
	CO_TOOLTIP_SECONDARY_COLOR_HELP = [[The color used in the tooltip to display secondary subtext such as realm and guild names, the currently and OOC contents, and zone or health information.]],

	REG_TT_GUILD_CUSTOM = "Custom guild",
	CO_TOOLTIP_GUILD_HIDDEN = "Hidden",
	CO_TOOLTIP_GUILD_SHOW_WITH_ORIGINAL = "Show original",
	CO_TOOLTIP_GUILD_SHOW_WITH_CUSTOM = "Show custom",
	CO_TOOLTIP_GUILD_SHOW_WITH_ALL = "Show all",
	CO_TOOLTIP_GUILD_TT = "Customizes how guild membership is displayed in the tooltip.",
	CO_TOOLTIP_GUILD_TT_HIDDEN = "Does not show any guild membership in the tooltip.",
	CO_TOOLTIP_GUILD_TT_SHOW_WITH_ORIGINAL = "Shows guild membership in the tooltip, but does not replace the name or rank if customized in the players' profile.",
	CO_TOOLTIP_GUILD_TT_SHOW_WITH_CUSTOM = "Shows guild membership in the tooltip, replacing the name or rank if customized in the players' profile.",
	CO_TOOLTIP_GUILD_TT_SHOW_WITH_ALL = "Shows both original and custom guild memberships on separate lines in the tooltip.",

	CO_REGISTER = "Register settings",
	CO_REGISTER_ABOUT_SETTINGS = "\"About\" settings",
	CO_REGISTER_ABOUT_H1_SIZE = "Header 1 text size",
	CO_REGISTER_ABOUT_H1_SIZE_TT = "Size of the text between {h1} tags. Default: %d",
	CO_REGISTER_ABOUT_H2_SIZE = "Header 2 text size",
	CO_REGISTER_ABOUT_H2_SIZE_TT = "Size of the text between {h2} tags. Default: %d",
	CO_REGISTER_ABOUT_H3_SIZE = "Header 3 text size",
	CO_REGISTER_ABOUT_H3_SIZE_TT = "Size of the text between {h3} tags. Default: %d",
	CO_REGISTER_ABOUT_P_SIZE = "Paragraph text size",
	CO_REGISTER_ABOUT_P_SIZE_TT = "Size of the text outside of header tags. Default: %d",
	CO_REGISTER_AUTO_PURGE = "Auto purge directory",
	CO_REGISTER_AUTO_PURGE_TT = "Automatically remove from directory the profiles of characters you haven't crossed for a certain time. You can choose the delay before deletion.\n\n|cff00ff00Note that profiles with a relation toward one of your characters will never be purged.\n\n|cffff9900There is a bug in WoW losing all the saved data when it reaches a certain threshold. We strongly recommend to avoid disabling the purge system.",
	CO_REGISTER_AUTO_PURGE_0 = "Disable purge",
	CO_REGISTER_AUTO_PURGE_1 = "After %s day(s)",
	CO_CURSOR_TITLE = "Cursor interactions",
	CO_CURSOR_RIGHT_CLICK = "Right-click to open profile",
	CO_CURSOR_RIGHT_CLICK_TT = [[Right-click on a player in the 3D world to open their profile, if they have one.

|TInterface\Cursor\WorkOrders:25|t This icon will be attached to the cursor when a player has a profile and you can right-click them.

|cffccccccNote: This feature is disabled during combat.|r]],
	CO_CURSOR_DISABLE_OOC = "Disabled while OOC",
	CO_CURSOR_DISABLE_OOC_TT = "Disable the cursor modifications when your roleplay status is set to |cffccccccOut Of Character|r.",
	CO_CURSOR_MODIFIER_KEY = "Modifier key",
	CO_CURSOR_MODIFIER_KEY_TT = "Requires a modifier key to be held down while right-clicking a player, to prevent accidental clicks.",
	CO_MODULES = "Modules status",
	CO_MODULES_VERSION = "Version: %s",
	CO_MODULES_ID = "Module ID: %s",
	CO_MODULES_STATUS = "Status: %s",
	CO_MODULES_STATUS_0 = "Missing dependencies",
	CO_MODULES_STATUS_1 = "Loaded",
	CO_MODULES_STATUS_2 = "Disabled",
	CO_MODULES_STATUS_3 = "Total RP 3 update required",
	CO_MODULES_STATUS_4 = "Error on initialization",
	CO_MODULES_STATUS_5 = "Error on startup",
	CO_MODULES_TT_NONE = "No dependencies";
	CO_MODULES_TT_DEPS = "Dependencies";
	CO_MODULES_TT_TRP = "%sFor Total RP 3 build %s minimum.|r",
	CO_MODULES_TT_DEP = "\n%s- %s (version %s)|r",
	CO_MODULES_TT_ERROR = "\n\n|cffff0000Error:|r\n%s";
	CO_MODULES_TUTO = [[A module is a independent feature that can be enabled or disabled.

Possible status:
|cff00ff00Loaded:|r The module is enabled and loaded.
|cff999999Disabled:|r The module is disabled.
|cffff9900Missing dependencies:|r Some dependencies are not loaded.
|cffff9900TRP update required:|r The module requires a more recent version of TRP3.
|cffff0000Error on init or on startup:|r The module loading sequence failed. The module will likely create errors!

|cffff9900When disabling a module, a UI reload is necessary.]],
	CO_MODULES_SHOWERROR = "Show error",
	CO_MODULES_DISABLE = "Disable module",
	CO_MODULES_ENABLE = "Enable module",
	CO_TOOLBAR = "Frames settings",
	CO_TOOLBAR_CONTENT = "Toolbar settings",
	CO_TOOLBAR_ICON_SIZE = "Icons size",
	CO_TOOLBAR_MAX = "Max icons per line",
	CO_TOOLBAR_MAX_TT = "Set to 1 if you want to display the bar vertically!",
	CO_TOOLBAR_CONTENT_CAPE = "Cape switch",
	CO_TOOLBAR_CONTENT_HELMET = "Helmet switch",
	CO_TOOLBAR_CONTENT_STATUS = "Player status (AFK/DND)",
	CO_TOOLBAR_CONTENT_RPSTATUS = "Character status (IC/OOC)",
	CO_TOOLBAR_SHOW_ON_LOGIN = "Show toolbar on login",
	CO_TOOLBAR_SHOW_ON_LOGIN_HELP = "If you don't want the toolbar to be displayed on login, you can disable this option.",
	CO_TOOLBAR_HIDE_TITLE = "Hide Toolbar Title",
	CO_TOOLBAR_HIDE_TITLE_HELP = "Hides the title shown above the toolbar.",
	CO_TARGETFRAME = "Target frame settings",
	CO_TARGETFRAME_USE = "Display conditions",
	CO_TARGETFRAME_USE_TT = "Determines in which conditions the target frame should be shown on target selection.",
	CO_TARGETFRAME_USE_1 = "Always",
	CO_TARGETFRAME_USE_2 = "Only when IC",
	CO_TARGETFRAME_USE_3 = "Never (Disabled)",
	CO_TARGETFRAME_ICON_SIZE = "Icons size",
	CO_MINIMAP_BUTTON = "Minimap button",
	CO_MINIMAP_BUTTON_SHOW_TITLE = "Show minimap button",
	CO_MINIMAP_BUTTON_SHOW_HELP = [[If you are using another add-on to display Total RP 3's minimap button (FuBar, Titan, Bazooka) you can remove the button from the minimap.

|cff00ff00Reminder : You can open Total RP 3 using /trp3 switch main|r]],
	CO_MINIMAP_BUTTON_FRAME = "Frame to anchor",
	CO_MINIMAP_BUTTON_RESET = "Reset position",
	CO_MINIMAP_BUTTON_RESET_BUTTON = "Reset",
	CO_MAP_BUTTON = "Map scan button",
	CO_MAP_BUTTON_POS = "Scan button anchor on map",
	CO_ANCHOR_TOP = "Top",
	CO_ANCHOR_TOP_LEFT = "Top left",
	CO_ANCHOR_TOP_RIGHT = "Top right",
	CO_ANCHOR_BOTTOM = "Bottom",
	CO_ANCHOR_BOTTOM_LEFT = "Bottom left",
	CO_ANCHOR_BOTTOM_RIGHT = "Bottom right",
	CO_ANCHOR_LEFT = "Left",
	CO_ANCHOR_RIGHT = "Right",
	CO_ANCHOR_CURSOR = "Show on cursor",
	CO_CHAT = "Chat settings",
	CO_CHAT_DISABLE_OOC = "Disable customizations when OOC",
	CO_CHAT_DISABLE_OOC_TT = "Disable all of Total RP 3's chat customizations (custom names, emote detection, NPC speeches, etc.) when your character is set as Out Of Character.",
	CO_CHAT_MAIN = "Chat main settings",
	CO_CHAT_MAIN_NAMING = "Naming method",
	CO_CHAT_MAIN_NAMING_1 = "Keep original names",
	CO_CHAT_MAIN_NAMING_2 = "Use custom names",
	CO_CHAT_MAIN_NAMING_3 = "First name + last name",
	CO_CHAT_MAIN_NAMING_4 = "Short title + first name + last name",
	CO_CHAT_REMOVE_REALM = "Remove realm from player names",
	CO_CHAT_INSERT_FULL_RP_NAME = "Insert RP names on shift-click",
	CO_CHAT_INSERT_FULL_RP_NAME_TT = [[Insert the complete RP name of a player when SHIFT-Clicking their name in the chat frame.

(When this option is enabled, you can ALT-SHIFT-Click on a name when you want the default behavior and insert the character name instead of the full RP name.)]],
	CO_CHAT_MAIN_COLOR = "Use custom colors for names",
	CO_CHAT_INCREASE_CONTRAST = "Increase color contrast",
	CO_CHAT_SHOW_OOC = "Show OOC indicator",
	CO_CHAT_USE_ICONS = "Show player icons",
	CO_CHAT_USE = "Used chat channels",
	CO_CHAT_USE_SAY = "Say channel",
	CO_CHAT_MAIN_NPC = "NPC talk detection",
	CO_CHAT_MAIN_NPC_USE = "Use NPC talk detection",
	CO_CHAT_MAIN_NPC_PREFIX = "NPC talk detection pattern",
	CO_CHAT_MAIN_NPC_PREFIX_TT = "If a chat line said in the EMOTE channel begins with this prefix, it will be interpreted as an NPC chat.\n\n|cff00ff00By default: \"|| \"\n(without the \" and with a space after the pipe)",
	CO_CHAT_MAIN_EMOTE = "Emote detection",
	CO_CHAT_MAIN_EMOTE_USE = "Use emote detection",
	CO_CHAT_MAIN_EMOTE_PATTERN = "Emote detection pattern",
	CO_CHAT_MAIN_OOC = "OOC detection",
	CO_CHAT_MAIN_OOC_USE = "Use OOC detection",
	CO_CHAT_MAIN_OOC_PATTERN = "OOC detection pattern",
	CO_CHAT_MAIN_OOC_COLOR = "OOC color",
	CO_CHAT_MAIN_EMOTE_YELL = "No yelled emote",
	CO_CHAT_MAIN_EMOTE_YELL_TT = "Do not show *emote* or <emote> in yelling.",
	CO_CHAT_MAIN_SPEECH = "Speech detection",
	CO_CHAT_MAIN_SPEECH_USE = "Use speech detection",
	CO_CHAT_MAIN_SPEECH_USE_TT = "Text surrounded by quotation marks will be colored as if written in /say.",
	CO_CHAT_NPCSPEECH_REPLACEMENT = "Customize companion names in NPC speeches",
	CO_CHAT_NPCSPEECH_REPLACEMENT_TT = "If a companion name is in brackets in an NPC speech, it will be colored and its icon will be shown depending on your settings above.",
	CO_GLANCE_MAIN = "\"At first glance\" bar",
	CO_GLANCE_RESET_TT = "Reset the bar position to the bottom left of the anchored frame.",
	CO_GLANCE_LOCK = "Lock bar",
	CO_GLANCE_LOCK_TT = "Prevent the bar from being dragged",
	CO_GLANCE_PRESET_TRP2 = "Use Total RP 2 style positions",
	CO_GLANCE_PRESET_TRP2_BUTTON = "Use",
	CO_GLANCE_PRESET_TRP2_HELP = "Shortcut to setup the bar in a TRP2 style: to the right of WoW target frame.",
	CO_GLANCE_PRESET_TRP3 = "Use Total RP 3 style positions",
	CO_GLANCE_PRESET_TRP3_HELP = "Shortcut to setup the bar in a TRP3 style: to the bottom of the TRP3 target frame.",
	CO_GLANCE_TT_ANCHOR = "Tooltips anchor point",
	CO_HIDE_EMPTY_MAP_BUTTON = "Hide when no scans available",
	CO_MSP = "Mary Sue Protocol",
	CO_WIM = "|cffff9900Whisper channels are disabled.",
	CO_WIM_TT = "You are using |cff00ff00WIM|r, the handling for whisper channels is disabled for compatibility purposes",
	CO_LOCATION = "Location settings",
	CO_LOCATION_ACTIVATE = "Enable character location",
	CO_LOCATION_ACTIVATE_TT = "Enable the character location system, allowing you to scan for other Total RP users on the world map and allowing them to find you.",
	CO_LOCATION_DISABLE_OOC = "Disable location when OOC",
	CO_LOCATION_DISABLE_OOC_TT = "You will not respond to location requests from other players when you've set your RP status to Out Of Character.",
	CO_LOCATION_DISABLE_CLASSIC_PVP = "Disable location when flagged for PvP",
	CO_LOCATION_DISABLE_CLASSIC_PVP_TT = "You will not respond to location requests from other players when you are flagged for PvP.\n\nThis option is particularly useful to avoid abuses of the location system to track you.",
	CO_SANITIZER = "Sanitize incoming profiles",
	CO_SANITIZER_TT = "Remove escaped sequences in tooltip fields from incoming profiles when TRP doesn't allow it (color, images, ...).",
	CO_DATE_FORMAT = "Date format",
	CO_DATE_FORMAT_HELP = "Format string used for date/time strings in the addon.|n|nIf left empty, this will display date/time strings in a format appropriate to the configured locale of the addon.|n|nThe following format specifiers are supported:|n|n%1$s|n|nAll other characters are treated literally.",
	CO_DATE_FORMAT_SPEC_a = "%1$s: Abbreviated weekday name (%2$s)",
	CO_DATE_FORMAT_SPEC_A = "%1$s: Full weekday name (%2$s)",
	CO_DATE_FORMAT_SPEC_b = "%1$s: Abbreviated month name (%2$s)",
	CO_DATE_FORMAT_SPEC_B = "%1$s: Full month name (%2$s)",
	CO_DATE_FORMAT_SPEC_d = "%1$s: Day of the month (%2$s)",
	CO_DATE_FORMAT_SPEC_H = "%1$s: Hour using a 24-hour clock (%2$s)",
	CO_DATE_FORMAT_SPEC_I = "%1$s: Hour using a 12-hour clock (%2$s)",
	CO_DATE_FORMAT_SPEC_m = "%1$s: Month (%2$s)",
	CO_DATE_FORMAT_SPEC_M = "%1$s: Minute (%2$s)",
	CO_DATE_FORMAT_SPEC_p = "%1$s: Either 'am' or 'pm' (%2$s)",
	CO_DATE_FORMAT_SPEC_S = "%1$s: Second (%2$s)",
	CO_DATE_FORMAT_SPEC_y = "%1$s: Two-digit year (%2$s)",
	CO_DATE_FORMAT_SPEC_Y = "%1$s: Full year (%2$s)",
	CO_DATE_FORMAT_SPEC_ESC = "%1$s: The literal character '%%'",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- TOOLBAR AND UI BUTTONS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TB_TOOLBAR = "Toolbar",
	TB_SWITCH_TOOLBAR = "Switch toolbar",
	TB_SWITCH_CAPE_ON = "Cloak: |cff00ff00Shown",
	TB_SWITCH_CAPE_OFF = "Cloak: |cffff0000Hidden",
	TB_SWITCH_CAPE_1 = "Show cloak",
	TB_SWITCH_CAPE_2 = "Hide cloak",
	TB_SWITCH_HELM_ON = "Helm: |cff00ff00Shown",
	TB_SWITCH_HELM_OFF = "Helm: |cffff0000Hidden",
	TB_SWITCH_HELM_1 = "Show helmet",
	TB_SWITCH_HELM_2 = "Hide helmet",
	TB_GO_TO_MODE = "Switch to %s mode",
	TB_NORMAL_MODE = "Normal",
	TB_DND_MODE = "Do not disturb",
	TB_AFK_MODE = "Away",
	TB_STATUS = "Player",
	TB_RPSTATUS_ON = "Character: |cff00ff00In character",
	TB_RPSTATUS_OFF = "Character: |cffff0000Out of character",
	TB_RPSTATUS_TO_ON = "Go |cff00ff00in character",
	TB_RPSTATUS_TO_OFF = "Go |cffff0000out of character",
	TB_SWITCH_PROFILE = "Switch to another profile",
	TF_OPEN_CHARACTER = "Show character page",
	TF_OPEN_COMPANION = "Show companion page",
	TF_OPEN_MOUNT = "Show mount page",
	TF_PLAY_THEME = "Play character theme",
	TF_PLAY_THEME_TT = "|cffffff00Click:|r Play |cff00ff00%s\n|cffffff00Right-click:|r Stop theme",
	TF_IGNORE = "Ignore player",
	TF_IGNORE_TT = "|cffffff00Click:|r Ignore player",
	TF_IGNORE_CONFIRM = "Are you sure you want to ignore this player?\n\n|cffffff00%s|r\n\n|cffff7700You can optionally enter below the reason why you ignore it. This is a personal note, it won't be visible by others and will serve as a reminder.",
	TF_IGNORE_NO_REASON = "No reason",
	TB_LANGUAGE = "Language",
	TB_LANGUAGES_TT = "Change language",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- PROFILES
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	PR_PROFILEMANAGER_TITLE = "Characters profiles",
	PR_PROFILEMANAGER_DELETE_WARNING = "Are you sure you want to delete the profile %s?\nThis action cannot be undone and all TRP3 information linked to this profile (Character info, inventory, quest log, applied states...) will be destroyed!",
	PR_PROFILE = "Profile",
	PR_PROFILES = "Profiles",
	PR_PROFILE_CREATED = "Profile %s created.",
	PR_CREATE_PROFILE = "Create profile",
	PR_PROFILE_DELETED = "Profile %s deleted.",
	PR_PROFILE_HELP = "A profile contains all information about a |cffffff00\"character\"|r as a |cff00ff00roleplay character|r.\n\nA real |cffffff00\"WoW character\"|r can be linked to only one profile at a time, but can switch from one to another whenever you want.\n\nYou can also link several |cffffff00\"WoW characters\"|r to the same |cff00ff00profile|r!",
	PR_PROFILE_DETAIL = "This profile is currently linked to these WoW characters",
	PR_DELETE_PROFILE = "Delete profile",
	PR_DUPLICATE_PROFILE = "Duplicate profile",
	PR_UNUSED_PROFILE = "This profile is currently not linked to any WoW character.",
	PR_PROFILE_LOADED = "The profile %s is loaded.",
	PR_PROFILEMANAGER_CREATE_POPUP = "Please enter a name for the new profile.\nThe name cannot be empty.",
	PR_PROFILEMANAGER_DUPP_POPUP = "Please enter a name for the new profile.\nThe name cannot be empty.\n\nThis duplication will not change the character's links to %s.",
	PR_PROFILEMANAGER_EDIT_POPUP = "Please enter a new name for this profile %s.\nThe name cannot be empty.\n\nChanging the name will not change any link between this profile and your characters.",
	PR_PROFILEMANAGER_ALREADY_IN_USE = "The profile name %s is not available.",
	PR_PROFILEMANAGER_COUNT = "%s WoW character(s) linked to this profile.",
	PR_PROFILEMANAGER_ACTIONS = "Actions",
	PR_PROFILEMANAGER_SWITCH = "Select profile",
	PR_PROFILEMANAGER_RENAME = "Rename profile",
	PR_PROFILEMANAGER_CURRENT = "Current profile",
	PR_PROFILEMANAGER_SEARCH_PROFILE = "Search profile",
	PR_PROFILEMANAGER_EMPTY = "No profiles found",
	PR_CO_PROFILEMANAGER_TITLE = "Companions profiles",
	PR_CO_PROFILE_HELP = [[A profile contains all information about a |cffffff00"pet"|r as a |cff00ff00roleplay character|r.

A companion profile can be linked to:
- A battle pet
- A hunter pet
- A warlock minion
- A mage elemental
- A death knight ghoul |cffff9900(see below)|r

Just like characters profiles, a |cff00ff00companion profile|r can be linked to |cffffff00several pets|r, and a |cffffff00pet|r can switch easily from one profile to another.

|cffff9900Ghouls:|r As ghouls get a new name each time they are summoned, you will have to re-link the profile to the ghoul for all possible names.]],
	PR_CO_PROFILE_HELP2 = [[Click here to create a new companion profile.

|cff00ff00To link a profile to a pet (hunter pet, warlock minion...), just summon the pet, select it and use the target frame to link it to a existing profile (or create a new one).|r]],
	PR_CO_MASTERS = "Masters",
	PR_CO_EMPTY = "No companion profile",
	PR_CO_NEW_PROFILE = "New companion profile",
	PR_CO_COUNT = "%s pets/mounts linked to this profile.",
	PR_CO_UNUSED_PROFILE = "This profile is currently not linked to any pet or mount.",
	PR_CO_PROFILE_DETAIL = "This profile is currently linked to",
	PR_CO_PROFILEMANAGER_DELETE_WARNING = "Are you sure you want to delete the companion profile %s?\nThis action cannot be undone and all TRP3 information linked to this profile will be destroyed!",
	PR_CO_PROFILEMANAGER_DUPP_POPUP = "Please enter a name for the new profile.\nThe name cannot be empty.\n\nThis duplication will not change your pets/mounts links to %s.",
	PR_CO_PROFILEMANAGER_EDIT_POPUP = "Please enter a new name for this profile %s.\nThe name cannot be empty.\n\nChanging the name will not change any link between this profile and your pets/mounts.",
	PR_CO_WARNING_RENAME = "|cffff0000Warning:|r it's strongly recommended that you rename your pet before linking it to a profile.\n\nLink it anyway?",
	PR_CO_PET = "Pet",
	PR_CO_BATTLE = "Battle pet",
	PR_CO_MOUNT = "Mount",
	PR_IMPORT_CHAR_TAB = "Characters importer",
	PR_IMPORT_PETS_TAB = "Companions importer",
	PR_IMPORT_IMPORT_ALL = "Import all",
	PR_IMPORT_WILL_BE_IMPORTED = "Will be imported",
	PR_IMPORT_EMPTY = "No importable profile",
	PR_PROFILE_MANAGEMENT_TITLE = "Profile management",
	PR_EXPORT_IMPORT_TITLE = "Export/import profile",
	PR_EXPORT_IMPORT_HELP = [[You can export and import profiles using the options in the dropdown menu.

Use the |cffffff00Export profile|r option to generate a chunk of text containing the profile serialized data. You can copy the text using Control-C (or Command-C on a Mac) and paste it somewhere else as a backup. (|cffff0000Please note that some advanced text editing tools like Microsoft Word will reformat special characters like quotes, altering the data. Use simpler text editing tools like Notepad.|r)

Use the |cffffff00Import profile|r option to paste data from a previous export inside an existing profile. The existing data in this profile will be replaced by the ones you have pasted. You cannot import data directly into your currently selected profile.]],
	PR_EXPORT_PROFILE = "Export profile",
	PR_IMPORT_PROFILE = "Import profile",
	PR_EXPORT_NAME = "Serial for profile %s (size %0.2f kB)",
	PR_EXPORT_TOO_LARGE = "This profile is too large and can't be exported.\n\nSize of profile: %0.2f kB\nMax: 20 kB",
	PR_IMPORT_PROFILE_TT = "Paste a profile serial here",
	PR_IMPORT = "Import",
	PR_PROFILEMANAGER_IMPORT_WARNING = "Replace all the content of profile %s with this imported data?",
	PR_PROFILEMANAGER_IMPORT_WARNING_2 = "Warning: this profile serial has been made from an older version of TRP3.\nThis can bring incompatibilities.\n\nReplacing all the content of profile %s with this imported data?",
	PR_SLASH_SWITCH_HELP = "Switch to another profile using its name.",
	PR_SLASH_EXAMPLE = "|cffffff00Command usage:|r |cffcccccc/trp3 profile Millidan Foamrage|r |cffffff00to switch to Millidan Foamrage's profile.|r",
	PR_SLASH_NOT_FOUND = "|cffff0000Could not find a profile named|r |cffffff00%s|r|cffff0000.|r",
	PR_SLASH_OPEN_HELP = "Open a character's profile using its in-game name, or your target's profile if no name is provided.",
	PR_SLASH_OPEN_EXAMPLE = "|cffffff00Command usage:|r |cffcccccc/trp3 open|r |cffffff00to open your target's profile or |cffcccccc/trp3 open CharacterName-RealmName|r |cffffff00to open that character's profile.|r",
	PR_SLASH_OPEN_WAITING = "|cffffff00Requesting profile, please wait...|r",
	PR_SLASH_OPEN_ABORTING = "|cffffff00Aborted profile request.|r",
	PR_DEFAULT_PROFILE_NAME = "Default profile",
	PR_DEFAULT_PROFILE_WARNING = "Create a new profile\nor link to an existing one in Profiles\nto edit your character's information.",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- DASHBOARD
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	DB_STATUS = "Status",
	DB_STATUS_CURRENTLY_COMMON = "These statuses will be displayed on your character's tooltip. Keep it clear and brief as |cffff9900by default TRP3 players will only see the first 140 characters of them!",
	DB_STATUS_CURRENTLY = "Currently (IC)",
	DB_STATUS_CURRENTLY_TT = "Here you can indicate something important about your character.",
	DB_STATUS_CURRENTLY_OOC = "Other information (OOC)",
	DB_STATUS_CURRENTLY_OOC_TT = "Here you can indicate something important about you, as a player, or anything out of your character.",
	DB_STATUS_RP = "Character status",
	DB_STATUS_RP_IC = "In character",
	DB_STATUS_RP_IC_TT = "That means you are currently playing your character.\nAll your actions will be interpreted as if it's your character doing them.",
	DB_STATUS_RP_OOC = "Out of character",
	DB_STATUS_RP_OOC_TT = "You are out of your character.\nYour actions can't be associated to him/her.",
	DB_STATUS_XP = "Roleplayer status",
	DB_STATUS_XP_BEGINNER = "Rookie roleplayer",
	DB_STATUS_XP_BEGINNER_TT = "This selection will show an icon on your tooltip, indicating\nto others that you are a beginner roleplayer.",
	DB_STATUS_RP_EXP = "Experienced roleplayer",
	DB_STATUS_RP_EXP_TT = "Shows that you are an experienced roleplayer.\nIt will not show any specific icon on your tooltip.",
	DB_STATUS_RP_VOLUNTEER = "Volunteer roleplayer",
	DB_STATUS_RP_VOLUNTEER_TT = "This selection will show an icon on your tooltip, indicating\nto beginner roleplayers that you are willing to help them.",
	DB_STATUS_LC = "Roleplay language",
	DB_STATUS_LC_TT = [[Sets your preferred roleplaying language. This will be shared with other compatible RP addon users.

|cffff9900Note:|r This does |cffff0000not|r change the user interface language of Total RP 3. This option can instead be found in the |cfffff569Advanced Settings|r page.]],

	-- DB_STATUS_LC_DEFAULT will be formatted with the current locale name, eg. "Italiano".
	DB_STATUS_LC_DEFAULT = "Default (%1$s)",

	-- DB_STATUS_ICON_ITEM will be formatted with an icon texture and a label for a dropdown item.
	DB_STATUS_ICON_ITEM = "%1$s %2$s",
	DB_TUTO_1 = [[|cffffff00The character status|r indicates if you are currently playing your character's role or not.

|cffffff00The roleplayer status|r allows you to state that you are a beginner, or a veteran willing to help rookies!

|cff00ff00These information will be placed in your character's tooltip.]],
	DB_NEW = "What's new?",
	DB_ABOUT = "About Total RP 3",
	DB_MORE = "More modules",
	DB_HTML_GOTO = "Click to open",
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- COMMON UI TEXTS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	UI_BKG = "Background %s",
	UI_ICON_BROWSER = "Icon browser",
	UI_ICON_BROWSER_HELP = "Copy icon",
	UI_ICON_BROWSER_HELP_TT = [[While this frame is open you can |cffffff00ctrl + click|r on a icon to copy its name.

This will works:|cff00ff00
- On any item in your bags
- On any icon in the spellbook|r]],
	UI_ICON_BROWSER_SEARCHING = "Searching...",
	UI_COMPANION_BROWSER_HELP = "Select a battle pet",
	UI_COMPANION_BROWSER_RENAME_WARNING = "|cffff0000Warning:|r It is strongly recommended to only link companion profiles to renamed pets.",
	UI_ICON_SELECT = "Select icon",
	UI_MUSIC_BROWSER = "Music browser",
	UI_MUSIC_SELECT = "Select music",
	UI_MUSIC_DURATION = "Duration",
	UI_MUSIC_ALTTITLE = "Alternate title",
	UI_COLOR_BROWSER = "Color browser",
	UI_COLOR_BROWSER_SELECT = "Select color",
	UI_COLOR_BROWSER_PRESETS = "Presets",
	UI_COLOR_BROWSER_PRESETS_BASIC = "Basic",
	UI_COLOR_BROWSER_PRESETS_CLASSES = "Class",
	UI_COLOR_BROWSER_PRESETS_RESOURCES = "Resource",
	UI_COLOR_BROWSER_PRESETS_ITEMS = "Item quality",
	UI_COLOR_BROWSER_PRESETS_CUSTOM = "Custom",
	UI_IMAGE_BROWSER = "Image browser",
	UI_IMAGE_SELECT = "Select image",
	UI_FILTER = "Filter",
	UI_FILTER_NO_RESULTS_FOUND_TITLE = "No results found.",
	UI_FILTER_NO_RESULTS_FOUND_TEXT = "Try adjusting your search criteria.",
	UI_LINK_URL = "http://your.url.here",
	UI_LINK_TEXT = "Your text here",
	UI_LINK_SAFE = [[Here's the link URL.]],
	UI_LINK_WARNING = [[Here's the link URL.
You can copy/paste it in your web browser.

|cffff0000!! Disclaimer !!|r
Total RP is not responsible for links leading to harmful content.]],
	UI_TUTO_BUTTON = "Tutorial mode",
	UI_TUTO_BUTTON_TT = "Click to toggle on/off the tutorial mode",
	UI_CLOSE_ALL = "Close all",

	NPC_TALK_SAY_PATTERN = "says:",
	NPC_TALK_YELL_PATTERN = "yells:",
	NPC_TALK_WHISPER_PATTERN = "whispers:",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- COMMON TEXTS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	CM_SHOW = "Show",
	CM_ACTIONS = "Actions",
	CM_IC = "IC",
	CM_OOC = "OOC",
	CM_CLICK = "Click",
	CM_R_CLICK = "Right-click",
	CM_L_CLICK = "Left-click",
	CM_M_CLICK = "Middle-click",
	CM_ALT = "Alt",
	CM_CTRL = "Ctrl",
	CM_SHIFT = "Shift",
	CM_DRAGDROP = "Drag & drop",
	CM_DOUBLECLICK = "Double-click",
	CM_LINK = "Link",
	CM_SAVE = "Save",
	CM_CANCEL = "Cancel",
	CM_DELETE = "Delete",
	CM_RESET = "Reset",
	CM_NAME = "Name",
	CM_VALUE = "Value",
	CM_UNKNOWN = "Unknown",
	CM_PLAY = "Play",
	CM_STOP = "Stop",
	CM_LOAD = "Load",
	CM_REMOVE = "Remove",
	CM_EDIT = "Edit",
	CM_LEFT = "Left",
	CM_CENTER = "Center",
	CM_RIGHT = "Right",
	CM_COLOR = "Color",
	CM_ICON = "Icon",
	CM_IMAGE = "Image",
	CM_SELECT = "Select",
	CM_OPEN = "Open",
	CM_APPLY = "Apply",
	CM_MOVE_UP = "Move up",
	CM_MOVE_DOWN = "Move down",
	CM_CLASS_WARRIOR = "Warrior",
	CM_CLASS_PALADIN = "Paladin",
	CM_CLASS_HUNTER = "Hunter",
	CM_CLASS_ROGUE = "Rogue",
	CM_CLASS_PRIEST = "Priest",
	CM_CLASS_DEATHKNIGHT = "Death Knight",
	CM_CLASS_SHAMAN = "Shaman",
	CM_CLASS_MAGE = "Mage",
	CM_CLASS_WARLOCK = "Warlock",
	CM_CLASS_MONK = "Monk",
	CM_CLASS_DRUID = "Druid",
	CM_CLASS_DEMONHUNTER = "Demon Hunter",
	CM_CLASS_EVOKER = "Evoker",
	CM_CLASS_UNKNOWN = "Unknown",
	CM_RESIZE = "Resize",
	CM_RESIZE_TT = "Drag to resize the frame.",
	CM_TWEET_PROFILE = "Show profile url",
	CM_TWEET = "Send a tweet",

	CM_ORANGE = "Orange",
	CM_WHITE = "White",
	CM_YELLOW = "Yellow",
	CM_CYAN = "Cyan",
	CM_BLUE = "Blue",
	CM_GREEN = "Green",
	CM_RED = "Red",
	CM_PURPLE = "Purple",
	CM_PINK = "Pink",
	CM_BLACK = "Black",
	CM_GREY = "Grey",

	COPY_URL_POPUP_TEXT = "You can copy this link by using the %s keyboard shortcut and then paste the link inside your browser using the %s shortcut.",
	CM_CTRL_MAC = "Command",
	CM_ALT_MAC = "Option",
	SHORTCUT_INSTRUCTION = "%s: %s",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Minimap button
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	MM_SHOW_HIDE_MAIN = "Show/hide the main frame",
	MM_SHOW_HIDE_SHORTCUT = "Show/hide the toolbar",
	MM_SHOW_HIDE_MOVE = "Move button",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Browsers
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	BW_COLOR_CODE = "Color code",
	BW_COLOR_CODE_TT = "You can paste a 6 figures hexadecimal color code here and press Enter.",
	BW_COLOR_CODE_ALERT = "Invalid hexadecimal color code!",
	BW_CUSTOM_NAME = "Custom color name",
	BW_CUSTOM_NAME_TITLE = "Name (Optional)",
	BW_CUSTOM_NAME_TT = "You can set a name for the custom color you're saving. If left empty, it will use the hexadecimal color code.",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Databroker
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	DTBK_HELMET = "Total RP 3 - Helmet",
	DTBK_CLOAK = "Total RP 3 - Cloak",
	DTBK_AFK = "Total RP 3 - AFK/DND",
	DTBK_RP = "Total RP 3 - IC/OOC",
	DTBK_LANGUAGES = "Total RP 3 - Languages",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Bindings
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	BINDING_NAME_TRP3_TOGGLE = "Toggle main frame";
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Toggle toolbar";

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- About TRP3
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	ABOUT_TITLE = "About",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Slash commands
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	SLASH_CMD_STATUS_USAGE = "ic || ooc || toggle",
	SLASH_CMD_STATUS_HELP = [[Usage: |cff00ff00/trp3 status ic || ooc || toggle|r
Changes your character status to the specified option:

|cffff9900/trp3 status ic|r will set your status to |cff00ff00in character|r.
|cffff9900/trp3 status ooc|r will set your status to |cffff0000out of character|r.
|cffff9900/trp3 status toggle|r will switch your status to the opposite state.]],

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- MAP
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	MAP_BUTTON_TITLE = "Scan for roleplay",
	MAP_BUTTON_SUBTITLE = "Click to show available scans",
	MAP_BUTTON_SUBTITLE_OFFLINE = "Map scanning is unavailable right now: %s",
	MAP_BUTTON_SUBTITLE_CONNECTING = "Map scanning is setting up. Please wait.",
	MAP_BUTTON_NO_SCAN = "No scan available",
	MAP_BUTTON_SCANNING = "Scanning",
	MAP_SCAN_CHAR = "Scan for characters",
	MAP_SCAN_CHAR_TITLE = "Characters",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- MATURE FILTER
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	MATURE_FILTER_TITLE = "Mature profiles filter",
	MATURE_FILTER_TOOLTIP_WARNING = "Mature content",
	MATURE_FILTER_TOOLTIP_WARNING_SUBTEXT = "This character profile contains mature content. Use the target bar action button to reveal the content if you really want to…",
	MATURE_FILTER_OPTION = "Filter mature profiles",
	MATURE_FILTER_OPTION_TT = [[Check this option to enable mature profile filtering. Total RP 3 will scan incoming profiles when they are received for specific keywords reported as being for a mature audience and flag the profile as mature if it finds such word.

A mature profile will have a muted tooltip and you will have to confirm that you want to view the profile the first time you open it.

|cffccccccNote: The mature filter dictionary is pre-populated with a list of words from a crowd sourced repository. You can edit the words using the option below.|r]],
	MATURE_FILTER_STRENGTH = "Mature filter strength",
	MATURE_FILTER_STRENGTH_TT = [[Set the strength of the mature filter.

|cffcccccc1 is weak (10 bad words required to flag), 10 is strong (only 1 bad word required to flag).|r]],
	MATURE_FILTER_FLAG_PLAYER = "Flag as mature",
	MATURE_FILTER_FLAG_PLAYER_TT = "Flag this profile has containing mature content. The profile content will be hidden.",
	MATURE_FILTER_FLAG_PLAYER_OPTION = "Flag as mature",
	MATURE_FILTER_FLAG_PLAYER_TEXT = [[Confirm that you want to flag %s's profile as containing mature content. This profile content will be hidden.

|cffffff00Optional:|r Indicate the offensive words you found in this profile (separated by a space character) to add them to the filter.]],
	MATURE_FILTER_EDIT_DICTIONARY = "Edit custom dictionary",
	MATURE_FILTER_EDIT_DICTIONARY_TT = "Edit the custom dictionary used to filter mature profiles.",
	MATURE_FILTER_EDIT_DICTIONARY_BUTTON = "Edit",
	MATURE_FILTER_EDIT_DICTIONARY_TITLE = "Custom dictionary editor",
	MATURE_FILTER_EDIT_DICTIONARY_ADD_BUTTON = "Add",
	MATURE_FILTER_EDIT_DICTIONARY_ADD_TEXT = "Add a new word to the dictionary",
	MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD = [[Edit this word]],
	MATURE_FILTER_EDIT_DICTIONARY_DELETE_WORD = [[Delete the word from the custom dictionary]],
	MATURE_FILTER_EDIT_DICTIONARY_RESET_TITLE = "Reset dictionary",
	MATURE_FILTER_EDIT_DICTIONARY_RESET_BUTTON = "Reset",
	MATURE_FILTER_EDIT_DICTIONARY_RESET_WARNING = "Are you sure you want to reset the dictionary? This will empty the dictionary and fill it with the default words provided for your current language (if available).",
	MATURE_FILTER_WARNING_TITLE = "Mature content",
	MATURE_FILTER_WARNING_CONTINUE = "Continue",
	MATURE_FILTER_WARNING_GO_BACK = "Go back",
	MATURE_FILTER_WARNING_TEXT = [[You have Total RP 3's mature content filtering system enabled.

This profile has been flagged as containing mature content.

Are you sure you want to view this profile?]],
	MATURE_FILTER_ADD_TO_SAFELIST = "Add this profile to the |cffffffffmature safelist|r",
	MATURE_FILTER_ADD_TO_SAFELIST_TT = "Add this profile to the |cffffffffmature safelist|r and reveal the mature content found inside.",
	MATURE_FILTER_ADD_TO_SAFELIST_OPTION = "Add to the |cffffffffmature safelist|r",
	MATURE_FILTER_ADD_TO_SAFELIST_TEXT = [[Confirm that you want to add %s to the |cffffffffmature safelist|r.

The content of their profiles will no longer be hidden.]],
	MATURE_FILTER_REMOVE_FROM_SAFELIST = "Remove this profile from the |cffffffffmature safelist|r",
	MATURE_FILTER_REMOVE_FROM_SAFELIST_TT = "Remove this profile from the |cffffffffmature safelist|r and hide again the mature content found inside.",
	MATURE_FILTER_REMOVE_FROM_SAFELIST_OPTION = "Remove from the |cffffffffmature safelist|r",
	MATURE_FILTER_REMOVE_FROM_SAFELIST_TEXT = [[Confirm that you want to remove %s from the |cffffffffmature safelist|r.

The content of their profiles will be hidden again.]],

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- DICE ROLL
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	DICE_ROLL = "%s Rolled |cffff9900%sx d%s|r|cffcc6600%s|r and got |cff00ff00%s|r.",
	DICE_TOTAL = "%s Total of |cff00ff00%s|r for the roll.",
	DICE_HELP = "A dice roll or rolls separated by spaces, example: 1d6, 2d12 3d20 ...",
	DICE_ROLL_T = "%s %s rolled |cffff9900%sx d%s|r|cffcc6600%s|r and got |cff00ff00%s|r.",
	DICE_TOTAL_T = "%s %s got a total of |cff00ff00%s|r for the roll.",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- NPC Speeches
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	NPC_TALK_TITLE = "NPC speeches",
	NPC_TALK_NAME = "NPC name",
	NPC_TALK_NAME_TT = [[You can use standard chat tags like %t to insert your target's name or %f to insert your focus' name.

You can also leave this field empty to create emotes without an NPC name at the start.

Putting your companion name in [brackets] will allow color and icon customization.
]],
	NPC_TALK_MESSAGE = "Message",
	NPC_TALK_CHANNEL = "Channel: ",
	NPC_TALK_SEND = "Send",
	NPC_TALK_ERROR_EMPTY_MESSAGE = "The message cannot be empty.",
	NPC_TALK_COMMAND_HELP = "Open the NPC speeches frame.",
	NPC_TALK_BUTTON_TT = "Open the NPC speeches frame allowing you to do NPC speeches or emotes.",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- ANALYTICS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	ANALYTICS_CONFIG_ENABLE = "Enable %s",
	ANALYTICS_CONFIG_ENABLE_HELP = "Enables the collection of anonymous addon usage analytics via %s.|n|nAn example of the statistics collected can be printed to the chat frame through the |cff00ff00/trp3 statistics|r command.",
	ANALYTICS_CONFIG_ENABLE_HELP_WAGO = [[This requires the |cff00ff00"Help addon developers"|r setting in the Wago Addons application to be enabled.]],
	ANALYTICS_COMMAND_HELP = "Prints addon usage statistics to the chat frame.",
	ANALYTICS_OUTPUT_HEADER = "Addon usage statistics:",
	MACRO_ACTION_PROFILE_NAME_INVALID = "Unknown profile name: %s",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- AUTOMATION
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	AUTOMATION_ACTION_CHARACTER_EQUIPSET = "Wear equipment set",
	AUTOMATION_ACTION_CHARACTER_EQUIPSET_APPLIED = "Changed equipment set to %s.",
	AUTOMATION_ACTION_CHARACTER_EQUIPSET_DESCRIPTION = "Automatically wears an equipment set.",
	AUTOMATION_ACTION_CHARACTER_EQUIPSET_HELP = "The name of the equipment set to wear must match the exact name of a set stored in the Equipment Manager of the Character Info panel.",
	AUTOMATION_ACTION_CHARACTER_EQUIPSET_INVALID = "Failed to change equipment set: Set %s does not exist.",
	AUTOMATION_ACTION_MAP_SCANS_BROADCAST = "Toggle location broadcast",
	AUTOMATION_ACTION_MAP_SCANS_BROADCAST_DESCRIPTION = "Toggles whether or not you will appear on other players' map scans.",
	AUTOMATION_ACTION_MAP_SCANS_BROADCAST_DISABLED = "Map scan location broadcast has been disabled.",
	AUTOMATION_ACTION_MAP_SCANS_BROADCAST_ENABLED = "Map scan location broadcast has been enabled.",
	AUTOMATION_ACTION_MAP_SCANS_BROADCAST_ERROR = "Failed to toggle map scan location broadcast: %s",
	AUTOMATION_ACTION_NAMEPLATES_ENABLE = "Toggle customizations",
	AUTOMATION_ACTION_NAMEPLATES_ENABLE_DESCRIPTION = "Toggles whether or not nameplates will be customized.",
	AUTOMATION_ACTION_NAMEPLATES_ENABLE_DISABLED = "Nameplate customizations have been disabled.",
	AUTOMATION_ACTION_NAMEPLATES_ENABLE_ENABLED = "Nameplate customizations have been enabled.",
	AUTOMATION_ACTION_NAMEPLATES_ENABLE_ERROR = "Failed to toggle nameplate customizations: %s",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS = "Toggle friendly NPC nameplates",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_DESCRIPTION = "Toggles whether or not friendly nameplates for NPCs will be shown.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_DISABLED = "Friendly NPC nameplates have been disabled.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_ENABLED = "Friendly NPC nameplates have been enabled.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_ERROR = "Failed to toggle friendly NPC nameplates: %s",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS = "Toggle friendly player nameplates",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_DESCRIPTION = "Toggles whether or not friendly nameplates for other players will be shown.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_DISABLED = "Friendly player nameplates have been disabled.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_ENABLED = "Friendly player nameplates have been enabled.",
	AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_ERROR = "Failed to toggle friendly nameplates: %s",
	AUTOMATION_ACTION_OPTIONS_HELP = "The macro condition must evaluate to any of the following options: %s.",
	AUTOMATION_ACTION_PROFILE_CHANGE = "Change profile",
	AUTOMATION_ACTION_PROFILE_CHANGE_DESCRIPTION = "Changes your currently selected profile.",
	AUTOMATION_ACTION_PROFILE_CHANGE_ERROR = "Failed to swap profiles: %s",
	AUTOMATION_ACTION_PROFILE_CHANGE_HELP = "The name of the profile to swap into will be matched case-insensitively and only need to be a partial match. For an exact match enclose the profile name in quotation marks (\"\").",
	AUTOMATION_ACTION_ROLEPLAY_STATUS = "Change roleplay status",
	AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_IC = "Roleplay status has been changed to in character.",
	AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_OOC = "Roleplay status has been changed to out of character.",
	AUTOMATION_ACTION_ROLEPLAY_STATUS_DESCRIPTION = "Changes your current roleplay status (in-character or out-of-character).",
	AUTOMATION_ACTION_ROLEPLAY_STATUS_ERROR = "Failed to change roleplay status: %s",
	AUTOMATION_CATEGORY_CHARACTER = "Character",
	AUTOMATION_CATEGORY_MAP_SCANS = "Map scans",
	AUTOMATION_CATEGORY_NAMEPLATES = "Nameplates",
	AUTOMATION_CATEGORY_PROFILE = "Profile",
	AUTOMATION_CONDITION_ROLEPLAY_STATUS_ERROR = "Failed to check 'rpstatus' condition: %s",
	AUTOMATION_ERROR_INVALID_OPTION = "invalid option '%1$s' (expected any of the following: %s)",
	AUTOMATION_ERROR_INVALID_PROFILE = "unable to find a profile named '%s'",
	AUTOMATION_MODULE_DESCRIPTION = "Allows configuring actions such as profile swaps and roleplay status changes to occur automatically.",
	AUTOMATION_MODULE_NAME = "Automation",
	AUTOMATION_MODULE_SETTINGS_HELP = "Select an action from the dropdown below and then enter a macro condition string into the displayed text field.",
	AUTOMATION_MODULE_SETTINGS_TITLE = "Automation settings",
	AUTOMATION_STATE_IC = "ic",
	AUTOMATION_STATE_OOC = "ooc",
	AUTOMATION_STATE_UNSET = "nochange",
	AUTOMATION_TEST_BUTTON = "Test condition",
	AUTOMATION_TEST_HELP = "Executes the supplied macro condition, printing the option it would select to the chat frame.",
	AUTOMATION_TEST_OUTPUT = "Test condition result: %s",
	AUTOMATION_PROFILE_CREATE = "Create profile",
	AUTOMATION_PROFILE_CREATE_HELP = "Creates a new profile.|n|nProfiles can be used to create character-specific rulesets for profile automation.",
	AUTOMATION_PROFILE_CREATE_DIALOG_TITLE = "Enter a name for the new automation profile.",
	AUTOMATION_PROFILE_CREATE_DIALOG_BUTTON1 = "Create",
	AUTOMATION_PROFILE_COPY = "Copy profile",
	AUTOMATION_PROFILE_COPY_HELP = "Copies all stored rules from this profile into the currently enabled one.|n|nThis will |cnRED_FONT_COLOR:irreversibly replace|r all rules configured on the current profile.",
	AUTOMATION_PROFILE_COPY_DIALOG_TITLE = "Are you sure you want to replace all automation rules in the profile |W|cnGREEN_FONT_COLOR:%s|r|w with the rules from the profile |W|cnGREEN_FONT_COLOR:%s|r|w?",
	AUTOMATION_PROFILE_COPY_DIALOG_BUTTON1 = "Copy",
	AUTOMATION_PROFILE_ENABLE = "Enable profile",
	AUTOMATION_PROFILE_ENABLE_HELP = "Enables this profile for the current character.",
	AUTOMATION_PROFILE_DELETE = "Delete profile",
	AUTOMATION_PROFILE_DELETE_HELP = "Deletes this profile.|n|nThis is an |cnRED_FONT_COLOR:irreversible|r process; deleted profiles cannot be restored.",
	AUTOMATION_PROFILE_DELETE_DIALOG_TITLE = "Are you sure you want to delete the profile |W|cnGREEN_FONT_COLOR:%s|r|w?",
	AUTOMATION_PROFILE_RESET = "Reset profile",
	AUTOMATION_PROFILE_RESET_HELP = "Resets all stored rules on the currently enabled profile.|n|nThis will |cnRED_FONT_COLOR:irreversibly delete|r all rules configured on the current profile.",
	AUTOMATION_PROFILE_RESET_DIALOG_TITLE = "Are you sure you want to reset all automation rules in the profile |W|cnGREEN_FONT_COLOR:%s|r|w?",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- MISC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	PATTERN_ERROR = "Error in pattern.",
	PATTERN_ERROR_TAG = "Error in pattern: unclosed text tag.",
	SCRIPT_UNKNOWN_EFFECT = "Script error, unknown FX",
	SCRIPT_ERROR = "Error in script.",
	NEW_VERSION_TITLE = "New update available",
	NEW_VERSION = "|cff00ff00A new version of Total RP 3 (v %s) is available.\n\n|cffffff00We strongly encourage you to stay up-to-date.|r\n\nThis message will only appear once per session and can be disabled in the settings (General settings => Miscellaneous).",
	BROADCAST_PASSWORD = "|cffff0000There is a password placed on the broadcast channel (%s).\n|cffff9900TRP3 won't try again to connect to it but you won't be able to use some features like players location on map.\n|cff00ff00You can disable or change the broadcast channel in the TRP3 general settings.",
	BROADCAST_PASSWORDED = "|cffff0000The user|r %s |cffff0000just placed a password on the broadcast channel (%s).\n|cffff9900If you don't know that password, you won't be able to use features like players location on the map.",
	BROADCAST_10 = "|cffff9900You already are in 10 channels. TRP3 won't try again to connect to the broadcast channel but you won't be able to use some features like players location on map.",
	BROADCAST_OFFLINE_DISABLED = "Broadcast has been disabled.",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- CHAT LINKS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	CL_REQUESTING_DATA = "Requesting link data from %s.",
	CL_EXPIRED = "This link has expired.",
	CL_PLAYER_PROFILE = "Player profile",
	CL_OPEN_PROFILE = "Open profile",
	CL_IMPORT_PROFILE = "Import profile",
	CL_GLANCE = "At-first-glance",
	CL_IMPORT_GLANCE = "Import at-first-glance",
	CL_COMPANION_PROFILE = "Companion profile",
	CL_IMPORT_COMPANION = "Import companion profile",
	CL_OPEN_COMPANION = "Open companion profile",
	CL_VERSIONS_DIFFER = [[This link has been generated using a different version of Total RP 3.

Importing content coming from a different version may cause issues in case of incompatibilities. Do you want to proceed anyway?]],

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- COMMANDS
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	COM_LIST = "List of commands:",
	COM_SWITCH_USAGE = "Usage: |cff00ff00/trp3 switch main|r to switch main frame or |cff00ff00/trp3 switch toolbar|r to switch the toolbar.",
	COM_RESET_USAGE = "Usage: |cff00ff00/trp3 reset frames|r to reset all frames positions.",
	COM_RESET_RESET = "The frames positions have been reset!",
	COM_STASH_DATA = [[|cffff0000Are you sure you want to stash away your Total RP 3 data?|r

Your profiles, companions profiles and settings will be temporarily stashed away and your UI will reload with empty data, as if your installation of Total RP 3 was brand new.
|cff00ff00Use the same command again (|cff999999/trp3 stash|cff00ff00) to restore your data.|r]],
	OPTION_ENABLED_TOAST = "Option enabled",
	OPTION_DISABLED_TOAST = "Option disabled",
	MORE_MODULES_2 = [[{h2:c}Optional modules{/h2}
{h3}Total RP 3: Extended{/h3}
|cff9999ffTotal RP 3: Extended|r add the possibility to create new content in WoW: campaigns with quests and dialogues, items, documents (books, signs, contracts, …) and many more!
{link*https://www.curseforge.com/wow/addons/total-rp-3-extended*Download on CurseForge}

{h3}TRP3 Currently Frame{/h3}
Adds a standalone frame to your UI that displays your "Currently" text and allows you to edit it easily.
{link*https://www.curseforge.com/wow/addons/trp3-currently-frame*Download on CurseForge}

{h3}TRP3 Location Toggle{/h3}
Adds a simple button to the toolbar to toggle on and off the map scan location feature.
{link*https://www.curseforge.com/wow/addons/trp3-location-toggle*Download on CurseForge}
]],

	THANK_YOU_1 = [[{h1:c}Total RP 3{/h1}
{p:c}{col:6eff51}Version %s (build %s){/col}{/p}
{p:c}{link*http://totalrp3.info*TotalRP3.info} — {twitter*TotalRP3*@TotalRP3} {/p}
{p:c}{link*http://discord.totalrp3.info*Join us on Discord}{/p}

{h2}{icon:INV_Eng_gizmo1:20} Created by{/h2}
%AUTHORS$s

{h2}{icon:QUEST_KHADGAR:20} The Rest of the Team{/h2}
%CONTRIBUTORS$s

{h2}{icon:THUMBUP:20} Acknowledgements{/h2}
{col:ffffff}Logo and minimap button icon:{/col}
- {link*https://twitter.com/Kelandiir*@Kelandiir}

{col:ffffff}Our pre-alpha QA team:{/col}
%TESTERS$s

{col:ffffff}Thanks to all our friends for their support all these years:{/col}
- For Telkos: Kharess, Kathryl, Marud, Solona, Stretcher, Lisma...
- For Ellypse: The guilds Eglise du Saint Gamon, Maison Celwë'Belore, Mercenaires Atal'ai, and more particularly Erzan, Elenna, Caleb, Siana and Adaeria

{col:ffffff}For helping us creating the Total RP guild on Kirin Tor (EU):{/col}
%GUILD_MEMBERS$s

{col:ffffff}Thanks to Horionne for sending us the magazine Gamer Culte Online #14 with an article about Total RP.{/col}]],

	MO_ADDON_NOT_INSTALLED = "The %s add-on is not installed, custom Total RP 3 integration disabled.",
	MO_SCRIPT_ERROR = "This module encountered a fatal script error.",
	MO_TOOLTIP_CUSTOMIZATIONS_DESCRIPTION = "Add custom compatibility for the %s add-on, so that your tooltip preferences are applied to Total RP 3's tooltips.",
	MO_CHAT_CUSTOMIZATIONS_DESCRIPTION = "Add custom compatibility for the %s add-on, so that chat messages and player names are modified by Total RP 3 in that add-on.",
	CO_TOOLTIP_PREFERRED_OOC_INDICATOR = "Preferred OOC indicator",
	CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT = "Text: ",
	CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON = "Icon: ",
	PR_EXPORT_WARNING_TITLE = "Warning:",
	PR_EXPORT_WARNING_WINDOWS = [[Please note that some advanced text editing tools like Microsoft Word or Discord will reformat special characters like quotes, altering the content of the data.

If you are planning on copying the text below inside a document, please use simpler text editing tools that do not automatically change characters, like Notepad.]],
	PR_EXPORT_WARNING_MAC = [[Please note that some advanced text editing tools like Text Edit or Discord will reformat special characters like quotes, altering the content of the data.

If you are planning on copying the text below inside a document, please use simpler text editing tools that do not automatically change characters (in Text Edit go to Format > Make Plain Text before pasting)]],
	BW_COLOR_PRESET_TITLE = "Color presets",
	BW_COLOR_PRESET_SAVE = "Save current color",
	BW_COLOR_PRESET_RENAME = "Rename %s preset",
	BW_COLOR_PRESET_DELETE = "Delete %s preset",
	CL_DIRECTORY_PLAYER_PROFILE = "Directory player profile",
	CL_DIRECTORY_COMPANION_PROFILE = "Directory companion profile",
	CL_CONTENT_SIZE = [[Size: %s]],
	THANK_YOU_ROLE_AUTHOR = "Author",
	THANK_YOU_ROLE_CONTRIBUTOR = "Contributor",
	THANK_YOU_ROLE_COMMUNITY_MANAGER = "Community Manager",
	THANK_YOU_ROLE_TESTER = "QA Team",
	THANK_YOU_ROLE_GUILD_MEMBER = "Guild Member",
	CL_SENT_BY = "Link sent by: %s",
	CL_TYPE = "TRP3 Link type: %s",
	CL_MAKE_IMPORTABLE_SIMPLER = [[Make this %s link importable?

People will be able to copy and use the content of the link.]],
	CL_MAKE_IMPORTABLE_BUTTON_TEXT = "Make importable",
	CL_MAKE_NON_IMPORTABLE = "Viewable only",
	CL_TOOLTIP = "Create a chat link",
	CL_DOWNLOADING = "Downloading: %0.1f %%",
	CL_SENDING_COMMAND = "Sending command…",
	CO_UI_RELOAD_WARNING = [[The interface needs to be reloaded in order for the changes to be applied.

Would you like to reload the interface now?]],
	TT_ELVUI_SKIN = "ElvUI skin",
	TT_ELVUI_SKIN_ENABLE_TOOLTIPS = "Skin tooltips",
	TT_ELVUI_SKIN_ENABLE_TARGET_FRAME = "Skin target frame",
	MAP_BUTTON_SUBTITLE_80_DISABLED = "Scans temporarily unavailable due to 8.0 changes",
	CO_ADVANCED_SETTINGS = "Advanced settings",
	CO_ADVANCED_SETTINGS_MENU_NAME = "Advanced",
	CO_ADVANCED_SETTINGS_POPUP = [[You have just modified an advanced setting.

Please keep in mind that changing those settings might alter your experience with the add-on and could prevent some features from working correctly. Use at your own risk.]],
	CO_ADVANCED_SETTINGS_RESET = "Reset advanced settings",
	CO_ADVANCED_SETTINGS_RESET_TT = "Reset all the advanced settings to their default value. Use this if you have issues after modifying the settings.",
	CO_GENERAL_BROADCAST_C = "Broadcast channel name",
	CO_ADVANCED_BROADCAST = "Add-on communications",
	CO_ADVANCED_LANGUAGES = "Languages",
	CO_ADVANCED_LANGUAGES_REMEMBER = "Remember last language used",
	CO_ADVANCED_LANGUAGES_REMEMBER_TT = "Total RP 3 will remember what language you were using before logging off and automatically select this language back on next login.",
	CO_TOOLTIP_CURRENT_LINES = "Max \"Currently\" line breaks",
	REG_PLAYERS = "Players",
	CO_LOCATION_DISABLE_WAR_MODE = "Disable location when in War Mode",
	CO_LOCATION_DISABLE_WAR_MODE_TT = "You will not respond to location requests from other players when you have War Mode enabled and you are outside of a |cff69CCF0Sanctuary|r.\n\nThis option is particularly useful to avoid abuses of the location system to track you.",
	CO_LOCATION_SHOW_DIFFERENT_WAR_MODES = "Show players in different War Mode",
	CO_LOCATION_SHOW_DIFFERENT_WAR_MODES_TT = "Players who are currently in the zone but have a different War Mode status than you will be shown on the map, with a lower opacity and a special icon in the tooltip.",
	REG_LOCATION_DIFFERENT_WAR_MODE = "Different War Mode",
	CO_ADVANCED_BROADCAST_CHANNEL_ALWAYS_LAST = "Keep broadcast channel last",
	CO_ADVANCED_BROADCAST_CHANNEL_ALWAYS_LAST_TT = "This option will make sure that the broadcast channel is always the last channel in your channels list.",
	REG_PLAYER_ABOUT_MUSIC_THEME = "Character music theme",
	REG_PLAYER_EDIT_MUSIC_THEME = "Music theme",
	LANG_CHANGE_CAUSED_REVERT_TO_DEFAULT = "Current spoken language reverted to default %s because you no longer know the previously selected language %s.",
	CO_ADVANCED_LANGUAGE_WORKAROUND = "Enable workaround against language reset",
	CO_ADVANCED_LANGUAGE_WORKAROUND_TT = "Since patch 8.0.1 the game will reset the selected language to the default language for your faction during every loading screen. This workaround makes sure to restore the selected language after a loading screen.",

	REG_REPORT_PLAYER_PROFILE = "Report profile to |cff449fe0Blizzard|r",
	REG_REPORT_PLAYER_PROFILE_TT = [[You can report a profile that infringe on Blizzard's Terms of Service. This can include harassment, doxxing, hate speech, obscene content or other form of disruptive content.

|cffff0000Please note that this option is NOT to report RP profiles of disputable quality or griefing. Abuses of this feature are punishable!]],
	REG_REPORT_PLAYER_TEMPLATE = "This player is using the RP profile addon %s to share content against the Terms of Service.",
	REG_REPORT_PLAYER_TEMPLATE_DATE = "The addon data was transferred through logged addon messages on %s.",
	REG_REPORT_PLAYER_TEMPLATE_TRIAL_ACCOUNT = "This player was on a trial account.",
	REG_REPORT_PLAYER_OPEN_URL = [[You can only report players directly from within the game if you can target them (use TRP3's target frame button).

If you wish to report %s's profile and you cannot target them you will need to open a ticket with Blizzard's support using the link bellow.]],
	REG_REPORT_PLAYER_OPEN_URL_160 = [[If you wish to report %s's profile, you will need to open a ticket with Blizzard's support using the link below.]],
	NEW_VERSION_BEHIND = "You are currently %s versions behind and are missing on many bug fixes and new features. Other players might not be able to see your profile correctly. Please consider updating the add-on.",
	REG_PLAYER_RELATIONSHIP_STATUS_UNKNOWN = "Do not show",
	REG_PLAYER_RELATIONSHIP_STATUS_SINGLE = "Single",
	REG_PLAYER_RELATIONSHIP_STATUS_TAKEN = "Taken",
	REG_PLAYER_RELATIONSHIP_STATUS_MARRIED = "Married",
	REG_PLAYER_RELATIONSHIP_STATUS_DIVORCED = "Divorced",
	REG_PLAYER_RELATIONSHIP_STATUS_WIDOWED = "Widowed",
	REG_PLAYER_RELATIONSHIP_STATUS = "Relationship status",
	REG_PLAYER_RELATIONSHIP_STATUS_TT = [[Indicate the relationship status of your character. Select "Do not show" if you wish to keep that information hidden.]],
	REG_NOTES_PROFILE = "Notes",
	REG_NOTES_PROFILE_TT = "Open the notes window for the target character.",
	REG_PLAYER_NOTES = "Notes",
	REG_PLAYER_NOTES_PROFILE = "Notes from %s",
	REG_PLAYER_NOTES_PROFILE_NONAME = "Profile notes",
	REG_PLAYER_NOTES_PROFILE_HELP = "These private notes are tied to your current profile and will change based on what profile you currently have active.",
	REG_PLAYER_NOTES_ACCOUNT = "Common notes",
	REG_PLAYER_NOTES_ACCOUNT_HELP = "These private notes are tied to your account and will be shared with all of your profiles.",

	BINDING_NAME_TRP3_OPEN_TARGET_PROFILE = "Open target profile",
	BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS = "Toggle character status",

	REG_COMPANION_BIND_TO_PET = "Pet",
	UI_PET_BROWSER_ACCEPT = "Assign",
	UI_PET_BROWSER_EMPTY_TEXT = "You have no pets that can be linked to a profile.",
	UI_PET_BROWSER_INTRO_TEXT = "Select a pet with the buttons below and click |cffffff00Assign|r to link it to the profile.",
	UI_PET_BROWSER_BOUND_WARNING = "|cffff0000Warning:|r This pet is currently linked to the profile |cff00ff00%1$s|r. Linking a profile to this pet will replace the current profile.",
	UI_PET_BROWSER_NAME_WARNING = "|cffff0000Warning:|r This pet has not been renamed. We recommend renaming the pet to prevent showing this profile on other pets you own with the same name.",
	REG_PLAYER_MISC_PRESET_PRONOUNS = "Pronouns",

	COPY_DROPDOWN_POPUP_TEXT = "Copy with %1$s. Paste with %2$s.\nThis frame will close upon copy.",
	COPY_SYSTEM_MESSAGE = "Copied to clipboard.",
	UNIT_POPUPS_MODULE_NAME = "Unit Popups",
	UNIT_POPUPS_MODULE_DESCRIPTION = "Adds integration with right-click menus on unit frames and player names in chat frames.",
	UNIT_POPUPS_ROLEPLAY_OPTIONS_HEADER = "Roleplay Options",
	UNIT_POPUPS_OPEN_PROFILE = "Open Profile",
	UNIT_POPUPS_CURRENT_PROFILE = "Current Profile",
	UNIT_POPUPS_CURRENT_PROFILE_NAME = "Current Profile: %1$s",
	UNIT_POPUPS_CHARACTER_STATUS = "Character Status",
	UNIT_POPUPS_CONFIG_MENU_TITLE = "Menu settings",
	UNIT_POPUPS_CONFIG_PAGE_TEXT = "Menu settings",
	UNIT_POPUPS_CONFIG_PAGE_HELP = "The unit popups module adds additional entries to the right-click menus found on unit frames and names in the chat frame.",
	UNIT_POPUPS_CONFIG_ENABLE_MODULE = "Module |cff00ff00enabled|r",
	UNIT_POPUPS_MODULE_DISABLE_WARNING = "A user interface reload is required to disable the unit popups module.|n|n|cffff0000Warning:|r Once disabled, this module can only be re-enabled from the |cffffcc00Modules status|r page.|n|nAre you sure you want to disable this module?",
	UNIT_POPUPS_CONFIG_ENTRIES_HEADER = "Menu entries",
	UNIT_POPUPS_CONFIG_SHOW_HEADER_TEXT = "Show header text",
	UNIT_POPUPS_CONFIG_SHOW_HEADER_TEXT_HELP = "If checked, shows a \"Roleplay Options\" header above any added menu entries.",
	UNIT_POPUPS_CONFIG_SHOW_SEPARATOR = "Show separator",
	UNIT_POPUPS_CONFIG_SHOW_SEPARATOR_HELP = "If checked, shows a separator bar above any added menu entries.",
	UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS = "Show character status toggle",
	UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS_HELP = "If checked, adds a checkbox to your own unit frame menu that allows you to toggle your in-character/out-of-character status.",
	UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE = "Show open profile button",
	UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE_HELP = "If checked, adds a button that opens the selected units' RP profile when clicked.|n|nThis option will be visible on all unit frame and chat menus.",
	UNIT_POPUPS_CONFIG_VISIBILITY_HEADER = "Visibility options",
	UNIT_POPUPS_CONFIG_DISABLE_OUT_OF_CHARACTER = "Hide menu entries while out of character",
	UNIT_POPUPS_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP = "If checked, additional menu entries will not be shown while out-of-character.",
	UNIT_POPUPS_CONFIG_DISABLE_IN_COMBAT = "Hide menu entries while in combat",
	UNIT_POPUPS_CONFIG_DISABLE_IN_COMBAT_HELP = "If checked, additional menu entries will not be shown while in combat.",
	UNIT_POPUPS_CONFIG_DISABLE_IN_INSTANCES = "Hide menu entries while in instances",
	UNIT_POPUPS_CONFIG_DISABLE_IN_INSTANCES_HELP = "If checked, additional menu entries will not be shown while in instanced content.",
	UNIT_POPUPS_CONFIG_DISABLE_ON_UNIT_FRAMES = "Hide menu entries on unit frames",
	UNIT_POPUPS_CONFIG_DISABLE_ON_UNIT_FRAMES_HELP = "If checked, additional menu entries will not be shown in menus activated by right-clicking unit frames.",

	NAMEPLATES_MODULE_NAME = "Nameplates",
	NAMEPLATES_MODULE_DESCRIPTION = "Enables the customization of nameplates with information obtained from roleplay profiles.",
	NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL = "This module was disabled automatically due to a conflict with another module or addon.",
	NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY = "This module was disabled automatically due to a missing dependency.",

	NAMEPLATES_CONFIG_MENU_TITLE = "Nameplates",
	NAMEPLATES_CONFIG_PAGE_TEXT = "Nameplate settings",
	NAMEPLATES_CONFIG_VISIBILITY_HEADER = "Visibility settings",
	NAMEPLATES_CONFIG_DISABLE_IN_COMBAT = "Disable customizations when in combat",
	NAMEPLATES_CONFIG_DISABLE_IN_COMBAT_HELP = "If checked, disables nameplate customizations while you are in combat.",
	NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER = "Disable customizations when OOC",
	NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP = "If checked, disables all nameplate customizations while you are out of character.",
	NAMEPLATES_CONFIG_ELEMENT_HEADER = "Customization settings",
	NAMEPLATES_CONFIG_CUSTOMIZE_NAMES = "Show custom names",
	NAMEPLATES_CONFIG_CUSTOMIZE_NAMES_HELP = "Controls how custom names for units will be displayed.",
	NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS = "Show custom name colors",
	NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS_HELP = "If checked, overrides the color of name texts with the class color of a units' profile.",
	NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS = "Show custom health colors",
	NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS_HELP = "If checked, overrides the color of health bars with the class color of a units' profile.",
	NAMEPLATES_CONFIG_CUSTOMIZE_TITLES = "Show prefix titles",
	NAMEPLATES_CONFIG_CUSTOMIZE_TITLES_HELP = "If checked, shows the short title of a unit on nameplates before their name.",
	NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES = "Show full length titles",
	NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES_HELP = "If checked, shows the full title of a unit on nameplates.|n|nFor |cff449fe0Blizzard|r and |cff9966ffKui|r nameplates, full titles are only shown in name-only mode.",
	NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS = "Show roleplay status indicator",
	NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS_HELP = "If checked, shows an indicator of a units' roleplay status (IC or OOC) on nameplates.",
	NAMEPLATES_CONFIG_CUSTOMIZE_ICONS = "Show icons",
	NAMEPLATES_CONFIG_CUSTOMIZE_ICONS_HELP = "If checked, shows profile icons on nameplates.",
	NAMEPLATES_CONFIG_CUSTOMIZE_OOC_UNITS = "Customize OOC units",
	NAMEPLATES_CONFIG_CUSTOMIZE_OOC_UNITS_HELP = "Controls the customization of out of character units.",
	NAMEPLATES_CONFIG_CUSTOMIZE_NON_ROLEPLAY_UNITS = "Customize non-roleplay units",
	NAMEPLATES_CONFIG_CUSTOMIZE_NON_ROLEPLAY_UNITS_HELP = "Controls the customization of units that do not have roleplay profiles.",
	NAMEPLATES_CONFIG_CUSTOMIZE_NPC_UNITS = "Customize NPC units",
	NAMEPLATES_CONFIG_CUSTOMIZE_NPC_UNITS_HELP = "Controls the customization of NPC units.",
	NAMEPLATES_CONFIG_ICON_SIZE = "Icon size",
	NAMEPLATES_CONFIG_ICON_SIZE_HELP = "Configures the size of icons displayed on nameplates if the |cffffff00Show icons|r option is enabled.",
	NAMEPLATES_CONFIG_ACTIVE_QUERY = "Automatically fetch profiles",
	NAMEPLATES_CONFIG_ACTIVE_QUERY_HELP = "If checked, automatically fetches roleplay profiles for units with nameplates attached.",
	NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK = "Use class color by default",
	NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK_HELP = "If checked, this enables the use of class colors for names and health bars as a fallback for units that do not have a custom class color in their profile.|n|nUnits that do not have roleplay profiles are unaffected by this setting and will not be class-colored.",
	NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY = "Hide bars on |cff449fe0Blizzard|r nameplates",
	NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY_HELP = "If checked, this enables the use of name-only mode for |cff449fe0Blizzard|r nameplates.|n|nIn this mode, all nameplates will have their health bars hidden, including those of enemy units and other players with or without roleplay profiles.|n|nThis option requires a UI reload to take effect.",
	NAMEPLATES_CONFIG_UNIT_STATE_SHOW = "Show",
	NAMEPLATES_CONFIG_UNIT_STATE_SHOW_HELP = "Show nameplates for these units with full customizations applied.|n|nVisibility of these nameplates may be overridden by other settings.",
	NAMEPLATES_CONFIG_UNIT_STATE_HIDE = "Always hide",
	NAMEPLATES_CONFIG_UNIT_STATE_HIDE_HELP = "Always hide nameplates for these units.",
	NAMEPLATES_CONFIG_UNIT_STATE_DISABLE = "Do not customize",
	NAMEPLATES_CONFIG_UNIT_STATE_DISABLE_HELP = "Ignore nameplates for these units and do not customize them.",
	NAMEPLATES_CONFIG_UNIT_NAME_FULL = "Show full name",
	NAMEPLATES_CONFIG_UNIT_NAME_FULL_HELP = "Shows the full name of units.",
	NAMEPLATES_CONFIG_UNIT_NAME_FIRST = "Show first name",
	NAMEPLATES_CONFIG_UNIT_NAME_FIRST_HELP = "Only show first names of players rather than full names.|n|nThis will not work with companion units and profiles received from other roleplay addons.",
	NAMEPLATES_CONFIG_UNIT_NAME_ORIGINAL = "Show original name",
	NAMEPLATES_CONFIG_UNIT_NAME_ORIGINAL_HELP = "Shows the original unmodified player name of the unit.",

	BLIZZARD_NAMEPLATES_MODULE_NAME = "Blizzard Nameplates",
	BLIZZARD_NAMEPLATES_MODULE_DESCRIPTION = "Enables the customization of Blizzard's default nameplates.",

	KUI_NAMEPLATES_MODULE_NAME = "Kui Nameplates",
	KUI_NAMEPLATES_MODULE_DESCRIPTION = "Enables the customization of Kui nameplates.",
	KUI_NAMEPLATES_WARN_OUTDATED_MODULE = "The Kui |cff9966ffNameplates|r plugin for Total RP 3 has been integrated directly into the main addon.|n|nThe old plugin has been disabled automatically, and |cffffcc00we recommend that you uninstall it|r as it is no longer needed.",

	CONFIG_COMMS_SETTINGS_HEADER = "Communications settings",
	CONFIG_COMMS_QUEUE_POOL_COUNT = "Queue pool size",
	CONFIG_COMMS_QUEUE_POOL_COUNT_DESCRIPTION = "Controls the size of the queue pool used for profile communications.|n|nLower values will reduce latency of addon communications for non-RP profile data, but may increase the amount of time before other players begin to receive any profile data at all in high load scenarios.",
	CONFIG_COMMS_QUEUE_POOL_WEIGHT_THRESHOLD = "Queue pool data weight threshold",
	CONFIG_COMMS_QUEUE_POOL_WEIGHT_THRESHOLD_DESCRIPTION = "Controls the minimum weight your RP profile data must be before queue pools will be used.|n|nFor larger profiles, increasing this value may |cffff0000severely deteriorate|r the performance of all addon communications.",

	CREDITS_THANK_YOU_SECTION_1 = [[{h1:c}Total RP 3{/h1}]],
	CREDITS_THANK_YOU_SECTION_2 = [[{h2}%1$s Created by{/h2}]],
	CREDITS_THANK_YOU_SECTION_3 = [[{h2}%1$s The Rest of the Team{/h2}]],
	CREDITS_THANK_YOU_SECTION_4 = [[{h2}%1$s Acknowledgements{/h2}]],
	CREDITS_THANK_YOU_SECTION_5 = [[{col:ffffff}Logo and minimap button icon:{/col} %1$s]],
	CREDITS_THANK_YOU_SECTION_6 = [[{col:ffffff}Our pre-alpha QA team:{/col}]],
	CREDITS_THANK_YOU_SECTION_7 = [[{col:ffffff}Thanks to all our friends for their support all these years:{/col}]],
	CREDITS_THANK_YOU_SECTION_8 = [[{col:ffffff}For helping us creating the Total RP guild on Kirin Tor (EU):{/col}]],
	CREDITS_THANK_YOU_SECTION_9 = [[{col:ffffff}Thanks to Horionne for sending us the magazine Gamer Culte Online #14 with an article about Total RP.{/col}]],
	CREDITS_THANK_YOU_SECTION_10 = [[{col:ffffff}Thanks to our active community members on Discord:{/col}]],
	CREDITS_THANK_YOU_SECTION_11 = [[{col:ffffff}Thanks to Bor Blasthammer for his help during BfA testing.{/col}]],

	CREDITS_THANK_YOU_ROLE_1 = "Project Lead",
	CREDITS_THANK_YOU_ROLE_2 = "Author",
	CREDITS_THANK_YOU_ROLE_3 = "Developer",
	CREDITS_THANK_YOU_ROLE_4 = "Community Manager",
	CREDITS_THANK_YOU_ROLE_5 = "Mascot",

	CREDITS_VERSION_TEXT = "Version %s",
	CREDITS_DISCORD_LINK_TEXT = "Join us on Discord",
	CREDITS_WEBSITE_LINK_TEXT = "Website",
	CREDITS_NAME_WITH_ROLE = "%1$s (%2$s)",
	CREDITS_GUILD_NAME = "<%1$s>",

	SLASH_CMD_HELP_USAGE = "Usage: %1$s",
	SLASH_CMD_HELP_COMMANDS = "Commands: %1$s",
	SLASH_CMD_HELP_EXAMPLES = "Examples: %1$s",
	SLASH_CMD_HELP_FIELDS = "Fields: %1$s",
	SLASH_CMD_LOCATION_HELP = "Controls whether or not your character will appear in roleplay map scans.",
	SLASH_CMD_LOCATION_HELP_ON = "%1$s will enable the broadcast of your characters' location.",
	SLASH_CMD_LOCATION_HELP_OFF = "%1$s will disable the broadcast of your characters' location.",
	SLASH_CMD_LOCATION_HELP_TOGGLE = "%1$s will toggle the current state of character location broadcasts.",
	SLASH_CMD_LOCATION_HELP_STATUS = "%1$s will display whether or not location broadcasts are enabled.",
	SLASH_CMD_LOCATION_FAILED = "Unknown location command: %s",
	SLASH_CMD_LOCATION_ENABLED = "Character location broadcast is enabled.",
	SLASH_CMD_LOCATION_DISABLED = "Character location broadcast is disabled.",
	SLASH_CMD_SET_HELP = "Changes the value associated with a field for your current profile.",
	SLASH_CMD_SET_HELP_ARG1 = "<field>",
	SLASH_CMD_SET_HELP_ARG2 = "[macro conditionals]",
	SLASH_CMD_SET_HELP_ARG3 = "<data...>",
	SLASH_CMD_SET_HELP_EXAMPLE1 = "Daydreaming about butterflies",
	SLASH_CMD_SET_HELP_EXAMPLE2 = "Happy Bear; Angry Elf",
	SLASH_CMD_SET_FAILED_INVALID_FIELD = "No profile field named %1$q exists.",
	SLASH_CMD_SET_FAILED_DEFAULT_PROFILE = "Your current profile cannot be updated as it is the default profile.",
	SLASH_CMD_SET_FAILED_INVALID_COLOR = "Failed to update %1$q field: %2$q is not a valid color string.",
	SLASH_CMD_SET_FAILED_INVALID_ICON = "Failed to update %1$q field: %2$q is not a valid icon name.",
	SLASH_CMD_SET_SUCCESS = "Successfully updated the %1$q field for your current profile.",
	MACRO_RPSTATUS_INVALID = "Unknown roleplay status: %s",

	LAUNCHER_CONFIG_MENU_TITLE = "Launcher settings",
	LAUNCHER_CONFIG_PAGE_DESCRIPTION = "The settings on this page control the behavior of various widgets that provide access to the Total RP 3 interface, such as minimap buttons.",
	LAUNCHER_CONFIG_LOCK_MINIMAP_BUTTON = "Lock minimap button",
	LAUNCHER_CONFIG_LOCK_MINIMAP_BUTTON_HELP = "If checked, prevent the minimap button from being draggable.",
	LAUNCHER_CONFIG_RESET_MINIMAP_BUTTON = "Reset minimap button position",
	LAUNCHER_CONFIG_RESET_MINIMAP_BUTTON_HELP = "Resets the position of the minimap button to the default location.",
	LAUNCHER_CONFIG_ADDON_COMPARTMENT = "Addon compartment",
	LAUNCHER_CONFIG_SHOW_ADDON_COMPARTMENT_BUTTON = "Show in addon compartment",
	LAUNCHER_CONFIG_SHOW_ADDON_COMPARTMENT_BUTTON_HELP = "If checked, display an entry for Total RP 3 in Blizzard's addon compartment menu located near the minimap.|n|nThis feature has no effect in Classic.",
	LAUNCHER_MODULE_NAME = "Launcher",
	LAUNCHER_MODULE_DESCRIPTION = "Provides user interface elements such as a minimap button to control the addon.",

	LAUNCHER_CONFIG_ACTIONS = "Launcher actions",
	LAUNCHER_ACTION_OPEN = "Toggle main window",
	LAUNCHER_ACTION_TOOLBAR = "Toggle toolbar",
	LAUNCHER_ACTION_STATUS = "Toggle roleplay status",
	LAUNCHER_ACTION_SETTINGS = "Open settings page",
	LAUNCHER_ACTION_DIRECTORY = "Open directory page",
	LAUNCHER_ACTION_PROFILES = "Open profiles page",
	LAUNCHER_ACTION_PLAYER = "Open current profile page",

	WHATS_NEW_25_4 = [[# Changelog version 2.4.3

## Added

- Added a setting to customize date formats displayed in the directory. (Thanks to Kisis for the initial work on it)
  - The default format now respects regional formats based on current game client.
  - Total RP 3: Extended will be updated to support this at a later date.

## Fixed

- Fixed tooltipData error showing since 10.0.2.
- Fixed map scan not working on WotLK Classic.
- Fixed potential taint issues leading to blocked actions.

]],
	WHATS_NEW_25_5 = [[# Changelog version 2.4.4

## Fixed

- Fixed "not currently playing" error messages sometimes showing up for players from specific realms.
- Fixed "Import profile" popup not properly resetting after importing a profile.

]],

	CO_MODULES_SUPPORTS_HOTRELOAD = "This module supports hot reload.",
	NAMEPLATES_CONFIG_PAGE_HELP = "Please note that only |cff449fe0Blizzard|r, |cff9966ffKui|r, and |cffa8deffPlater|r nameplates are currently supported. Refer to the help tip on each setting below for additional information.",
	PLATER_NAMEPLATES_MODULE_NAME = "Plater Nameplates",
	PLATER_NAMEPLATES_MODULE_DESCRIPTION = "Enables the customization of Plater nameplates.",
	PLATER_NAMEPLATES_WARN_OUTDATED_MODULE = "|cffa8deffPlater|r Nameplates is outdated.",
	PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR = "An error occured while importing the Plater mod.",

	CO_LOCATION_SHOW_OUT_OF_CHARACTER = "Show out of character players",
	CO_LOCATION_SHOW_OUT_OF_CHARACTER_TT = "If checked, show map pins for all players that are marked as out of character.",

	WHATS_NEW_25_6 = [[# Changelog version 2.4.5

## Added

- Added Plater support for RP nameplates customization. Thanks to Ghost for this addition.
- The TRP toolbar can now be set to only show while in character with the Toolbar display conditions setting (replacing Toolbar show on login).
- OOC characters are now hidden from the map scan.
  - You can re-enable them by checking "Show out of character players" in Register settings > Location settings. Pins with only OOC characters will appear faded.
  - Only players from this version onwards are recognized as OOC, so this may take some time to be accurate.

## Fixed

- Re-enabled right-click menu options (with the exception of the IC/OOC status toggle).
- Fixed dashboard dropdowns not showing the correct selected values.
- Fixed name-only nameplates setting not persisting upon logout.
- Fixed an issue with profiles showing as Unknown in the directory quick entries if the profile was received for the first time.

]],

	CO_TOOLBAR_VISIBILITY = "Display conditions",
	CO_TOOLBAR_VISIBILITY_HELP = "Configures the conditions under which the toolbar should be shown.|n|nThe visibility of the toolbar can be forcefully toggled by running the |cff00ff00/trp3 switch toolbar|r slash command or by right-clicking the minimap button.",
	CO_TOOLBAR_VISIBILITY_1 = "Always show",
	CO_TOOLBAR_VISIBILITY_2 = "Only show in-character",
	CO_TOOLBAR_VISIBILITY_3 = "Always hidden",

	NAMEPLATES_CONFIG_CUSTOMIZE_GUILD = "Show custom guild names",
	NAMEPLATES_CONFIG_CUSTOMIZE_GUILD_HELP = "If checked, show custom guild names on nameplates that support them.",
	NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES = "Disable customizations in instances",
	NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES_HELP = "If checked, disables nameplate customizations while in instances.|n|nIn instanced content friendly nameplates cannot be customized.",
	NAMEPLATES_CONFIG_MAX_NAME_CHARS = "Maximum name length",
	NAMEPLATES_CONFIG_MAX_NAME_CHARS_HELP = "The maximum number of characters to display for names and prefix titles. Names exceeding this length will be cropped.",
	NAMEPLATES_CONFIG_MAX_TITLE_CHARS = "Maximum title length",
	NAMEPLATES_CONFIG_MAX_TITLE_CHARS_HELP = "The maximum number of characters to display for full titles. Titles exceeding this length will be cropped.",
	NAMEPLATES_CONFIG_MAX_GUILD_NAME_CHARS = "Maximum guild name length",
	NAMEPLATES_CONFIG_MAX_GUILD_NAME_CHARS_HELP = "The maximum number of characters to display for guild names. Guild names exceeding this length will be cropped.",
	NAMEPLATES_CONFIG_PAGE_SETTINGS_MAY_REQUIRE_TOGGLE_HELP = "You may need to toggle your nameplates for any settings changes to take effect.",
	NAMEPLATES_CONFIG_SHOW_TARGET_UNIT = "Always show target unit",
	NAMEPLATES_CONFIG_SHOW_TARGET_UNIT_HELP = "If checked, your current target will always have its nameplate visible.",

	CO_TOOLTIP_VOICE_REFERENCE = "Show voice reference",
	REG_PLAYER_MISC_PRESET_GUILD_NAME = "Guild name",
	REG_PLAYER_MISC_PRESET_GUILD_RANK = "Guild rank",
	REG_PLAYER_MISC_PRESET_VOICE_REFERENCE = "Voice reference",
	DEFAULT_GUILD_RANK = "Member",

	CO_GENERAL_DISABLE_WELCOME_MESSAGE = "Disable welcome message",
	CO_GENERAL_DISABLE_WELCOME_MESSAGE_HELP = "Disables the welcome message displayed in the chat frame on login.",

	WHATS_NEW_25_7 = [[# Changelog version 2.4.6

## Added

- Added support for 10.0.7 furbolg language.
- Added voice reference, custom guild name and rank presets in additional info.
  - Voice reference will be shown in the tooltip if filled in.
  - Custom guild name/rank will replace the original fields in TRP tooltips.
  - You may disable either of these changes via tooltip settings ("Show voice reference" and "Show custom guild names").
- Added nameplates settings:
  - Name and title max length on nameplates
  - Display first name only
  - Display custom guild name
  - Disable customizations in instances
  - Disable customizations on NPCs
- IC/OOC fields from other players' profile are now selectable to make it easier to copy URLs.
- Added setting to disable the welcome message on login.

## Fixed

- Fixed an issue with "Unknown" names potentially showing on tooltips after a loading screen.
- Fixed an issue with the KuiNameplates module to properly fade/hide nameplates when appropriate.
- Fixed an issue where the target frame would stay hidden after a UI reload with a target selected.

]],

	WHATS_NEW_26_0 = [[# Changelog version 2.5.0

## Added

- Added 503 icons, 15 images and 70 musics from patch 10.1.
- Added Automation system, accessible in the settings
  - This allows you to automate actions based on macro conditionals.
  - Actions include changing your profile, your roleplay status, whether the map scan is enabled or not...
  - For a list of macro conditionals, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Macro-conditionals).
- Added Analytics module
  - **This is strictly opt-in and only applies to users of the Wago Addons client who enabled "Help addon developers".**
  - For more details, see [our wiki article](https://github.com/Total-RP/Total-RP-3/wiki/Analytics-in-Total-RP-3).
- Added entry in the new addon compartment located below the calendar button, with the same actions as the minimap button.
- Added tooltip indicator if the guild fields have been customized, as well as options to display both/either custom and in-game guild info.
- Added ability to get the party started.

## Changed

- "Always show target" nameplate option will now display the target nameplate even if it is OOC and "Hide out of character units" was enabled.

]],
	WHATS_NEW_26_1 = [[# Changelog version 2.5.1

## Fixed

- Fixed an error with the Prat module out if a player had no custom color.
- Fixed an error with chat links.
- Empty guild rank/name fields will now display default values in the tooltip.
- Fixed an issue with "No player named..." messages appearing when hovering players on realms with non-latin characters.

]],
	WHATS_NEW_26_2 = [[# Changelog version 2.5.2

## Fixed

- Fixed an issue with the Plater RP nameplates getting stuck on screen.

]],
	WHATS_NEW_26_3 = [[# Changelog version 2.5.3

## Fixed

- Prevented invalid dice roll messages from showing.
- Updated TaintLess library for patch 3.4.2.

]],
	WHATS_NEW_26_4 = [[# Changelog version 2.5.4

## Added

- Added 53 musics, 45 images and 169 icons from patch 10.1.5 and before (some previously encrypted icons).

## Fixed

- Fixed close/minimize/resize buttons positions for Retail.
- Fixed a bug with the dashboard potentially related to Prat.

]],
	WHATS_NEW_26_5 = [[# Changelog version 2.5.5

## Added

- Added 3 musics, 4 images and 76 icons from patch 10.1.7.
- Added setting to crop long guild names on RP nameplates.

## Fixed

- Improved icon browser performance to deal with an occasional addon loading issue.
- Fixed a recycling issue with RP nameplates when using Plater Nameplates.

]],
	WHATS_NEW_27_0 = [[# Changelog version 2.6.0

## Added

- Added 448 icons, 10 images and 118 musics from patch 10.2.
- Added 5 Classic icons from patch 3.4.3.
- Added profiles to the automation system to allow you to set different automation rules for different characters, especially useful for alternate forms, stance or specialization conditionals.
- Added a new "Launcher settings" category letting you control visibility of the minimap button and addon compartment entry, as well as modifying what actions are executed depending on how you click them (left/middle/right mouse button, with modifier key...).
- Added a guild members map scan.

## Changed

- Reworked the icon browser search to be asynchronous, in order to prevent issues related to the amount of icons in the game.
- Changed the nameplate visibility settings from checkboxes to dropdowns offering clearer control over which nameplates to display or hide.

## Fixed

- Fixed the size of the main window not persisting between sessions. **The position may be reset once upon login with the new version.**

]],
	MAP_SCAN_CHAR_GUILD_ONLY = "Scan for guild members",
	MAP_SCAN_CHAR_GUILD_ONLY_TITLE = "Guild",

	WHATS_NEW_27_1 = [[# Changelog version 2.6.1

## Fixed

- Fixed an issue with the nameplates addon detection which could cause the RP names not to apply.
- Fixed the shuffling of the map scans in the dropdown.
- Fixed the companion tooltip not showing on humanoid battle pets.
  - Battle pet types will still be shown incorrectly until Blizzard fixes the bug which caused the issue in the first place.

]],
	WHATS_NEW_27_2 = [[# Changelog version 2.6.2

## Fixed

- Fixed nameplate customization erroring in combat since a recent hotfix.
- Fixed custom names displaying on chat lines they're not supposed to (like preset emotes) while using Prat.

]],
	WHATS_NEW_27_3 = [[# Changelog version 2.7.0

## Added

- Added 97 icons and 11 musics from patch 10.2.5.
- Added support for party/raid unit tokens in the "/trp3 open" command.

## Changed

- The icon browser has been further updated with a new look:
  - The list of icons shown is now bigger.
  - The currently selected icon is now highlighted and shows first in the list.
  - The search will now ignore punctuation in the icon name.
  - A text indicator will appear if a search hasn't returned any result.
- Additional Information preset fields can no longer be renamed to prevent confusion on the field to modify.
  - Preset fields which were renamed have been turned into custom fields and may need to be set again.
- Keybindings have been moved to a dedicated Total RP 3 category.

## Fixed

- Fixed own pet nameplate not customizing.
- Fixed an issue when trying to import a profile with an invalid music (when importing a Retail profile on Classic for instance).
- Fixed an issue when viewing some icons on first glance slots.
- Fixed some profile fields showing outdated info on other RP addons.
- Fixed some fields not being properly cleaned when received from other addons.

]],
	WHATS_NEW_27_4 = [[# Changelog version 2.7.1

## Fixed

- Fixed the addon not loading on Mac.

]],
	WHATS_NEW_27_5 = [[# Changelog version 2.7.2

## Added

- Added 4 musics and 8 images from patch 10.2.5.

## Changed

- Icons in the browser have been made bigger once again.
- The icon browser in the glance editor is no longer smaller than everywhere else.

]],
	WHATS_NEW_28_0 = [[# Changelog version 2.8.0

## Added

- Added a small indicator at the bottom of the tooltip while receiving updates to a profile.

## Changed

- Chat links will no longer display the added number at the end of the name when sent. (We've also learned that after 1 comes 2, not 12.)

## Fixed

- Fixed tooltip display issues when using non-English characters.
- Fixed error when displaying some NPC companion nameplates.
- Fixed errors when receiving profiles with a music theme not listed in the current addon version.
- Pets will no longer be asked to provide their profiles directly, as they can't reply.
- Fixed an issue where the addon would wait indefinitely for a profile if the transfer was interrupted, preventing from ever receiving that profile again until reload.

]],
	WHATS_NEW_28_1 = [[# Changelog version 2.8.1

*Profile transfers will currently be much slower on Cataclysm Classic due to rate limit changes. We are looking into changes to alleviate this, but they will take time, please bear with us.*

## Fixed

- Fixed icons not showing in the tooltips on Classic.
- Fixed the "receiving profile" animated icon appearing as a green square on Classic.
- Fixed an issue when editing profiles with an invalid icon (for example, a Retail icon on Classic).
- Pasting a color code into the color picker field will now trim spaces that might have been copied with it to prevent issues.

]],
	WHATS_NEW_28_2 = [[# Changelog version 2.8.2

*The rate limit changes mentioned last version no longer apply in the outdoor world or garrisons. Instances are still heavily limited.*

## Added

- Added "Open Profile" right-click menu option for pets and battle pets.
- Added 94 icons and 47 images from patch 10.2.7 (and earlier).

## Fixed

- Fixed battle pets not being able to get a profile assigned on Cataclysm Classic.
  - As part of this fix, it is now possible to attach a profile to a non-renamed battle pet on Retail. It is still strongly advised to rename battle pets before assigning them a profile.
- Fixed map scan not working if the player was in Telogrus Rift.
- Fixed loading icon sometimes showing on companion tooltips.

]],
	WHATS_NEW_28_3 = [[# Changelog version 2.8.3

## Added

- Added "Open Profile" right-click menu option on Battle.net friends.
  - This will only be shown if the other player is in the same region and using the same client.

## Fixed

- Added a temporary workaround to prevent disconnects under specific conditions.
  - The proper fix will come from Blizzard, this is just a short-term safety measure.
- Fixed an issue where the Kui nameplates customization wouldn't properly hide friendly nameplates according to the settings under specific circumstances.
- Fixed mount and character tooltips overlapping in some cases when the tooltip is anchored on the cursor.

]],
	WHATS_NEW_28_4 = [[# Changelog version 2.8.4

## Added

- The original tooltip can now be shown instead of the TRP tooltip by pressing Alt.
  - This can be disabled (or the modifier key can be changed) in Tooltip settings > "Hide on modifier key".
- Added profile tooltip support for soft targets.
  - This is mostly relevant to ConsolePort users with "Enable Soft Friend Targeting" and "Show Friendly Tooltip", but impacts anyone with the SoftTargetFriend and SoftTargetTooltipFriend CVars enabled.

## Fixed

- Fixed companion titles not wrapping properly on tooltips.
- Fixed the timerunner icon not showing when names are customized in chat (unless the profile icon is included in the customization).
- The temporary workaround for disconnects has been extended indefinitely.
  - It was set to expire at the end of May assuming the issue would be fixed by then, which has not been the case. As we don't know for sure when it will, we'll just release a new version to remove it once it has.

]],

};

-- Bindings and FrameXML Global Strings

BINDING_HEADER_TRP3 = "Total RP 3";

-- The default locale for any lookups in script bodies is based on the addon
-- locale global managed by the Data addon, which will prefer (in-order) the
-- the previously configured state of the AddonLocale setting, the unofficial
-- GAME_LOCALE global variable, or finally the default client locale.
TRP3_API.loc = TRP3_API.Ellyb.Localization(L);
TRP3_API.loc:RegisterNewLocale("enUS", "English", L);
TRP3_API.loc:SetCurrentLocale(TRP3_AddonLocale, true);
