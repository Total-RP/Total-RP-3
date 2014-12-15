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
		ABOUT_TITLE = "Описание", -- Needs review
		BINDING_NAME_TRP3_TOGGLE = "Включить главное окно", -- Needs review
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Включить панель инструментов", -- Needs review
		BW_COLOR_CODE = "Код цвета", -- Needs review
		BW_COLOR_CODE_ALERT = "Неверный шестнадцатиричный код!", -- Needs review
		CM_ACTIONS = "Действия", -- Needs review
		CM_APPLY = "Применить", -- Needs review
		CM_CANCEL = "Отмена", -- Needs review
		CM_CENTER = "Центр", -- Needs review
		CM_CLASS_DEATHKNIGHT = "Рыцарь Смерти", -- Needs review
		CM_CLASS_DRUID = "Друид", -- Needs review
		CM_CLASS_HUNTER = "Охотник", -- Needs review
		CM_CLASS_MAGE = "Маг", -- Needs review
		CM_CLASS_MONK = "Монах", -- Needs review
		CM_CLASS_PALADIN = "Паладин", -- Needs review
		CM_CLASS_PRIEST = "Жрец", -- Needs review
		CM_CLASS_ROGUE = "Разбойник", -- Needs review
		CM_CLASS_SHAMAN = "Шаман", -- Needs review
		CO_ANCHOR_TOP = "Вверху", -- Needs review
		CO_ANCHOR_TOP_LEFT = "Слева вверху", -- Needs review
		CO_ANCHOR_TOP_RIGHT = "Справа вверху", -- Needs review
		CO_CHAT = "Настройки чата", -- Needs review
		CO_CHAT_MAIN = "Основные настройки чата", -- Needs review
		CO_CHAT_MAIN_COLOR = "Использовать особые цвета имен", -- Needs review
		CO_CHAT_MAIN_EMOTE = "Обнаружение эмоций", -- Needs review
		CO_CHAT_MAIN_EMOTE_PATTERN = "Шаблон обнаружения эмоций", -- Needs review
		CO_CHAT_MAIN_EMOTE_USE = "Использовать обнаружение эмоций", -- Needs review
		CO_GENERAL_CHANGELOCALE_ALERT = [=[Пегрегрузите интерфейс, чтобы изменить язык на %s прямо сейчас.
Или язык будет изменен при следующем входе в игру.]=], -- Needs review
		CO_GENERAL_COM = "Общение", -- Needs review
		GEN_WELCOME_MESSAGE = "Спасибо за выбор Total RP3 (v %s)! Приятной игры!", -- Needs review
	},
};

TRP3_API.locale.registerLocale(LOCALE);