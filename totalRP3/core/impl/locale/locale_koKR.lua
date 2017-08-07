----------------------------------------------------------------------------------
-- Total RP 3
-- Korean locale
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

-- Added Korean locale - Paul Corlay

local LOCALE = {
	locale = "koKR",
	localeText = "Korean",
    localeContent =
    --@localization(locale="koKR", format="lua_table", handle-unlocalized="ignore")@
    --@do-not-package@
    {
		["ABOUT_TITLE"] = "약",
		["BW_COLOR_CODE"] = "색상 코드",
		["BW_COLOR_CODE_ALERT"] = "잘못된 16 진수 코드!",
		["CM_ACTIONS"] = "행위",
		["CM_APPLY"] = "적용",
		["CM_CANCEL"] = "취소",
		["CM_CENTER"] = "센터",
		["CM_CLASS_DEATHKNIGHT"] = "죽음의 기사 ",
		["CM_CLASS_DRUID"] = "드루이드 ",
		["CM_CLASS_HUNTER"] = "사냥꾼",
		["CM_CLASS_MAGE"] = "마법사 ",
		["CM_CLASS_MONK"] = "수도사",
		["CM_CLASS_PALADIN"] = "성기사",
		["CM_CLASS_PRIEST"] = "사제",
		["CM_CLASS_ROGUE"] = "도적",
		["CM_CLASS_SHAMAN"] = "주술사 ",
		["CM_CLASS_UNKNOWN"] = "알 수없는",
		["CM_CLASS_WARLOCK"] = "흑마법사",
		["CM_CLASS_WARRIOR"] = "전사 ",
		["CM_CLICK"] = "클릭",
		["CM_COLOR"] = "색",
		["CM_DRAGDROP"] = "끌어서 놓기",
		["CM_ICON"] = "아이콘",
		["CM_IMAGE"] = "영상",
		["CM_LEFT"] = "왼쪽",
		["CM_LINK"] = "링크",
		["CM_NAME"] = "이름",
		["CM_RIGHT"] = "권리",
		["CM_UNKNOWN"] = "알 수없는",
		["CO_ANCHOR_LEFT"] = "왼쪽",
		["CO_ANCHOR_RIGHT"] = "권리",
		["COM_LIST"] = "명령의 목록:",
		["GEN_WELCOME_MESSAGE"] = "Total RP 3 (v %s)를 사용하여 주셔서 감사합니다! 재미를!"
	}
    --@end-do-not-package@
};

TRP3_API.locale.registerLocale(LOCALE);