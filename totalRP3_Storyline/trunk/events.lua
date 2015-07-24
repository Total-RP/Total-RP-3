----------------------------------------------------------------------------------
-- Total RP 3
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

-- Storyline API
local configureHoverFrame = Storyline_API.lib.configureHoverFrame;
local setTooltipForSameFrame, setTooltipAll = Storyline_API.lib.setTooltipForSameFrame, Storyline_API.lib.setTooltipAll;
local refreshTooltipForFrame = Storyline_RefreshTooltipForFrame;
local Storyline_MainTooltip = Storyline_MainTooltip;
local log = Storyline_API.lib.log;
local registerHandler = Storyline_API.lib.registerHandler;
local getTextureString, colorCodeFloat = Storyline_API.lib.getTextureString, Storyline_API.lib.colorCodeFloat;
local getId = Storyline_API.lib.generateID;
local loc = Storyline_API.locale.getText;
local playSelfAnim, getDuration, playAnimationDelay = Storyline_API.playSelfAnim, Storyline_API.getDuration, Storyline_API.playAnimationDelay;
local getQuestIcon, getQuestActiveIcon = Storyline_API.getQuestIcon, Storyline_API.getQuestActiveIcon;
local getQuestTriviality = Storyline_API.getQuestTriviality;
local selectMultipleAvailableGreetings = Storyline_API.selectMultipleAvailableGreetings;
local selectMultipleActiveGreetings = Storyline_API.selectMultipleActiveGreetings;
local selectMultipleActive = Storyline_API.selectMultipleActive;
local selectFirstActive = Storyline_API.selectFirstActive;
local selectMultipleAvailable = Storyline_API.selectMultipleAvailable;
local selectFirstAvailable = Storyline_API.selectFirstAvailable;
local selectFirstGossip, selectMultipleGossip = Storyline_API.selectFirstGossip, Storyline_API.selectMultipleGossip;
local selectMultipleRewards, selectFirstGreetingActive = Storyline_API.selectMultipleRewards, Storyline_API.selectFirstGreetingActive;
local getAnimationByModel = Storyline_API.getAnimationByModel;

-- WOW API
local faction, faction_loc = UnitFactionGroup("player");
local pairs, CreateFrame, wipe, type, tinsert, after, select, huge = pairs, CreateFrame, wipe, type, tinsert, C_Timer.After, select, math.huge;
local ChatTypeInfo = ChatTypeInfo;
local UnitIsUnit, UnitExists, DeclineQuest, AcceptQuest = UnitIsUnit, UnitExists, DeclineQuest, AcceptQuest;
local IsQuestCompletable, CompleteQuest, CloseQuest, GetQuestLogTitle = IsQuestCompletable, CompleteQuest, CloseQuest, GetQuestLogTitle;
local GetNumQuestChoices, GetQuestReward, GetQuestLogSelection = GetNumQuestChoices, GetQuestReward, GetQuestLogSelection;
local GetQuestLogQuestText, GetGossipAvailableQuests, GetGossipActiveQuests = GetQuestLogQuestText, GetGossipAvailableQuests, GetGossipActiveQuests;
local GetNumGossipOptions, GetNumGossipAvailableQuests, GetNumGossipActiveQuests = GetNumGossipOptions, GetNumGossipAvailableQuests, GetNumGossipActiveQuests;
local GetQuestItemInfo, GetNumQuestItems, GetGossipOptions = GetQuestItemInfo, GetNumQuestItems, GetGossipOptions;
local GetObjectiveText, GetCoinTextureString, GetRewardXP = GetObjectiveText, GetCoinTextureString, GetRewardXP;
local GetQuestItemLink, GetNumQuestRewards, GetRewardMoney = GetQuestItemLink, GetNumQuestRewards, GetRewardMoney;
local GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests = GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests;
local GetAvailableTitle, GetActiveTitle, CloseGossip = GetAvailableTitle, GetActiveTitle, CloseGossip;
local GetProgressText, GetTitleText, GetGreetingText = GetProgressText, GetTitleText, GetGreetingText;
local GetGossipText, GetRewardText, GetQuestText = GetGossipText, GetRewardText, GetQuestText;
local GetItemInfo, GetContainerNumSlots, GetContainerItemLink, EquipItemByName = GetItemInfo, GetContainerNumSlots, GetContainerItemLink, EquipItemByName;
local InCombatLockdown, GetInventorySlotInfo, GetInventoryItemLink = InCombatLockdown, GetInventorySlotInfo, GetInventoryItemLink;

-- UI
local TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3 = TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3;
local TRP3_NPCDialogFrameObjectives, TRP3_NPCDialogFrameObjectivesNo, TRP3_NPCDialogFrameObjectivesYes = TRP3_NPCDialogFrameObjectives, TRP3_NPCDialogFrameObjectivesNo, TRP3_NPCDialogFrameObjectivesYes;
local TRP3_NPCDialogFrameObjectivesImage = TRP3_NPCDialogFrameObjectivesImage;
local TRP3_NPCDialogFrameRewardsItemIcon, TRP3_NPCDialogFrameRewardsItem, TRP3_NPCDialogFrameRewards = TRP3_NPCDialogFrameRewardsItemIcon, TRP3_NPCDialogFrameRewardsItem, TRP3_NPCDialogFrameRewards;
local TRP3_NPCDialogFrame, TRP3_NPCDialogFrameChatNextText = TRP3_NPCDialogFrame, TRP3_NPCDialogFrameChatNextText;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious = TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious;
local TRP3_NPCDialogFrameConfigButton, TRP3_NPCDialogFrameObjectivesContent = TRP3_NPCDialogFrameConfigButton, TRP3_NPCDialogFrameObjectivesContent;
local TRP3_NPCDialogFrameGossipChoices = TRP3_NPCDialogFrameGossipChoices;

-- Constants
local OPTIONS_MARGIN, OPTIONS_TOP = 175, -175;
local CHAT_MARGIN = 70;
local gossipColor = "|cffffffff";
local EVENT_INFO;
local eventHandlers = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Auto equip part, greatly inspired by AutoTurnIn by Alex Shubert (alex.shubert@gmail.com)
-- Thanks to him !
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SUPPORTED_SLOTS = {
	["INVTYPE_AMMO"]={"AmmoSlot"},
	["INVTYPE_HEAD"]={"HeadSlot"},
	["INVTYPE_NECK"]={"NeckSlot"},
	["INVTYPE_SHOULDER"]={"ShoulderSlot"},
	["INVTYPE_CHEST"]={"ChestSlot"},
	["INVTYPE_WAIST"]={"WaistSlot"},
	["INVTYPE_LEGS"]={"LegsSlot"},
	["INVTYPE_FEET"]={"FeetSlot"},
	["INVTYPE_WRIST"]={"WristSlot"},
	["INVTYPE_HAND"]={"HandsSlot"},
	["INVTYPE_FINGER"]={"Finger0Slot", "Finger1Slot"},
	["INVTYPE_TRINKET"]={"Trinket0Slot", "Trinket1Slot"},
	["INVTYPE_CLOAK"]={"BackSlot"},
	["INVTYPE_WEAPON"]={"MainHandSlot", "SecondaryHandSlot"},
	["INVTYPE_2HWEAPON"]={"MainHandSlot"},
	["INVTYPE_RANGED"]={"MainHandSlot"},
	["INVTYPE_RANGEDRIGHT"]={"MainHandSlot"},
	["INVTYPE_WEAPONMAINHAND"]={"MainHandSlot"},
	["INVTYPE_SHIELD"]={"SecondaryHandSlot"},
	["INVTYPE_WEAPONOFFHAND"]={"SecondaryHandSlot"},
	["INVTYPE_HOLDABLE"]={"SecondaryHandSlot"}
}

local function getItemLevel(itemLink)
	if (not itemLink) then
		return 0
	end
	-- 7 for heirloom http://wowprogramming.com/docs/api_types#itemQuality
	local invQuality, invLevel = select(3, GetItemInfo(itemLink));
	return (invQuality == 7) and huge or invLevel;
end

local AUTO_EQUIP_DELAY = 2;
local function autoEquip(itemLink)
	local name, link, quality, lootLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink);
	log(("autoEquip %s on slot %s"):format(name, equipSlot));

	-- First, determine if we should auto equip
	local shouldAutoEquip = false;
	local equipOn;
	if TRP3_Storyline.config.autoEquip then
		-- Compares reward and already equipped item levels. If reward level is greater than equipped item, auto equip reward
		local slot = SUPPORTED_SLOTS[equipSlot]
		if slot then
			log(("Supported slot %s"):format(equipSlot));
			local firstSlot = GetInventorySlotInfo(slot[1]);
			local invLink = GetInventoryItemLink("player", firstSlot);
			local eqLevel = getItemLevel(invLink);

			-- If reward is a ring  trinket or one-handed weapons all slots must be checked in order to swap one with a lesser item-level
			if #slot > 1 then
				local secondSlot = GetInventorySlotInfo(slot[2]);
				invLink = GetInventoryItemLink("player", secondSlot);
				if invLink then
					local eq2Level = getItemLevel(invLink);
					firstSlot = (eqLevel > eq2Level) and secondSlot or firstSlot;
					eqLevel = (eqLevel > eq2Level) and eq2Level or eqLevel;
				end
			end

			-- comparing lowest equipped item level with reward's item level
			log(("Comparing lvl: lootLevel %s vs eqLevel %s"):format(lootLevel, eqLevel));
			if lootLevel > eqLevel then
				shouldAutoEquip = true;
				equipOn = firstSlot;
			end
		end
	end

	if shouldAutoEquip then
		log(("Will auto equip %s on slot %s"):format(name, equipOn));
		after(AUTO_EQUIP_DELAY, function()
			if InCombatLockdown() then
				return;
			end
			for container=0, NUM_BAG_SLOTS do
				for slot=1, GetContainerNumSlots(container) do
					local link = GetContainerItemLink (container, slot);
					if link then
						local itemName = GetItemInfo(link);
						if itemName == name then
							log(("Found and trying to auto equip %s"):format(itemName, equipOn));
							EquipItemByName(name, equipOn);
							return;
						end
					end
				end
			end
		end);
	end
end

local function autoEquipAllReward()
	if GetNumQuestRewards() > 0 then
		for i=1, GetNumQuestRewards() do
			local link = GetQuestItemLink("reward", i);
			autoEquip(link);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getQuestData(qTitle)
	for questIndex=1, GetNumQuestLogEntries() do
		local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questIndex);
		if questTitle == qTitle then
			SelectQuestLogEntry(questIndex);
			local questDescription, questObjectives = GetQuestLogQuestText();
			return questObjectives or "";
		end
	end
	return "";
end

local itemButtons = {};
local function placeItemButton(frame, placeOn, position, first)
	local available;
	for _, button in pairs(itemButtons) do
		if not button:IsShown() then
			available = button;
			break;
		end
	end
	if not available then
		available = CreateFrame("Button", "TRP3_StorylineItemButton" .. #itemButtons, nil, "LargeItemButtonTemplate");
		available:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetQuestItem(self.type, self.index);
			GameTooltip_ShowCompareItem(GameTooltip);
		end);
		available:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end);
		available:SetScript("OnClick", function(self)
			local itemLink = GetQuestItemLink(self.type, self.index);
			if not HandleModifiedItemClick(itemLink) and self.type == "choice" then
				GetQuestReward(self.index);
				autoEquip(itemLink);
				autoEquipAllReward();
			end
		end);
		tinsert(itemButtons, available);
	end
	available:Show();
	available:SetParent(frame);
	available:ClearAllPoints();
	if position == "TOPLEFT" then
		available:SetPoint("TOPLEFT", placeOn, "BOTTOMLEFT", first and 0 or -157, -5);
	else
		available:SetPoint("TOPLEFT", placeOn, "TOPRIGHT", 10, 0);
	end
	return available;
end

local function decorateItemButton(button, index, type, texture, name, numItems, isUsable)
	button.index = index;
	button.type = type;
	button.Icon:SetTexture(texture);
	button.Name:SetText(name);
	button.Count:SetText(numItems > 1 and numItems or "");
	if isUsable then
		button.Icon:SetVertexColor(1, 1, 1);
	else
		button.Icon:SetVertexColor(1, 0, 0);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT PART
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

eventHandlers["GOSSIP_SHOW"] = function()
	local hasGossip, hasAvailable, hasActive = GetNumGossipOptions() > 0, GetNumGossipAvailableQuests() > 0, GetNumGossipActiveQuests() > 0;
	local previous;

	-- Available quests
	if hasAvailable then
		TRP3_NPCDialogFrameChatOption1:Show();
		TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
		TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

		previous = TRP3_NPCDialogFrameChatOption1;
		if GetNumGossipAvailableQuests() == 1 then
			local title, lvl, isTrivial, frequency, isRepeatable, isLegendary = GetGossipAvailableQuests();
			local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
			TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. icon .. title .. getQuestTriviality(isTrivial));
			TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectFirstAvailable);
		else
			TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
			TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectMultipleAvailable);
		end
	end

	-- Active options
	if hasActive then
		TRP3_NPCDialogFrameChatOption2:Show();
		TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
		TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = TRP3_NPCDialogFrameChatOption2;
		if GetNumGossipActiveQuests() == 1 then
			local title, lvl, isTrivial, isComplete, isRepeatable = GetGossipActiveQuests();
			TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|T" .. getQuestActiveIcon(isComplete, isRepeatable) .. ":20:20|t " .. title .. getQuestTriviality(isTrivial));
			TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectFirstActive);
		else
			TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
			TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectMultipleActive);
		end
	end

	-- Gossip options
	if hasGossip then
		TRP3_NPCDialogFrameChatOption3:Show();
		TRP3_NPCDialogFrameChatOption3:SetScript("OnEnter", function() playSelfAnim(60) end);
		TRP3_NPCDialogFrameChatOption3:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption3:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption3:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			TRP3_NPCDialogFrameChatOption3:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			TRP3_NPCDialogFrameChatOption3:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = TRP3_NPCDialogFrameChatOption3;

		local gossips = { GetGossipOptions() };
		if GetNumGossipOptions() == 1 then
			local gossip, gossipType = gossips[1], gossips[2];
			TRP3_NPCDialogFrameChatOption3:SetText(gossipColor .. "|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:20:20|t " .. gossip);
			TRP3_NPCDialogFrameChatOption3:SetScript("OnClick", selectFirstGossip);
		else
			TRP3_NPCDialogFrameChatOption3:SetText(gossipColor .. "|TInterface\\GossipFrame\\PetitionGossipIcon:20:20|t " .. loc("SL_WELL"));
			TRP3_NPCDialogFrameChatOption3:SetScript("OnClick", selectMultipleGossip);
		end
	end

end

eventHandlers["QUEST_GREETING"] = function()
	local numActiveQuests = GetNumActiveQuests();
	local numAvailableQuests = GetNumAvailableQuests();
	local previous;

	if numActiveQuests > 0 then
		TRP3_NPCDialogFrameChatOption1:Show();
		TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
		TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

		previous = TRP3_NPCDialogFrameChatOption1;
		if numActiveQuests == 1 then
			local title, isComplete = GetActiveTitle(1);
			local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(1);
			local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
			TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|T" .. getQuestActiveIcon(isComplete, isRepeatable) .. ":20:20|t " .. title .. getQuestTriviality(isTrivial));
			TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectFirstGreetingActive);
		else
			TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
			TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectMultipleActiveGreetings);
		end
	end

	if numAvailableQuests > 0 then
		TRP3_NPCDialogFrameChatOption2:Show();
		TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
		TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = TRP3_NPCDialogFrameChatOption2;
		if numAvailableQuests == 1 then
			local title, isComplete = GetAvailableTitle(1);
			local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(numActiveQuests + 1);
			local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
			TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. icon .. title .. getQuestTriviality(isTrivial));
			TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectFirstAvailable);
		else
			TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
			TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectMultipleAvailableGreetings);
		end
	end
end

eventHandlers["QUEST_DETAIL"] = function()
	TRP3_NPCDialogFrameObjectives:Show();
	TRP3_NPCDialogFrameObjectivesImage:SetDesaturated(false);
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "TOP", 0, 0, QUEST_OBJECTIVES, loc("SL_CHECK_OBJ"));
	TRP3_NPCDialogFrameObjectivesContent.Objectives:SetText(GetObjectiveText());

	TRP3_NPCDialogFrameObjectivesContent:SetHeight(TRP3_NPCDialogFrameObjectivesContent.Objectives:GetHeight() + TRP3_NPCDialogFrameObjectivesContent.Title:GetHeight() + 25);

	if GetNumQuestItems() > 0 then
		local _, icon = GetQuestItemInfo("required", 1);
		TRP3_NPCDialogFrameObjectivesImage:SetTexture(icon);
	end
end

eventHandlers["QUEST_PROGRESS"] = function()
	TRP3_NPCDialogFrameObjectives:Show();
	TRP3_NPCDialogFrameObjectivesImage:SetDesaturated(not IsQuestCompletable());
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "TOP", 0, 0, QUEST_OBJECTIVES, loc("SL_CHECK_OBJ"));

	local questObjectives = getQuestData(GetTitleText());
	if IsQuestCompletable() then
		questObjectives = getTextureString("Interface\\RAIDFRAME\\ReadyCheck-Ready", 15) .. " |cff00ff00" .. questObjectives;
	else
		questObjectives = getTextureString("Interface\\RAIDFRAME\\ReadyCheck-NotReady", 15) .. " |cffff0000" .. questObjectives;
	end
	TRP3_NPCDialogFrameObjectivesContent.Objectives:SetText(questObjectives);

	local contentHeight = 0;
	if GetNumQuestItems() > 0 then
		TRP3_NPCDialogFrameObjectivesContent.RequiredItemText:Show();
		local previous = TRP3_NPCDialogFrameObjectivesContent.RequiredItemText;
		local anchor = "TOPLEFT";
		local _, icon = GetQuestItemInfo("required", 1);
		TRP3_NPCDialogFrameObjectivesImage:SetTexture(icon);
		for i = 1, GetNumQuestItems() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("required", i);
			local button = placeItemButton(TRP3_NPCDialogFrameObjectivesContent, previous, anchor, i == 1);
			decorateItemButton(button, i, "required", texture, name, numItems, isUsable);
			previous = button;
			if anchor == "TOPLEFT" then
				anchor = "LEFT";
			else
				anchor = "TOPLEFT";
			end
			contentHeight = contentHeight + ((i%2) * 46);
		end
		contentHeight = contentHeight + TRP3_NPCDialogFrameObjectivesContent.RequiredItemText:GetHeight() + 10;
	end
	contentHeight = contentHeight + TRP3_NPCDialogFrameObjectivesContent.Objectives:GetHeight() + TRP3_NPCDialogFrameObjectivesContent.Title:GetHeight() + 25;
	TRP3_NPCDialogFrameObjectivesContent:SetHeight(contentHeight);
end

eventHandlers["QUEST_COMPLETE"] = function(eventInfo)
	TRP3_NPCDialogFrameRewards:Show();
	setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "TOP", 0, 0, REWARDS, loc("SL_GET_REWARD"));

	local bestIcon = "Interface\\ICONS\\trade_archaeology_chestoftinyglassanimals";
	local contentHeight = 20;

	local reward1Text;
	local xp = GetRewardXP();
	if xp > 0 then
		contentHeight = contentHeight + 18;
		bestIcon = "Interface\\ICONS\\xp_icon";
		if reward1Text then
			reward1Text = reward1Text .. "\n";
		end
		reward1Text = (reward1Text or "") .. BONUS_OBJECTIVE_EXPERIENCE_FORMAT:format( "|cff00ff00" .. xp .. "|r");
	end
	local money = GetRewardMoney();
	if money > 0 then
		contentHeight = contentHeight + 18;
		bestIcon = "Interface\\ICONS\\inv_misc_coin_03";
		if money < 100 then
			bestIcon = "Interface\\ICONS\\inv_misc_coin_05";
		elseif money > 9999 then
			bestIcon = "Interface\\ICONS\\inv_misc_coin_01";
		end
		local moneyString = GetCoinTextureString(money);
		if reward1Text then
			reward1Text = reward1Text .. "\n";
		end
		reward1Text = (reward1Text or "") .. moneyString
	end
	TRP3_NPCDialogFrameRewards.Content.RewardText1Value:SetText(reward1Text);

	local previousForChoice = TRP3_NPCDialogFrameRewards.Content.RewardText1Value;

	if GetNumQuestChoices() == 1 or GetNumQuestRewards() > 0 then
		TRP3_NPCDialogFrameRewards.Content.RewardText2:Show();
		contentHeight = contentHeight + 20;
		local previous = TRP3_NPCDialogFrameRewards.Content.RewardText2;
		local anchor = "TOPLEFT";

		if GetNumQuestChoices() == 1 then
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("choice", 1);
			local button = placeItemButton(TRP3_NPCDialogFrameRewards.Content, previous, anchor, true);
			bestIcon = texture;
			decorateItemButton(button, 1, "choice", texture, name, numItems, isUsable);
			previous = button;
			if anchor == "TOPLEFT" then
				anchor = "LEFT";
			else
				anchor = "TOPLEFT";
			end
			contentHeight = contentHeight + 46;
			previousForChoice = button;
		end

		for i = 1, GetNumQuestRewards() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("reward", i);
			local button = placeItemButton(TRP3_NPCDialogFrameRewards.Content, previous, anchor, i == 1);
			bestIcon = texture;
			decorateItemButton(button, i, "reward", texture, name, numItems, isUsable);
			previous = button;
			if anchor == "TOPLEFT" then
				anchor = "LEFT";
			else
				anchor = "TOPLEFT";
			end
			contentHeight = contentHeight + ((i%2) * 46);
			previousForChoice = button;
		end
	end

	if GetNumQuestChoices() > 1 then
		if faction and faction:len() > 0 then
			bestIcon = "Interface\\ICONS\\battleground_strongbox_gold_" .. faction;
		else
			bestIcon = "Interface\\ICONS\\achievement_boss_spoils_of_pandaria";
		end
		contentHeight = contentHeight + 18;
		TRP3_NPCDialogFrameRewards.Content.RewardText3:Show();
		TRP3_NPCDialogFrameRewards.Content.RewardText3:SetPoint("TOP", previousForChoice, "BOTTOM", 0, -5);

		local previous = TRP3_NPCDialogFrameRewards.Content.RewardText3;
		local anchor = "TOPLEFT";

		for i = 1, GetNumQuestChoices() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("choice", i);
			local button = placeItemButton(TRP3_NPCDialogFrameRewards.Content, previous, anchor, i == 1);
			decorateItemButton(button, i, "choice", texture, name, numItems, isUsable);
			previous = button;
			if anchor == "TOPLEFT" then
				anchor = "LEFT";
			else
				anchor = "TOPLEFT";
			end
			contentHeight = contentHeight + ((i%2) * 46);
		end
	end

	TRP3_NPCDialogFrameRewardsItemIcon:SetTexture(bestIcon);
	contentHeight = contentHeight + TRP3_NPCDialogFrameRewards.Content.Title:GetHeight() + 15;
	TRP3_NPCDialogFrameRewards.Content:SetHeight(contentHeight);
end

local function handleEventSpecifics(event, texts, textIndex, eventInfo)
	-- Options
	for _, button in pairs(itemButtons) do
		button:Hide();
	end
	TRP3_NPCDialogFrameGossipChoices:Hide();
	TRP3_NPCDialogFrameRewards:Hide();
	TRP3_NPCDialogFrameObjectives:Hide();
	TRP3_NPCDialogFrameChatOption1:Hide();
	TRP3_NPCDialogFrameChatOption2:Hide();
	TRP3_NPCDialogFrameChatOption3:Hide();
	TRP3_NPCDialogFrameObjectivesYes:Hide();
	TRP3_NPCDialogFrameObjectivesNo:Hide();
	TRP3_NPCDialogFrameObjectives.OK:Hide();
	TRP3_NPCDialogFrameObjectivesContent.RequiredItemText:Hide();
	TRP3_NPCDialogFrameRewards.Content:Hide();
	TRP3_NPCDialogFrameRewards.Content.RewardText2:Hide();
	TRP3_NPCDialogFrameRewards.Content.RewardText3:Hide();
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption1);
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption2);
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption3);
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives);
	TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameChatOption3:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameObjectivesImage:SetTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon");

	if textIndex == #texts and eventHandlers[event] then
		eventHandlers[event](eventInfo);
	end
end

local function playText(textIndex, targetModel)
	local animTab = targetModel.animTab;
	wipe(animTab);

	local text = TRP3_NPCDialogFrameChat.texts[textIndex];
	local sound;
	local delay = 0;
	local textLineToken = getId();

	TRP3_NPCDialogFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_SAY"].r, ChatTypeInfo["MONSTER_SAY"].g, ChatTypeInfo["MONSTER_SAY"].b);

	if text:byte() == 60 or not UnitExists("npc") or UnitIsUnit("player", "npc") then -- Emote if begins with <
		local color = colorCodeFloat(ChatTypeInfo["MONSTER_EMOTE"].r, ChatTypeInfo["MONSTER_EMOTE"].g, ChatTypeInfo["MONSTER_EMOTE"].b);
		local finalText = text:gsub("<", color .. "<");
		finalText = finalText:gsub(">", ">|r");
		if not UnitExists("npc") or UnitIsUnit("player", "npc") then
			TRP3_NPCDialogFrameChatText:SetText(color .. finalText);
		else
			TRP3_NPCDialogFrameChatText:SetText(finalText);
		end
	else
		TRP3_NPCDialogFrameChatText:SetText(text);
		text:gsub("[%.%?%!]+", function(finder)
			animTab[#animTab + 1] = getAnimationByModel(targetModel.model, finder:sub(1, 1));
			animTab[#animTab + 1] = 0;
		end);
	end

	if #animTab == 0 then
		animTab[1] = 0;
	end

	for _, sequence in pairs(animTab) do
		delay = playAnimationDelay(targetModel, sequence, getDuration(targetModel.model, sequence), delay, textLineToken);
	end

	TRP3_NPCDialogFrameChat.start = 0;

	if #TRP3_NPCDialogFrameChat.texts > 1 then
		TRP3_NPCDialogFrameChatPrevious:Show();
	end

	handleEventSpecifics(TRP3_NPCDialogFrameChat.event, TRP3_NPCDialogFrameChat.texts, textIndex, TRP3_NPCDialogFrameChat.eventInfo);

	TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + 5);
end

function Storyline_API.playNext(targetModel)
	TRP3_NPCDialogFrameChatNext:Enable();
	TRP3_NPCDialogFrameChat.currentIndex = TRP3_NPCDialogFrameChat.currentIndex + 1;

	TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_NEXT"));
	if TRP3_NPCDialogFrameChat.currentIndex >= #TRP3_NPCDialogFrameChat.texts then
		if TRP3_NPCDialogFrameChat.eventInfo.finishText and (type(TRP3_NPCDialogFrameChat.eventInfo.finishText) ~= "function" or TRP3_NPCDialogFrameChat.eventInfo.finishText()) then
			if type(TRP3_NPCDialogFrameChat.eventInfo.finishText) == "function" then
				TRP3_NPCDialogFrameChatNextText:SetText(TRP3_NPCDialogFrameChat.eventInfo.finishText());
			else
				TRP3_NPCDialogFrameChatNextText:SetText(TRP3_NPCDialogFrameChat.eventInfo.finishText);
			end
		end
	end

	if TRP3_NPCDialogFrameChat.currentIndex <= #TRP3_NPCDialogFrameChat.texts then
		playText(TRP3_NPCDialogFrameChat.currentIndex, targetModel);
	else
		if TRP3_NPCDialogFrameChat.eventInfo.finishMethod then
			TRP3_NPCDialogFrameChat.eventInfo.finishMethod();
		else
			TRP3_NPCDialogFrame:Hide();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Storyline_API.initEventsStructure()
	local startDialog = Storyline_API.startDialog;

	EVENT_INFO = {
		["QUEST_GREETING"] = {
			text = GetGreetingText,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_DETAIL"] = {
			text = GetQuestText,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
			finishText = loc("SL_CHECK_OBJ"),
			finishMethod = function()
				if not TRP3_NPCDialogFrameObjectivesContent:IsVisible() then
					configureHoverFrame(TRP3_NPCDialogFrameObjectivesContent, TRP3_NPCDialogFrameObjectives, "TOP");
					setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "TOP", 0, 0, nil, nil);
					Storyline_MainTooltip:Hide();
					TRP3_NPCDialogFrameObjectivesYes:Show();
					TRP3_NPCDialogFrameObjectivesNo:Show();
					TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_ACCEPTANCE"));
				else
					AcceptQuest();
				end
			end,
		},
		["QUEST_PROGRESS"] = {
			text = GetProgressText,
			finishMethod = function()
				if not TRP3_NPCDialogFrameObjectivesContent:IsVisible() then
					configureHoverFrame(TRP3_NPCDialogFrameObjectivesContent, TRP3_NPCDialogFrameObjectives, "TOP");
					setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "TOP", 0, 0, nil, nil);
					Storyline_MainTooltip:Hide();
					if IsQuestCompletable() then
						TRP3_NPCDialogFrameObjectives.OK:Show();
						TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_CONTINUE"));
						playSelfAnim(68);
					else
						TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_NOT_YET"));
						playSelfAnim(186);
					end
				elseif IsQuestCompletable() then
					CompleteQuest();
				else
					CloseQuest();
				end
			end,
			finishText = function()
				return loc("SL_CHECK_OBJ");
			end,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_COMPLETE"] = {
			text = GetRewardText,
			finishMethod = function()
				if not TRP3_NPCDialogFrameRewards.Content:IsVisible() then
					configureHoverFrame(TRP3_NPCDialogFrameRewards.Content, TRP3_NPCDialogFrameRewardsItem, "TOP");
					setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "TOP", 0, 0);
					Storyline_MainTooltip:Hide();
					if GetNumQuestChoices() > 1 then
						TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_SELECT_REWARD"));
						TRP3_NPCDialogFrameChatNext:Disable();
					else
						TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_CONTINUE"));
					end
				elseif GetNumQuestChoices() == 1 then
					GetQuestReward(1);
					autoEquip(GetQuestItemLink("choice", 1));
					autoEquipAllReward();
				elseif GetNumQuestChoices() == 0 then
					GetQuestReward();
					autoEquipAllReward();
				end
			end,
			finishText = loc("SL_GET_REWARD"),
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["GOSSIP_SHOW"] = {
			text = GetGossipText,
			finishMethod = function()
				if GetNumGossipAvailableQuests() > 1 and not TRP3_NPCDialogFrameGossipChoices:IsVisible() then
					TRP3_NPCDialogFrameChatOption1:GetScript("OnClick")(TRP3_NPCDialogFrameChatOption1);
				elseif GetNumGossipActiveQuests() > 1 and not TRP3_NPCDialogFrameGossipChoices:IsVisible() then
					TRP3_NPCDialogFrameChatOption2:GetScript("OnClick")(TRP3_NPCDialogFrameChatOption2);
				elseif GetNumGossipOptions() > 1 and not TRP3_NPCDialogFrameGossipChoices:IsVisible() then
					TRP3_NPCDialogFrameChatOption3:GetScript("OnClick")(TRP3_NPCDialogFrameChatOption3);
				else
					CloseGossip();
				end
			end,
			finishText = GOODBYE,
			cancelMethod = CloseGossip,
		},
		["REPLAY"] = {
			titleGetter = function()
				local questTitle = GetQuestLogTitle(GetQuestLogSelection());
				return questTitle;
			end,
			nameGetter = function()
				return QUEST_LOG;
			end,
			finishText = CLOSE,
		}
	};

	for event, info in pairs(EVENT_INFO) do
		registerHandler(event, function()
			startDialog("npc", info.text(), event, info);
		end);
	end

	-- Replay buttons
	local questButton = CreateFrame("Button", nil, QuestLogPopupDetailFrame, "TRP3_CommonButton");
	questButton:SetText(loc("SL_STORYLINE"));
	questButton:SetPoint("TOP");
	questButton:SetScript("OnClick", function()
		local questDescription = GetQuestLogQuestText();
		startDialog("none", questDescription, "REPLAY", EVENT_INFO["REPLAY"]);
	end);

	-- UI
	setTooltipAll(TRP3_NPCDialogFrameChatPrevious, "BOTTOM", 0, 0, loc("SL_RESET"), loc("SL_RESET_TT"));
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectivesYes, "TOP", 0, 0,  loc("SL_ACCEPTANCE"));
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectivesNo, "TOP", 0, 0, loc("SL_DECLINE"));
	TRP3_NPCDialogFrameObjectivesYes:SetScript("OnClick", AcceptQuest);
	TRP3_NPCDialogFrameObjectivesYes:SetScript("OnEnter", function(self)
		playSelfAnim(185);
		refreshTooltipForFrame(self);
	end);
	TRP3_NPCDialogFrameObjectivesNo:SetScript("OnClick", DeclineQuest);
	TRP3_NPCDialogFrameObjectivesNo:SetScript("OnEnter", function(self)
		playSelfAnim(186);
		refreshTooltipForFrame(self);
	end);

	TRP3_NPCDialogFrameObjectives:SetScript("OnClick", function() EVENT_INFO["QUEST_PROGRESS"].finishMethod(); end);
	TRP3_NPCDialogFrameObjectivesContent.Title:SetText(QUEST_OBJECTIVES);
	TRP3_NPCDialogFrameObjectivesContent.RequiredItemText:SetText(TURN_IN_ITEMS);

	TRP3_NPCDialogFrameRewardsItem:SetScript("OnClick", function() EVENT_INFO["QUEST_COMPLETE"].finishMethod(); end);
	TRP3_NPCDialogFrameRewards.Content.RewardText1:SetText(REWARD_ITEMS_ONLY);
	TRP3_NPCDialogFrameRewards.Content.Title:SetText(REWARDS);
	TRP3_NPCDialogFrameRewards.Content.RewardText2:SetText(REWARD_ITEMS);
	TRP3_NPCDialogFrameRewards.Content.RewardText3:SetText(REWARD_CHOOSE);
end