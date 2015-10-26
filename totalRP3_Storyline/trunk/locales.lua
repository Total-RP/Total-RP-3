----------------------------------------------------------------------------------
--  Storyline
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--	Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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

Storyline_API = {
	lib = {},
	locale = {},
};

Storyline_API.locale.info = {

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_EN
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["enUS"] = {
		localeText = "English",
		localeContent = {
			SL_STORYLINE = "Storyline",
			SL_SELECT_DIALOG_OPTION = "Select dialog option",
			SL_SELECT_AVAILABLE_QUEST = "Select available quest",
			SL_WELL = "Well ...",
			SL_ACCEPTANCE = "I accept.",
			SL_DECLINE = "I refuse.",
			SL_NEXT = "Continue",
			SL_CONTINUE = "Complete quest",
			SL_NOT_YET = "Come back when it's done",
			SL_CHECK_OBJ = "Check objectives",
			SL_RESET = "Rewind",
			SL_RESET_TT = "Rewind this dialogue.",
			SL_REWARD_MORE = "You will also get",
			SL_REWARD_MORE_SUB = "\nMoney: |cffffffff%s|r\nExperience: |cffffffff%s xp|r\n\n|cffffff00Click:|r Get your reward!",
			SL_GET_REWARD = "Get your reward",
			SL_SELECT_REWARD = "Select your reward",
			SL_CONFIG = "Settings",
			SL_CONFIG_WELCOME = [[Thank you for using Storyline!

You can follow Storyline developers on Twitter |cff55acee@EllypseCelwe|r and |cff55acee@Telkostrasz|r to get news about the add-on and sneek peaks of its development.
]],
			SL_CONFIG_LANGUAGE = "Language",
			SL_CONFIG_TEXTSPEED_TITLE = "Text animation speed",
			SL_CONFIG_TEXTSPEED = "%.1fx",
			SL_CONFIG_TEXTSPEED_INSTANT = "No animation",
			SL_CONFIG_TEXTSPEED_HIGH = "Fast",
			SL_CONFIG_AUTOEQUIP = "Auto equip reward (experimental)",
			SL_CONFIG_AUTOEQUIP_TT = "Auto equip rewards if it has a better item lvl.",
			SL_CONFIG_FORCEGOSSIP = "Show flavor texts",
			SL_CONFIG_FORCEGOSSIP_TT = "Show flavor texts on NPCs like merchants or fly masters.",
			SL_CONFIG_USE_KEYBOARD = "Use keyboard shortcuts",
			SL_CONFIG_USE_KEYBOARD_TT = "Use keyboard shortcuts to navigate inside dialogs (space bar to advance, backspace to go back, keys 1 to 0 to select a dialog choice)",
			SL_CONFIG_HIDEORIGINALFRAMES = "Hide original frames",
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Hide the original quest frame and NPC dialogs frame.",
			SL_CONFIG_LOCKFRAME = "Lock frame",
			SL_CONFIG_LOCKFRAME_TT = "Lock Storyline frame so it cannot be moved by mistake.",
			SL_CONFIG_SAMPLE_TEXT = "Grumpy wizards make toxic brew for the evil queen and jack",
			SL_CONFIG_BIG_SAMPLE_TEXT = [[Here’s to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can’t do is ignore them.]],
			SL_CONFIG_QUEST_TITLE = "Quest title",
			SL_CONFIG_DIALOG_TEXT = "Dialog text",
			SL_CONFIG_NPC_NAME = "NPC name",
			SL_CONFIG_NEXT_ACTION = "Next action";
			SL_CONFIG_STYLING_OPTIONS = "Styling options",
			SL_CONFIG_STYLING_OPTIONS_SUBTEXT = "", -- Nothing for now, maybe later
			SL_CONFIG_MISCELLANEOUS_SUBTEXT = "", -- Nothing for now, maybe later
			SL_CONFIG_MISCELLANEOUS = "Miscellaneous options",
			SL_CONFIG_DEBUG = "Debug mode",
			SL_CONFIG_DEBUG_TT = "Enable the debug frame showing development data under Storyline frame",
			SL_RESIZE = "Resize",
			SL_RESIZE_TT = "Drag and drop to resize",
		}
	},
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_FR
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["frFR"] = {
		localeText = "Français",
		localeContent = {
			SL_ACCEPTANCE = "J'accepte.", -- Needs review
			SL_CHECK_OBJ = "Vérifier objectifs", -- Needs review
			SL_CONFIG = "Configuration",
			SL_CONFIG_AUTOEQUIP = "Équipement automatique (expérimental)",
			SL_CONFIG_AUTOEQUIP_TT = "Équipe automatiquement les récompense si elles ont un meilleur niveau d'équipement.",
			SL_CONFIG_BIG_SAMPLE_TEXT = [=[« C'est un trou de verdure où chante une rivière,
Accrochant follement aux herbes des haillons
D'argent ; où le soleil, de la montagne fière,
Luit : c'est un petit val qui mousse de rayons. »
— Arthur Rimbaud]=], -- Needs review
			SL_CONFIG_DEBUG = "Mode débug", -- Needs review
			SL_CONFIG_DEBUG_TT = "Activer le mode débug pour afficher la fenêtre d'informations de développement sous la fenêtre principale de Storyline.", -- Needs review
			SL_CONFIG_DIALOG_TEXT = "Texte de dialogues", -- Needs review
			SL_CONFIG_FORCEGOSSIP = "Forcer les textes des PNJs", -- Needs review
			SL_CONFIG_FORCEGOSSIP_TT = "Forcer l'affichage des textes des PNJs normalement masqués, comme les marchands ou les maîtres de vol.", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES = "Cacher les fenêtres originales", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Cacher les fenêtres originales du jeu (quêtes et dialogues de PNJs) pour qu'il n'y ait que Storyline de visible à l'écran.",
			SL_CONFIG_LOCKFRAME = "Verrouiller la fenêtre", -- Needs review
			SL_CONFIG_LOCKFRAME_TT = "Verrouiller la fenêtre de Storyline pour empêcher un déplacement par erreur.",
			SL_CONFIG_MISCELLANEOUS = "Options diverses", -- Needs review
			SL_CONFIG_NEXT_ACTION = "Action suivante", -- Needs review
			SL_CONFIG_NPC_NAME = "Nom du PNJ", -- Needs review
			SL_CONFIG_QUEST_TITLE = "Titre de la quête", -- Needs review
			SL_CONFIG_SAMPLE_TEXT = "Voix ambiguë d’un cœur qui au zéphyr préfère les jattes de kiwi.", -- Needs review
			SL_CONFIG_STYLING_OPTIONS = "Options d’affichage", -- Needs review
			SL_CONFIG_TEXTSPEED = "%.1fx", -- Needs review
			SL_CONFIG_TEXTSPEED_HIGH = "Rapide", -- Needs review
			SL_CONFIG_TEXTSPEED_INSTANT = "Pas de défilement", -- Needs review
			SL_CONFIG_TEXTSPEED_TITLE = "Vitesse d'animation du texte", -- Needs review
			SL_CONFIG_USE_KEYBOARD = "Utiliser les raccourcis clavier", -- Needs review
			SL_CONFIG_USE_KEYBOARD_TT = "Utiliser les raccourcis clavier pour naviguer dans les dialogues (barre espace pour avancer, touche retour pour revenir en arrière, touches 1 à 0 pour sélectionner une option de dialogue).", -- Needs review
			SL_CONFIG_WELCOME = [=[Merci d'utiliser Storyline!

Vous pouvez suivre les développeurs de Storyline sur Twitter, |cff55acee@EllypseCelwe|r et |cff55acee@Telkostrasz|r, pour recevoir des informations sur les mise-à-jour de l'add-on et des aperçu de son développement.]=], -- Needs review
			SL_CONTINUE = "Terminer la quête", -- Needs review
			SL_DECLINE = "Je refuse.", -- Needs review
			SL_GET_REWARD = "Prenez votre récompense", -- Needs review
			SL_NEXT = "Continuer", -- Needs review
			SL_NOT_YET = "Revenez quand cela sera fait", -- Needs review
			SL_RESET = "Début", -- Needs review
			SL_RESET_TT = "Revenir au début du dialogue", -- Needs review
			SL_RESIZE = "Redimensionner", -- Needs review
			SL_RESIZE_TT = "Cliquer-glisser pour redimensionner", -- Needs review
			SL_REWARD_MORE = "Vous recevrez aussi", -- Needs review
			SL_REWARD_MORE_SUB = [=[
Argent: |cffffffff%s|r
Expérience: |cffffffff%s xp|r

|cffffff00Clic:|r Prenez votre récompense !]=],
			SL_SELECT_AVAILABLE_QUEST = "Sélectionnez une quête", -- Needs review
			SL_SELECT_DIALOG_OPTION = "Sélectionnez une option", -- Needs review
			SL_SELECT_REWARD = "Choisissez votre récompense", -- Needs review
			SL_STORYLINE = "Storyline",
			SL_WELL = "Et bien…", -- Needs review
		}
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_SP
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	["esES"] = {
		localeText = "Español",
		localeContent = {
			SL_ACCEPTANCE = "Acepto", -- Needs review
			SL_CHECK_OBJ = "Comprueba los objetivos", -- Needs review
			SL_CONFIG = "Configuración", -- Needs review
			SL_CONFIG_AUTOEQUIP = "Equipar automaticamente recompensas (experimental)", -- Needs review
			SL_CONFIG_AUTOEQUIP_TT = "Equipa automaticamente las recompensas si tienen un nivel de equipo mejor.", -- Needs review
			SL_CONFIG_DEBUG = "Modo de depuración", -- Needs review
			SL_CONFIG_DEBUG_TT = "Activa el marco de depuración que muestra información de desarrollo debajo del marco de Storyline", -- Needs review
			SL_CONFIG_DIALOG_TEXT = "Texto de dialogo", -- Needs review
			SL_CONFIG_FORCEGOSSIP = "Forzar diálogos de PNJs", -- Needs review
			SL_CONFIG_FORCEGOSSIP_TT = "Fuerza a que aparezcan diálogos generalmente ocultos en PNJs, como comerciantes y maestros de vuelo", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES = "Ocultar los marcos originales", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Oculta los marcos originales (diálogos de misión y PNJ) de forma que solo Storyline estará visible en la pantalla", -- Needs review
			SL_CONFIG_LOCKFRAME = "Bloquear marco", -- Needs review
			SL_CONFIG_LOCKFRAME_TT = "Bloquea el marco de Storyline de forma que no se mueva por error.", -- Needs review
			SL_CONFIG_MISCELLANEOUS = "Opciones varias", -- Needs review
			SL_CONFIG_NEXT_ACTION = "Siguiente acción", -- Needs review
			SL_CONFIG_NPC_NAME = "Nombre del PNJ", -- Needs review
			SL_CONFIG_QUEST_TITLE = "Título de la misión", -- Needs review
			SL_CONFIG_STYLING_OPTIONS = "Opciones de estilo", -- Needs review
			SL_CONFIG_TEXTSPEED = "%.1fx", -- Needs review
			SL_CONFIG_TEXTSPEED_HIGH = "Alta", -- Needs review
			SL_CONFIG_TEXTSPEED_INSTANT = "Sin animación", -- Needs review
			SL_CONFIG_TEXTSPEED_TITLE = "Velocidad de animación del texto", -- Needs review
			SL_CONFIG_USE_KEYBOARD = "Utilizar atajos de teclado", -- Needs review
			SL_CONFIG_USE_KEYBOARD_TT = "Utiliza atajos del teclado para moverte por los diálogos (barra espaciadora para avanzar, retroceso para volver, teclas 1 al 0 para seleccionar una opción de diálogo)", -- Needs review
			SL_CONFIG_WELCOME = [=[¡Gracias por usar Storyline!

Puedes seguir a los desarrolladores de Storyline en Twitter, |cff55acee@EllypseCelwe|r y |cff55acee@Telkostrasz|r, para recibir noticias acerca del add-on y adelantos de su desarrollo.]=], -- Needs review
			SL_CONTINUE = "Completar misión", -- Needs review
			SL_DECLINE = "Me niego", -- Needs review
			SL_GET_REWARD = "Obtén tu recompensa", -- Needs review
			SL_NEXT = "Continuar", -- Needs review
			SL_NOT_YET = "Vuelve cuando hayas acabado", -- Needs review
			SL_RESET = "Vuelve atrás", -- Needs review
			SL_RESET_TT = "Vuelve atrás este dialogo", -- Needs review
			SL_RESIZE = "Redimensionar", -- Needs review
			SL_RESIZE_TT = "Arrastra y suelta para redimensionar", -- Needs review
			SL_REWARD_MORE = "Ademas conseguirás", -- Needs review
			SL_REWARD_MORE_SUB = [=[
Dinero: |cffffffff%s|r
Experiencia: |cffffffff%s exp|r

|cffffff00Clic:|r ¡Obtén tu recompensa!]=], -- Needs review
			SL_SELECT_AVAILABLE_QUEST = "Selecciona una misión disponible", -- Needs review
			SL_SELECT_DIALOG_OPTION = "Selecciona una opción de dialogo", -- Needs review
			SL_SELECT_REWARD = "Selecciona tu recompensa", -- Needs review
			SL_STORYLINE = "Storyline", -- Needs review
			SL_WELL = "Bueno ...", -- Needs review
		}
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_DE
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	["deDE"] = {
		localeText = "Deutsch",
		localeContent = {
			SL_ACCEPTANCE = "Ich akzeptiere.", -- Needs review
			SL_CHECK_OBJ = "Questziele überprüfen", -- Needs review
			SL_CONFIG = "Parameter",
			SL_CONFIG_AUTOEQUIP = "Belohnung automatisch anlegen", -- Needs review
			SL_CONFIG_AUTOEQUIP_TT = "Belohnungen automatisch anlegen, falls sie eine bessere Gegenstandsstufe haben.", -- Needs review
			SL_CONFIG_FORCEGOSSIP = "Geschwätz immer anzeigen", -- Needs review
			SL_CONFIG_FORCEGOSSIP_TT = "Geschwätz bei NSCs wie Händler und Flugmeister immer anzeigen.", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES = "Originalfenster verstecken", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Versteckt die Originalfenster (Quest- und NPC-Dialoge), sodass nur Storyline auf dem Bildschirm sichtbar ist.",
			SL_CONFIG_LOCKFRAME = "Fenster fixieren", -- Needs review
			SL_CONFIG_LOCKFRAME_TT = "Fixiert das Storyline-Fenster, sodass es nicht aus Versehen verschoben werden kann.", -- Needs review
			SL_CONFIG_TEXTSPEED = "%.1fx", -- Needs review
			SL_CONFIG_TEXTSPEED_HIGH = "Hoch", -- Needs review
			SL_CONFIG_TEXTSPEED_INSTANT = "Keine Anim.", -- Needs review
			SL_CONTINUE = "Quest abschließen", -- Needs review
			SL_DECLINE = "Ich lehne ab.", -- Needs review
			SL_GET_REWARD = "Erhaltet Eure Belohnung", -- Needs review
			SL_NEXT = "Fortsetzen", -- Needs review
			SL_NOT_YET = "Kehrt zurück, wenn es erledigt ist", -- Needs review
			SL_RESET = "Zurückspulen", -- Needs review
			SL_RESET_TT = "Spult diesen Dialog zurück.", -- Needs review
			SL_RESIZE = "Größe ändern", -- Needs review
			SL_RESIZE_TT = "Ziehen und loslassen um die Größe zu ändern", -- Needs review
			SL_REWARD_MORE = "Ihr bekommt außerdem", -- Needs review
			SL_REWARD_MORE_SUB = [=[
Geld: |cffffffff%s|r
Erfahrung: |cffffffff%s EP|r

|cffffff00Click:|r Erhaltet Eure Belohnung!]=], -- Needs review
			SL_SELECT_AVAILABLE_QUEST = "Verfügbare Quest wählen", -- Needs review
			SL_SELECT_DIALOG_OPTION = "Dialogoption wählen", -- Needs review
			SL_SELECT_REWARD = "Wählt Eure Belohnung", -- Needs review
			SL_STORYLINE = "Storyline", -- Needs review
			SL_WELL = "Nun...", -- Needs review
		}
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_IT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	["itIT"] = {
		localeText = "Italiano",
		localeContent = {
			SL_ACCEPTANCE = "Accetto.", -- Needs review
			SL_CHECK_OBJ = "Controlla gli obiettivi", -- Needs review
			SL_CONFIG = "Parametri", -- Needs review
			SL_CONFIG_AUTOEQUIP = "Equipaggia automaticamente la ricompensa (sperimentale)", -- Needs review
			SL_CONFIG_AUTOEQUIP_TT = "Equipaggia automaticamente la ricompensa se il LivOg è più alto", -- Needs review
			SL_CONFIG_FORCEGOSSIP = "Attiva convenevoli", -- Needs review
			SL_CONFIG_FORCEGOSSIP_TT = "Attiva convenevoli per i PNG come mercanti o maestri di volo.", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES = "Nascondi i riquadri originali", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Nascondi i riquadri originali (dialoghi missioni e PNG) in modo che sia visualizzato solo Sotryline.", -- Needs review
			SL_CONFIG_LOCKFRAME = "Blocca riquadro", -- Needs review
			SL_CONFIG_LOCKFRAME_TT = "Blocca il riquadro di Storyline così da evitare di spostarlo per errore.", -- Needs review
			SL_CONFIG_TEXTSPEED = "%.1fx", -- Needs review
			SL_CONFIG_TEXTSPEED_HIGH = "Alta", -- Needs review
			SL_CONFIG_TEXTSPEED_INSTANT = "Nessuna animazione", -- Needs review
			SL_CONTINUE = "Completa la missione", -- Needs review
			SL_DECLINE = "Non accetto.", -- Needs review
			SL_GET_REWARD = "Ottieni la ricompensa", -- Needs review
			SL_NEXT = "Continua", -- Needs review
			SL_NOT_YET = "Torna a missione completata", -- Needs review
			SL_RESET = "Riavvolgi", -- Needs review
			SL_RESET_TT = "Riavvolgi il dialogo.", -- Needs review
			SL_RESIZE = "Ridimensiona", -- Needs review
			SL_RESIZE_TT = "Trascina il riquadro per ridimensionarlo", -- Needs review
			SL_REWARD_MORE = "Otterrai anche", -- Needs review
			SL_REWARD_MORE_SUB = [=[
Denaro: |cffffffff%s|r
Esperienza: |cffffffff%s xp|r

|cffffff00Click:|r Ottieni la ricompensa!]=], -- Needs review
			SL_SELECT_AVAILABLE_QUEST = "Seleziona le missioni disponibili", -- Needs review
			SL_SELECT_DIALOG_OPTION = "Seleziona l'opzione di dialogo", -- Needs review
			SL_SELECT_REWARD = "Seleziona la ricompensa", -- Needs review
			SL_STORYLINE = "Storyline", -- Needs review
			SL_WELL = "Be'...", -- Needs review
		}
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_RU
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	--[[
	["ruRU"] = {
		localeContent = {
			SL_ACCEPTANCE = "Соглашаюсь", -- Needs review
			SL_CHECK_OBJ = "Показать цель", -- Needs review
			SL_CONFIG = "Параметры",
			SL_CONFIG_AUTOEQUIP = "Автоснаряжение персонажа (пробно)", -- Needs review
			SL_CONFIG_AUTOEQUIP_TT = "Автоматически надевать полученную вещь, если у неё уровень предмета выше.", -- Needs review
			SL_CONFIG_FORCEGOSSIP = "Мгновенное отображение текста задания", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES = "Скрыть стандартные окна", -- Needs review
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Отображать только окна Storyline (скрыть стандартные окна заданий и диалогов с NPC).", -- Needs review
			SL_CONFIG_LOCKFRAME = "Закрепить окно", -- Needs review
			SL_CONFIG_LOCKFRAME_TT = "Закрепить окно аддона", -- Needs review
			SL_CONFIG_TEXTSPEED = "%.1fx", -- Needs review
			SL_CONFIG_TEXTSPEED_HIGH = "Высокая", -- Needs review
			SL_CONFIG_TEXTSPEED_INSTANT = "Без анимации", -- Needs review
			SL_CONTINUE = "Завершить", -- Needs review
			SL_DECLINE = "Отказываюсь", -- Needs review
			SL_GET_REWARD = "Получить награду", -- Needs review
			SL_NEXT = "Продолжить", -- Needs review
			SL_NOT_YET = "Возвращайся, когда выполнишь", -- Needs review
			SL_RESET = "Отмотать назад", -- Needs review
			SL_RESET_TT = "Отобразить диалог повторно", -- Needs review
			SL_RESIZE = "Размер окна", -- Needs review
			SL_RESIZE_TT = "Потяните", -- Needs review
			SL_REWARD_MORE = "Также получите", -- Needs review
			SL_REWARD_MORE_SUB = [=[Золото: |cffffffff%s|r
Опыт: |cffffffff%s xp|r

|cffffff00Click:|r Получите награду!]=], -- Needs review
			SL_SELECT_AVAILABLE_QUEST = "Выбирайте задание", -- Needs review
			SL_SELECT_DIALOG_OPTION = "Выбирайте", -- Needs review
			SL_SELECT_REWARD = "Выбор награды", -- Needs review
			SL_STORYLINE = "Storyline", -- Needs review
			SL_WELL = "Ну так что?", -- Needs review
		}
	},]]

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_ZHTW
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	--[[
	["zhTW"] = {
		localeContent = {
			SL_ACCEPTANCE = "我接受。",
			SL_CHECK_OBJ = "任務目標是...",
			SL_CONFIG = "選項",
			SL_CONFIG_AUTOEQUIP = "自動裝備獎勵物品 (實驗性功能)",
			SL_CONFIG_AUTOEQUIP_TT = "當物品等級較高時，自動裝備獎勵。",
			SL_CONFIG_BIG_SAMPLE_TEXT = "在魔獸世界還在內部測試的時候，遊戲裡曾有許多有待修正的bug，其中有個bug是，在大陸間航行的船隻有時會莫名失效，於是暴雪設置了幾個NPC，讓玩家直接傳送到另一個大陸，其中的一個NPC則深受玩家喜愛，普萊斯霍德船長(暫定船長)，暫定船長究竟有多受歡迎呢? 玩家甚至特意為這個NPC做了詞曲，在bug修正後，暫定船長就被移除了。不過，在魔獸正式上線後，這bug又出現了，暴雪只能再把暫定船長搬了出來，玩家深愛上了船長，於是當暴雪移除這個NPC時。玩家哭著鬧著吼著吵著，要求暴雪把船長送回來。於是在大災變裡，暴雪又將NPC放進遊戲，是一個85級的精英部落陣營NPC，不過這NPC沒有達到預期效果，模型也改過了，反正，已經不是當年那個船長了。但是，暫定船長會永遠地活在我們心裡。", -- Needs review
			SL_CONFIG_DEBUG = "除錯模式",
			SL_CONFIG_DEBUG_TT = "啟用除錯框架，在任務劇情故事框架下方顯示開發資訊。",
			SL_CONFIG_DIALOG_TEXT = "對話文字",
			SL_CONFIG_FORCEGOSSIP = "顯示口頭禪文字",
			SL_CONFIG_FORCEGOSSIP_TT = "顯示NPC的口頭禪文字，例如商人或飛行管理員。",
			SL_CONFIG_HIDEORIGINALFRAMES = "隱藏遊戲內建的框架",
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "隱藏原始的任務框架和NPC對話框。",
			SL_CONFIG_LOCKFRAME = "鎖定框架",
			SL_CONFIG_LOCKFRAME_TT = "鎖定任務故事情節框架，避免不小心移動。",
			SL_CONFIG_MISCELLANEOUS = "其他選項",
			SL_CONFIG_NEXT_ACTION = "下一步動作",
			SL_CONFIG_NPC_NAME = "NPC 名字",
			SL_CONFIG_QUEST_TITLE = "任務標題",
			SL_CONFIG_SAMPLE_TEXT = "暗影聚兮，黑鴉噬日。 天火盡兮，玄翼蔽空。吾雛吾民，歇兮憩兮；斯是殘陽，終有眠期。", -- Needs review
			SL_CONFIG_STYLING_OPTIONS = "樣式選項",
			SL_CONFIG_TEXTSPEED = "%.1fx",
			SL_CONFIG_TEXTSPEED_HIGH = "快速",
			SL_CONFIG_TEXTSPEED_INSTANT = "無動畫",
			SL_CONFIG_TEXTSPEED_TITLE = "文字動畫速度",
			SL_CONFIG_USE_KEYBOARD = "使用鍵盤快速鍵",
			SL_CONFIG_USE_KEYBOARD_TT = "使用鍵盤快速鍵導覽對話 (空白鍵往前，倒退鍵往後，按鍵 1 到 0 選擇對話內容)",
			SL_CONFIG_WELCOME = "感謝使用任務故事劇情 Storyline!",
			SL_CONTINUE = "完成任務",
			SL_DECLINE = "我拒絕。",
			SL_GET_REWARD = "取得你的獎勵",
			SL_NEXT = "繼續",
			SL_NOT_YET = "完成後再來",
			SL_RESET = "回顧內容",
			SL_RESET_TT = "回顧對話內容。",
			SL_RESIZE = "調整大小",
			SL_RESIZE_TT = "拖曳滑鼠來調整大小。",
			SL_REWARD_MORE = "還可以獲得",
			SL_REWARD_MORE_SUB = [=[
金錢: |cffffffff%s|r
經驗值: |cffffffff%s xp|r

|cffffff00點一下:|r 取得你的獎勵!]=],
			SL_SELECT_AVAILABLE_QUEST = "選擇任務",
			SL_SELECT_DIALOG_OPTION = "選擇對話內容",
			SL_SELECT_REWARD = "選擇你的獎勵",
			SL_STORYLINE = "任務故事情節",
			SL_WELL = "嗯哼...",
		}
	},]]

}

local error, tostring = error, tostring;

local LOCALS = Storyline_API.locale.info;
local DEFAULT_LOCALE = "enUS";
Storyline_API.locale.DEFAULT_LOCALE = DEFAULT_LOCALE;
local effectiveLocal = {};
local localeFont;
local current;

-- Initialize a locale for the addon.
function Storyline_API.locale.init()
	-- Register config

	current = Storyline_Data.config.locale or GetLocale();
	if not LOCALS[current] then
		current = DEFAULT_LOCALE;
	end
	-- Pick the right font
	if current == "zhCN" then
		localeFont = "Fonts\\ARKai_T.TTF";
	elseif current == "zhTW" then
		localeFont = "Fonts\\bLEI00D.TTF";
	elseif current == "ruRU" then
		localeFont = "Fonts\\FRIZQT___CYR.TTF";
	else
		localeFont = "Fonts\\FRIZQT__.TTF";
	end
	effectiveLocal = LOCALS[current].localeContent;

	Storyline_Data.config.locale = current;
	Storyline_API.locale.localeFont = localeFont;
end

--	Return the localized text link to this key.
--	If the key isn't present in the current Locals table, then return the default localization.
--	If the key is totally unknown from TRP3, then an error will be lifted.
local function getText(key)
	if effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key] then
		return effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key];
	end
	error("Unknown localization key: ".. tostring(key));
end
Storyline_API.locale.getText = getText;

function Storyline_API.locale.getLocales()
	return Storyline_API.locale.info;
end