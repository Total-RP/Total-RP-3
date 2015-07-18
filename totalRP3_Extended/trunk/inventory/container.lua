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
local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local _G, assert, tostring, tinsert, wipe, pairs = _G, assert, tostring, tinsert, wipe, pairs;
local CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown = CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local loc = TRP3_API.locale.getText;
local getBaseClassDataSafe, isContainerByClass = TRP3_API.inventory.getBaseClassDataSafe, TRP3_API.inventory.isContainerByClass;
local getItemClass, isContainerByClassID = TRP3_API.inventory.getItemClass, TRP3_API.inventory.isContainerByClassID;
local getQualityColorRGB, getQualityColorText = TRP3_API.inventory.getQualityColorRGB, TRP3_API.inventory.getQualityColorText;
local EMPTY = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Slot management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local containerInstances = {};
local switchContainerByRef, isContainerInstanceOpen, highlightContainerInstance;

local function getItemTooltipLines(slotInfo, itemClass)
	local title, text1, text2;
	local icon, name = getBaseClassDataSafe(itemClass);
	title = getQualityColorText(itemClass.BA.QA) .. name;

	text1 = "";
	if itemClass.QE then
		text1 = Utils.str.color("w") .. ITEM_BIND_QUEST;
	end
	if isContainerByClass(itemClass) then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("y") .. "Container"; -- TODO:
	end
	if itemClass.BA.SB then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("w") .. ITEM_SOULBOUND;
	end
	if itemClass.BA.UN and itemClass.BA.UN > 0 then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("w") .. ITEM_UNIQUE .. " (" .. itemClass.BA.UN .. ")";
	end

	if itemClass.BA.DE and itemClass.BA.DE:len() > 0 then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("o") .. "\"" .. itemClass.BA.DE .. "\"";
	end

	if itemClass.US and itemClass.US.AC then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("g") .. USE .. ": " .. itemClass.US.AC;
	end

	if itemClass.BA.CO then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. "|cff66BBFF" .. PROFESSIONS_USED_IN_COOKING;
	end

	if IsAltKeyDown() then
		if itemClass.BA.WE and itemClass.BA.WE > 0 then
			if text1:len() > 0 then text1 = text1 .. "\n"; end
			text1 = text1 .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15) .. Utils.str.color("w") .. " " .. itemClass.BA.WE .. "kg";
		end

		local first = true;
		text2 = "";
		if isContainerByClass(itemClass) then
			if first then first = false; text2 = text2 .. "\n"; end
			text2 = text2 .. Utils.str.color("y") .. loc("CM_DOUBLECLICK") .. ": " .. Utils.str.color("o") .. "Open container"; -- TODO:
		end
	end

	return title, text1, text2;
end

local TRP3_ItemTooltip = TRP3_ItemTooltip;
local function showItemTooltip(frame, slotInfo, itemClass)
	TRP3_ItemTooltip:Hide();
	TRP3_ItemTooltip:SetOwner(frame, "TOP_LEFT", 0, 0);

	local title, text1, text2 = getItemTooltipLines(slotInfo, itemClass);

	local i = 1;
	if title and title:len() > 0 then
		TRP3_ItemTooltip:AddLine(title, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormalLarge);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	if text1 and text1:len() > 0 then
		TRP3_ItemTooltip:AddLine(text1, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormal);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetSpacing(2);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	if text2 and text2:len() > 0 then
		TRP3_ItemTooltip:AddLine(text2, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormalSmall);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetSpacing(2);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	TRP3_ItemTooltip:Show();
end

local function containerSlotUpdate(self, elapsed)
	self.Quest:Hide();
	self.Icon:Hide();
	self.IconBorder:Hide();
	self.Quantity:Hide();
	self.Icon:SetVertexColor(1, 1, 1);
	if not self.info then

	else
		local class = self.class or EMPTY;
		local icon, name = getBaseClassDataSafe(class);
		self.Icon:Show();
		self.Icon:SetTexture("Interface\\ICONS\\" .. icon);
		if class.QE and class.QE.QH then
			self.Quest:Show();
		end
		if class.BA and class.BA.QA and class.BA.QA ~= 1 then
			self.IconBorder:Show();
			local r, g, b = getQualityColorRGB(class.BA.QA);
			self.IconBorder:SetVertexColor(r, g, b);
		end
		if self.info.count and self.info.count > 1 then
			self.Quantity:Show();
			self.Quantity:SetText(self.info.count);
		end
		if self.class and MouseIsOver(self) and TRP3_ItemTooltip.ref == self then
			showItemTooltip(self, self.info, self.class);
		end
		if isContainerByClass(self.class) and isContainerInstanceOpen(self.class, self.info.instanceId) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
		end
	end
end

local function slotOnEnter(self)
	if self.info and self.class then
		TRP3_ItemTooltip.ref = self;
		showItemTooltip(self, self.info, self.class);
		if isContainerByClass(self.class) and isContainerInstanceOpen(self.class, self.info.instanceId) then
			highlightContainerInstance(self.info.instanceId);
		end
	end
end

local function slotOnLeave(self)
	TRP3_ItemTooltip.ref = nil;
	TRP3_ItemTooltip:Hide();
	highlightContainerInstance(nil);
end

local function slotOnDragStart(self)
	if self.info and self.class then
		self.Icon:SetDesaturated(true);
		SetCursor("Interface\\ICONS\\" .. (self.class.BA.IC or "Temp")) ;
	end
end

local function slotOnDragStop(self)
	self.Icon:SetDesaturated(false);
	ResetCursor();
end

local function slotOnDragReceive(self)

end

local COLUMN_SPACING = 43;
local ROW_SPACING = 42;
local CONTAINER_SLOT_UPDATE_FREQUENCY = 0.15;
local function initContainerSlots(containerFrame, rowCount, colCount)
	local slotNum = 1;
	local rowY = -58;
	containerFrame.slots = {};
	for row = 1, rowCount do
		local colX = 22;
		for col = 1, colCount do
			local slot = CreateFrame("Button", containerFrame:GetName() .. "Slot" .. slotNum, containerFrame, "TRP3_ContainerSlotTemplate");
			tinsert(containerFrame.slots, slot);
			createRefreshOnFrame(slot, CONTAINER_SLOT_UPDATE_FREQUENCY, containerSlotUpdate);
			slot:SetPoint("TOPLEFT", colX, rowY);
			slot:RegisterForDrag("LeftButton");
			slot:SetScript("OnDragStart", slotOnDragStart);
			slot:SetScript("OnDragStop", slotOnDragStop);
			slot:SetScript("OnReceiveDrag", slotOnDragReceive);
			slot:SetScript("OnEnter", slotOnEnter);
			slot:SetScript("OnLeave", slotOnLeave);
			slot:SetScript("OnDoubleClick", function(self, button)
				if self.info and self.class and isContainerByClass(self.class) then
					switchContainerByRef(self.info, self:GetParent());
					slotOnEnter(self);
				end
			end);
			colX = colX + COLUMN_SPACING;
			slotNum = slotNum + 1;
		end
		rowY = rowY - ROW_SPACING;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Container
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function loadContainerPageSlots(containerFrame)
	if not containerFrame.info or not containerFrame.class then return end
	local containerContent = containerFrame.info.content or EMPTY;
	local slotCounter = 1;
	for index, slot in pairs(containerFrame.slots) do
		slot.slotID = tostring(slotCounter);
		if containerContent[slot.slotID] then
			slot.info = containerContent[slot.slotID];
			slot.class = getItemClass(containerContent[slot.slotID].id);
		else
			slot.info = nil;
			slot.class = nil;
		end
		containerSlotUpdate(slot);
		slotCounter = slotCounter + 1;
	end
end

local function containerFrameUpdate(self, elapsed)
	if not self.info or not self.class then return end
	-- Durability
	local durability = "";
	if self.class.CO.DU and self.class.CO.DU > 0 then
		local max = self.class.CO.DU;
		local current = self.info.durability or self.class.CO.DU;
		durability = (Utils.str.texture("Interface\\GROUPFRAME\\UI-GROUP-MAINTANKICON", 15) .. "%s/%s"):format(current, max);
	end
	self.DurabilityText:SetText(durability);

	-- Weight
	local current = self.info.totalWeight or 0;
	local weight = ("%s kg" .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15)):format(current);
	if self.class.CO.MW and self.class.CO.MW > 0 then
		-- TODO: color if too heavy
	end
	self.WeightText:SetText(weight);

	self.LockIcon:Hide();
	if self.lockedBy then
		self.LockIcon:Show();
	end
end

local function decorateContainer(containerFrame, class, container)
	local icon, name = getBaseClassDataSafe(class);
	Utils.texture.applyRoundTexture(containerFrame.Icon, "Interface\\ICONS\\" .. icon, "Interface\\ICONS\\TEMP");
	containerFrame.Title:SetText(name);
end

function highlightContainerInstance(instanceId, except)
	for _, ref in pairs(containerInstances) do
		ref.Glow:Hide();
		if ref.instanceId == instanceId and ref:IsVisible() then
			ref.Glow:Show();
		end
	end
end

local function lockOnContainer(self, originContainer)
	self:ClearAllPoints();
	self.lockedOn = originContainer;
	if originContainer and originContainer:IsVisible() then
		if originContainer.lockedBy then
			lockOnContainer(self, originContainer.lockedBy);
			return;
		end
		originContainer.lockedBy = self;
		self:SetPoint("TOPLEFT", originContainer, "TOPRIGHT", 0, 0);
		containerFrameUpdate(originContainer);
	elseif self.info.point and self.info.relativePoint then
		self:SetPoint(self.info.point, nil, self.info.relativePoint, self.info.xOfs, self.info.yOfs);
	else
		self:SetPoint("CENTER", 0, 0);
	end
end

local function unlockFromContainer(self)
	if self.lockedOn then
		self.lockedOn.lockedBy = nil;
		containerFrameUpdate(self.lockedOn);
	end
end

local function containerOnDragStop(self)
	self:StopMovingOrSizing();
	local anchor, _, _, x, y = self:GetPoint(1);
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1);
	self.info.point = point;
	self.info.relativePoint = relativePoint;
	self.info.xOfs = xOfs;
	self.info.yOfs = yOfs;
	for _, containerFrame in pairs(containerInstances) do
		containerFrame.isMoving = nil;
	end
	-- Check for anchor
	for _, containerFrame in pairs(containerInstances) do
		if containerFrame ~= self and MouseIsOver(containerFrame) then
			lockOnContainer(self, containerFrame);
			self.info.point = nil;
			self.info.relativePoint = nil;
			self.info.xOfs = nil;
			self.info.yOfs = nil;
		end
	end
	containerFrameUpdate(self);
end

local function containerOnDragStart(self)
	unlockFromContainer(self);
	self.lockedOn = nil;
	self:StartMoving();
	for _, containerFrame in pairs(containerInstances) do
		containerFrame.isMoving = self.info.instanceId;
	end
end

local function onContainerShow(self)
	self.IconButton.info = self.info;
	self.IconButton.class = self.class;
	lockOnContainer(self, self.originContainer);
	decorateContainer(self, self.class, self.info);
	loadContainerPageSlots(self);
end

local function onContainerHide(self)
	unlockFromContainer(self);
end

local CONTAINER_UPDATE_FREQUENCY = 0.5;
local function getContainerInstance(containerClass, instanceId)
	local count = 0;
	local containerFrame, available;
	for _, ref in pairs(containerInstances) do
		count = count + 1;
		if not ref:IsVisible() then
			available = ref;
		end
		if ref:IsVisible() and ref.instanceId == instanceId then
			containerFrame = ref;
			break;
		end
	end
	if containerFrame then -- If a container is already visible for this instance
		return containerFrame;
	end
	if available then -- If there is available frame in the pool
		containerFrame = available;
	else -- Else: we create a new one
		containerFrame = CreateFrame("Frame", "TRP3_Container5x4_" .. (count + 1), nil, "TRP3_Container5x4Template");
		createRefreshOnFrame(containerFrame, CONTAINER_UPDATE_FREQUENCY, containerFrameUpdate);
		initContainerSlots(containerFrame, 5, 4);
		containerFrame:SetScript("OnShow", onContainerShow);
		containerFrame:SetScript("OnHide", onContainerHide);
		containerFrame:RegisterForDrag("LeftButton");
		containerFrame:SetScript("OnDragStart", containerOnDragStart);
		containerFrame:SetScript("OnDragStop", containerOnDragStop);
		containerFrame.IconButton:RegisterForDrag("LeftButton");
		containerFrame.IconButton:SetScript("OnDragStart", function(self) containerOnDragStart(self:GetParent()) end);
		containerFrame.IconButton:SetScript("OnDragStop", function(self) containerOnDragStop(self:GetParent()) end);
		containerFrame.IconButton:SetScript("OnEnter", slotOnEnter);
		containerFrame.IconButton:SetScript("OnLeave", slotOnLeave);
		tinsert(containerInstances, containerFrame);
	end
	containerFrame.instanceId = instanceId;
	return containerFrame;
end

function isContainerInstanceOpen(containerClass, instanceId)
	for _, ref in pairs(containerInstances) do
		if ref.instanceId == instanceId and ref:IsVisible() then
			return true;
		end
	end
	return false;
end

function switchContainerByRef(container, originContainer)
	local instanceId = container.instanceId;
	local class = getItemClass(container.id);
	local containerFrame = getContainerInstance(class, instanceId);
	containerFrame.info = container;
	containerFrame.class = class;
	containerFrame.originContainer = originContainer;
	ToggleFrame(containerFrame);
end

function TRP3_API.inventory.switchContainerBySlotID(parentContainer, slotID)
	assert(parentContainer, "Nil parent container.");
	assert(parentContainer.content[slotID], "Empty slot.");
	assert(parentContainer.content[slotID].id, "Container without id for slot: " .. tostring(slotID));
	switchContainerByRef(parentContainer.content[slotID]);
end