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
    localeContent =
    --@localization(locale="ruRU", format="lua_table", handle-unlocalized="ignore")@
    --@do-not-package@
    {
        ["ABOUT_TITLE"] = [=[О персонаже]=],
        ["BINDING_NAME_TRP3_TOGGLE"] = "Показать/спрятать главное окно",
        ["BINDING_NAME_TRP3_TOOLBAR_TOGGLE"] = "Отображение панели инструментов",
        ["BW_COLOR_CODE"] = "Цветовой код",
        ["BW_COLOR_CODE_ALERT"] = "Некорректный 16-ричный код!",
        ["BW_COLOR_CODE_TT"] = "Здесь можно вставить 6 цифр 16-ричного цветового кода и нажать Enter.",
        ["CM_ACTIONS"] = "Действия",
        ["CM_APPLY"] = "Применить",
        ["CM_CANCEL"] = "Отмена",
        ["CM_CENTER"] = "Центр",
        ["CM_CLASS_DEATHKNIGHT"] = "Рыцарь Смерти",
        ["CM_CLASS_DRUID"] = "Друид",
        ["CM_CLASS_HUNTER"] = "Охотник",
        ["CM_CLASS_MAGE"] = "Маг",
        ["CM_CLASS_MONK"] = "Монах",
        ["CM_CLASS_PALADIN"] = "Паладин",
        ["CM_CLASS_PRIEST"] = "Жрец",
        ["CM_CLASS_ROGUE"] = "Разбойник",
        ["CM_CLASS_SHAMAN"] = "Шаман",
        ["CM_CLASS_UNKNOWN"] = "Неизвестно",
        ["CM_CLASS_WARLOCK"] = "Чернокнижник",
        ["CM_CLASS_WARRIOR"] = "Воин",
        ["CM_CLICK"] = "Щелчок",
        ["CM_COLOR"] = "Цвет",
        ["CM_CTRL"] = "Ctrl",
        ["CM_DRAGDROP"] = "Перетащить",
        ["CM_EDIT"] = "Редактировать",
        ["CM_IC"] = "IC (в роли)",
        ["CM_ICON"] = "Иконка",
        ["CM_IMAGE"] = "Изображение",
        ["CM_L_CLICK"] = "ЛКМ",
        ["CM_LEFT"] = "Влево",
        ["CM_LINK"] = "Ссылка",
        ["CM_LOAD"] = "Загрузить",
        ["CM_MOVE_DOWN"] = "Сдвинуть вниз",
        ["CM_MOVE_UP"] = "Сдвинуть вверх",
        ["CM_NAME"] = "Имя",
        ["CM_OOC"] = "OOC (вне роли)",
        ["CM_OPEN"] = "Открыть",
        ["CM_PLAY"] = "Играть",
        ["CM_R_CLICK"] = "ПКМ",
        ["CM_REMOVE"] = "Убрать",
        ["CM_RESIZE_TT"] = "Потяните для изменения размера окна",
        ["CM_RIGHT"] = "Вправо",
        ["CM_SAVE"] = "Сохранить",
        ["CM_SELECT"] = "Выбрать",
        ["CM_SHIFT"] = "Shift",
        ["CM_SHOW"] = "Показать",
        ["CM_STOP"] = "Стоп",
        ["CM_TWEET"] = "Отправить твит",
        ["CM_TWEET_PROFILE"] = "Показать ссылку профиля",
        ["CM_UNKNOWN"] = "Неизвестно",
        ["CM_VALUE"] = "Значение",
        ["CO_ANCHOR_BOTTOM"] = "Внизу",
        ["CO_ANCHOR_BOTTOM_LEFT"] = "Внизу слева",
        ["CO_ANCHOR_BOTTOM_RIGHT"] = "Внизу справа",
        ["CO_ANCHOR_LEFT"] = "Слева",
        ["CO_ANCHOR_RIGHT"] = "Справа",
        ["CO_ANCHOR_TOP"] = "Вверху",
        ["CO_ANCHOR_TOP_LEFT"] = "Слева вверху",
        ["CO_ANCHOR_TOP_RIGHT"] = "Справа вверху",
        ["CO_CHAT"] = "Настройки чата",
        ["CO_CHAT_MAIN"] = "Основные настройки чата",
        ["CO_CHAT_MAIN_COLOR"] = "Использовать особые цвета имен",
        ["CO_CHAT_MAIN_EMOTE"] = "Обнаружение эмоций",
        ["CO_CHAT_MAIN_EMOTE_PATTERN"] = "Шаблон обнаружения эмоций",
        ["CO_CHAT_MAIN_EMOTE_USE"] = "Использовать обнаружение эмоций",
        ["CO_CHAT_MAIN_EMOTE_YELL"] = "Скрыть эмоции /крик",
        ["CO_CHAT_MAIN_EMOTE_YELL_TT"] = "Не показывать *эмоция* или <эмоция> в канале /крик",
        ["CO_CHAT_MAIN_NAMING"] = "Метод именования",
        ["CO_CHAT_MAIN_NAMING_1"] = "Оставить первоначальные имена",
        ["CO_CHAT_MAIN_NAMING_2"] = "Использовать свои имена",
        ["CO_CHAT_MAIN_NAMING_3"] = "Имя + Фамилия",
        ["CO_CHAT_MAIN_NPC"] = "Обнаружение разговоров НИПов",
        ["CO_CHAT_MAIN_NPC_PREFIX"] = "Шаблон обнаружения разговоров НИПов",
        ["CO_CHAT_MAIN_NPC_PREFIX_TT"] = [=[Если фраза в чате с этим префиксом будет сказана в каналах /сказать, /эмоция, /группа или /рейд, она будет распознана как фраза НИПа.

|cff00ff00By default : "|| "
(без кавычек" и с пробелом после разделительной линии)]=],
        ["CO_CHAT_MAIN_NPC_USE"] = "Использовать обнаружение разговора НИПов.",
        ["CO_CHAT_MAIN_OOC"] = "Обнаружение персонажей вне отыгрыша",
        ["CO_CHAT_MAIN_OOC_COLOR"] = "Цвет \"вне отыгрыша\"",
        ["CO_CHAT_MAIN_OOC_PATTERN"] = "Шаблон обнаружения \"вне отыгрыша\"",
        ["CO_CHAT_MAIN_OOC_USE"] = "Использовать обнаружение \"вне отыгрыша\"",
        ["CO_CHAT_USE"] = "Используемые каналы чата",
        ["CO_CHAT_USE_SAY"] = "Канал /сказать",
        ["CO_CONFIGURATION"] = "Настройки",
        ["CO_GENERAL"] = "Основное",
        ["CO_GENERAL_BROADCAST"] = "Использовать общий канал чата",
        ["CO_GENERAL_BROADCAST_C"] = "Название общего канала чата",
        ["CO_GENERAL_BROADCAST_TT"] = "Общий канал чата нужен для многих вещей. Отключив его, вы отключите такие опции как нахождение на карте, локальные звуки, тайники и доступ к указателям...",
        ["CO_GENERAL_CHANGELOCALE_ALERT"] = [=[Для смены языка на %s необходимо перезагрузить интерфейс.

В случае отказа язык будет изменен при следующем входе в игру.]=],
        ["CO_GENERAL_COM"] = "Общение",
        ["CO_GENERAL_HEAVY"] = "Предупреждать о перегруженном профиле",
        ["CO_GENERAL_HEAVY_TT"] = "Оповестить, когда общий объем вашего профиля превысит разумное значение.",
        ["CO_GENERAL_LOCALE"] = "Язык аддона",
        ["CO_GENERAL_MISC"] = "Разное",
        ["CO_GENERAL_NEW_VERSION"] = "Оповещение об обновлениях",
        ["CO_GENERAL_NEW_VERSION_TT"] = "Оповестить, когда будет доступна новая версия аддона.",
        ["CO_GENERAL_TT_SIZE"] = "Размер текста подсказок",
        ["CO_GENERAL_UI_ANIMATIONS"] = "Анимация интерфейса",
        ["CO_GENERAL_UI_ANIMATIONS_TT"] = "Включить анимацию интерфейса.",
        ["CO_GENERAL_UI_SOUNDS"] = "Звуки интерфейса",
        ["CO_GENERAL_UI_SOUNDS_TT"] = "Включить звуки интерфейса (при открытии окон, переключении вкладок, нажатии кнопок).",
        ["CO_GLANCE_LOCK"] = "Закрепить панель",
        ["CO_GLANCE_LOCK_TT"] = "Запретить перемещение панели",
        ["CO_GLANCE_MAIN"] = "Панель \"На первый взгляд\"",
        ["CO_GLANCE_PRESET_TRP2"] = "Использовать позиционирование в стиле Total RP 2",
        ["CO_GLANCE_PRESET_TRP2_BUTTON"] = "Использовать",
        ["CO_GLANCE_PRESET_TRP2_HELP"] = "Ярлык для установки панели в стиле TRP2: справа от рамки цели WoW.",
        ["CO_GLANCE_PRESET_TRP3"] = "Использовать позиционирование в стиле Total RP 3",
        ["CO_GLANCE_PRESET_TRP3_HELP"] = "Ярлык для установки панели в стиле TRP3: снизу от рамки цели TRP3.",
        ["CO_GLANCE_RESET_TT"] = "Сбросить позиционирование панели вниз влево от закрепленной рамки.",
        ["CO_GLANCE_TT_ANCHOR"] = "Точка закрепления подсказок",
        ["CO_MINIMAP_BUTTON"] = "Кнопка у миникарты",
        ["CO_MINIMAP_BUTTON_FRAME"] = "Рамка для закрепления",
        ["CO_MINIMAP_BUTTON_RESET"] = "Сбросить позицию",
        ["CO_MINIMAP_BUTTON_RESET_BUTTON"] = "Сбросить",
        ["CO_MODULES"] = "Статус модулей",
        ["CO_MODULES_DISABLE"] = "Отключить модуль",
        ["CO_MODULES_ENABLE"] = "Включить модуль",
        ["CO_MODULES_ID"] = "ID модуля: %s",
        ["CO_MODULES_SHOWERROR"] = "Показать ошибку",
        ["CO_MODULES_STATUS"] = "Статус: %s",
        ["CO_MODULES_STATUS_0"] = "Отключены зависимости",
        ["CO_MODULES_STATUS_1"] = "Загружен",
        ["CO_MODULES_STATUS_2"] = "Отключен",
        ["CO_MODULES_STATUS_3"] = "Требуется обновить Total RP 3",
        ["CO_MODULES_STATUS_4"] = "Ошибка инициализации",
        ["CO_MODULES_STATUS_5"] = "Ошибка запуска",
        ["CO_MODULES_TT_DEP"] = "%s- %s (версия %s)|r",
        ["CO_MODULES_TT_DEPS"] = "Зависимости",
        ["CO_MODULES_TT_ERROR"] = [=[

|cffff0000Ошибка:|r
%s]=],
        ["CO_MODULES_TT_NONE"] = "Нет зависимостей",
        ["CO_MODULES_TT_TRP"] = "%sДля Total RP 3 версии %s и выше.|r",
        ["CO_MODULES_TUTO"] = [=[Модуль — независимая опция, которую можно включить или отключить.

Возможные статусы:
|cff00ff00Загружен:|r Модуль включен и загружен.
|cff999999Отключен:|r Модуль отключен.
|cffff9900Отключены зависимости:|r Некоторые зависимости не загружены.
|cffff9900TRP требуется обновление:|r Модулю требуется последняя версия TRP3.
|cffff0000Ошибка инициализации или запуска:|r Порядок загрузки модуля нарушен. Модуль может создавать ошибки!

|cffff9900При отключении модуля необходима перегрузка интерфейса.]=],
        ["CO_MODULES_VERSION"] = "Версия: %s",
        ["CO_MSP"] = "Протокол Mary Sue",
        ["CO_MSP_T3"] = "Использовать только шаблон 3",
        ["CO_MSP_T3_TT"] = "Шаблон 3 всегда будет использоваться для совместимости с протоколом, даже если вы выберите другой шаблон \"Описание\".",
        ["CO_REGISTER"] = "Настройки реестра",
        ["CO_REGISTER_ABOUT_VOTE"] = "Использовать систему голосования",
        ["CO_REGISTER_ABOUT_VOTE_TT"] = "Включает систему голосования, которая позволяет оценивать (\"нравится\" или \"не нравится\") описания других игроков и разрешает оценивать ваше описание другим.",
        ["CO_REGISTER_AUTO_ADD"] = "Автоматически добавлять новых игроков",
        ["CO_REGISTER_AUTO_ADD_TT"] = "Автоматически добавлять новых игроков в реестр.",
        ["CO_TARGETFRAME"] = "Настройки рамки цели",
        ["CO_TARGETFRAME_ICON_SIZE"] = "Размер иконок",
        ["CO_TARGETFRAME_USE"] = "Показать условия",
        ["CO_TARGETFRAME_USE_1"] = "Всегда",
        ["CO_TARGETFRAME_USE_2"] = "Только когда \"в отыгрыше\"",
        ["CO_TARGETFRAME_USE_3"] = "Никогда (Отключено)",
        ["CO_TARGETFRAME_USE_TT"] = "Определяет при каких условиях будет показана рамка цели при выборе цели.",
        ["CO_TOOLBAR"] = "Настройки рамок",
        ["CO_TOOLBAR_CONTENT"] = "Настройки панели инструментов",
        ["CO_TOOLBAR_CONTENT_CAPE"] = "Отображение плаща",
        ["CO_TOOLBAR_CONTENT_HELMET"] = "Отображение шлема",
        ["CO_TOOLBAR_CONTENT_RPSTATUS"] = "Статус персонажа (Отыгрываю/Не отыгрываю)",
        ["CO_TOOLBAR_CONTENT_STATUS"] = "Статус игрока (Отсутствует/Не беспокоить)",
        ["CO_TOOLBAR_ICON_SIZE"] = "Размер иконок",
        ["CO_TOOLBAR_MAX"] = "Максимум иконок в строке",
        ["CO_TOOLBAR_MAX_TT"] = "Чтобы панель отображалась вертикально, задайте значение 1!",
        ["CO_TOOLTIP"] = "Настройки подсказок",
        ["CO_TOOLTIP_ANCHOR"] = "Точка закрепления",
        ["CO_TOOLTIP_ANCHORED"] = "Закрепленная рамка",
        ["CO_TOOLTIP_CHARACTER"] = "Описание персонажей",
        ["CO_TOOLTIP_CLIENT"] = "Показать клиент",
        ["CO_TOOLTIP_COMBAT"] = "Скрывать в бою",
        ["CO_TOOLTIP_COMMON"] = "Общие настройки",
        ["CO_TOOLTIP_CURRENT"] = "Показывать текст \"текущее\"",
        ["CO_TOOLTIP_CURRENT_SIZE"] = "Максимальная длина текста \"текущее\"",
        ["CO_TOOLTIP_FT"] = "Показывать полный титул",
        ["CO_TOOLTIP_GUILD"] = "Показывать информацию о гильдии",
        ["CO_TOOLTIP_HIDE_ORIGINAL"] = "Скрывать подсказки игры",
        ["CO_TOOLTIP_ICONS"] = "Показывать иконки",
        ["CO_TOOLTIP_MAINSIZE"] = "Размер основного шрифта",
        ["CO_TOOLTIP_NOTIF"] = "Показывать уведомления",
        ["CO_TOOLTIP_NOTIF_TT"] = "Строка уведомлений — строка, содержащая версию клиента, метку непрочитанного описания и метку \"На первый взгляд\".",
        ["CO_TOOLTIP_OWNER"] = "Показать владельца",
        ["CO_TOOLTIP_PETS"] = "Подсказки спутников",
        ["CO_TOOLTIP_PETS_INFO"] = "Показать информацию о спутнике",
        ["CO_TOOLTIP_PROFILE_ONLY"] = "Использовать, только если у цели есть профиль",
        ["CO_TOOLTIP_RACE"] = "Показывать расу, класс и уровень",
        ["CO_TOOLTIP_REALM"] = "Показывать игровой мир",
        ["CO_TOOLTIP_RELATION"] = "Показывать цвет отношений",
        ["CO_TOOLTIP_RELATION_TT"] = "Окрасить рамку подсказки персонажа в цвет, характеризующий отношение.",
        ["CO_TOOLTIP_SPACING"] = "Показывать интервалы",
        ["CO_TOOLTIP_SPACING_TT"] = "Располагает интервалы для облегчения подсказки, в стиле MyRolePlay.",
        ["CO_TOOLTIP_SUBSIZE"] = "Размер вторичного шрифта",
        ["CO_TOOLTIP_TARGET"] = "Показать цель",
        ["CO_TOOLTIP_TERSIZE"] = "Размер третичного шрифта",
        ["CO_TOOLTIP_TITLE"] = "Показывать заголовок",
        ["CO_TOOLTIP_USE"] = "Использовать подсказку персонажей/спутников",
        ["CO_WIM"] = "|cffff9900Каналы шепота отключены.",
        ["CO_WIM_TT"] = "Вы используете аддон |cff00ff00WIM|r, для совместимости отключена обработка каналов шепота отключена.",
        ["COM_LIST"] = "Список команд",
        ["COM_RESET_RESET"] = "Расположение окон сброшено!",
        ["COM_RESET_USAGE"] = "Использование: |cff00ff00/trp3 сброс фреймов|r сбросить расположение окон.",
        ["COM_SWITCH_USAGE"] = "Использование: |cff00ff00/trp3 вкл/выкл главное окно|r чтобы показать/скрыть главное окно или |cff00ff00/trp3 вкл/выкл панель инструментов|r чтобы показать/скрыть панель инструментов",
        ["DB_MORE"] = "Больше дополнений",
        ["DB_STATUS"] = "Статус",
        ["DB_STATUS_CURRENTLY"] = "Текущее (Отыгрываю)",
        ["DB_STATUS_CURRENTLY_COMMON"] = "Эти статусы будут показаны в подсказке вашего персонажа. Делайте их краткими, так как |cffff9900by по умолчанию игроки с TRP3 будут видеть только первые 140 символов",
        ["DB_STATUS_CURRENTLY_OOC"] = "Другая информация (Вне отыгрыша)",
        ["DB_STATUS_CURRENTLY_OOC_TT"] = "Здесь вы можете указать что-то важное о вас, как игроке, или что-нибудь еще вне отыгрыша.",
        ["DB_STATUS_CURRENTLY_TT"] = "Здесь вы можете указать что-нибудь важное о вашем персонаже.",
        ["DB_STATUS_RP"] = "Статус персонажа",
        ["DB_STATUS_RP_EXP"] = "Опытный ролевик",
        ["DB_STATUS_RP_EXP_TT"] = [=[Показывает, что вы опытный ролевик.
Не добавляет никаких специальных иконок в вашу подсказку.]=],
        ["DB_STATUS_RP_IC"] = "Отыгрываю",
        ["DB_STATUS_RP_IC_TT"] = [=[Это значит, что сейчас вы отыгрываете своего персонажа.
Все ваши действия рассматриваются как выполненные вашим персонажем.]=],
        ["DB_STATUS_RP_OOC"] = "Вне отыгрыша",
        ["DB_STATUS_RP_OOC_TT"] = [=[Вы вне роли.
Ваши действия не могут быть связаны с вашим персонажем.]=],
        ["DB_STATUS_RP_VOLUNTEER"] = "Волонтер",
        ["DB_STATUS_RP_VOLUNTEER_TT"] = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая ролевикам-новичкам, что Вы хотите помочь им.",
        ["DB_STATUS_XP"] = "Статус ролевика",
        ["DB_STATUS_XP_BEGINNER"] = "Новичок",
        ["DB_STATUS_XP_BEGINNER_TT"] = "Если выбрать этот статус, в вашей подсказке отобразится специальная иконка, показывающая остальным ролевикам, что Вы - новичок.",
        ["DB_TUTO_1"] = [=[|cffffff00Статус персонажа|r отображает, находитесь ли Вы в данный момент в отыгрыше.

|cffffff00Статус персонажа|r позволяет указать Ваш опыт в ролевых играх: будь то новичок или ветеран, желающий помочь новобранцам.

|cff00ff00Эта информация будет указана в описании вашего персонажа.]=],
        ["GEN_VERSION"] = "Версия: %s (Сборка %s)",
        ["GEN_WELCOME_MESSAGE"] = "Благодарим за использование TotalRP3 (версии %s)! Приятной игры!",
        ["MAP_SCAN_CHAR"] = "Поиск персонажей",
        ["MAP_SCAN_CHAR_TITLE"] = "Персонажи",
        ["MM_SHOW_HIDE_MAIN"] = "Отображение основной рамки",
        ["MM_SHOW_HIDE_MOVE"] = "Переместить кнопку",
        ["MM_SHOW_HIDE_SHORTCUT"] = "Отображение панели инструментов",
        ["NPC_TALK_SAY_PATTERN"] = "говорит:",
        ["NPC_TALK_WHISPER_PATTERN"] = "шепчет:",
        ["NPC_TALK_YELL_PATTERN"] = "кричит:",
        ["PR_CO_BATTLE"] = "Боевой питомец",
        ["PR_CO_COUNT"] = "%s питомцев/средств передвижения привязано к данному профилю.",
        ["PR_CO_EMPTY"] = "Профиль спутника отсутствует",
        ["PR_CO_MASTERS"] = "Хозяева",
        ["PR_CO_NEW_PROFILE"] = "Профиль нового спутника",
        ["PR_CO_PET"] = "Питомец",
        ["PR_CO_PROFILE_DETAIL"] = "Данный профиль связан с",
        ["PR_CO_PROFILE_HELP"] = [=[Профиль содержит всю информацию о |cffffff00"питомце"|r как |cff00ff00персонаже отыгрыша|r.

Профиль спутника может быть привязан к:
- Боевому питомцу |cffff9900(только если он назван)|r
- Питомцу охотника
- Демону чернокнижника
- Элементалю мага
- Вурдалаку рыцаря смерти |cffff9900(см. ниже)|r

Как и профиль персонажа, |cff00ff00профиль спутника|r можно привязать к |cffffff00нескольким питомцам|r, |cffffff00питомца|r можно легко переключать между профилями.


|cffff9900Вурдалаки:|r Так как вурдалак получает новое имя при каждом призывании, Вам необходимо привязать профиль ко всем вариациям имени.]=],
        ["PR_CO_PROFILE_HELP2"] = [=[Нажмите, чтобы создать новый профиль спутника.

|cff00ff00Чтобы привязать профиль к питомцу (демону/элементалю/вурдалаку), призовите его, выделите и привяжите к существующему профилю (или создайте новый профиль).|r]=],
        ["PR_CO_PROFILEMANAGER_DELETE_WARNING"] = [=[Вы уверены, что хотите удалить профиль спутника %s?
Данное действие нельзя отменить, вся информация TRP3, связанная с данным профилем будет удалена!]=],
        ["PR_CO_PROFILEMANAGER_DUPP_POPUP"] = [=[Введите название для нового профиля.
Название не может быть пустым.

Эта копия не изменит список питомцев/транспорта, привязанный к профилю %s.]=],
        ["PR_CO_PROFILEMANAGER_EDIT_POPUP"] = [=[Введите новое название для профиля %s.
Название не может быть пустым.

Изменение названия не изменит связей между профилем и питомцами/транспортом.]=],
        ["PR_CO_PROFILEMANAGER_TITLE"] = "Профили спутников",
        ["PR_CO_UNUSED_PROFILE"] = "К данному профилю не привязан ни один питомец или вид транспорта.",
        ["PR_CO_WARNING_RENAME"] = [=[|cffff0000Внимание:|r настоятельно рекомендуется сменить имя питомца перед тем, как привязывать его к профилю.

Link it anyway ?]=],
        ["PR_CREATE_PROFILE"] = "Создать профиль",
        ["PR_DELETE_PROFILE"] = "Удалить профиль",
        ["PR_DUPLICATE_PROFILE"] = "Копировать профиль",
        ["PR_IMPORT_CHAR_TAB"] = "Импорт персонажей",
        ["PR_IMPORT_EMPTY"] = "Нет импортируемых профилей",
        ["PR_IMPORT_IMPORT_ALL"] = "Импортировать все",
        ["PR_IMPORT_PETS_TAB"] = "Импортирование спутников",
        ["PR_IMPORT_WILL_BE_IMPORTED"] = "Будет импортировано",
        ["PR_PROFILE"] = "Профиль",
        ["PR_PROFILE_CREATED"] = "Профиль \"%s\" создан.",
        ["PR_PROFILE_DELETED"] = "Профиль \"%s\" удален.",
        ["PR_PROFILE_DETAIL"] = "Этот профиль на данный момент привязан к следующим персонажам WoW",
        ["PR_PROFILE_HELP"] = [=[Профиль содержит информацию о |cffffff00"персонаже"|r как о |cff00ff00персонаже отыгрыша|r.

Настоящий |cffffff00"персонаж WoW"|r может быть связан только с одним профилем одновременно, но в любой момент можно переключить его на другой.

Так же можно связать нескольких |cffffff00"персонажей WoW"|r к одному |cff00ff00профилю|r!]=],
        ["PR_PROFILE_LOADED"] = "Загружен профиль %s.",
        ["PR_PROFILEMANAGER_ACTIONS"] = "Действия",
        ["PR_PROFILEMANAGER_ALREADY_IN_USE"] = "Профиль %s недоступен.",
        ["PR_PROFILEMANAGER_COUNT"] = "%s персонаж(ей) WoW связаны с профилем.",
        ["PR_PROFILEMANAGER_CREATE_POPUP"] = [=[Введите название для нового профиля.
Название не может быть пустым.]=],
        ["PR_PROFILEMANAGER_CURRENT"] = "Текущий профиль",
        ["PR_PROFILEMANAGER_DELETE_WARNING"] = [=[Вы уверены, что хотите удалить профиль %s?
Данное действие невозможно отменить, вся информация TRP3, связанная с профилем (информация о персонаже, инвентарь, список заданий и др.) будет удалена!]=],
        ["PR_PROFILEMANAGER_DUPP_POPUP"] = [=[Введите название для нового профиля.
Название не может быть пустым.

Эта копия не изменит связи персонажа с профилем %s.]=],
        ["PR_PROFILEMANAGER_EDIT_POPUP"] = [=[Введите новое название профиля.
Название не может быть пустым.

Переименование профиля не изменит связей между профилем и персонажами.]=],
        ["PR_PROFILEMANAGER_RENAME"] = "Переименовать профиль",
        ["PR_PROFILEMANAGER_SWITCH"] = "Выбрать профиль",
        ["PR_PROFILEMANAGER_TITLE"] = "Профили персонажей",
        ["PR_PROFILES"] = "Профили",
        ["PR_UNUSED_PROFILE"] = "Этот профиль на данный момент не привязан к какому-либо персонажу WoW.",
        ["REG_COMPANION"] = "Спутник",
        ["REG_COMPANION_INFO"] = "Информация",
        ["REG_COMPANION_NAME"] = "Имя",
        ["REG_COMPANION_NAME_COLOR"] = "Цвет имени",
        ["REG_COMPANION_PAGE_TUTO_C_1"] = "Совет",
        ["REG_COMPANION_PAGE_TUTO_E_1"] = [=[Это |cff00ff00основная информация о вашем спутнике|r.

Эта информация будет отображаться |cffff9900в описании спутника|r.]=],
        ["REG_COMPANION_PAGE_TUTO_E_2"] = [=[Это |cff00ff00описание вашего спутника|r.

Оно не связано с |cffff9900физическим описанием|r. Здесь можно описать |cffff9900историю|r спутника или его |cffff9900характер|r.

Описание можно настроить под себя различными способами.
Вы можете выбрать |cffffff00текстуру фона|r для описания. Доступны инструменты форматирования, такие как |cffffff00размер шрифта, цвет и выравнивание|r.
Эти инструменты позволяют так же вставить |cffffff00изображения, иконки или ссылки на сайты|r.]=],
        ["REG_COMPANION_PROFILES"] = "Профили спутников",
        ["REG_COMPANION_TF_BOUND_TO"] = "Выбрать профиль",
        ["REG_COMPANION_TF_CREATE"] = "Создать новый профиль",
        ["REG_COMPANION_TF_NO"] = "Нет профиля",
        ["REG_COMPANION_TF_OPEN"] = "Открыть страницу",
        ["REG_COMPANION_TF_OWNER"] = "Владелец: %s",
        ["REG_COMPANION_TF_PROFILE"] = "Профиль спутника",
        ["REG_COMPANION_TF_PROFILE_MOUNT"] = "Профиль ездового животного",
        ["REG_COMPANION_TF_UNBOUND"] = "Отвязать от профиля",
        ["REG_COMPANION_TITLE"] = "Название",
        ["REG_COMPANIONS"] = "Спутники",
        ["REG_DELETE_WARNING"] = [=[Вы уверены, что хотите удалить профиль "%s"?
]=],
        ["REG_IGNORE_TOAST"] = "Персонаж игнорируется",
        ["REG_LIST_ACTIONS_MASS"] = "Действие над %s выбранными профилями",
        ["REG_LIST_ACTIONS_MASS_IGNORE"] = "Игнорировать профили",
        ["REG_LIST_ACTIONS_MASS_IGNORE_C"] = [=[Данное действие добавит |cff00ff00%s персонажей|r в черный список.

Можете написать причину добавления ниже. Эту заметку сможете увидеть только Вы.]=],
        ["REG_LIST_ACTIONS_MASS_REMOVE"] = "Удалить профили",
        ["REG_LIST_ACTIONS_MASS_REMOVE_C"] = "Это действие удалит |cff00ff00%s выбранный(е) профиль(и)|r.",
        ["REG_LIST_ACTIONS_PURGE"] = "Очистить регистр",
        ["REG_LIST_ACTIONS_PURGE_ALL"] = "Удалить все профили",
        ["REG_LIST_ACTIONS_PURGE_ALL_C"] = [=[Очистка удалит все профили и связанных персонажей из директории.

|cff00ff00%s персонажей.]=],
        ["REG_LIST_ACTIONS_PURGE_ALL_COMP_C"] = [=[Очистка удалит всех спутников из директории.

|cff00ff00%s спутников.]=],
        ["REG_LIST_ACTIONS_PURGE_COUNT"] = "%s профилей будет удалено.",
        ["REG_LIST_ACTIONS_PURGE_EMPTY"] = "Нет профилей для удаления.",
        ["REG_LIST_ACTIONS_PURGE_IGNORE"] = "Профили персонажей из черного списка",
        ["REG_LIST_ACTIONS_PURGE_IGNORE_C"] = [=[Очистка удалит все профили, связанные с персонажами WoW из черного списка.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_TIME"] = "Профиль не появлялся более месяца",
        ["REG_LIST_ACTIONS_PURGE_TIME_C"] = [=[Очистка удалит все профили, которые не появлялись больше месяца.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_UNLINKED"] = "Профиль не привязан к персонажу",
        ["REG_LIST_ACTIONS_PURGE_UNLINKED_C"] = [=[Очистка удалит все профили, не связанные с персонажами WoW.

|cff00ff00%s]=],
        ["REG_LIST_ADDON"] = "Тип профиля",
        ["REG_LIST_CHAR_EMPTY"] = "Нет персонажей",
        ["REG_LIST_CHAR_EMPTY2"] = "Ни один персонаж не подходит под описание",
        ["REG_LIST_CHAR_FILTER"] = "Персонажей: %s / %s",
        ["REG_LIST_CHAR_IGNORED"] = "Черный список",
        ["REG_LIST_CHAR_SEL"] = "Выбранный персонаж",
        ["REG_LIST_CHAR_TITLE"] = "Список персонажей",
        ["REG_LIST_CHAR_TT"] = "Просмотреть страницу",
        ["REG_LIST_CHAR_TT_CHAR"] = "Связанные персонажи WoW:",
        ["REG_LIST_CHAR_TT_CHAR_NO"] = "Не привязан ни к одному персонажу",
        ["REG_LIST_CHAR_TT_DATE"] = [=[Последнее появление: |cff00ff00%s|r
Последняя локация: |cff00ff00%s|r]=],
        ["REG_LIST_CHAR_TT_GLANCE"] = "На первый взгляд",
        ["REG_LIST_CHAR_TT_IGNORE"] = "Черный список",
        ["REG_LIST_CHAR_TT_NEW_ABOUT"] = "Непрочитанное описание",
        ["REG_LIST_CHAR_TT_RELATION"] = [=[Отношение:
|cff00ff00%s]=],
        ["REG_LIST_CHAR_TUTO_ACTIONS"] = "Этот столбец позволяет выбрать несколько персонажей для проведения действий над всеми.",
        ["REG_LIST_CHAR_TUTO_FILTER"] = [=[Можно применять фильтры к списку персонажей.

|cff00ff00Фильтр имени|r производит поиск по полному имени (имя + фамилия), а так же по привязанным персонажам.

|cff00ff00Фильтр гильдий|r производит поиск по названию гильдии привязанных персонажей.

|cff00ff00Фильтр игровых миров|r отображает только профили связанных персонажей из вашего мира.]=],
        ["REG_LIST_CHAR_TUTO_LIST"] = [=[Первый столбец отображает имя персонажа.

Второй столбей отображает отношения между Вашим персонажем и прочими.

Последний столбец используется для различных меток (черный список и др.).]=],
        ["REG_LIST_FILTERS"] = "Фильтры",
        ["REG_LIST_FILTERS_TT"] = [=[|cffffff00ЛКМ:|r Применить фильтр
|cffffff00ПКМ:|r Сбросить фильтр]=],
        ["REG_LIST_FLAGS"] = "Метки",
        ["REG_LIST_GUILD"] = "Гильдия персонажа",
        ["REG_LIST_IGNORE_EMPTY"] = "Черный список пуст",
        ["REG_LIST_IGNORE_TITLE"] = "Черный список",
        ["REG_LIST_IGNORE_TT"] = [=[Причина:
|cff00ff00%s

|cffffff00Удалить из черного списка]=],
        ["REG_LIST_NAME"] = "Имя персонажа",
        ["REG_LIST_NOTIF_ADD"] = "Обнаружен новый профиль для |cff00ff00%s",
        ["REG_LIST_NOTIF_ADD_CONFIG"] = "Обнаружен новый профиль",
        ["REG_LIST_NOTIF_ADD_NOT"] = "Данный профиль не существует.",
        ["REG_LIST_PET_MASTER"] = "Имя хозяина",
        ["REG_LIST_PET_NAME"] = "Имя спутника",
        ["REG_LIST_PET_TYPE"] = "Тип спутника",
        ["REG_LIST_PETS_EMPTY"] = "Нет спутника",
        ["REG_LIST_PETS_EMPTY2"] = "Ни один спутник не подходит под ваш выбор",
        ["REG_LIST_PETS_FILTER"] = "Спутники: %s / %s",
        ["REG_LIST_PETS_TITLE"] = "Список спутников",
        ["REG_LIST_PETS_TOOLTIP"] = "Последнее появление",
        ["REG_LIST_PETS_TOOLTIP2"] = "Был вместе с",
        ["REG_LIST_REALMONLY"] = "Только текущий игровой мир",
        ["REG_MSP_ALERT"] = [=[|cffff0000ВНИМАНИЕ

Настоятельно не рекомендуется пользоваться несколькими аддонами, использующими протокол Mary Sue, так как это вызывает ошибки.|r

Сейчас используются: |cff00ff00%s

|cffff9900Поддержка протокола для Total RP3 будет отключена.|r

Если вы не хотите использовать TRP3 по этому протоколу и не хотите снова видеть это сообщение, можно его отключить в настойках.]=],
        ["REG_PLAYER"] = "Персонаж",
        ["REG_PLAYER_ABOUT"] = "О персонаже",
        ["REG_PLAYER_ABOUT_ADD_FRAME"] = "Добавить окно",
        ["REG_PLAYER_ABOUT_EMPTY"] = "Нет описания",
        ["REG_PLAYER_ABOUT_HEADER"] = "Метка титула",
        ["REG_PLAYER_ABOUT_MUSIC"] = "Тема персонажа",
        ["REG_PLAYER_ABOUT_MUSIC_LISTEN"] = "Играть тему",
        ["REG_PLAYER_ABOUT_MUSIC_REMOVE"] = "Отключить тему",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT"] = "Выбрать тему персонажа",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT2"] = "Выбрать тему",
        ["REG_PLAYER_ABOUT_MUSIC_STOP"] = "Остановить тему",
        ["REG_PLAYER_ABOUT_NOMUSIC"] = "|cffff9900Тема не выбрана",
        ["REG_PLAYER_ABOUT_P"] = "Метка абзаца",
        ["REG_PLAYER_ABOUT_REMOVE_FRAME"] = "Удалить рамку",
        ["REG_PLAYER_ABOUT_SOME"] = "Текст ...",
        ["REG_PLAYER_ABOUT_T1_YOURTEXT"] = "Вставьте Ваш текст",
        ["REG_PLAYER_ABOUT_TAGS"] = "Инструменты форматирования",
        ["REG_PLAYER_ABOUT_UNMUSIC"] = "|cffff9900Неизвестная тема",
        ["REG_PLAYER_ABOUT_VOTE_DOWN"] = "Мне не нравится описание",
        ["REG_PLAYER_ABOUT_VOTE_NO"] = [=[Персонажи, связанные с профилем, не в сети.
Хотите, чтобы Total RP 3 все равно отправил голос?]=],
        ["REG_PLAYER_ABOUT_VOTE_SENDING"] = "Посылка голоса профилю %s ...",
        ["REG_PLAYER_ABOUT_VOTE_SENDING_OK"] = "Ваш голос успешно отправлен профилю %s!",
        ["REG_PLAYER_ABOUT_VOTE_TT"] = "Ваш голос является анонимным. Другой игрок не увидит отправителя.",
        ["REG_PLAYER_ABOUT_VOTE_TT2"] = "Вы можете голосовать, только если игрок в сети.",
        ["REG_PLAYER_ABOUT_VOTE_UP"] = "Мне нравится описание",
        ["REG_PLAYER_ABOUT_VOTES"] = "Статистика",
        ["REG_PLAYER_ABOUT_VOTES_R"] = [=[|cff00ff00%s игрокам нравится описание
|cffff0000%s игрокам не нравится описание]=],
        ["REG_PLAYER_ABOUTS"] = "О %s",
        ["REG_PLAYER_ADD_NEW"] = "Создать новый",
        ["REG_PLAYER_AGE"] = "Возраст",
        ["REG_PLAYER_AGE_TT"] = [=[Здест Вы можете указать возраст вашего персонажа.

Это можно сделать следующими способами:|c0000ff00
- Возраст в годах (число),
- Прилагательное (Молодой, Взрослый, Престарелый и др.).]=],
        ["REG_PLAYER_ALERT_HEAVY_SMALL"] = [=[|cffff0000Общий размер профиля слишком велик.
|cffff9900Уменьшите его.]=],
        ["REG_PLAYER_BIRTHPLACE"] = "Место рождения",
        ["REG_PLAYER_BIRTHPLACE_TT"] = [=[Здесь Вы можете написать место рождения персонажа: это может быть регион, локация или континент. Все зависит от того, насколько точно Вы хотите его описать.

|c00ffff00Используйте кнопку справа, чтобы установить Ваше текущее положение как место рождения.]=],
        ["REG_PLAYER_BKG"] = "Стиль фона",
        ["REG_PLAYER_CARACT"] = "Характеристики",
        ["REG_PLAYER_CHANGE_CONFIRM"] = [=[Возможно, Вы не сохранили изменения.
Вы действительно хотите изменить страницу?
|cffff9900Все изменения будут утеряны.]=],
        ["REG_PLAYER_CHARACTERISTICS"] = "Характеристики",
        ["REG_PLAYER_CLASS"] = "Класс",
        ["REG_PLAYER_CLASS_TT"] = [=[Это нестандартный класс вашего персонажа.

|cff00ff00Например:|r
Рыцарь, Пиротехник, Некромант, Элитный стрелок, Чародей, ...]=],
        ["REG_PLAYER_COLOR_CLASS"] = "Цвет класса",
        ["REG_PLAYER_COLOR_TT"] = [=[|cffffff00ЛКМ:|r Выбрать цвет
|cffffff00ПКМ:|r Сбросить цвет]=],
        ["REG_PLAYER_CURRENT"] = "На данный момент",
        ["REG_PLAYER_CURRENT_OOC"] = "Это информация вне отыгрыша",
        ["REG_PLAYER_CURRENTOOC"] = "На данный момент (Вне отыгрыша)",
        ["REG_PLAYER_EYE"] = "Цвет глаз",
        ["REG_PLAYER_EYE_TT"] = [=[Здесь Вы можете указать цвет глаз персонажа.

Учтите, что даже если лицо персонажа постоянно скрыто, цвет глаз стоит указать на всякий случай.]=],
        ["REG_PLAYER_FIRSTNAME"] = "Имя",
        ["REG_PLAYER_FIRSTNAME_TT"] = [=[Это имя Вашего персонажа. Это поле является обязательным, по умолчанию будет использовано имя персонажа WoW (|cffffff00%s|r).

Так же можно использовать |c0000ff00прозвище|r!]=],
        ["REG_PLAYER_FULLTITLE"] = "Полный титул",
        ["REG_PLAYER_GLANCE"] = "На первый взгляд",
        ["REG_PLAYER_GLANCE_PRESET"] = "Загрузить заготовку",
        ["REG_PLAYER_GLANCE_PRESET_ALERT1"] = "Пожалуйста, введите категорию и название",
        ["REG_PLAYER_GLANCE_PRESET_CATEGORY"] = "Категория заготовки",
        ["REG_PLAYER_GLANCE_PRESET_NAME"] = "Название заготовки",
        ["REG_PLAYER_GLANCE_PRESET_SAVE"] = "Сохранить информацию как заготовку",
        ["REG_PLAYER_GLANCE_PRESET_SAVE_SMALL"] = "Сохранить как заготовку",
        ["REG_PLAYER_GLANCE_PRESET_SELECT"] = "Выбрать заготовку",
        ["REG_PLAYER_GLANCE_TITLE"] = "Название атрибута",
        ["REG_PLAYER_GLANCE_UNUSED"] = "Неиспользуемый слот",
        ["REG_PLAYER_GLANCE_USE"] = "Активировать слот",
        ["REG_PLAYER_HEIGHT"] = "Рост",
        ["REG_PLAYER_HEIGHT_TT"] = [=[Здесь вы можете указать рост Вашего персонажа.

Это можно сделать следующими способами:|c0000ff00
- Точное значение (170 см, 6'5"),
- Прилагательное (высокий, низкий).]=],
        ["REG_PLAYER_HERE"] = "Установить позицию",
        ["REG_PLAYER_HERE_TT"] = "|cffffff00ЛКМ|r: Установить на текущее положение",
        ["REG_PLAYER_HISTORY"] = "История",
        ["REG_PLAYER_ICON"] = "Значок персонажа",
        ["REG_PLAYER_ICON_TT"] = "Выберите изображение, представляющее вашего персонажа",
        ["REG_PLAYER_IGNORE"] = "Добавить в черный список связанных персонажей (%s)",
        ["REG_PLAYER_IGNORE_WARNING"] = [=[Вы хотите добавить в черный список выбранных персонажей?

|cffff9900%s

|rВы можете указать причину ниже. Другие игроки не смогут ее увидеть.]=],
        ["REG_PLAYER_LASTNAME"] = "Фамилия",
        ["REG_PLAYER_LASTNAME_TT"] = "Фамилия Вашего персонажа.",
        ["REG_PLAYER_MISC_ADD"] = "Добавить поле",
        ["REG_PLAYER_MORE_INFO"] = "Дополнительная информация",
        ["REG_PLAYER_MSP_HOUSE"] = "Название дома",
        ["REG_PLAYER_MSP_MOTTO"] = "Девиз",
        ["REG_PLAYER_MSP_NICK"] = "Ник",
        ["REG_PLAYER_NAMESTITLES"] = "Имена и названия",
        ["REG_PLAYER_NO_CHAR"] = "Нет характеристик",
        ["REG_PLAYER_PEEK"] = "Разное",
        ["REG_PLAYER_PHYSICAL"] = "Физические характеристики",
        ["REG_PLAYER_PSYCHO"] = "Черты характера",
        ["REG_PLAYER_PSYCHO_Acete"] = "Аскет",
        ["REG_PLAYER_PSYCHO_ADD"] = "Добавить черту характера",
        ["REG_PLAYER_PSYCHO_ATTIBUTENAME_TT"] = "Название атрибута",
        ["REG_PLAYER_PSYCHO_Bonvivant"] = "Душа компании",
        ["REG_PLAYER_PSYCHO_CHAOTIC"] = "Хаотичный",
        ["REG_PLAYER_PSYCHO_Chaste"] = "Строгий",
        ["REG_PLAYER_PSYCHO_Conciliant"] = "Идеал",
        ["REG_PLAYER_PSYCHO_Couard"] = "Бесхребетный",
        ["REG_PLAYER_PSYCHO_CREATENEW"] = "Создать черту",
        ["REG_PLAYER_PSYCHO_Cruel"] = "Жестокий",
        ["REG_PLAYER_PSYCHO_CUSTOM"] = "Своя черта",
        ["REG_PLAYER_PSYCHO_Egoiste"] = "Эгоист",
        ["REG_PLAYER_PSYCHO_Genereux"] = "Альтруист",
        ["REG_PLAYER_PSYCHO_Impulsif"] = "Импульсивный",
        ["REG_PLAYER_PSYCHO_Loyal"] = "Законопослушный",
        ["REG_PLAYER_PSYCHO_Luxurieux"] = "Похотливый",
        ["REG_PLAYER_PSYCHO_Misericordieux"] = "Вежливый",
        ["REG_PLAYER_PSYCHO_MORE"] = "Добавить точку к \"%s\"",
        ["REG_PLAYER_PSYCHO_PERSONAL"] = "Черты характера",
        ["REG_PLAYER_PSYCHO_Pieux"] = "Суеверный",
        ["REG_PLAYER_PSYCHO_POINT"] = "Добавить точку",
        ["REG_PLAYER_PSYCHO_Pragmatique"] = "Отступник",
        ["REG_PLAYER_PSYCHO_Rationnel"] = "Рациональный",
        ["REG_PLAYER_PSYCHO_Reflechi"] = "Осторожный",
        ["REG_PLAYER_PSYCHO_Rencunier"] = "Мстительный",
        ["REG_PLAYER_PSYCHO_Sincere"] = "Правдивый",
        ["REG_PLAYER_PSYCHO_SOCIAL"] = "Социальные черты",
        ["REG_PLAYER_PSYCHO_Trompeur"] = "Лживый",
        ["REG_PLAYER_PSYCHO_Valeureux"] = "Доблестный",
        ["REG_PLAYER_RACE"] = "Раса",
        ["REG_PLAYER_RACE_TT"] = "Здесь указывается раса персонажа. Не обязательно ограничиваться играбельными расами. В мире Warcraft есть много рас, обладающих схожими чертами.",
        ["REG_PLAYER_RESIDENCE"] = "Место жительства",
        ["REG_PLAYER_SHOWPSYCHO"] = "Отображать рамку характера",
        ["REG_PLAYER_STYLE_ASSIST"] = "Помощь в отыгрыше",
        ["REG_PLAYER_STYLE_FREQ_1"] = "Всегда в роли",
        ["REG_PLAYER_STYLE_FREQ_5"] = "Всегда вне роли, этот персонаж не для отыгрыша",
        ["REG_PLAYER_STYLE_GUILD"] = "Членство в гильдии",
        ["REG_PLAYER_TRP2_PIERCING"] = "Пирсинг",
        ["REG_PLAYER_TRP2_TATTOO"] = "Татуировки",
        ["REG_PLAYER_TRP2_TRAITS"] = "Облик",
        ["TB_SWITCH_HELM_1"] = "Отображать шлем",
        ["TB_SWITCH_HELM_2"] = "Скрыть шлем",
        ["TB_SWITCH_HELM_OFF"] = "Шлем: |cffff0000Скрыт",
        ["TB_SWITCH_HELM_ON"] = "Шлем: |cffff0000Показан",
        ["TF_OPEN_COMPANION"] = "Показать страницу спутника",
        ["UI_COLOR_BROWSER_SELECT"] = "Выбрать цвет",
        ["UI_FILTER"] = "Фильтер",
        ["UI_ICON_BROWSER_HELP"] = "Скопировать иконку",
        ["UI_ICON_SELECT"] = "Выбрать иконку",
        ["UI_IMAGE_BROWSER"] = "Обозреватель изображений",
        ["UI_IMAGE_SELECT"] = "Выбрать изображение",
        ["UI_LINK_TEXT"] = "Введите текст",
        ["UI_LINK_URL"] = "http://адрес_вашего_сайта",
        ["UI_MUSIC_BROWSER"] = "Обозреватель музыки",
        ["UI_MUSIC_SELECT"] = "Выбрать музыку",
        ["UI_TUTO_BUTTON"] = "Обучающий режим",
        ["UI_TUTO_BUTTON_TT"] = "Нажмите, чтобы включить/выключить режим обучения"
    }
    --@end-do-not-package@
};

TRP3_API.locale.registerLocale(LOCALE);