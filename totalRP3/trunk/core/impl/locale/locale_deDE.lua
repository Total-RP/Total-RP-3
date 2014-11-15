----------------------------------------------------------------------------------
-- Total RP 3
-- German locale
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--	Translation into German: Benjamin Strecker - Týberîás @Die Aldor-EU (zerogravityspider@gmx.net)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local LOCALE_DE = {
	locale = "deDE",
	localeText = "Deutsch",
	localeContent = {
	
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- GENERAL
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		GEN_WELCOME_MESSAGE = "Danke das du Total RP 3 (v %s) verwendest! Viel Spaß !",
		GEN_VERSION = "Version: %s (Build %s)",
		GEN_NEW_VERSION_AVAILABLE = "Eine neue Version von Total RP 3 ist verfügbar.\n\n|cffff0000Deine Version : %s\n|c0000ff00Neue Version %s|r\n\n|cffff9900Wir empfehlen dir immer die aktuelleste Version zu verwenden.|r\n\nDiese Meldung wird nur einmal pro Sitzung angezeigt und kann in den Einstellungen abgeschaltet werden.",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- REGISTER
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		REG_PLAYER = "Charakter",
		REG_PLAYER_CHANGE_CONFIRM = "Du hast ungespeicherte Daten.\nMöchtest du die Seite dennoch wechseln ?\n|cffff9900Alle änderungen gehen verloren.",
		REG_PLAYER_CARACT = "Charakteristiken",
		REG_PLAYER_NAMESTITLES = "Namen und Titel",
		REG_PLAYER_CHARACTERISTICS = "Charakteristiken",
		REG_PLAYER_REGISTER = "Register Informationen",
		REG_PLAYER_ICON = "Charakter Icon",
		REG_PLAYER_ICON_TT = "W\ähle eine Grafik die deinen Charakter symbolisiert.",
		REG_PLAYER_TITLE = "Titel",
		REG_PLAYER_TITLE_TT = "Der Titel deines Charakters ist der Titel unter welchem er angesprochen wird. Vermeide bitte lange Titel, für diesen Zweck kannst du das Feld \"Kompletter Titel\" verwenden.\n\n"
								.."Beispiel |c0000ff00passender Titel |r:\n|c0000ff00- Graf,\n- Vogt,\n- Magier,\n- Lord,\n- etc.\n|r"
								.."Beispiel |cffff0000unpassender Titel|r:\n|cffff0000- Graf der Nordmarschen,\n- Erzmagier des Zirkels von Sturmwind,\n- Diplomat der Draenei,\n- etc.",
		REG_PLAYER_FIRSTNAME = "Vorname",
		REG_PLAYER_FIRSTNAME_TT = "Das ist der Vorname deines Charakters. Dies ist ein Freies Feld, wenn du nichts einträgst wird der Spielname (|cffffff00%s|r) deines Charakters benutzt."
								.."\n\nDu kannst einen |c0000ff00Spitznamen|r verwenden!",
		REG_PLAYER_LASTNAME = "Nachname",
		REG_PLAYER_LASTNAME_TT = "Dies ist der Familienname deines Charakters.",
		REG_PLAYER_HERE = "Position abfragen",
		REG_PLAYER_HERE_TT = "Klicke hier um deine aktuelle Position abzufragen",
		REG_PLAYER_COLOR_CLASS = "Klassenfarbe",
		REG_PLAYER_COLOR_CLASS_TT = "Dies bestimmt ebenfalls die Farbe des Charakternamens.\n\n",
		REG_PLAYER_COLOR_TT = "|cffffff00Links-Klick:|r Wähle eine Farbe\n|cffffff00Rechts-Klick:|r Farbe abwählen",
		REG_PLAYER_FULLTITLE = "Voller Titel",
		REG_PLAYER_FULLTITLE_TT = "Hier kannst du den Vollen Titel deines Charakter eintragen. Dies kann der komplette volle Titel deines Charakters oder weiter Titel sein.\n\nWie dem auch sei, versuche bitte Wiederholungen zu vermeinden falls es keine weiteren Informationen zu deinem Titel mehr gibt.",
		REG_PLAYER_RACE = "Rasse",
		REG_PLAYER_RACE_TT = "Hier gehört die Rasse des Charakters rein. Die Rass muss nicht der Spielrasse entsprechen. Es gibt im Warcraft-Universum genügen Kreaturen welche sich das Aussehen teilen ...",
		REG_PLAYER_BKG = "Hintergrundlayout",
		REG_PLAYER_BKG_TT = "Dies Repräsentiert den grafischen Hintergrund für dein Charakteristikfenster.",
		REG_PLAYER_CLASS = "Klasse",
		REG_PLAYER_CLASS_TT = "Die Klasse deines Charakters.\n\n|cff00ff00Zum Beispiel :|r\nRitter, Pyromane, Nekromant, Eliteschütze, Arkanwirker, Magd ...",
		REG_PLAYER_AGE = "Alter",
		REG_PLAYER_AGE_TT = "Hier kannst du angeben wie alt dein Charakter ist.\n\nHierfür gibt es mehrere Möglichkeiten:|c0000ff00\n- Du kannst Jahre angeben,\n- Oder ein Adjektiv (jung, ausgewachsen, erwachsen, steinalt, etc.).",
		REG_PLAYER_EYE = "Augenfarbe",
		REG_PLAYER_EYE_TT = "Hier kannst du die Augenfarbe eintragen.\n\nBedenke bitte das, auch wenn dein Charakter ein komplett verhülltes Gesicht hat, es trotzdem sinvoll sein kann die Augenfarbe hier zu erwähnen.",
		REG_PLAYER_HEIGHT = "Größe",
		REG_PLAYER_HEIGHT_TT = "Die Größe deines Charakters.\nHierführ gibt es mehrere Möglichkeiten:|c0000ff00\n- Eine komplette Zahl: 170 cm, 1,45 m \" ...\n- Eine Beschreibung: großgewachsen, klein ...",
		REG_PLAYER_WEIGHT = "Körperform",
		REG_PLAYER_WEIGHT_TT = "Dies ist die Körperform deines Charakters.\nZum Beispiel kann du folgendes angeben |c0000ff00schlank, dick or muskulös...|r oder einfach \"normal\" !",
		REG_PLAYER_BIRTHPLACE = "Geburtsort",
		REG_PLAYER_BIRTHPLACE_TT = "Hier kannst du den Geburtsort deines Charakters angeben. Das kann entweder ein Ort, eine Zone oder ein Kontinent sein. Es liegt ganz an dir wie akkurat du dies angeben möchtest.\n\n"
									.."|c00ffff00Du kannst den Button rechts verwenden um ganz einfach den aktuellen Ort als deinen Geburtsort festzulegen.",
		REG_PLAYER_RESIDENCE = "Heimat",
		REG_PLAYER_RESIDENCE_TT = "Hier kannst du angeben wo dein Charakter normalerweiße lebt. Das kann eine genaue Adresse sein (dein Heim) oder einfach der Ort oder die Region in der dein Charakter lebt."
									.."\nWenn dien Charakter Obdachlos ist oder durch die Welt streift dann denke daran die hier jeweils passend einzutragen.\n\n|c00ffff00Du kannst den Button rechts verwenden um ganz einfach den aktuellen Ort als deinen Geburtsort festzulegen.",
		REG_PLAYER_MSP_MOTTO = "Motto",
		REG_PLAYER_MSP_HOUSE = "Hausname",
		REG_PLAYER_MSP_NICK = "Spitzname",
		REG_PLAYER_PSYCHO = "Persönliche Werte",
		REG_PLAYER_HISTORY = "Hintergrund",
		REG_PLAYER_MORE_INFO = "Zusätzliche Informationen",
		REG_PLAYER_PHYSICAL = "Aussehen",
		REG_PLAYER_NO_CHAR = "Keine Charakterstik",
		REG_PLAYER_SHOWPSYCHO = "Zeige persönlichen Ruhm",
		REG_PLAYER_SHOWPSYCHO_TT = "Wählen ob du die Persönlichkeitsbeschreibung nutzen möchtest.\n\nWenn du die Persönlichkeit deines Charakter auf diese Art nicht angeben möchtest dann wähle die Option nicht aus und das Persönlichkeits Fenster wird nicht angezeigt werden.",
		REG_PLAYER_PSYCHO_ADD = "Personlichen Wert hinzufügen",
		REG_PLAYER_PSYCHO_POINT = "Punkt hinzufügen",
		REG_PLAYER_PSYCHO_MORE = "Punkt zu \"%s\" hinzufügen",
		REG_PLAYER_PSYCHO_ATTIBUTENAME_TT = "Attributsname",
		REG_PLAYER_PSYCHO_RIGHTICON_TT = "Rechtes Attributsicon auswählen.",
		REG_PLAYER_PSYCHO_LEFTICON_TT = "Linkes Attributsicon auswählen.",
		REG_PLAYER_PSYCHO_SOCIAL = "Soziale Werte",
		REG_PLAYER_PSYCHO_PERSONAL = "Persönliche Werte",
		REG_PLAYER_PSYCHO_CHAOTIC = "Chaotisch";
		REG_PLAYER_PSYCHO_Loyal = "Rechtschaffen";
		REG_PLAYER_PSYCHO_Chaste = "Keusch";
		REG_PLAYER_PSYCHO_Luxurieux = "Lüstern";
		REG_PLAYER_PSYCHO_Indulgent = "Vergebend";
		REG_PLAYER_PSYCHO_Rencunier = "Rachsüchtig";
		REG_PLAYER_PSYCHO_Genereux = "Altruistisch";
		REG_PLAYER_PSYCHO_Egoiste = "Egoistisch";
		REG_PLAYER_PSYCHO_Sincere = "Ehrlich";
		REG_PLAYER_PSYCHO_Trompeur = "Unehrlich";
		REG_PLAYER_PSYCHO_Misericordieux = "Höflich";
		REG_PLAYER_PSYCHO_Cruel = "Brutal";
		REG_PLAYER_PSYCHO_Pieux = "Abergläubisch";
		REG_PLAYER_PSYCHO_Pragmatique = "Abtrünnig";
		REG_PLAYER_PSYCHO_Conciliant = "Vorbildlich";
		REG_PLAYER_PSYCHO_Rationnel = "Rational";
		REG_PLAYER_PSYCHO_Reflechi = "Vorsichtig";
		REG_PLAYER_PSYCHO_Impulsif = "Impulsiv";
		REG_PLAYER_PSYCHO_Acete = "Asketisch";
		REG_PLAYER_PSYCHO_Bonvivant = "Lebemann";
		REG_PLAYER_PSYCHO_Valeureux = "Tapfer";
		REG_PLAYER_PSYCHO_Couard = "Rückgratlos";
		REG_PLAYER_PSYCHO_CUSTOM = "Benutzerdefinierter Wert",
		REG_PLAYER_PSYCHO_CREATENEW = "Erstelle einen Wert",
		REG_PLAYER_LEFTTRAIT = "Linkes Attribut",
		REG_PLAYER_RIGHTTRAIT = "Rechtes Attribut",
		REG_DELETE_WARNING = "Bist du sicher das du %s's Profil löschen möchtest?\n",
		REG_IGNORE_TOAST = "Charakter ignoriert",
		REG_PLAYER_IGNORE = "Ignoriere verlinkte Charaktere (%s)",
		REG_PLAYER_IGNORE_WARNING = "Möchtest du diese Charaktere ignorieren?\n\n|cffff9900%s\n\n|rOptional kannst du einen Grund angeben. Dies ist eine persönliche Notiz und kann nur von dir eingesehen werden.",
		REG_PLAYER_SHOWMISC = "Zeige Sonstiges Frame",
		REG_PLAYER_SHOWMISC_TT = "Abhaken wenn du benutzerdefinierte Felder auf deinem Charakter anzeigen möchtest.\n\nWenn du die benutzerdefinierten Felder nicht angezeigt haben willst lasse das Häkchen weg und das Sonstiges Frame wird komplett deaktiviert.",
		REG_PLAYER_MISC_ADD = "Füge ein weiters Feld hinzu",
		REG_PLAYER_ABOUT = "Über",
		REG_PLAYER_ABOUTS = "Über %s",
		REG_PLAYER_ABOUT_MUSIC = "Charakter Soundtrack",
		REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900Kein Soundtrack",
		REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900Unbekannter Soundtrack",
		REG_PLAYER_ABOUT_MUSIC_SELECT = "Charakter Soundtrack wählen",
		REG_PLAYER_ABOUT_MUSIC_REMOVE = "Soundtrack abwählen",
		REG_PLAYER_ABOUT_MUSIC_LISTEN = "Soundtrack abspielen",
		REG_PLAYER_ABOUT_MUSIC_STOP = "Soundtrack stoppen",
		REG_PLAYER_ABOUT_MUSIC_SELECT2 = "Soundtrack wählen",
		REG_PLAYER_ABOUT_T1_YOURTEXT = "Dein Text hier",
		REG_PLAYER_ABOUT_HEADER = "Title tag",
		REG_PLAYER_ABOUT_ADD_FRAME = "Fenster hinzufügen",
		REG_PLAYER_ABOUT_REMOVE_FRAME = "Diese Fenster entfernen",
		REG_PLAYER_ABOUT_P = "Paragraph tag",
		REG_PLAYER_ABOUT_TAGS = "Formatierungstools",
		REG_PLAYER_ABOUT_SOME = "Irgendein Text ...",
		REG_PLAYER_ABOUT_VOTE_UP = "Ich mag den Inhalt",
		REG_PLAYER_ABOUT_VOTE_DOWN = "Ich mag diesen Inhalt nicht",
		REG_PLAYER_ABOUT_VOTE_TT = "Diese Abstimmung ist komplett anonym und kann nur vom bewerteten Spieler gesehen werden.",
		REG_PLAYER_ABOUT_VOTE_TT2 = "Du kannst nur abstimmen wenn der Charakter Online ist .",
		REG_PLAYER_ABOUT_VOTE_NO = "Kein Charakter der mit diesem Profil verbunden ist schein Online zu sein.\nMöchtest du Total RP 3 trotzdem abstimmen lassen?",
		REG_PLAYER_ABOUT_VOTE_SENDING = "Sende deine abstimmung an %s ...",
		REG_PLAYER_ABOUT_VOTE_SENDING_OK = "Deine Abstimmung wurde an %s gesendet!",
		REG_PLAYER_ABOUT_VOTES = "Statistiken",
		REG_PLAYER_ABOUT_VOTES_R = "|cff00ff00%s Inhalt liken\n|cffff0000%s Inhalt nicht Liken",
		REG_PLAYER_ABOUT_EMPTY = "Keine Beschreibung",
		REG_PLAYER_STYLE_RPSTYLE_SHORT = "RP Stil",
		REG_PLAYER_STYLE_RPSTYLE = "Rollenspiel Stil",
		REG_PLAYER_STYLE_HIDE = "Nicht anzeigen",
		REG_PLAYER_STYLE_WOWXP = "World of Warcraft Erfahrung",
		REG_PLAYER_STYLE_FREQ = "In-character Verhalten",
		REG_PLAYER_STYLE_FREQ_1 = "Vollzeit, kein OOC",
		REG_PLAYER_STYLE_FREQ_2 = "Die meiste Zeit",
		REG_PLAYER_STYLE_FREQ_3 = "Gelegentlich",
		REG_PLAYER_STYLE_FREQ_4 = "Gewöhnlich",
		REG_PLAYER_STYLE_FREQ_5 = "Vollzeit OOC, kein RP Charakter",
		REG_PLAYER_STYLE_PERMI = "Mit Spieler erlaubniss",
		REG_PLAYER_STYLE_ASSIST = "Rollenspiel Assistenz",
		REG_PLAYER_STYLE_INJURY = "Akzeptiere Charakter Verletzung",
		REG_PLAYER_STYLE_DEATH = "Akzeptiere Charakter Tot",
		REG_PLAYER_STYLE_ROMANCE = "Akzeptiere Charakter Romanze",
		REG_PLAYER_STYLE_BATTLE = "RP-Kampfstil",
		REG_PLAYER_STYLE_BATTLE_1 = "World of Warcraft PVP",
		REG_PLAYER_STYLE_BATTLE_2 = "TRP Wüfelkampf (noch nicht verfügbar)",
		REG_PLAYER_STYLE_BATTLE_3 = "/würfeln Kampf",
		REG_PLAYER_STYLE_BATTLE_4 = "Emote Kampf",
		REG_PLAYER_STYLE_EMPTY = "Kein Rollenspielattribut geteilt",
		REG_PLAYER_STYLE_GUILD = "Gildenmitgliedschaft",
		REG_PLAYER_STYLE_GUILD_IC = "IC Mitglied",
		REG_PLAYER_STYLE_GUILD_OOC = "OOC Mitglied",
		REG_PLAYER_ALERT_HEAVY_SMALL = "|cffff0000Die größe deines Profils ist sehr groß.\n|cffff9900Du solltest die größe reduzieren.",
		CO_GENERAL_HEAVY = "Großes Profil",
		CO_GENERAL_HEAVY_TT = "Bekomme einen Warnhinweis wenn dein Profil eine verträgliche Größe überschreitet.",
		REG_PLAYER_PEEK = "Verschiedenes",
		REG_PLAYER_CURRENT = "Aktuelles",
		REG_PLAYER_CURRENTOOC = "Aktuelles (OOC)",
		REG_PLAYER_CURRENT_OOC = "Dies ist eine OOC Information";
		REG_PLAYER_GLANCE = "Auf den ersten Blick",
		REG_PLAYER_GLANCE_USE = "Diesen Slot aktivieren",
		REG_PLAYER_GLANCE_TITLE = "Attributsname",
		REG_PLAYER_GLANCE_UNUSED = "Unbenutzer Slot",
		REG_PLAYER_GLANCE_CONFIG = "\n|cffffff00Links-Klick:|r Slot konfigurieren\n|cffffff00Rechts-Klick:|r Slot aktivierung umschalten\n|cffffff00Drag & drop:|r Slots neu anordnen",
		REG_PLAYER_GLANCE_EDITOR = "Slot Editor",
		REG_PLAYER_GLANCE_PRESET = "Voreinstellung laden",
		REG_PLAYER_GLANCE_PRESET_SELECT = "Voreinstellung auswählen",
		REG_PLAYER_GLANCE_PRESET_SAVE = "Informationen als Vorseinstellung speichern",
		REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Als Voreinstellung speichern",
		REG_PLAYER_GLANCE_PRESET_CATEGORY = "Voreinstellungskategorie",
		REG_PLAYER_GLANCE_PRESET_NAME = "Voreinstellungsname",
		REG_PLAYER_GLANCE_PRESET_NONE = "Leerer Slot",
		REG_PLAYER_GLANCE_PRESET_ALERT1 = "Bitte eine Kategorie und einen Namen angeben",
		REG_PLAYER_GLANCE_PRESET_ALERT2 = "Es gibt schon eine Voreinstellung Namens %s",
		REG_PLAYER_TUTO_ABOUT_COMMON = [[|cff00ff00Charakter Soundtrack:|r
Du kannst einen |cffffff00Soundtrack|r für deinen Charakter aussuchen. Stell es dir als |cffffff00Hintergundmusik beim Lesen deiner Charakterbeschreibung vor|r.

|cff00ff00Hintergund:|r
Dies ist eine |cffffff00Hintergrundtextur|r für deine Charakterbeschreibung.

|cff00ff00Template:|r
Das gewählte Template gibt Auskunft über |cffffff00das generelle Aussehen und die Schriftmöglichkeiten|r deiner Beschreibung.
|cffff9900Nur das ausgewählte Template ist für andere sichtbar du musst allso nicht alle ausfüllen.|r
Sobald ein Template ausgewählt ist, kannst du das Tutorial nochmals öffnen um dir Hilfe zu jedem Template anzeigen zu lassen.]],
		REG_PLAYER_TUTO_ABOUT_T1 = [[Dieses Template erlaubt dir deine |cff00ff00Beschreibung frei zu gestalten|r.

Die Beschreibung muss nicht auf die |cffff9900physische Beschreibung|r deines Charakters beschränkt sein. Gibt ruhig Teile seines |cffff9900Hintergrundes|r oder Details zu seiner |cffff9900Persönlichkeit|r an.

Mit diesem Template hast du Zugriff auf die Formatierungstools um so Dinge wie |cffffff00Schriftgröße, Farben und Ausrichtung|r zu beeinflussen.
Diese Tools erlauben auch das Einfügen von |cffffff00Bildern, Icons oder Links zu externen Internetseiten|r.]],
		REG_PLAYER_TUTO_ABOUT_T2 = [[Dieses Template ist ein wenig strukturierter und besteht aus |cff00ff00einer Reihe unabhängiger Fenster|r.

Jedes Fenster wird von einem eigenen |cffffff00Icon, einem Hintergrund und eineem Text|r repräsentiert. Beachte das du hier Texttags in diesen Fenstern nutzen kannst, genau so kanns du auch Farbe oder Icon Tags verwenden.

Die Beschreibung muss nicht auf die |cffff9900physische Beschreibung|r deines Charakters beschränkt sein. Gibt ruhig Teile seines |cffff9900Hintergrundes|r oder Details zu seiner |cffff9900Persönlichkeit|r an.]],
		REG_PLAYER_TUTO_ABOUT_T3 = [[Dieses Template ist in 3 Teile unterteilt: |cff00ff00Die Physische Beschreibung, Persönlichkeit und Hintergrundgeschichte|r.

Du musst nicht alle Fenster ausfüllen, |cffff9900wenn du eines frei läßt wird es in deiner Beschreibung einfach nicht angezeigt|r.

Jedes Fenster wird von einem eigenen |cffffff00Icon, einem Hintergrund und eineem Text|r repräsentiert. Beachte das du hier Texttags in diesen Fenstern nutzen kannst, genau so kanns du auch Farbe oder Icon Tags verwenden.]],
		REG_PLAYER_TUTO_ABOUT_MISC_1 = [[Dieser Teil stellt dir|cffffff005 Slots|r zur Verfügung mit welchen du die |cff00ff00wichtigesten Informationen zu deinem Charakter|r aussuchen kannst.

Die Slots sind in |cffffff00"Auf den ersten Blick"|r ersichtlich wenn jemand deinen Charakter anwählt.

|cff00ff00Hint: Du kannst die Slots per Drag&Drop neu anordnen.|r
Das Funktioniert auch in der Sektion |cffffff00"Auf den ersten Blick"|r!]],
		REG_PLAYER_TUTO_ABOUT_MISC_3 = [[Dieser Teil enthält |cffffff00eine Liste von Informationen|r, welche eine Menge |cffffff00einfache Fragen zu der Art wie du deinen Charakter spielst enthält|r.]],
		REG_RELATION = "Beziehungen",
		REG_RELATION_BUTTON_TT = "Beziehung: %s\n|cff00ff00%s\n\n|cffffff00Klicken um mögliche Aktionen zu wählen",
		REG_RELATION_UNFRIENDLY = "Unfreundlich",
		REG_RELATION_NONE = "Keine",
		REG_RELATION_NEUTRAL = "Neutral",
		REG_RELATION_BUSINESS = "Geschäftlich",
		REG_RELATION_FRIEND = "Freundlich",
		REG_RELATION_LOVE = "Liebe",
		REG_RELATION_FAMILY = "Familie",
		REG_RELATION_UNFRIENDLY_TT = "%s mag %s offensichtlich nicht.",
		REG_RELATION_NONE_TT = "%s kennt %s nicht.",
		REG_RELATION_NEUTRAL_TT = "%s hat keine spezielle Beziehung zu %s.",
		REG_RELATION_BUSINESS_TT = "%s und %s haben einen Geschäftsbeziehung.",
		REG_RELATION_FRIEND_TT = "%s nennt %s einen Freund.",
		REG_RELATION_LOVE_TT = "%s ist in %s verliebt!",
		REG_RELATION_FAMILY_TT = "%s hat Blutsbande mit %s.",
		REG_RELATION_TARGET = "|cffffff00Klick: |rBeziehung ändern",
		REG_REGISTER = "Register",
		REG_REGISTER_CHAR_LIST = "Charakterliste",
		REG_TT_GUILD_IC = "IC Mitglied",
		REG_TT_GUILD_OOC = "OOC Mitglied",
		REG_TT_LEVEL = "Level %s %s",
		REG_TT_REALM = "Realm: |cffff9900%s",
		REG_TT_GUILD = "%s von |cffff9900%s",
		REG_TT_TARGET = "Ziel: |cffff9900%s",
		REG_TT_NOTIF = "Ungelesene Beschreibung",
		REG_TT_IGNORED = "< Charakter ist ignoriert >",
		REG_TT_IGNORED_OWNER = "< Besitzer ist ignoriert >",
		REG_LIST_CHAR_TITLE = "Charakterliste",
		REG_LIST_CHAR_SEL = "Charakter wählen",
		REG_LIST_CHAR_TT = "Zum anzeigen klicken",
		REG_LIST_CHAR_TT_RELATION = "Beziehung:\n|cff00ff00%s",
		REG_LIST_CHAR_TT_CHAR = "Gebundene WoW Charakter/e:",
		REG_LIST_CHAR_TT_CHAR_NO = "Nicht an einen Charakter gebunden",
		REG_LIST_CHAR_TT_DATE = "Zuletzt gesehen: |cff00ff00%s|r\nWo zuletzt gesehen: |cff00ff00%s|r",
		REG_LIST_CHAR_TT_GLANCE = "Auf den ersten Blick",
		REG_LIST_CHAR_TT_NEW_ABOUT = "Ungelesene Beschreibung",
		REG_LIST_CHAR_TT_IGNORE = "Ignorierte Charakter/e",
		REG_LIST_CHAR_FILTER = "Charaktere: %s / %s",
		REG_LIST_CHAR_EMPTY = "Kein Charakter",
		REG_LIST_CHAR_EMPTY2 = "Kein Charakter passt zu deiner Auswahl",
		REG_LIST_CHAR_IGNORED = "Ignoriert",
		REG_LIST_IGNORE_TITLE = "Ignorierten Liste",
		REG_LIST_IGNORE_EMPTY = "Kein Ignorierter Charakter",
		REG_LIST_IGNORE_TT = "Grund:\n|cff00ff00%s\n\n|cffffff00Klicken um von der Liste zu streichen",
		REG_LIST_PETS_FILTER = "Begleiter: %s / %s",
		REG_LIST_PETS_TITLE = "Begleiterliste",
		REG_LIST_PETS_EMPTY = "Kein/e Begleiter",
		REG_LIST_PETS_EMPTY2 = "Kein Begleiter passt zu deiner Auswahl",
		REG_LIST_PETS_TOOLTIP = "Wurde gesehen bei",
		REG_LIST_PETS_TOOLTIP2 = "Wurde gesehen mit",
		REG_LIST_PET_NAME = "Name des Begleiters",
		REG_LIST_PET_TYPE = "Typ des Begleiters",
		REG_LIST_PET_MASTER = "Name des Herren",
		REG_LIST_FILTERS = "Filter",
		REG_LIST_FILTERS_TT = "|cffffff00Links-Klick:|r Filter anwenden\n|cffffff00Rechts-Klicken:|r Filter zurücksetzen",
		REG_LIST_REALMONLY = "Nur dieser Realm",
		REG_LIST_GUILD = "Gilde des Charakters",
		REG_LIST_NAME = "Name das Charakters",
		REG_LIST_FLAGS = "Flags",
		REG_LIST_ACTIONS_PURGE = "Register entfernen",
		REG_LIST_ACTIONS_PURGE_ALL = "Alle Profile löschen",
		REG_LIST_ACTIONS_PURGE_ALL_COMP_C = "Dies wird alle deine Begleiter löschen.\n\n|cff00ff00%s Begleiter.",
		REG_LIST_ACTIONS_PURGE_ALL_C = "Dies wird alle Profile und verlinkten Charaktere löschen.\n\n|cff00ff00%s Charaktere.",
		REG_LIST_ACTIONS_PURGE_TIME = "Seit 1 Monat nicht mehr gesehene Profile",
		REG_LIST_ACTIONS_PURGE_TIME_C = "Dies wird alle seit 1 Monat nicht mehr gesehenen Profile löschen.\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_UNLINKED = "Profile ohne Charakter",
		REG_LIST_ACTIONS_PURGE_UNLINKED_C = "Dies wird alle Profile welche nicht an einen WoW Charakter gebunden sind löschen.\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_IGNORE = "Profile von ignorierten Charakteren",
		REG_LIST_ACTIONS_PURGE_IGNORE_C = "Dies wird alle Profile welche mit ignorierten Charakteren verbunden sind löschen.\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_EMPTY = "Keine Profile zum löschen.",
		REG_LIST_ACTIONS_PURGE_COUNT = "%s Profile werden gelöscht.",
		REG_LIST_ACTIONS_MASS = "Aktion auf %s ausgewählte Profile",
		REG_LIST_ACTIONS_MASS_REMOVE = "Profile entfernen",
		REG_LIST_ACTIONS_MASS_REMOVE_C = "Diese Aktion wird |cff00ff00%s ausgewählte/s Profil/e löschen|r.",
		REG_LIST_ACTIONS_MASS_IGNORE = "Profile ignorieren",
		REG_LIST_ACTIONS_MASS_IGNORE_C = [[Diese Aktion wird |cff00ff00%s Charaktere der Ignorieren Liste hinzufügen.

Optional kann hier ein Grund angegeben werden. Dies ist eine Persönliche Notiz welche nur zur Erinnerung dient.]],
		REG_LIST_CHAR_TUTO_ACTIONS = "Diese Spalte erlabt es dir mehrere Charaktere auszuwählen um die selbe Aktion auf diese auszuführen.",
		REG_LIST_CHAR_TUTO_LIST = [[Die erste Spalte zeigt den Charakternamen.

Die zweite Spalte zeigt die Beziehung zwischen den Charakteren und deinem Charakter.

Die letzte Spalte ist für diverse Angaben. (ignoriert ..etc.)]],
		REG_LIST_CHAR_TUTO_FILTER = [[Du kannst nach verschiedenen Kriterien filtern.

Der |cff00ff00Namensfilter|r wird nach bestimmten Profilnamen suchen (Vorname + Nachname) sowie nach WoW Charakteren.

Der |cff00ff00Gildenfilter|r wird nach bestimmten Charakteren einer bestimmten Gilde suchen.

Der |cff00ff00Realm Only Filter|r wird nur nach Charakteren auf dem aktuellen Realm suchen.]],
		REG_LIST_NOTIF_ADD = "Neues Profil gefunden für |cff00ff00%s",
		REG_LIST_NOTIF_ADD_CONFIG = "Neues Profil gefunden",
		REG_LIST_NOTIF_ADD_NOT = "Dieses Profil existiert nicht mehr.",
		REG_COMPANION = "Begleiter",
		REG_COMPANIONS = "Begleiter",
		REG_COMPANION_PROFILES = "Begleiter Profile",
		REG_COMPANION_TF_PROFILE = "Begleiter Profil",
		REG_COMPANION_TF_NO = "Kein Profil",
		REG_COMPANION_TF_CREATE = "Neus Profil erstellen",
		REG_COMPANION_TF_UNBOUND = "Profil abwählen",
		REG_COMPANION_TF_BOUND_TO = "Profil auswählen",
		REG_COMPANION_TF_OPEN = "Seite öffnen",
		REG_COMPANION_TF_OWNER = "%s's %s",
		REG_COMPANION_INFO = "Information",
		REG_COMPANION_NAME = "Name",
		REG_COMPANION_TITLE = "Titel",
		REG_COMPANION_NAME_COLOR = "Namensfarbe",
		REG_MSP_ALERT = [[|cffff0000WARNUNG

Du kannst nicht mehrere Addons nutzen welche das Mary Sue Protocol (MSP) nutzen da diese zu Fehlern führen kann!|r

Aktuell geladen: |cff00ff00%s

|cffff9900Deshalb wir der MSP Support für Total RP3 deaktiviert.|r

Wenn du TRP3 nicht als dein MSP Addon nutzen und diese Meldung nicht noch einmal sehen willst kannst du das Mary Sue Protocol Modul in den TRP3 Einstellungen unter Modul Status deaktivieren.]],
		REG_COMPANION_PAGE_TUTO_C_1 = "Consult",
		REG_COMPANION_PAGE_TUTO_E_1 = "Das ist die|cff00ff00 Hauptinformation deines Begleiters|r.\n\nAll diese Informationen werden |cffff9900im Tooltip deines Begleiters angezeigt|r.",
		REG_COMPANION_PAGE_TUTO_E_2 = [[Das ist die|cff00ff00 Beschreibung deines Charakters|r.

Es ist nicht auf eine |cffff9900Physische Beschreibung|r limitiert. Gib hier ruhig teiles seiner |cffff9900Hintergrundgeschichte|r oder Details über seine |cffff9900Persönlichkeit|r an.

Es gibt unzählige Wege die Beschreibung zu personalisieren.
Du kannst eine |cffffff00Hintergrund Textur|r für die Beschreibung aussuchen. Du kannst ebenfalls die Formatierungstools verwenden um Dinge wie |cffffff00Schriftgröße, Farbe und Textausrichtung|r anzupassen.
Diese Tools erlauben dir auch das Einfügen von |cffffff00Bildern, Icons oder Links zu externen Internetseiten|r.]],

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- CONFIGURATION
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		CO_CONFIGURATION = "Einstellungen",
		CO_GENERAL = "Allgemeine Einstellungen",
		CO_GENERAL_CHANGELOCALE_ALERT = "Das Interface neu Laden um die Sprache jetzt auf %s zu ändern?\n\nWenn nicht wird die Sprache beim nächsten Login geändert.",
		CO_GENERAL_LOCALE = "Addon Sprache",
		CO_GENERAL_COM = "Kommunikation",
		CO_GENERAL_BROADCAST = "Übertragungskanal",
		CO_GENERAL_BROADCAST_TT = "Der Übertragungskanal wird für viele Funktionen genutzt. Durch das deaktivieren werden Funktionen wie die Charakterposition auf der Karte, Lokale Sounds usw. deaktivert",
		CO_GENERAL_BROADCAST_C = "Names des Übertragungskanals",
		CO_GENERAL_NOTIF = "Benachrichtigungen",
		CO_GENERAL_MISC = "Verschiedenes",
		CO_GENERAL_TT_SIZE = "Info Tooltip Textgröße",
		CO_GENERAL_NEW_VERSION = "Update Alarm",
		CO_GENERAL_NEW_VERSION_TT = "Bekomme einen \"Alarm\" wenn eine neue Version verfügbar ist.",
		CO_GENERAL_UI_SOUNDS = "UI Sounds",
		CO_GENERAL_UI_SOUNDS_TT = "Aktivert die UI Sounds(beim öffnen von Fenster, dem Wechseln zwischen Reitern, dem klicken auf Buttons).",
		CO_GENERAL_UI_ANIMATIONS = "UI Animationen",
		CO_GENERAL_UI_ANIMATIONS_TT = "Aktiviert die UI Animationen.",
		CO_TOOLTIP = "Tooltip Einstellungen",
		CO_TOOLTIP_USE = "Benutze die Tooltips für Charaktere/Begleiter",
		CO_TOOLTIP_COMBAT = "Während dem Kampf verbergen",
		CO_TOOLTIP_CHARACTER = "Charakter Tooltip",
		CO_TOOLTIP_ANCHORED = "Ankerfenster",
		CO_TOOLTIP_ANCHOR = "Ankerpunkt",
		CO_TOOLTIP_HIDE_ORIGINAL = "Verstecke Originalen Tooltip",
		CO_TOOLTIP_MAINSIZE = "Hauptschriftgröße",
		CO_TOOLTIP_SUBSIZE = "Sekundäre Schriftgöße",
		CO_TOOLTIP_TERSIZE = "Tertiäre Schriftgröße",
		CO_TOOLTIP_SPACING = "Zeige Leerzeile",
		CO_TOOLTIP_SPACING_TT = "Zeigt Leerzeilen um den Tooltip dem MyRoleplay Tooltip änhlich zu sehen.",
		CO_TOOLTIP_PETS = "Begleiter Tooltip",
		CO_TOOLTIP_OWNER = "Zeige Besitzer",
		CO_TOOLTIP_PETS_INFO = "Zeige Begleiter Informationen",
		CO_TOOLTIP_COMMON = "Standarteinstellungen",
		CO_TOOLTIP_ICONS = "Zeige Icons",
		CO_TOOLTIP_FT = "Zeige vollen Titel",
		CO_TOOLTIP_RACE = "Zeige Rasse, Klasse und Level",
		CO_TOOLTIP_REALM = "Zeige Realm",
		CO_TOOLTIP_GUILD = "Zeige Gildeninfo",
		CO_TOOLTIP_TARGET = "Zeige Ziel",
		CO_TOOLTIP_TITLE = "Zeige Titel",
		CO_TOOLTIP_CLIENT = "Zeige Client",
		CO_TOOLTIP_NOTIF = "Zeige Benachrichtigungen",
		CO_TOOLTIP_NOTIF_TT = "Die Benachrichtigungszeile enthält die Clientversion, den ungelesene Beschreibungen Marker und die \"Auf den Ersten Blick\" Marker.",
		CO_TOOLTIP_RELATION = "Zeige Beziehungs Farbe",
		CO_TOOLTIP_RELATION_TT = "Fügt dem Rand des Charakter Tooltips eine Farbe hinzu um die Beziehung zu repräsentieren.",
		CO_TOOLTIP_CURRENT = "Zeige \"aktuelle\" Informationen",
		CO_TOOLTIP_CURRENT_SIZE = "Maximale Länge von \"aktuelle\" Informationen",
		CO_TOOLTIP_PROFILE_ONLY = "Nur benutzen wenn das Ziel ein Profil hat",
		CO_REGISTER = "Einstellungen registrieren",
		CO_REGISTER_ABOUT_VOTE = "Benutze Abstimmungssystem",
		CO_REGISTER_ABOUT_VOTE_TT = "Aktiviert das Abstimmungssystem welches dir Erlaub die Beschreibung eines Charakters zu Liken oder nicht zu Liken. Hierdurch kannst auch dein Charakter bewertet werden!",
		CO_REGISTER_AUTO_ADD = "Neue Spieler automatisch hinzufügen",
		CO_REGISTER_AUTO_ADD_TT = "Automatisch neue Spieler welchen du begegnest zum Register hinzufügen.",
		CO_MODULES = "Modul Status",
		CO_MODULES_VERSION = "Version: %s",
		CO_MODULES_ID = "Modul ID: %s",
		CO_MODULES_STATUS = "Status: %s",
		CO_MODULES_STATUS_0 = "Fehlende Abhängigkeiten",
		CO_MODULES_STATUS_1 = "Geladen",
		CO_MODULES_STATUS_2 = "Deaktivert",
		CO_MODULES_STATUS_3 = "Total RP 3 Update benötigt",
		CO_MODULES_STATUS_4 = "Fehler bei der Inizialisierung",
		CO_MODULES_STATUS_5 = "Fehler beim Start",
		CO_MODULES_TT_NONE = "Keine Abhängigkeiten";
		CO_MODULES_TT_DEPS = "Abhängigkeiten";
		CO_MODULES_TT_TRP = "%sFür Total RP 3 build %s minimum.|r",
		CO_MODULES_TT_DEP = "\n%s- %s (version %s)|r",
		CO_MODULES_TT_ERROR = "\n\n|cffff0000Fehler:|r\n%s";
		CO_MODULES_TUTO = [[Ein Modul ist eine unabhängige Funktion welche aktiviert oder deaktiviert werden kann.

Möglicher Status:
|cff00ff00Geladen:|r Modul aktiviert und geladen.
|cff999999Deaktiviert:|r Modul deaktiviert.
|cffff9900Fehlende Abhängigkeiten:|r Einige Abhängigkeiten sind nicht geladen/verfügbar.
|cffff9900TRP Update benötigt:|r Diese Modul benötigt eine aktueller Version von TRP3.
|cffff0000Fehler beim Inizialisieren oder Starten:|r Der Start des Moduls hat nicht funktioniert. Das Modul würde sicher Fehler verursachen!

|cffff9900Wenn ein Modul deaktivert wird muss das UI neu geladen werden!]],
		CO_MODULES_SHOWERROR = "Zeige Fehler",
		CO_MODULES_DISABLE = "Deaktiviere Modul",
		CO_MODULES_ENABLE = "Aktiviere Modul",
		CO_TOOLBAR = "Fenster Einstellungen",
		CO_TOOLBAR_CONTENT = "Toolbar Einstellungen",
		CO_TOOLBAR_ICON_SIZE = "Icongröße",
		CO_TOOLBAR_MAX = "Maximale Icons pro Zeile",
		CO_TOOLBAR_MAX_TT = "Auf 1 stellen wenn du die Leiste vertikal angezeigt haben möchtest!",
		CO_TOOLBAR_CONTENT_CAPE = "Umhang an/aus",
		CO_TOOLBAR_CONTENT_HELMET = "Helm an/aus",
		CO_TOOLBAR_CONTENT_STATUS = "Spielerstatus (AFK/DND)",
		CO_TOOLBAR_CONTENT_RPSTATUS = "Charakterstatus (IC/OOC)",
		CO_TARGETFRAME = "Zielfenster Einstellungen",
		CO_TARGETFRAME_USE = "Anzeige Bedingungen",
		CO_TARGETFRAME_USE_TT = "Gibt an unter welchen Bedingungen das Zielfenster am Ziel gezeigt werden soll.",
		CO_TARGETFRAME_USE_1 = "Immer",
		CO_TARGETFRAME_USE_2 = "Nur wenn IC",
		CO_TARGETFRAME_USE_3 = "Niemals (Deaktiviert)",
		CO_TARGETFRAME_ICON_SIZE = "Icongröße",
		CO_MINIMAP_BUTTON = "Minimap Button",
		CO_MINIMAP_BUTTON_FRAME = "Ankerfenster",
		CO_MINIMAP_BUTTON_FRAME_TT = "Indicates which frame to use as parent for the button.\n\n|cff00ff00To move the button relatively from this frame you can drag & drop the button.",
		CO_MINIMAP_BUTTON_RESET = "Button wiederhertellen",
		CO_MINIMAP_BUTTON_RESET_TT = "Falls du den Button \"verloren\" hast kannst du ihn hiermit wiederherstellen.",
		CO_MINIMAP_BUTTON_LOCK = "Position fixieren",
		CO_MINIMAP_BUTTON_LOCK_TT = "Verhindert das der Button verschoben wird.",
		CO_MINIMAP_BUTTON_RESET = "Position zurücksetzen",
		CO_MINIMAP_BUTTON_RESET_BUTTON = "Zurücksetzen",
		CO_MINIMAP_BUTTON_RESET_TT = "Setzt den Button an die untere linke Ecke des Ankerfenster zurück.",
		CO_ANCHOR_TOP = "Oben",
		CO_ANCHOR_TOP_LEFT = "Oben Links",
		CO_ANCHOR_TOP_RIGHT = "Oben Rechts",
		CO_ANCHOR_BOTTOM = "Unten",
		CO_ANCHOR_BOTTOM_LEFT = "Unten Links",
		CO_ANCHOR_BOTTOM_RIGHT = "Unten Rechts",
		CO_ANCHOR_LEFT = "Links",
		CO_ANCHOR_RIGHT = "Rechts",
		CO_CHAT = "Chat Einstellungen",
		CO_CHAT_MAIN = "Chat Haupteinstellungen",
		CO_CHAT_MAIN_NAMING = "Benennungsmethode",
		CO_CHAT_MAIN_NAMING_1 = "Behalte originale Namen",
		CO_CHAT_MAIN_NAMING_2 = "Nutze angepasste Namen",
		CO_CHAT_MAIN_NAMING_3 = "Vorname + Nachname",
		CO_CHAT_MAIN_COLOR = "Benutze angepasste Farben für Namen",
		CO_CHAT_USE = "Benutze Chat Kanäle",
		CO_CHAT_USE_SAY = "Sagen Kanal",
		CO_CHAT_MAIN_NPC = "NPC Spracherkennung",
		CO_CHAT_MAIN_NPC_USE = "Nutze NPC Spracherkennung",
		CO_CHAT_MAIN_NPC_PREFIX = "NPC Spracherkennungssequenz",
		CO_CHAT_MAIN_NPC_PREFIX_TT = "If a chat line said in SAY, EMOTE, GROUP or RAID channel begins with this prefix, it will be interpreted as a NPC chat.\n\n|cff00ff00By default : \"|| \"\n(without the \" and with a space after the pipe)",
		CO_CHAT_MAIN_EMOTE = "Emote Erkennung",
		CO_CHAT_MAIN_EMOTE_USE = "Nutze Emote Erkennung",
		CO_CHAT_MAIN_EMOTE_PATTERN = "Emote Erkennungssequenz",
		CO_CHAT_MAIN_OOC = "OOC Erkennung",
		CO_CHAT_MAIN_OOC_USE = "Nutze OOC Erkennung",
		CO_CHAT_MAIN_OOC_PATTERN = "OOC Erkennungssequenz",
		CO_CHAT_MAIN_OOC_COLOR = "OOC Farbe",
		CO_CHAT_MAIN_EMOTE_YELL = "Keine geschriehenen Emotes",
		CO_CHAT_MAIN_EMOTE_YELL_TT = "Beim schreien *emote* oder <emote> nicht zeigen.",
		CO_GLANCE_MAIN = "\"Auf den ersten Blick\" Zeile",
		CO_GLANCE_RESET_TT = "Setze die Zeile auf die untere linke Position des Ankerfensters zurück.",
		CO_GLANCE_LOCK = "Zeile sperren",
		CO_GLANCE_LOCK_TT = "Verhinder das die Zeile verschoben wid",
		CO_GLANCE_PRESET_TRP2 = "Benutze Positionen im Total RP 2 Stil",
		CO_GLANCE_PRESET_TRP2_BUTTON = "Benutzen",
		CO_GLANCE_PRESET_TRP2_HELP = "Verknüpfung um die Zeile im TRP2 Stil aufzusetzen - Am rechten Rand des WoW Zielfensters.",
		CO_GLANCE_PRESET_TRP3 = "Benutze Positionen im Total RP 3 Stil",
		CO_GLANCE_PRESET_TRP3_HELP = "Verknüpfung um die Zeile im TRP3 Stil aufzusetzen - Am unteren Rand des TRP3 Zielfensters.",
		CO_GLANCE_TT_ANCHOR = "Tooltip Ankerpunkt",
		CO_MSP = "Mary Sue Protocol",
		CO_MSP_T3 = "Benutze nur Template 3",
		CO_MSP_T3_TT = "Event if you choose another \"about\" template, the template 3 will always be used for MSP compatibility.",
		CO_NOTIF_NO = "Keine Benachrichtigung",
		CO_NOTIF_SIMPLE = "Benachrichtigung",
		CO_NOTIF_DOUBLE = "Benachrichtigung + Chatnachricht",
		CO_NOTIF_TRIPLE = "Benachrichtigung + Chatnachricht + Raidalarm",
		CO_WIM = "|cffff9900Flüster Kanäle deaktiviert.",
		CO_WIM_TT = "Du nutzt |cff00ff00WIM|r, die Nutzung wurde aus Kompatibilitätsgründen deaktiviert",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- TOOLBAR AND UI BUTTONS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		TB_TOOLBAR = "Toolbar",
		TB_SWITCH_TOOLBAR = "Toolbar umschalten",
		TB_SWITCH_CAPE_ON = "Umhang: |cff00ff00Anzeigen",
		TB_SWITCH_CAPE_OFF = "Umhang: |cffff0000Verstecken",
		TB_SWITCH_CAPE_1 = "Zeige Umhang",
		TB_SWITCH_CAPE_2 = "Verstecke Umhang",
		TB_SWITCH_HELM_ON = "Helm: |cff00ff00Anzeigen",
		TB_SWITCH_HELM_OFF = "Helm: |cffff0000Verstecken",
		TB_SWITCH_HELM_1 = "Zeige Helm",
		TB_SWITCH_HELM_2 = "Verstecke Helm",
		TB_GO_TO_MODE = "Zu %s Modus wechseln",
		TB_NORMAL_MODE = "Normal",
		TB_DND_MODE = "Nicht stören (DnD)",
		TB_AFK_MODE = "AFK",
		TB_STATUS = "Spieler",
		TB_RPSTATUS_ON = "Charakter: |cff00ff00In character (IC)",
		TB_RPSTATUS_OFF = "Charakter: |cffff0000Out of character (OOC)",
		TB_RPSTATUS_TO_ON = "Zu |cff00ff00In character|r wechseln",
		TB_RPSTATUS_TO_OFF = "Zu |cffff0000Out of character|r wechseln",
		TB_SWITCH_PROFILE = "Zu einem anderen Profil wechseln",
		TF_OPEN_CHARACTER = "Charakterseite anzeigen",
		TF_OPEN_COMPANION = "Begleiterseite anzeigen",
		TF_PLAY_THEME = "Charaktersoundtrack abspielen",
		TF_PLAY_THEME_TT = "|cffffff00Links-Klick:|r Abspielen |cff00ff00%s\n|cffffff00Rechts-Klick:|r Stop",
		TF_IGNORE = "Spieler ignorieren",
		TF_IGNORE_TT = "|cffffff00Klicken:|r Spieler ignorieren",
		TF_IGNORE_CONFIRM = "Bist du sicher das du die ID ?\n\n|cffffff00%s|r ignorieren willst\n\n|cffff7700Du kannst Optional angeben warum die diesen Spieler ignorierst. Dies ist eine persönliche Notiz und kann nicht von anderen Spielern eingesehen werden.",
		TF_IGNORE_NO_REASON = "Kein Grund",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- PROFILES
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		PR_PROFILEMANAGER_TITLE = "Charakter Profile",
		PR_PROFILEMANAGER_DELETE_WARNING = "Bist du sicher das du das Profil %s? löschen willst\nDiese Aktion kann nicht rückgängig gemacht werden und alle TRP3 Informationen werden unwiederruflich gelöscht!",
		PR_PROFILE = "Profil",
		PR_PROFILES = "Profile",
		PR_PROFILE_CREATED = "Profile %s erstellt.",
		PR_CREATE_PROFILE = "Erstelle Profil",
		PR_PROFILE_DELETED = "Profile %s gelöscht.",
		PR_PROFILE_HELP = "Ein Profil enthält alle Informationen über einen |cffffff00\"Charakter\"|r als |cff00ff00Rollenspiel Charakter|r.\n\nEin realer |cffffff00\"WoW Charakter\"|r kann nur an ein Profil gleichzeitig gebunden sein, kann aber zwischen verschiedenen Profilen hin und her schalten.\n\nDu kannst auch mehrere |cffffff00\"WoW Charaktere\"|r an das selbe |cff00ff00Profil|r binden!",
		PR_PROFILE_DETAIL = "Diese Profil ist aktuelle an diese WoW Charaktere gebunden",
		PR_DELETE_PROFILE = "Profil löschen",
		PR_DUPLICATE_PROFILE = "Profil kopieren",
		PR_UNUSED_PROFILE = "Dieses Profil ist aktuell an keinen WoW Charakter gebunden.",
		PR_PROFILE_LOADED = "Das Profil %s ist geladen.",
		PR_PROFILEMANAGER_CREATE_POPUP = "Gib bitte einen Namen für das neue Profil ein.\nDie Namenszeile darf nicht leer sein.",
		PR_PROFILEMANAGER_DUPP_POPUP = "Gib bitte einen Namen für das neue Profil ein.\nDie Namenszeile darf nicht leer sein.\n\nDiese Kopie ändert nicht die Bindung zu %s.",
		PR_PROFILEMANAGER_EDIT_POPUP = "Gib bitte einen neuen Namen für das Profil %s ein.\nDie Namenszeile darf nicht leer sein.\n\nDie änderung des Namens verändert nicht die Verbindung zwischen dem Profil und den Charakteren.",
		PR_PROFILEMANAGER_ALREADY_IN_USE = "Der Profilname %s ist nicht verfügbar.",
		PR_PROFILEMANAGER_COUNT = "%s WoW Charakter/e an dieses Profil gebunden.",
		PR_PROFILEMANAGER_ACTIONS = "Aktionen",
		PR_PROFILEMANAGER_SWITCH = "Profil auswählen",
		PR_PROFILEMANAGER_RENAME = "Profil umbenennen",
		PR_PROFILEMANAGER_CURRENT = "Aktuelles Profil",
		PR_CO_PROFILEMANAGER_TITLE = "Begleiter Profile",
		PR_CO_PROFILE_HELP = [[Ein Profil enthält alle Informationen über ein |cffffff00"Haustier/Begleiter"|r als |cff00ff00Rollenspiel Charakter|r.

Ein Begleiterprofil kann an folgende Begleiterarten gebunden werden:
- Ein Kampfhaustier |cffff9900(nur wenn es umbennant wurde)|r
- Ein Jägerbegleiter
- Ein Diener eines Hexenmeisters
- Ein Magierelementar
- Ein Guhl eines Todesritters |cffff9900(siehe unten)|r

Genau wie bei einem Charakterprofil kann ein |cff00ff00Begleiterproful|r mit |cffffff00verschiedenen Haustieren|r verbunden werden. Genauso kannst du für dein |cffffff00Haustier|r einfach durch die verschiedenen Profile schalten.

|cffff9900Guhle:|r Für einen Guhl musst du das Profil bei jeder Beschwöhrung neu auswählen, da der Ingame Name zufällig vergeben wird!]],
		PR_CO_PROFILE_HELP2 = [[Hier klicken um eine neues Begleiterprofil anzulegen.

|cff00ff00Um ein Profil einem Haustier zu zuweisen, beschwöre einfach dein Haustier/Begleiter, wähle es aus und benutze das Zielfenster um es einem Profil zu zuweisen (oder ein neues Profil zu erstellen).|r]],
		PR_CO_MASTERS = "Meister",
		PR_CO_EMPTY = "Kein Begleiter Profil",
		PR_CO_NEW_PROFILE = "Neues Begleiter Profil",
		PR_CO_COUNT = "%s Haustiere/Reittiere an dieses Profil gebunden.",
		PR_CO_UNUSED_PROFILE = "Dieses Profil ist aktuell nicht an ein Haustier oder Reittier gebunden.",
		PR_CO_PROFILE_DETAIL = "Dieses Profil ist aktuell gebunden anT",
		PR_CO_PROFILEMANAGER_DELETE_WARNING = "Bist du sicher das du das Begleiterprofil %s löschen willst?\nDiese Aktion kann nicht Rückgängig gemacht werden und alle TRP3 Informationen die damit zusammenhängen werden zerstört!",
		PR_CO_PROFILEMANAGER_DUPP_POPUP = "Bitte gibt einen Namen für das neue Profil ein.\nDer Name darf nicht leer sein.\n\nDiese Kopie ändert nicht die Bindung deines Haustieres/Reittieres zu %s.",
		PR_CO_PROFILEMANAGER_EDIT_POPUP = "Bitte gib einen Namen für das Profil %s ein.\nDer Name darf nicht leer sein.\n\nDas ändern des Namens ändert nicht die verbindung des Profils mit deinem Haustier/Reittier.",
		PR_CO_WARNING_RENAME = "|cffff0000Warnung:|r Es wird dringend empfohlen dein Haustier umzubenennen bevor du es mit einem Profil verbindest.\n\nTrotzdem verbinden?",
		PR_CO_PET = "Tier",
		PR_CO_BATTLE = "Begleiter",
		PR_IMPORT_CHAR_TAB = "Charakter Importeur",
		PR_IMPORT_PETS_TAB = "Begleiter Importeur",
		PR_IMPORT_IMPORT_ALL = "Alles Importieren",
		PR_IMPORT_WILL_BE_IMPORTED = "Wir importiert",
		PR_IMPORT_EMPTY = "Kein importierbares Profil",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- DASHBOARD
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		DB_STATUS = "Status",
		DB_STATUS_CURRENTLY_COMMON = "Der Status wird im Tooltip deines Charakters angezeigt. Halte dich hier kurz, knapp und eindeutig, da |cffff9900standartmäßig alle TRP3 Nutzer nur die ersten 140 Zeichen sehen können!",
		DB_STATUS_CURRENTLY = "Aktuelles (IC)",
		DB_STATUS_CURRENTLY_TT = "Hier kannst du wichtiges über einen Charakter angeben.",
		DB_STATUS_CURRENTLY_OOC = "Andere Informationen (OOC)",
		DB_STATUS_CURRENTLY_OOC_TT = "Hier kannst du irgend etwas wichtiges über dich als Spieler oder andere OOC Dinge eintragen.",
		DB_STATUS_RP = "Charakter Status",
		DB_STATUS_RP_IC = "In character (IC)",
		DB_STATUS_RP_IC_TT = "Die spielst diesen Charakter aktuell aus.\nDein gesamtes Handeln wird bewertet als ob du der Charakter wärst der die Aktionen ausführt.",
		DB_STATUS_RP_OOC = "Out of character (OOC)",
		DB_STATUS_RP_OOC_TT = "Du spielst diesen Charakter aktuell nicht aus.\nDein Handeln wird nicht mit dem Charakter in Verbindung gebracht.",
		DB_STATUS_XP = "Rollenspielerfahrung",
		DB_STATUS_XP_BEGINNER = "RP Anfänger",
		DB_STATUS_XP_BEGINNER_TT = "Dieser Status zeigt ein Icon auf deinem Tooltip an welches anzeigt das du ein Rollenspiel Anfänger bist.",
		DB_STATUS_RP_EXP = "Erfahrener Rollenspieler",
		DB_STATUS_RP_EXP_TT = "Zeigt an das du ein Rollenspieler mit Erfahrung bist.\nZeigt kein spezielles Icon auf deinem Tooltip an.",
		DB_STATUS_RP_VOLUNTEER = "Rollenspiel Lehrer",
		DB_STATUS_RP_VOLUNTEER_TT = "Diese Auswahl zeigt ein Icon auf deinem Tooltip an welches anzeigt das du Rollenspiel Anfängern Hilfestellung gibst.",
		DB_NOTIFICATIONS = "Benachrichtigunganzeige",
		DB_NOTIFICATIONS_NO = "Du hast keine Benachrichtigungen",
		DB_NOTIFICATIONS_CLEAR = "Alle Benachrichtigungen entfernen",
		DB_NOTIFICATIONS_ALL = "Alle Benachrichtigungstypen",
		DB_TUTO_1 = [[|cffffff00Der Charakter Status|r zeigt an ob du deinen Charakter aktuell ausspielst oder nicht.

|cffffff00Die Rollenspielerfahrung|r gibt an ob du ein blutiger Anfänger oder ein Erfahrener Rollenspieler bist welcher gerne Neulingen hilft!

|cff00ff00Diese Informationen werden im Tooltip deines Charakters angezeigt.]],
		DB_TUTO_2 = [[Einige Ereignisse erzeugen Benachrichtigungen. Diese sind ein schneller Weg um zu sehen was in Total RP 3 passiert ist.

Alle Benachrichtigungen lassen sich unter |cffff9900Allgemeine Einstellungen|r einstellen.]],
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMON UI TEXTS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		UI_BKG = "Background %s",
		UI_ICON_BROWSER = "Icon browser",
		UI_ICON_BROWSER_HELP = "Copy icon",
		UI_ICON_BROWSER_HELP_TT = [[Während dieses Fenter geöffnet ist kannst du mit |cffffff00ctrl + Klick|r auf ein Icon anwenden um dessen Namen zu kopieren.

Das funktioniert:|cff00ff00
- Mit jedem Item in deinem Inventar
- Mit jeder Fähigkeit in deinem Zauberbuch|r]],
		UI_ICON_SELECT = "Icon auswählen",
		UI_MUSIC_BROWSER = "Musik Browser",
		UI_MUSIC_SELECT = "Musik auswählen",
		UI_COLOR_BROWSER = "Farb Browser",
		UI_COLOR_BROWSER_RED = "Rot",
		UI_COLOR_BROWSER_GREEN = "Grün",
		UI_COLOR_BROWSER_BLUE = "Blau",
		UI_COLOR_BROWSER_MAX = "Maximum",
		UI_COLOR_BROWSER_MIN = "Minimum",
		UI_COLOR_BROWSER_SELECT = "Farbe auswählen",
		UI_IMAGE_BROWSER = "Bild Browser",
		UI_IMAGE_SELECT = "Bild auswählen",
		UI_FILTER = "Filter",
		UI_LINK_URL = "http://deine.url.hier.de",
		UI_LINK_TEXT = "Dein Text",
		UI_LINK_WARNING = [[Hier ist der Link.
Ihn kannst du per Copy/Paste in deinen Browser kopieren.

|cffff0000!! Disclaimer !!|r
Total RP ist NICHT für Links verantwortlich welche auf schädlichem oder illegalem Inhalt verweisen!]],
		UI_TUTO_BUTTON = "Tutorial Modus",
		UI_TUTO_BUTTON_TT = "Klicke um den Tutorial Modus ein/aus zu schalten",
		UI_CLOSE_ALL = "Alle schließen",
		
		NPC_TALK_SAY_PATTERN = "sagt: ",
		NPC_TALK_YELL_PATTERN = "schreit: ",
		NPC_TALK_WHISPER_PATTERN = "flüstert: ",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMON TEXTS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		CM_SHOW = "Anzeigen",
		CM_ACTIONS = "Aktionen",
		CM_IC = "IC",
		CM_OOC = "OOC",
		CM_CLICK = "Klicken",
		CM_R_CLICK = "Rechts-Klick",
		CM_L_CLICK = "Links-Klick",
		CM_CTRL = "Ctrl",
		CM_SHIFT = "Shift",
		CM_DRAGDROP = "Drag & drop",
		CM_LINK = "Link",
		CM_SAVE = "Speichern",
		CM_CANCEL = "Abbrechen",
		CM_NAME = "Name",
		CM_VALUE = "Wert",
		CM_UNKNOWN = "Unbekannt",
		CM_PLAY = "Play",
		CM_STOP = "Stop",
		CM_LOAD = "Laden",
		CM_REMOVE = "Entfernen",
		CM_EDIT = "Editieren",
		CM_LEFT = "Links",
		CM_CENTER = "Mittig",
		CM_RIGHT = "Rechst",
		CM_COLOR = "Farbe",
		CM_ICON = "Icon",
		CM_IMAGE = "Bild",
		CM_SELECT = "Auswählen",
		CM_OPEN = "Öffnen",
		CM_APPLY = "Übernehmen",
		CM_MOVE_UP = "Hoch",
		CM_MOVE_DOWN = "Runter",
		CM_CLASS_WARRIOR = "Kriefer",
		CM_CLASS_PALADIN = "Paladin",
		CM_CLASS_HUNTER = "Jäger",
		CM_CLASS_ROGUE = "Schurke",
		CM_CLASS_PRIEST = "Priester",
		CM_CLASS_DEATHKNIGHT = "Todesritter",
		CM_CLASS_SHAMAN = "Schamane",
		CM_CLASS_MAGE = "Magier",
		CM_CLASS_WARLOCK = "Hexenmeister",
		CM_CLASS_MONK = "Mönch",
		CM_CLASS_DRUID = "Druide",
		CM_CLASS_UNKNOWN = "Unbekannt",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Minimap button
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		MM_SHOW_HIDE_MAIN = "Zeige/Verstecke das Hauptfenster",
		MM_SHOW_HIDE_SHORTCUT = "Zeig/Verstecke die Toolbar",
		MM_SHOW_HIDE_MOVE = "Icon bewegen",
		
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Browsers
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		BW_COLOR_CODE = "Farbmodus",
		BW_COLOR_CODE_TT = "Hier kannst du 6 Zeichen hexdezimalen Farbcode eintragen und mit ENTER bestätigen.",
		BW_COLOR_CODE_ALERT = "Falscher Hexdezimaler Farbcode!",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Bindings
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		BINDING_NAME_TRP3_TOGGLE = "Hauptfenster umschalten";
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Toolbar umschalten";

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- About TRP3
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		ABOUT_TITLE = "Über",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMANDS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		COM_LIST = "Kommandos:",
		COM_SWITCH_USAGE = "Nutzung: |cff00ff00/trp3 switch main|r um das Hauptfenster umzuschalten oder |cff00ff00/trp3 switch toolbar|r um die Toolbar umzuschalten.",
		COM_RESET_USAGE = "Nutzung: |cff00ff00/trp3 reset frames|r um alle Fensterpositionen wiederherzustellen.",
		COM_RESET_RESET = "Die Position des Fenster wurde wiederhergestellt",
	},
};

TRP3_API.locale.registerLocale(LOCALE_DE);