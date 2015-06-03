----------------------------------------------------------------------------------
-- Total RP 3
-- French locale
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
-- Thanks to Solanya Stormbreaker ( http://www.curseforge.com/profiles/SolanyaStormbreaker/ )
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

local LOCALE = {
	locale = "frFR",
	localeText = "Français",
	localeContent = {
		ABOUT_TITLE = "À propos",
		BINDING_NAME_TRP3_TOGGLE = "Afficher/cacher la fenêtre principale",
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Afficher/cacher la barre d'outils",
		BW_COLOR_CODE = "Code couleur",
		BW_COLOR_CODE_ALERT = "Mauvais code hexadécimal !",
		BW_COLOR_CODE_TT = "Vous pouvez coller ici un code couleur hexadecimal à 6 caractères et appuyer sur Entrée pour valider.",
		CM_ACTIONS = "Actions",
		CM_APPLY = "Appliquer",
		CM_CANCEL = "Annuler",
		CM_CENTER = "Centre",
		CM_CLASS_DEATHKNIGHT = "Chevalier de la mort",
		CM_CLASS_DRUID = "Druide",
		CM_CLASS_HUNTER = "Chasseur",
		CM_CLASS_MAGE = "Mage",
		CM_CLASS_MONK = "Moine",
		CM_CLASS_PALADIN = "Paladin",
		CM_CLASS_PRIEST = "Prêtre",
		CM_CLASS_ROGUE = "Voleur",
		CM_CLASS_SHAMAN = "Chaman",
		CM_CLASS_UNKNOWN = "Inconnu",
		CM_CLASS_WARLOCK = "Démoniste",
		CM_CLASS_WARRIOR = "Guerrier",
		CM_CLICK = "Clic",
		CM_COLOR = "Couleur",
		CM_CTRL = "Ctrl",
		CM_DRAGDROP = "Glisser-déposer",
		CM_EDIT = "Modifier",
		CM_IC = "RP",
		CM_ICON = "Icône",
		CM_IMAGE = "Image",
		CM_L_CLICK = "Clic-gauche",
		CM_LEFT = "Gauche",
		CM_LINK = "Lien",
		CM_LOAD = "Charger",
		CM_MOVE_DOWN = "Déplacer vers le bas",
		CM_MOVE_UP = "Déplacer vers le haut",
		CM_NAME = "Nom",
		CM_OOC = "HRP",
		CM_OPEN = "Ouvrir",
		CM_PLAY = "Jouer",
		CM_R_CLICK = "Clic-droit",
		CM_REMOVE = "Supprimer",
		CM_RIGHT = "Droite",
		CM_SAVE = "Sauver",
		CM_SELECT = "Choisir",
		CM_SHIFT = "Maj",
		CM_SHOW = "Afficher",
		CM_STOP = "Arrêter",
		CM_UNKNOWN = "Inconnu",
		CM_VALUE = "Valeur",
		CO_ANCHOR_BOTTOM = "Bas",
		CO_ANCHOR_BOTTOM_LEFT = "Bas-gauche",
		CO_ANCHOR_BOTTOM_RIGHT = "Bas-droite",
		CO_ANCHOR_CURSOR = "Afficher sur le curseur",
		CO_ANCHOR_LEFT = "Gauche",
		CO_ANCHOR_RIGHT = "Droite",
		CO_ANCHOR_TOP = "Haut",
		CO_ANCHOR_TOP_LEFT = "Haut-gauche",
		CO_ANCHOR_TOP_RIGHT = "Haut-droite",
		CO_CHAT = "Discussions",
		CO_CHAT_MAIN = "Paramètres principaux de discussions",
		CO_CHAT_MAIN_COLOR = "Utiliser les couleurs personnalisées pour les noms",
		CO_CHAT_MAIN_EMOTE = "Détection des émotes",
		CO_CHAT_MAIN_EMOTE_PATTERN = "Schéma de détection des émotes",
		CO_CHAT_MAIN_EMOTE_USE = "Utiliser la détection des émotes",
		CO_CHAT_MAIN_EMOTE_YELL = "Pas d'émotes criées",
		CO_CHAT_MAIN_EMOTE_YELL_TT = "Ne pas afficher *emote* ou <emote> en /crier.",
		CO_CHAT_MAIN_NAMING = "Méthode d'affichage des noms",
		CO_CHAT_MAIN_NAMING_1 = "Garder le nom original",
		CO_CHAT_MAIN_NAMING_2 = "Utiliser les noms personnalisés",
		CO_CHAT_MAIN_NAMING_3 = "Prénom + nom",
		CO_CHAT_MAIN_NPC = "Détection des dialogues de PNJ",
		CO_CHAT_MAIN_NPC_PREFIX = "Schéma de détection des dialogues de PNJ",
		CO_CHAT_MAIN_NPC_PREFIX_TT = [=[Si un message envoyé sur le canal /dire, /emote, /groupe ou /raid commence par ce préfix, il sera interprété comme dialogue de PNJ.

|cff00ff00Par défaut : "|| "
(sans les " et avec un espace après le | )]=],
		CO_CHAT_MAIN_NPC_USE = "Utiliser la détection des dialogues de PNJ",
		CO_CHAT_MAIN_OOC = "Détection du HRP",
		CO_CHAT_MAIN_OOC_COLOR = "Couleur du HRP",
		CO_CHAT_MAIN_OOC_PATTERN = "Schéma de détection du HRP",
		CO_CHAT_MAIN_OOC_USE = "Utiliser la détection du HRP",
		CO_CHAT_USE = "Canaux de discussion utilisés",
		CO_CHAT_USE_SAY = "Canal /dire",
		CO_CONFIGURATION = "Paramètres",
		CO_GENERAL = "Général",
		CO_GENERAL_BROADCAST = "Utiliser le canal de diffusion",
		CO_GENERAL_BROADCAST_C = "Nom du canal de diffusion",
		CO_GENERAL_BROADCAST_TT = "Le canal de diffusion est utilisé pour de nombreuses fonctionnalités. Le désactiver désactivera également les fonctionnalités comme la location sur la carte, les sons diffusés localement, l'accès aux planques et aux panneaux, etc.",
		CO_GENERAL_CHANGELOCALE_ALERT = [=[Changer la langue pour %s ?
Cela provoquera une rechargement de l'interface.]=],
		CO_GENERAL_COM = "Communication",
		CO_GENERAL_HEAVY = "Alerte de profil lourd",
		CO_GENERAL_HEAVY_TT = "Afficher une alerte lorsque la taille du profil dépasse une valeur raisonnable",
		CO_GENERAL_LOCALE = "Langue de l'add-don",
		CO_GENERAL_MISC = "Divers",
		CO_GENERAL_NEW_VERSION = "Alerte de mise-à-jour",
		CO_GENERAL_NEW_VERSION_TT = "Afficher une alerte lorsqu'une nouvelle version est disponible.",
		CO_GENERAL_TT_SIZE = "Taille du texte de l'infobulle",
		CO_GENERAL_UI_ANIMATIONS = "Animations d'interface",
		CO_GENERAL_UI_ANIMATIONS_TT = "Activer les animations d'interface",
		CO_GENERAL_UI_SOUNDS = "Effets sonores d'interface",
		CO_GENERAL_UI_SOUNDS_TT = "Activer les effets sonores d'interface (à l'ouverture des fenêtres, aux changements d'onglets ou aux clics des boutons).",
		CO_GLANCE_LOCK = "Verrouiller la barre",
		CO_GLANCE_LOCK_TT = "Empêche la barre de pouvoir être déplacée",
		CO_GLANCE_MAIN = "Barre \"Coup d’œil\"",
		CO_GLANCE_PRESET_TRP2 = "Utiliser les positions dans le style de Total RP 2",
		CO_GLANCE_PRESET_TRP2_BUTTON = "Utiliser",
		CO_GLANCE_PRESET_TRP2_HELP = "Raccourci pour configurer la barre dans le style de TRP2 : à droite du portrait de la cible.",
		CO_GLANCE_PRESET_TRP3 = "Utiliser les positions dans le style de Total RP 3",
		CO_GLANCE_PRESET_TRP3_HELP = "Raccourci pour configurer la barre dans le style de TRP3 : en-dessous du portrait de la cible.",
		CO_GLANCE_RESET_TT = "Réinitialiser la position de la barre en bas à gauche du cadre d'ancrage.",
		CO_GLANCE_TT_ANCHOR = "Point d'ancrage des infobulles",
		CO_LOCATION = "Paramètres de position",
		CO_LOCATION_ACTIVATE = "Activer la position du personnage",
		CO_LOCATION_ACTIVATE_TT = "Active la fonctionnalité de position du personnage, vous permettant de lancer un scan afin d'afficher sur la carte les autres utilisateurs de Total RP ayant activé cette fonctionnalité. Cela leur permet aussi de vous scanner.",
		CO_LOCATION_DISABLE_OOC = "Désactiver le scan si HRP",
		CO_LOCATION_DISABLE_OOC_TT = "Vous ne répondrez pas aux requêtes de positions de personnages si vous êtes en statut HRP.",
		CO_LOCATION_DISABLE_PVP = "Désactiver le scan si PvP",
		CO_LOCATION_DISABLE_PVP_TT = [=[Vous ne répondrez pas aux requêtes de positions de personnages si vous êtes en mode PvP.

Cette option est particulièrement utile sur les royaume PvP où les utilisateurs de la faction opposée pourraient abuser du système pour vous traquer.]=],
		CO_MINIMAP_BUTTON = "Bouton de la minicarte",
		CO_MINIMAP_BUTTON_FRAME = "Cadre d'ancrage",
		CO_MINIMAP_BUTTON_RESET = "Réinitialiser la position",
		CO_MINIMAP_BUTTON_RESET_BUTTON = "Réinitialiser",
		CO_MINIMAP_BUTTON_SHOW_HELP = "Si vous utilisez un autre add-on pour afficher le bouton de la mini-carte de Total RP 3 (FuBar, Titan, Bazooka) vous pouvez cacher le bouton par défaut.",
		CO_MINIMAP_BUTTON_SHOW_TITLE = "Afficher le bouton de la mini-carte",
		COM_LIST = "Liste des commandes :",
		CO_MODULES = "Statut des modules",
		CO_MODULES_DISABLE = "Désactiver le module",
		CO_MODULES_ENABLE = "Activer le module",
		CO_MODULES_ID = "Identifiant du module: %s",
		CO_MODULES_SHOWERROR = "Afficher l'erreur",
		CO_MODULES_STATUS = "Statut: %s",
		CO_MODULES_STATUS_0 = "Dépendances manquantes",
		CO_MODULES_STATUS_1 = "Chargé",
		CO_MODULES_STATUS_2 = "Désactivé",
		CO_MODULES_STATUS_3 = "Mise à jour de Total RP 3 requise",
		CO_MODULES_STATUS_4 = "Erreur à l'initialisation",
		CO_MODULES_STATUS_5 = "Erreur au démarrage",
		CO_MODULES_TT_DEP = "%s- %s (version %s)|r",
		CO_MODULES_TT_DEPS = "Dépendances",
		CO_MODULES_TT_ERROR = [=[
|cffff0000Erreur:|r
%s]=],
		CO_MODULES_TT_NONE = "Pas de dépendances",
		CO_MODULES_TT_TRP = "%sPour Total RP 3 version %s minimum.|r",
		CO_MODULES_TUTO = [=[Un module est une fonctionnalité indépendante qui peut être activé ou désactivé.

Statuts possibles:
|cff00ff00Chargé:|r Le module est activé et chargé.
|cff999999Désactivé:|r Le module est désactivé.
|cffff9900Dépendances manquantes:|r Certaines dépendances ne sont pas chargées.
|cffff9900Mise à jour de TRP requise:|r Le module requiert une version plus récente de TRP3.
|cffff0000Erreur à l'initialisation ou au démarrage:|r La séquence de chargement du module a échoué. Le module créera sans doute des erreurs !

|cffff9900Lorsque vous désactivez un module, il est nécessaire de recharger l'interface.]=],
		CO_MODULES_VERSION = "Version: %s",
		COM_RESET_RESET = "La position des éléments de l'interface a été ré-initialisée.",
		COM_RESET_USAGE = "Utilisation : |cff00ff00/trp3 reset frames|r pour ré-initialiser la position des éléments de l'interface.",
		CO_MSP = "Mary Sue Protocol",
		CO_MSP_T3 = "Utiliser uniquement le modèle 3",
		CO_MSP_T3_TT = "Même si vous choisissez un autre modèle \"À propos\", le modèle 3 sera toujours utilisé pour la compatibilité avec MSP.",
		COM_SWITCH_USAGE = "Utilisation: |cff00ff00/trp3 switch main|r pour afficher ou masquer la fenêtre principale ou |cff00ff00/trp3 switch toolbar|r pour afficher ou masquer la barre d'outils.",
		CO_REGISTER = "Registre",
		CO_REGISTER_ABOUT_VOTE = "Utiliser le système de vote",
		CO_REGISTER_ABOUT_VOTE_TT = "Active le système de vote, vous permettant de voter (\"j'aime\" ou \"je n'aime pas\") pour les descriptions des autres et leur permettant de faire de même pour vous.",
		CO_REGISTER_AUTO_ADD = "Ajouter automatiquement les nouveaux joueurs",
		CO_REGISTER_AUTO_ADD_TT = "Ajouter automatiquement les nouveaux joueurs que vous rencontrez au registre.",
		CO_REGISTER_AUTO_PURGE = "Purge auto. du registre",
		CO_REGISTER_AUTO_PURGE_0 = "Désactiver la purge",
		CO_REGISTER_AUTO_PURGE_1 = "Après %s jours",
		CO_REGISTER_AUTO_PURGE_TT = [=[Retire automatiquement du registre les profils de personnages que vous n'avez pas croisés depuis un certain temps. Vous pouvez choisir le délais avant la suppression.

|cff00ff00Notez qu'un profil envers le quel un de vos personnage possède une relation ne sera jamais supprimé.

|cffff9900Il existe un bug dans WoW supprimant toutes les données sauvegardées si le fichier de sauvegarde atteint une certaine taille. Nous déconseillons donc fortement de désactiver totalement la purge.]=],
		CO_TARGETFRAME = "Paramètres du cadre de la cible",
		CO_TARGETFRAME_ICON_SIZE = "Taille des icônes",
		CO_TARGETFRAME_USE = "Conditions d'affichage",
		CO_TARGETFRAME_USE_1 = "Toujours",
		CO_TARGETFRAME_USE_2 = "Uniquement quand le personnage est joué",
		CO_TARGETFRAME_USE_3 = "Jamais (Désactivé)",
		CO_TARGETFRAME_USE_TT = "Détermine les conditions d'affichage du cadre de la cible lors de la sélection d'une cible.",
		CO_TOOLBAR = "Cadres",
		CO_TOOLBAR_CONTENT = "Paramètres de la barre d'outils",
		CO_TOOLBAR_CONTENT_CAPE = "Affichage de la cape",
		CO_TOOLBAR_CONTENT_HELMET = "Affichage du casque",
		CO_TOOLBAR_CONTENT_RPSTATUS = "Statut du personnage (RP/HRP)",
		CO_TOOLBAR_CONTENT_STATUS = "Statut du joueur (ABS/NPD)",
		CO_TOOLBAR_ICON_SIZE = "Taille des icônes",
		CO_TOOLBAR_MAX = "Nombre maximum d'icônes par ligne",
		CO_TOOLBAR_MAX_TT = "Réglez à 1 si vous désirez afficher la barre verticalement !",
		CO_TOOLBAR_SHOW_ON_LOGIN = "Afficher la barre d'outils à la connexion",
		CO_TOOLBAR_SHOW_ON_LOGIN_HELP = "Si vous ne souhaitez plus que la barre d'outils de Total RP 3 s'affiche automatiquement à la connexion, vous pouvez décocher cette option.",
		CO_TOOLTIP = "Infobulles",
		CO_TOOLTIP_ANCHOR = "Point d'ancrage",
		CO_TOOLTIP_ANCHORED = "Cadre ancré",
		CO_TOOLTIP_CHARACTER = "Infobulle de personnages",
		CO_TOOLTIP_CLIENT = "Afficher le client",
		CO_TOOLTIP_COMBAT = "Cacher durant un combat",
		CO_TOOLTIP_COMMON = "Paramètres généraux",
		CO_TOOLTIP_CURRENT = "Afficher l'information \"actuellement\"",
		CO_TOOLTIP_CURRENT_SIZE = "Longueur maximale de l'information \"actuellement\"",
		CO_TOOLTIP_FT = "Afficher le titre complet",
		CO_TOOLTIP_GUILD = "Afficher l'information de la guilde",
		CO_TOOLTIP_HIDE_ORIGINAL = "Masquer l'infobulle originale",
		CO_TOOLTIP_ICONS = "Afficher les icônes",
		CO_TOOLTIP_MAINSIZE = "Taille de la police principale",
		CO_TOOLTIP_NOTIF = "Afficher les notifications",
		CO_TOOLTIP_NOTIF_TT = "La ligne des notifications est la ligne comprenant la version du client, l'indication de description non lue et l'indication 'Coup d'œil'",
		CO_TOOLTIP_OWNER = "Afficher le propriétaire",
		CO_TOOLTIP_PETS = "Infobulle de compagnons",
		CO_TOOLTIP_PETS_INFO = "Afficher l'information du compagnon",
		CO_TOOLTIP_PROFILE_ONLY = "Utiliser uniquement si la cible a un profil",
		CO_TOOLTIP_RACE = "Afficher la race, la classe et le niveau",
		CO_TOOLTIP_REALM = "Afficher le royaume",
		CO_TOOLTIP_RELATION = "Afficher la couleur de la relation",
		CO_TOOLTIP_RELATION_TT = "Colorer la bordure de l'infobulle en fonction de la relation",
		CO_TOOLTIP_SPACING = "Afficher les espaces",
		CO_TOOLTIP_SPACING_TT = "Ajoute des espaces pour aérer l'infobulle, dans le style de MyRolePlay.",
		CO_TOOLTIP_SUBSIZE = "Taille de la police secondaire",
		CO_TOOLTIP_TARGET = "Afficher la cible",
		CO_TOOLTIP_TERSIZE = "Taille de la police tertiaire",
		CO_TOOLTIP_TITLE = "Afficher le titre",
		CO_TOOLTIP_USE = "Utiliser les infobulles de personnages/compagnons",
		CO_WIM = "|cffff9900Les canaux de chuchotement sont désactivés.",
		CO_WIM_TT = "Vous utilisez |cff00ff00WIM|r, le support des canaux de chuchotement est désactivé pour des raisons de compatibilité.",
		DB_ABOUT = "A propos de Total RP 3",
		DB_HTML_GOTO = "Cliquer pour ouvrir",
		DB_NEW = "Quoi de neuf ?",
		DB_STATUS = "Statut",
		DB_STATUS_CURRENTLY = "Actuellement (RP)",
		DB_STATUS_CURRENTLY_COMMON = "Ces statuts seront affichés dans l'infobulle de votre personnage. Restez clair et bref, |cffff9900par défaut les utilisateurs de Total RP 3 verront uniquement les 140 premiers caractères !",
		DB_STATUS_CURRENTLY_OOC = "Autres informations (HRP)",
		DB_STATUS_CURRENTLY_OOC_TT = "Vous pouvez indiquer ici quelque chose d'important sur vous, le joueur, ou autre chose hors de votre personnage.",
		DB_STATUS_CURRENTLY_TT = "Vous pouvez indiquer ici quelque chose d'important sur votre personnage.",
		DB_STATUS_RP = "Statut du personnage",
		DB_STATUS_RP_EXP = "Rôliste confirmé",
		DB_STATUS_RP_EXP_TT = [=[Montre que vous êtes un rôliste confirmé.
Cela n'affichera aucune icône spécifique sur votre bulle d'aide.]=],
		DB_STATUS_RP_IC = "Personnage joué",
		DB_STATUS_RP_IC_TT = [=[Cela signifie que vous jouez actuellement votre personnage.
Toutes vos actions seront interprétées comme si votre personnage les effectuait.]=],
		DB_STATUS_RP_OOC = "Hors du personnage",
		DB_STATUS_RP_OOC_TT = [=[Vous n'êtes pas dans votre personnage.
Vos actions ne lui seront pas associées.]=],
		DB_STATUS_RP_VOLUNTEER = "Rôliste volontaire",
		DB_STATUS_RP_VOLUNTEER_TT = [=[Ce choix affichera une icône dans votre infobulle, indiquant
aux joueurs débutants que vous êtes enclin à les aider.]=],
		DB_STATUS_XP = "Statut roleplay",
		DB_STATUS_XP_BEGINNER = "Rôliste débutant",
		DB_STATUS_XP_BEGINNER_TT = [=[Ce choix affichera une icône dans votre infobulle, indiquant
aux autres que vous débutez dans le roleplay.]=],
		DB_TUTO_1 = [=[|cffffff00Le statut du personnage|r indique si vous jouez actuellement le rôle de votre personnage ou non.

|cffffff00Le statut rolepay|r vous permet d'indiquer que vous êtes un débutant ou un vétéran désireux d'aider les novices !

|cff00ff00Cette information sera placée dans la bulle d'aide de votre personnage.]=],
		DTBK_AFK = "Total RP 3 - ABS/NPD",
		DTBK_CLOAK = "Total RP 3 - Cape",
		DTBK_HELMET = "Total RP 3 - Casque",
		DTBK_LANGUAGES = "Total RP - Langages",
		DTBK_RP = "Total RP 3 - RP/HRP",
		GEN_NEW_VERSION_AVAILABLE = [=[Une nouvelle version pour Total RP 3 est disponible.

|cffff0000Votre version: %s
|c0000ff00Nouvelle version: %s|r

|cffff9900Nous vous recommandons fortement de garder l'addon à jour.|r

Ce message ne s'affichera qu'une seule fois par session et peut être désactivé dans les paramètres.]=],
		GEN_VERSION = "Version: %s (Build %s)",
		GEN_WELCOME_MESSAGE = "Merci d'utiliser Total RP 3 (v %s) ! Amusez-vous bien !",
		MAP_BUTTON_NO_SCAN = "Pas de scan disponible",
		MAP_BUTTON_SCANNING = "Scan en cours",
		MAP_BUTTON_SUBTITLE = "Clic pour afficher les scans disponibles",
		MAP_BUTTON_TITLE = "Recherche de roleplay",
		MM_SHOW_HIDE_MAIN = "Afficher/cacher la fenêtre principale",
		MM_SHOW_HIDE_MOVE = "Déplacer le bouton",
		MM_SHOW_HIDE_SHORTCUT = "Afficher/cacher la barre d'outils",
		NPC_TALK_SAY_PATTERN = "dit :",
		NPC_TALK_WHISPER_PATTERN = "chuchotte :",
		NPC_TALK_YELL_PATTERN = "crie :",
		PR_CO_BATTLE = "Compagnon",
		PR_CO_COUNT = "%s familiers/montures liées à ce profil.",
		PR_CO_EMPTY = "Pas de profil compagnon",
		PR_CO_MASTERS = "Maîtres",
		PR_CO_MOUNT = "Monture",
		PR_CO_NEW_PROFILE = "Nouveau profil compagnon",
		PR_CO_PET = "Familier",
		PR_CO_PROFILE_DETAIL = "Ce profil est actuellement lié à",
		PR_CO_PROFILE_HELP = [=[Le profil contient toutes les informations sur un |cffffff00"familier"|r comme un |cff00ff00personnage roleplay|r.

Un profil de familier peut être lié à:
- Une mascotte de combat |cffff9900(uniquement si elle a été renommée)|r
- Un familier de chasseur
- Un serviteur de démoniste
- Un élémentaire de mage
- Une goule de chevalier de la mort |cffff9900(voir en-dessous)|r

À l'instar des profils de personnages, un |cff00ff00profil de compagnon|r peut être lié à |cffffff00plusieurs familiers|r, et un |cffffff00familier|r peut passer facilement d'un profil à un autre.

|cffff9900Goules:|r Les goules obtenant un nom différent à chaque invocation, il est nécessaire de lié le profil à la goule pour tous les noms générés.]=],
		PR_CO_PROFILE_HELP2 = [=[Cliquer ici pour créer un nouveau profil de compagnon.

|cff00ff00Pour lier un profil à un familier, invoquez juste le familier, sélectionnez-le et utilisez le cadre de cible pour le lier à un profil existant (ou en créer un nouveau).|r]=],
		PR_CO_PROFILEMANAGER_DELETE_WARNING = [=[Êtes-vous sûr(e) de vouloir supprimer le profil compagnon %s ?
Cette action est irréversible et toutes les informations liées à ce profil seront détruites !]=],
		PR_CO_PROFILEMANAGER_DUPP_POPUP = [=[Veuillez entrer le nom pour le nouveau profil.
Le nom ne peut pas être vide.

Cette duplication ne change pas les familiers/montures liés à %s.]=],
		PR_CO_PROFILEMANAGER_EDIT_POPUP = [=[Veuillez entrer le nouveau nom pour ce profile %s.
Le nom ne peut pas être vide.

Changer le nom ne modifie pas les liens entre ce profil et vos familiers/montures.]=],
		PR_CO_PROFILEMANAGER_TITLE = "Profils de compagnons",
		PR_CO_UNUSED_PROFILE = "Ce profil n'est actuellement lié à aucun familier ou monture.",
		PR_CO_WARNING_RENAME = [=[|cffff0000Attention:|r il est fortement recommandé que vous renommiez votre familier avant de le lier à un profil.

Le lier quand même ?]=],
		PR_CREATE_PROFILE = "Créer un profil",
		PR_DELETE_PROFILE = "Supprimer le profil",
		PR_DUPLICATE_PROFILE = "Dupliquer le profil",
		PR_IMPORT_CHAR_TAB = "Importateur de personnages",
		PR_IMPORT_EMPTY = "Aucun profil disponible",
		PR_IMPORT_IMPORT_ALL = "Tout importer",
		PR_IMPORT_PETS_TAB = "Importateur de compagnons",
		PR_IMPORT_WILL_BE_IMPORTED = "Sera importé",
		PR_PROFILE = "Profil",
		PR_PROFILE_CREATED = "Profil %s créé.",
		PR_PROFILE_DELETED = "Profil %s supprimé.",
		PR_PROFILE_DETAIL = "Ce profil est actuellement lié à ces personnages WoW",
		PR_PROFILE_HELP = [=[Un profil contient toutes les informations à propos d'un |cffffff00"personnage"|r en tant que |cff00ff00personnage roleplay|r.

Un |cffffff00"personnage WoW"|r réel ne peut être lié qu'à un seul profil à la fois, mais peut passer d'un profil à un autre à votre convenance.

Vous pouvez aussi lier plusieurs |cffffff00"personnages WoW"|r au même |cff00ff00profil|r !]=],
		PR_PROFILE_LOADED = "Le profil %s est chargé.",
		PR_PROFILEMANAGER_ACTIONS = "Actions",
		PR_PROFILEMANAGER_ALREADY_IN_USE = "Le nom de profil %s n'est pas disponible.",
		PR_PROFILEMANAGER_COUNT = "%s personnage(s) WoW lié(s) à ce profil.",
		PR_PROFILEMANAGER_CREATE_POPUP = [=[Veuillez entrer un nom pour le nouveau profil.
Ce nom ne peut pas être vide.]=],
		PR_PROFILEMANAGER_CURRENT = "Profil actuel",
		PR_PROFILEMANAGER_DELETE_WARNING = [=[Êtes-vous sûr de vouloir supprimer le profil %s?
Cette action est irréversible et toutes les informations TRP3 liées à ce profil (Informations du personnage, inventaire, journal de quêtes, états actifs ...) seront effacées !]=],
		PR_PROFILEMANAGER_DUPP_POPUP = [=[Veuillez entrer un nom pour le nouveau profil.
Ce nom ne peut pas être vide.

Cette duplication ne changera pas les liens du personnage à %s.]=],
		PR_PROFILEMANAGER_EDIT_POPUP = [=[Veuillez entrer un nom pour le nouveau profil.
Ce nom ne peut pas être vide.

Changer le nom ne changera aucun lien entre ce profil et vos personnages]=],
		PR_PROFILEMANAGER_RENAME = "Renommer le profil",
		PR_PROFILEMANAGER_SWITCH = "Choisir le profil",
		PR_PROFILEMANAGER_TITLE = "Profils de personnages",
		PR_PROFILES = "Profils",
		PR_UNUSED_PROFILE = "Ce profil n'est actuellement lié à aucun personnage WoW.",
		REG_COMPANION = "Compagnon",
		REG_COMPANION_BOUNDS = "Liens",
		REG_COMPANION_BOUND_TO = "Lier à ...",
		REG_COMPANION_BOUND_TO_TARGET = "Cible",
		REG_COMPANION_BROWSER_BATTLE = "Navigateur de mascottes",
		REG_COMPANION_BROWSER_MOUNT = "Navigateur de montures",
		REG_COMPANION_INFO = "Informations",
		REG_COMPANION_LINKED = "Le compagnon %s est maintenant lié au profil %s.",
		REG_COMPANION_LINKED_NO = "Le compagnon %s n'est plus lié à un profil.",
		REG_COMPANION_NAME = "Nom",
		REG_COMPANION_NAME_COLOR = "Couleur du nom",
		REG_COMPANION_PAGE_TUTO_C_1 = "Consulter",
		REG_COMPANION_PAGE_TUTO_E_1 = [=[Ce sont |cff00ff00les informations principales de votre compagnon|r.

Toutes ces informations s'afficheront dans |cffff9900l'infobulle de votre compagnon|r.]=],
		REG_COMPANION_PAGE_TUTO_E_2 = [=[Ceci est |cff00ff00la description de votre compagnon|r.

Elle n'est pas limitée à sa |cffff9900description physique|r. N'hésitez pas à indiquer des parties de son |cffff9900histoire|r ou des détails sur sa |cffff9900personnalité|r.

Il y a de nombreux moyens pour personnaliser la description.
Vous pouvez choisir une |cffffff00texture d'arrière-plan|r pour la description. Vous pouvez aussi utiliser les outils de formatage pour accéder à plusieurs paramètres de mise en page, tels que |cffffff00les tailles de texte, les couleurs et les alignements|r.
Ces outils vous permettent aussi d'insérer |cffffff00 des images, des icônes ou un lien vers un site web externe|r.]=],
		REG_COMPANION_PROFILES = "Profils de compagnons",
		REG_COMPANIONS = "Compagnons",
		REG_COMPANION_TARGET_NO = "Votre cible n'est pas un familier, un démon, une goule, un élémentaire de mage ou une mascotte renommée.",
		REG_COMPANION_TF_BOUND_TO = "Sélectionner un profil",
		REG_COMPANION_TF_CREATE = "Créer un nouveau profil",
		REG_COMPANION_TF_NO = "Pas de profil",
		REG_COMPANION_TF_OPEN = "Ouvrir la page",
		REG_COMPANION_TF_OWNER = "Maître : %s",
		REG_COMPANION_TF_PROFILE = "Profil de compagnon",
		REG_COMPANION_TF_PROFILE_MOUNT = "Profil de monture",
		REG_COMPANION_TF_UNBOUND = "Délier le profil",
		REG_COMPANION_TITLE = "Titre",
		REG_COMPANION_UNBOUND = "Délier ...",
		REG_DELETE_WARNING = [=[Êtes-vous sûr de vouloir supprimer le profil de %s?
]=],
		REG_IGNORE_TOAST = "Personnage ignoré",
		REG_LIST_ACTIONS_MASS = "Action sur les %s profils sélectionnés",
		REG_LIST_ACTIONS_MASS_IGNORE = "Ignorer les profils",
		REG_LIST_ACTIONS_MASS_IGNORE_C = [=[Cette action ajoutera |cff00ff00%s personnage(s)|r à la liste des ignorés.

Vous pouvez optionnellement entrer la raison ci-dessous. C'est une note personnelle, elle servira comme rappel.]=],
		REG_LIST_ACTIONS_MASS_REMOVE = "Supprimer les profils",
		REG_LIST_ACTIONS_MASS_REMOVE_C = "Cette action supprimera les |cff00ff00%s profils sélectionnés|r.",
		REG_LIST_ACTIONS_PURGE = "Purger le registre",
		REG_LIST_ACTIONS_PURGE_ALL = "Supprimer tous les profils",
		REG_LIST_ACTIONS_PURGE_ALL_C = [=[Cette purge supprimera tous les profils et les personnages auxquels ils sont liés du registre.

|cff00ff00%s personnages.]=],
		REG_LIST_ACTIONS_PURGE_ALL_COMP_C = [=[Cette purge supprimera tous les compagnons du registre.

|cff00ff00%s compagnons.]=],
		REG_LIST_ACTIONS_PURGE_COUNT = "%s profils seront supprimés.",
		REG_LIST_ACTIONS_PURGE_EMPTY = "Pas de profil à purger.",
		REG_LIST_ACTIONS_PURGE_IGNORE = "Profils de personnages ignorés",
		REG_LIST_ACTIONS_PURGE_IGNORE_C = [=[Cette purge supprimere tous les profils liés à un personnage WoW ignoré.

|cff00ff00%s]=],
		REG_LIST_ACTIONS_PURGE_TIME = "Profils non vus depuis 1 mois",
		REG_LIST_ACTIONS_PURGE_TIME_C = [=[Cette purge supprimera tous les profils qui n'ont pas été vus depuis un mois.

|cff00ff00%s]=],
		REG_LIST_ACTIONS_PURGE_UNLINKED = "Profils non-liés à un personnage",
		REG_LIST_ACTIONS_PURGE_UNLINKED_C = [=[Cette purge supprimera tous les profils qui ne sont pas liés à un personnage WoW.

|cff00ff00%s]=],
		REG_LIST_CHAR_EMPTY = "Aucun personnage",
		REG_LIST_CHAR_EMPTY2 = "Aucun personnage ne correspond à votre sélection",
		REG_LIST_CHAR_FILTER = "Personnages: %s / %s",
		REG_LIST_CHAR_IGNORED = "Ignoré",
		REG_LIST_CHAR_SEL = "Personnage sélectionné",
		REG_LIST_CHAR_TITLE = "Liste de personnages",
		REG_LIST_CHAR_TT = "Cliquer pour afficher la page",
		REG_LIST_CHAR_TT_CHAR = "Personnage(s) WoW lié(s):",
		REG_LIST_CHAR_TT_CHAR_NO = "Non lié à un personnage",
		REG_LIST_CHAR_TT_DATE = [=[Vu pour la dernière fois le: |cff00ff00%s|r
Vu pour la dernière fois à: |cff00ff00%s|r]=],
		REG_LIST_CHAR_TT_GLANCE = "Coup d'œil",
		REG_LIST_CHAR_TT_IGNORE = "Personnage(s) ignoré(s)",
		REG_LIST_CHAR_TT_NEW_ABOUT = "Description non lue",
		REG_LIST_CHAR_TT_RELATION = [=[Relation:
|cff00ff00%s]=],
		REG_LIST_CHAR_TUTO_ACTIONS = "Cette colonne vous permet de sélectionner plusieurs personnages afin d'effectuer une action sur tous les personnages sélectionnés.",
		REG_LIST_CHAR_TUTO_FILTER = [=[Vous pouvez filtrer la liste de personnages.

Le |cff00ff00filtre de nom|r permet de rechercher un personnage à partir du nom complet du profil (prénom + nom) mais aussi des personnages WoW liés.

Le |cff00ff00filtre de guilde|r permet de rechercher à partir du nom de la guilde des personnages WoW liés.

Le |cff00ff00filtre de royaume|r vous montrera uniquement les profils liés à un personnage WoW de votre royaume actuel.]=],
		REG_LIST_CHAR_TUTO_LIST = [=[La première colonne affiche le nom du personnage.

La deuxième colonne affiche la relation entre ces personnages et votre personnage actuel.

La dernière colonne correspond aux différents marqueurs. (ignoré ..etc.)]=],
		REG_LIST_FILTERS = "Filtres",
		REG_LIST_FILTERS_TT = [=[|cffffff00Clic gauche:|r Appliquer les filtres
|cffffff00Clic droit:|r Effacer les filtres]=],
		REG_LIST_FLAGS = "Marqueurs",
		REG_LIST_GUILD = "Guilde du personnage",
		REG_LIST_IGNORE_EMPTY = "Pas de personnage ignoré",
		REG_LIST_IGNORE_TITLE = "Liste des ignorés",
		REG_LIST_IGNORE_TT = [=[Raison:
|cff00ff00%s

|cffffff00Cliquer pour supprimer de la ligne des ignorés]=],
		REG_LIST_NAME = "Nom du personnage",
		REG_LIST_NOTIF_ADD = "Nouveau profil découvert pour |cff00ff00%s",
		REG_LIST_NOTIF_ADD_CONFIG = "Nouveau profil découvert",
		REG_LIST_NOTIF_ADD_NOT = "Ce profil n'existe plus.",
		REG_LIST_PET_MASTER = "Nom du maître",
		REG_LIST_PET_NAME = "Nom du compagnon",
		REG_LIST_PETS_EMPTY = "Aucun compagnon",
		REG_LIST_PETS_EMPTY2 = "Aucun compagnon ne correspond à votre sélection",
		REG_LIST_PETS_FILTER = "compagnons: %s / %s",
		REG_LIST_PETS_TITLE = "Liste des compagnons",
		REG_LIST_PETS_TOOLTIP = "A été vu le",
		REG_LIST_PETS_TOOLTIP2 = "A été vu avec",
		REG_LIST_PET_TYPE = "Type du compagnon",
		REG_LIST_REALMONLY = "Ce royaume uniquement",
		REG_MSP_ALERT = [=[|cffff0000ATTENTION

Vous ne pouvez avoir simultanément plus d'un addon utilisant le Mary Sue Protocol, car cela créerait un conflit.|r

Actuellement chargé: |cff00ff00%s

|cffff9900En conséquence, le support MSP pour Total RP3 sera désactivé.|r

Si vous ne souhaitez pas que TRP3 soit votre addon MSP et ne voulez plus voir cette alerte à nouveau, vous pouvez désactiver le module Mary Sue Protocol dans les paramètres TRP3 -> Statut des modules.]=],
		REG_PLAYER = "Personnage",
		REG_PLAYER_ABOUT = "À propos",
		REG_PLAYER_ABOUT_ADD_FRAME = "Ajouter un cadre",
		REG_PLAYER_ABOUT_EMPTY = "Aucune description",
		REG_PLAYER_ABOUT_HEADER = "Tag de titre",
		REG_PLAYER_ABOUT_MUSIC = "Thème du personnage",
		REG_PLAYER_ABOUT_MUSIC_LISTEN = "Jouer le thème",
		REG_PLAYER_ABOUT_MUSIC_REMOVE = "Désélectionner le thème",
		REG_PLAYER_ABOUT_MUSIC_SELECT = "Choisir le thème du personnage",
		REG_PLAYER_ABOUT_MUSIC_SELECT2 = "Choisir le thème",
		REG_PLAYER_ABOUT_MUSIC_STOP = "Arrêter le thème",
		REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900Aucun thème",
		REG_PLAYER_ABOUT_P = "Tag de paragraphe",
		REG_PLAYER_ABOUT_REMOVE_FRAME = "Supprimer ce cadre",
		REG_PLAYER_ABOUTS = "À propos de %s",
		REG_PLAYER_ABOUT_SOME = "Du texte ...",
		REG_PLAYER_ABOUT_T1_YOURTEXT = "Votre texte ici",
		REG_PLAYER_ABOUT_TAGS = "Outils de mise en page",
		REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900Thème inconnu",
		REG_PLAYER_ABOUT_VOTE_DOWN = "Je n'aime pas ce contenu",
		REG_PLAYER_ABOUT_VOTE_NO = [=[Aucun personnage lié à ce profil ne semble être connecté.
Voulez-vous forcer Total RP 3 à envoyer tout de même votre vote ?]=],
		REG_PLAYER_ABOUT_VOTES = "Statistiques",
		REG_PLAYER_ABOUT_VOTE_SENDING = "Envoi de votre vote à %s ...",
		REG_PLAYER_ABOUT_VOTE_SENDING_OK = "Votre vote à été envoyé à %s !",
		REG_PLAYER_ABOUT_VOTES_R = [=[|cff00ff00%s aiment ce contenu
|cffff0000%s n'aiment pas ce contenu]=],
		REG_PLAYER_ABOUT_VOTE_TT = "Votre vote est totalement anonyme et ne peut être vu que par ce joueur.",
		REG_PLAYER_ABOUT_VOTE_TT2 = "Vous ne pouvez voter que si le joueur est connecté.",
		REG_PLAYER_ABOUT_VOTE_UP = "J'aime ce contenu",
		REG_PLAYER_ADD_NEW = "Créer nouveau",
		REG_PLAYER_AGE = "Âge",
		REG_PLAYER_AGE_TT = [=[Vous indiquez ici l'âge de votre personnage.

Il y a plusieurs moyens de le faire:|c0000ff00
- Utiliser un nombre d'années,
- Ou un adjectif (Jeune, Mature, Adulte, Vénérable, etc.).]=],
		REG_PLAYER_ALERT_HEAVY_SMALL = [=[|cffff0000La taille de votre profil est plutôt importante.
|cffff9900Vous devriez la réduire.]=],
		REG_PLAYER_BIRTHPLACE = "Lieu de naissance",
		REG_PLAYER_BIRTHPLACE_TT = [=[Vous pouvez indiquer ici le lieu de naissance de votre personnage. Cela peut être une région, une zone, ou même un continent. C'est à vous de décider la précision avec laquelle vous souhaitez l'indiquer.

|c00ffff00Vous pouvez utiliser le bouton à droite vous régler facilement votre position actuelle comme Lieu de naissance.]=],
		REG_PLAYER_BKG = "Format d'arrière-plan",
		REG_PLAYER_BKG_TT = "Cela représente l'arrière-plan graphique à utiliser pour votre panneau Caractéristiques",
		REG_PLAYER_CARACT = "Caractéristiques",
		REG_PLAYER_CHANGE_CONFIRM = [=[Il se peut que vous ayez effectué des changements non sauvegardés.
Voulez-vous changer de page ?
|cffff9900Tout changement non-sauvegardé sera perdu.]=],
		REG_PLAYER_CHARACTERISTICS = "Caractéristiques",
		REG_PLAYER_CLASS = "Classe",
		REG_PLAYER_CLASS_TT = [=[Ceci est la classe personnalisée de votre personnage.

|cff00ff00Par exemple :|r
Chevalier, Pyrotechnicien, Nécromant, Tireur d'élite, Arcaniste ...]=],
		REG_PLAYER_COLOR_CLASS = "Couleur de classe",
		REG_PLAYER_COLOR_CLASS_TT = [=[Cela déterminera aussi la couleur de votre nom.

]=],
		REG_PLAYER_COLOR_TT = [=[|cffffff00Clic gauche:|r Sélectionner une couleur
|cffffff00Clic droit:|r Effacer la couleur]=],
		REG_PLAYER_CURRENT = "Actuellement",
		REG_PLAYER_CURRENTOOC = "Actuellement (HRP)",
		REG_PLAYER_CURRENT_OOC = "Ceci est une information hors du personnage",
		REG_PLAYER_EYE = "Couleur des yeux",
		REG_PLAYER_EYE_TT = [=[Vous pouvez indiquer ici la couleur des yeux de votre personnage.

Pensez bien que, même si le visage de votre personnage est constamment caché, il peut être utile de le mentionner, au cas où.]=],
		REG_PLAYER_FIRSTNAME = "Prénom",
		REG_PLAYER_FIRSTNAME_TT = [=[C'est le prénom de votre personnage. Ce champ est obligatoire, donc si vous ne spécifiez aucun nom, le nom du personnage par défaut (|cffffff00%s|r) sera utilisé.

Vous pouvez utiliser un |c0000ff00surnom |r!]=],
		REG_PLAYER_FULLTITLE = "Titre complet",
		REG_PLAYER_FULLTITLE_TT = [=[Vous pouvez indiquer ici le titre complet de votre personnage. Cela peut être une version plus longue du Titre ou un tout autre titre.

Cependant, vous devriez éviter les répétitions, s'il n'y a aucune information supplémentaire à mentionner.]=],
		REG_PLAYER_GLANCE = "Coup d'œil",
		REG_PLAYER_GLANCE_BAR_DELETED = "Le groupe d'emplacements |cffff9900%s|r a été supprimé.",
		REG_PLAYER_GLANCE_BAR_EMPTY = "Le nom du groupe ne peut pas être vide.",
		REG_PLAYER_GLANCE_BAR_LOAD = "Groupe d'emplacements",
		REG_PLAYER_GLANCE_BAR_LOAD_SAVE = "Groupe d'emplacements",
		REG_PLAYER_GLANCE_BAR_NAME = [=[Merci d'entrer le nom du groupe.

|cff00ff00Note: Si ce nom est déjà utilisé par un autre groupe, ce dernier sera remplacé.]=],
		REG_PLAYER_GLANCE_BAR_SAVE = "Sauvegarder comme groupe",
		REG_PLAYER_GLANCE_BAR_SAVED = "Le groupe d'emplacements |cff00ff00%s|r a été supprimé.",
		REG_PLAYER_GLANCE_BAR_TARGET = "Groupe de \"Coup d’œil\"",
		REG_PLAYER_GLANCE_CONFIG = [=[|cffffff00Clic gauche:|r Configurer l'emplacement
|cffffff00Clic droit:|r Activer/Désactiver l'emplacement
|cffffff00Glisser-déposer:|r Réorganiser les emplacements]=],
		REG_PLAYER_GLANCE_EDITOR = "Coup d'œil : Emplacement %s",
		REG_PLAYER_GLANCE_PRESET = "Charger depuis ...",
		REG_PLAYER_GLANCE_PRESET_ADD = "Modèle |cff00ff00%s|r créé.",
		REG_PLAYER_GLANCE_PRESET_ALERT1 = "Veuillez entrer une catégorie et un nom",
		REG_PLAYER_GLANCE_PRESET_CATEGORY = "Catégorie",
		REG_PLAYER_GLANCE_PRESET_CREATE = "Créer modèle",
		REG_PLAYER_GLANCE_PRESET_GET_CAT = [=[%s

Merci d'entrer le nom de la catégorie pour ce modèle]=],
		REG_PLAYER_GLANCE_PRESET_NAME = "Coup d'œil",
		REG_PLAYER_GLANCE_PRESET_REMOVE = "Modèle |cff00ff00%s|r supprimé.",
		REG_PLAYER_GLANCE_PRESET_SAVE = "Enregistrer le coup d'œil sous ...",
		REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Enregistrer",
		REG_PLAYER_GLANCE_PRESET_SELECT = "Choisir un coup d'œil",
		REG_PLAYER_GLANCE_TITLE = "Nom de l'attribut",
		REG_PLAYER_GLANCE_UNUSED = "Emplacement inutilisé",
		REG_PLAYER_GLANCE_USE = "Activer cet emplacement",
		REG_PLAYER_HEIGHT = "Taille",
		REG_PLAYER_HEIGHT_TT = [=[Il s'agit de la taille de votre personnage.
Il y a plusieurs manières de l'indiquer:|c0000ff00
- Un nombre précis: 170 cm, 6'5" ...
- Un qualificatif: Grand, petit ...]=],
		REG_PLAYER_HERE = "Obtenir la position",
		REG_PLAYER_HERE_HOME_PRE_TT = [=[Coordonnées actuelles:
|cff00ff00%s|r.]=],
		REG_PLAYER_HERE_HOME_TT = [=[|cffffff00Clic|r: Utiliser la position actuelle comme coordonnées de résidence
|cffffff00Clic-droit|r: Effacer les coordonnées de la résidence]=],
		REG_PLAYER_HERE_TT = "Cliquer pour obtenir votre position actuelle",
		REG_PLAYER_HISTORY = "Histoire",
		REG_PLAYER_ICON = "Icône du personnage",
		REG_PLAYER_ICON_TT = "Sélectionne une représentation graphique pour votre personnage.",
		REG_PLAYER_IGNORE = "Ignorer les personnages liés (%s)",
		REG_PLAYER_IGNORE_WARNING = [=[Voulez-vous ignorer ces personnages ?

|cffff9900%s

|rVous pouvez optionnellement entrer la raison de cette action. Cette note est personnelle et vous servira de rappel.]=],
		REG_PLAYER_LASTNAME = "Nom",
		REG_PLAYER_LASTNAME_TT = "C'est le nom de famille de votre personnage",
		REG_PLAYER_LEFTTRAIT = "Attribut de gauche",
		REG_PLAYER_MISC_ADD = "Ajouter un champ additionnel",
		REG_PLAYER_MORE_INFO = "Informations additionnelles",
		REG_PLAYER_MSP_HOUSE = "Maison",
		REG_PLAYER_MSP_MOTTO = "Devise",
		REG_PLAYER_MSP_NICK = "Surnom",
		REG_PLAYER_NAMESTITLES = "Noms et titres",
		REG_PLAYER_NO_CHAR = "Pas de caractéristiques",
		REG_PLAYER_PEEK = "Divers",
		REG_PLAYER_PHYSICAL = "Physique",
		REG_PLAYER_PSYCHO = "Personnalité",
		REG_PLAYER_PSYCHO_Acete = "Ascète",
		REG_PLAYER_PSYCHO_ADD = "Ajouter un trait de personnalité",
		REG_PLAYER_PSYCHO_ATTIBUTENAME_TT = "Nom de l'attribut",
		REG_PLAYER_PSYCHO_Bonvivant = "Bon vivant",
		REG_PLAYER_PSYCHO_CHAOTIC = "Chaotique",
		REG_PLAYER_PSYCHO_Chaste = "Chaste",
		REG_PLAYER_PSYCHO_Conciliant = "Parangon",
		REG_PLAYER_PSYCHO_Couard = "Couard",
		REG_PLAYER_PSYCHO_CREATENEW = "Créer un trait",
		REG_PLAYER_PSYCHO_Cruel = "Brutal",
		REG_PLAYER_PSYCHO_CUSTOM = "Trait personnalisé",
		REG_PLAYER_PSYCHO_Egoiste = "Egoïste",
		REG_PLAYER_PSYCHO_Genereux = "Altruiste",
		REG_PLAYER_PSYCHO_Impulsif = "Impulsif",
		REG_PLAYER_PSYCHO_Indulgent = "Indulgent",
		REG_PLAYER_PSYCHO_LEFTICON_TT = "Régler l'icône d'attribut de gauche",
		REG_PLAYER_PSYCHO_Loyal = "Loyal",
		REG_PLAYER_PSYCHO_Luxurieux = "Luxurieux",
		REG_PLAYER_PSYCHO_Misericordieux = "Miséricordieux",
		REG_PLAYER_PSYCHO_MORE = "Ajouter un point à \"%s\"",
		REG_PLAYER_PSYCHO_PERSONAL = "Traits personnels",
		REG_PLAYER_PSYCHO_Pieux = "Pieux",
		REG_PLAYER_PSYCHO_POINT = "Ajouter un point",
		REG_PLAYER_PSYCHO_Pragmatique = "Pragmatique",
		REG_PLAYER_PSYCHO_Rationnel = "Rationnel",
		REG_PLAYER_PSYCHO_Reflechi = "Réflechi",
		REG_PLAYER_PSYCHO_Rencunier = "Rancunier",
		REG_PLAYER_PSYCHO_RIGHTICON_TT = "Régler l'icône de l'attribut de droite.",
		REG_PLAYER_PSYCHO_Sincere = "Sincère",
		REG_PLAYER_PSYCHO_SOCIAL = "Traits sociaux",
		REG_PLAYER_PSYCHO_Trompeur = "Trompeur",
		REG_PLAYER_PSYCHO_Valeureux = "Valeureux",
		REG_PLAYER_RACE = "Race",
		REG_PLAYER_RACE_TT = "Il s'agit de la race de votre personnage. Il n'est pas nécessaire de se restreindre aux races jouables. Il y a de nombreuses races de Warcraft qui peuvent posséder des formes communes ...",
		REG_PLAYER_REGISTER = "Informations du registre",
		REG_PLAYER_RESIDENCE = "Lieu de résidence",
		REG_PLAYER_RESIDENCE_SHOW = "Coordonnées de résidence",
		REG_PLAYER_RESIDENCE_SHOW_TT = [=[|cff00ff00%s

|rClic pour afficher sur la carte]=],
		REG_PLAYER_RESIDENCE_TT = [=[Vous pouvez indiquer ici où votre personnage vit en temps normal. Il peut s'agir de son adresse personnelle (sa maison) ou un endroit où il séjourne.
Notez que si votre personnage est un voyageur ou encore un sans-domicile, vous devrez changer l'information en accord avec cela.

|c00ffff00Vous pouvez utiliser le bouton à droite pour définir facilement votre position actuelle comme Lieu de résidence.]=],
		REG_PLAYER_RIGHTTRAIT = "Attribut de droite",
		REG_PLAYER_SHOWMISC = "Afficher le panneau \"Divers\"",
		REG_PLAYER_SHOWMISC_TT = [=[Cochez si vous désirez afficher des champs personnalisés pour votre personnage.

Si vous ne désirez pas afficher de champs personnalisés, laissez ce bouton décoché et le panneau "Divers" restera complètement caché.]=],
		REG_PLAYER_SHOWPSYCHO = "Afficher le panneau de personnalité",
		REG_PLAYER_SHOWPSYCHO_TT = [=[Cochez si vous désirez utiliser la description de personnalité.

Si vous ne voulez pas indiquer la personnalité de votre personnage ainsi, laissez ce bouton décoché et le panneau de personnalité restera complètement caché.]=],
		REG_PLAYER_STYLE_ASSIST = "Aide au jeu de rôle",
		REG_PLAYER_STYLE_BATTLE = "Résolution de combats RP",
		REG_PLAYER_STYLE_BATTLE_1 = "JcJ World of Warcraft",
		REG_PLAYER_STYLE_BATTLE_2 = "Bataille de jets de dés TRP (Indisponible pour le moment)",
		REG_PLAYER_STYLE_BATTLE_3 = "Bataille de /rand",
		REG_PLAYER_STYLE_BATTLE_4 = "Bataille d'émotes",
		REG_PLAYER_STYLE_DEATH = "Accepte la mort",
		REG_PLAYER_STYLE_EMPTY = "Pas d'attribut de jeu de rôle partagé",
		REG_PLAYER_STYLE_FREQ = "Fréquence de jeu en RP",
		REG_PLAYER_STYLE_FREQ_1 = "Plein temps",
		REG_PLAYER_STYLE_FREQ_2 = "La plupart du temps",
		REG_PLAYER_STYLE_FREQ_3 = "La moitié du temps",
		REG_PLAYER_STYLE_FREQ_4 = "De temps en temps",
		REG_PLAYER_STYLE_FREQ_5 = "Pas un personnage RP",
		REG_PLAYER_STYLE_GUILD = "Appartenance à la guilde",
		REG_PLAYER_STYLE_GUILD_IC = "Membre RP",
		REG_PLAYER_STYLE_GUILD_OOC = "Membre HRP",
		REG_PLAYER_STYLE_HIDE = "Ne pas afficher",
		REG_PLAYER_STYLE_INJURY = "Accepte les blessures",
		REG_PLAYER_STYLE_PERMI = "Avec permission du joueur",
		REG_PLAYER_STYLE_ROMANCE = "Accepte la romance",
		REG_PLAYER_STYLE_RPSTYLE = "Style de roleplay",
		REG_PLAYER_STYLE_RPSTYLE_SHORT = "Style de RP",
		REG_PLAYER_STYLE_WOWXP = "Expérience de World of Warcraft",
		REG_PLAYER_TITLE = "Titre",
		REG_PLAYER_TITLE_TT = [=[Le titre de votre personnage est le titre par lequel votre personnage est habituellement appelé. Evitez les titres longs, l'attribut de Titre complet y est consacré.

Exemple de |c0000ff00titres appropriés |r:
|c0000ff00- Comtesse,
- Marquis,
- Magus,
- Seigneur,
- etc.
|rExemple of |cffff0000titres inappropriés|r:
|cffff0000- Comtesse des Marches du Nord,
- Magus de la Tour de Hurlevent,
- Diplomate pour le Gouvernement Draenei,
- etc.]=],
		REG_PLAYER_TRP2_PIERCING = "Piercings",
		REG_PLAYER_TRP2_TATTOO = "Tatouages",
		REG_PLAYER_TRP2_TRAITS = "Traits du visage",
		REG_PLAYER_TUTO_ABOUT_COMMON = [=[|cff00ff00Thème de personnage:|r
Vous pouvez choisir un |cffffff00thème|r pour votre personnage. Pensez-y comme une |cffffff00musique d'ambiance pour lire la description de votre personnage|r.

|cff00ff00Arrière-plan:|r
Ceci est une |cffffff00texture d'arrière-plan|r pour la description de votre personnage.

|cff00ff00Modèle:|r
Le modèle choisi définit |cffffff00le format général et les possibilités d'écriture|r de votre description.
|cffff9900Seul le modèle sélectionné est visible par les autres, vous n'avez donc pas à tous les remplir.|r
Une fois qu'un modèle est choisi, vous pouvez rouvrir ce tutoriel pour avoir plus d'aide à propos de chaque modèle.]=],
		REG_PLAYER_TUTO_ABOUT_MISC_1 = [=[Cette section vous fournit des |cffffff005 emplacements|r dans lesquels vous pouvez décrire |cff00ff00les informations les plus importantes à propos de votre personnage|r.

Ces informations seront visibles sur la |cffffff00barre "Coup d'œil"|r lorsque quelqu'un sélectionne votre personnage.

|cff00ff00Astuce: Vous pouvez glisser et déposer les emplacements pour les réorganiser.|r
Cela marche aussi sur la |cffffff00barre "Coup d'œil"|r!]=],
		REG_PLAYER_TUTO_ABOUT_MISC_3 = "Cette section fournit |cffffff00une liste d'indicateurs|r pour répondre à beaucoup de |cffffff00questions usuelles que les joueurs peuvent vous demander à propos de vous, votre personnage, et la manière dont vous souhaitez le jouer|r.",
		REG_PLAYER_TUTO_ABOUT_T1 = [=[Ce modèle vous permet de |cff00ff00structurer librement votre description|r.

La description n'a pas besoin d'être limitée uniquement à la |cffff9900description physique|r de votre personnage. N'hésitez pas à indiquer des parties de son |cffff9900histoire|r ou des détails sur sa |cffff9900personnalité|r.

Avec ce modèle vous pouvez aussi utiliser les outils de formatage pour accéder à plusieurs paramètres de mise en page tels que |cffffff00les tailles de texte, les couleurs, ou les alignements|r.
Ces outils vous permettent aussi d'insérer |cffffff00des images, des icônes ou des liens vers des sites web externes|r.]=],
		REG_PLAYER_TUTO_ABOUT_T2 = [=[Ce modèle est plus structuré et consiste en |cff00ff00une liste de cadres indépendants|r.

Chaque cadre est caractérisé par une |cffffff00icône, un arrière-plan et un texte|r. Notez que vous pouvez utiliser quelques balises de texte dans ces cadres, comme celles de couleur, ou d'icônes.

La description n'a pas besoin d'être limitée uniquement à la |cffff9900description physique|r de votre personnage. N'hésitez pas à indiquer des parties de son |cffff9900histoire|r ou des détails sur sa |cffff9900personnalité|r.]=],
		REG_PLAYER_TUTO_ABOUT_T3 = [=[Ce modèle est découpé en 3 sections: |cff00ff00Description physique, personnalité et histoire|r.

Vous n'avez pas à remplir tous les cadres, |cffff9900Si vous laissez un cadre vide, il ne sera pas affiché sur votre description|r.

Chaque cadre est caractérisé par une |cffffff00icône, un arrière-plan et un texte|r. Notez que vous pouvez utiliser quelques balises de texte dans ces cadres, comme celles de couleur, ou d'icônes.]=],
		REG_PLAYER_WEIGHT = "Stature",
		REG_PLAYER_WEIGHT_TT = [=[Il s'agit de la stature de votre personnage.
Il pourrait par exemple être |c0000ff00mince, gros ou musclé...|r Ou tout simplement être dans la norme !]=],
		REG_REGISTER = "Registre",
		REG_REGISTER_CHAR_LIST = "Liste de personnages",
		REG_RELATION = "Relation",
		REG_RELATION_BUSINESS = "Commerce",
		REG_RELATION_BUSINESS_TT = "%s et %s sont dans une relation d'affaires.",
		REG_RELATION_BUTTON_TT = [=[Relation: %s
|cff00ff00%s

|cffffff00Cliquer pour afficher les actions possibles]=],
		REG_RELATION_FAMILY = "Famille",
		REG_RELATION_FAMILY_TT = "%s partage des liens du sang avec %s.",
		REG_RELATION_FRIEND = "Amical",
		REG_RELATION_FRIEND_TT = "%s considère %s comme un ami.",
		REG_RELATION_LOVE = "Amour",
		REG_RELATION_LOVE_TT = "%s est amoureux de %s !",
		REG_RELATION_NEUTRAL = "Neutre",
		REG_RELATION_NEUTRAL_TT = "%s n'a pas d'affection particulière pour %s.",
		REG_RELATION_NONE = "Aucune",
		REG_RELATION_NONE_TT = "%s ne connaît pas %s.",
		REG_RELATION_TARGET = "|cffffff00Clic gauche: |rChanger la relation",
		REG_RELATION_UNFRIENDLY = "Hostile",
		REG_RELATION_UNFRIENDLY_TT = "%s n'aime vraiment pas %s.",
		REG_TT_GUILD = "%s de |cffff9900%s",
		REG_TT_GUILD_IC = "membre RP",
		REG_TT_GUILD_OOC = "membre HRP",
		REG_TT_IGNORED = "< Le personnage est ignoré >",
		REG_TT_IGNORED_OWNER = "< Le propriétaire est ignoré >",
		REG_TT_LEVEL = "Niveau %s %s",
		REG_TT_NOTIF = "Description non-lue",
		REG_TT_REALM = "Royaume: |cffff9900%s",
		REG_TT_TARGET = "Cible: |cffff9900%s",
		TB_AFK_MODE = "Absent",
		TB_DND_MODE = "Ne pas déranger",
		TB_GO_TO_MODE = "Passer en mode %s",
		TB_LANGUAGE = "Langage",
		TB_LANGUAGES_TT = "Changer de langage",
		TB_NORMAL_MODE = "Normal",
		TB_RPSTATUS_OFF = "Personnage: |cffff0000Hors du personnage",
		TB_RPSTATUS_ON = "Personnage: |cff00ff00Dans le personnage",
		TB_RPSTATUS_TO_OFF = "Passer |cffff0000hors du personnage",
		TB_RPSTATUS_TO_ON = "Passer |cff00ff00dans le personnage",
		TB_STATUS = "Joueur",
		TB_SWITCH_CAPE_1 = "Afficher la cape",
		TB_SWITCH_CAPE_2 = "Masquer la cape",
		TB_SWITCH_CAPE_OFF = "Cape: |cffff0000Masquée",
		TB_SWITCH_CAPE_ON = "Cape: |cffff0000Affichée",
		TB_SWITCH_HELM_1 = "Afficher le casque",
		TB_SWITCH_HELM_2 = "Masquer le casque",
		TB_SWITCH_HELM_OFF = "Casque: |cffff0000Masqué",
		TB_SWITCH_HELM_ON = "Casque: |cffff0000Affiché",
		TB_SWITCH_PROFILE = "Passer à un autre profil",
		TB_SWITCH_TOOLBAR = "Afficher/masquer la barre d'outils",
		TB_TOOLBAR = "Barre d'outils",
		TF_IGNORE = "Ignorer le joueur",
		TF_IGNORE_CONFIRM = [=[Êtes-vous sûr de vouloir ignorer ce joueur ?

|cffffff00%s|r

|cffff7700Vous pouvez entrer optionnellement la raison d'ignorer le joueur ci-dessous. C'est une note personnelle, elle ne sera vue par personne d'autre et servira de rappel.]=],
		TF_IGNORE_NO_REASON = "Aucune raison",
		TF_IGNORE_TT = "|cffffff00Clic gauche:|r Ignorer le joueur",
		TF_OPEN_CHARACTER = "Afficher la fiche du personnage",
		TF_OPEN_COMPANION = "Afficher la fiche du familier",
		TF_OPEN_MOUNT = "Afficher la fiche de la monture",
		TF_PLAY_THEME = "Jouer le thème du personnage",
		TF_PLAY_THEME_TT = [=[|cffffff00Clic gauche:|r Jouer |cff00ff00%s
|cffffff00Clic droit:|r Arrêter le thème]=],
		UI_BKG = "Arrière-plan %s",
		UI_CLOSE_ALL = "Fermer tout",
		UI_COLOR_BROWSER = "Sélecteur de couleur",
		UI_COLOR_BROWSER_SELECT = "Choisir une couleur",
		UI_COMPANION_BROWSER_HELP = "Sélectionner une mascotte",
		UI_COMPANION_BROWSER_HELP_TT = [=[|cffffff00Attention: |rSeules les mascottes renommées peuvent être associées à un profil.

|cff00ff00Cette section ne liste que ces mascottes.]=],
		UI_FILTER = "Filtre",
		UI_ICON_BROWSER = "Navigateur d'icônes",
		UI_ICON_BROWSER_HELP = "Copier l'icône",
		UI_ICON_BROWSER_HELP_TT = [=[Tant que cette fenêtre est ouverte, vous pouvez |cffffff00CTRL + cliquer|r sur une icône pour copier son nom.

Disponible pour:|cff00ff00
- Un objet de votre sac
- Un sort du grimoire|r]=],
		UI_ICON_SELECT = "Choisir une icône",
		UI_IMAGE_BROWSER = "Navigateur d'images",
		UI_IMAGE_SELECT = "Choisir une image",
		UI_LINK_TEXT = "Votre texte ici",
		UI_LINK_URL = "http://votre.url.ici",
		UI_LINK_WARNING = [=[Voici l'URL du lien.
Vous pouvez le copier-coller dans votre navigateur web.

|cffff0000!! Attention !!|r
Total RP n'est pas responsable du contenu des liens partagés.]=],
		UI_MUSIC_BROWSER = "Navigateur de musiques",
		UI_MUSIC_SELECT = "Choisir une musique",
		UI_TUTO_BUTTON = "Mode tutoriel",
		UI_TUTO_BUTTON_TT = "Cliquer pour afficher ou masquer le mode tutoriel",
		WHATS_NEW = [=[{h3:c}Nouveau dans la version {col:6eff51}1.0.1{/col}{/h3}
{h3}1. Onglet modules{/h3}
Découvrez les nouveaux {link*modules*modules} optionnels !

{h3}2. Coordonnées de résidence{/h3}
Vous pouvez maintenant placer sur la carte la résidence de votre personnage en cliquant sur le bouton "Obtenir la position" pendant l'édition des caractéristiques.
Les autres joueurs pourront voir ce marqueur sur leur carte lors de leur visite de votre profil.

{h3}3. Purge automatique du registre{/h3}
WoW n'est pas parfait, et un bug ennuyant provoque l'effacement de toutes les données d'un addon lorsqu'elle atteignent une certaine taille.
Pour réduire les chances que cela arrive, nous avons ajouté un système de purge automatique effaçant les profils de personnages que vous n'avez pas croisé depuis plus de 5 jours et sur lesquels vous n'avez placé aucune relation.
Vous pouvez changer ce comportement {link*scandisable*ici}.]=],
		MORE_MODULES = [[{h2:c}Modules optionnels{/h2}
{h3}Storyline{/h3}
|cff9999ffStoryline|r est un module améliorant la manière dont les quêtes de World of Warcraft vous seront contées.
|cff9999ffVisitez vite: {link*storyline*http://storyline.totalrp3.info}]],
		DB_MORE = "Modules additionnels",
		THANK_YOU = [[{h1:c}Total RP 3{/h1}
{p:c}{col:6eff51}Version %s (build %s){/col}{/p}
{p:c}http://totalrp3.info{/p}

{h2}{icon:INV_Eng_gizmo1:20} Créé par{/h2}
- Renaud "{twitter*EllypseCelwe*Ellypse}" Parize
- Sylvain "{twitter*Telkostrasz*Telkostrasz}" Cossement


{h2}{icon:THUMBUP:20} Remerciements{/h2}
{col:ffffff}Notre équipe de test pré-alpha:{/col}
- Saelora
- Erzan
- Calian
- Kharess
- Alnih
- 611

{col:ffffff}Merci à tous nos amis pour leur support au fil des années:{/col}
- Pour Telkos: Kharess, Kathryl, Marud, Solona, Stretcher, Lisma...
- Pour Ellypse: Les guildes Maison Celwë'Belore, Mercenaires Atal'ai, et plus particulièrement Erzan, Elenna, Caleb, Siana et Adaeria.

{col:ffffff}Pour nous avoir aidé à créer la guilde Total RP sur Kirin Tor (EU):{/col}
- Azane
- Hellclaw
- Leylou
{col:ffffff}Merci à Horionne, pour nous avoir envoyé le magazine Gamer Culte Online numéro 14 avec l'article sur Total RP:{/col}]]
	}


};

TRP3_API.locale.registerLocale(LOCALE);