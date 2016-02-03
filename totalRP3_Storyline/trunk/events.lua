----------------------------------------------------------------------------------
--  Storyline
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--	Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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
local format = format;
local playSelfAnim, getDuration, playAnimationDelay = Storyline_API.playSelfAnim, Storyline_API.getDuration, Storyline_API.playAnimationDelay;
local getQuestIcon, getQuestActiveIcon = Storyline_API.getQuestIcon, Storyline_API.getQuestActiveIcon;
local getQuestTriviality = Storyline_API.getQuestTriviality;
local selectMultipleAvailableGreetings = Storyline_API.selectMultipleAvailableGreetings;
local selectFirstGreetingAvailable = Storyline_API.selectFirstGreetingAvailable;
local selectMultipleActiveGreetings = Storyline_API.selectMultipleActiveGreetings;
local selectMultipleActive = Storyline_API.selectMultipleActive;
local selectFirstActive = Storyline_API.selectFirstActive;
local selectMultipleAvailable = Storyline_API.selectMultipleAvailable;
local selectFirstAvailable = Storyline_API.selectFirstAvailable;
local selectFirstGossip, selectMultipleGossip = Storyline_API.selectFirstGossip, Storyline_API.selectMultipleGossip;
local selectMultipleRewards, selectFirstGreetingActive = Storyline_API.selectMultipleRewards, Storyline_API.selectFirstGreetingActive;
local getAnimationByModel = Storyline_API.getAnimationByModel;
local getBindingIcon = Storyline_API.getBindingIcon;
local hideStorylineFrame = Storyline_API.layout.hideStorylineFrame;

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
local GetQuestItemLink, GetNumQuestRewards, GetRewardMoney, GetNumRewardCurrencies = GetQuestItemLink, GetNumQuestRewards, GetRewardMoney, GetNumRewardCurrencies;
local GetRewardSkillPoints = GetRewardSkillPoints;
local GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests = GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests;
local GetAvailableTitle, GetActiveTitle, CloseGossip = GetAvailableTitle, GetActiveTitle, CloseGossip;
local GetProgressText, GetTitleText, GetGreetingText = GetProgressText, GetTitleText, GetGreetingText;
local GetGossipText, GetRewardText, GetQuestText = GetGossipText, GetRewardText, GetQuestText;
local GetItemInfo, GetContainerNumSlots, GetContainerItemLink, EquipItemByName = GetItemInfo, GetContainerNumSlots, GetContainerItemLink, EquipItemByName;
local InCombatLockdown, GetInventorySlotInfo, GetInventoryItemLink = InCombatLockdown, GetInventorySlotInfo, GetInventoryItemLink;
local GetQuestCurrencyInfo, GetMaxRewardCurrencies, GetRewardTitle = GetQuestCurrencyInfo, GetMaxRewardCurrencies, GetRewardTitle;
local GarrisonFollowerPortrait_Set, GetFollowerInfo = GarrisonFollowerPortrait_Set, C_Garrison.GetFollowerInfo;
local GetQuestMoneyToGet, GetMoney, GetNumQuestCurrencies = GetQuestMoneyToGet, GetMoney, GetNumQuestCurrencies;
local GetSuggestedGroupNum = GetSuggestedGroupNum;
local UnitIsDead = UnitIsDead;
local QuestIsFromAreaTrigger, QuestGetAutoAccept = QuestIsFromAreaTrigger, QuestGetAutoAccept;
-- UI
local Storyline_NPCFrameChatOption1, Storyline_NPCFrameChatOption2, Storyline_NPCFrameChatOption3 = Storyline_NPCFrameChatOption1, Storyline_NPCFrameChatOption2, Storyline_NPCFrameChatOption3;
local Storyline_NPCFrameObjectives, Storyline_NPCFrameObjectivesNo, Storyline_NPCFrameObjectivesYes = Storyline_NPCFrameObjectives, Storyline_NPCFrameObjectivesNo, Storyline_NPCFrameObjectivesYes;
local Storyline_NPCFrameObjectivesImage = Storyline_NPCFrameObjectivesImage;
local Storyline_NPCFrameRewardsItemIcon, Storyline_NPCFrameRewardsItem, Storyline_NPCFrameRewards = Storyline_NPCFrameRewardsItemIcon, Storyline_NPCFrameRewardsItem, Storyline_NPCFrameRewards;
local Storyline_NPCFrame, Storyline_NPCFrameChatNextText = Storyline_NPCFrame, Storyline_NPCFrameChatNextText;
local Storyline_NPCFrameChat, Storyline_NPCFrameChatText = Storyline_NPCFrameChat, Storyline_NPCFrameChatText;
local Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious = Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious;
local Storyline_NPCFrameConfigButton, Storyline_NPCFrameObjectivesContent = Storyline_NPCFrameConfigButton, Storyline_NPCFrameObjectivesContent;
local Storyline_NPCFrameGossipChoices = Storyline_NPCFrameGossipChoices;

-- Constants
local OPTIONS_MARGIN, OPTIONS_TOP = 175, -175;
local CHAT_MARGIN = 70;
local GOSSIP_DELAY = 0.2;
local gossipColor = "|cffffffff";
local EVENT_INFO;
local eventHandlers = {};
local BONUS_SKILLPOINTS = BONUS_SKILLPOINTS;
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS;
local REQUIRED_MONEY = REQUIRED_MONEY;
local QUEST_SUGGESTED_GROUP_NUM, QUEST_OBJECTIVES = QUEST_SUGGESTED_GROUP_NUM, QUEST_OBJECTIVES;

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
	if Storyline_Data.config.autoEquip then
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

local function showQuestPortraitFrame()
	if not Storyline_Data.config.hideOriginalFrames then
		return;
	end
	local questPortrait, questPortraitText, questPortraitName = GetQuestPortraitGiver();
	if (questPortrait ~= 0) then
		QuestFrame_ShowQuestPortrait(Storyline_NPCFrame, questPortrait, questPortraitText, questPortraitName, -3, -42);
	else
		QuestFrame_HideQuestPortrait();
	end
end

local function acceptQuest()
	if QuestFlagsPVP() then
		QuestFrame.dialog = StaticPopup_Show("CONFIRM_ACCEPT_PVP_QUEST");
	else
		if QuestFrame.autoQuest then
			AcknowledgeAutoAcceptQuest();
		else
			AcceptQuest();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Grid system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local placeItemOnTheLeft = true;
local gridHeight, gridCount;
local previousElementOnTheLeft;

local function placeOnGrid(button, initialPlacement)
	previousElementOnTheLeft = previousElementOnTheLeft or initialPlacement;

	if placeItemOnTheLeft then
		button:SetPoint("TOPLEFT", previousElementOnTheLeft, "BOTTOMLEFT", gridCount == 0 and 0 or -157, -5);
	else
		button:SetPoint("TOPLEFT", previousElementOnTheLeft, "TOPRIGHT", 10, 0);
	end
	previousElementOnTheLeft = button;

	placeItemOnTheLeft = not placeItemOnTheLeft;
	gridHeight = gridHeight + (placeItemOnTheLeft and 0 or 50);
	gridCount = gridCount + 1;
end

local function resetGrid()
	previousElementOnTheLeft = nil;
	placeItemOnTheLeft = true;
	gridHeight = 0;
	gridCount = 0;
end

local itemButtons = {};
local function getQuestButton(parentFrame)
	local available;
	for _, button in pairs(itemButtons) do
		if not button:IsShown() then
			available = button;
			break;
		end
	end
	if not available then
		available = CreateFrame("Button", "Storyline_ItemButton" .. #itemButtons, nil, "LargeItemButtonTemplate");
		available:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end);
		tinsert(itemButtons, available);
	end
	available:SetParent(parentFrame);
	available:Show();
	return available;
end

local function decorateItemButton(button, index, type, texture, name, numItems, isUsable)
	numItems = numItems or 0;
	button.index = index;
	button.type = type;
	button.Icon:SetTexture(texture);
	button.Name:SetText(name);
	button.Count:SetText(numItems > 1 and numItems or "");
	if not isUsable then
		button.Icon:SetVertexColor(1, 0, 0);
	end
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetQuestItem(self.type, self.index);
		GameTooltip_ShowCompareItem(GameTooltip);
	end);
	button:SetScript("OnClick", function(self)
		local itemLink = GetQuestItemLink(self.type, self.index);
		if not HandleModifiedItemClick(itemLink) and self.type == "choice" then
			GetQuestReward(self.index);
			autoEquip(itemLink);
			autoEquipAllReward();
		end
		
		if IsModifiedClick("DRESSUP") and DressUpFrame:IsVisible() then
			DressUpFrame:ClearAllPoints();
			DressUpFrame:SetPoint("TOPLEFT", Storyline_NPCFrame, "TOPRIGHT", 10, 0);
		end
	end);
end

local function decorateCurrencyButton(button, index, type, texture, name, numItems)
	numItems = numItems or 0;
	button.index = index;
	button.type = type;
	button.Icon:SetTexture(texture);
	button.Name:SetText(name);
	button.Count:SetText(numItems > 1 and numItems or "");
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetQuestCurrency(self.type, self.index);
	end);
	button:SetScript("OnClick", nil);
end

local function decorateStandardButton(button, texture, name, tt, ttsub, isNotUsable)
	button.Icon:SetTexture(texture);
	button.Name:SetText(name);
	button.Count:SetText("");
	if isNotUsable then
		button.Icon:SetVertexColor(1, 0, 0);
	end
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:AddLine("|cffffffff" .. tt);
		if ttsub then
			GameTooltip:AddLine("|cffffffff" .. ttsub);
		end
		GameTooltip:Show();
	end);
	button:SetScript("OnClick", nil);
end

local function decorateSkillPointButton(button, texture, name, count, tt, ttsub)
	button.Icon:SetTexture(texture);
	button.Name:SetText(name);
	button.Count:SetText(count > 1 and count or "");
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:AddLine("|cffffffff" .. tt);
		GameTooltip:Show();
	end);
	-- TODO skill point nice circle
	-- Storyline_NPCFrameRewards.Content.SkillPointFrame.ValueText:SetText(skillPoints);
	button:SetScript("OnClick", nil);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT PART
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local displayBuilder = {};

eventHandlers["GOSSIP_SHOW"] = function()
	local hasGossip, hasAvailable, hasActive = GetNumGossipOptions() > 0, GetNumGossipAvailableQuests() > 0, GetNumGossipActiveQuests() > 0;
	local previous;
	local keyBinding = 1;

	-- Available quests
	if hasAvailable then
		Storyline_NPCFrameChatOption1:Show();
		Storyline_NPCFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
		Storyline_NPCFrameChatOption1:ClearAllPoints();
		Storyline_NPCFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

		previous = Storyline_NPCFrameChatOption1;
		if GetNumGossipAvailableQuests() == 1 then
			local title, lvl, isTrivial, frequency, isRepeatable, isLegendary = GetGossipAvailableQuests();
			local icon = getQuestIcon(frequency, isRepeatable, isLegendary, isTrivial);
			Storyline_NPCFrameChatOption1:SetText(getBindingIcon(keyBinding) .. gossipColor .. icon .. " " .. title);
			Storyline_NPCFrameChatOption1:SetScript("OnClick", selectFirstAvailable);
		else
			Storyline_NPCFrameChatOption1:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
			Storyline_NPCFrameChatOption1:SetScript("OnClick", selectMultipleAvailable);
		end
		keyBinding = keyBinding + 1;
	end

	-- Active options
	if hasActive then
		Storyline_NPCFrameChatOption2:Show();
		Storyline_NPCFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
		Storyline_NPCFrameChatOption2:ClearAllPoints();
		Storyline_NPCFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			Storyline_NPCFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			Storyline_NPCFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = Storyline_NPCFrameChatOption2;
		if GetNumGossipActiveQuests() == 1 then
			local title, lvl, isTrivial, isComplete, isRepeatable = GetGossipActiveQuests();
			Storyline_NPCFrameChatOption2:SetText(getBindingIcon(keyBinding) .. gossipColor .. getQuestActiveIcon(isComplete, isRepeatable) .. " " .. title);
			Storyline_NPCFrameChatOption2:SetScript("OnClick", selectFirstActive);
		else
			Storyline_NPCFrameChatOption2:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
			Storyline_NPCFrameChatOption2:SetScript("OnClick", selectMultipleActive);
		end
		keyBinding = keyBinding + 1;
	end

	-- Gossip options
	if hasGossip then
		Storyline_NPCFrameChatOption3:Show();
		Storyline_NPCFrameChatOption3:SetScript("OnEnter", function() playSelfAnim(60) end);
		Storyline_NPCFrameChatOption3:ClearAllPoints();
		Storyline_NPCFrameChatOption3:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption3:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			Storyline_NPCFrameChatOption3:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			Storyline_NPCFrameChatOption3:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = Storyline_NPCFrameChatOption3;

		local gossips = { GetGossipOptions() };
		if GetNumGossipOptions() == 1 then
			local gossip, gossipType = gossips[1], gossips[2];
			Storyline_NPCFrameChatOption3:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:20:20|t " .. gossip);
			Storyline_NPCFrameChatOption3:SetScript("OnClick", selectFirstGossip);
		else
			Storyline_NPCFrameChatOption3:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\PetitionGossipIcon:20:20|t " .. loc("SL_WELL"));
			Storyline_NPCFrameChatOption3:SetScript("OnClick", selectMultipleGossip);
		end
		keyBinding = keyBinding + 1;
	end

end

eventHandlers["QUEST_GREETING"] = function()
	local numActiveQuests = GetNumActiveQuests();
	local numAvailableQuests = GetNumAvailableQuests();
	local previous;
	local keyBinding = 1;

	if numActiveQuests > 0 then
		Storyline_NPCFrameChatOption1:Show();
		Storyline_NPCFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
		Storyline_NPCFrameChatOption1:ClearAllPoints();
		Storyline_NPCFrameChatOption1:ClearAllPoints();
		Storyline_NPCFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

		previous = Storyline_NPCFrameChatOption1;
		if numActiveQuests == 1 then
			local title, isComplete = GetActiveTitle(1);
			local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(1);
			Storyline_NPCFrameChatOption1:SetText(getBindingIcon(keyBinding) .. gossipColor .. getQuestActiveIcon(isComplete, isRepeatable) .. " " .. title);
			Storyline_NPCFrameChatOption1:SetScript("OnClick", selectFirstGreetingActive);
		else
			Storyline_NPCFrameChatOption1:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
			Storyline_NPCFrameChatOption1:SetScript("OnClick", selectMultipleActiveGreetings);
		end
		keyBinding = keyBinding + 1;
	end

	if numAvailableQuests > 0 then
		Storyline_NPCFrameChatOption2:Show();
		Storyline_NPCFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
		Storyline_NPCFrameChatOption2:ClearAllPoints();
		Storyline_NPCFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
		Storyline_NPCFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
		if previous then
			Storyline_NPCFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
		else
			Storyline_NPCFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
		end
		previous = Storyline_NPCFrameChatOption2;
		if numAvailableQuests == 1 then
			local title, isComplete = GetAvailableTitle(1);
			local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(1);
			local icon = getQuestIcon(frequency, isRepeatable, isLegendary);
			Storyline_NPCFrameChatOption2:SetText(getBindingIcon(keyBinding) .. gossipColor .. icon .. " " .. title);
			Storyline_NPCFrameChatOption2:SetScript("OnClick", selectFirstGreetingAvailable);
		else
			Storyline_NPCFrameChatOption2:SetText(getBindingIcon(keyBinding) .. gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
			Storyline_NPCFrameChatOption2:SetScript("OnClick", selectMultipleAvailableGreetings);
		end
		keyBinding = keyBinding + 1;
	end
end

eventHandlers["QUEST_DETAIL"] = function()

	-- Quest that pops up and are auto-accepted (like the one for learning to mount or for new expansions)
	if (QuestGetAutoAccept() and QuestIsFromAreaTrigger()) then
		hideStorylineFrame();
	end

	local contentHeight = Storyline_NPCFrameObjectivesContent.Title:GetHeight() + 15;

	Storyline_NPCFrameObjectives:Show();
	Storyline_NPCFrameObjectivesImage:SetDesaturated(false);
	setTooltipForSameFrame(Storyline_NPCFrameObjectives, "TOP", 0, 0, QUEST_OBJECTIVES, loc("SL_CHECK_OBJ"));

	local objectives = GetObjectiveText();
	if objectives:len() > 0 then
		Storyline_NPCFrameObjectivesContent.Objectives:SetText(objectives);
		Storyline_NPCFrameObjectivesContent.Objectives:Show();
		contentHeight = contentHeight + 10 + Storyline_NPCFrameObjectivesContent.Objectives:GetHeight();
	end

	local groupNum = GetSuggestedGroupNum();
	if groupNum > 0 then
		Storyline_NPCFrameObjectivesContent.GroupSuggestion:SetText(format(QUEST_SUGGESTED_GROUP_NUM, groupNum));
		Storyline_NPCFrameObjectivesContent.GroupSuggestion:Show();
		contentHeight = contentHeight + 10 + Storyline_NPCFrameObjectivesContent.GroupSuggestion:GetHeight();
	end

	Storyline_NPCFrameObjectivesContent:SetHeight(contentHeight);

	if GetNumQuestItems() > 0 then
		local _, icon = GetQuestItemInfo("required", 1);
		Storyline_NPCFrameObjectivesImage:SetTexture(icon);
	end
end

eventHandlers["QUEST_PROGRESS"] = function()
	Storyline_NPCFrameObjectives:Show();
	Storyline_NPCFrameObjectivesImage:SetDesaturated(not IsQuestCompletable());
	setTooltipForSameFrame(Storyline_NPCFrameObjectives, "TOP", 0, 0, QUEST_OBJECTIVES, loc("SL_CHECK_OBJ"));

	local contentHeight = Storyline_NPCFrameObjectivesContent.Title:GetHeight() + 15;

	local questObjectives = getQuestData(GetTitleText());
	if IsQuestCompletable() and questObjectives:len() > 0 then
		questObjectives = getTextureString("Interface\\RAIDFRAME\\ReadyCheck-Ready", 15) .. " |cff00ff00" .. questObjectives;
	elseif questObjectives:len() > 0 then
		questObjectives = getTextureString("Interface\\RAIDFRAME\\ReadyCheck-NotReady", 15) .. " |cffff0000" .. questObjectives;
	end

	if questObjectives:len() > 0 then
		Storyline_NPCFrameObjectivesContent.Objectives:SetText(questObjectives);
		Storyline_NPCFrameObjectivesContent.Objectives:Show();
		contentHeight = contentHeight + 10 + Storyline_NPCFrameObjectivesContent.Objectives:GetHeight()
	end

	if GetNumQuestItems() > 0 or GetNumQuestCurrencies() > 0 or GetQuestMoneyToGet() > 0 then
		Storyline_NPCFrameObjectivesContent.RequiredItemText:Show();
		local bestIcon = "Interface\\ICONS\\trade_archaeology_chestoftinyglassanimals";

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Prepare display structure
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		wipe(displayBuilder);

		local money = GetQuestMoneyToGet();
		if money > 0 then
			bestIcon = "Interface\\ICONS\\inv_misc_coin_03";
			if money < 100 then
				bestIcon = "Interface\\ICONS\\inv_misc_coin_05";
			elseif money > 9999 then
				bestIcon = "Interface\\ICONS\\inv_misc_coin_01";
			end
			local moneyString = GetCoinTextureString(money);
			tinsert(displayBuilder, {
				text = moneyString,
				icon = bestIcon,
				tooltipTitle = REQUIRED_MONEY .. " " ..moneyString,
				isNotUsable = money > GetMoney()
			});
		end

		for i = 1, GetNumQuestItems() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("required", i);
			bestIcon = texture;
			tinsert(displayBuilder, {
				text = name,
				icon = texture,
				count = numItems,
				index = i,
				type = "item",
				rewardType = "required",
				isUsable = isUsable,
			});
		end

		for i = 1, GetNumQuestCurrencies() do
			local name, texture, numItems = GetQuestCurrencyInfo("required", i);
			bestIcon = texture;
			tinsert(displayBuilder, {
				text = name,
				icon = texture,
				count = numItems,
				index = i,
				type = "currency",
				rewardType = "required",
			});
		end

		Storyline_NPCFrameObjectivesImage:SetTexture(bestIcon);

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Displays structure content
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		resetGrid();
		for index, buttonInfo in pairs(displayBuilder) do
			local button = getQuestButton(Storyline_NPCFrameObjectivesContent);
			placeOnGrid(button, Storyline_NPCFrameObjectivesContent.RequiredItemText);
			if buttonInfo.type == "currency" then
				decorateCurrencyButton(button, buttonInfo.index, buttonInfo.rewardType, buttonInfo.icon, buttonInfo.text, buttonInfo.count);
			elseif buttonInfo.type == "item" then
				decorateItemButton(button, buttonInfo.index, buttonInfo.rewardType, buttonInfo.icon, buttonInfo.text, buttonInfo.count, buttonInfo.isUsable);
			else
				decorateStandardButton(button, buttonInfo.icon, buttonInfo.text, buttonInfo.tooltipTitle, buttonInfo.tooltipSub, buttonInfo.isNotUsable);
			end
		end
		contentHeight = contentHeight + gridHeight;
		contentHeight = contentHeight + Storyline_NPCFrameObjectivesContent.RequiredItemText:GetHeight() + 10;
	end

	Storyline_NPCFrameObjectivesContent:SetHeight(contentHeight);
end

eventHandlers["QUEST_COMPLETE"] = function(eventInfo)
	Storyline_NPCFrameRewards:Show();
	setTooltipForSameFrame(Storyline_NPCFrameRewardsItem, "TOP", 0, 0, REWARDS, loc("SL_GET_REWARD"));

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Rewards structure
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Clean our variable used for remember the first reward choice available
	Storyline_NPCFrameRewards.Content.firstChoice = nil;
	wipe(displayBuilder);
	local bestIcon = "Interface\\ICONS\\trade_archaeology_chestoftinyglassanimals";

	-- XP
	local xp = GetRewardXP();
	if xp > 0 then
		bestIcon = "Interface\\ICONS\\xp_icon";
		tinsert(displayBuilder, {
			text = xp .. " " .. XP,
			icon = bestIcon,
			tooltipTitle = ERR_QUEST_REWARD_EXP_I:format(xp)
		});
	end

	-- Money
	local money = GetRewardMoney();
	if money > 0 then
		bestIcon = "Interface\\ICONS\\inv_misc_coin_03";
		if money < 100 then
			bestIcon = "Interface\\ICONS\\inv_misc_coin_05";
		elseif money > 9999 then
			bestIcon = "Interface\\ICONS\\inv_misc_coin_01";
		end
		local moneyString = GetCoinTextureString(money);
		tinsert(displayBuilder, {
			text = moneyString,
			icon = bestIcon,
			tooltipTitle = ERR_QUEST_REWARD_MONEY_S:format(moneyString),
		});
	end

	-- Title
	local playerTitle = GetRewardTitle();
	if playerTitle then
		tinsert(displayBuilder, {
			text = playerTitle,
			icon = "Interface\\ICONS\\inv_scroll_11",
			tooltipTitle = playerTitle,
			tooltipSub = playerTitle
		});
	end

	-- Skill points
	local skillName, skillIcon, skillPoints = GetRewardSkillPoints();
	if skillPoints then
		skillName = skillName or "?";
		tinsert(displayBuilder, {
			text = BONUS_SKILLPOINTS:format(skillName),
			icon = skillIcon,
			count = skillPoints,
			type = "skillpoint",
			tooltipTitle = format(BONUS_SKILLPOINTS_TOOLTIP, skillPoints, skillName),
		});
	end

	-- Currencies
	local currencyCount = GetNumRewardCurrencies();
	if currencyCount > 0 then
		for i = 1, currencyCount, 1 do -- Some quest reward several currencies
			local name, texture, numItems = GetQuestCurrencyInfo("reward", i);
			if name and texture and numItems then
				tinsert(displayBuilder, {
					text = name,
					icon = texture,
					count = numItems,
					index = i,
					type = "currency"
				});
			end
		end
	end

	-- Item reward
	if GetNumQuestChoices() == 1 or GetNumQuestRewards() > 0 then
		if GetNumQuestChoices() == 1 then
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("choice", 1);
			bestIcon = texture;
			tinsert(displayBuilder, {
				text = name,
				icon = texture,
				count = numItems,
				index = 1,
				type = "item",
				rewardType = "choice",
				isUsable = isUsable,
			});
		end

		for i = 1, GetNumQuestRewards() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("reward", i);
			bestIcon = texture;
			tinsert(displayBuilder, {
				text = name,
				icon = texture,
				count = numItems,
				index = i,
				type = "item",
				rewardType = "reward",
				isUsable = isUsable,
			});
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Displays rewards
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local contentHeight = 20;
	local previousForChoice = Storyline_NPCFrameRewards.Content.RewardText1;

	resetGrid();
	for index, buttonInfo in pairs(displayBuilder) do
		local button = getQuestButton(Storyline_NPCFrameRewards.Content);
		placeOnGrid(button, Storyline_NPCFrameRewards.Content.RewardText1);
		if buttonInfo.type == "currency" then
			decorateCurrencyButton(button, buttonInfo.index, "reward", buttonInfo.icon, buttonInfo.text, buttonInfo.count);
		elseif buttonInfo.type == "item" then
			decorateItemButton(button, buttonInfo.index, buttonInfo.rewardType, buttonInfo.icon, buttonInfo.text, buttonInfo.count, buttonInfo.isUsable);
		elseif buttonInfo.type == "skillpoint" then
			decorateSkillPointButton(button, buttonInfo.icon, buttonInfo.text, buttonInfo.count, buttonInfo.tooltipTitle);
		else
			decorateStandardButton(button, buttonInfo.icon, buttonInfo.text, buttonInfo.tooltipTitle, buttonInfo.tooltipSub);
		end
		previousForChoice = button;
	end
	if #displayBuilder == 0 then
		Storyline_NPCFrameRewards.Content.RewardText1:Hide();
	else
		Storyline_NPCFrameRewards.Content.RewardText1:Show();
	end
	contentHeight = contentHeight + gridHeight;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Reward choice
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	if GetNumQuestChoices() > 1 then

		if faction and faction:len() > 0 then
			bestIcon = "Interface\\ICONS\\battleground_strongbox_gold_" .. faction;
		else
			bestIcon = "Interface\\ICONS\\achievement_boss_spoils_of_pandaria";
		end
		contentHeight = contentHeight + 18;
		Storyline_NPCFrameRewards.Content.RewardText3:Show();
		Storyline_NPCFrameRewards.Content.RewardText3:SetPoint("TOP", previousForChoice, "BOTTOM", 0, -5);
		previousForChoice = Storyline_NPCFrameRewards.Content.RewardText3;

		wipe(displayBuilder);
		for i = 1, GetNumQuestChoices() do
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo("choice", i);
			bestIcon = texture;
			tinsert(displayBuilder, {
				text = name,
				icon = texture,
				count = numItems,
				index = i,
				rewardType = "choice",
				isUsable = isUsable,
			});
		end

		resetGrid();
		for index, buttonInfo in pairs(displayBuilder) do
			local button = getQuestButton(Storyline_NPCFrameRewards.Content);
			placeOnGrid(button, Storyline_NPCFrameRewards.Content.RewardText3);
			decorateItemButton(button, buttonInfo.index, buttonInfo.rewardType, buttonInfo.icon, buttonInfo.text, buttonInfo.count, buttonInfo.isUsable);
			if index == 1 then
				-- We remember the first choice reward so we can use it later (in our ConsolePort support)
				Storyline_NPCFrameRewards.Content.firstChoice = button;
			end
			previousForChoice = button;
		end

		contentHeight = contentHeight + gridHeight;
	end

	local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID = GetRewardSpell();
	local spellReward = texture and (not isBoostSpell or IsCharacterNewlyBoosted()) and (not garrFollowerID or not C_Garrison.IsFollowerCollected(garrFollowerID));

	if spellReward then

		if isTradeskillSpell then
			Storyline_NPCFrameRewards.Content.RewardTextSpell:SetText(REWARD_TRADESKILL_SPELL);
		elseif isBoostSpell then
			Storyline_NPCFrameRewards.Content.RewardTextSpell:SetText(REWARD_ABILITY);
		elseif garrFollowerID then
			Storyline_NPCFrameRewards.Content.RewardTextSpell:SetText(REWARD_FOLLOWER);
		elseif not isSpellLearned then
			Storyline_NPCFrameRewards.Content.RewardTextSpell:SetText(REWARD_AURA);
		else
			Storyline_NPCFrameRewards.Content.RewardTextSpell:SetText(REWARD_SPELL);
		end

		Storyline_NPCFrameRewards.Content.RewardTextSpell:Show();
		Storyline_NPCFrameRewards.Content.RewardTextSpell:SetPoint("TOP", previousForChoice, "BOTTOM", 0, -5);
		contentHeight = contentHeight + 18;
		previousForChoice = Storyline_NPCFrameRewards.Content.RewardTextSpell;

		if garrFollowerID then
			local questItem = Storyline_NPCFrameRewards.Content.FollowerFrame;
			questItem:SetPoint("TOP", previousForChoice, "BOTTOM", 0, -5);
			questItem:Show();
			questItem.ID = garrFollowerID;
			local followerInfo = GetFollowerInfo(garrFollowerID);
			questItem.Name:SetText(followerInfo.name);
			questItem.PortraitFrame.Level:SetText(followerInfo.level);
			questItem.Class:SetAtlas(followerInfo.classAtlas);
			local color = ITEM_QUALITY_COLORS[followerInfo.quality];
			questItem.PortraitFrame.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b);
			questItem.PortraitFrame.LevelBorder:SetVertexColor(color.r, color.g, color.b);
			GarrisonFollowerPortrait_Set(questItem.PortraitFrame.Portrait, followerInfo.portraitIconID);
			contentHeight = contentHeight + 70;
			previousForChoice = questItem;
		else
			local questItem = Storyline_NPCFrameRewards.Content.SpellFrame;
			questItem:Show();
			questItem.Icon:SetTexture(texture);
			questItem.Name:SetText(name);
			contentHeight = contentHeight + 40;
			previousForChoice = questItem;
		end
	end

	showQuestPortraitFrame();

	Storyline_NPCFrameRewardsItemIcon:SetTexture(bestIcon);
	contentHeight = contentHeight + Storyline_NPCFrameRewards.Content.Title:GetHeight() + 15;
	Storyline_NPCFrameRewards.Content:SetHeight(contentHeight);
end

local function handleEventSpecifics(event, texts, textIndex, eventInfo)
	-- Options
	for _, button in pairs(itemButtons) do
		button:Hide();
		button.Icon:SetVertexColor(1, 1, 1);
	end
	Storyline_NPCFrameGossipChoices:Hide();
	Storyline_NPCFrameRewards:Hide();
	Storyline_NPCFrameObjectives:Hide();
	Storyline_NPCFrameChatOption1:Hide();
	Storyline_NPCFrameChatOption2:Hide();
	Storyline_NPCFrameChatOption3:Hide();
	Storyline_NPCFrameObjectivesYes:Hide();
	Storyline_NPCFrameObjectivesNo:Hide();
	Storyline_NPCFrameObjectives.OK:Hide();
	Storyline_NPCFrameObjectivesContent.RequiredItemText:Hide();
	Storyline_NPCFrameObjectivesContent.GroupSuggestion:Hide();
	Storyline_NPCFrameObjectivesContent.Objectives:SetText('');
	Storyline_NPCFrameObjectivesContent.Objectives:Hide();
	Storyline_NPCFrameRewards.Content:Hide();
	Storyline_NPCFrameRewards.Content.RewardText2:Hide();
	Storyline_NPCFrameRewards.Content.RewardText3:Hide();
	Storyline_NPCFrameRewards.Content.RewardTextSpell:Hide();
	Storyline_NPCFrameRewards.Content.FollowerFrame:Hide();
	Storyline_NPCFrameRewards.Content.SpellFrame:Hide();
	setTooltipForSameFrame(Storyline_NPCFrameChatOption1);
	setTooltipForSameFrame(Storyline_NPCFrameChatOption2);
	setTooltipForSameFrame(Storyline_NPCFrameChatOption3);
	setTooltipForSameFrame(Storyline_NPCFrameObjectives);
	Storyline_NPCFrameChatOption1:SetScript("OnEnter", nil);
	Storyline_NPCFrameChatOption2:SetScript("OnEnter", nil);
	Storyline_NPCFrameChatOption3:SetScript("OnEnter", nil);
	Storyline_NPCFrameObjectivesImage:SetTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon");
	QuestFrame_HideQuestPortrait();

	if textIndex == #texts and eventHandlers[event] then
		eventHandlers[event](eventInfo);
	end
end

local function playText(textIndex, targetModel)
	local animTab = targetModel.animTab;
	wipe(animTab);

	local text = Storyline_NPCFrameChat.texts[textIndex];
	local sound;
	local delay = 0;
	local textLineToken = getId();

	Storyline_NPCFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_SAY"].r, ChatTypeInfo["MONSTER_SAY"].g, ChatTypeInfo["MONSTER_SAY"].b);

	if text:byte() == 60 or not UnitExists("npc") or UnitIsUnit("player", "npc") or UnitIsDead("npc") then -- Emote if begins with <
		local color = colorCodeFloat(ChatTypeInfo["MONSTER_EMOTE"].r, ChatTypeInfo["MONSTER_EMOTE"].g, ChatTypeInfo["MONSTER_EMOTE"].b);
		local finalText = text:gsub("<", color .. "<");
		finalText = finalText:gsub(">", ">|r");
		if not UnitExists("npc") or UnitIsUnit("player", "npc") or UnitIsDead("npc") then
			Storyline_NPCFrameChatText:SetText(color .. finalText);
		else
			Storyline_NPCFrameChatText:SetText(finalText);
		end
	else
		Storyline_NPCFrameChatText:SetText(text);
		text:gsub("[%.%?%!]+", function(finder)
			animTab[#animTab + 1] = getAnimationByModel(targetModel.model, finder:sub(1, 1));
			animTab[#animTab + 1] = 0;
		end);
	end

	if #animTab == 0 then
		animTab[1] = 0;
	end

	if UnitIsDead("npc") then
		wipe(animTab)
		animTab[1] = 6;
	end

	for _, sequence in pairs(animTab) do
		delay = playAnimationDelay(targetModel, sequence, getDuration(targetModel.model, sequence), delay, textLineToken);
	end

	Storyline_NPCFrameChat.start = 0;

	if #Storyline_NPCFrameChat.texts > 1 then
		Storyline_NPCFrameChatPrevious:Show();
	end

	handleEventSpecifics(Storyline_NPCFrameChat.event, Storyline_NPCFrameChat.texts, textIndex, Storyline_NPCFrameChat.eventInfo);

	Storyline_NPCFrameChat:SetHeight(Storyline_NPCFrameChatText:GetHeight() + CHAT_MARGIN + 5);
end

function Storyline_API.playNext(targetModel)
	Storyline_NPCFrameChatNext:Enable();
	Storyline_NPCFrameChat.currentIndex = Storyline_NPCFrameChat.currentIndex + 1;

	Storyline_NPCFrameChatNextText:SetText(loc("SL_NEXT"));
	if Storyline_NPCFrameChat.currentIndex >= #Storyline_NPCFrameChat.texts then
		if Storyline_NPCFrameChat.eventInfo.finishText and (type(Storyline_NPCFrameChat.eventInfo.finishText) ~= "function" or Storyline_NPCFrameChat.eventInfo.finishText()) then
			if type(Storyline_NPCFrameChat.eventInfo.finishText) == "function" then
				Storyline_NPCFrameChatNextText:SetText(Storyline_NPCFrameChat.eventInfo.finishText());
			else
				Storyline_NPCFrameChatNextText:SetText(Storyline_NPCFrameChat.eventInfo.finishText);
			end
		end
	end

	if Storyline_NPCFrameChat.currentIndex <= #Storyline_NPCFrameChat.texts then
		playText(Storyline_NPCFrameChat.currentIndex, targetModel);
	else
		if Storyline_NPCFrameChat.eventInfo.finishMethod then
			Storyline_NPCFrameChat.eventInfo.finishMethod();
		else
			hideStorylineFrame();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Storyline_API.initEventsStructure()
	local startDialog = Storyline_API.startDialog;

	EVENT_INFO = {
		["SCALING_DEBUG"] = {
			text = function() return "DEBUG TEXT" end,
			cancelMethod = function() end,
			titleGetter = function() return "DEBUG TITLE" end,
		},
		["QUEST_GREETING"] = {
			text = GetGreetingText,
			finishMethod = CloseQuest,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_DETAIL"] = {
			text = GetQuestText,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
			finishText = loc("SL_CHECK_OBJ"),
			finishMethod = function()
				if not Storyline_NPCFrameObjectivesContent:IsVisible() then
					configureHoverFrame(Storyline_NPCFrameObjectivesContent, Storyline_NPCFrameObjectives, "TOP");
					setTooltipForSameFrame(Storyline_NPCFrameObjectives, "TOP", 0, 0, nil, nil);
					Storyline_MainTooltip:Hide();
					Storyline_NPCFrameObjectivesYes:Show();
					Storyline_NPCFrameObjectivesNo:Show();
					Storyline_NPCFrameChatNextText:SetText(loc("SL_ACCEPTANCE"));
					showQuestPortraitFrame();
				else
					acceptQuest();
				end
			end,
		},
		["QUEST_PROGRESS"] = {
			text = GetProgressText,
			finishMethod = function()
				if not Storyline_NPCFrameObjectivesContent:IsVisible() then
					configureHoverFrame(Storyline_NPCFrameObjectivesContent, Storyline_NPCFrameObjectives, "TOP");
					setTooltipForSameFrame(Storyline_NPCFrameObjectives, "TOP", 0, 0, nil, nil);
					Storyline_MainTooltip:Hide();
					if IsQuestCompletable() then
						Storyline_NPCFrameObjectives.OK:Show();
						Storyline_NPCFrameChatNextText:SetText(loc("SL_CONTINUE"));
						playSelfAnim(68);
					else
						Storyline_NPCFrameChatNextText:SetText(loc("SL_NOT_YET"));
						playSelfAnim(186);
					end
					showQuestPortraitFrame();
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
				if not Storyline_NPCFrameRewards.Content:IsVisible() then
					configureHoverFrame(Storyline_NPCFrameRewards.Content, Storyline_NPCFrameRewardsItem, "TOP");
					setTooltipForSameFrame(Storyline_NPCFrameRewardsItem, "TOP", 0, 0);
					Storyline_MainTooltip:Hide();
					-- Call upon our ConsolePort support to move its custom cursor to the first reward available if it exists
					Storyline_API.consolePort.moveCursorToFirstAvailableReward()
					if GetNumQuestChoices() > 1 then
						Storyline_NPCFrameChatNextText:SetText(loc("SL_SELECT_REWARD"));
						Storyline_NPCFrameChatNext:Disable();
					else
						Storyline_NPCFrameChatNextText:SetText(loc("SL_CONTINUE"));
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
				if GetNumGossipAvailableQuests() > 1 and not Storyline_NPCFrameGossipChoices:IsVisible() then
					Storyline_NPCFrameChatOption1:GetScript("OnClick")(Storyline_NPCFrameChatOption1);
				elseif GetNumGossipActiveQuests() > 1 and not Storyline_NPCFrameGossipChoices:IsVisible() then
					Storyline_NPCFrameChatOption2:GetScript("OnClick")(Storyline_NPCFrameChatOption2);
				elseif GetNumGossipOptions() > 1 and not Storyline_NPCFrameGossipChoices:IsVisible() then
					Storyline_NPCFrameChatOption3:GetScript("OnClick")(Storyline_NPCFrameChatOption3);
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
	Storyline_API.EVENT_INFO = EVENT_INFO;

	for event, info in pairs(EVENT_INFO) do
		registerHandler(event, function()
			if not Storyline_Data.config.forceGossip and event == "GOSSIP_SHOW" then
				after(GOSSIP_DELAY, function()
					if GossipFrame:IsVisible() then
						startDialog("npc", info.text(), event, info);
					end
				end);
			else
				startDialog("npc", info.text(), event, info);
			end
		end);
	end

	-- Replay buttons
	local questButton = CreateFrame("Button", nil, QuestLogPopupDetailFrame, "Storyline_CommonButton");
	questButton:SetText(loc("SL_STORYLINE"));
	questButton:SetPoint("TOP");
	questButton:SetScript("OnClick", function()
		local questDescription = GetQuestLogQuestText();
		startDialog("none", questDescription, "REPLAY", EVENT_INFO["REPLAY"]);
	end);

	-- UI
	setTooltipAll(Storyline_NPCFrameChatPrevious, "BOTTOM", 0, 0, loc("SL_RESET"), loc("SL_RESET_TT"));
	setTooltipForSameFrame(Storyline_NPCFrameObjectivesYes, "TOP", 0, 0,  loc("SL_ACCEPTANCE"));
	setTooltipForSameFrame(Storyline_NPCFrameObjectivesNo, "TOP", 0, 0, loc("SL_DECLINE"));
	Storyline_NPCFrameObjectivesYes:SetScript("OnClick", acceptQuest);
	Storyline_NPCFrameObjectivesYes:SetScript("OnEnter", function(self)
		playSelfAnim(185);
		refreshTooltipForFrame(self);
	end);
	Storyline_NPCFrameObjectivesNo:SetScript("OnClick", DeclineQuest);
	Storyline_NPCFrameObjectivesNo:SetScript("OnEnter", function(self)
		playSelfAnim(186);
		refreshTooltipForFrame(self);
	end);

	Storyline_NPCFrameObjectives:SetScript("OnClick", function() EVENT_INFO["QUEST_PROGRESS"].finishMethod(); end);
	Storyline_NPCFrameObjectivesContent.Title:SetText(QUEST_OBJECTIVES);
	Storyline_NPCFrameObjectivesContent.RequiredItemText:SetText(TURN_IN_ITEMS);

	Storyline_NPCFrameRewardsItem:SetScript("OnClick", function() EVENT_INFO["QUEST_COMPLETE"].finishMethod(); end);
	Storyline_NPCFrameRewards.Content.RewardText1:SetText(REWARD_ITEMS_ONLY);
	Storyline_NPCFrameRewards.Content.Title:SetText(REWARDS);
	Storyline_NPCFrameRewards.Content.RewardText2:SetText(REWARD_ITEMS);
	Storyline_NPCFrameRewards.Content.RewardText3:SetText(REWARD_CHOOSE);
end
