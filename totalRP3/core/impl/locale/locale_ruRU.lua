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
        BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Отображение панели инструментов", -- Needs review
        BW_COLOR_CODE = "Цветовой код", -- Needs review
        BW_COLOR_CODE_ALERT = "Некорректный 16-ричный код!",
        BW_COLOR_CODE_TT = "Здесь можно вставить 6 цифр 16-ричного цветового кода и нажать Enter.",
        CM_ACTIONS = "Действия", -- Needs review
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
        CM_IC = "IC (в роли)", -- Needs review
        CM_ICON = "Иконка",
        CM_IMAGE = "Изображение",
        CM_L_CLICK = "ЛКМ",
        CM_LEFT = "Влево", -- Needs review
        CM_LINK = "Ссылка",
        CM_LOAD = "Загрузить",
        CM_MOVE_DOWN = "Сдвинуть вниз", -- Needs review
        CM_MOVE_UP = "Сдвинуть вверх", -- Needs review
        CM_NAME = "Имя",
        CM_OOC = "OOC (вне роли)", -- Needs review
        CM_OPEN = "Открыть",
        CM_PLAY = "Играть", -- Needs review
        CM_R_CLICK = "ПКМ",
        CM_REMOVE = "Убрать",
        CM_RESIZE_TT = "Потяните для изменения размера окна", -- Needs review
        CM_RIGHT = "Вправо", -- Needs review
        CM_SAVE = "Сохранить", -- Needs review
        CM_SELECT = "Выбрать", -- Needs review
        CM_SHIFT = "Shift", -- Needs review
        CM_SHOW = "Показать", -- Needs review
        CM_STOP = "Стоп", -- Needs review
        CM_TWEET = "Отправить твит", -- Needs review
        CM_TWEET_PROFILE = "Показать ссылку профиля", -- Needs review
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
        CO_CHAT_MAIN_EMOTE_YELL = "Скрыть эмоции /крик", -- Needs review
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
        CO_GENERAL = "Основное", -- Needs review
        CO_GENERAL_BROADCAST = "Использовать общий канал чата", -- Needs review
        CO_GENERAL_BROADCAST_C = "Название общего канала чата", -- Needs review
        CO_GENERAL_BROADCAST_TT = "Общий канал чата нужен для многих вещей. Отключив его, вы отключите такие опции как нахождение на карте, локальные звуки, тайники и доступ к указателям...", -- Needs review
        CO_GENERAL_CHANGELOCALE_ALERT = [=[Для смены языка на %s необходимо перезагрузить интерфейс.

В случае отказа язык будет изменен при следующем входе в игру.]=], -- Needs review
        CO_GENERAL_COM = "Общение", -- Needs review
        CO_GENERAL_HEAVY = "Предупреждать о перегруженном профиле", -- Needs review
        CO_GENERAL_HEAVY_TT = "Оповестить, когда общий объем вашего профиля превысит разумное значение.", -- Needs review
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
        CO_GLANCE_LOCK_TT = "Запретить перемещение панели", -- Needs review
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
        CO_MODULES_STATUS_0 = "Отключены зависимости", -- Needs review
        CO_MODULES_STATUS_1 = "Загружен", -- Needs review
        CO_MODULES_STATUS_2 = "Отключен", -- Needs review
        CO_MODULES_STATUS_3 = "Требуется обновить Total RP 3", -- Needs review
        CO_MODULES_STATUS_4 = "Ошибка инициализации", -- Needs review
        CO_MODULES_STATUS_5 = "Ошибка запуска", -- Needs review
        CO_MODULES_TT_DEP = "%s- %s (версия %s)|r", -- Needs review
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
|cffff9900Отключены зависимости:|r Некоторые зависимости не загружены.
|cffff9900TRP требуется обновление:|r Модулю требуется последняя версия TRP3.
|cffff0000Ошибка инициализации или запуска:|r Порядок загрузки модуля нарушен. Модуль может создавать ошибки!

|cffff9900При отключении модуля необходима перегрузка интерфейса.]=], -- Needs review
        CO_MODULES_VERSION = "Версия: %s", -- Needs review
        COM_RESET_RESET = "Расположение окон сброшено!", -- Needs review
        COM_RESET_USAGE = "Использование: |cff00ff00/trp3 сброс фреймов|r сбросить расположение окон.", -- Needs review
        CO_MSP = "Протокол Mary Sue", -- Needs review
        CO_MSP_T3 = "Использовать только шаблон 3", -- Needs review
        CO_MSP_T3_TT = "Шаблон 3 всегда будет использоваться для совместимости с протоколом, даже если вы выберите другой шаблон \"Описание\".", -- Needs review
        COM_SWITCH_USAGE = "Использование: |cff00ff00/trp3 вкл/выкл главное окно|r чтобы показать/скрыть главное окно или |cff00ff00/trp3 вкл/выкл панель инструментов|r чтобы показать/скрыть панель инструментов", -- Needs review
        CO_REGISTER = "Настройки реестра", -- Needs review
        CO_REGISTER_ABOUT_VOTE = "Использовать систему голосования", -- Needs review
        CO_REGISTER_ABOUT_VOTE_TT = "Включает систему голосования, которая позволяет оценивать (\"нравится\" или \"не нравится\") описания других игроков и разрешает оценивать ваше описание другим.", -- Needs review
        CO_REGISTER_AUTO_ADD = "Автоматически добавлять новых игроков", -- Needs review
        CO_REGISTER_AUTO_ADD_TT = "Автоматически добавлять новых игроков в реестр.", -- Needs review
        CO_TARGETFRAME = "Настройки рамки цели", -- Needs review
        CO_TARGETFRAME_ICON_SIZE = "Размер иконок", -- Needs review
        CO_TARGETFRAME_USE = "Показать условия", -- Needs review
        CO_TARGETFRAME_USE_1 = "Всегда", -- Needs review
        CO_TARGETFRAME_USE_2 = "Только когда \"в отыгрыше\"", -- Needs review
        CO_TARGETFRAME_USE_3 = "Никогда (Отключено)", -- Needs review
        CO_TARGETFRAME_USE_TT = "Определяет при каких условиях будет показана рамка цели при выборе цели.", -- Needs review
        CO_TOOLBAR = "Настройки рамок", -- Needs review
        CO_TOOLBAR_CONTENT = "Настройки панели инструментов", -- Needs review
        CO_TOOLBAR_CONTENT_CAPE = "Отображение плаща", -- Needs review
        CO_TOOLBAR_CONTENT_HELMET = "Отображение шлема", -- Needs review
        CO_TOOLBAR_CONTENT_RPSTATUS = "Статус персонажа (Отыгрываю/Не отыгрываю)", -- Needs review
        CO_TOOLBAR_CONTENT_STATUS = "Статус игрока (Отсутствует/Не беспокоить)", -- Needs review
        CO_TOOLBAR_ICON_SIZE = "Размер иконок", -- Needs review
        CO_TOOLBAR_MAX = "Максимум иконок в строке", -- Needs review
        CO_TOOLBAR_MAX_TT = "Чтобы панель отображалась вертикально, задайте значение 1!", -- Needs review
        CO_TOOLTIP = "Настройки подсказок", -- Needs review
        CO_TOOLTIP_ANCHOR = "Точка закрепления", -- Needs review
        CO_TOOLTIP_ANCHORED = "Закрепленная рамка", -- Needs review
        CO_TOOLTIP_CHARACTER = "Описание персонажей", -- Needs review
        CO_TOOLTIP_CLIENT = "Показать клиент", -- Needs review
        CO_TOOLTIP_COMBAT = "Скрывать в бою", -- Needs review
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
        CO_TOOLTIP_RACE = "Показывать расу, класс и уровень", -- Needs review
        CO_TOOLTIP_REALM = "Показывать игровой мир", -- Needs review
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
        CO_WIM_TT = "Вы используете аддон |cff00ff00WIM|r, для совместимости отключена обработка каналов шепота отключена.", -- Needs review
        DB_MORE = "Больше дополнений", -- Needs review
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
        DB_STATUS_RP_IC = "Отыгрываю", -- Needs review
        DB_STATUS_RP_IC_TT = [=[Это значит, что сейчас вы отыгрываете своего персонажа.
Все ваши действия рассматриваются как выполненные вашим персонажем.]=], -- Needs review
        DB_STATUS_RP_OOC = "Вне отыгрыша", -- Needs review
        DB_STATUS_RP_OOC_TT = [=[Вы вне роли.
Ваши действия не могут быть связаны с вашим персонажем.]=], -- Needs review
        DB_STATUS_RP_VOLUNTEER = "Волонтер", -- Needs review
        DB_STATUS_RP_VOLUNTEER_TT = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая ролевикам-новичкам, что Вы хотите помочь им.", -- Needs review
        DB_STATUS_XP = "Статус ролевика", -- Needs review
        DB_STATUS_XP_BEGINNER = "Новичок", -- Needs review
        DB_STATUS_XP_BEGINNER_TT = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая остальным ролевикам, что Вы - новичок.", -- Needs review
        DB_TUTO_1 = [=[|cffffff00Статус персонажа|r отображает, находитесь ли Вы в данный момент в отыгрыше.

|cffffff00Статус персонажа|r позволяет указать Ваш опыт в ролевых играх: будь то новичок или ветеран, желающий помочь новобранцам.

|cff00ff00Эта информация будет указана в описании вашего персонажа.]=], -- Needs review
        GEN_NEW_VERSION_AVAILABLE = [=[Доступна новая версия Total RP 3.

|cffff0000Ваша версия: %s
|c0000ff00Новая версия: %s|r

|cffff9900Настоятельно рекомендуем обновить аддон.|r

Данное сообщение отображается каждый раз, при входе в игровой мир и может быть отключено в настройках.]=], -- Needs review
        GEN_VERSION = "Версия: %s (Сборка %s)", -- Needs review
        GEN_WELCOME_MESSAGE = "Благодарим за использование TotalRP3 (версии %s)! Приятной игры!", -- Needs review
        MAP_SCAN_CHAR = "Поиск персонажей", -- Needs review
        MAP_SCAN_CHAR_TITLE = "Персонажи", -- Needs review
        MM_SHOW_HIDE_MAIN = "Отображение основной рамки", -- Needs review
        MM_SHOW_HIDE_MOVE = "Переместить кнопку", -- Needs review
        MM_SHOW_HIDE_SHORTCUT = "Отображение панели инструментов", -- Needs review
        MORE_MODULES = "Истории - это дополнение, улучшающее оригинальную квестовую систему WoW путем изменения окна задания: добавления анимированных моделей персонажей, обновленного показа текста.", -- Needs review
        NPC_TALK_SAY_PATTERN = "говорит:", -- Needs review
        NPC_TALK_WHISPER_PATTERN = "шепчет:", -- Needs review
        NPC_TALK_YELL_PATTERN = "кричит:", -- Needs review
        PR_CO_BATTLE = "Боевой питомец", -- Needs review
        PR_CO_COUNT = "%s питомцев/средств передвижения привязано к данному профилю.", -- Needs review
        PR_CO_EMPTY = "Профиль спутника отсутствует", -- Needs review
        PR_CO_MASTERS = "Хозяева", -- Needs review
        PR_CO_NEW_PROFILE = "Профиль нового спутника", -- Needs review
        PR_CO_PET = "Питомец", -- Needs review
        PR_CO_PROFILE_DETAIL = "Данный профиль связан с", -- Needs review
        PR_CO_PROFILE_HELP = [=[Профиль содержит всю информацию о |cffffff00"питомце"|r как |cff00ff00персонаже отыгрыша|r.

Профиль спутника может быть привязан к:
- Боевому питомцу |cffff9900(только если он назван)|r
- Питомцу охотника
- Демону чернокнижника
- Элементалю мага
- Вурдалаку рыцаря смерти |cffff9900(см. ниже)|r

Как и профиль персонажа, |cff00ff00профиль спутника|r можно привязать к |cffffff00нескольким питомцам|r, |cffffff00питомца|r можно легко переключать между профилями.


|cffff9900Вурдалаки:|r Так как вурдалак получает новое имя при каждом призывании, Вам необходимо привязать профиль ко всем вариациям имени.]=], -- Needs review
        PR_CO_PROFILE_HELP2 = [=[Нажмите, чтобы создать новый профиль спутника.

|cff00ff00Чтобы привязать профиль к питомцу (демону/элементалю/вурдалаку), призовите его, выделите и привяжите к существующему профилю (или создайте новый профиль).|r]=], -- Needs review
        PR_CO_PROFILEMANAGER_DELETE_WARNING = [=[Вы уверены, что хотите удалить профиль спутника %s?
Данное действие нельзя отменить, вся информация TRP3, связанная с данным профилем будет удалена!]=], -- Needs review
        PR_CO_PROFILEMANAGER_DUPP_POPUP = [=[Введите название для нового профиля.
Название не может быть пустым.

Эта копия не изменит список питомцев/транспорта, привязанный к профилю %s.]=], -- Needs review
        PR_CO_PROFILEMANAGER_EDIT_POPUP = [=[Введите новое название для профиля %s.
Название не может быть пустым.

Изменение названия не изменит связей между профилем и питомцами/транспортом.]=], -- Needs review
        PR_CO_PROFILEMANAGER_TITLE = "Профили спутников", -- Needs review
        PR_CO_UNUSED_PROFILE = "К данному профилю не привязан ни один питомец или вид транспорта.", -- Needs review
        PR_CO_WARNING_RENAME = [=[|cffff0000Внимание:|r настоятельно рекомендуется сменить имя питомца перед тем, как привязывать его к профилю.

Link it anyway ?]=], -- Needs review
        PR_CREATE_PROFILE = "Создать профиль", -- Needs review
        PR_DELETE_PROFILE = "Удалить профиль", -- Needs review
        PR_DUPLICATE_PROFILE = "Копировать профиль", -- Needs review
        PR_IMPORT_CHAR_TAB = "Импорт персонажей", -- Needs review
        PR_IMPORT_EMPTY = "Нет импортируемых профилей", -- Needs review
        PR_IMPORT_IMPORT_ALL = "Импортировать все", -- Needs review
        PR_IMPORT_PETS_TAB = "Импортирование спутников", -- Needs review
        PR_IMPORT_WILL_BE_IMPORTED = "Будет импортировано", -- Needs review
        PR_PROFILE = "Профиль", -- Needs review
        PR_PROFILE_CREATED = "Профиль \"%s\" создан.", -- Needs review
        PR_PROFILE_DELETED = "Профиль \"%s\" удален.", -- Needs review
        PR_PROFILE_DETAIL = "Этот профиль на данный момент привязан к следующим персонажам WoW", -- Needs review
        PR_PROFILE_HELP = [=[Профиль содержит информацию о |cffffff00"персонаже"|r как о |cff00ff00персонаже отыгрыша|r.

Настоящий |cffffff00"персонаж WoW"|r может быть связан только с одним профилем одновременно, но в любой момент можно переключить его на другой.

Так же можно связать нескольких |cffffff00"персонажей WoW"|r к одному |cff00ff00профилю|r!]=], -- Needs review
        PR_PROFILE_LOADED = "Загружен профиль %s.", -- Needs review
        PR_PROFILEMANAGER_ACTIONS = "Действия", -- Needs review
        PR_PROFILEMANAGER_ALREADY_IN_USE = "Профиль %s недоступен.", -- Needs review
        PR_PROFILEMANAGER_COUNT = "%s персонаж(ей) WoW связаны с профилем.", -- Needs review
        PR_PROFILEMANAGER_CREATE_POPUP = [=[Введите название для нового профиля.
Название не может быть пустым.]=], -- Needs review
        PR_PROFILEMANAGER_CURRENT = "Текущий профиль", -- Needs review
        PR_PROFILEMANAGER_DELETE_WARNING = [=[Вы уверены, что хотите удалить профиль %s?
Данное действие невозможно отменить, вся информация TRP3, связанная с профилем (информация о персонаже, инвентарь, список заданий и др.) будет удалена!]=], -- Needs review
        PR_PROFILEMANAGER_DUPP_POPUP = [=[Введите название для нового профиля.
Название не может быть пустым.

Эта копия не изменит связи персонажа с профилем %s.]=], -- Needs review
        PR_PROFILEMANAGER_EDIT_POPUP = [=[Введите новое название профиля.
Название не может быть пустым.

Переименование профиля не изменит связей между профилем и персонажами.]=], -- Needs review
        PR_PROFILEMANAGER_RENAME = "Переименовать профиль", -- Needs review
        PR_PROFILEMANAGER_SWITCH = "Выбрать профиль", -- Needs review
        PR_PROFILEMANAGER_TITLE = "Профили персонажей", -- Needs review
        PR_PROFILES = "Профили", -- Needs review
        PR_UNUSED_PROFILE = "Этот профиль на данный момент не привязан к какому-либо персонажу WoW.", -- Needs review
        REG_COMPANION = "Спутник", -- Needs review
        REG_COMPANION_INFO = "Информация", -- Needs review
        REG_COMPANION_NAME = "Имя", -- Needs review
        REG_COMPANION_NAME_COLOR = "Цвет имени", -- Needs review
        REG_COMPANION_PAGE_TUTO_C_1 = "Совет", -- Needs review
        REG_COMPANION_PAGE_TUTO_E_1 = [=[Это |cff00ff00основная информация о вашем спутнике|r.

Эта информация будет отображаться |cffff9900в описании спутника|r.]=], -- Needs review
        REG_COMPANION_PAGE_TUTO_E_2 = [=[Это |cff00ff00описание вашего спутника|r.

Оно не связано с |cffff9900физическим описанием|r. Здесь можно описать |cffff9900историю|r спутника или его |cffff9900характер|r.

Описание можно настроить под себя различными способами.
Вы можете выбрать |cffffff00текстуру фона|r для описания. Доступны инструменты форматирования, такие как |cffffff00размер шрифта, цвет и выравнивание|r.
Эти инструменты позволяют так же вставить |cffffff00изображения, иконки или ссылки на сайты|r.]=], -- Needs review
        REG_COMPANION_PROFILES = "Профили спутников", -- Needs review
        REG_COMPANIONS = "Спутники", -- Needs review
        REG_COMPANION_TF_BOUND_TO = "Выбрать профиль", -- Needs review
        REG_COMPANION_TF_CREATE = "Создать новый профиль", -- Needs review
        REG_COMPANION_TF_NO = "Нет профиля", -- Needs review
        REG_COMPANION_TF_OPEN = "Открыть страницу", -- Needs review
        REG_COMPANION_TF_OWNER = "Владелец: %s", -- Needs review
        REG_COMPANION_TF_PROFILE = "Профиль спутника", -- Needs review
        REG_COMPANION_TF_PROFILE_MOUNT = "Профиль ездового животного", -- Needs review
        REG_COMPANION_TF_UNBOUND = "Отвязать от профиля", -- Needs review
        REG_COMPANION_TITLE = "Название", -- Needs review
        REG_DELETE_WARNING = [=[Вы уверены, что хотите удалить профиль "%s"?
]=], -- Needs review
        REG_IGNORE_TOAST = "Персонаж игнорируется", -- Needs review
        REG_LIST_ACTIONS_MASS = "Действие над %s выбранными профилями", -- Needs review
        REG_LIST_ACTIONS_MASS_IGNORE = "Игнорировать профили", -- Needs review
        REG_LIST_ACTIONS_MASS_IGNORE_C = [=[Данное действие добавит |cff00ff00%s персонажей|r в черный список.

Можете написать причину добавления ниже. Эту заметку сможете увидеть только Вы.]=], -- Needs review
        REG_LIST_ACTIONS_MASS_REMOVE = "Удалить профили", -- Needs review
        REG_LIST_ACTIONS_MASS_REMOVE_C = "Это действие удалит |cff00ff00%s выбранный(е) профиль(и)|r.", -- Needs review
        REG_LIST_ACTIONS_PURGE = "Очистить регистр", -- Needs review
        REG_LIST_ACTIONS_PURGE_ALL = "Удалить все профили", -- Needs review
        REG_LIST_ACTIONS_PURGE_ALL_C = [=[Очистка удалит все профили и связанных персонажей из директории.

|cff00ff00%s персонажей.]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_ALL_COMP_C = [=[Очистка удалит всех спутников из директории.

|cff00ff00%s спутников.]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_COUNT = "%s профилей будет удалено.", -- Needs review
        REG_LIST_ACTIONS_PURGE_EMPTY = "Нет профилей для удаления.", -- Needs review
        REG_LIST_ACTIONS_PURGE_IGNORE = "Профили персонажей из черного списка", -- Needs review
        REG_LIST_ACTIONS_PURGE_IGNORE_C = [=[Очистка удалит все профили, связанные с персонажами WoW из черного списка.

|cff00ff00%s]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_TIME = "Профиль не появлялся более месяца", -- Needs review
        REG_LIST_ACTIONS_PURGE_TIME_C = [=[Очистка удалит все профили, которые не появлялись больше месяца.

|cff00ff00%s]=], -- Needs review
        REG_LIST_ACTIONS_PURGE_UNLINKED = "Профиль не привязан к персонажу", -- Needs review
        REG_LIST_ACTIONS_PURGE_UNLINKED_C = [=[Очистка удалит все профили, не связанные с персонажами WoW.

|cff00ff00%s]=], -- Needs review
        REG_LIST_ADDON = "Тип профиля", -- Needs review
        REG_LIST_CHAR_EMPTY = "Нет персонажей", -- Needs review
        REG_LIST_CHAR_EMPTY2 = "Ни один персонаж не подходит под описание", -- Needs review
        REG_LIST_CHAR_FILTER = "Персонажей: %s / %s", -- Needs review
        REG_LIST_CHAR_IGNORED = "Черный список", -- Needs review
        REG_LIST_CHAR_SEL = "Выбранный персонаж", -- Needs review
        REG_LIST_CHAR_TITLE = "Список персонажей", -- Needs review
        REG_LIST_CHAR_TT = "Просмотреть страницу", -- Needs review
        REG_LIST_CHAR_TT_CHAR = "Связанные персонажи WoW:", -- Needs review
        REG_LIST_CHAR_TT_CHAR_NO = "Не привязан ни к одному персонажу", -- Needs review
        REG_LIST_CHAR_TT_DATE = [=[Последнее появление: |cff00ff00%s|r
Последняя локация: |cff00ff00%s|r]=], -- Needs review
        REG_LIST_CHAR_TT_GLANCE = "На первый взгляд", -- Needs review
        REG_LIST_CHAR_TT_IGNORE = "Черный список", -- Needs review
        REG_LIST_CHAR_TT_NEW_ABOUT = "Непрочитанное описание", -- Needs review
        REG_LIST_CHAR_TT_RELATION = [=[Отношение:
|cff00ff00%s]=], -- Needs review
        REG_LIST_CHAR_TUTO_ACTIONS = "Этот столбец позволяет выбрать несколько персонажей для проведения действий над всеми.", -- Needs review
        REG_LIST_CHAR_TUTO_FILTER = [=[Можно применять фильтры к списку персонажей.

|cff00ff00Фильтр имени|r производит поиск по полному имени (имя + фамилия), а так же по привязанным персонажам.

|cff00ff00Фильтр гильдий|r производит поиск по названию гильдии привязанных персонажей.

|cff00ff00Фильтр игровых миров|r отображает только профили связанных персонажей из вашего мира.]=], -- Needs review
        REG_LIST_CHAR_TUTO_LIST = [=[Первый столбец отображает имя персонажа.

Второй столбей отображает отношения между Вашим персонажем и прочими.

Последний столбец используется для различных меток (черный список и др.).]=], -- Needs review
        REG_LIST_FILTERS = "Фильтры", -- Needs review
        REG_LIST_FILTERS_TT = [=[|cffffff00ЛКМ:|r Применить фильтр
|cffffff00ПКМ:|r Сбросить фильтр]=], -- Needs review
        REG_LIST_FLAGS = "Метки", -- Needs review
        REG_LIST_GUILD = "Гильдия персонажа", -- Needs review
        REG_LIST_IGNORE_EMPTY = "Черный список пуст", -- Needs review
        REG_LIST_IGNORE_TITLE = "Черный список", -- Needs review
        REG_LIST_IGNORE_TT = [=[Причина:
|cff00ff00%s

|cffffff00Удалить из черного списка]=], -- Needs review
        REG_LIST_NAME = "Имя персонажа", -- Needs review
        REG_LIST_NOTIF_ADD = "Обнаружен новый профиль для |cff00ff00%s", -- Needs review
        REG_LIST_NOTIF_ADD_CONFIG = "Обнаружен новый профиль", -- Needs review
        REG_LIST_NOTIF_ADD_NOT = "Данный профиль не существует.", -- Needs review
        REG_LIST_PET_MASTER = "Имя хозяина", -- Needs review
        REG_LIST_PET_NAME = "Имя спутника", -- Needs review
        REG_LIST_PETS_EMPTY = "Нет спутника", -- Needs review
        REG_LIST_PETS_EMPTY2 = "Ни один спутник не подходит под ваш выбор", -- Needs review
        REG_LIST_PETS_FILTER = "Спутники: %s / %s", -- Needs review
        REG_LIST_PETS_TITLE = "Список спутников", -- Needs review
        REG_LIST_PETS_TOOLTIP = "Последнее появление", -- Needs review
        REG_LIST_PETS_TOOLTIP2 = "Был вместе с", -- Needs review
        REG_LIST_PET_TYPE = "Тип спутника", -- Needs review
        REG_LIST_REALMONLY = "Только текущий игровой мир", -- Needs review
        REG_MSP_ALERT = [=[|cffff0000ВНИМАНИЕ

Настоятельно не рекомендуется пользоваться несколькими аддонами, использующими протокол Mary Sue, так как это вызывает ошибки.|r

Сейчас используются: |cff00ff00%s

|cffff9900Поддержка протокола для Total RP3 будет отключена.|r

Если вы не хотите использовать TRP3 по этому протоколу и не хотите снова видеть это сообщение, можно его отключить в настойках.]=], -- Needs review
        REG_PLAYER = "Персонаж", -- Needs review
        REG_PLAYER_ABOUT = "О персонаже", -- Needs review
        REG_PLAYER_ABOUT_ADD_FRAME = "Добавить окно", -- Needs review
        REG_PLAYER_ABOUT_EMPTY = "Нет описания", -- Needs review
        REG_PLAYER_ABOUT_HEADER = "Метка титула", -- Needs review
        REG_PLAYER_ABOUT_MUSIC = "Тема персонажа", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_LISTEN = "Играть тему", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_REMOVE = "Отключить тему", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_SELECT = "Выбрать тему персонажа", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_SELECT2 = "Выбрать тему", -- Needs review
        REG_PLAYER_ABOUT_MUSIC_STOP = "Остановить тему", -- Needs review
        REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900Тема не выбрана", -- Needs review
        REG_PLAYER_ABOUT_P = "Метка абзаца", -- Needs review
        REG_PLAYER_ABOUT_REMOVE_FRAME = "Удалить рамку", -- Needs review
        REG_PLAYER_ABOUTS = "О %s", -- Needs review
        REG_PLAYER_ABOUT_SOME = "Текст ...", -- Needs review
        REG_PLAYER_ABOUT_T1_YOURTEXT = "Вставьте Ваш текст", -- Needs review
        REG_PLAYER_ABOUT_TAGS = "Инструменты форматирования", -- Needs review
        REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900Неизвестная тема", -- Needs review
        REG_PLAYER_ABOUT_VOTE_DOWN = "Мне не нравится описание", -- Needs review
        REG_PLAYER_ABOUT_VOTE_NO = [=[Персонажи, связанные с профилем, не в сети.
Хотите, чтобы Total RP 3 все равно отправил голос?]=], -- Needs review
        REG_PLAYER_ABOUT_VOTES = "Статистика", -- Needs review
        REG_PLAYER_ABOUT_VOTE_SENDING = "Посылка голоса профилю %s ...", -- Needs review
        REG_PLAYER_ABOUT_VOTE_SENDING_OK = "Ваш голос успешно отправлен профилю %s!", -- Needs review
        REG_PLAYER_ABOUT_VOTES_R = [=[|cff00ff00%s игрокам нравится описание
|cffff0000%s игрокам не нравится описание]=], -- Needs review
        REG_PLAYER_ABOUT_VOTE_TT = "Ваш голос является анонимным. Другой игрок не увидит отправителя.", -- Needs review
        REG_PLAYER_ABOUT_VOTE_TT2 = "Вы можете голосовать, только если игрок в сети.", -- Needs review
        REG_PLAYER_ABOUT_VOTE_UP = "Мне нравится описание", -- Needs review
        REG_PLAYER_ADD_NEW = "Создать новый", -- Needs review
        REG_PLAYER_AGE = "Возраст", -- Needs review
        REG_PLAYER_AGE_TT = [=[Здест Вы можете указать возраст вашего персонажа.

Это можно сделать следующими способами:|c0000ff00
- Возраст в годах (число),
- Прилагательное (Молодой, Взрослый, Престарелый и др.).]=], -- Needs review
        REG_PLAYER_ALERT_HEAVY_SMALL = [=[|cffff0000Общий размер профиля слишком велик.
|cffff9900Уменьшите его.]=], -- Needs review
        REG_PLAYER_BIRTHPLACE = "Место рождения", -- Needs review
        REG_PLAYER_BIRTHPLACE_TT = [=[Здесь Вы можете написать место рождения персонажа: это может быть регион, локация или континент. Все зависит от того, насколько точно Вы хотите его описать.

|c00ffff00Используйте кнопку справа, чтобы установить Ваше текущее положение как место рождения.]=], -- Needs review
        REG_PLAYER_CARACT = "Характеристики", -- Needs review
        REG_PLAYER_CHANGE_CONFIRM = [=[Возможно, Вы не сохранили изменения.
Вы действительно хотите изменить страницу?
|cffff9900Все изменения будут утеряны.]=], -- Needs review
        REG_PLAYER_CHARACTERISTICS = "Характеристики", -- Needs review
        REG_PLAYER_CLASS = "Класс", -- Needs review
        REG_PLAYER_CLASS_TT = [=[Это нестандартный класс вашего персонажа.

|cff00ff00Например:|r
Рыцарь, Пиротехник, Некромант, Элитный стрелок, Чародей, ...]=], -- Needs review
        REG_PLAYER_COLOR_CLASS = "Цвет класса", -- Needs review
        REG_PLAYER_COLOR_TT = [=[|cffffff00ЛКМ:|r Выбрать цвет
|cffffff00ПКМ:|r Сбросить цвет]=], -- Needs review
        REG_PLAYER_CURRENT_OOC = "Это информация вне отыгрыша", -- Needs review
        REG_PLAYER_EYE = "Цвет глаз", -- Needs review
        REG_PLAYER_EYE_TT = [=[Здесь Вы можете указать цвет глаз персонажа.

Учтите, что даже если лицо персонажа постоянно скрыто, цвет глаз стоит указать на всякий случай.]=], -- Needs review
        REG_PLAYER_FIRSTNAME = "Имя", -- Needs review
        REG_PLAYER_FIRSTNAME_TT = [=[Это имя Вашего персонажа. Это поле является обязательным, по умолчанию будет использовано имя персонажа WoW (|cffffff00%s|r).

Так же можно использовать |c0000ff00прозвище|r!]=], -- Needs review
        REG_PLAYER_FULLTITLE = "Полный титул", -- Needs review
        REG_PLAYER_GLANCE = "На первый взгляд", -- Needs review
        REG_PLAYER_GLANCE_PRESET = "Загрузить заготовку", -- Needs review
        REG_PLAYER_GLANCE_PRESET_ALERT1 = "Пожалуйста, введите категорию и название", -- Needs review
        REG_PLAYER_GLANCE_PRESET_CATEGORY = "Категория заготовки", -- Needs review
        REG_PLAYER_GLANCE_PRESET_NAME = "Название заготовки", -- Needs review
        REG_PLAYER_GLANCE_PRESET_SAVE = "Сохранить информацию как заготовку", -- Needs review
        REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "Сохранить как заготовку", -- Needs review
        REG_PLAYER_GLANCE_PRESET_SELECT = "Выбрать заготовку", -- Needs review
        REG_PLAYER_GLANCE_UNUSED = "Неиспользуемый слот", -- Needs review
        REG_PLAYER_GLANCE_USE = "Активировать слот", -- Needs review
        REG_PLAYER_HEIGHT = "Рост", -- Needs review
        REG_PLAYER_HEIGHT_TT = [=[Здесь вы можете указать рост Вашего персонажа.

Это можно сделать следующими способами:|c0000ff00
- Точное значение (170 см, 6'5"),
- Прилагательное (высокий, низкий).]=], -- Needs review
        REG_PLAYER_HERE = "Установить позицию", -- Needs review
        REG_PLAYER_HERE_TT = "|cffffff00ЛКМ|r: Установить на текущее положение", -- Needs review
        REG_PLAYER_HISTORY = "История", -- Needs review
        REG_PLAYER_ICON = "Значок персонажа", -- Needs review
        REG_PLAYER_IGNORE = "Добавить в черный список связанных персонажей (%s)", -- Needs review
        REG_PLAYER_IGNORE_WARNING = [=[Вы хотите добавить в черный список выбранных персонажей?

|cffff9900%s

|rВы можете указать причину ниже. Другие игроки не смогут ее увидеть.]=], -- Needs review
        REG_PLAYER_LASTNAME = "Фамилия", -- Needs review
        REG_PLAYER_LASTNAME_TT = "Фамилия Вашего персонажа.", -- Needs review
        REG_PLAYER_MISC_ADD = "Добавить поле", -- Needs review
        REG_PLAYER_MORE_INFO = "Дополнительная информация", -- Needs review
        REG_PLAYER_MSP_NICK = "Ник", -- Needs review
        REG_PLAYER_NAMESTITLES = "Имена и названия", -- Needs review
        REG_PLAYER_NO_CHAR = "Нет характеристик", -- Needs review
        REG_PLAYER_PEEK = "Разное", -- Needs review
        REG_PLAYER_PHYSICAL = "Физические характеристики", -- Needs review
        REG_PLAYER_PSYCHO = "Черты характера", -- Needs review
        REG_PLAYER_PSYCHO_Acete = "Аскет", -- Needs review
        REG_PLAYER_PSYCHO_ADD = "Добавить черту характера", -- Needs review
        REG_PLAYER_PSYCHO_Bonvivant = "Душа компании", -- Needs review
        REG_PLAYER_PSYCHO_CHAOTIC = "Хаотичный", -- Needs review
        REG_PLAYER_PSYCHO_Chaste = "Строгий", -- Needs review
        REG_PLAYER_PSYCHO_Conciliant = "Идеал", -- Needs review
        REG_PLAYER_PSYCHO_Couard = "Бесхребетный", -- Needs review
        REG_PLAYER_PSYCHO_CREATENEW = "Создать черту", -- Needs review
        REG_PLAYER_PSYCHO_Cruel = "Жестокий", -- Needs review
        REG_PLAYER_PSYCHO_CUSTOM = "Своя черта", -- Needs review
        REG_PLAYER_PSYCHO_Egoiste = "Эгоист", -- Needs review
        REG_PLAYER_PSYCHO_Genereux = "Альтруист", -- Needs review
        REG_PLAYER_PSYCHO_Loyal = "Законопослушный", -- Needs review
        REG_PLAYER_PSYCHO_Luxurieux = "Похотливый", -- Needs review
        REG_PLAYER_PSYCHO_Misericordieux = "Вежливый", -- Needs review
        REG_PLAYER_PSYCHO_MORE = "Добавить точку к \"%s\"", -- Needs review
        REG_PLAYER_PSYCHO_PERSONAL = "Черты характера", -- Needs review
        REG_PLAYER_PSYCHO_Pieux = "Суеверный", -- Needs review
        REG_PLAYER_PSYCHO_POINT = "Добавить точку", -- Needs review
        REG_PLAYER_PSYCHO_Pragmatique = "Отступник", -- Needs review
        REG_PLAYER_PSYCHO_Rationnel = "Рациональный", -- Needs review
        REG_PLAYER_PSYCHO_Reflechi = "Осторожный", -- Needs review
        REG_PLAYER_PSYCHO_Rencunier = "Мстительный", -- Needs review
        REG_PLAYER_PSYCHO_Sincere = "Правдивый", -- Needs review
        REG_PLAYER_PSYCHO_SOCIAL = "Социальные черты", -- Needs review
        REG_PLAYER_PSYCHO_Trompeur = "Лживый", -- Needs review
        REG_PLAYER_PSYCHO_Valeureux = "Доблестный", -- Needs review
        REG_PLAYER_RACE = "Раса", -- Needs review
        REG_PLAYER_RACE_TT = "Здесь указывается раса персонажа. Не обязательно ограничиваться играбельными расами. В мире Warcraft есть много рас, обладающих схожими чертами.", -- Needs review
        REG_PLAYER_RESIDENCE = "Место жительства", -- Needs review
        REG_PLAYER_SHOWPSYCHO = "Отображать рамку характера", -- Needs review
        REG_PLAYER_STYLE_ASSIST = "Помощь в отыгрыше", -- Needs review
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