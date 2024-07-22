-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

local function GenerateFilteredMusicList(query)
	local results = {};

	query = TRP3_StringUtil.GenerateSearchableString(query);

	local function CheckStringMatch(musicName)
		local searchName = TRP3_StringUtil.GenerateSearchableString(musicName);
		local offset = 1;
		local plain = true;

		return (string.find(searchName, query, offset, plain));
	end

	local predicate = (query ~= "" and CheckStringMatch or "");

	for musicResult in LRPM12:FindMusic(predicate, { reuseTable = {} }) do
		local musicInfo = { name = musicResult.matchingName, file = musicResult.file, duration = musicResult.duration };
		table.insert(results, musicInfo);
	end

	return results;
end

local MusicDurationFormatter = CreateFromMixins(SecondsFormatterMixin);
MusicDurationFormatter:Init(1, SecondsFormatter.Abbreviation.Truncate, true, true);
MusicDurationFormatter:SetDesiredUnitCount(2);

TRP3_MusicBrowserListElementMixin = CreateFromMixins(CallbackRegistryMixin, TRP3_TooltipScriptMixin);
TRP3_MusicBrowserListElementMixin:GenerateCallbackEvents({ "OnMusicSelected" });

function TRP3_MusicBrowserListElementMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	self.Border:SetVertexColor(TRP3_BACKDROP_COLOR_CREAMY_BROWN:GetRGB());
end

function TRP3_MusicBrowserListElementMixin:OnEnter()
	TRP3_TooltipScriptMixin.OnEnter(self);
	self.Highlight:Show();
end

function TRP3_MusicBrowserListElementMixin:OnLeave()
	TRP3_TooltipScriptMixin.OnLeave(self);
	self.Highlight:Hide();
end

function TRP3_MusicBrowserListElementMixin:OnClick(mouseButtonName)
	local musicInfo = self:GetElementData();
	PlaySound(TRP3_InterfaceSounds.ButtonClick);

	if mouseButtonName == "LeftButton" then
		self:TriggerEvent("OnMusicSelected", musicInfo);
	elseif mouseButtonName == "RightButton" then
		TRP3_API.utils.music.playMusic(musicInfo.file);
	end
end

function TRP3_MusicBrowserListElementMixin:OnTooltipShow(description)
	local musicInfo = self:GetElementData();
	local musicTitle = musicInfo.name;
	local musicDuration = MusicDurationFormatter:Format(floor(musicInfo.duration + 0.5));

	description:AddTitleLine(musicTitle);
	description:AddDelimitedLine(L.UI_MUSIC_DURATION, musicDuration);
	description:AddBlankLine();
	description:AddInstructionLine("LCLICK", L.REG_PLAYER_ABOUT_MUSIC_SELECT);
	description:AddInstructionLine("RCLICK", L.REG_PLAYER_ABOUT_MUSIC_LISTEN);
end

function TRP3_MusicBrowserListElementMixin:Init(musicInfo)
	self:SetText(musicInfo.name);
end

TRP3_MusicBrowserMixin = {};

function TRP3_MusicBrowserMixin:OnLoad()
	BackdropTemplateMixin.OnBackdropLoaded(self);

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self, "TOPLEFT", 15, -35),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.ScrollBar, "BOTTOMLEFT", -10, 0),
	};

	local scrollBoxAnchorsWithoutBar = {
		scrollBoxAnchorsWithBar[1],
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -15, 78),
	};

	self.ScrollView = CreateScrollBoxListLinearView();
	self.ScrollView:SetElementInitializer("TRP3_MusicBrowserListElementTemplate", function(...) self:OnListElementInitialize(...); end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);

	self.Filter.SearchBox:HookScript("OnTextChanged", TRP3_FunctionUtil.Debounce(0.25, function() self:Update(); end));
	self.Filter.StopButton:SetScript("OnClick", function() self:OnStopButtonClick() end);
	self.CloseButton:SetScript("OnClick", function() self:OnCloseButtonClick(); end);
end

function TRP3_MusicBrowserMixin:OnShow()
	self.Title:SetText(L.UI_MUSIC_BROWSER);
	self.Filter.StopButton:SetText(L.REG_PLAYER_ABOUT_MUSIC_STOP);
end

function TRP3_MusicBrowserMixin:OnCloseButtonClick()
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Close();
end

function TRP3_MusicBrowserMixin:OnStopButtonClick()
	TRP3_API.utils.music.stopMusic();
end

function TRP3_MusicBrowserMixin:OnMusicSelected(musicInfo)
	securecallfunction(self.callback, musicInfo.file);
	self:Close();
end

function TRP3_MusicBrowserMixin:OnListElementInitialize(button, musicInfo)
	button:Init(musicInfo);
	button:RegisterCallback("OnMusicSelected", self.OnMusicSelected, self);
end

function TRP3_MusicBrowserMixin:Open(callback)
	self.callback = callback;
	self.Filter.SearchBox:SetText("");
	self.Filter.SearchBox:SetFocus();
	self:Update();
end

function TRP3_MusicBrowserMixin:Update()
	local filteredMusicList = GenerateFilteredMusicList(self.Filter.SearchBox:GetText());
	local filteredMusicCount = #filteredMusicList;
	local totalMusicCount = LRPM12:GetNumMusic();

	local provider = CreateDataProvider(filteredMusicList);
	self.Filter.TotalText:SetText(string.format(GENERIC_FRACTION_STRING, filteredMusicCount, totalMusicCount));
	self.ScrollBox:SetDataProvider(provider);
end

function TRP3_MusicBrowserMixin:Close()
	TRP3_API.popup.hidePopups();
	self:Hide();
end
