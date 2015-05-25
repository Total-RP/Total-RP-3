----------------------------------------------------------------------------------
-- Total RP 3
-- Russian locale
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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
	locale = "ruRU",
	localeText = "Russian",
	localeContent = {
		ABOUT_TITLE = [=[О персонаже
]=],
		BINDING_NAME_TRP3_TOGGLE = "Показать/спрятать главное окно",
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Показать/спрятать панель инструментов",
		BW_COLOR_CODE = "Код цвета",
		BW_COLOR_CODE_ALERT = "Некорректный 16-ричный код!", -- Needs review
		BW_COLOR_CODE_TT = "Здесь можно вставить 6 цифр 16-ричного цветового кода и нажать Enter.", -- Needs review
		CM_ACTIONS = "Опции",
		CM_APPLY = "Применить",
		CM_CANCEL = "Отмена",
		CM_CENTER = "Центр",
		CM_CLASS_DEATHKNIGHT = "Рыцарь Смерти",
		CM_CLASS_DRUID = "Друид",
		CM_CLASS_HUNTER = "Охотник",
		CM_CLASS_MAGE = "Маг",
		CM_CLASS_MONK = "Монах",
		CM_CLASS_PALADIN = "Паладин",
		CM_CLASS_PRIEST = "Жрец",
		CM_CLASS_ROGUE = "Разбойник",
		CM_CLASS_SHAMAN = "Шаман",
		CM_CLASS_UNKNOWN = "Неизвестно",
		CM_CLASS_WARLOCK = "Чернокнижник",
		CM_CLASS_WARRIOR = "Воин",
		CM_CLICK = "Щелчок", -- Needs review
		CM_COLOR = "Цвет",
		CM_CTRL = "Ctrl",
		CM_DRAGDROP = "Перетащить",
		CM_EDIT = "Редактировать",
		CM_IC = "В роли",
		CM_ICON = "Иконка",
		CM_IMAGE = "Изображение",
		CM_L_CLICK = "ЛКМ",
		CM_LEFT = "Влево", -- Needs review
		CM_LINK = "Ссылка",
		CM_LOAD = "Загрузить",
		CM_MOVE_DOWN = "Сдвинуть вниз", -- Needs review
		CM_MOVE_UP = "Сдвинуть вверх", -- Needs review
		CM_NAME = "Имя",
		CM_OOC = "Вне роли",
		CM_OPEN = "Открыть",
		CM_PLAY = "Играть", -- Needs review
		CM_R_CLICK = "ПКМ",
		CM_REMOVE = "Убрать",
		CM_RIGHT = "Вправо", -- Needs review
		CM_SAVE = "Сохранить", -- Needs review
		CM_SELECT = "Выбрать", -- Needs review
		CM_SHIFT = "Shift", -- Needs review
		CM_SHOW = "Показать", -- Needs review
		CM_STOP = "Стоп", -- Needs review
		CM_UNKNOWN = "Неизвестно", -- Needs review
		CM_VALUE = "Значение", -- Needs review
		CO_ANCHOR_BOTTOM = "Внизу", -- Needs review
		CO_ANCHOR_BOTTOM_LEFT = "Внизу слева", -- Needs review
		CO_ANCHOR_BOTTOM_RIGHT = "Внизу справа", -- Needs review
		CO_ANCHOR_LEFT = "Слева", -- Needs review
		CO_ANCHOR_RIGHT = "Справа", -- Needs review
		CO_ANCHOR_TOP = "Вверху", -- Needs review
		CO_ANCHOR_TOP_LEFT = "Слева вверху", -- Needs review
		CO_ANCHOR_TOP_RIGHT = "Справа вверху", -- Needs review
		CO_CHAT = "Настройки чата", -- Needs review
		CO_CHAT_MAIN = "Основные настройки чата", -- Needs review
		CO_CHAT_MAIN_COLOR = "Использовать особые цвета имен", -- Needs review
		CO_CHAT_MAIN_EMOTE = "Обнаружение эмоций", -- Needs review
		CO_CHAT_MAIN_EMOTE_PATTERN = "Шаблон обнаружения эмоций", -- Needs review
		CO_CHAT_MAIN_EMOTE_USE = "Использовать обнаружение эмоций", -- Needs review
		CO_CHAT_MAIN_EMOTE_YELL = "Не /кричатьэмоции", -- Needs review
		CO_CHAT_MAIN_EMOTE_YELL_TT = "Не показывать *эмоция* или <эмоция> в канале /крик", -- Needs review
		CO_CHAT_MAIN_NAMING = "Метод именования", -- Needs review
		CO_CHAT_MAIN_NAMING_1 = "Оставить первоначальные имена", -- Needs review
		CO_CHAT_MAIN_NAMING_2 = "Использовать свои имена", -- Needs review
		CO_CHAT_MAIN_NAMING_3 = "Имя + Фамилия", -- Needs review
		CO_CHAT_MAIN_NPC = "Обнаружение разговоров НИПов", -- Needs review
		CO_CHAT_MAIN_NPC_PREFIX = "Шаблон обнаружения разговоров НИПов", -- Needs review
		CO_CHAT_MAIN_NPC_PREFIX_TT = [=[Если фраза в чате с этим префиксом будет сказана в каналах /сказать, /эмоция, /группа или /рейд, она будет распознана как фраза НИПа.

|cff00ff00By default : "|| "
(без кавычек" и с пробелом после разделительной линии)]=], -- Needs review
		CO_CHAT_MAIN_NPC_USE = "Использовать обнаружение разговора НИПов.", -- Needs review
		CO_CHAT_MAIN_OOC = "Обнаружение персонажей вне отыгрыша", -- Needs review
		CO_CHAT_MAIN_OOC_COLOR = "Цвет \"вне отыгрыша\"", -- Needs review
		CO_CHAT_MAIN_OOC_PATTERN = "Шаблон обнаружения \"вне отыгрыша\"", -- Needs review
		CO_CHAT_MAIN_OOC_USE = "Использовать обнаружение \"вне отыгрыша\"", -- Needs review
		CO_CHAT_USE = "Используемые каналы чата", -- Needs review
		CO_CHAT_USE_SAY = "Канал /сказать", -- Needs review
		CO_CONFIGURATION = "Настройки", -- Needs review
		CO_GENERAL = "Основные настройки", -- Needs review
		CO_GENERAL_BROADCAST = "Использовать общий канал чата", -- Needs review
		CO_GENERAL_BROADCAST_C = "Название общего канала чата", -- Needs review
		CO_GENERAL_BROADCAST_TT = "Общий канал чата нужен для многих вещей. Отключив его, вы отключите такие опции как нахождение на карте, локальные звуки, тайники и доступ к указателям...", -- Needs review
		CO_GENERAL_CHANGELOCALE_ALERT = [=[Пегрегрузите интерфейс, чтобы изменить язык на %s прямо сейчас.

Или язык будет изменен при следующем входе в игру.]=], -- Needs review
		CO_GENERAL_COM = "Общение", -- Needs review
		CO_GENERAL_HEAVY = "Предупреждение о перегруженном профиле", -- Needs review
		CO_GENERAL_HEAVY_TT = "Оповестить, когда общий размер вашего профиля превысит разумное значение", -- Needs review
		CO_GENERAL_LOCALE = "Язык аддона", -- Needs review
		CO_GENERAL_MISC = "Разное", -- Needs review
		CO_GENERAL_NEW_VERSION = "Оповещение об обновлениях", -- Needs review
		CO_GENERAL_NEW_VERSION_TT = "Оповестить, когда будет доступна новая версия аддона.", -- Needs review
		CO_GENERAL_TT_SIZE = "Размер текста подсказок", -- Needs review
		CO_GENERAL_UI_ANIMATIONS = "Анимация интерфейса", -- Needs review
		CO_GENERAL_UI_ANIMATIONS_TT = "Включить анимацию интерфейса.", -- Needs review
		CO_GENERAL_UI_SOUNDS = "Звуки интерфейса", -- Needs review
		CO_GENERAL_UI_SOUNDS_TT = "Включить звуки интерфейса (при открытии окон, переключении вкладок, нажатии кнопок).", -- Needs review
		CO_GLANCE_LOCK = "Закрепить панель", -- Needs review
		CO_GLANCE_LOCK_TT = "Запрещает перетаскивание панели", -- Needs review
		CO_GLANCE_MAIN = "Панель \"На первый взгляд\"", -- Needs review
		CO_GLANCE_PRESET_TRP2 = "Использовать позиционирование в стиле Total RP 2", -- Needs review
		CO_GLANCE_PRESET_TRP2_BUTTON = "Использовать", -- Needs review
		CO_GLANCE_PRESET_TRP2_HELP = "Ярлык для установки панели в стиле TRP2: справа от рамки цели WoW.", -- Needs review
		CO_GLANCE_PRESET_TRP3 = "Использовать позиционирование в стиле Total RP 3", -- Needs review
		CO_GLANCE_PRESET_TRP3_HELP = "Ярлык для установки панели в стиле TRP3: снизу от рамки цели TRP3.", -- Needs review
		CO_GLANCE_RESET_TT = "Сбросить позиционирование панели вниз влево от закрепленной рамки.", -- Needs review
		CO_GLANCE_TT_ANCHOR = "Точка закрепления подсказок", -- Needs review
		CO_MINIMAP_BUTTON = "Кнопка у миникарты", -- Needs review
		CO_MINIMAP_BUTTON_FRAME = "Рамка для закрепления", -- Needs review
		CO_MINIMAP_BUTTON_RESET = "Сбросить позицию", -- Needs review
		CO_MINIMAP_BUTTON_RESET_BUTTON = "Сбросить", -- Needs review
		COM_LIST = "Список команд", -- Needs review
		CO_MODULES = "Статус модулей", -- Needs review
		CO_MODULES_DISABLE = "Отключить модуль", -- Needs review
		CO_MODULES_ENABLE = "Включить модуль", -- Needs review
		CO_MODULES_ID = "ID модуля: %s", -- Needs review
		CO_MODULES_SHOWERROR = "Показать ошибку", -- Needs review
		CO_MODULES_STATUS = "Статус: %s", -- Needs review
		CO_MODULES_STATUS_0 = "Недостающие зависимости", -- Needs review
		CO_MODULES_STATUS_1 = "Загружен", -- Needs review
		CO_MODULES_STATUS_2 = "Отключен", -- Needs review
		CO_MODULES_STATUS_3 = "Total RP 3 требуется обновление", -- Needs review
		CO_MODULES_STATUS_4 = "Ошибка инициализации", -- Needs review
		CO_MODULES_STATUS_5 = "Ошибка запуска", -- Needs review
		CO_MODULES_TT_DEP = [=[
%s- %s (версия %s)|r]=], -- Needs review
		CO_MODULES_TT_DEPS = "Зависимости", -- Needs review
		CO_MODULES_TT_ERROR = [=[

|cffff0000Ошибка:|r
%s]=], -- Needs review
		CO_MODULES_TT_NONE = "Нет зависимостей", -- Needs review
		CO_MODULES_TT_TRP = "%sДля Total RP 3 версии %s и выше.|r", -- Needs review
		CO_MODULES_TUTO = [=[Модуль — независимая опция, которую можно включить или отключить.

Возможные статусы:
|cff00ff00Загружен:|r Модуль включен и загружен.
|cff999999Отключен:|r Модуль отключен.
|cffff9900Недостающие зависимости:|r Некоторые зависимости не загружены.
|cffff9900TRP требуется обновление:|r Модулю требуется последняя версия TRP3.
|cffff0000Ошибка инициализации или запуска:|r Порядок загрузки модуля нарушен. Модуль будет создавать ошибки!

|cffff9900При отключении модуля необходимо перегрузить интерфейс.]=], -- Needs review
		CO_MODULES_VERSION = "Версия: %s", -- Needs review
		COM_RESET_RESET = "Расположение окон сброшено!", -- Needs review
		COM_RESET_USAGE = "Использование: |cff00ff00/trp3 сброс фреймов|r сбросить расположение окон.", -- Needs review
		CO_MSP = "Мэри Сью Протокол", -- Needs review
		CO_MSP_T3 = "Использовать только шаблон 3", -- Needs review
		CO_MSP_T3_TT = "Шаблон 3 всегда будет использоваться для совместимости с МСП, даже если вы выберите другой шаблон \"Описание\".", -- Needs review
		COM_SWITCH_USAGE = "Использование: |cff00ff00/trp3 вкл/выкл главное окно|r чтобы показать/скрыть главное окно или |cff00ff00/trp3 вкл/выкл панель инструментов|r чтобы показать/скрыть панель инструментов", -- Needs review
		CO_REGISTER = "Настройки реестра", -- Needs review
		CO_REGISTER_ABOUT_VOTE = "Использовать систему голосования", -- Needs review
		CO_REGISTER_ABOUT_VOTE_TT = "Включает систему голосования, позволяя голосовать (\"нравится\" или \"не нравится\") за описания других игроков и позволяя им делать то же самое для вас.", -- Needs review
		CO_REGISTER_AUTO_ADD = "Автоматически добавлять новых игроков", -- Needs review
		CO_REGISTER_AUTO_ADD_TT = "Автоматически добавлять новых игроков из реестра.", -- Needs review
		CO_TARGETFRAME = "Настройки рамки цели", -- Needs review
		CO_TARGETFRAME_ICON_SIZE = "Размер иконок", -- Needs review
		CO_TARGETFRAME_USE = "Показать условия", -- Needs review
		CO_TARGETFRAME_USE_1 = "Всегда", -- Needs review
		CO_TARGETFRAME_USE_2 = "Только когда \"отыгрываю\"", -- Needs review
		CO_TARGETFRAME_USE_3 = "Никогда (Отключено)", -- Needs review
		CO_TARGETFRAME_USE_TT = "Определяет при каких условиях будет показана рамка цели при выборе цели.", -- Needs review
		CO_TOOLBAR = "Настройки рамок", -- Needs review
		CO_TOOLBAR_CONTENT = "Настройки панели инструментов", -- Needs review
		CO_TOOLBAR_CONTENT_CAPE = "Смена отображения плаща", -- Needs review
		CO_TOOLBAR_CONTENT_HELMET = "Смена отображения шлема", -- Needs review
		CO_TOOLBAR_CONTENT_RPSTATUS = "Статус персонажа (Отыгрываю/Не отыгрываю)", -- Needs review
		CO_TOOLBAR_CONTENT_STATUS = "Статус игрока (Отсутствует/Не беспокоить)", -- Needs review
		CO_TOOLBAR_ICON_SIZE = "Размер иконок", -- Needs review
		CO_TOOLBAR_MAX = "Максимум иконок в строке", -- Needs review
		CO_TOOLBAR_MAX_TT = "Чтобы панель отображалась вертикально, задайте значение 1!", -- Needs review
		CO_TOOLTIP = "Настройки подсказок", -- Needs review
		CO_TOOLTIP_ANCHOR = "Точка закрепления", -- Needs review
		CO_TOOLTIP_ANCHORED = "Закрепленная рамка", -- Needs review
		CO_TOOLTIP_CHARACTER = "Подсказки персонажей", -- Needs review
		CO_TOOLTIP_CLIENT = "Показать клиент", -- Needs review
		CO_TOOLTIP_COMBAT = "Прятать в бою", -- Needs review
		CO_TOOLTIP_COMMON = "Общие настройки", -- Needs review
		CO_TOOLTIP_CURRENT = "Показывать текст \"текущее\"", -- Needs review
		CO_TOOLTIP_CURRENT_SIZE = "Максимальная длина текста \"текущее\"", -- Needs review
		CO_TOOLTIP_FT = "Показывать полный титул", -- Needs review
		CO_TOOLTIP_GUILD = "Показывать информацию о гильдии", -- Needs review
		CO_TOOLTIP_HIDE_ORIGINAL = "Скрывать подсказки игры", -- Needs review
		CO_TOOLTIP_ICONS = "Показывать иконки", -- Needs review
		CO_TOOLTIP_MAINSIZE = "Размер основного шрифта", -- Needs review
		CO_TOOLTIP_NOTIF = "Показывать уведомления", -- Needs review
		CO_TOOLTIP_NOTIF_TT = "Строка уведомлений — строка, содержащая версию клиента, метку непрочитанного описания и метку \"На первый взгляд\".", -- Needs review
		CO_TOOLTIP_OWNER = "Показать владельца", -- Needs review
		CO_TOOLTIP_PETS = "Подсказки спутников", -- Needs review
		CO_TOOLTIP_PETS_INFO = "Показать информацию о спутнике", -- Needs review
		CO_TOOLTIP_PROFILE_ONLY = "Использовать, только если у цели есть профиль", -- Needs review
		CO_TOOLTIP_RACE = "Показать расу, класс и уровень", -- Needs review
		CO_TOOLTIP_REALM = "Показать игровой мир", -- Needs review
		CO_TOOLTIP_RELATION = "Показывать цвет отношений", -- Needs review
		CO_TOOLTIP_RELATION_TT = "Окрасить рамку подсказки персонажа в цвет, характеризующий отношение.", -- Needs review
		CO_TOOLTIP_SPACING = "Показывать интервалы", -- Needs review
		CO_TOOLTIP_SPACING_TT = "Располагает интервалы для облегчения подсказки, в стиле MyRolePlay.", -- Needs review
		CO_TOOLTIP_SUBSIZE = "Размер вторичного шрифта", -- Needs review
		CO_TOOLTIP_TARGET = "Показать цель", -- Needs review
		CO_TOOLTIP_TERSIZE = "Размер третичного шрифта", -- Needs review
		CO_TOOLTIP_TITLE = "Показывать заголовок", -- Needs review
		CO_TOOLTIP_USE = "Использовать подсказку персонажей/спутников", -- Needs review
		CO_WIM = "|cffff9900Каналы шепота отключены.", -- Needs review
		CO_WIM_TT = "Вы используете мод |cff00ff00WIM|r, для совместимости отключена обработка каналов шепота отключена.", -- Needs review
		DB_STATUS = "Статус", -- Needs review
		DB_STATUS_CURRENTLY = "Текущее (Отыгрываю)", -- Needs review
		DB_STATUS_CURRENTLY_COMMON = "Эти статусы будут показаны в подсказке вашего персонажа. Делайте их краткими, так как |cffff9900by по умолчанию игроки с TRP3 будут видеть только первые 140 символов", -- Needs review
		DB_STATUS_CURRENTLY_OOC = "Другая информация (Вне отыгрыша)", -- Needs review
		DB_STATUS_CURRENTLY_OOC_TT = "Здесь вы можете указать что-то важное о вас, как игроке, или что-нибудь еще вне отыгрыша.", -- Needs review
		DB_STATUS_CURRENTLY_TT = "Здесь вы можете указать что-нибудь важное о вашем персонаже.", -- Needs review
		DB_STATUS_RP = "Статус персонажа", -- Needs review
		DB_STATUS_RP_EXP = "Опытный ролевик", -- Needs review
		DB_STATUS_RP_EXP_TT = [=[Показывает, что вы опытный ролевик.
Не добавляет никаких специальных иконок в вашу подсказку.]=], -- Needs review
		DB_STATUS_RP_IC = "В роли", -- Needs review
		DB_STATUS_RP_IC_TT = [=[Это значит, что сейчас вы отыгрываете своего персонажа.
Все ваши действия рассматриваются как выполненные вашим персонажем.]=], -- Needs review
		DB_STATUS_RP_OOC = "Вне роли", -- Needs review
		DB_STATUS_RP_OOC_TT = [=[Вы вне роли.
Ваши действия не могут быть связаны с вашим персонажем.]=], -- Needs review
		DB_STATUS_RP_VOLUNTEER = "Волонтер", -- Needs review
		DB_STATUS_RP_VOLUNTEER_TT = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая ролевикам-новичкам, что Вы хотите помочь им.", -- Needs review
		DB_STATUS_XP = "Статус ролевика", -- Needs review
		DB_STATUS_XP_BEGINNER = "Новичок", -- Needs review
		DB_STATUS_XP_BEGINNER_TT = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая остальным ролевикам, что Вы - новичок.", -- Needs review
		GEN_VERSION = "Версия: %s (Сборка %s)", -- Needs review
		GEN_WELCOME_MESSAGE = "Спасибо за выбор Total RP3 (v %s)! Приятной игры!",
		PR_CO_MASTERS = "Хозяева", -- Needs review
		PR_CO_PET = "Питомец", -- Needs review
		PR_PROFILE_CREATED = "Профиль \"%s\" создан.", -- Needs review
		PR_PROFILE_DELETED = "Профиль \"%s\" удален.", -- Needs review
		PR_PROFILE_DETAIL = "Этот профиль на данный момент привязан к следующим персонажам WoW", -- Needs review
		PR_UNUSED_PROFILE = "Этот профиль на данный момент не привязан к какому-либо персонажу WoW.", -- Needs review
		REG_COMPANION = "Спутник", -- Needs review
		REG_COMPANION_INFO = "Информация", -- Needs review
		REG_COMPANION_NAME = "Имя", -- Needs review
		REG_COMPANION_NAME_COLOR = "Цвет имени", -- Needs review
		REG_COMPANION_PROFILES = "Профили спутников", -- Needs review
		REG_COMPANIONS = "Спутники", -- Needs review
		REG_COMPANION_TF_BOUND_TO = "Выбрать профиль", -- Needs review
		REG_COMPANION_TF_CREATE = "Создать новый профиль", -- Needs review
		REG_COMPANION_TF_NO = "Нет профиля", -- Needs review
		REG_COMPANION_TF_OPEN = "Открыть страницу", -- Needs review
		REG_COMPANION_TF_PROFILE = "Профиль спутника", -- Needs review
		REG_COMPANION_TF_PROFILE_MOUNT = "Профиль ездового животного", -- Needs review
		REG_COMPANION_TITLE = "Название", -- Needs review
		REG_DELETE_WARNING = [=[Вы уверены, что хотите удалить профиль "%s"?
]=], -- Needs review
		REG_IGNORE_TOAST = "Персонаж игнорируется", -- Needs review
		REG_LIST_ACTIONS_MASS_IGNORE = "Игнорировать профили", -- Needs review
		REG_LIST_ACTIONS_MASS_REMOVE = "Удалить профили", -- Needs review
		REG_LIST_ACTIONS_MASS_REMOVE_C = "Это действие удалит |cff00ff00%s выбранный(е) профиль(и)|r.", -- Needs review
		REG_LIST_PET_MASTER = "Имя хозяина", -- Needs review
		REG_LIST_PET_NAME = "Имя спутника", -- Needs review
		REG_LIST_PETS_EMPTY = "Нет спутника", -- Needs review
		REG_LIST_PETS_EMPTY2 = "Ни один спутник не подходит под ваш выбор", -- Needs review
		REG_LIST_PETS_FILTER = "Спутники: %s / %s", -- Needs review
		REG_LIST_PETS_TITLE = "Список спутников", -- Needs review
		REG_LIST_PET_TYPE = "Тип спутника", -- Needs review
		REG_PLAYER = "Персонаж", -- Needs review
		REG_PLAYER_ABOUT = "О персонаже", -- Needs review
		REG_PLAYER_ABOUT_ADD_FRAME = "Добавить окно", -- Needs review
		REG_PLAYER_ABOUT_EMPTY = "Нет описания", -- Needs review
		REG_PLAYER_ABOUTS = "О %s", -- Needs review
		REG_PLAYER_CLASS = "Класс", -- Needs review
		REG_PLAYER_CLASS_TT = [=[Это нестандартный класс вашего персонажа.

|cff00ff00Например:|r
Рыцарь, Пиротехник, Некромант, Элитный стрелок, Чародей, ...]=], -- Needs review
		REG_PLAYER_COLOR_CLASS = "Цвет класса", -- Needs review
		REG_PLAYER_COLOR_TT = [=[|cffffff00ЛКМ:|r Выбрать цвет
|cffffff00ПКМ:|r Сбросить цвет]=], -- Needs review
		REG_PLAYER_EYE = "Цвет глаз", -- Needs review
		REG_PLAYER_GLANCE_PRESET = "Загрузить заготовку", -- Needs review
		REG_PLAYER_GLANCE_PRESET_ALERT1 = "Пожалуйста, введите категорию и название", -- Needs review
		REG_PLAYER_GLANCE_PRESET_CATEGORY = "Категория заготовки", -- Needs review
		REG_PLAYER_GLANCE_PRESET_NAME = "Название заготовки", -- Needs review
		REG_PLAYER_GLANCE_PRESET_SAVE = "Сохранить информацию как заготовку", -- Needs review
		REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Сохранить как заготовку", -- Needs review
		REG_PLAYER_GLANCE_PRESET_SELECT = "Выбрать заготовку", -- Needs review
		REG_PLAYER_MSP_NICK = "Ник", -- Needs review
		REG_PLAYER_NAMESTITLES = "Имена и названия", -- Needs review
		REG_PLAYER_NO_CHAR = "Нет характеристик", -- Needs review
		REG_PLAYER_PEEK = "Разное", -- Needs review
		REG_PLAYER_PHYSICAL = "Физические характеристики", -- Needs review
		REG_PLAYER_RACE = "Раса", -- Needs review
		REG_PLAYER_STYLE_FREQ_1 = "Всегда в роли", -- Needs review
		REG_PLAYER_STYLE_FREQ_5 = "Всегда вне роли, этот персонаж не для отыгрыша", -- Needs review
		REG_PLAYER_STYLE_GUILD = "Членство в гильдии", -- Needs review
		REG_PLAYER_TRP2_PIERCING = "Пирсинг", -- Needs review
		REG_PLAYER_TRP2_TATTOO = "Татуировки", -- Needs review
		REG_PLAYER_TRP2_TRAITS = "Облик", -- Needs review
		TB_SWITCH_HELM_1 = "Отображать шлем", -- Needs review
		TB_SWITCH_HELM_2 = "Скрыть шлем", -- Needs review
		TB_SWITCH_HELM_OFF = "Шлем: |cffff0000Скрыт", -- Needs review
		TB_SWITCH_HELM_ON = "Шлем: |cffff0000Показан", -- Needs review
		TF_OPEN_COMPANION = "Показать страницу спутника", -- Needs review
		UI_COLOR_BROWSER_SELECT = "Выбрать цвет", -- Needs review
		UI_FILTER = "Фильтер", -- Needs review
		UI_ICON_BROWSER_HELP = "Скопировать иконку", -- Needs review
		UI_ICON_SELECT = "Выбрать иконку", -- Needs review
		UI_IMAGE_BROWSER = "Обозреватель изображений", -- Needs review
		UI_IMAGE_SELECT = "Выбрать изображение", -- Needs review
		UI_LINK_TEXT = "Введите текст", -- Needs review
		UI_LINK_URL = "http://адрес_вашего_сайта", -- Needs review
		UI_MUSIC_BROWSER = "Обозреватель музыки", -- Needs review
		UI_MUSIC_SELECT = "Выбрать музыку", -- Needs review
		UI_TUTO_BUTTON = "Обучающий режим", -- Needs review
		UI_TUTO_BUTTON_TT = "Нажмите, чтобы включить/выключить режим обучения", -- Needs review
	}
};

TRP3_API.locale.registerLocale(LOCALE);