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
local getBaseClassDataSafe, isContainerByClass, isUsableByClass = TRP3_API.inventory.getBaseClassDataSafe, TRP3_API.inventory.isContainerByClass, TRP3_API.inventory.isUsableByClass;
local getItemClass, isContainerByClassID = TRP3_API.inventory.getItemClass, TRP3_API.inventory.isContainerByClassID;
local getQualityColorRGB, getQualityColorText = TRP3_API.inventory.getQualityColorRGB, TRP3_API.inventory.getQualityColorText;
local EMPTY = TRP3_API.globals.empty;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Slot management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local containerInstances = {};
local loadContainerPageSlots;
local switchContainerByRef, isContainerInstanceOpen, highlightContainerInstance;

local function incrementLine(line)
	if line:len() > 0 then
		line = line .. "\n";
	end
	return line;
end

local function incrementLineIfFirst(first, line)
	if first then
		first = false;
		line = line .. "\n";
	end
	return first, line;
end

local function getItemTooltipLines(slotInfo, class)
	local title, text1, text2;
	local icon, name = getBaseClassDataSafe(class);
	title = getQualityColorText(class.BA.QA) .. name;

	text1 = "";
	if class.QE then
		text1 = Utils.str.color("w") .. ITEM_BIND_QUEST;
	end
	if class.BA.SB then
		text1 = incrementLine(text1);
		text1 = text1 .. Utils.str.color("w") .. ITEM_SOULBOUND;
	end
	if isContainerByClass(class) then
		text1 = incrementLine(text1);
		text1 = text1 .. Utils.str.color("w") .. CONTAINER_SLOTS:format((class.CO.SR or 5) * (class.CO.SC or 4), BAGSLOT);
	end
	if class.UN and class.UN > 0 then
		text1 = incrementLine(text1);
		text1 = text1 .. Utils.str.color("w") .. ITEM_UNIQUE .. " (" .. class.UN .. ")";
	end

	if class.BA.DE and class.BA.DE:len() > 0 then
		text1 = incrementLine(text1);
		text1 = text1 .. Utils.str.color("o") .. "\"" .. class.BA.DE .. "\"";
	end

	if class.US and class.US.AC then
		text1 = incrementLine(text1);
		text1 = text1 .. Utils.str.color("g") .. USE .. ": " .. class.US.AC;
	end

	if class.BA.CO then
		text1 = incrementLine(text1);
		text1 = text1 .. "|cff66BBFF" .. PROFESSIONS_USED_IN_COOKING;
	end

	if slotInfo.madeBy then
		text1 = incrementLine(text1);
		text1 = text1 .. ITEM_CREATED_BY:format(TRP3_API.register.getUnitRPNameWithID(slotInfo.madeBy));
	end

	if IsAltKeyDown() then
		if class.BA.WE and class.BA.WE > 0 then
			text1 = incrementLine(text1);
			text1 = text1 .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15) .. Utils.str.color("w") .. " " .. ((slotInfo.count or 1) * class.BA.WE) .. "kg";
		end

		text2 = "";

		if class.US then
			text2 = text2 .. "\n";
			text2 = text2 .. Utils.str.color("y") .. loc("CM_R_CLICK") .. ": " .. Utils.str.color("o") .. USE;
		end

		if isContainerByClass(class) then
			text2 = text2 .. "\n";
			text2 = text2 .. Utils.str.color("y") .. loc("CM_DOUBLECLICK") .. ": " .. Utils.str.color("o") .. loc("IT_CON_OPEN");
		end

		if class.missing then
			text2 = text2 .. "\n";
			text2 = text2 .. Utils.str.color("y") .. "Missing item class ID" .. ": " .. Utils.str.color("o") .. slotInfo.id; -- TODO: locals
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
	if self.info then
		local class = self.class;
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
		if MouseIsOver(self) then
			showItemTooltip(self, self.info, self.class);
		end
		if isContainerByClass(self.class) and isContainerInstanceOpen(self.info) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
		end
	else
		if TRP3_ItemTooltip.ref == self and MouseIsOver(self) then
			TRP3_ItemTooltip:Hide();
		end
	end
end

local function slotOnEnter(self)
	if self.info then
		TRP3_ItemTooltip.ref = self;
		showItemTooltip(self, self.info, self.class);
		if isContainerByClass(self.class) and isContainerInstanceOpen(self.info) then
			highlightContainerInstance(self.info);
		end
	end
end

local function slotOnLeave(self)
	TRP3_ItemTooltip.ref = nil;
	TRP3_ItemTooltip:Hide();
	highlightContainerInstance(nil);
end

local function slotOnDragStart(self)
	if self.info then
		StackSplitFrame:Hide();
		self.Icon:SetDesaturated(true);
		SetCursor("Interface\\ICONS\\" .. ((self.class and self.class.BA.IC) or "inv_misc_questionmark")) ;
	end
end

local function slotOnDragStop(slotFrom)
	slotFrom.Icon:SetDesaturated(false);
	ResetCursor();
	if slotFrom.info then
		local slotTo = GetMouseFocus();
		local container1, slot1;
		slot1 = slotFrom.slotID;
		container1 = slotFrom:GetParent().info;
		if slotTo:GetName() == "WorldFrame" then
			local itemClass = getItemClass(slotFrom.info.id);
			TRP3_API.popup.showConfirmPopup(DELETE_ITEM:format(TRP3_API.inventory.getItemLink(itemClass)), function() -- TODO: locals
				TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_ON_SLOT_REMOVE, container1, slot1, slotFrom.info);
			end);
		elseif slotTo.slotID then -- TODO: for now we assume it's good enough, but should check the name or any precise data
			local container2, slot2;
			slot2 = slotTo.slotID;
			container2 = slotTo:GetParent().info;
			TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_ON_SLOT_SWAP, container1, slot1, container2, slot2);
		end
	end
end

local function slotOnDragReceive(self)

end

local function splitStack(slot, quantity)
	if slot and slot.info and slot:GetParent().info then
		TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_SPLIT_SLOT, slot.info, slot:GetParent().info, quantity);
	end
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
			slot:RegisterForClicks("LeftButtonUp", "RightButtonUp");
			slot:RegisterForDrag("LeftButton");
			slot:SetScript("OnDragStart", slotOnDragStart);
			slot:SetScript("OnDragStop", slotOnDragStop);
			slot:SetScript("OnReceiveDrag", slotOnDragReceive);
			slot:SetScript("OnEnter", slotOnEnter);
			slot:SetScript("OnLeave", slotOnLeave);
			slot:SetScript("OnClick", function(self, button)
				if self.info then
					if button == "LeftButton" and IsShiftKeyDown() and (self.info.count or 1) > 1 then
						OpenStackSplitFrame(self.info.count, self, "BOTTOMRIGHT", "TOPRIGHT");
					elseif button == "RightButton" then
						TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_ON_SLOT_USE, self, self:GetParent());
					end
				end
			end);
			slot:SetScript("OnDoubleClick", function(self, button)
				if button == "LeftButton" and self.info and self.class and isContainerByClass(self.class) then
					switchContainerByRef(self.info, self:GetParent());
					slotOnEnter(self);
				end
			end);
			slot.SplitStack = splitStack;
			-- Listen to refresh event
			TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_DETACH_SLOT, function(slotInfo)
				if slot.info == slotInfo then
					slot.info = nil;
					slot.class = nil;
					containerSlotUpdate(slot);
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

local DEFAULT_CONTAINER_SIZE = "5x4";

function loadContainerPageSlots(containerFrame)
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

local function refreshContainers()
	for _, containerFrame in pairs(containerInstances) do
		loadContainerPageSlots(containerFrame);
	end
end

local function containerFrameUpdate(self, elapsed)
	if not self.info or not self.class then
		self:Hide();
		return
	end

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

function highlightContainerInstance(container, except)
	for _, ref in pairs(containerInstances) do
		ref.Glow:Hide();
		if ref.info == container and ref:IsVisible() then
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
		containerFrame.isMoving = self.info;
	end
end

local function onContainerShow(self)
	assert(self.info, "No info on container " .. self:GetName());
	self.IconButton.info = self.info;
	self.IconButton.class = self.class;
	lockOnContainer(self, self.originContainer);
	decorateContainer(self, self.class, self.info);
	loadContainerPageSlots(self);
end

local function onContainerHide(self)
	unlockFromContainer(self);
	-- Free resources for garbage collection.
	self.info = nil;
	self.class = nil;
	for index, slot in pairs(self.slots) do
		slot.info = nil;
		slot.class = nil;
	end
end

local CONTAINER_UPDATE_FREQUENCY = 0.15;
local function getContainerInstance(container, class)
	if not class or not isContainerByClass(class) then
		return nil;
	end

	local size = class.CO.SI or DEFAULT_CONTAINER_SIZE;
	local count = 0;
	local containerFrame, available;
	for _, ref in pairs(containerInstances) do
		count = count + 1;
		if not ref:IsVisible() and ref.containerSize == size then
			available = ref;
		end
		if ref:IsVisible() and ref.info == container then
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
		containerFrame = CreateFrame("Frame", "TRP3_Container" .. size .. "_" .. (count + 1), nil, "TRP3_Container" .. size .. "Template");
		createRefreshOnFrame(containerFrame, CONTAINER_UPDATE_FREQUENCY, containerFrameUpdate);
		initContainerSlots(containerFrame, class.CO.SR or 5, class.CO.SC or 4);
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
		containerFrame.containerSize = size;
		-- Listen to refresh event
		TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, function(containerInfo)
			if containerFrame.info == containerInfo then
				loadContainerPageSlots(containerFrame);
			end
		end);
		tinsert(containerInstances, containerFrame);
	end
	containerFrame.info = container;
	return containerFrame;
end

function isContainerInstanceOpen(container)
	for _, ref in pairs(containerInstances) do
		if ref.info == container and ref:IsVisible() then
			return true;
		end
	end
	return false;
end

function switchContainerByRef(container, originContainer)
	local class = getItemClass(container.id);
	local containerFrame = getContainerInstance(container, class);
	assert(containerFrame, "No frame available for container: " .. tostring(container.id));

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