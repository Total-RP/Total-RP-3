--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, Utils, Comm, Events = TRP3_GLOBALS, TRP3_UTILS, TRP3_COMM, TRP3_EVENTS;
local TRP3_NPCDialogFrame = TRP3_NPCDialogFrame;
local TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou = TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local tostring, strsplit = tostring, strsplit;
local ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText = ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText;
local GetRewardText, GetQuestText = GetRewardText, GetQuestText;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_SEQUENCE_SPEED = 1000;
local ANIMATION_TEXT_SPEED = 40;
local ANIMATION_SEQUENCE_DURATION = {
	["64"] = 3000,
	["65"] = 3000,
	["60"] = 4000,
	["0"] = 2000,
}

local function playText(textIndex)
	local text = TRP3_NPCDialogFrameChat.texts[textIndex];
	local animTab = {};
	local sound;
	text:gsub("[%.%?%!]+", function(finder)
		if finder:sub(1, 1) == "!" then
			animTab[#animTab+1] = 64;
		elseif finder:sub(1, 1) == "?" then
			animTab[#animTab+1] = 65;
		else
			animTab[#animTab+1] = 60;
		end
	end);
	animTab[#animTab+1] = 0;

	TRP3_NPCDialogFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_SAY"].r, ChatTypeInfo["MONSTER_SAY"].g, ChatTypeInfo["MONSTER_SAY"].b);
	TRP3_NPCDialogFrameChatText:SetText(text);

	TRP3_NPCDialogFrameModelsYou.seqtime = 0;
	TRP3_NPCDialogFrameModelsYou.sequenceTab = animTab;
	TRP3_NPCDialogFrameModelsYou.sequence = 1;
	
	TRP3_NPCDialogFrameChat.start = 0;
end

local function playNext()
	TRP3_NPCDialogFrameChat.currentIndex = TRP3_NPCDialogFrameChat.currentIndex + 1;
	playText(TRP3_NPCDialogFrameChat.currentIndex);
end

local function playPrevious()
	TRP3_NPCDialogFrameChat.currentIndex = TRP3_NPCDialogFrameChat.currentIndex - 1;
	playText(TRP3_NPCDialogFrameChat.currentIndex);
end

local function startDialog(targetType, fullText)
	TRP3_NPCDialogFrameModelsYou:SetCamera(1);
	TRP3_NPCDialogFrameModelsYou:SetFacing(-0.75);
	TRP3_NPCDialogFrameModelsYou:SetUnit(targetType);
	TRP3_NPCDialogFrameModelsYou:SetLight(1, 0, 0, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

	fullText = fullText:gsub("\n+", "\n");
	local texts = {strsplit("\n", fullText)};
	TRP3_NPCDialogFrameChat.texts = texts;
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	
	TRP3_NPCDialogFrame:Show();

	playNext();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ANIMATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onUpdateModel(self, elapsed)
	if self.seqtime and self.sequence and self.sequenceTab then
		self.seqtime = self.seqtime + (elapsed * ANIMATION_SEQUENCE_SPEED);
		if self.sequenceTab[self.sequence] ~= 0 then
			self:SetSequenceTime(self.sequenceTab[self.sequence], self.seqtime);
		end
		local sequenceString = tostring(self.sequenceTab[self.sequence]);
		-- Once the anim is finished, go to the next one.
		if ANIMATION_SEQUENCE_DURATION[sequenceString] and self.seqtime > ANIMATION_SEQUENCE_DURATION[sequenceString] then
			self.seqtime = 0;
			if self.sequence < #self.sequenceTab then
				self.sequence = self.sequence + 1;
			end
		end
	end
end

local function onUpdateChatText(self, elapsed)
	if self.start then
		self.time = 0;
		self.start = self.start + (elapsed * ANIMATION_TEXT_SPEED);
		if self.start == TRP3_NPCDialogFrameChatText:GetText():len() then
			self.start = nil;
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(0,0);
		else
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()
	TRP3_NPCDialogFrameModelsMe:SetCamera(1);
	TRP3_NPCDialogFrameModelsMe:SetFacing(0.75);
	TRP3_NPCDialogFrameModelsMe:SetUnit("player");
	TRP3_NPCDialogFrameModelsMe:SetLight(1, 0, 0, -1, -1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

	TRP3_NPCDialogFrameChatNext:SetScript("OnClick", playNext);
	TRP3_NPCDialogFrameChatPrevious:SetScript("OnClick", playPrevious);
	TRP3_NPCDialogFrameModelsYou:SetScript("OnUpdate", onUpdateModel);
	TRP3_NPCDialogFrameChat:SetScript("OnUpdate", onUpdateChatText);
	
	-- Showing
	Utils.event.registerHandler("QUEST_PROGRESS", function()
		startDialog("npc", GetProgressText());
	end);
	Utils.event.registerHandler("QUEST_GREETING", function()
		startDialog("npc", GetGreetingText());
	end);
	Utils.event.registerHandler("GOSSIP_SHOW", function()
		startDialog("npc", GetGossipText());
	end);
	Utils.event.registerHandler("QUEST_DETAIL", function()
		startDialog("npc", GetQuestText());
	end);
	Utils.event.registerHandler("QUEST_COMPLETE", function()
		startDialog("npc", GetRewardText());
	end);
	-- Closing
	Utils.event.registerHandler("GOSSIP_CLOSED", function()
		TRP3_NPCDialogFrame:Hide();
	end);
	Utils.event.registerHandler("QUEST_FINISHED", function()
		TRP3_NPCDialogFrame:Hide();
	end);
end

local MODULE_STRUCTURE = {
	["module_name"] = "Better NPC chat",
	["module_version"] = 1.000,
	["module_id"] = "better_npc_chat",
	["onLoaded"] = init,
	["min_version"] = 0.1,
};

TRP3_MODULE.registerModule(MODULE_STRUCTURE);