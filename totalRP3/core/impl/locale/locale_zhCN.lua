----------------------------------------------------------------------------------
-- Total RP 3
-- Simplified Chinese locale
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

-- "Chinese" to "Simplified Chinese" - Paul Corlay

local LOCALE = {
	locale = "zhCN",
	localeText = "Simplified Chinese",
    localeContent =
    --@localization(locale="zhCN", format="lua_table", handle-unlocalized="ignore")@
    --@do-not-package@
    {
        ["ABOUT_TITLE"] = "关于",
        ["BINDING_NAME_TRP3_TOGGLE"] = "Toggle主界面",
        ["BINDING_NAME_TRP3_TOOLBAR_TOGGLE"] = "Toggle工具栏",
        ["BW_COLOR_CODE"] = "颜色代码",
        ["BW_COLOR_CODE_ALERT"] = "错误的十六进制代码！",
        ["BW_COLOR_CODE_TT"] = "您可以在这里黏贴一个代表颜色的6位数十六进制代码， 然后按下回车。",
        ["CM_ACTIONS"] = "动作",
        ["CM_APPLY"] = "应用",
        ["CM_CANCEL"] = "取消",
        ["CM_CENTER"] = "中心",
        ["CM_CLASS_DEATHKNIGHT"] = "死亡骑士",
        ["CM_CLASS_DRUID"] = "德鲁伊",
        ["CM_CLASS_HUNTER"] = "猎人",
        ["CM_CLASS_MAGE"] = "法师",
        ["CM_CLASS_MONK"] = "武僧",
        ["CM_CLASS_PALADIN"] = "圣骑士",
        ["CM_CLASS_PRIEST"] = "牧师",
        ["CM_CLASS_ROGUE"] = "潜行者",
        ["CM_CLASS_SHAMAN"] = "萨满",
        ["CM_CLASS_UNKNOWN"] = "未知",
        ["CM_CLASS_WARLOCK"] = "术士",
        ["CM_CLASS_WARRIOR"] = "战士",
        ["CM_CLICK"] = "点击",
        ["CM_COLOR"] = "颜色",
        ["CM_CTRL"] = "Ctrl键",
        ["CM_DRAGDROP"] = "拖放",
        ["CM_EDIT"] = "编辑",
        ["CM_IC"] = "扮演中(IC)",
        ["CM_ICON"] = "图标",
        ["CM_IMAGE"] = "图片",
        ["CM_L_CLICK"] = "鼠标左键点击",
        ["CM_LEFT"] = "左边",
        ["CM_LINK"] = "链接",
        ["CM_LOAD"] = "读取",
        ["CM_MOVE_DOWN"] = "向下移动",
        ["CM_MOVE_UP"] = "向上移动",
        ["CM_NAME"] = "角色名",
        ["CM_OOC"] = "非扮演中(OOC)",
        ["CM_OPEN"] = "打开",
        ["CM_PLAY"] = "播放",
        ["CM_R_CLICK"] = "鼠标右键点击",
        ["CM_REMOVE"] = "移除",
        ["CM_RIGHT"] = "右边",
        ["CM_SAVE"] = "保存",
        ["CM_SELECT"] = "选取",
        ["CM_SHIFT"] = "Shift键",
        ["CM_SHOW"] = "显示",
        ["CM_STOP"] = "停止",
        ["CM_UNKNOWN"] = "未知",
        ["CM_VALUE"] = "值",
        ["CO_ANCHOR_BOTTOM"] = "下方",
        ["CO_ANCHOR_BOTTOM_LEFT"] = "左下方",
        ["CO_ANCHOR_BOTTOM_RIGHT"] = "右下方",
        ["CO_ANCHOR_LEFT"] = "左边",
        ["CO_ANCHOR_RIGHT"] = "右边",
        ["CO_ANCHOR_TOP"] = "上方",
        ["CO_ANCHOR_TOP_LEFT"] = "左上方",
        ["CO_ANCHOR_TOP_RIGHT"] = "右上方",
        ["CO_CHAT"] = "聊天栏设置",
        ["CO_CHAT_MAIN"] = "聊天栏主要设置",
        ["CO_CHAT_MAIN_COLOR"] = "为姓名使用自定义颜色",
        ["CO_CHAT_MAIN_EMOTE"] = "表情监测",
        ["CO_CHAT_MAIN_EMOTE_PATTERN"] = "表情监测类型",
        ["CO_CHAT_MAIN_EMOTE_USE"] = "使用表情方式",
        ["CO_CHAT_MAIN_EMOTE_YELL"] = "不允许喊叫表情",
        ["CO_CHAT_MAIN_EMOTE_YELL_TT"] = "不在喊叫时显示*表情*或<表情>",
        ["CO_CHAT_MAIN_NAMING"] = "命名方法",
        ["CO_CHAT_MAIN_NAMING_1"] = "使用原角色名",
        ["CO_CHAT_MAIN_NAMING_2"] = "使用自定角色名",
        ["CO_CHAT_MAIN_NAMING_3"] = "名+姓",
        ["CO_CHAT_MAIN_NPC"] = "NPC谈话监测",
        ["CO_CHAT_MAIN_NPC_PREFIX"] = "NPC谈话监测方式",
        ["CO_CHAT_MAIN_NPC_PREFIX_TT"] = "如果在说、表情、小队或团队频道的话有这个前缀，它会被认为是NPC谈话。默认：\"|| \"（请去掉“但是保留||后面的空格）",
        ["CO_CHAT_MAIN_NPC_USE"] = "开启NPC谈话监测",
        ["CO_CHAT_MAIN_OOC"] = "OOC监测",
        ["CO_CHAT_MAIN_OOC_COLOR"] = "OOC颜色",
        ["CO_CHAT_MAIN_OOC_PATTERN"] = "OOC监测方式",
        ["CO_CHAT_MAIN_OOC_USE"] = "开启OOC监测",
        ["CO_CHAT_USE"] = "已使用的频道",
        ["CO_CHAT_USE_SAY"] = "说",
        ["CO_CONFIGURATION"] = "设置",
        ["CO_GENERAL"] = "综合设置",
        ["CO_GENERAL_BROADCAST"] = "使用广播频道",
        ["CO_GENERAL_BROADCAST_C"] = "广播频道名",
        ["CO_GENERAL_CHANGELOCALE_ALERT"] = [=[是否现在重新加载以改变界面语言为%s？

 如果选择不重新加载，界面语言将在下次登录时改变。]=],
        ["CO_GENERAL_HEAVY"] = "档案容量警告",
        ["CO_GENERAL_HEAVY_TT"] = "当你的档案总大小超过一个合理值时你将收到一个警告。",
        ["CO_GENERAL_LOCALE"] = "插件文件位置",
        ["CO_GENERAL_MISC"] = "杂项",
        ["CO_GENERAL_NEW_VERSION"] = "更新提醒",
        ["CO_GENERAL_NEW_VERSION_TT"] = "可以进行更新时收到一个提醒",
        ["CO_GENERAL_UI_ANIMATIONS"] = "界面动画",
        ["CO_GENERAL_UI_ANIMATIONS_TT"] = "激活界面动画",
        ["CO_GENERAL_UI_SOUNDS"] = "界面音效",
        ["CO_GENERAL_UI_SOUNDS_TT"] = "激活界面音效（当打开窗口，切换选项卡，点击按键时）",
        ["CO_GLANCE_LOCK"] = "锁定栏",
        ["CO_GLANCE_LOCK_TT"] = "防止栏被拖动",
        ["COM_LIST"] = "命令列表：",
        ["COM_RESET_RESET"] = "界面位置已经被重置！",
        ["COM_RESET_USAGE"] = "通途：重置帧数。",
        ["COM_SWITCH_USAGE"] = "用途：重置帧数或者转换工具栏。",
        ["GEN_WELCOME_MESSAGE"] = "感谢您使用Total RP 3 (v %s)！祝您玩的开心！",
        ["REG_PLAYER_EYE"] = "眼睛的颜色",
        ["REG_PLAYER_FIRSTNAME"] = "名字",
        ["REG_PLAYER_FULLTITLE"] = "完整标题",
        ["TB_STATUS"] = "玩家",
        ["TB_SWITCH_CAPE_2"] = "隐藏披风",
        ["TB_SWITCH_HELM_1"] = "显示头盔",
        ["TB_SWITCH_HELM_2"] = "隐藏头盔",
        ["TB_SWITCH_TOOLBAR"] = "切换工具条",
        ["TB_TOOLBAR"] = "工具条",
        ["TF_IGNORE"] = "屏蔽玩家",
        ["TF_OPEN_CHARACTER"] = "显示角色页面",
        ["TF_PLAY_THEME"] = "扮演角色主题",
        ["UI_BKG"] = "背景 %s",
        ["UI_CLOSE_ALL"] = "关闭所有",
        ["UI_COLOR_BROWSER_SELECT"] = "选择颜色"
    }
    --@end-do-not-package@
};

TRP3_API.locale.registerLocale(LOCALE);