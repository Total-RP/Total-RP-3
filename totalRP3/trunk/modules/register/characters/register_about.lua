--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : About section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_API.profile.getData;
local safeGet = TRP3_API.profile.getDataDefault;
local loc = TRP3_API.locale.getText;
local tcopy, tsize = Utils.table.copy, Utils.table.size;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local showIconBrowser = TRP3_API.popup.showIconBrowser;
local unitIDToInfo = Utils.str.unitIDToInfo;
local Log = Utils.log;
local getConfigValue = TRP3_API.configuration.getValue;
local CreateFrame = CreateFrame;
local tostring, unpack = tostring, unpack;
local assert, tinsert, type, wipe, _G, strconcat, tonumber, pairs, tremove, math = assert, tinsert, type, wipe, _G, strconcat, tonumber, pairs, tremove, math;
local getTiledBackground = TRP3_API.ui.frame.getTiledBackground;
local getTiledBackgroundList = TRP3_API.ui.frame.getTiledBackgroundList;
local showIfMouseOver = TRP3_API.ui.frame.showIfMouseOverFrame;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local TRP3_RegisterAbout_AboutPanel = TRP3_RegisterAbout_AboutPanel;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local getUnitID = Utils.str.getUnitID;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile = TRP3_API.register.hasProfile;
local showConfirmPopup = TRP3_API.popup.showConfirmPopup;

local refreshTemplate2EditDisplay, saveInDraft, template2SaveToDraft; -- Function reference

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

getDefaultProfile().player.about = {
	v = 1,
	TE = 1,
	T1 = {

	},
	T2 = {

	},
	T3 = {
		PH = {}, PS = {}, HI = {}
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ABOUT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData = nil;

local function setBkg(frame, bkg)
	local backdrop = frame:GetBackdrop();
	backdrop.bgFile = getTiledBackground(bkg or 1);
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

local function shouldShowTemplate1(dataTab)
	local templateData = dataTab.T1 or {};
	return templateData.TX and templateData.TX:len() > 0;
end

local function showTemplate1(dataTab)
	local templateData = dataTab.T1 or {};
	if shouldShowTemplate1(dataTab) then
		local text = Utils.str.toHTML(templateData.TX or "");
		TRP3_RegisterAbout_AboutPanel_Template1:SetText(text);
	else
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
		TRP3_RegisterAbout_AboutPanel_Template1:SetText("");
	end
	TRP3_RegisterAbout_AboutPanel_Template1:Show();
end

local function onLinkClicked(self, url)
	TRP3_API.popup.showTextInputPopup(loc("UI_LINK_WARNING"), nil, nil, url);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 2
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local template2Frames = {};
local TEMPLATE2_PADDING = 30;

local function shouldShowTemplate2(dataTab)
	local templateData = dataTab.T2 or {};
	local atLeastOneFrame = false;
	for _, frameTab in pairs(templateData) do
		if frameTab.TX and frameTab.TX:len() > 0 then
			atLeastOneFrame = true;
		end
	end
	return atLeastOneFrame;
end

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
		backdrop.bgFile = getTiledBackground(frameTab.BK or 1);
		frame:SetBackdrop(backdrop);
		setupIconButton(icon, frameTab.IC or Globals.icons.default);
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

		if frameTab.TX and frameTab.TX:len() > 0 then
			frame:Show();
			previous = frame;
		else
			frame:Hide();
		end

		frameIndex = frameIndex + 1;
		bool = not bool;
	end

	if not shouldShowTemplate2(dataTab) then
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
	end

	TRP3_RegisterAbout_AboutPanel_Template2:Show();
end

local template2EditFrames = {};

local function setTemplate2EditBkg(bkg, frame)
	frame = frame:GetParent();
	assert(frame.frameData, "No frameData in the frame ...");
	setBkg(frame, bkg);
	frame.frameData.BK = bkg;
end

local function template2DeleteFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	tremove(templateData, frame.index);
	refreshTemplate2EditDisplay();
end

local function template2UpFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index - 1, frameData);
	refreshTemplate2EditDisplay();
end

local function template2DownFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index + 1, frameData);
	refreshTemplate2EditDisplay();
end

local function createTemplate2Frame(frameIndex)
	local frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Edit"..frameIndex, TRP3_RegisterAbout_Edit_Template2_Container, "TRP3_RegisterAbout_Template2_Edit");
	setupListBox(_G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."Bkg"], getTiledBackgroundList(), setTemplate2EditBkg, nil, 120, true);
	_G[frame:GetName().."Delete"]:SetScript("OnClick", template2DeleteFrame);
	_G[frame:GetName().."Delete"]:SetText(loc("CM_REMOVE"));
	_G[frame:GetName().."Up"]:SetScript("OnClick", template2UpFrame);
	_G[frame:GetName().."Down"]:SetScript("OnClick", template2DownFrame);
	setTooltipAll(_G[frame:GetName().."Up"], "TOP", 0, 0, loc("CM_MOVE_UP"));
	setTooltipAll(_G[frame:GetName().."Down"], "TOP", 0, 0, loc("CM_MOVE_DOWN"));
	tinsert(template2EditFrames, frame);
	return frame;
end

function refreshTemplate2EditDisplay()
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
			frame = createTemplate2Frame(frameIndex);
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
		_G[frame:GetName().."TextScrollText"]:SetText(frameData.TX or "");
		setupIconButton(_G[frame:GetName().."Icon"], frameData.IC or Globals.icons.default);
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function()
			showIconBrowser(function(icon)
				frame.frameData.IC = icon;
				setupIconButton(_G[frame:GetName().."Icon"], icon);
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
	template2SaveToDraft();
	local templateData = draftData.T2;
	tinsert(templateData, {TX = loc("REG_PLAYER_ABOUT_SOME")});
	TRP3_RegisterAbout_AboutPanel_Edit:Hide(); -- Hack to prevent invisible ScrollFontString bug
	refreshTemplate2EditDisplay();
	TRP3_RegisterAbout_AboutPanel_Edit:Show();
end

--- Save to draft all the frames texts
function template2SaveToDraft()
	for _, frame in pairs(template2EditFrames) do
		if frame:IsVisible() then
			assert(frame.frameData, "Frame has no frameData !");
			frame.frameData.TX = stEtN(_G[frame:GetName().."TextScrollText"]:GetText());
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
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, icon or Globals.icons.default);
end

local function onPsychoIconSelected(icon)
	draftData.T3.PS.IC = icon;
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, icon or Globals.icons.default);
end

local function onHistoIconSelected(icon)
	draftData.T3.HI.IC = icon;
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, icon or Globals.icons.default);
end

local function shouldShowTemplate3(dataTab)
	local atLeastOneFrame = false;
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	for i=1, 3 do
		local data = datas[i] or {};
		if data.TX and data.TX:len() > 0 then
			atLeastOneFrame = true;
		end
	end
	return atLeastOneFrame;
end

local function showTemplate3(dataTab)
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	local titles = {loc("REG_PLAYER_PHYSICAL"), loc("REG_PLAYER_PSYCHO"), loc("REG_PLAYER_HISTORY")};

	for i=1, 3 do
		local data = datas[i] or {};
		local frame = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s"):format(i)];
		if data.TX and data.TX:len() > 0 then
			local icon = Utils.str.icon(data.IC or Globals.icons.default, 25);
			local title = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Title"):format(i)];
			local text = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Text"):format(i)];
			title:SetText(icon.."    "..titles[i].."    "..icon);
			text:SetText(Utils.str.convertTextTags(data.TX));
			setBkg(frame, data.BK);
			frame:SetHeight(title:GetHeight() + text:GetHeight() + TEMPLATE3_MARGIN);
			frame:Show();
		else
			frame:Hide();
			frame:SetHeight(1);
		end
	end
	if not shouldShowTemplate3(dataTab) then
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
	end
	TRP3_RegisterAbout_AboutPanel_Template3:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- VOTE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local sendVote;
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

local function showVotingOption(voteValue)
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context !");
	assert(not context.isPlayer, "Trying to vote for yourself ...");

	local profile = context.profile;
	if profile.link then
		if tsize(profile.link) == 1 then
			for unitID, _ in pairs(profile.link) do -- For loop because it's a hash table
				sendVote(voteValue, unitID, profile);
			end
		else
		-- TODO: auto detect which is online
		end
	end
end

function sendVote(voteValue, target, profile)
	if target ~= Globals.player_id and profile and profile.about then
		if voteValue == profile.about.vote then
			voteValue = 0; -- Unvoting
		end
		Comm.sendObject(VOTE_MESSAGE_PREFIX, {voteValue, Globals.player_hash}, target, VOTE_MESSAGE_PRIORITY);
		local playerName = unitIDToInfo(target);
		Utils.message.displayMessage(loc("REG_PLAYER_ABOUT_VOTE_SENDING"):format(playerName));
	end
end

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

local function refreshPlayerVoteDisplay()
	if getCurrentPageID() == "player_main" then
		local context = getCurrentContext();
		if context and context.isPlayer and context.profile and context.profile.about then
			setTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbResult,
				"LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTES"),
				loc("REG_PLAYER_ABOUT_VOTES_R"):format(aggregateVotes(context.profile.about.vote))
			);
		end
	end
end

-- Someone vote for your description
local function vote(values, sender)
	local value, fromHash = unpack(values);
	Log.log(("Receive vote from %s: %s (%s)"):format(sender, value, fromHash));
	local about = get("player/about");
	if not about.vote then
		about.vote = {};
	end
	about.vote[fromHash] = value;
	Comm.sendObject(VOTE_MESSAGE_R_PREFIX, value, sender, VOTE_MESSAGE_R_PRIORITY);
	refreshPlayerVoteDisplay();
end

-- Your vote has been registered
local function voteResponse(value, sender)
	local value = tonumber(value);
	if isUnitIDKnown(sender) and hasProfile(sender) and getUnitIDProfile(sender).about then
		getUnitIDProfile(sender).about.vote = value;
		local playerName = unitIDToInfo(sender);
		Utils.message.displayMessage(loc("REG_PLAYER_ABOUT_VOTE_SENDING_OK"):format(playerName));
		if getCurrentPageID() == "player_main" then
			local context = getCurrentContext();
			assert(context, "No context for page player_main !");
			if context.profile == getUnitIDProfile(sender) then
				refreshVoteDisplay(getUnitIDProfile(sender).about);
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
	dataToSend.vote = nil; -- Don't send your votes ...
	-- Don't send data about templates you don't use ...
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

function TRP3_API.register.player.getAboutExchangeData()
	if currentCompressed ~= nil then
		return currentCompressed;
	else
		return getOptimizedData();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local templatesFunction = {
	showTemplate1,
	showTemplate2,
	showTemplate3
}

local function refreshConsultDisplay(context)
	local dataTab = context.profile.about or Globals.empty;
	local template = dataTab.TE or 1;
	TRP3_RegisterAbout_AboutPanel.isMine = context.isPlayer;
	TRP3_RegisterAbout_AboutPanel_ThumbResult:Hide();
	TRP3_RegisterAbout_AboutPanel_ThumbUp:Hide();
	TRP3_RegisterAbout_AboutPanel_ThumbDown:Hide();

	if context.isPlayer then
		TRP3_RegisterAbout_AboutPanel_ThumbResult:Show();
		refreshPlayerVoteDisplay();
	else
		if dataTab ~= Globals.empty then
			dataTab.read = true;
		end
		Events.fireEvent(Events.REGISTER_ABOUT_READ, context.profile.link);
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

function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.BK = TRP3_RegisterAbout_Edit_BckField:GetSelectedValue();
	draftData.TE = TRP3_RegisterAbout_Edit_TemplateField:GetSelectedValue();
	-- Template 1
	draftData.T1.TX = TRP3_RegisterAbout_Edit_Template1ScrollText:GetText();
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

	local dataTab = get("player/about");
	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- Reinit votes
	if dataTab.vote then
		wipe(dataTab.vote);
	end
	dataTab.vote = nil;
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);

	compressData();
	Events.fireEvent(Events.REGISTER_ABOUT_SAVED);
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
	TRP3_RegisterAbout_Edit_Template1ScrollText:SetText(template1Data.TX or "");
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
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, template3Data.PH.IC or Globals.icons.default);
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, template3Data.PS.IC or Globals.icons.default);
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, template3Data.HI.IC or Globals.icons.default);
	TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetText(template3Data.PH.TX or "");
	TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetText(template3Data.PS.TX or "");
	TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetText(template3Data.HI.TX or "");

	TRP3_RegisterAbout_AboutPanel_Edit:Show();
	setEditTemplate(draftData.TE or 1);
end

local function refreshDisplay()
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");

	--Hide all templates
	TRP3_RegisterAbout_AboutPanel_Template1:Hide();
	TRP3_RegisterAbout_AboutPanel_Template2:Hide();
	TRP3_RegisterAbout_AboutPanel_Template3:Hide();
	TRP3_RegisterAbout_AboutPanel_Empty:Hide();
	TRP3_RegisterAbout_AboutPanel:Hide();
	TRP3_RegisterAbout_AboutPanel_Edit:Hide();

	if context.isEditMode then
		assert(context.isPlayer, "Trying to show About edition for another than mine ...");
		refreshEditDisplay();
	else
		refreshConsultDisplay(context);
	end
end

local function showAboutTab()
	TRP3_RegisterAbout_AboutPanel_MusicPlayer:Hide();
	TRP3_RegisterAbout:Show();
	getCurrentContext().isEditMode = false;
	refreshDisplay();
end
TRP3_API.register.ui.showAboutTab = showAboutTab;

local function onEdit()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	getCurrentContext().isEditMode = true;
	refreshDisplay();
end

function TRP3_API.register.ui.shouldShowAboutTab(profile)
	if profile and profile.about then
		local dataTab = profile.about;
		return (dataTab.TE == 1 and shouldShowTemplate1(dataTab))
		or (dataTab.TE == 2 and shouldShowTemplate2(dataTab))
		or (dataTab.TE == 3 and shouldShowTemplate3(dataTab));
	end
	return false;
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
		TRP3_API.popup.showMusicBrowser(onMusicSelected);
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
	displayDropDown(button, values, onMusicEditSelected, 0, true);
end

local function getUnitIDTheme(unitID)
	if unitID == Globals.player_id then
		return get("player/about/MU");
	elseif isUnitIDKnown(unitID) and hasProfile(unitID) and getUnitIDProfile(unitID).about then
		return getUnitIDProfile(unitID).about.MU;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI MISC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_RegisterAbout_AboutPanel_Thumb = TRP3_RegisterAbout_AboutPanel_Thumb;
local TRP3_RegisterAbout_AboutPanel_EditButton = TRP3_RegisterAbout_AboutPanel_EditButton;
local TRP3_RegisterAbout_AboutPanel_MusicPlayer = TRP3_RegisterAbout_AboutPanel_MusicPlayer;

local function onPlayerAboutRefresh()
	if getConfigValue("register_about_use_vote") and (getCurrentContext().isPlayer or (getCurrentContext().profile.link and tsize(getCurrentContext().profile.link) > 0)) then
		showIfMouseOver(TRP3_RegisterAbout_AboutPanel_Thumb, TRP3_RegisterAbout_AboutPanel);
	end
	if TRP3_RegisterAbout_AboutPanel.isMine then
		showIfMouseOver(TRP3_RegisterAbout_AboutPanel_EditButton, TRP3_RegisterAbout_AboutPanel);
	end
	if TRP3_RegisterAbout_AboutPanel.musicURL then
		showIfMouseOver(TRP3_RegisterAbout_AboutPanel_MusicPlayer, TRP3_RegisterAbout_AboutPanel);
	end
end

local function onSave()
	save();
	showAboutTab();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.inits.aboutInit()

	Comm.registerProtocolPrefix(VOTE_MESSAGE_PREFIX, vote);
	Comm.registerProtocolPrefix(VOTE_MESSAGE_R_PREFIX, voteResponse);

	TRP3_API.target.registerButton({
		id = "char_music",
		onlyForType = TRP3_API.target.TYPE_CHARACTER,
		configText = loc("TF_PLAY_THEME"),
		condition = function(targetType, unitID)
			return getUnitIDTheme(unitID) ~= nil;
		end,
		onClick = function(unitID, _, button)
			if button == "LeftButton" then
				Utils.music.play(getUnitIDTheme(unitID));
			else
				Utils.music.stop();
			end
		end,
		adapter = function(buttonStructure, unitID)
			local theme = getUnitIDTheme(unitID);
			if theme then
				buttonStructure.tooltipSub = loc("TF_PLAY_THEME_TT"):format(Utils.music.getTitle(theme));
			end
		end,
		tooltip = loc("TF_PLAY_THEME"),
		icon = "inv_misc_drum_06"
	});

	-- UI
	createRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);
	local bkgTab = getTiledBackgroundList();
	setupListBox(TRP3_RegisterAbout_Edit_BckField, bkgTab, setEditBkg, nil, 120, true);
	setupListBox(TRP3_RegisterAbout_Edit_TemplateField, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 120, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_PhysBkg, bkgTab, setTemplate3PhysBkg, nil, 120, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_PsyBkg, bkgTab, setTemplate3PsyBkg, nil, 120, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_HistBkg, bkgTab, setTemplate3HistBkg, nil, 120, true);
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function() showIconBrowser(onPhisIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function() showIconBrowser(onPsychoIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function() showIconBrowser(onHistoIconSelected) end );
	TRP3_RegisterAbout_Edit_Music_Action:SetScript("OnClick", onMusicEditClicked);
	TRP3_RegisterAbout_Edit_Template2_Add:SetScript("OnClick", template2AddFrame);
	TRP3_RegisterAbout_AboutPanel_EditButton:SetScript("OnClick", onEdit);
	TRP3_RegisterAbout_Edit_SaveButton:SetScript("OnClick", onSave);
	TRP3_RegisterAbout_Edit_CancelButton:SetScript("OnClick", showAboutTab);

	TRP3_RegisterAbout_AboutPanel_Empty:SetText(loc("REG_PLAYER_ABOUT_EMPTY"));
	TRP3_API.ui.text.setupToolbar("TRP3_RegisterAbout_Edit_Template1_Toolbar", TRP3_RegisterAbout_Edit_Template1ScrollText);
	
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
	TRP3_RegisterAbout_Edit_Template2_Add:SetText(loc("REG_PLAYER_ABOUT_ADD_FRAME"));
	TRP3_RegisterAbout_AboutPanel_EditButton:SetText(loc("CM_EDIT"));
	TRP3_RegisterAbout_Edit_SaveButton:SetText(loc("CM_SAVE"));
	TRP3_RegisterAbout_Edit_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetText(loc("CM_PLAY"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetText(loc("CM_STOP"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Title:SetText(loc("REG_PLAYER_ABOUT_MUSIC"));

	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("p", GameFontNormal);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h1", GameFontNormalHuge3);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h2", GameFontNormalHuge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h3", GameFontNormalLarge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h1", 1, 1, 1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h2", 1, 1, 1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h3", 1, 1, 1);

	setupIconButton(TRP3_RegisterAbout_AboutPanel_ThumbResult, "INV_Inscription_RunescrollOfFortitude_Green");
	setupIconButton(TRP3_RegisterAbout_AboutPanel_ThumbUp, "THUMBUP");
	setupIconButton(TRP3_RegisterAbout_AboutPanel_ThumbDown, "THUMBSDOWN");

	setTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbUp, "LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTE_UP"), loc("REG_PLAYER_ABOUT_VOTE_TT") .. "\n\n" .. Utils.str.color("y") .. loc("REG_PLAYER_ABOUT_VOTE_TT2"));
	setTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_ThumbDown, "LEFT", 0, 5, loc("REG_PLAYER_ABOUT_VOTE_DOWN"), loc("REG_PLAYER_ABOUT_VOTE_TT") .. "\n\n" .. Utils.str.color("y") .. loc("REG_PLAYER_ABOUT_VOTE_TT2"));
	TRP3_RegisterAbout_AboutPanel_ThumbUp:SetScript("OnClick", function() showVotingOption(1) end);
	TRP3_RegisterAbout_AboutPanel_ThumbDown:SetScript("OnClick", function() showVotingOption(-1) end);

	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetScript("OnClick", function()
		Utils.music.play(TRP3_RegisterAbout_AboutPanel.musicURL);
	end);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetScript("OnClick", function()
		Utils.music.stop();
	end);

	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, compressData); -- On profile change, compress the new data
	compressData();
end