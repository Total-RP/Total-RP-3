--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : About section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local Comm = TRP3_COMM;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_PROFILE.getData;
local safeGet = TRP3_PROFILE.getDataDefault;
local loc = TRP3_L;
local stNtE = Utils.str.nilToEmpty;
local tcopy = Utils.table.copy;
local numberToHexa = Utils.color.numberToHexa;
local getDefaultProfile = TRP3_PROFILE.getDefaultProfile;
local openIconBrowser = TRP3_POPUPS.openIconBrowser;
local unitIDToInfo = Utils.str.unitIDToInfo;
local Log = Utils.log;
local getConfigValue = TRP3_CONFIG.getValue;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--getDefaultProfile().player.about = {
--	v = 1,
--	TE = 1,
--	T1 = {
--	
--	},
--	T2 = {
--	
--	},
--	T3 = {
--		PH = {}, PS = {}, HI = {}
--	},
--}

-- Mock
getDefaultProfile().player.about = {
	v = 1,
	TE = 1,
	BK = 1,
	MU = "ZoneMusic\\GrizzlyHills\\GH_Intro1Uni01",
	T1 = {
		TX = [[{h1}A big left title{/h1}
{h1:c}A big centered title{/h1}
{h1:r}A big right title{/h1}
{h3}A left title{/h3}
{h3:c}A centered title{/h3}
{h3:r}A right title{/h3}
{img:Interface\Challenges\challenges-bronze:128:128}
{p}{col:r}This is my description as a {col:ff00ff}dragon !{/col}

Le poème en prose a pour origine la prose poétique. Toutefois,{fake_balise} la prose poétique restait de la prose, un moyen supplémentaire pour le romancier, une marque de son style, sans constituer une véritable forme de poème. Autour de 1800, pendant que se constitue le romantisme, les aspirations des écrivains tendent de plus en plus vers l'absolu. La poésie suscite à nouveau de l'intérêt (contrairement au siècle des Lumières où elle était considérée comme un ornement) et la versification sera assouplie. Cependant, cela ne suffit pas pour certains tempéraments, qui se soumettent plus difficilement à la tyrannie de la rime et du mètre. François-René de Chateaubriand, très porté vers le lyrisme, mais peu vers le vers, écrit une épopée en prose, Les Martyrs (1809).{/p}
{p:r}{icon:Ability_Rogue_CheatDeath:50}{/p}]],
	},
	T2 = {
		{
			TX = "Mon beau texte",
		},
		{
			IC = "ACHIEVEMENT_GUILDPERK_LADYLUCK",
			TX = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
			BK = 2,
		},
		{
			IC = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			TX = "Mon beau texte 3",
			BK = 3,
		},
	},
	T3 = {
		PH = {
			TX = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
		PS = {
			TX = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
		HI = {
			TX = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ABOUT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData = nil;

local function setBkg(frame, bkg)
	local backdrop = frame:GetBackdrop();
	backdrop.bgFile = TRP3_getTiledBackground(bkg or 1);
	frame:SetBackdrop(backdrop);
end

local function setConsultBkg(bkg)
	setBkg(TRP3_RegisterAbout, bkg);
end

local function setEditBkg(bkg)
	setBkg(TRP3_RegisterAbout, bkg);
end

local function selectMusic(music)
	if music then
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc("REG_PLAYER_ABOUT_MUSIC"), Utils.music.getTitle(music)));
	else
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc("REG_PLAYER_ABOUT_MUSIC"), loc("REG_PLAYER_ABOUT_NOMUSIC")));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 1
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TAGS_INFO = {
	{
		openTags = {"{h1}", "{h1:c}", "{h1:r}"},
		closeTag = "{/h1}",
	},
	{
		openTags = {"{h2}", "{h2:c}", "{h2:r}"},
		closeTag = "{/h2}",
	},
	{
		openTags = {"{h3}", "{h3:c}", "{h3:r}"},
		closeTag = "{/h3}",
	},
	{
		openTags = {"{p:c}", "{p:r}"},
		closeTag = "{/p}",
	}
}

local function showTemplate1(dataTab)
	local templateData = dataTab.T1 or {};
	
	local text = Utils.str.toHTML(templateData.TX or "");
	TRP3_RegisterAbout_AboutPanel_Template1:Show();
	TRP3_RegisterAbout_AboutPanel_Template1:SetText(text);
end

local function insertTag(tag, index)
	local text = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetText();
	local pre = text:sub(1, index);
	local post = text:sub(index + 1);
	text = strconcat(pre, tag, post);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetText(text);
end

local function postInsertHighlight(index, tagSize, textSize)
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(index + tagSize + textSize);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:HighlightText(index + tagSize, index + tagSize + textSize);
end

local function insertContainerTag(alignIndex, button)
	assert(button.tagIndex and TAGS_INFO[button.tagIndex], "Button is not properly init with a tag index");
	local tagInfo = TAGS_INFO[button.tagIndex];
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	insertTag(strconcat(tagInfo.openTags[alignIndex], loc("REG_PLAYER_ABOUT_T1_YOURTEXT"), tagInfo.closeTag), cursorIndex);
	postInsertHighlight(cursorIndex, tagInfo.openTags[alignIndex]:len(), loc("REG_PLAYER_ABOUT_T1_YOURTEXT"):len());
end

local function onColorTagSelected(red, green, blue)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{col:%s}"):format(strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue)));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onIconTagSelected(icon)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{icon:%s:25}"):format(icon);
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onImageTagSelected(image)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{img:%s:%s:%s}"):format(image.url, math.min(image.width, 512), math.min(image.height, 512));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onLinkTagClicked()
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{link||%s||%s}"):format(loc("UI_LINK_URL"), loc("UI_LINK_TEXT"));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + 6);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:HighlightText(cursorIndex + 6, cursorIndex + 6 + loc("UI_LINK_URL"):len());
end

-- Drop down
local function onContainerTagClicked(button)
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_HEADER")});
	tinsert(values, {loc("CM_LEFT"), 1});
	tinsert(values, {loc("CM_CENTER"), 2});
	tinsert(values, {loc("CM_RIGHT"), 3});
	TRP3_DisplayDropDown(button, values, insertContainerTag, 0, true);
end

local function onContainerPTagClicked(button)
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_P")});
	tinsert(values, {loc("CM_CENTER"), 1});
	tinsert(values, {loc("CM_RIGHT"), 2});
	TRP3_DisplayDropDown(button, values, insertContainerTag, 0, true);
end

local function onLinkClicked(self, url)
	TRP3_ShowTextInputPopup(loc("UI_LINK_WARNING"), nil, nil, url);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 2
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local template2Frames = {};
local TEMPLATE2_PADDING = 30;

local function showTemplate2(dataTab)
	local templateData = dataTab.T2 or {};
	
	-- Hide all
	for _, frame in pairs(template2Frames) do
		frame:Hide();
	end
	
	local frameIndex = 1;
	local previous = TRP3_RegisterAbout_AboutPanel_Template2Title;
	local bool = true;
	for _, frameTab in pairs(templateData) do
		local frame = template2Frames[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Frame"..frameIndex, TRP3_RegisterAbout_AboutPanel_Template2, "TRP3_RegisterAbout_Template2_Frame");
			tinsert(template2Frames, frame);
		end
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
		
		local icon = _G[frame:GetName().."Icon"];
		local text = _G[frame:GetName().."Text"];
		local backdrop = frame:GetBackdrop();
		backdrop.bgFile = TRP3_getTiledBackground(frameTab.BK or 1);
		frame:SetBackdrop(backdrop);
		TRP3_InitIconButton(icon, frameTab.IC or Globals.icons.default);
		text:SetText(frameTab.TX);
		icon:ClearAllPoints();
		text:ClearAllPoints();
		if bool then
			icon:SetPoint("LEFT", 15, 0);
			text:SetPoint("LEFT", icon, "RIGHT", 10, 0);
			text:SetJustifyH("LEFT")
		else
			icon:SetPoint("RIGHT", -15, 0);
			text:SetPoint("RIGHT", icon, "LEFT", -10, 0);
			text:SetJustifyH("RIGHT")
		end
		
		local height = math.max(text:GetHeight(), icon:GetHeight()) + TEMPLATE2_PADDING;
		frame:SetHeight(height);
		
		frame:Show();
		previous = frame;
		frameIndex = frameIndex + 1;
		bool = not bool;
	end
	
	TRP3_RegisterAbout_AboutPanel_Template2:Show();
	TRP3_RegisterAbout_AboutPanel_Template2Title:SetText(safeGet("player/characteristics/firstName", Globals.player));
end

local template2EditFrames = {};
local refreshTemplate2EditDisplay; -- Function reference

local function setTemplate2EditBkg(bkg, frame)
	frame = frame:GetParent();
	assert(frame.frameData, "No frameData in the frame ...");
	setBkg(frame, bkg);
	frame.frameData.BK = bkg;
end

local function template2DeleteFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	tremove(templateData, frame.index);
	refreshTemplate2EditDisplay();
end

local function template2UpFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index - 1, frameData);
	refreshTemplate2EditDisplay();
end

local function template2DownFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index + 1, frameData);
	refreshTemplate2EditDisplay();
end

refreshTemplate2EditDisplay = function()
	-- Hide all
	for _, frame in pairs(template2EditFrames) do
		frame:Hide();
		frame.frameData = nil; -- Helps garbage collection
	end
	
	local templateData = draftData.T2;
	assert(type(templateData) == "table", "Error: Nil template3 data or not a table.");
	
	local previous = nil;
	for frameIndex, frameData in pairs(templateData) do
		local frame = template2EditFrames[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Edit"..frameIndex, TRP3_RegisterAbout_Edit_Template2_Container, "TRP3_RegisterAbout_Template2_Edit");
			TRP3_ListBox_Setup(_G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."Bkg"], TRP3_getTiledBkgListForListbox(), setTemplate2EditBkg, nil, 120, true);
			_G[frame:GetName().."Delete"]:SetScript("OnClick", template2DeleteFrame);
			_G[frame:GetName().."Delete"]:SetText(loc("CM_REMOVE"));
			_G[frame:GetName().."Up"]:SetScript("OnClick", template2UpFrame);
			_G[frame:GetName().."Down"]:SetScript("OnClick", template2DownFrame);
			TRP3_SetTooltipAll(_G[frame:GetName().."Up"], "TOP", 0, 0, loc("CM_MOVE_UP"));
			TRP3_SetTooltipAll(_G[frame:GetName().."Down"], "TOP", 0, 0, loc("CM_MOVE_DOWN"));
			tinsert(template2EditFrames, frame);
		end
		-- Position
		frame:ClearAllPoints();
		if previous == nil then
			frame:SetPoint("TOPLEFT", TRP3_RegisterAbout_Edit_Template2_Container, "TOPLEFT", -5, -5);
		else
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -5);
		end
		-- Values
		frame.index = frameIndex;
		frame.frameData = frameData;
		_G[frame:GetName().."Bkg"]:SetSelectedIndex(frameData.BK or 1);
		_G[frame:GetName().."TextScrollBox"]:SetText(frameData.TX or "");
		TRP3_InitIconButton(_G[frame:GetName().."Icon"], frameData.IC or Globals.icons.default);
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function()
			openIconBrowser(function(icon)
				frame.frameData.IC = icon;
				TRP3_InitIconButton(_G[frame:GetName().."Icon"], icon);
			end);
		end);
		-- Buttons
		if frameIndex == 1 then
			_G[frame:GetName().."Up"]:Hide();
		else
			_G[frame:GetName().."Up"]:Show();
		end
		if frameIndex == #templateData then
			_G[frame:GetName().."Down"]:Hide();
		else
			_G[frame:GetName().."Down"]:Show();
		end
		
		frame:Show();
		previous = frame;
	end
end

local function template2AddFrame()
	local templateData = draftData.T2;
	tinsert(templateData, {TX = loc("REG_PLAYER_ABOUT_SOME")});
	refreshTemplate2EditDisplay();
end

--- Save to draft all the frames texts
local function template2SaveToDraft()
	for _, frame in pairs(template2EditFrames) do
		if frame:IsVisible() then
			assert(frame.frameData, "Frame has no frameData !");
			frame.frameData.TX = stEtN(_G[frame:GetName().."TextScrollBox"]:GetText());
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 3
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TEMPLATE3_MINIMAL_HEIGHT = 100;
local TEMPLATE3_MARGIN = 30;

local function setTemplate3PhysBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Phys, bkg);
end

local function setTemplate3PsyBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Psy, bkg);
end

local function setTemplate3HistBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Hist, bkg);
end

local function onPhisIconSelected(icon)
	draftData.T3.PH.IC = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, icon or Globals.icons.default);
end

local function onPsychoIconSelected(icon)
	draftData.T3.PS.IC = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, icon or Globals.icons.default);
end

local function onHistoIconSelected(icon)
	draftData.T3.HI.IC = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, icon or Globals.icons.default);
end

local function showTemplate3(dataTab)
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	local titles = {loc("REG_PLAYER_PHYSICAL"), loc("REG_PLAYER_PSYCHO"), loc("REG_PLAYER_HISTORY")};
	for i=1, 3 do
		local data = datas[i] or {};
		local icon = Utils.str.icon(data.IC or Globals.icons.default, 25);
		local title = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Title"):format(i)];
		local frame = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s"):format(i)];
		local text = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Text"):format(i)];
		title:SetText(icon.."    "..titles[i].."    "..icon);
		text:SetText(Utils.str.convertTextTags(data.TX));
		setBkg(frame, data.BK);
		frame:SetHeight(title:GetHeight() + text:GetHeight() + TEMPLATE3_MARGIN);
	end

	TRP3_RegisterAbout_AboutPanel_Template3:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- VOTE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local VOTE_MESSAGE_PREFIX = "ABVT";
local VOTE_MESSAGE_PRIORITY = "ALERT";
local VOTE_MESSAGE_R_PREFIX = "ABVR";
local VOTE_MESSAGE_R_PRIORITY = "ALERT";

local function refreshVoteDisplay(aboutTab)
	if aboutTab.vote == 1 then
		TRP3_RegisterAbout_AboutPanel_ThumbUp:LockHighlight();
		TRP3_RegisterAbout_AboutPanel_ThumbUp:GetHighlightTexture():SetVertexColor(0, 1, 0);
	else
		TRP3_RegisterAbout_AboutPanel_ThumbUp:UnlockHighlight();
		TRP3_RegisterAbout_AboutPanel_ThumbUp:GetHighlightTexture():SetVertexColor(1, 1, 1);
	end
	if aboutTab.vote == -1 then
		TRP3_RegisterAbout_AboutPanel_ThumbDown:LockHighlight();
		TRP3_RegisterAbout_AboutPanel_ThumbDown:GetHighlightTexture():SetVertexColor(0, 1, 0);
	else
		TRP3_RegisterAbout_AboutPanel_ThumbDown:UnlockHighlight();
		TRP3_RegisterAbout_AboutPanel_ThumbDown:GetHighlightTexture():SetVertexColor(1, 1, 1);
	end
end

local function sendVote(voteValue)
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	if context.unitID and context.unitID ~= Globals.player_id and TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).about then
		if voteValue == TRP3_GetUnitProfile(context.unitID).about.vote then
			voteValue = 0; -- Unvoting
		end
		Comm.sendObject(VOTE_MESSAGE_PREFIX, voteValue, context.unitID, VOTE_MESSAGE_PRIORITY);
		local playerName = unitIDToInfo(context.unitID);
		Utils.message.displayMessage(loc("REG_PLAYER_ABOUT_VOTE_SENDING"):format(playerName));
	end
end

-- Someone vote for your description
local function vote(value, sender)
	Log.log(("Receive vote from %s: %s"):format(sender, value));
	local about = get("player/about");
	if not about.vote then
		about.vote = {};
	end
	about.vote[sender] = value;
	Comm.sendObject(VOTE_MESSAGE_R_PREFIX, value, sender, VOTE_MESSAGE_R_PRIORITY);
end

-- Your vote has been registered
local function voteResponse(value, sender)
	local value = tonumber(value);
	if TRP3_IsUnitIDKnown(sender) and TRP3_HasProfile(sender) and TRP3_GetUnitProfile(sender).about then
		TRP3_GetUnitProfile(sender).about.vote = value;
		local playerName = unitIDToInfo(sender);
		Utils.message.displayMessage(loc("REG_PLAYER_ABOUT_VOTE_SENDING_OK"):format(playerName));
		if TRP3_GetCurrentPageID() == "player_main" then
			local context = TRP3_GetCurrentPageContext();
			assert(context, "No context for page player_main !");
			if context.unitID == sender then
				refreshVoteDisplay(TRP3_GetUnitProfile(sender).about);
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentCompressed;

local function getOptimizedData()
	local dataTab = get("player/about");
	-- Optimize : only send the selected template
	local dataToSend = {};
	tcopy(dataToSend, dataTab);
	local template = dataToSend.TE or 1;
	if template ~= 1 then
		dataToSend.T1 = nil;
	end
	if template ~= 2 then
		dataToSend.T2 = nil;
	end
	if template ~= 3 then
		dataToSend.T3 = nil;
	end
	return dataToSend;
end

local function compressData()
	local dataTab = getOptimizedData();
	local serial = Utils.serial.serialize(dataTab);
	local compressed = Utils.serial.encodeCompressMessage(serial);
	
--	log(("Compressed data : %s / %s (%i%%)"):format(compressed:len(), serial:len(), compressed:len() / serial:len() * 100));
	if compressed:len() < serial:len() then
		currentCompressed = compressed;
	else
		currentCompressed = nil;
	end
end

function TRP3_RegisterAboutGetExchangeData()
	if currentCompressed ~= nil then
		return currentCompressed;
	else
		return getOptimizedData();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local isEditMode;
local templatesFunction = {
	showTemplate1,
	showTemplate2,
	showTemplate3
}

local function aggregateVotes(voteData)
	local voteUp = 0;
	local voteDown = 0;
	for voter, vote in pairs(voteData or {}) do
		if vote == 1 then
			voteUp = voteUp + 1;
		elseif vote == -1 then
			voteDown = voteDown + 1;
		end
	end
	return voteUp, voteDown;
end

local function refreshConsultDisplay(context)
	local dataTab = nil;
	local template = nil;
	TRP3_RegisterAbout_AboutPanel.isMine = nil;
	TRP3_RegisterAbout_AboutPanel_ThumbResult:Hide();
	TRP3_RegisterAbout_AboutPanel_ThumbUp:Hide();
	TRP3_RegisterAbout_AboutPanel_ThumbDown:Hide();
	
	if context.unitID == Globals.player_id then
		dataTab = get("player/about");
		template = dataTab.TE or 1;
		TRP3_RegisterAbout_AboutPanel.isMine = true;
		TRP3_RegisterAbout_AboutPanel_ThumbResult:Show();
		local voteUp, voteDown = aggregateVotes(dataTab.vote);
		TRP3_SetTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbResult,
			"LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTES"),
			loc("REG_PLAYER_ABOUT_VOTES_R"):format(voteUp, voteDown)
		);
	else
		if TRP3_HasProfile(context.unitID) and TRP3_GetUnitProfile(context.unitID).about then
			dataTab = TRP3_GetUnitProfile(context.unitID).about;
			dataTab.read = true;
			template = dataTab.TE or 1;
		else
			dataTab = {};
			template = 1;
		end
		TRP3_RegisterAbout_AboutPanel_ThumbUp:Show();
		TRP3_RegisterAbout_AboutPanel_ThumbDown:Show();
		refreshVoteDisplay(dataTab);
	end

	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	assert(template, "Error: No about template ID.");
	assert(type(templatesFunction[template]) == "function", "Error: no function for about template: " .. tostring(template));
	
	TRP3_RegisterAbout_AboutPanel.musicURL = dataTab.MU;
	if dataTab.MU then
		TRP3_RegisterAbout_AboutPanel_MusicPlayer_URL:SetText(Utils.music.getTitle(dataTab.MU));
	end
	
	TRP3_RegisterAbout_AboutPanel_EditButton:Hide();
	TRP3_RegisterAbout_AboutPanel_Thumb:Hide();
	TRP3_RegisterAbout_AboutPanel:Show();
	-- Putting the right templates
	templatesFunction[template](dataTab);
	-- Putting the righ background
	setConsultBkg(dataTab.BK);
end

local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.BK = TRP3_RegisterAbout_Edit_BckField:GetSelectedValue();
	draftData.TE = TRP3_RegisterAbout_Edit_TemplateField:GetSelectedValue();
	-- Template 1
	draftData.T1.TX = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetText();
	-- Template 2
	template2SaveToDraft();
	-- Template 3
	draftData.T3.PH.BK = TRP3_RegisterAbout_Edit_Template3_PhysBkg:GetSelectedValue();
	draftData.T3.PS.BK = TRP3_RegisterAbout_Edit_Template3_PsyBkg:GetSelectedValue();
	draftData.T3.HI.BK = TRP3_RegisterAbout_Edit_Template3_HistBkg:GetSelectedValue();
	draftData.T3.PH.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:GetText());
	draftData.T3.PS.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:GetText());
	draftData.T3.HI.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:GetText());
end

local function setEditTemplate(value)
	TRP3_RegisterAbout_Edit_Template1:Hide();
	TRP3_RegisterAbout_Edit_Template2:Hide();
	TRP3_RegisterAbout_Edit_Template3:Hide();
	_G["TRP3_RegisterAbout_Edit_Template"..value]:Show();
end

local function save()
	saveInDraft();
	
	--TODO: check size and warn if too long
	local aboutSize = Comm.estimateStructureLoad(draftData);
	
	local dataTab = get("player/about");
	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);
	
	compressData();
end

local function refreshEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/about");
		assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end
	
	TRP3_RegisterAbout_Edit_BckField:SetSelectedIndex(draftData.BK or 1);
	TRP3_RegisterAbout_Edit_TemplateField:SetSelectedIndex(draftData.TE or 1);
	selectMusic(draftData.MU);
	-- Template 1
	local template1Data = draftData.T1;
	assert(type(template1Data) == "table", "Error: Nil template1 data or not a table.");
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetText(template1Data.TX or "");
	-- Template 2
	refreshTemplate2EditDisplay();
	-- Template 3
	local template3Data = draftData.T3;
	assert(type(template3Data) == "table", "Error: Nil template3 data or not a table.");
	setTemplate3PhysBkg(template3Data.PH.BK or 1);
	setTemplate3PsyBkg(template3Data.PS.BK or 1);
	setTemplate3HistBkg(template3Data.HI.BK or 1);
	TRP3_RegisterAbout_Edit_Template3_PhysBkg:SetSelectedIndex(template3Data.PH.BK or 1);
	TRP3_RegisterAbout_Edit_Template3_PsyBkg:SetSelectedIndex(template3Data.PS.BK or 1);
	TRP3_RegisterAbout_Edit_Template3_HistBkg:SetSelectedIndex(template3Data.HI.BK or 1);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, template3Data.PH.IC or Globals.icons.default);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, template3Data.PS.IC or Globals.icons.default);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, template3Data.HI.IC or Globals.icons.default);
	TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetText(template3Data.PH.TX or "");
	TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetText(template3Data.PS.TX or "");
	TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetText(template3Data.HI.TX or "");
	
	TRP3_RegisterAbout_AboutPanel_Edit:Show();
	setEditTemplate(draftData.TE or 1);
end

local function refreshDisplay()
	local context = TRP3_GetCurrentPageContext();
	assert(context, "No context for page player_main !");
	local isSelf = context.unitID == Globals.player_id;
	
	--Hide all templates
	TRP3_RegisterAbout_AboutPanel_Template1:Hide();
	TRP3_RegisterAbout_AboutPanel_Template2:Hide();
	TRP3_RegisterAbout_AboutPanel_Template3:Hide();
	TRP3_RegisterAbout_AboutPanel:Hide();
	TRP3_RegisterAbout_AboutPanel_Edit:Hide();
	
	if isEditMode then
		assert(isSelf, "Trying to show About edition for another unitID than me ...");
		refreshEditDisplay();
	else
		refreshConsultDisplay(context);
	end
end

function TRP3_onPlayerAboutShow()
	TRP3_RegisterAbout_AboutPanel_MusicPlayer:Hide();
	TRP3_RegisterAbout:Show();
	isEditMode = false;
	refreshDisplay();
end

function TRP3_UI_AboutEditButton()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	isEditMode = true;
	refreshDisplay();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MUSIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onMusicSelected(music)
	draftData.MU = music;
	selectMusic(draftData.MU);
end

local function onMusicEditSelected(value, button)
	if value == 1 then
		TRP3_OpenMusicBrowser(onMusicSelected);
	elseif value == 2 and draftData.MU then
		draftData.MU = nil;
		selectMusic(draftData.MU);
	elseif value == 3 and draftData.MU then
		Utils.music.play(draftData.MU);
	elseif value == 4 and draftData.MU then
		Utils.music.stop();
	end
end

local function onMusicEditClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_SELECT"), 1});
	if draftData.MU then
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_REMOVE"), 2});
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_LISTEN"), 3});
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_STOP"), 4});
	end
	TRP3_DisplayDropDown(button, values, onMusicEditSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI MISC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPlayerAboutRefresh()
	if getConfigValue("register_about_use_vote") then
		TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_Thumb, TRP3_RegisterAbout_AboutPanel);
	end
	if TRP3_RegisterAbout_AboutPanel.isMine then
		TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_EditButton, TRP3_RegisterAbout_AboutPanel);
	end
	if TRP3_RegisterAbout_AboutPanel.musicURL then
		TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_MusicPlayer, TRP3_RegisterAbout_AboutPanel);
	end
end

function TRP3_UI_AboutSaveButton()
	save();
	TRP3_onPlayerAboutShow();
end

function TRP3_UI_AboutCancelButton()
	TRP3_onPlayerAboutShow();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_AboutInit()

	Comm.registerProtocolPrefix(VOTE_MESSAGE_PREFIX, vote);
	Comm.registerProtocolPrefix(VOTE_MESSAGE_R_PREFIX, voteResponse);
	
	-- UI
	TRP3_CreateRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);
	local bkgTab = TRP3_getTiledBkgListForListbox();
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_BckField, bkgTab, setEditBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_TemplateField, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PhysBkg, bkgTab, setTemplate3PhysBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PsyBkg, bkgTab, setTemplate3PsyBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_HistBkg, bkgTab, setTemplate3HistBkg, nil, 120, true);
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function() openIconBrowser(onPhisIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function() openIconBrowser(onPsychoIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function() openIconBrowser(onHistoIconSelected) end );
	TRP3_RegisterAbout_Edit_Music_Action:SetScript("OnClick", onMusicEditClicked);
	TRP3_RegisterAbout_Edit_Template2_Add:SetScript("OnClick", template2AddFrame);
	
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Title:SetText(loc("REG_PLAYER_ABOUT_TAGS"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Image:SetText(loc("CM_IMAGE"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Icon:SetText(loc("CM_ICON"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Color:SetText(loc("CM_COLOR"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Link:SetText(loc("CM_LINK"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H1.tagIndex = 1;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H2.tagIndex = 2;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H3.tagIndex = 3;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_P.tagIndex = 4;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H1:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H2:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H3:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_P:SetScript("OnClick", onContainerPTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Icon:SetScript("OnClick", function() openIconBrowser(onIconTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Color:SetScript("OnClick", function() TRP3_OpenColorBrowser(onColorTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Image:SetScript("OnClick", function() TRP3_OpenImageBrowser(onImageTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Link:SetScript("OnClick", onLinkTagClicked);
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkClick", onLinkClicked);
	
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkEnter", function(self, link, text)
		TRP3_MainTooltip:Hide();
		TRP3_MainTooltip:SetOwner(TRP3_RegisterAbout_AboutPanel, "ANCHOR_CURSOR");
		TRP3_MainTooltip:AddLine(text, 1, 1, 1, true);
		TRP3_MainTooltip:AddLine(link, 1, 1, 1, true);
		TRP3_MainTooltip:Show();
	end);
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkLeave", function() TRP3_MainTooltip:Hide(); end);

	TRP3_RegisterAbout_AboutPanel_Template3_1_Text:SetWidth(450);
	TRP3_RegisterAbout_AboutPanel_Template3_2_Text:SetWidth(450);
	TRP3_RegisterAbout_AboutPanel_Template3_3_Text:SetWidth(450);
	TRP3_RegisterAbout_Edit_Template3_PhysTitle:SetText(loc("REG_PLAYER_PHYSICAL"));
	TRP3_RegisterAbout_Edit_Template3_PsyTitle:SetText(loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterAbout_Edit_Template3_HistTitle:SetText(loc("REG_PLAYER_HISTORY"));
	TRP3_RegisterAbout_AboutPanel_EditButton:SetText(loc("CM_EDIT"));
	TRP3_RegisterAbout_Edit_SaveButton:SetText(loc("CM_SAVE"));
	TRP3_RegisterAbout_Edit_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetText(loc("CM_PLAY"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetText(loc("CM_STOP"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Title:SetText(loc("REG_PLAYER_ABOUT_MUSIC"));
	
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("p",GameFontNormal);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h1",GameFontNormalHuge3);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h2",GameFontNormalHuge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h3",GameFontNormalLarge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h1",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h2",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h3",1,1,1);

	TRP3_InitIconButton(TRP3_RegisterAbout_AboutPanel_ThumbResult, "INV_Inscription_RunescrollOfFortitude_Green");
	TRP3_InitIconButton(TRP3_RegisterAbout_AboutPanel_ThumbUp, "THUMBUP");
	TRP3_InitIconButton(TRP3_RegisterAbout_AboutPanel_ThumbDown, "THUMBSDOWN");
	
	TRP3_SetTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbUp, "LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTE_UP"), loc("REG_PLAYER_ABOUT_VOTE_TT") .. "\n\n" .. Utils.str.color("y") .. loc("REG_PLAYER_ABOUT_VOTE_TT2"));
	TRP3_SetTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbDown, "LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTE_DOWN"), loc("REG_PLAYER_ABOUT_VOTE_TT") .. "\n\n" .. Utils.str.color("y") .. loc("REG_PLAYER_ABOUT_VOTE_TT2"));
	TRP3_RegisterAbout_AboutPanel_ThumbUp:SetScript("OnClick", function() sendVote(1) end);
	TRP3_RegisterAbout_AboutPanel_ThumbDown:SetScript("OnClick", function() sendVote(-1) end);
	
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetScript("OnClick", function()
		Utils.music.play(TRP3_RegisterAbout_AboutPanel.musicURL);
	end);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetScript("OnClick", function()
		Utils.music.stop();
	end);
	
	compressData();
end