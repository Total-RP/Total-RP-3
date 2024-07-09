-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- THIS FILE IS AUTOMATICALLY GENERATED.
-- ALL MODIFICATIONS TO THIS FILE WILL BE LOST.

local _, TRP3_API = ...;

local L;

L = {
	["ABOUT_TITLE"] = "關於",
	["BINDING_NAME_TRP3_TOGGLE"] = "開啟主頁面",
	["BINDING_NAME_TRP3_TOOLBAR_TOGGLE"] = "開啟工具欄",
	["BROADCAST_10"] = "|cffff9900你已經加入了十個頻道，Total RP 3 無法將您連接到廣播頻道，且無法使用地圖上顯示玩家位置的功能。",
	["BROADCAST_OFFLINE_DISABLED"] = "廣播頻道無法使用。",
	["BROADCAST_PASSWORD"] = [=[|cffff0000廣播頻道被設置了密碼 (%s).
|cffff9900Total RP 3不會繼續嘗試連結到廣播頻道，你將無法使用地圖顯示玩家位置的功能。
|cff00ff00你可以在一般設定中關閉或修改廣播頻道。]=],
	["BROADCAST_PASSWORDED"] = [=[|cffff0000玩家|r %s |cffff0000剛剛修改了廣播頻道的密碼 (%s).
|cffff9900如果你不知道密碼，你將無法使用顯示地圖上玩家的功能。]=],
	["BW_COLOR_CODE"] = "顏色代碼",
	["BW_COLOR_CODE_ALERT"] = "十六進制碼錯誤",
	["BW_COLOR_CODE_TT"] = "您可以在這裡貼上6位數的十六進制顏色代碼，然後按Enter。",
	["BW_COLOR_PRESET_SAVE"] = "儲存目前顏色",
	["BW_COLOR_PRESET_TITLE"] = "顏色預覽",
	["BW_CUSTOM_NAME"] = "設計名稱的顏色",
	["CL_DOWNLOADING"] = "下載中： %0.1f %%",
	["CL_GLANCE"] = "第一印象",
	["CL_IMPORT_COMPANION"] = "匯入夥伴檔案",
	["CL_IMPORT_GLANCE"] = "匯入第一印象",
	["CL_IMPORT_PROFILE"] = "匯入角色檔案",
	["CL_MAKE_IMPORTABLE_BUTTON_TEXT"] = "可傳輸的連結",
	["CL_MAKE_IMPORTABLE_SIMPLER"] = [=[您確定要傳輸 %s 的檔案？
其他玩家將可以複製並使用此連結的內容。]=],
	["CL_MAKE_NON_IMPORTABLE"] = "僅可觀看",
	["CL_OPEN_COMPANION"] = "開啟夥伴檔案",
	["CL_OPEN_PROFILE"] = "開啟檔案",
	["CL_PLAYER_PROFILE"] = "玩家檔案",
	["CL_TOOLTIP"] = "於對話欄產生連結",
	["CM_ACTIONS"] = "動作",
	["CM_ALT"] = "Alt",
	["CM_APPLY"] = "套用",
	["CM_BLACK"] = "黑色",
	["CM_BLUE"] = "藍色",
	["CM_CANCEL"] = "取消",
	["CM_CENTER"] = "中心",
	["CM_CLASS_DEATHKNIGHT"] = "死亡騎士",
	["CM_CLASS_DRUID"] = "德魯伊",
	["CM_CLASS_HUNTER"] = "獵人",
	["CM_CLASS_MAGE"] = "法師",
	["CM_CLASS_MONK"] = "武僧",
	["CM_CLASS_PALADIN"] = "聖騎士",
	["CM_CLASS_PRIEST"] = "牧師",
	["CM_CLASS_ROGUE"] = "盜賊",
	["CM_CLASS_SHAMAN"] = "薩滿",
	["CM_CLASS_UNKNOWN"] = "未知",
	["CM_CLASS_WARLOCK"] = "術士",
	["CM_CLASS_WARRIOR"] = "戰士",
	["CM_CLICK"] = "點擊",
	["CM_COLOR"] = "顏色",
	["CM_CTRL"] = "Ctrl",
	["CM_CYAN"] = "青色",
	["CM_DELETE"] = "刪除",
	["CM_DOUBLECLICK"] = "雙擊",
	["CM_DRAGDROP"] = "拖曳＆丟棄",
	["CM_EDIT"] = "編輯",
	["CM_GREEN"] = "綠色",
	["CM_GREY"] = "灰色",
	["CM_IC"] = "IC（進入角色）",
	["CM_ICON"] = "圖標",
	["CM_IMAGE"] = "圖像",
	["CM_L_CLICK"] = "左鍵點擊",
	["CM_LEFT"] = "左",
	["CM_LINK"] = "連結",
	["CM_LOAD"] = "載入",
	["CM_M_CLICK"] = "中鍵點擊",
	["CM_MOVE_DOWN"] = "下移",
	["CM_MOVE_UP"] = "上移",
	["CM_NAME"] = "名稱",
	["CM_OOC"] = "OOC（脫離角色）",
	["CM_OPEN"] = "打開",
	["CM_ORANGE"] = "橘色",
	["CM_PINK"] = "粉紅色",
	["CM_PLAY"] = "播放",
	["CM_PURPLE"] = "紫色",
	["CM_R_CLICK"] = "右鍵點擊",
	["CM_RED"] = "紅色",
	["CM_REMOVE"] = "清除",
	["CM_RESET"] = "重置",
	["CM_RESIZE"] = "調整尺寸",
	["CM_RESIZE_TT"] = "拖曳以縮放視窗大小。",
	["CM_RIGHT"] = "右",
	["CM_SAVE"] = "儲存",
	["CM_SELECT"] = "選擇",
	["CM_SHIFT"] = "Shift",
	["CM_SHOW"] = "顯示",
	["CM_STOP"] = "停止",
	["CM_TWEET"] = "發送推特",
	["CM_TWEET_PROFILE"] = "顯示推特資料網址",
	["CM_UNKNOWN"] = "不明",
	["CM_VALUE"] = "值",
	["CM_WHITE"] = "白色",
	["CM_YELLOW"] = "黃色",
	["CO_ADVANCED_SETTINGS"] = "進階設定",
	["CO_ADVANCED_SETTINGS_RESET"] = "重設進階設定",
	["CO_ADVANCED_SETTINGS_RESET_TT"] = "當調整後出現問題時，使用重設，回到默認設定。",
	["CO_ANCHOR_BOTTOM"] = "下方",
	["CO_ANCHOR_BOTTOM_LEFT"] = "左下方",
	["CO_ANCHOR_BOTTOM_RIGHT"] = "右下方",
	["CO_ANCHOR_CURSOR"] = "顯示游標",
	["CO_ANCHOR_LEFT"] = "左側",
	["CO_ANCHOR_RIGHT"] = "右側",
	["CO_ANCHOR_TOP"] = "上方",
	["CO_ANCHOR_TOP_LEFT"] = "左上方",
	["CO_ANCHOR_TOP_RIGHT"] = "右上方",
	["CO_CHAT"] = "聊天設定",
	["CO_CHAT_DISABLE_OOC"] = "當OOC時停止適用",
	["CO_CHAT_DISABLE_OOC_TT"] = "當你設定為「脫離角色」，Total RP 3 的設定（包括角色名稱、情感偵測、NPC對話等）將不再適用。",
	["CO_CHAT_INCREASE_CONTRAST"] = "增強顏色對比",
	["CO_CHAT_INSERT_FULL_RP_NAME"] = "按下「shift - 左鍵」插入RP名字",
	["CO_CHAT_INSERT_FULL_RP_NAME_TT"] = [=[當你使用SHIFT + 點擊聊天欄的名字時，於輸入列出現完整角色名稱。

（啟用此選項時，您仍然可以使用ALT + SHIFT + 點擊來輸入原始角色名稱。）]=],
	["CO_CHAT_MAIN"] = "聊天室主設定",
	["CO_CHAT_MAIN_COLOR"] = "顯示角色名稱客制化顏色",
	["CO_CHAT_MAIN_EMOTE"] = "表情偵測",
	["CO_CHAT_MAIN_EMOTE_PATTERN"] = "表情偵測模式",
	["CO_CHAT_MAIN_EMOTE_USE"] = "使用表情偵測",
	["CO_CHAT_MAIN_EMOTE_YELL"] = "不允許大喊表情",
	["CO_CHAT_MAIN_EMOTE_YELL_TT"] = "大喊時，不顯示*表情* 或 <表情>",
	["CO_CHAT_MAIN_NAMING"] = "名稱顯示方式",
	["CO_CHAT_MAIN_NAMING_1"] = "沿用原始名稱",
	["CO_CHAT_MAIN_NAMING_2"] = "使用角色扮演名稱",
	["CO_CHAT_MAIN_NAMING_3"] = "名字＋姓氏",
	["CO_CHAT_MAIN_NAMING_4"] = "短稱號＋名字＋姓氏",
	["CO_CHAT_MAIN_NPC"] = "ＮＰＣ對話偵測",
	["CO_CHAT_MAIN_NPC_PREFIX"] = "ＮＰＣ對話偵測模式",
	["CO_CHAT_MAIN_NPC_PREFIX_TT"] = [=[如果對話以EMOTE為字首頻道時，將被解讀為ＮＰＣ對話。

|cff00ff00By default : "|| "
（除了 " 符號，並在管狀符號後方加上空格。）|r]=],
	["CO_CHAT_MAIN_NPC_USE"] = "使用ＮＰＣ對話判讀",
	["CO_CHAT_MAIN_OOC"] = "ＯＯＣ判讀",
	["CO_CHAT_MAIN_OOC_COLOR"] = "ＯＯＣ顏色",
	["CO_CHAT_MAIN_OOC_PATTERN"] = "ＯＯＣ判讀模式",
	["CO_CHAT_MAIN_OOC_USE"] = "使用ＯＯＣ判讀",
	["CO_CHAT_REMOVE_REALM"] = "移除角色名稱當中的伺服器名稱",
	["CO_CHAT_USE"] = "使用聊天頻道",
	["CO_CHAT_USE_ICONS"] = "顯示玩家圖示",
	["CO_CHAT_USE_SAY"] = "對話頻道",
	["CO_CONFIGURATION"] = "設定",
	["CO_CURSOR_RIGHT_CLICK"] = "右鍵點擊開啟",
	["CO_GENERAL"] = "一般設定",
	["CO_GENERAL_BROADCAST"] = "使用廣播頻道",
	["CO_GENERAL_BROADCAST_C"] = "廣播頻道名稱",
	["CO_GENERAL_BROADCAST_TT"] = "廣播頻道和許多功能連結。禁用廣播功能將連帶禁用所有功能，例如顯示玩家在地圖上的位置、播放範圍音效、藏物處等…",
	["CO_GENERAL_CHANGELOCALE_ALERT"] = [=[立即重新登入介面來切換為 %s 語言選項嗎？

如果不要，語言選項將會在下次登入時變更。]=],
	["CO_GENERAL_COM"] = "訊息",
	["CO_GENERAL_HEAVY"] = "檔案容量警告",
	["CO_GENERAL_HEAVY_TT"] = "當你的檔案容量大小超過合理值時給予警示。",
	["CO_GENERAL_LOCALE"] = "插件本地化選擇",
	["CO_GENERAL_MISC"] = "雜項",
	["CO_GENERAL_NEW_VERSION"] = "版本昇級提示",
	["CO_GENERAL_NEW_VERSION_TT"] = "當有新版本釋出時提醒我",
	["CO_GENERAL_TT_SIZE"] = "工具列字型大小",
	["CO_GENERAL_UI_ANIMATIONS"] = "插件動畫",
	["CO_GENERAL_UI_ANIMATIONS_TT"] = "啟用插件動畫",
	["CO_GENERAL_UI_SOUNDS"] = "插件音效",
	["CO_GENERAL_UI_SOUNDS_TT"] = "啟用插件音效（當開啟視窗、切換標籤或點擊按鍵時。）。",
	["CO_GLANCE_LOCK"] = "鎖定第一印象欄",
	["CO_GLANCE_LOCK_TT"] = "避免第一印象欄被拖曳",
	["CO_GLANCE_MAIN"] = "\"第一印象\"欄",
	["CO_GLANCE_PRESET_TRP2"] = "使用Total RP 2 風格的介面設置",
	["CO_GLANCE_PRESET_TRP2_BUTTON"] = "套用",
	["CO_GLANCE_PRESET_TRP2_HELP"] = "使你能快速套用ＴＲＰ２風格的設定。",
	["CO_GLANCE_PRESET_TRP3"] = "使用Total RP 3 風格的介面設置",
	["CO_GLANCE_PRESET_TRP3_HELP"] = "快速更改你的工具列為TRP3的風格。",
	["CO_GLANCE_RESET_TT"] = "將工具列的位置重置回左側錨點。",
	["CO_GLANCE_TT_ANCHOR"] = "工具欄錨點",
	["CO_LOCATION"] = "位置設定",
	["CO_LOCATION_ACTIVATE"] = "允許公開角色位置",
	["CO_LOCATION_ACTIVATE_TT"] = "啟動腳色位置系統，允許你在小地圖上掃描其他玩家、並讓他們也能找到你。",
	["CO_LOCATION_DISABLE_OOC"] = "脫離腳色（ＯＯＣ）時不顯示位置",
	["CO_LOCATION_DISABLE_OOC_TT"] = "當你將角色狀態設定為脫離角色（ＯＯＣ）時，將不會響應您的角色位置搜索功能。",
	["CO_LOCATION_DISABLE_WAR_MODE"] = "戰爭模式中不顯示角色位置",
	["CO_MAP_BUTTON"] = "地圖掃描鍵",
	["CO_MAP_BUTTON_POS"] = "地圖掃描鍵錨點",
	["CO_MINIMAP_BUTTON"] = "小地圖鍵",
	["CO_MINIMAP_BUTTON_FRAME"] = "框架錨點",
	["CO_MINIMAP_BUTTON_RESET"] = "重置座標",
	["CO_MINIMAP_BUTTON_RESET_BUTTON"] = "重置",
	["CO_MINIMAP_BUTTON_SHOW_HELP"] = [=[如果您正使用其他插件來展示Total RP 3的小地圖按鍵，例如（FuBar, Titan, Bazooka）你可以關閉原始小地圖上的按鍵。

|cff00ff00Reminder : 你可以使用指令 /trp3 來開啟Total RP 3的切換|r]=],
	["CO_MINIMAP_BUTTON_SHOW_TITLE"] = "顯示小地圖按鈕",
	["CO_MODULES"] = "插件狀態",
	["CO_MODULES_DISABLE"] = "停用插件",
	["CO_MODULES_ENABLE"] = "運行插件",
	["CO_MODULES_ID"] = "插件ID：%s",
	["CO_MODULES_SHOWERROR"] = "錯誤顯示",
	["CO_MODULES_STATUS"] = "狀態：%s",
	["CO_MODULES_STATUS_0"] = "關聯插件遺失",
	["CO_MODULES_STATUS_1"] = "載入中",
	["CO_MODULES_STATUS_2"] = "無法運作",
	["CO_MODULES_STATUS_3"] = "需要更新 Total RP 3",
	["CO_MODULES_STATUS_4"] = "初始化時發生錯誤",
	["CO_MODULES_STATUS_5"] = "啟動時發生錯誤",
	["CO_MODULES_TT_DEP"] = "%s- %s (版本 %s)|r",
	["CO_MODULES_TT_DEPS"] = "關聯插件",
	["CO_MODULES_TT_ERROR"] = [=[|cffff0000錯誤:|r
%s]=],
	["CO_MODULES_TT_NONE"] = "無關聯性插件",
	["CO_MODULES_TUTO"] = [=[插件可以獨立開啟或關閉，以下是常見的狀況：

|cff00ff00載入中:|r 插件已經載入並且正常執行。
|cff999999無法運作:|r 插件已經停用。
|cffff9900關聯插件遺失:|r 某些具關聯性的插件還沒運作。
|cffff9900需要更新 Total RP 3:|r 此插件需要更高版本的Total RP 3支援。
|cffff0000啟動時或初始化時發生錯誤:|r 此插件在初始化時出現錯誤，有可能造成更多問題。

|cnGREEN_FONT_COLOR:停用插件後，必須重新啟動遊戲。|r]=],
	["CO_MODULES_VERSION"] = "版本: %s",
	["CO_MSP"] = "Mary Sue 協議",
	["CO_REGISTER"] = "資訊設定",
	["CO_REGISTER_AUTO_PURGE"] = "自動清理目錄",
	["CO_REGISTER_AUTO_PURGE_0"] = "不清除",
	["CO_REGISTER_AUTO_PURGE_1"] = "%s 天之後清除",
	["CO_REGISTER_AUTO_PURGE_TT"] = [=[自動清除目錄中特定時間內的角色檔案，你可以選擇該時間的長短。

|cnGREEN_FONT_COLOR:備註：跟你有特殊關係的角色將永遠不會被清除。|r

|cnWARNING_FONT_COLOR:當你的資料數量達到一定的極限值時，魔獸世界會自動清除所有資料，所以我們強烈建議你不要關閉此選項。|r]=],
	["CO_SANITIZER"] = "整理接收的角色資訊",
	["CO_SANITIZER_TT"] = "清除接收的資訊中不被你的設定所允許的部分。（色彩、圖像等…）",
	["CO_TARGETFRAME"] = "目標欄位設定",
	["CO_TARGETFRAME_ICON_SIZE"] = "圖示大小",
	["CO_TARGETFRAME_USE"] = "顯示條件",
	["CO_TARGETFRAME_USE_1"] = "總是顯示",
	["CO_TARGETFRAME_USE_2"] = "只有進入角色（IC）時顯示",
	["CO_TARGETFRAME_USE_3"] = "永不顯示（停用）",
	["CO_TARGETFRAME_USE_TT"] = "選擇你想在什麼情況下顯示對方的角色卡。",
	["CO_TOOLBAR_CONTENT"] = "工具列設定",
	["CO_TOOLBAR_CONTENT_RPSTATUS"] = "角色狀態（IC／OOC）",
	["CO_TOOLBAR_CONTENT_STATUS"] = "玩家狀態（離開／請勿打擾）",
	["CO_TOOLBAR_ICON_SIZE"] = "圖示尺寸",
	["CO_TOOLBAR_MAX"] = "單行圖示最大數量",
	["CO_TOOLBAR_MAX_TT"] = "如果你希望工具列是垂直的，將本數值設定為１！",
	["CO_TOOLBAR_SHOW_ON_LOGIN"] = "登入時顯示工具欄。",
	["CO_TOOLBAR_SHOW_ON_LOGIN_HELP"] = "如果你不希望登入時就顯示工具欄，可以取消此選項。",
	["CO_TOOLTIP"] = "提示欄設定",
	["CO_TOOLTIP_ANCHOR"] = "顯示位置",
	["CO_TOOLTIP_ANCHORED"] = "提示欄座標對應欄位",
	["CO_TOOLTIP_CHARACTER"] = "角色卡提示欄",
	["CO_TOOLTIP_CLIENT"] = "顯示伺服器",
	["CO_TOOLTIP_COLOR"] = "顯示自訂顏色",
	["CO_TOOLTIP_COMBAT"] = "戰鬥中隱藏欄位",
	["CO_TOOLTIP_COMMON"] = "共通設定",
	["CO_TOOLTIP_CONTRAST"] = "增加顏色對比",
	["CO_TOOLTIP_CONTRAST_TT"] = "當你使用自訂顏色時，增加顏色對比可以避免選擇了太暗的顏色。",
	["CO_TOOLTIP_CROP_TEXT"] = "剪裁不合理的過長文本",
	["CO_TOOLTIP_CROP_TEXT_TT"] = [=[角色卡提示欄中各欄位的字數有限，避免產生過長的情況。

|cnGREEN_FONT_COLOR:各欄位限制：
名稱：100單位
稱號：150單位
種族：50單位
職業：50單位|r]=],
	["CO_TOOLTIP_CURRENT"] = "顯示其他資訊",
	["CO_TOOLTIP_CURRENT_SIZE"] = "其他資訊的最大長度",
	["CO_TOOLTIP_FT"] = "顯示完整稱號",
	["CO_TOOLTIP_GUILD"] = "顯示公會內容",
	["CO_TOOLTIP_HIDE_ORIGINAL"] = "隱藏遊戲內建提示欄",
	["CO_TOOLTIP_ICONS"] = "顯示圖示",
	["CO_TOOLTIP_IN_CHARACTER_ONLY"] = "脫離角色（OOC）時隱藏",
	["CO_TOOLTIP_MAINSIZE"] = "主要文字尺寸",
	["CO_TOOLTIP_NO_FADE_OUT"] = "立即隱藏取代淡出效果",
	["CO_TOOLTIP_NOTIF"] = "顯示提示",
	["CO_TOOLTIP_NOTIF_TT"] = "當同伺服器的對象玩家有未讀的資訊時，顯示驚嘆號通知圖示。",
	["CO_TOOLTIP_OWNER"] = "顯示主人",
	["CO_TOOLTIP_PETS"] = "夥伴提示欄",
	["CO_TOOLTIP_PETS_INFO"] = "顯示夥伴資訊",
	["CO_TOOLTIP_PROFILE_ONLY"] = "只有目標有檔案時才顯示",
	["CO_TOOLTIP_RACE"] = "顯示種族、職業及等級",
	["CO_TOOLTIP_REALM"] = "顯示伺服器",
	["CO_TOOLTIP_RELATION"] = "顯示關係對應顏色",
	["CO_TOOLTIP_RELATION_TT"] = "將角色卡欄位的邊框設定為關係對應顏色",
	["CO_TOOLTIP_SPACING"] = "保持空隙",
	["CO_TOOLTIP_SPACING_TT"] = "提示欄中的文句之間保持空隙，以便閱讀。",
	["CO_TOOLTIP_SUBSIZE"] = "二級字體尺寸",
	["CO_TOOLTIP_TARGET"] = "顯示目標",
	["CO_TOOLTIP_TERSIZE"] = "三級字體尺寸",
	["CO_TOOLTIP_TITLE"] = "顯示頭銜",
	["CO_TOOLTIP_USE"] = "使用角色／夥伴欄位",
	["CO_WIM"] = "|cffff9900停用悄悄話頻道。",
	["COM_LIST"] = "指令表",
	["COM_RESET_RESET"] = "欄位的座標已經重置！",
	["DB_ABOUT"] = "關於 Total RP 3",
	["DB_HTML_GOTO"] = "點擊開啟",
	["DB_MORE"] = "更多相關插件",
	["DB_NEW"] = "最新消息",
	["DB_STATUS"] = "狀態列",
	["DB_STATUS_CURRENTLY"] = "當前活動",
	["DB_STATUS_CURRENTLY_COMMON"] = "這些狀態也會顯示在你的角色卡欄位，Keep it clear and brief as |cffff9900by default TRP3 players will only see the first 140 characters of them!",
	["DB_STATUS_CURRENTLY_OOC"] = "其他資訊（OOC）",
	["DB_STATUS_RP"] = "角色狀態",
	["DB_STATUS_RP_IC"] = "進入角色（IC）",
	["DB_STATUS_RP_OOC"] = "脫離角色（OOC）",
	["DB_TUTO_1"] = [=[|cffffff00角色狀態|r 指示你是進入角色還是脫離角色扮演的狀態。

|cffffff00扮演程度|r 顯示你是菜鳥、老鳥還是志願的教學者。

|cff00ff00這些資訊都會在你的角色卡欄位中顯示。|r]=],
	["DICE_HELP"] = "骰子可以藉由代數（xdy）來進行設定，例如：1d6／2d12／3d20…等等。代表擲x次有y面的骰子，像是1d20就是丟1次20面骰。",
	["DICE_ROLL"] = "%s 擲出了 |cffff9900%sx d%s|r|cffcc6600%s|r 並得到 |cff00ff00%s|r。",
	["DICE_ROLL_T"] = "%s %s 擲出了 |cffff9900%sx d%s|r|cffcc6600%s|r 並得到 |cff00ff00%s|r。",
	["DICE_TOTAL"] = "%s 在這次擲骰中得到 |cff00ff00%s|r 的總數。",
	["DICE_TOTAL_T"] = "%s %s 在這次擲骰中得到 |cff00ff00%s|r 的總數。",
	["DTBK_AFK"] = "Total RP 3 - 離開／請勿打擾",
	["DTBK_CLOAK"] = "Total RP 3 - 斗篷",
	["DTBK_HELMET"] = "Total RP 3 - 頭盔",
	["DTBK_LANGUAGES"] = "Total RP 3 - 語言",
	["DTBK_RP"] = "Total RP 3 - IC／OOC",
	["GEN_VERSION"] = "版本：%s（第%s次更新）",
	["GEN_WELCOME_MESSAGE"] = "感謝您使用Total RP 3  (v %s) ! 祝您玩得開心!",
	["MAP_BUTTON_NO_SCAN"] = "無可用掃描",
	["MAP_BUTTON_SCANNING"] = "掃描中",
	["MAP_BUTTON_SUBTITLE"] = "點擊以顯示可用搜尋",
	["MAP_BUTTON_TITLE"] = "角色扮演搜尋器",
	["MAP_SCAN_CHAR"] = "搜尋本地角色",
	["MAP_SCAN_CHAR_TITLE"] = "角色",
	["MM_SHOW_HIDE_MAIN"] = "顯示／隱藏主視窗",
	["MM_SHOW_HIDE_MOVE"] = "移動此圖示",
	["MM_SHOW_HIDE_SHORTCUT"] = "顯示／隱藏插件工具列",
	["NPC_TALK_BUTTON_TT"] = "開啟NPC speech欄位來允許你使用NPC對話或表情的功能。",
	["NPC_TALK_CHANNEL"] = "頻道:",
	["NPC_TALK_COMMAND_HELP"] = "開啟NPC speech欄。",
	["NPC_TALK_ERROR_EMPTY_MESSAGE"] = "訊息不能為空白。",
	["NPC_TALK_MESSAGE"] = "訊息",
	["NPC_TALK_NAME"] = "NPC名稱",
	["NPC_TALK_NAME_TT"] = "你可以直接用指令 %t 來顯示目標名稱，也可以留白來書寫無名稱的旁白。",
	["NPC_TALK_SAY_PATTERN"] = "說：",
	["NPC_TALK_SEND"] = "送出",
	["NPC_TALK_TITLE"] = "NPC發話（NPC speech）",
	["NPC_TALK_WHISPER_PATTERN"] = "悄悄地說：",
	["NPC_TALK_YELL_PATTERN"] = "大喊：",
	["PATTERN_ERROR"] = "模組錯誤。",
	["PR_CO_BATTLE"] = "戰寵",
	["PR_CO_COUNT"] = "%s 寵物／坐騎綁定此角色檔案。",
	["PR_CO_EMPTY"] = "無夥伴角色檔",
	["PR_CO_MASTERS"] = "主人",
	["PR_CO_MOUNT"] = "坐騎",
	["PR_CO_NEW_PROFILE"] = "新夥伴檔案",
	["PR_CO_PET"] = "寵物",
	["PR_CO_PROFILE_DETAIL"] = "此檔案目前綁定在",
	["PR_CO_PROFILEMANAGER_TITLE"] = "夥伴檔案",
	["PR_CO_UNUSED_PROFILE"] = "此角色檔目前並無綁定在任何寵物和坐騎上。",
	["PR_CREATE_PROFILE"] = "創作角色檔",
	["PR_DELETE_PROFILE"] = "刪除角色檔",
	["PR_DUPLICATE_PROFILE"] = "複製角色檔",
	["PR_EXPORT_IMPORT_TITLE"] = "匯入／匯出檔案",
	["PR_EXPORT_PROFILE"] = "輸出角色檔",
	["PR_EXPORT_TOO_LARGE"] = [=[此角色檔容量太大以致於無法輸出。

角色檔容量: %0.2f kB
最大: 20 kB]=],
	["PR_IMPORT"] = "匯入",
	["PR_IMPORT_CHAR_TAB"] = "角色輸入器",
	["PR_IMPORT_EMPTY"] = "無法輸入角色檔",
	["PR_IMPORT_IMPORT_ALL"] = "輸入全部",
	["PR_IMPORT_PETS_TAB"] = "夥伴輸入器",
	["PR_IMPORT_PROFILE"] = "輸入角色檔",
	["PR_PROFILE"] = "角色檔",
	["PR_PROFILE_CREATED"] = "角色檔 %s 已經建立。",
	["PR_PROFILE_DELETED"] = "角色檔 %s 已經刪除。",
	["PR_PROFILE_DETAIL"] = "此角色檔目前被綁定在這些角色上",
	["PR_PROFILE_LOADED"] = "檔案%s已載入。",
	["PR_PROFILE_MANAGEMENT_TITLE"] = "檔案管理",
	["PR_PROFILEMANAGER_ACTIONS"] = "動作",
	["PR_PROFILEMANAGER_ALREADY_IN_USE"] = "檔案名稱%s不被允許。",
	["PR_PROFILEMANAGER_COUNT"] = "%s個遊戲角色綁定於此檔案。",
	["PR_PROFILEMANAGER_CREATE_POPUP"] = "請替你的新角色檔案命名，檔案名稱不能為空白。",
	["PR_PROFILEMANAGER_CURRENT"] = "當前使用檔案",
	["PR_PROFILEMANAGER_DELETE_WARNING"] = [=[你確定你要刪除檔案%s嗎？

此動作無法被返回！而且所有跟此檔案有關聯的資訊都會被銷毀！（設定內容、道具等等任何與此檔案綁定的資訊。）]=],
	["PR_PROFILEMANAGER_DUPP_POPUP"] = [=[請替您要複製的新檔案命名，
此名稱不可為空白。

此檔案不會影響已綁定原檔 %s 的角色。]=],
	["PR_PROFILEMANAGER_EDIT_POPUP"] = [=[請替您要複製的新檔案命名，
此名稱不可為空白。

改變名稱並不會連動改變角色與檔案之間的綁定關係。]=],
	["PR_PROFILEMANAGER_IMPORT_WARNING"] = "使用匯入的檔案來取代 %s 原有的內容嗎？",
	["PR_PROFILEMANAGER_IMPORT_WARNING_2"] = [=[警告：此檔案來自較舊版的TRP3，可能會有不相容的情況。

仍然要以匯入的檔案來取代 %s 的內容嗎？]=],
	["PR_PROFILEMANAGER_RENAME"] = "重新命名",
	["PR_PROFILEMANAGER_SWITCH"] = "選擇檔案",
	["PR_PROFILEMANAGER_TITLE"] = "角色檔案",
	["PR_PROFILES"] = "檔案",
	["PR_UNUSED_PROFILE"] = "此檔案當前並未綁定至任何角色。",
	["REG_COMPANION_BOUND_TO"] = "連結至…",
	["REG_COMPANION_BOUND_TO_TARGET"] = "目標",
	["REG_COMPANION_BOUNDS"] = "連結",
	["REG_COMPANION_BROWSER_BATTLE"] = "戰寵瀏覽器",
	["REG_COMPANION_BROWSER_MOUNT"] = "坐騎瀏覽器",
	["REG_COMPANION_INFO"] = "資訊",
	["REG_COMPANION_LINKED"] = "夥伴 %s 現在已經連結到檔案 %s。",
	["REG_COMPANION_LINKED_NO"] = "夥伴 %s 目前沒有和任何檔案連結。",
	["REG_COMPANION_NAME"] = "名稱",
	["REG_COMPANION_NAME_COLOR"] = "名稱顏色",
	["REG_COMPANION_TF_CREATE"] = "創建新角色擋",
	["REG_COMPANION_TF_OWNER"] = "擁有者：%s",
	["REG_COMPANION_TITLE"] = "標題",
	["REG_COMPANIONS"] = "夥伴",
	["REG_DELETE_WARNING"] = [=[你確定你要刪除 %s 的角色檔？
]=],
	["REG_IGNORE_TOAST"] = "角色已被屏蔽",
	["REG_LIST_CHAR_EMPTY"] = "無角色",
	["REG_LIST_CHAR_EMPTY2"] = "沒有角色符合搜尋結果",
	["REG_LIST_CHAR_IGNORED"] = "忽略",
	["REG_LIST_CHAR_SEL"] = "選擇角色",
	["REG_LIST_CHAR_TITLE"] = "角色列表",
	["REG_LIST_CHAR_TT_GLANCE"] = "第一印象",
	["REG_LIST_CHAR_TT_IGNORE"] = "已忽略的角色",
	["REG_LIST_GUILD"] = "角色公會",
	["REG_LIST_IGNORE_EMPTY"] = "無已忽略的角色",
	["REG_LIST_IGNORE_TITLE"] = "忽略名單",
	["REG_LIST_NAME"] = "角色名稱",
	["REG_LIST_PET_MASTER"] = "主人名稱",
	["REG_LIST_PET_NAME"] = "夥伴名稱",
	["REG_LIST_PET_TYPE"] = "夥伴類型",
	["REG_LIST_PETS_EMPTY"] = "沒有夥伴",
	["REG_LIST_PETS_EMPTY2"] = "沒有夥伴符合搜尋結果",
	["REG_LIST_PETS_TITLE"] = "夥伴列表",
	["REG_LIST_REALMONLY"] = "僅顯示同伺服器",
	["REG_PLAYER"] = "角色",
	["REG_PLAYER_ABOUT"] = "關於",
	["REG_PLAYER_ABOUT_ADD_FRAME"] = "新增欄位",
	["REG_PLAYER_ABOUT_EMPTY"] = "無敘述",
	["REG_PLAYER_ABOUT_MUSIC_LISTEN"] = "播放主題曲",
	["REG_PLAYER_ABOUT_MUSIC_REMOVE"] = "取消已選擇的主題曲",
	["REG_PLAYER_ABOUT_MUSIC_SELECT"] = "選擇角色主題曲",
	["REG_PLAYER_ABOUT_MUSIC_SELECT2"] = "選擇主題曲",
	["REG_PLAYER_ABOUT_MUSIC_STOP"] = "停止播放主題曲",
	["REG_PLAYER_ABOUT_MUSIC_THEME"] = "角色主題曲",
	["REG_PLAYER_ABOUT_NOMUSIC"] = "|cffff9900沒有主題曲|r",
	["REG_PLAYER_ABOUT_P"] = "文字錨點",
	["REG_PLAYER_ABOUT_REMOVE_FRAME"] = "移除此欄位",
	["REG_PLAYER_ABOUT_T1_YOURTEXT"] = "由此鍵入文字",
	["REG_PLAYER_ABOUT_TAGS"] = "內容編輯工具",
	["REG_PLAYER_ABOUT_UNMUSIC"] = "|cffff9900未知的主題曲|r",
	["REG_PLAYER_ABOUTS"] = "關於%s",
	["REG_PLAYER_ADD_NEW"] = "新建",
	["REG_PLAYER_AGE"] = "年齡",
	["REG_PLAYER_AGE_TT"] = [=[這裡你可以描述你的腳色年紀。

有幾種做法建議:|c0000ff00
- 撰寫確切年齡
- 使用模糊的描述（幼年／少年／青年／中年…等等。）]=],
	["REG_PLAYER_BIRTHPLACE"] = "出生地",
	["REG_PLAYER_BIRTHPLACE_TT"] = [=[這裡指的是您的角色的出生地。可以是區里鄉鎮市、也可以是一塊大陸或一個國家的名字，看您想怎麼使用。

|c00ffff00您也可以點擊按鈕，直接在地圖上選擇您的出生地。]=],
	["REG_PLAYER_CARACT"] = "特徵",
	["REG_PLAYER_CHANGE_CONFIRM"] = [=[您似乎還沒儲存此檔案的變更，
確定要切換頁面嗎？
|cffff9900所做的變更將會遺失]=],
	["REG_PLAYER_CHARACTERISTICS"] = "角色資訊",
	["REG_PLAYER_CLASS"] = "職業",
	["REG_PLAYER_CLASS_TT"] = [=[這裡可以自行填寫你的職業。

|cff00ff00範例 :|r
騎士、乳酪商、礦工、軍人、奧術師…]=],
	["REG_PLAYER_COLOR_ALWAYS_DEFAULT_TT"] = [=[|cffffff00Click:|r 選擇顏色
|cffffff00Right-click:|r 放棄顏色]=],
	["REG_PLAYER_COLOR_CLASS"] = "職業欄顏色",
	["REG_PLAYER_COLOR_CLASS_TT"] = "此選項同時將會更改名字的顏色。",
	["REG_PLAYER_COLOR_TT_SELECT"] = "選擇顏色",
	["REG_PLAYER_COLOR_TT_DISCARD"] = "放棄顏色",
	["REG_PLAYER_COLOR_TT_DEFAULTPICKER"] = "直接使用調色盤",
	["REG_PLAYER_EDIT_MUSIC_THEME"] = "主題音樂",
	["REG_PLAYER_EYE"] = "眼睛顏色",
	["REG_PLAYER_EYE_TT"] = [=[這裡可以描述你的腳色眼睛的顏色。

小提醒，就算你的腳色常常把臉遮住，這一點仍然相當重要。]=],
	["REG_PLAYER_FIRSTNAME"] = "名字",
	["REG_PLAYER_FIRSTNAME_TT"] = [=[這裡可以書寫角色的名字。這是必填的，如果你不做任何改變，將會直接使用角色ＩＤ(|cffffff00%s|r)

你也可以使用 |c0000ff00綽號|r ！]=],
	["REG_PLAYER_FULLTITLE"] = "全稱頭銜",
	["REG_PLAYER_FULLTITLE_TT"] = [=[這裡可以讓你寫下你的角色的全稱頭銜。這會比短頭銜來得更長且完整。

然而，重複的頭銜就可以不用再提了，以防空間有限。]=],
	["REG_PLAYER_GLANCE"] = "第一印象",
	["REG_PLAYER_GLANCE_BAR_TARGET"] = "「第一印象欄」預設欄位",
	["REG_PLAYER_GLANCE_CONFIG"] = [=[|cnGREEN_FONT_COLOR:「第一印象欄」|r 可以快速地將五個關於此角色重要且明顯的資訊傳達給其他玩家知道，目的是讓其他玩家只要短暫地看一眼就能對角色有「快速」、「精準」且「合理」的認識。因此建議不要有過於冗長、上帝視角的不合理資訊。]=],
	["REG_PLAYER_GLANCE_CONFIG_EDIT"] = "設定欄位內容",
	["REG_PLAYER_GLANCE_CONFIG_TOGGLE"] = "開啟／關閉欄位",
	["REG_PLAYER_GLANCE_CONFIG_PRESETS"] = "預設欄位選項",
	["REG_PLAYER_GLANCE_CONFIG_REORDER"] = "變更位置",
	["REG_PLAYER_GLANCE_EDITOR"] = "編輯器 : 欄位 %s",
	["REG_PLAYER_GLANCE_MENU_COPY"] = "複製此欄位",
	["REG_PLAYER_GLANCE_MENU_PASTE"] = "貼上欄位： %s",
	["REG_PLAYER_GLANCE_PRESET"] = "載入預設欄位",
	["REG_PLAYER_GLANCE_PRESET_ADD"] = "預設欄位 |cff00ff00%s|r 已建立。",
	["REG_PLAYER_GLANCE_PRESET_ALERT1"] = "您必須輸入一個類別名稱",
	["REG_PLAYER_GLANCE_PRESET_CATEGORY"] = "預設欄位類別",
	["REG_PLAYER_GLANCE_PRESET_CREATE"] = "建立預設欄位",
	["REG_PLAYER_GLANCE_PRESET_GET_CAT"] = [=[%s

請輸入此預設欄位的類別。]=],
	["REG_PLAYER_GLANCE_PRESET_NAME"] = "預設欄位名稱",
	["REG_PLAYER_GLANCE_PRESET_REMOVE"] = "已刪除了預設欄位 |cff00ff00%s|r 與其內容。",
	["REG_PLAYER_GLANCE_PRESET_SAVE_SMALL"] = "以預設欄位的方式儲存",
	["REG_PLAYER_GLANCE_PRESET_SELECT"] = "選擇預設欄位",
	["REG_PLAYER_GLANCE_TITLE"] = "欄位名稱",
	["REG_PLAYER_GLANCE_UNUSED"] = "未使用的欄位",
	["REG_PLAYER_GLANCE_USE"] = "開啟此欄位",
	["REG_PLAYER_HEIGHT"] = "身高",
	["REG_PLAYER_HERE"] = "選擇位置",
	["REG_PLAYER_HERE_HOME_PRE_TT"] = [=[目前居住地設定為：
|cff00ff00%s|r.]=],
	["REG_PLAYER_HERE_TT"] = "|cffffff00Click|r：以角色當前的位置設定",
	["REG_PLAYER_HERE_HOME_TT_CURRENT"] = "使用角色當前的位置來作為居住地",
	["REG_PLAYER_HERE_HOME_TT_DISCARD"] = "清除欄位內容",
	["REG_PLAYER_ICON"] = "角色圖案",
	["REG_PLAYER_ICON_TT"] = "選擇一個合適的圖案來代表您的角色。",
	["REG_PLAYER_LASTNAME"] = "姓氏",
	["REG_PLAYER_LASTNAME_TT"] = "你的家族姓氏。",
	["REG_PLAYER_LEFTTRAIT"] = "左側屬性",
	["REG_PLAYER_MISC_ADD"] = "新增一個資訊欄位",
	["REG_PLAYER_MORE_INFO"] = "額外資訊",
	["REG_PLAYER_MSP_HOUSE"] = "家族名稱",
	["REG_PLAYER_MSP_MOTTO"] = "座右銘",
	["REG_PLAYER_MSP_NICK"] = "綽號",
	["REG_PLAYER_NAMESTITLES"] = "稱號及姓名",
	["REG_PLAYER_NOTES"] = "記事本",
	["REG_PLAYER_NOTES_ACCOUNT_HELP"] = "記事本是僅供私人使用的，只有你的帳號才能瀏覽其中的資訊。",
	["REG_PLAYER_NOTES_PROFILE"] = "關於 %s 的紀錄",
	["REG_PLAYER_NOTES_PROFILE_HELP"] = "這些私人的筆記和您當前的角色綁定，當您切換角色的時候筆記內容也會跟著切換。",
	["REG_PLAYER_PEEK"] = "雜項",
	["REG_PLAYER_PHYSICAL"] = "生理外觀描述",
	["REG_PLAYER_PSYCHO"] = "人格特質",
	["REG_PLAYER_PSYCHO_ASCETIC"] = "禁慾",
	["REG_PLAYER_PSYCHO_ADD"] = "新增一個人格特質",
	["REG_PLAYER_PSYCHO_BONVIVANT"] = "樂天",
	["REG_PLAYER_PSYCHO_CHAOTIC"] = "混亂",
	["REG_PLAYER_PSYCHO_CHASTE"] = "純潔",
	["REG_PLAYER_PSYCHO_PARAGON"] = "典範人物",
	["REG_PLAYER_PSYCHO_SPINELESS"] = "懦弱",
	["REG_PLAYER_PSYCHO_CREATENEW"] = "創建新的特徵",
	["REG_PLAYER_PSYCHO_BRUTAL"] = "粗暴",
	["REG_PLAYER_PSYCHO_CUSTOM"] = "自訂特徵",
	["REG_PLAYER_PSYCHO_CUSTOMCOLOR_LEFT_TT"] = "選擇一個顏色來代表左側屬性欄。",
	["REG_PLAYER_PSYCHO_CUSTOMCOLOR_RIGHT_TT"] = "選擇一個顏色來代表右側屬性條。",
	["REG_PLAYER_PSYCHO_SELFISH"] = "自私",
	["REG_PLAYER_PSYCHO_ALTRUISTIC"] = "無私",
	["REG_PLAYER_PSYCHO_IMPULSIVE"] = "衝動",
	["REG_PLAYER_PSYCHO_FORGIVING"] = "寬容",
	["REG_PLAYER_PSYCHO_LEFTICON_TT"] = "設定左側圖示。",
	["REG_PLAYER_PSYCHO_LAWFUL"] = "守序",
	["REG_PLAYER_PSYCHO_LUSTFUL"] = "淫蕩",
	["REG_PLAYER_PSYCHO_GENTLE"] = "溫和",
	["REG_PLAYER_PSYCHO_PERSONAL"] = "人格特質",
	["REG_PLAYER_PSYCHO_SUPERSTITIOUS"] = "迷信",
	["REG_PLAYER_PSYCHO_RENEGADE"] = "叛逆者",
	["REG_PLAYER_PSYCHO_RATIONAL"] = "理性",
	["REG_PLAYER_PSYCHO_CAUTIOUS"] = "謹慎",
	["REG_PLAYER_PSYCHO_VINDICTIVE"] = "有仇必報",
	["REG_PLAYER_PSYCHO_RIGHTICON_TT"] = "設定右側圖示",
	["REG_PLAYER_PSYCHO_TRUTHFUL"] = "誠實",
	["REG_PLAYER_PSYCHO_SOCIAL"] = "社交特質",
	["REG_PLAYER_PSYCHO_DECEITFUL"] = "虛偽",
	["REG_PLAYER_PSYCHO_VALOROUS"] = "勇敢",
	["REG_PLAYER_RACE"] = "種族",
	["REG_PLAYER_RACE_TT"] = "意即角色所屬的種族。不限於遊戲中可玩的種族，魔獸世界裡還有許多外型相仿但並未釋出給一般玩家使用的種族。",
	["REG_PLAYER_REGISTER"] = "基本資料",
	["REG_PLAYER_RELATIONSHIP_STATUS"] = "感情狀態",
	["REG_PLAYER_RELATIONSHIP_STATUS_DIVORCED"] = "離異",
	["REG_PLAYER_RELATIONSHIP_STATUS_MARRIED"] = "已婚",
	["REG_PLAYER_RELATIONSHIP_STATUS_SINGLE"] = "單身",
	["REG_PLAYER_RELATIONSHIP_STATUS_TAKEN"] = "已有對象",
	["REG_PLAYER_RELATIONSHIP_STATUS_TT"] = "標示角色現在的感情狀態，如果不想顯示，選擇「不顯示」就可以將此資訊欄隱藏。",
	["REG_PLAYER_RELATIONSHIP_STATUS_UNKNOWN"] = "不顯示",
	["REG_PLAYER_RELATIONSHIP_STATUS_WIDOWED"] = "喪偶",
	["REG_PLAYER_RESIDENCE"] = "居住地",
	["REG_PLAYER_RESIDENCE_SHOW"] = "居住地地圖座標",
	["REG_PLAYER_RESIDENCE_SHOW_TT"] = "在地圖上顯示",
	["REG_PLAYER_RIGHTTRAIT"] = "右側屬性",
	["REG_PLAYER_SHOWMISC"] = "顯示雜項欄",
	["REG_PLAYER_SHOWPSYCHO"] = "顯示個性資料欄",
	["REG_PLAYER_SHOWPSYCHO_TT"] = [=[如果你想使用角色個性描述，請勾選。

如果你不想以這種方式來向其他玩家展示您的角色，請不要勾選此欄，描述框將會完全隱藏。]=],
	["REG_PLAYER_STYLE_DEATH"] = "允許角色死亡",
	["REG_PLAYER_STYLE_GUILD"] = "公會成員",
	["REG_PLAYER_STYLE_GUILD_IC"] = "成員皆為角色扮演玩家",
	["REG_PLAYER_STYLE_GUILD_OOC"] = "成員皆為非角色扮演玩家",
	["REG_PLAYER_STYLE_HIDE"] = "不予顯示",
	["REG_PLAYER_STYLE_INJURY"] = "允許角色受到傷害的狀況",
	["REG_PLAYER_STYLE_PERMI"] = "需要經過玩家許可",
	["REG_PLAYER_STYLE_ROMANCE"] = "允許角色之間發展戀愛關係",
	["REG_PLAYER_STYLE_RPSTYLE"] = "喜好遊戲方式",
	["REG_PLAYER_TITLE"] = "稱號",
	["REG_PLAYER_TITLE_TT"] = [=[你的角色稱號代表他經常被稱呼的頭銜，避免使用過長的稱號，過長的稱號應該輸入在長稱號區而非此處。

以下為範例的 |c0000ff00合適稱號|r :
|c0000ff00- 伯爵夫人
- 侯爵
- 法師
- 領主
- 諸如此類…
|r以下為範例的 |cffff0000不合適稱號|r:
|cffff0000- 北方沼澤的伯爵夫人
- 暴風塔的法師
- 德萊尼行政外交官
- 諸如此類…]=],
	["REG_PLAYER_TRP2_PIERCING"] = "穿環打孔",
	["REG_PLAYER_TRP2_TATTOO"] = "刺青",
	["REG_PLAYER_TRP2_TRAITS"] = "面相",
	["REG_PLAYER_TUTO_ABOUT_T1"] = [=[這個版面可以讓你 |cff00ff00自由發揮|r你的創意。

描述不必局限於角色的|cffff9900生理狀態|r。自由地揮灑他的|cffff9900背景故事|r 或|cffff9900個性上|r的細節。

使用此版面，您可以使用工具列來插入許多裝飾和變化，如|cffffff00texts尺寸，顏色和粗體字|r。
甚至還有|cffffff00圖片，圖標或超連結|r。]=],
	["REG_PLAYER_TUTO_ABOUT_T2"] = [=[這個版面更加結構化，由|cff00ff00a各自獨立的框架列表|r所組成。

每個框架又由|cffffff00icon背景和文本|r組成。注意，您可以在這些框架中使用一些文字標籤：如顏色和圖標等。

敘述時不必局限於|cffff9900生理狀態|r。也可以撰寫他的|cffff9900背景故事|r 或他|cffff9900個性|r上的細節。]=],
	["REG_PLAYER_TUTO_ABOUT_T3"] = [=[此樣板被分割為三個部分： |cff00ff00生理描述、個性和歷史。

不一定要填滿所有欄位， |cffff9900if 空白的欄位將不會顯示|r。

每一個欄位都由 |cffffff00icon背景和文本|r呈現。你可以在這些欄位中使用特殊文本功能，例如：顏色、圖示、標籤等等…]=],
	["REG_PLAYER_WEIGHT"] = "體態",
	["REG_PLAYER_WEIGHT_TT"] = [=[此處代表你的角色身形。
例如 |c0000ff00瘦、胖或強壯…|r 或只是一般的身形。]=],
	["REG_PLAYERS"] = "玩家",
	["REG_REGISTER"] = "目錄",
	["REG_REGISTER_CHAR_LIST"] = "角色名單",
	["REG_RELATION"] = "人際關係",
	["REG_RELATION_BUSINESS"] = "工作",
	["REG_RELATION_BUSINESS_TT"] = "%s 和 %s 之間是生意上的關係。",
	["REG_RELATION_BUTTON_TT"] = "|cnGREEN_FONT_COLOR:關係: %s|r|n%s",
	["REG_RELATION_BUTTON_TT_ACTIONS"] = "顯示可執行的動作",
	["REG_RELATION_FAMILY"] = "家人",
	["REG_RELATION_FAMILY_TT"] = "%s 與 %s 的關係血濃於水。",
	["REG_RELATION_FRIEND"] = "友善",
	["REG_RELATION_FRIEND_TT"] = "%s 將 %s 視為朋友。",
	["REG_RELATION_LOVE"] = "愛戀",
	["REG_RELATION_LOVE_TT"] = "%s正與%s陷入愛河！",
	["REG_RELATION_NEUTRAL"] = "中立",
	["REG_RELATION_NEUTRAL_TT"] = "%s 對 %s 沒什麼特別的感覺。",
	["REG_RELATION_NONE"] = "無",
	["REG_RELATION_NONE_TT"] = "%s 不認識 %s。",
	["REG_RELATION_TARGET"] = "變更關係",
	["REG_RELATION_UNFRIENDLY"] = "不友善",
	["REG_RELATION_UNFRIENDLY_TT"] = "看來 %s 不太喜歡 %s。",
	["REG_REPORT_PLAYER_TEMPLATE_TRIAL_ACCOUNT"] = "此玩家為試玩帳號。",
	["REG_TRIAL_ACCOUNT"] = "試玩帳號",
	["REG_TT_GUILD_IC"] = "ＩＣ成員",
	["REG_TT_GUILD_OOC"] = "ＯＯＣ成員",
	["REG_TT_IGNORED"] = "＜角色已忽略＞",
	["REG_TT_IGNORED_OWNER"] = "＜使用者已忽略＞",
	["REG_TT_LEVEL"] = "等級 %s %s",
	["REG_TT_NOTIF"] = "未讀的文本",
	["REG_TT_REALM"] = "區域: |cffff9900%s",
	["REG_TT_TARGET"] = "目標： |cffff9900%s",
	["SCRIPT_ERROR"] = "腳本錯誤",
	["SCRIPT_UNKNOWN_EFFECT"] = "腳本錯誤，無法辨識的效果",
	["TB_AFK_MODE"] = "離開",
	["TB_DND_MODE"] = "請勿打擾",
	["TB_GO_TO_MODE"] = "切換至 %s 模式",
	["TB_LANGUAGE"] = "語言",
	["TB_LANGUAGES_TT"] = "變更語言",
	["TB_NORMAL_MODE"] = "有空",
	["TB_RPSTATUS_OFF"] = "角色狀態：|cnRED_FONT_COLOR:脫離角色|r",
	["TB_RPSTATUS_ON"] = "角色狀態：|cnGREEN_FONT_COLOR:進入角色（IC）|r",
	["TB_RPSTATUS_TO_OFF"] = "切換至脫離角色（OOC）",
	["TB_RPSTATUS_TO_ON"] = "切換至進入角色（IC）",
	["TB_STATUS"] = "玩家",
	["TB_SWITCH_CAPE_1"] = "顯示斗篷",
	["TB_SWITCH_CAPE_2"] = "隱藏斗篷",
	["TB_SWITCH_CAPE_OFF"] = "斗篷：|cffff0000隱藏|r",
	["TB_SWITCH_CAPE_ON"] = "斗篷：|cff00ff00已顯示|r",
	["TB_SWITCH_HELM_1"] = "顯示頭盔",
	["TB_SWITCH_HELM_2"] = "隱藏頭盔",
	["TB_SWITCH_HELM_OFF"] = "頭盔：|cffff0000隱藏|r",
	["TB_SWITCH_HELM_ON"] = "頭盔：|cff00ff00已顯示|r",
	["TB_SWITCH_PROFILE"] = "切換至其他角色資料",
	["TB_SWITCH_TOOLBAR"] = "切換工具欄",
	["TB_TOOLBAR"] = "工具列",
	["TF_IGNORE"] = "忽略玩家",
	["TF_IGNORE_CONFIRM"] = [=[你確定要忽略這個ＩＤ嗎？

|cffffff00%s|r

|cffff7700你可以選擇輸入自己忽略對方的原因，這是私人記錄，不會被其他玩家看到。|r]=],
	["TF_IGNORE_NO_REASON"] = "沒有原因",
	["TF_OPEN_CHARACTER"] = "顯示角色頁面",
	["TF_OPEN_COMPANION"] = "顯示夥伴頁面",
	["TF_OPEN_MOUNT"] = "顯示坐騎頁面",
	["TF_PLAY_THEME"] = "播放角色主題曲",
	["TF_PLAY_THEME_TT"] = "播放 %s",
	["THANK_YOU_1"] = [=[{h1:c}Total RP 3{/h1}
{p:c}{col:6eff51}版本 %s (build %s){/col}{/p}
{p:c}{link*http://totalrp3.info*TotalRP3.info} — {twitter*TotalRP3*@TotalRP3} {/p}
{p:c}{link*http://discord.totalrp3.info* 加入我們的Discord}{/p}

{h2}{icon:INV_Eng_gizmo1:20} 作者：{/h2}
%AUTHORS$s

{h2}{icon:QUEST_KHADGAR:20} 其他工作人員：{/h2}
%CONTRIBUTORS$s

{h2}{icon:THUMBUP:20} 感謝{/h2}
{col:ffffff}Logo 與小地圖按鈕:{/col}
- {link*https://twitter.com/Kelandiir*@Kelandiir}

{col:ffffff}準預覽版本測試團隊：{/col}
%TESTERS$s

{col:ffffff}感謝所有朋友這些年的支持：{/col}
- For Telkos: Kharess, Kathryl, Marud, Solona, Stretcher, Lisma...
- For Ellypse: The guilds Eglise du Saint Gamon, Maison Celwë'Belore, Mercenaires Atal'ai, and more particularly Erzan, Elenna, Caleb, Siana and Adaeria

{col:ffffff}感謝EU Kirin Tor 在我們製作Total RP期間所提供的幫助：{/col}
%GUILD_MEMBERS$s

{col:ffffff}感謝 Horionne 寄給我們那本雜誌《Gamer Culte Online #14中有關角色扮演的文章。{/col}
]=],
	["THANK_YOU_ROLE_AUTHOR"] = "作者",
	["THANK_YOU_ROLE_GUILD_MEMBER"] = "公會成員",
	["THANK_YOU_ROLE_TESTER"] = "測試團隊",
	["UI_BKG"] = "背景 %s",
	["UI_CLOSE_ALL"] = "全部關閉",
	["UI_COLOR_BROWSER"] = "顏色瀏覽器",
	["UI_COLOR_BROWSER_PRESETS"] = "預設",
	["UI_COLOR_BROWSER_PRESETS_BASIC"] = "基本",
	["UI_COLOR_BROWSER_PRESETS_CLASSES"] = "類別",
	["UI_COLOR_BROWSER_PRESETS_CUSTOM"] = "自訂",
	["UI_COLOR_BROWSER_SELECT"] = "選擇顏色",
	["UI_COMPANION_BROWSER_HELP"] = "請選擇一隻戰寵",
	["UI_FILTER"] = "過濾器",
	["UI_ICON_BROWSER"] = "圖示瀏覽器",
	["UI_ICON_SELECT"] = "選擇圖示",
	["UI_ICON_COPY"] = "複製圖示",
	["UI_IMAGE_BROWSER"] = "圖片瀏覽器",
	["UI_IMAGE_SELECT"] = "選擇圖片",
	["UI_LINK_SAFE"] = "這是連結網址。",
	["UI_LINK_TEXT"] = "於此處輸入文字",
	["UI_LINK_URL"] = "http://your.url.here",
	["UI_LINK_WARNING"] = [=[這是連結網址。
你可以複製、貼上到瀏覽器上。

|cffff0000!! Disclaimer !!|r
若網址導向有危險性的網站，Total RP 將不為此負責。]=],
	["UI_MUSIC_BROWSER"] = "音樂瀏覽器",
	["UI_MUSIC_SELECT"] = "選擇音樂",
	["UI_TUTO_BUTTON"] = "教學模式",
	["UI_TUTO_BUTTON_TT"] = "啟／關閉教學模式"
};

TRP3_API.loc:RegisterNewLocale("zhTW", "繁體中文", L);
