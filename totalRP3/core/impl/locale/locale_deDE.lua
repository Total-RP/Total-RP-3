----------------------------------------------------------------------------------
-- Total RP 3
-- German locale
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Translation into German:
-- Benjamin Strecker - Týberîás @Die Aldor-EU (zerogravityspider@gmx.net)
-- Enduni ( http://www.curseforge.com/profiles/Enduni/ )
-- ded88 ( http://www.curseforge.com/profiles/ded88/ )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local LOCALE_DE = {
	locale = "deDE",
	localeText = "Deutsch",
	localeContent = {
        ABOUT_TITLE = "Über",
        BINDING_NAME_TRP3_TOGGLE = "Hauptfenster umschalten",
        BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Werkzeugleiste umschalten", -- Needs review
        BW_COLOR_CODE = "Farbcode", -- Needs review
        BW_COLOR_CODE_ALERT = "Falscher hexadezimaler Farbcode!", -- Needs review
        BW_COLOR_CODE_TT = "Hier kannst du 6 Zeichen hexadezimalen Farbcode einfügen und mit Eingabe bestätigen.", -- Needs review
        CM_ACTIONS = "Aktionen",
        CM_APPLY = "Übernehmen",
        CM_CANCEL = "Abbrechen",
        CM_CENTER = "Zentriert", -- Needs review
        CM_CLASS_DEATHKNIGHT = "Todesritter",
        CM_CLASS_DRUID = "Druide",
        CM_CLASS_HUNTER = "Jäger",
        CM_CLASS_MAGE = "Magier",
        CM_CLASS_MONK = "Mönch",
        CM_CLASS_PALADIN = "Paladin",
        CM_CLASS_PRIEST = "Priester",
        CM_CLASS_ROGUE = "Schurke",
        CM_CLASS_SHAMAN = "Schamane",
        CM_CLASS_UNKNOWN = "Unbekannt",
        CM_CLASS_WARLOCK = "Hexenmeister",
        CM_CLASS_WARRIOR = "Krieger", -- Needs review
        CM_CLICK = "Klicken",
        CM_COLOR = "Farbe",
        CM_CTRL = "Strg", -- Needs review
        CM_DRAGDROP = "Drag & Drop", -- Needs review
        CM_EDIT = "Bearbeiten", -- Needs review
        CM_IC = "IC",
        CM_ICON = "Icon",
        CM_IMAGE = "Bild",
        CM_L_CLICK = "Links-Klick",
        CM_LEFT = "Links",
        CM_LINK = "Link",
        CM_LOAD = "Laden",
        CM_MOVE_DOWN = "Nach unten", -- Needs review
        CM_MOVE_UP = "Nach oben", -- Needs review
        CM_NAME = "Name",
        CM_OOC = "OOC",
        CM_OPEN = "Öffnen",
        CM_PLAY = "Abspielen", -- Needs review
        CM_R_CLICK = "Rechts-Klick",
        CM_REMOVE = "Entfernen",
        CM_RIGHT = "Rechts", -- Needs review
        CM_SAVE = "Speichern",
        CM_SELECT = "Auswählen",
        CM_SHIFT = "Umstelltaste", -- Needs review
        CM_SHOW = "Anzeigen",
        CM_STOP = "Anhalten", -- Needs review
        CM_UNKNOWN = "Unbekannt",
        CM_VALUE = "Wert",
        CO_ANCHOR_BOTTOM = "Unten",
        CO_ANCHOR_BOTTOM_LEFT = "Unten Links",
        CO_ANCHOR_BOTTOM_RIGHT = "Unten Rechts",
        CO_ANCHOR_CURSOR = "Zeige am Mauszeiger", -- Needs review
        CO_ANCHOR_LEFT = "Links",
        CO_ANCHOR_RIGHT = "Rechts",
        CO_ANCHOR_TOP = "Oben",
        CO_ANCHOR_TOP_LEFT = "Oben Links",
        CO_ANCHOR_TOP_RIGHT = "Oben Rechts",
        CO_CHAT = "Chateinstellungen", -- Needs review
        CO_CHAT_MAIN = "Chathaupteinstellungen", -- Needs review
        CO_CHAT_MAIN_COLOR = "Benutze eigene Farben für Namen", -- Needs review
        CO_CHAT_MAIN_EMOTE = "Emoteerkennung", -- Needs review
        CO_CHAT_MAIN_EMOTE_PATTERN = "Muster zur Emoteerkennung", -- Needs review
        CO_CHAT_MAIN_EMOTE_USE = "Nutze Emoteerkennung", -- Needs review
        CO_CHAT_MAIN_EMOTE_YELL = "Keine geschrienen Emotes", -- Needs review
        CO_CHAT_MAIN_EMOTE_YELL_TT = "Beim Schreien *emote* oder <emote> nicht zeigen.", -- Needs review
        CO_CHAT_MAIN_NAMING = "Benennungsmethode",
        CO_CHAT_MAIN_NAMING_1 = "Originale Namen beibehalten", -- Needs review
        CO_CHAT_MAIN_NAMING_2 = "Angepasste Namen verwenden", -- Needs review
        CO_CHAT_MAIN_NAMING_3 = "Vorname + Nachname",
        CO_CHAT_MAIN_NPC = "NSC-Spracherkennung", -- Needs review
        CO_CHAT_MAIN_NPC_PREFIX = "Muster für NSC-Spracherkennung", -- Needs review
        CO_CHAT_MAIN_NPC_PREFIX_TT = [=[Wenn eine Chatnachricht im Sagen-, Emote- oder Schlachtzugskanal mit diesem Zeichen startet, wird sie als NSC-Nachricht interpretiert.

|cff00ff00Voreingestellt : "|| "
(ohne die " und mit einem Leerzeichen nach dem Strich)]=], -- Needs review
        CO_CHAT_MAIN_NPC_USE = "Nutze NSC-Spracherkennung", -- Needs review
        CO_CHAT_MAIN_OOC = "OOC-Erkennung", -- Needs review
        CO_CHAT_MAIN_OOC_COLOR = "OOC-Farbe", -- Needs review
        CO_CHAT_MAIN_OOC_PATTERN = "Muster für OOC-Erkennung", -- Needs review
        CO_CHAT_MAIN_OOC_USE = "Nutze OOC-Erkennung", -- Needs review
        CO_CHAT_USE = "Benutze Chatkanäle", -- Needs review
        CO_CHAT_USE_SAY = "Sagen-Kanal", -- Needs review
        CO_CONFIGURATION = "Einstellungen",
        CO_GENERAL = "Allgemeine Einstellungen",
        CO_GENERAL_BROADCAST = "Broadcast-Kanal nutzen", -- Needs review
        CO_GENERAL_BROADCAST_C = "Names des Broadcast-Kanals", -- Needs review
        CO_GENERAL_BROADCAST_TT = "Der Broadcast-Kanal wird für viele Funktionen genutzt. Durch das Deaktivieren werden Funktionen wie die Charakterposition auf der Karte, Abspielen lokaler Klänge usw. deaktivert.", -- Needs review
        CO_GENERAL_CHANGELOCALE_ALERT = [=[Interface neu laden, um die Sprache jetzt auf %s zu ändern?

Wenn nicht, wird die Sprache beim nächsten Login geändert.]=], -- Needs review
        CO_GENERAL_COM = "Kommunikation",
        CO_GENERAL_HEAVY = "Warnung bei überlangem Profil", -- Needs review
        CO_GENERAL_HEAVY_TT = "Gibt dir einen Warnhinweis, wenn dein Profil eine verträgliche Größe überschreitet.", -- Needs review
        CO_GENERAL_LOCALE = "Sprache des Addons", -- Needs review
        CO_GENERAL_MISC = "Verschiedenes",
        CO_GENERAL_NEW_VERSION = "Aktualisierungshinweis", -- Needs review
        CO_GENERAL_NEW_VERSION_TT = "Gibt dir einen Hinweis, sobald eine neue Version verfügbar ist.", -- Needs review
        CO_GENERAL_TT_SIZE = "Textgröße des Informationstooltips", -- Needs review
        CO_GENERAL_UI_ANIMATIONS = "Interface-Animationen", -- Needs review
        CO_GENERAL_UI_ANIMATIONS_TT = "Aktiviert die Interface-Animationen.", -- Needs review
        CO_GENERAL_UI_SOUNDS = "Interface-Klänge", -- Needs review
        CO_GENERAL_UI_SOUNDS_TT = "Aktivert die Interface-Klänge (beim Öffnen von Fenstern, Wechseln zwischen Reitern und Klicken auf Schaltflächen).", -- Needs review
        CO_GLANCE_LOCK = "Leiste fixieren", -- Needs review
        CO_GLANCE_LOCK_TT = "Verhindert, dass die Leiste verschoben wird.", -- Needs review
        CO_GLANCE_MAIN = "\"Auf den ersten Blick\"-Leiste", -- Needs review
        CO_GLANCE_PRESET_TRP2 = "Benutze Positionen im Total RP 2 Stil",
        CO_GLANCE_PRESET_TRP2_BUTTON = "Benutzen",
        CO_GLANCE_PRESET_TRP2_HELP = "Verknüpfung, um die Leiste im TRP2-Stil zu konfigurieren – am rechten Rand des WoW-Zielfensters.", -- Needs review
        CO_GLANCE_PRESET_TRP3 = "Benutze Positionen im Total RP 3 Stil",
        CO_GLANCE_PRESET_TRP3_HELP = "Verknüpfung um die Zeile im TRP3 Stil aufzusetzen - Am unteren Rand des TRP3 Zielfensters.",
        CO_GLANCE_RESET_TT = "Setze die Leiste auf die untere linke Position des Ankerfensters zurück.", -- Needs review
        CO_GLANCE_TT_ANCHOR = "Ankerpunkt des Tooltips", -- Needs review
        CO_MINIMAP_BUTTON = "Minimap Button",
        CO_MINIMAP_BUTTON_FRAME = "Ankerfenster",
        CO_MINIMAP_BUTTON_RESET = "Position zurücksetzen",
        CO_MINIMAP_BUTTON_RESET_BUTTON = "Zurücksetzen",
        CO_MINIMAP_BUTTON_SHOW_TITLE = "Zeige MInimap-Button", -- Needs review
        COM_LIST = "Liste aller Befehle:", -- Needs review
        CO_MODULES = "Modulstatus", -- Needs review
        CO_MODULES_DISABLE = "Deaktiviere Modul",
        CO_MODULES_ENABLE = "Aktiviere Modul",
        CO_MODULES_ID = "Modul ID: %s",
        CO_MODULES_SHOWERROR = "Zeige Fehler",
        CO_MODULES_STATUS = "Status: %s",
        CO_MODULES_STATUS_0 = "Fehlende Abhängigkeiten",
        CO_MODULES_STATUS_1 = "Geladen",
        CO_MODULES_STATUS_2 = "Deaktivert",
        CO_MODULES_STATUS_3 = "Total RP 3 Aktualisierung benötigt", -- Needs review
        CO_MODULES_STATUS_4 = "Fehler bei der Initialisierung", -- Needs review
        CO_MODULES_STATUS_5 = "Fehler beim Start",
        CO_MODULES_TT_DEP = "%s- %s (version %s)|r", -- Needs review
        CO_MODULES_TT_DEPS = "Abhängigkeiten",
        CO_MODULES_TT_ERROR = [=[
|cffff0000Fehler:|r
%s]=], -- Needs review
        CO_MODULES_TT_NONE = "Keine Abhängigkeiten",
        CO_MODULES_TT_TRP = "%sFür Total RP 3 build %s minimum.|r",
        CO_MODULES_TUTO = [=[Ein Modul ist eine unabhängige Funktion, die aktiviert oder deaktiviert werden kann.

Möglicher Status:
|cff00ff00Geladen:|r Modul aktiviert und geladen.
|cff999999Deaktiviert:|r Modul deaktiviert.
|cffff9900Fehlende Abhängigkeiten:|r Einige Abhängigkeiten sind nicht geladen/verfügbar.
|cffff9900TRP Update benötigt:|r Diese Modul benötigt eine aktueller Version von TRP3.
|cffff0000Fehler beim Inizialisieren oder Starten:|r Der Start des Moduls hat nicht funktioniert. Das Modul würde sicher Fehler verursachen!

|cffff9900Wenn ein Modul deaktivert wird muss das UI neu geladen werden!]=], -- Needs review
        CO_MODULES_VERSION = "Version: %s",
        COM_RESET_RESET = "Die Position des Fensters wurde zurückgesetzt.", -- Needs review
        COM_RESET_USAGE = "Hinweis: |cff00ff00/trp3 reset frames|r, um alle Fensterpositionen zurückzusetzen.", -- Needs review
        CO_MSP = "Mary Sue Protocol",
        CO_MSP_T3 = "Benutze nur Template 3",
        CO_MSP_T3_TT = "Selbst, wenn du ein anderes \"Über\"-Template auswählst, wird immer Template 3 genutzt, um MSP-Kompatibilität zu gewährleisten.", -- Needs review
        COM_SWITCH_USAGE = "Hinweis: |cff00ff00/trp3 switch main|r, um das Hauptfenster umzuschalten oder |cff00ff00/trp3 switch toolbar|r, um die Werkzeugleiste umzuschalten.", -- Needs review
        CO_REGISTER = "Einstellungen registrieren",
        CO_REGISTER_ABOUT_VOTE = "Benutze Bewertungssystem", -- Needs review
        CO_REGISTER_ABOUT_VOTE_TT = "Aktiviert das Bewertungssystem, welches dir erlaubt, die Beschreibung von Charakteren als positiv oder negativ zu bewerten. Hierdurch kannt auch dein Charakter bewertet werden!", -- Needs review
        CO_REGISTER_AUTO_ADD = "Neue Spieler automatisch hinzufügen",
        CO_REGISTER_AUTO_ADD_TT = "Automatisch neue Spieler, denen du begegnest, zum Register hinzufügen.", -- Needs review
        CO_REGISTER_AUTO_PURGE_1 = "Nach %s Tag(en)", -- Needs review
        CO_TARGETFRAME = "Zielfentereinstellungen", -- Needs review
        CO_TARGETFRAME_ICON_SIZE = "Icongröße",
        CO_TARGETFRAME_USE = "Anzeigebedingungen", -- Needs review
        CO_TARGETFRAME_USE_1 = "Immer",
        CO_TARGETFRAME_USE_2 = "Nur wenn IC",
        CO_TARGETFRAME_USE_3 = "Niemals (Deaktiviert)",
        CO_TARGETFRAME_USE_TT = "Gibt an, unter welchen Bedingungen das Zielfenster am gewählten Ziel gezeigt werden soll.", -- Needs review
        CO_TOOLBAR = "Fenstereinstellungen", -- Needs review
        CO_TOOLBAR_CONTENT = "Toolbareinstellungen", -- Needs review
        CO_TOOLBAR_CONTENT_CAPE = "Umhang an/aus",
        CO_TOOLBAR_CONTENT_HELMET = "Helm an/aus",
        CO_TOOLBAR_CONTENT_RPSTATUS = "Charakterstatus (IC/OOC)",
        CO_TOOLBAR_CONTENT_STATUS = "Spielerstatus (AFK/DND)",
        CO_TOOLBAR_ICON_SIZE = "Icongröße",
        CO_TOOLBAR_MAX = "Maximale Icons pro Zeile",
        CO_TOOLBAR_MAX_TT = "Auf 1 stellen wenn du die Leiste vertikal angezeigt haben möchtest!",
        CO_TOOLBAR_SHOW_ON_LOGIN = "Zeige Toolbar beim Login", -- Needs review
        CO_TOOLBAR_SHOW_ON_LOGIN_HELP = "Wenn du nicht möchtest, dass die Toolbar beim Login erscheint, deaktiviere diese Option.", -- Needs review
        CO_TOOLTIP = "Tooltipeinstellungen", -- Needs review
        CO_TOOLTIP_ANCHOR = "Ankerpunkt",
        CO_TOOLTIP_ANCHORED = "Ankerfenster",
        CO_TOOLTIP_CHARACTER = "Charaktertooltip", -- Needs review
        CO_TOOLTIP_CLIENT = "Zeige Client",
        CO_TOOLTIP_COMBAT = "Während des Kampfs verbergen", -- Needs review
        CO_TOOLTIP_COMMON = "Standardeinstellungen", -- Needs review
        CO_TOOLTIP_CURRENT = "Zeige \"aktuelle\" Informationen",
        CO_TOOLTIP_CURRENT_SIZE = "Maximale Länge von \"aktuellen\" Informationen", -- Needs review
        CO_TOOLTIP_FT = "Zeige vollen Titel",
        CO_TOOLTIP_GUILD = "Zeige Gildeninformationen", -- Needs review
        CO_TOOLTIP_HIDE_ORIGINAL = "Verstecke Originaltooltip", -- Needs review
        CO_TOOLTIP_ICONS = "Zeige Icons",
        CO_TOOLTIP_MAINSIZE = "Hauptschriftgröße",
        CO_TOOLTIP_NOTIF = "Zeige Benachrichtigungen",
        CO_TOOLTIP_NOTIF_TT = "Die Benachrichtigungszeile enthält die Clientversion, den Marker für ungelesene Beschreibungen und die \"Auf den Ersten Blick\" Leiste.", -- Needs review
        CO_TOOLTIP_OWNER = "Zeige Besitzer",
        CO_TOOLTIP_PETS = "Begleitertooltip", -- Needs review
        CO_TOOLTIP_PETS_INFO = "Zeige Begleiterinformationen", -- Needs review
        CO_TOOLTIP_PROFILE_ONLY = "Nur benutzen, wenn das Ziel ein Profil hat", -- Needs review
        CO_TOOLTIP_RACE = "Zeige Rasse, Klasse und Level",
        CO_TOOLTIP_REALM = "Zeige Server", -- Needs review
        CO_TOOLTIP_RELATION = "Zeige Beziehungsfarbe", -- Needs review
        CO_TOOLTIP_RELATION_TT = "Fügt dem Rand des Charaktertooltips eine Farbe hinzu, um die Beziehung zu repräsentieren.", -- Needs review
        CO_TOOLTIP_SPACING = "Zeige Leerzeile",
        CO_TOOLTIP_SPACING_TT = "Zeigt Leerzeilen, um den Tooltip dem Tooltip von MyRoleplay ähnlich zu sehen.", -- Needs review
        CO_TOOLTIP_SUBSIZE = "Sekundäre Schriftgöße",
        CO_TOOLTIP_TARGET = "Zeige Ziel",
        CO_TOOLTIP_TERSIZE = "Tertiäre Schriftgröße",
        CO_TOOLTIP_TITLE = "Zeige Titel",
        CO_TOOLTIP_USE = "Benutze die Tooltips für Charaktere/Begleiter",
        CO_WIM = "|cffff9900Flüsterkanäle deaktiviert.", -- Needs review
        CO_WIM_TT = "Du nutzt |cff00ff00WIM|r, die Nutzung wurde aus Kompatibilitätsgründen deaktiviert",
        DB_STATUS = "Status",
        DB_STATUS_CURRENTLY = "Aktuelles (IC)",
        DB_STATUS_CURRENTLY_COMMON = "Der Status wird im Tooltip deines Charakters angezeigt. Halte dich hier kurz, knapp und eindeutig, da |cffff9900standartmäßig alle TRP3 Nutzer nur die ersten 140 Zeichen sehen können!",
        DB_STATUS_CURRENTLY_OOC = "Andere Informationen (OOC)",
        DB_STATUS_CURRENTLY_OOC_TT = "Hier kannst du Wichtiges über dich als Spieler oder andere OOC Informationen eintragen.", -- Needs review
        DB_STATUS_CURRENTLY_TT = "Hier kannst du Wichtiges über deinen Charakter angeben.", -- Needs review
        DB_STATUS_RP = "Charakterstatus", -- Needs review
        DB_STATUS_RP_EXP = "Erfahrener Rollenspieler",
        DB_STATUS_RP_EXP_TT = [=[Zeigt an, dass du ein erfahrener Rollenspieler bist.
Zeigt kein spezielles Icon auf deinem Tooltip an.]=], -- Needs review
        DB_STATUS_RP_IC = "In Character (IC)", -- Needs review
        DB_STATUS_RP_IC_TT = [=[Die spielst diesen Charakter aktuell aus.
Dein gesamtes Handeln wird bewertet, als ob dein Charakter diese Aktionen ausführt.]=], -- Needs review
        DB_STATUS_RP_OOC = "Out of Character (OOC)", -- Needs review
        DB_STATUS_RP_OOC_TT = [=[Du spielst diesen Charakter aktuell nicht aus.
Dein Handeln wird nicht mit dem Charakter in Verbindung gebracht.]=],
        DB_STATUS_RP_VOLUNTEER = "Rollenspiellehrer", -- Needs review
        DB_STATUS_RP_VOLUNTEER_TT = "Diese Auswahl zeigt mithilfe eines Icons auf deinem Tooltip an, dass du Rollenspielanfängern Hilfestellung gibst.", -- Needs review
        DB_STATUS_XP = "Rollenspielerfahrung",
        DB_STATUS_XP_BEGINNER = "Rollenspielanfänger", -- Needs review
        DB_STATUS_XP_BEGINNER_TT = "Diese Auswahl zeigt mithilfe eines Icons auf deinem Tooltip an, dass du noch Rollenspielanfänger bist.", -- Needs review
        DB_TUTO_1 = [=[|cffffff00Der Charakter Status|r zeigt an, ob du deinen Charakter momentan ausspielst oder nicht.

|cffffff00Die Rollenspielerfahrung|r gibt an, ob du ein blutiger Anfänger oder ein erfahrener Rollenspieler bist, der gerne Neulingen hilft!

|cff00ff00Diese Informationen werden im Tooltip deines Charakters angezeigt.]=], -- Needs review
        DTBK_AFK = "Total RP 3 - AFK/DND", -- Needs review
        DTBK_CLOAK = "Total RP 3 - Rücken", -- Needs review
        DTBK_HELMET = "Total RP 3 - Helm", -- Needs review
        DTBK_RP = "Total RP 3 - IC/OOC", -- Needs review
        GEN_NEW_VERSION_AVAILABLE = [=[Eine neue Version von Total RP 3 ist verfügbar.

|cffff0000Deine Version : %s
|c0000ff00Neue Version %s|r

|cffff9900Wir empfehlen dir, immer die aktuelleste Version zu verwenden.|r

Diese Meldung wird nur einmal pro Sitzung angezeigt und kann in den Einstellungen abgeschaltet werden.]=], -- Needs review
        GEN_VERSION = "Version: %s (Build %s)",
        GEN_WELCOME_MESSAGE = "Danke, dass du Total RP 3 (v %s) verwendest! Viel Spaß!", -- Needs review
        MM_SHOW_HIDE_MAIN = "Zeige/verstecke das Hauptfenster", -- Needs review
        MM_SHOW_HIDE_MOVE = "Icon bewegen",
        MM_SHOW_HIDE_SHORTCUT = "Zeig/verstecke die Toolbar", -- Needs review
        NPC_TALK_SAY_PATTERN = "sagt: ",
        NPC_TALK_WHISPER_PATTERN = "flüstert: ",
        NPC_TALK_YELL_PATTERN = "schreit: ",
        PR_CO_BATTLE = "Begleiter",
        PR_CO_COUNT = "%s Haustiere/Reittiere an dieses Profil gebunden.",
        PR_CO_EMPTY = "Kein Begleiterprofil", -- Needs review
        PR_CO_MASTERS = "Meister",
        PR_CO_MOUNT = "Reittier", -- Needs review
        PR_CO_NEW_PROFILE = "Neues Begleiterprofil", -- Needs review
        PR_CO_PET = "Tier",
        PR_CO_PROFILE_DETAIL = "Dieses Profil ist aktuell gebunden an", -- Needs review
        PR_CO_PROFILE_HELP = [=[Ein Profil enthält alle Informationen über ein |cffffff00"Haustier/Begleiter"|r als |cff00ff00Rollenspiel Charakter|r.

Ein Begleiterprofil kann an folgende Begleiterarten gebunden werden:
- Ein Kampfhaustier |cffff9900(nur wenn es umbennant wurde)|r
- Einen Jägerbegleiter
- Einen Diener eines Hexenmeisters
- Einen Magierelementar
- Einen Ghul eines Todesritters |cffff9900(siehe unten)|r

Genau wie bei einem Charakterprofil kann ein |cff00ff00Begleiterproful|r mit |cffffff00verschiedenen Haustieren|r verbunden werden. Genauso kannst du für dein |cffffff00Haustier|r einfach durch die verschiedenen Profile schalten.

|cffff9900Ghule:|r Für einen Ghul musst du das Profil bei jeder Beschwörung neu auswählen, da dessen Spielname zufällig vergeben wird!]=], -- Needs review
        PR_CO_PROFILE_HELP2 = [=[Hier klicken um eine neues Begleiterprofil anzulegen.

|cff00ff00Um ein Profil einem Haustier zu zuweisen, beschwöre einfach dein Haustier/Begleiter, wähle es aus und benutze das Zielfenster um es einem Profil zu zuweisen (oder ein neues Profil zu erstellen).|r]=],
        PR_CO_PROFILEMANAGER_DELETE_WARNING = [=[Bist du sicher, dass du dieses Begleiterprofil %s löschen willst?
Diese Aktion kann nicht rückgängig gemacht werden und alle TRP3 Informationen, die damit zusammenhängen, werden unwiderruflich zerstört!]=], -- Needs review
        PR_CO_PROFILEMANAGER_DUPP_POPUP = [=[Bitte gibt einen Namen für das neue Profil ein.
Der Name darf nicht leer sein.

Diese Kopie ändert nicht die Bindung deines Haustieres/Reittieres zu %s.]=],
        PR_CO_PROFILEMANAGER_EDIT_POPUP = [=[Bitte gib einen Namen für das Profil %s ein.
Der Name darf nicht leer sein.

Das Ändern des Namens ändert nicht die Verbindung des Profils mit deinem Haustier/Reittier.]=], -- Needs review
        PR_CO_PROFILEMANAGER_TITLE = "Begleiterprofile", -- Needs review
        PR_CO_UNUSED_PROFILE = "Dieses Profil ist aktuell nicht an ein Haustier oder Reittier gebunden.",
        PR_CO_WARNING_RENAME = [=[|cffff0000Warnung:|r Es wird dringend empfohlen, dein Haustier umzubenennen, bevor du es mit einem Profil verbindest.

Trotzdem verbinden?]=], -- Needs review
        PR_CREATE_PROFILE = "Profil erstellen", -- Needs review
        PR_DELETE_PROFILE = "Profil löschen",
        PR_DUPLICATE_PROFILE = "Profil kopieren",
        PR_IMPORT_CHAR_TAB = "Charakterimporteur", -- Needs review
        PR_IMPORT_EMPTY = "Kein importierbares Profil",
        PR_IMPORT_IMPORT_ALL = "Alles importieren", -- Needs review
        PR_IMPORT_PETS_TAB = "Begleiterimporteur", -- Needs review
        PR_IMPORT_WILL_BE_IMPORTED = "Wird importiert", -- Needs review
        PR_PROFILE = "Profil",
        PR_PROFILE_CREATED = "Profile %s erstellt.",
        PR_PROFILE_DELETED = "Profile %s gelöscht.",
        PR_PROFILE_DETAIL = "Dieses Profil ist aktuell an diese WoW Charaktere gebunden", -- Needs review
        PR_PROFILE_HELP = [=[Ein Profil enthält alle Informationen über einen |cffffff00"Charakter"|r als |cff00ff00Rollenspielcharakter|r.

Ein realer |cffffff00"WoW Charakter"|r kann nur an ein Profil gleichzeitig gebunden sein, kann aber zwischen verschiedenen Profilen hin und her schalten.

Du kannst auch mehrere |cffffff00"WoW Charaktere"|r an dasselbe |cff00ff00Profil|r binden!]=], -- Needs review
        PR_PROFILE_LOADED = "Das Profil %s ist geladen.",
        PR_PROFILEMANAGER_ACTIONS = "Aktionen",
        PR_PROFILEMANAGER_ALREADY_IN_USE = "Der Profilname %s ist nicht verfügbar.",
        PR_PROFILEMANAGER_COUNT = "%s WoW Charakter/e an dieses Profil gebunden.",
        PR_PROFILEMANAGER_CREATE_POPUP = [=[Gib bitte einen Namen für das neue Profil ein.
Die Namenszeile darf nicht leer sein.]=],
        PR_PROFILEMANAGER_CURRENT = "Aktuelles Profil",
        PR_PROFILEMANAGER_DELETE_WARNING = [=[Bist du sicher, dass du das Profil %s? löschen willst
Diese Aktion kann nicht rückgängig gemacht werden und alle TRP3 Informationen, die damit verbunden sind, werden unwiderruflich gelöscht!]=], -- Needs review
        PR_PROFILEMANAGER_DUPP_POPUP = [=[Gib bitte einen Namen für das neue Profil ein.
Die Namenszeile darf nicht leer sein.

Diese Kopie ändert nicht die Bindung zu %s.]=],
        PR_PROFILEMANAGER_EDIT_POPUP = [=[Gib bitte einen neuen Namen für das Profil %s ein.
Die Namenszeile darf nicht leer sein.

Die änderung des Namens verändert nicht die Verbindung zwischen dem Profil und den Charakteren.]=],
        PR_PROFILEMANAGER_RENAME = "Profil umbenennen",
        PR_PROFILEMANAGER_SWITCH = "Profil auswählen",
        PR_PROFILEMANAGER_TITLE = "Charakterprofile", -- Needs review
        PR_PROFILES = "Profile",
        PR_UNUSED_PROFILE = "Dieses Profil ist aktuell an keinen WoW Charakter gebunden.",
        REG_COMPANION = "Begleiter",
        REG_COMPANION_BOUND_TO_TARGET = "Ziel", -- Needs review
        REG_COMPANION_BROWSER_BATTLE = "Wildtierbrowser", -- Needs review
        REG_COMPANION_INFO = "Information",
        REG_COMPANION_LINKED = "Der Begleiter %s ist nun verbunden mit dem Profil %s", -- Needs review
        REG_COMPANION_LINKED_NO = "Der Begleiter %s ist nun nicht mehr mit einem Profil verbunden.", -- Needs review
        REG_COMPANION_NAME = "Name",
        REG_COMPANION_NAME_COLOR = "Namensfarbe",
        REG_COMPANION_PAGE_TUTO_C_1 = "Consult",
        REG_COMPANION_PAGE_TUTO_E_1 = [=[Das ist die|cff00ff00 Hauptinformation deines Begleiters|r.

All diese Informationen werden |cffff9900im Tooltip deines Begleiters angezeigt|r.]=],
        REG_COMPANION_PAGE_TUTO_E_2 = [=[Das ist die|cff00ff00 Beschreibung deines Charakters|r.

Es ist nicht auf eine |cffff9900Physische Beschreibung|r limitiert. Deute hier ruhig Teile seiner |cffff9900Hintergrundgeschichte|r oder Details über seine |cffff9900Persönlichkeit|r an.

Es gibt unzählige Wege, die Beschreibung zu personalisieren.
Du kannst eine |cffffff00Hintergrundtextur|r für die Beschreibung aussuchen. Du kannst ebenfalls die Formatierungstools verwenden, um Dinge wie |cffffff00Schriftgröße, Farbe und Textausrichtung|r anzupassen.
Diese Tools erlauben dir auch das Einfügen von |cffffff00Bildern, Icons oder Links zu externen Internetseiten|r.]=], -- Needs review
        REG_COMPANION_PROFILES = "Begleiterprofile", -- Needs review
        REG_COMPANIONS = "Begleiter",
        REG_COMPANION_TF_BOUND_TO = "Profil auswählen",
        REG_COMPANION_TF_CREATE = "Neues Profil erstellen", -- Needs review
        REG_COMPANION_TF_NO = "Kein Profil",
        REG_COMPANION_TF_OPEN = "Seite öffnen",
        REG_COMPANION_TF_OWNER = "Owner: %s", -- Needs review
        REG_COMPANION_TF_PROFILE = "Begleiterprofil", -- Needs review
        REG_COMPANION_TF_PROFILE_MOUNT = "Reittierprofil", -- Needs review
        REG_COMPANION_TF_UNBOUND = "Profil abwählen",
        REG_COMPANION_TITLE = "Titel",
        REG_DELETE_WARNING = [=[Bist du sicher, dass du %s's Profil löschen möchtest?
]=], -- Needs review
        REG_IGNORE_TOAST = "Charakter wird ignoriert", -- Needs review
        REG_LIST_ACTIONS_MASS = "Aktion auf %s ausgewählte Profile",
        REG_LIST_ACTIONS_MASS_IGNORE = "Profile ignorieren",
        REG_LIST_ACTIONS_MASS_IGNORE_C = [=[Diese Aktion wird |cff00ff00%s Charaktere der Ignorieren Liste hinzufügen.

Optional kann hier ein Grund angegeben werden. Es handelt sich um eine persönliche Notiz, die nur zur Erinnerung dient.]=], -- Needs review
        REG_LIST_ACTIONS_MASS_REMOVE = "Profile entfernen",
        REG_LIST_ACTIONS_MASS_REMOVE_C = "Diese Aktion wird |cff00ff00%s ausgewählte/s Profil/e löschen|r.",
        REG_LIST_ACTIONS_PURGE = "Register entfernen",
        REG_LIST_ACTIONS_PURGE_ALL = "Alle Profile löschen",
        REG_LIST_ACTIONS_PURGE_ALL_C = [=[Dies wird alle Profile und verlinkten Charaktere löschen.

|cff00ff00%s Charaktere.]=],
        REG_LIST_ACTIONS_PURGE_ALL_COMP_C = [=[Dies wird alle deine Begleiter löschen.

|cff00ff00%s Begleiter.]=],
        REG_LIST_ACTIONS_PURGE_COUNT = "%s Profile werden gelöscht.",
        REG_LIST_ACTIONS_PURGE_EMPTY = "Keine Profile zum Löschen.", -- Needs review
        REG_LIST_ACTIONS_PURGE_IGNORE = "Profile von ignorierten Charakteren",
        REG_LIST_ACTIONS_PURGE_IGNORE_C = [=[Dies wird alle Profile, die mit ignorierten Charakteren verbunden sind, löschen.

|cff00ff00%s]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_TIME = "Seit 1 Monat nicht mehr gesehene Profile",
        REG_LIST_ACTIONS_PURGE_TIME_C = [=[Dies wird alle Profile löschen, die seit einem Monat nicht gesehen wurden.

|cff00ff00%s]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_UNLINKED = "Profile ohne Charakter",
        REG_LIST_ACTIONS_PURGE_UNLINKED_C = [=[Dies wird alle Profile, die nicht an einen WoW Charakter gebunden sind, löschen.

|cff00ff00%s]=], -- Needs review
        REG_LIST_CHAR_EMPTY = "Kein Charakter",
        REG_LIST_CHAR_EMPTY2 = "Kein Charakter passt zu deiner Auswahl",
        REG_LIST_CHAR_FILTER = "Charaktere: %s / %s",
        REG_LIST_CHAR_IGNORED = "Ignoriert",
        REG_LIST_CHAR_SEL = "Charakter wählen",
        REG_LIST_CHAR_TITLE = "Charakterliste",
        REG_LIST_CHAR_TT = "Zum Anzeigen klicken", -- Needs review
        REG_LIST_CHAR_TT_CHAR = "Gebundene WoW Charakter/e:",
        REG_LIST_CHAR_TT_CHAR_NO = "Nicht an einen Charakter gebunden",
        REG_LIST_CHAR_TT_DATE = [=[Zuletzt gesehen: |cff00ff00%s|r
Wo zuletzt gesehen: |cff00ff00%s|r]=],
        REG_LIST_CHAR_TT_GLANCE = "Auf den ersten Blick",
        REG_LIST_CHAR_TT_IGNORE = "Ignorierte Charakter/e",
        REG_LIST_CHAR_TT_NEW_ABOUT = "Ungelesene Beschreibung",
        REG_LIST_CHAR_TT_RELATION = [=[Beziehung:
|cff00ff00%s]=],
        REG_LIST_CHAR_TUTO_ACTIONS = "Diese Spalte erlabt es dir, mehrere Charaktere auszuwählen, um die selbe Aktion auf diese auszuführen.", -- Needs review
        REG_LIST_CHAR_TUTO_FILTER = [=[Du kannst nach verschiedenen Kriterien filtern.

Der |cff00ff00Namensfilter|r wird nach bestimmten Profilnamen suchen (Vorname + Nachname) sowie nach WoW Charakteren.

Der |cff00ff00Gildenfilter|r wird nach Charakteren einer bestimmten Gilde suchen.

Der |cff00ff00Realm Only Filter|r wird nur nach Charakteren auf dem aktuellen Realm suchen.]=], -- Needs review
        REG_LIST_CHAR_TUTO_LIST = [=[Die erste Spalte zeigt den Charakternamen.

Die zweite Spalte zeigt die Beziehung zwischen den Charakteren und deinem Charakter.

Die letzte Spalte ist für diverse Angaben. (ignoriert ..etc.)]=],
        REG_LIST_FILTERS = "Filter",
        REG_LIST_FILTERS_TT = [=[|cffffff00Links-Klick:|r Filter anwenden
|cffffff00Rechts-Klicken:|r Filter zurücksetzen]=],
        REG_LIST_FLAGS = "Flags",
        REG_LIST_GUILD = "Gilde des Charakters",
        REG_LIST_IGNORE_EMPTY = "Keine ignorierter Charaktere", -- Needs review
        REG_LIST_IGNORE_TITLE = "Liste ignorierter Charaktere", -- Needs review
        REG_LIST_IGNORE_TT = [=[Grund:
|cff00ff00%s

|cffffff00Klicken, um von der Liste zu streichen]=], -- Needs review
        REG_LIST_NAME = "Name das Charakters",
        REG_LIST_NOTIF_ADD = "Neues Profil gefunden für |cff00ff00%s",
        REG_LIST_NOTIF_ADD_CONFIG = "Neues Profil gefunden",
        REG_LIST_NOTIF_ADD_NOT = "Dieses Profil existiert nicht mehr.",
        REG_LIST_PET_MASTER = "Name des Herren",
        REG_LIST_PET_NAME = "Name des Begleiters",
        REG_LIST_PETS_EMPTY = "Kein/e Begleiter",
        REG_LIST_PETS_EMPTY2 = "Kein Begleiter passt zu deiner Auswahl",
        REG_LIST_PETS_FILTER = "Begleiter: %s / %s",
        REG_LIST_PETS_TITLE = "Begleiterliste",
        REG_LIST_PETS_TOOLTIP = "Wurde gesehen bei",
        REG_LIST_PETS_TOOLTIP2 = "Wurde gesehen mit",
        REG_LIST_PET_TYPE = "Typ des Begleiters",
        REG_LIST_REALMONLY = "Nur dieser Realm",
        REG_MSP_ALERT = [=[|cffff0000WARNUNG

Du kannst nicht mehrere Addons nutzen, die das Mary Sue Protocol (MSP) nutzen, da das zu Fehlern führen kann!|r

Aktuell geladen: |cff00ff00%s

|cffff9900Deshalb wir der MSP Support für Total RP3 deaktiviert.|r

Wenn du TRP3 nicht als dein MSP Addon nutzen und diese Meldung nicht noch einmal sehen willst, kannst du das Mary Sue Protocol Modul in den TRP3 Einstellungen unter Modul Status deaktivieren.]=], -- Needs review
        REG_PLAYER = "Charakter",
        REG_PLAYER_ABOUT = "Über",
        REG_PLAYER_ABOUT_ADD_FRAME = "Fenster hinzufügen",
        REG_PLAYER_ABOUT_EMPTY = "Keine Beschreibung",
        REG_PLAYER_ABOUT_HEADER = "Titeltag", -- Needs review
        REG_PLAYER_ABOUT_MUSIC = "Charaktersoundtrack", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_LISTEN = "Soundtrack abspielen",
        REG_PLAYER_ABOUT_MUSIC_REMOVE = "Soundtrack abwählen",
        REG_PLAYER_ABOUT_MUSIC_SELECT = "Charakter Soundtrack wählen",
        REG_PLAYER_ABOUT_MUSIC_SELECT2 = "Soundtrack wählen",
        REG_PLAYER_ABOUT_MUSIC_STOP = "Soundtrack stoppen",
        REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900Kein Soundtrack",
        REG_PLAYER_ABOUT_P = "Paragraph tag",
        REG_PLAYER_ABOUT_REMOVE_FRAME = "Diese Fenster entfernen",
        REG_PLAYER_ABOUTS = "Über %s",
        REG_PLAYER_ABOUT_SOME = "Irgendein Text ...",
        REG_PLAYER_ABOUT_T1_YOURTEXT = "Dein Text hier",
        REG_PLAYER_ABOUT_TAGS = "Formatierungstools",
        REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900Unbekannter Soundtrack",
        REG_PLAYER_ABOUT_VOTE_DOWN = "Ich mag diesen Inhalt nicht.", -- Needs review
        REG_PLAYER_ABOUT_VOTE_NO = [=[Kein Charakter der mit diesem Profil verbunden ist, scheint online zu sein.
Möchtest du Total RP 3 trotzdem bewerten lassen?]=], -- Needs review
        REG_PLAYER_ABOUT_VOTES = "Statistiken",
        REG_PLAYER_ABOUT_VOTE_SENDING = "Sende deine Bewertung an %s ...", -- Needs review
        REG_PLAYER_ABOUT_VOTE_SENDING_OK = "Deine Bewertung wurde an %s gesendet!", -- Needs review
        REG_PLAYER_ABOUT_VOTES_R = [=[|cff00ff00%s Inhalt positiv bewerten
|cffff0000%s Inhalt negativ bewerten]=], -- Needs review
        REG_PLAYER_ABOUT_VOTE_TT = "Diese Bewertung ist komplett anonym und kann nur vom bewerteten Spieler gesehen werden.", -- Needs review
        REG_PLAYER_ABOUT_VOTE_TT2 = "Du kannst nur bewerten, wenn der Charakter online ist .", -- Needs review
        REG_PLAYER_ABOUT_VOTE_UP = "Ich mag den Inhalt",
        REG_PLAYER_ADD_NEW = "Neu erstellen", -- Needs review
        REG_PLAYER_AGE = "Alter",
        REG_PLAYER_AGE_TT = [=[Hier kannst du angeben, wie alt dein Charakter ist.

Hierfür gibt es mehrere Möglichkeiten:|c0000ff00
- Du kannst Jahre angeben,
- Oder ein Adjektiv (jung, ausgewachsen, erwachsen, steinalt, etc.).]=], -- Needs review
        REG_PLAYER_ALERT_HEAVY_SMALL = [=[|cffff0000Dein Profil ist sehr lang.
|cffff9900Du solltest versuchen, die Länge reduzieren.]=], -- Needs review
        REG_PLAYER_BIRTHPLACE = "Geburtsort",
        REG_PLAYER_BIRTHPLACE_TT = [=[Hier kannst du den Geburtsort deines Charakters angeben. Das kann entweder ein Ort, eine Zone oder ein Kontinent sein. Es liegt ganz an dir, wie akkurat du es angeben möchtest.

|c00ffff00Du kannst den Button rechts verwenden, um ganz einfach den aktuellen Ort als deinen Geburtsort festzulegen.]=], -- Needs review
        REG_PLAYER_BKG = "Hintergrundlayout",
        REG_PLAYER_BKG_TT = "Dies repräsentiert den grafischen Hintergrund für dein Charakteristikfenster.", -- Needs review
        REG_PLAYER_CARACT = "Charakteristiken",
        REG_PLAYER_CHANGE_CONFIRM = [=[Du hast ungespeicherte Daten.
Möchtest du die Seite dennoch wechseln?
|cffff9900Alle änderungen gehen verloren.]=], -- Needs review
        REG_PLAYER_CHARACTERISTICS = "Charakteristiken",
        REG_PLAYER_CLASS = "Klasse",
        REG_PLAYER_CLASS_TT = [=[Die Klasse deines Charakters.

|cff00ff00Zum Beispiel :|r
Ritter, Pyromane, Nekromant, Eliteschütze, Arkanwirker, Magd ...]=],
        REG_PLAYER_COLOR_CLASS = "Klassenfarbe",
        REG_PLAYER_COLOR_CLASS_TT = [=[Dies bestimmt ebenfalls die Farbe des Charakternamens.

]=],
        REG_PLAYER_COLOR_TT = [=[|cffffff00Linksklick:|r Wähle eine Farbe
|cffffff00Rechtsklick:|r Farbe abwählen]=], -- Needs review
        REG_PLAYER_CURRENT = "Aktuelles",
        REG_PLAYER_CURRENTOOC = "Aktuelles (OOC)",
        REG_PLAYER_CURRENT_OOC = "Dies ist eine OOC Information.", -- Needs review
        REG_PLAYER_EYE = "Augenfarbe",
        REG_PLAYER_EYE_TT = [=[Hier kannst du die Augenfarbe eintragen.

Bedenke bitte das, auch wenn dein Charakter ein komplett verhülltes Gesicht hat, es trotzdem sinvoll sein kann die Augenfarbe hier zu erwähnen.]=],
        REG_PLAYER_FIRSTNAME = "Vorname",
        REG_PLAYER_FIRSTNAME_TT = [=[Das ist der Vorname deines Charakters. Dies ist ein Freies Feld, wenn du nichts einträgst wird der Spielname (|cffffff00%s|r) deines Charakters benutzt.

Du kannst einen |c0000ff00Spitznamen|r verwenden!]=],
        REG_PLAYER_FULLTITLE = "Voller Titel",
        REG_PLAYER_FULLTITLE_TT = [=[Hier kannst du den Vollen Titel deines Charakter eintragen. Dies kann der komplette volle Titel deines Charakters oder weiter Titel sein.

Wie dem auch sei, versuche bitte Wiederholungen zu vermeinden falls es keine weiteren Informationen zu deinem Titel mehr gibt.]=],
        REG_PLAYER_GLANCE = "Auf den ersten Blick",
        REG_PLAYER_GLANCE_BAR_DELETED = "Gruppenvoreinstellung |cffff9900%s|r wurde gelöscht.", -- Needs review
        REG_PLAYER_GLANCE_BAR_EMPTY = "Der Name einer Voreinstellung darf nicht leer sein.", -- Needs review
        REG_PLAYER_GLANCE_BAR_LOAD = "Gruppenvoreinstellung", -- Needs review
        REG_PLAYER_GLANCE_BAR_LOAD_SAVE = "Gruppenvoreinstellungen", -- Needs review
        REG_PLAYER_GLANCE_BAR_NAME = [=[Bitte gibt einen Voreinstellungsnamen ein

|cff00ff00Hinweis: Wenn der Name bereits von einer anderen Voreinstellung genutzt wird, wird diese ersetzt.]=], -- Needs review
        REG_PLAYER_GLANCE_BAR_SAVE = "Speichere diese Gruppe als Voreinstellung.", -- Needs review
        REG_PLAYER_GLANCE_BAR_SAVED = "Gruppenvoreinstellung |cff00ff00%s|r wurde erstellt.", -- Needs review
        REG_PLAYER_GLANCE_BAR_TARGET = "\"Auf den ersten Blick\" Voreinstellungen", -- Needs review
        REG_PLAYER_GLANCE_CONFIG = [=[
|cffffff00Links-Klick:|r Slot konfigurieren
|cffffff00Rechts-Klick:|r Slot aktivierung umschalten
|cffffff00Drag & drop:|r Slots neu anordnen]=],
        REG_PLAYER_GLANCE_EDITOR = "Slot Editor",
        REG_PLAYER_GLANCE_PRESET = "Voreinstellung laden",
        REG_PLAYER_GLANCE_PRESET_ALERT1 = "Bitte eine Kategorie und einen Namen angeben",
        REG_PLAYER_GLANCE_PRESET_CATEGORY = "Voreinstellungskategorie",
        REG_PLAYER_GLANCE_PRESET_NAME = "Voreinstellungsname",
        REG_PLAYER_GLANCE_PRESET_SAVE = "Informationen als Vorseinstellung speichern",
        REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Als Voreinstellung speichern",
        REG_PLAYER_GLANCE_PRESET_SELECT = "Voreinstellung auswählen",
        REG_PLAYER_GLANCE_TITLE = "Attributsname",
        REG_PLAYER_GLANCE_UNUSED = "Unbenutzer Slot",
        REG_PLAYER_GLANCE_USE = "Diesen Slot aktivieren",
        REG_PLAYER_HEIGHT = "Größe",
        REG_PLAYER_HEIGHT_TT = [=[Die Größe deines Charakters.
Hierfür gibt es mehrere Möglichkeiten:|c0000ff00
- Eine komplette Zahl: 170 cm, 1,45 m ...
- Eine Beschreibung: großgewachsen, klein ...]=], -- Needs review
        REG_PLAYER_HERE = "Position abfragen",
        REG_PLAYER_HERE_TT = "Klicke hier, um deine aktuelle Position abzufragen", -- Needs review
        REG_PLAYER_HISTORY = "Hintergrund",
        REG_PLAYER_ICON = "Charaktericon", -- Needs review
        REG_PLAYER_ICON_TT = "Wähle eine Grafik, die deinen Charakter symbolisiert.", -- Needs review
        REG_PLAYER_IGNORE = "Ignoriere verlinkte Charaktere (%s)",
        REG_PLAYER_IGNORE_WARNING = [=[Möchtest du diese Charaktere ignorieren?

|cffff9900%s

|rOptional kannst du einen Grund angeben. Dies ist eine persönliche Notiz und kann nur von dir eingesehen werden.]=],
        REG_PLAYER_LASTNAME = "Nachname",
        REG_PLAYER_LASTNAME_TT = "Dies ist der Familienname deines Charakters.",
        REG_PLAYER_LEFTTRAIT = "Linkes Attribut",
        REG_PLAYER_MISC_ADD = "Füge ein weiteres Feld hinzu", -- Needs review
        REG_PLAYER_MORE_INFO = "Zusätzliche Informationen",
        REG_PLAYER_MSP_HOUSE = "Hausname",
        REG_PLAYER_MSP_MOTTO = "Motto",
        REG_PLAYER_MSP_NICK = "Spitzname",
        REG_PLAYER_NAMESTITLES = "Namen und Titel",
        REG_PLAYER_NO_CHAR = "Keine Charakterstik",
        REG_PLAYER_PEEK = "Verschiedenes",
        REG_PLAYER_PHYSICAL = "Aussehen",
        REG_PLAYER_PSYCHO = "Persönliche Merkmale", -- Needs review
        REG_PLAYER_PSYCHO_Acete = "Asketisch",
        REG_PLAYER_PSYCHO_ADD = "Personliches Merkmal hinzufügen", -- Needs review
        REG_PLAYER_PSYCHO_ATTIBUTENAME_TT = "Attributsname",
        REG_PLAYER_PSYCHO_Bonvivant = "Lebemann",
        REG_PLAYER_PSYCHO_CHAOTIC = "Chaotisch",
        REG_PLAYER_PSYCHO_Chaste = "Keusch",
        REG_PLAYER_PSYCHO_Conciliant = "Vorbildlich",
        REG_PLAYER_PSYCHO_Couard = "Rückgratlos",
        REG_PLAYER_PSYCHO_CREATENEW = "Erstelle einen Wert",
        REG_PLAYER_PSYCHO_Cruel = "Brutal",
        REG_PLAYER_PSYCHO_CUSTOM = "Benutzerdefinierter Wert",
        REG_PLAYER_PSYCHO_Egoiste = "Egoistisch",
        REG_PLAYER_PSYCHO_Genereux = "Altruistisch",
        REG_PLAYER_PSYCHO_Impulsif = "Impulsiv",
        REG_PLAYER_PSYCHO_Indulgent = "Vergebend",
        REG_PLAYER_PSYCHO_LEFTICON_TT = "Linkes Attributsicon auswählen.",
        REG_PLAYER_PSYCHO_Loyal = "Rechtschaffen",
        REG_PLAYER_PSYCHO_Luxurieux = "Lüstern",
        REG_PLAYER_PSYCHO_Misericordieux = "Sanft", -- Needs review
        REG_PLAYER_PSYCHO_MORE = "Punkt zu \"%s\" hinzufügen",
        REG_PLAYER_PSYCHO_PERSONAL = "Persönliche Werte",
        REG_PLAYER_PSYCHO_Pieux = "Abergläubisch",
        REG_PLAYER_PSYCHO_POINT = "Punkt hinzufügen",
        REG_PLAYER_PSYCHO_Pragmatique = "Abtrünnig",
        REG_PLAYER_PSYCHO_Rationnel = "Rational",
        REG_PLAYER_PSYCHO_Reflechi = "Vorsichtig",
        REG_PLAYER_PSYCHO_Rencunier = "Rachsüchtig",
        REG_PLAYER_PSYCHO_RIGHTICON_TT = "Rechtes Attributsicon auswählen.",
        REG_PLAYER_PSYCHO_Sincere = "Ehrlich",
        REG_PLAYER_PSYCHO_SOCIAL = "Soziale Werte",
        REG_PLAYER_PSYCHO_Trompeur = "Unehrlich",
        REG_PLAYER_PSYCHO_Valeureux = "Tapfer",
        REG_PLAYER_RACE = "Rasse",
        REG_PLAYER_RACE_TT = "Hier gehört die Rasse des Charakters rein. Die Rasse muss nicht der Spielrasse entsprechen. Es gibt im Warcraft-Universum genügend Kreaturen, die sich ähnlich sehen.", -- Needs review
        REG_PLAYER_REGISTER = "Registerinformationen", -- Needs review
        REG_PLAYER_RESIDENCE = "Heimat",
        REG_PLAYER_RESIDENCE_TT = [=[Hier kannst du angeben, wo dein Charakter normalerweise lebt. Das kann eine genaue Adresse sein (dein Heim) oder einfach der Ort oder die Region, in der dein Charakter lebt.
Wenn dein Charakter obdachlos ist oder durch die Welt streift, dann denke daran, die Informationen anzupassen.

|c00ffff00Du kannst den rechten Button verwenden, um ganz einfach den aktuellen Ort als deinen Geburtsort festzulegen.]=], -- Needs review
        REG_PLAYER_RIGHTTRAIT = "Rechtes Attribut",
        REG_PLAYER_SHOWMISC = "Zeige Sonstiges Frame",
        REG_PLAYER_SHOWMISC_TT = [=[Anwählen, wenn du benutzerdefinierte Felder auf deinem Charakter anzeigen möchtest.

Wenn du die benutzerdefinierten Felder nicht angezeigt haben willst lasse das Häkchen weg und das Sonstiges Frame wird komplett deaktiviert.]=], -- Needs review
        REG_PLAYER_SHOWPSYCHO = "Zeige Persönlichkeitsfenster", -- Needs review
        REG_PLAYER_SHOWPSYCHO_TT = [=[Anwählen, wenn du die Persönlichkeitsbeschreibung nutzen möchtest.

Wenn du die Persönlichkeit deines Charakter auf diese Art nicht angeben möchtest, dann wähle die Option nicht aus und das Persönlichkeitsfenster wird nicht angezeigt werden.]=], -- Needs review
        REG_PLAYER_STYLE_ASSIST = "Rollenspielassistenz", -- Needs review
        REG_PLAYER_STYLE_BATTLE = "RP-Kampfstil",
        REG_PLAYER_STYLE_BATTLE_1 = "World of Warcraft PVP",
        REG_PLAYER_STYLE_BATTLE_2 = "TRP Würfelkampf (noch nicht verfügbar)", -- Needs review
        REG_PLAYER_STYLE_BATTLE_3 = "/würfeln Kampf",
        REG_PLAYER_STYLE_BATTLE_4 = "Emotekampf", -- Needs review
        REG_PLAYER_STYLE_DEATH = "Akzeptiere Charaktertod", -- Needs review
        REG_PLAYER_STYLE_EMPTY = "Kein Rollenspielattribut geteilt",
        REG_PLAYER_STYLE_FREQ = "In-Character Häufigkeit", -- Needs review
        REG_PLAYER_STYLE_FREQ_1 = "Vollzeit, kein OOC",
        REG_PLAYER_STYLE_FREQ_2 = "Die meiste Zeit",
        REG_PLAYER_STYLE_FREQ_3 = "Gelegentlich",
        REG_PLAYER_STYLE_FREQ_4 = "Gewöhnlich",
        REG_PLAYER_STYLE_FREQ_5 = "Vollzeit OOC, kein RP Charakter",
        REG_PLAYER_STYLE_GUILD = "Gildenmitgliedschaft",
        REG_PLAYER_STYLE_GUILD_IC = "IC Mitglied",
        REG_PLAYER_STYLE_GUILD_OOC = "OOC Mitglied",
        REG_PLAYER_STYLE_HIDE = "Nicht anzeigen",
        REG_PLAYER_STYLE_INJURY = "Akzeptiere Charakterverletzungen", -- Needs review
        REG_PLAYER_STYLE_PERMI = "Mit Spielererlaubnis", -- Needs review
        REG_PLAYER_STYLE_ROMANCE = "Akzeptiere Charakterromanze", -- Needs review
        REG_PLAYER_STYLE_RPSTYLE = "Rollenspielstil", -- Needs review
        REG_PLAYER_STYLE_RPSTYLE_SHORT = "RP Stil",
        REG_PLAYER_STYLE_WOWXP = "World of Warcraft Erfahrung",
        REG_PLAYER_TITLE = "Titel",
        REG_PLAYER_TITLE_TT = [=[Der Titel deines Charakters ist der Titel, mit dem er angesprochen wird. Vermeide bitte lange Titel, für diesen Zweck kannst du das Feld "Kompletter Titel" verwenden.

Beispiele |c0000ff00passender Titel |r:
|c0000ff00- Graf,
- Vogt,
- Magier,
- Lord,
- etc.
|rBeispiele |cffff0000unpassender Titel|r:
|cffff0000- Graf der Nordmarschen,
- Erzmagier des Zirkels von Sturmwind,
- Diplomat der Draenei,
- etc.]=], -- Needs review
        REG_PLAYER_TRP2_PIERCING = "Piercings", -- Needs review
        REG_PLAYER_TRP2_TATTOO = "Tattoos", -- Needs review
        REG_PLAYER_TRP2_TRAITS = "Gesichtzüge", -- Needs review
        REG_PLAYER_TUTO_ABOUT_COMMON = [=[|cff00ff00Charaktersoundtrack:|r
Du kannst einen |cffffff00Soundtrack|r für deinen Charakter aussuchen. Stell es dir als |cffffff00Hintergundmusik beim Lesen deiner Charakterbeschreibung vor|r.

|cff00ff00Hintergund:|r
Dies ist eine |cffffff00Hintergrundtextur|r für deine Charakterbeschreibung.

|cff00ff00Template:|r
Das gewählte Template gibt Auskunft über |cffffff00das generelle Aussehen und die Schriftmöglichkeiten|r deiner Beschreibung.
|cffff9900Nur das ausgewählte Template ist für andere sichtbar. Du musst also nicht alle ausfüllen.|r
Sobald ein Template ausgewählt ist, kannst du das Tutorial nochmals öffnen, um dir Hilfe zu jedem Template anzeigen zu lassen.]=], -- Needs review
        REG_PLAYER_TUTO_ABOUT_MISC_1 = [=[Dieser Teil stellt dir|cffffff005 Slots|r zur Verfügung, in denen du die |cff00ff00wichtigsten Informationen zu deinem Charakter|r beschreiben kannst.

Die Slots sind in |cffffff00"Auf den ersten Blick"|r ersichtlich wenn jemand deinen Charakter anwählt.

|cff00ff00Hinweis: Du kannst die Slots per Drag&Drop neu anordnen.|r
Das funktioniert auch in der Sektion |cffffff00"Auf den ersten Blick"|r!]=], -- Needs review
        REG_PLAYER_TUTO_ABOUT_MISC_3 = "Dieser Teil enthält |cffffff00eine Liste von Informationen|r, die eine Menge |cffffff00einfache Fragen zu der Art, wie du deinen Charakter spielst, beantwortet|r.", -- Needs review
        REG_PLAYER_TUTO_ABOUT_T1 = [=[Dieses Template erlaubt dir deine |cff00ff00Beschreibung frei zu gestalten|r.

Die Beschreibung muss nicht auf die |cffff9900physische Beschreibung|r deines Charakters beschränkt sein. Gibt ruhig Teile seines |cffff9900Hintergrundes|r oder Details zu seiner |cffff9900Persönlichkeit|r an.

Mit diesem Template hast du Zugriff auf die Formatierungstools, um beispielsweise |cffffff00Schriftgröße, Farben und Ausrichtung|r zu beeinflussen.
Diese Tools erlauben auch das Einfügen von |cffffff00Bildern, Icons oder Links zu externen Internetseiten|r.]=], -- Needs review
        REG_PLAYER_TUTO_ABOUT_T2 = [=[Dieses Template ist ein wenig strukturierter und besteht aus |cff00ff00einer Reihe unabhängiger Fenster|r.

Jedes Fenster wird von einem eigenen |cffffff00Icon, einem Hintergrund und eineem Text|r repräsentiert. Beachte das du hier Texttags in diesen Fenstern nutzen kannst, genauso kannst du auch Farb- oder Icon-Tags verwenden.

Die Beschreibung muss nicht auf die |cffff9900physische Beschreibung|r deines Charakters beschränkt sein. Gibt ruhig Teile seines |cffff9900Hintergrundes|r oder Details zu seiner |cffff9900Persönlichkeit|r an.]=], -- Needs review
        REG_PLAYER_TUTO_ABOUT_T3 = [=[Dieses Template ist in 3 Teile unterteilt: |cff00ff00Die Physische Beschreibung, Persönlichkeit und Hintergrundgeschichte|r.

Du musst nicht alle Fenster ausfüllen, |cffff9900wenn du eines frei läßt wird es in deiner Beschreibung einfach nicht angezeigt|r.

Jedes Fenster wird von einem eigenen |cffffff00Icon, einem Hintergrund und einem Text|r repräsentiert. Beachte das du hier Texttags in diesen Fenstern nutzen kannst, genauso kannst du auch Farb- oder Icon-Tags verwenden.]=], -- Needs review
        REG_PLAYER_WEIGHT = "Körperform",
        REG_PLAYER_WEIGHT_TT = [=[Dies ist die Körperform deines Charakters.
Zum Beispiel kann du folgendes angeben |c0000ff00schlank, dick or muskulös...|r oder einfach durchschnittlich!]=], -- Needs review
        REG_REGISTER = "Register",
        REG_REGISTER_CHAR_LIST = "Charakterliste",
        REG_RELATION = "Beziehung", -- Needs review
        REG_RELATION_BUSINESS = "Geschäftlich",
        REG_RELATION_BUSINESS_TT = "%s und %s haben eine Geschäftsbeziehung.", -- Needs review
        REG_RELATION_BUTTON_TT = [=[Beziehung: %s
|cff00ff00%s

|cffffff00Klicke, um mögliche Aktionen zu wählen]=], -- Needs review
        REG_RELATION_FAMILY = "Familie",
        REG_RELATION_FAMILY_TT = "%s hat Blutsbande mit %s.",
        REG_RELATION_FRIEND = "Freundlich",
        REG_RELATION_FRIEND_TT = "%s nennt %s einen Freund.",
        REG_RELATION_LOVE = "Liebe",
        REG_RELATION_LOVE_TT = "%s ist in %s verliebt!",
        REG_RELATION_NEUTRAL = "Neutral",
        REG_RELATION_NEUTRAL_TT = "%s hat keine spezielle Beziehung zu %s.",
        REG_RELATION_NONE = "Keine",
        REG_RELATION_NONE_TT = "%s kennt %s nicht.",
        REG_RELATION_TARGET = "|cffffff00Klick: |rBeziehung ändern",
        REG_RELATION_UNFRIENDLY = "Unfreundlich",
        REG_RELATION_UNFRIENDLY_TT = "%s mag %s offensichtlich nicht.",
        REG_TT_GUILD = "%s von |cffff9900%s",
        REG_TT_GUILD_IC = "IC Mitglied",
        REG_TT_GUILD_OOC = "OOC Mitglied",
        REG_TT_IGNORED = "< Charakter ist ignoriert >",
        REG_TT_IGNORED_OWNER = "< Besitzer ist ignoriert >",
        REG_TT_LEVEL = "Level %s %s",
        REG_TT_NOTIF = "Ungelesene Beschreibung",
        REG_TT_REALM = "Realm: |cffff9900%s",
        REG_TT_TARGET = "Ziel: |cffff9900%s",
        TB_AFK_MODE = "AFK",
        TB_DND_MODE = "Nicht stören (DnD)",
        TB_GO_TO_MODE = "Zu %s Modus wechseln",
        TB_LANGUAGE = "Sprache", -- Needs review
        TB_LANGUAGES_TT = "Sprache wechseln", -- Needs review
        TB_NORMAL_MODE = "Normal",
        TB_RPSTATUS_OFF = "Charakter: |cffff0000Out of Character (OOC)", -- Needs review
        TB_RPSTATUS_ON = "Charakter: |cff00ff00In Character (IC)", -- Needs review
        TB_RPSTATUS_TO_OFF = "Zu |cffff0000Out of Character|r wechseln", -- Needs review
        TB_RPSTATUS_TO_ON = "Zu |cff00ff00In Character|r wechseln", -- Needs review
        TB_STATUS = "Spieler",
        TB_SWITCH_CAPE_1 = "Zeige Umhang",
        TB_SWITCH_CAPE_2 = "Verstecke Umhang",
        TB_SWITCH_CAPE_OFF = "Umhang: |cffff0000Versteckt", -- Needs review
        TB_SWITCH_CAPE_ON = "Umhang: |cff00ff00Angezeigt", -- Needs review
        TB_SWITCH_HELM_1 = "Zeige Helm",
        TB_SWITCH_HELM_2 = "Verstecke Helm",
        TB_SWITCH_HELM_OFF = "Helm: |cffff0000Versteckt", -- Needs review
        TB_SWITCH_HELM_ON = "Helm: |cff00ff00Angezeigt", -- Needs review
        TB_SWITCH_PROFILE = "Zu einem anderen Profil wechseln",
        TB_SWITCH_TOOLBAR = "Toolbar umschalten",
        TB_TOOLBAR = "Toolbar",
        TF_IGNORE = "Spieler ignorieren",
        TF_IGNORE_CONFIRM = [=[Bist du sicher das du die ID ignorieren willst?

|cffffff00%s|r

|cffff7700Du kannst optional angeben, warum die diesen Spieler ignorierst. Dies ist eine persönliche Notiz und kann nicht von anderen Spielern eingesehen werden.]=], -- Needs review
        TF_IGNORE_NO_REASON = "Kein Grund",
        TF_IGNORE_TT = "|cffffff00Klicken:|r Spieler ignorieren",
        TF_OPEN_CHARACTER = "Charakterseite anzeigen",
        TF_OPEN_COMPANION = "Begleiterseite anzeigen",
        TF_PLAY_THEME = "Charaktersoundtrack abspielen",
        TF_PLAY_THEME_TT = [=[|cffffff00Linksklick:|r Abspielen |cff00ff00%s
|cffffff00Rechtsklick:|r Stop]=], -- Needs review
        UI_BKG = "Hintergrund %s", -- Needs review
        UI_CLOSE_ALL = "Alle schließen",
        UI_COLOR_BROWSER = "Farbwähler", -- Needs review
        UI_COLOR_BROWSER_SELECT = "Farbe auswählen",
        UI_COMPANION_BROWSER_HELP = "Wähle ein Wildtier", -- Needs review
        UI_COMPANION_BROWSER_HELP_TT = [=[|cffffff00Warnung: |rNur umbenannte Wildtiere dürfen mit einem Profil verbunden werden.

|cff00ff00Dieser Bereich enthält nur diese Wildtiere.]=], -- Needs review
        UI_FILTER = "Filter",
        UI_ICON_BROWSER = "Iconbrowser", -- Needs review
        UI_ICON_BROWSER_HELP = "Icon kopieren", -- Needs review
        UI_ICON_BROWSER_HELP_TT = [=[Während dieses Fenter geöffnet ist, kannst du mit |cffffff00ctrl + Klick|r auf ein Icon anwenden, um dessen Namen zu kopieren.

Das funktioniert:|cff00ff00
- Mit jedem Item in deinem Inventar
- Mit jeder Fähigkeit in deinem Zauberbuch|r]=], -- Needs review
        UI_ICON_SELECT = "Icon auswählen",
        UI_IMAGE_BROWSER = "Bildbrowser", -- Needs review
        UI_IMAGE_SELECT = "Bild auswählen",
        UI_LINK_TEXT = "Dein Text",
        UI_LINK_URL = "http://deine.url.hier.de",
        UI_LINK_WARNING = [=[Hier ist die Link URL.
Du kannst sie per Copy/Paste in deinen Browser kopieren.

|cffff0000!! Disclaimer !!|r
Total RP ist NICHT für Links verantwortlich, die auf schädlichen oder illegalen Inhalt verweisen!]=], -- Needs review
        UI_MUSIC_BROWSER = "Musikbrowser", -- Needs review
        UI_MUSIC_SELECT = "Musik auswählen",
        UI_TUTO_BUTTON = "Tutorialmodus", -- Needs review
        UI_TUTO_BUTTON_TT = "Klicke, um den Tutorialmodus ein/aus zu schalten", -- Needs review
    }
};

TRP3_API.locale.registerLocale(LOCALE_DE);