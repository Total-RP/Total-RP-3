-- Total RP 3
-- Pet Browser
--
-- Copyright 2014-2021 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local _, TRP3_API = ...;
local L = TRP3_API.loc;

local function GetCompanionProfileID(petName)
	return TRP3_API.companions.player.getCompanionProfileID(petName);
end

local function GetCompanionProfileName(petName)
	local profileID = GetCompanionProfileID(petName);
	if not profileID then
		return nil;
	end

	local profileData = TRP3_API.companions.player.getCompanionProfileByID(profileID);
	if not profileData then
		return nil;
	end

	return profileData.profileName;
end

TRP3_PetBrowserMixin = {};

function TRP3_PetBrowserMixin:OnLoad()
	-- Browser state.
	self.pageNumber   = 1;
	self.selectedSlot = nil;
	self.tooltipFrame = nil;

	-- Dynamic UI styling.
	UIPanelCloseButton_SetBorderAtlas(self.CloseButton, "UI-Frame-GenericMetal-ExitButtonBorder", -1, 1);
	self.AcceptButton:SetText(L.UI_PET_BROWSER_ACCEPT);

	-- Icon grid layout setup.
	local GRID_DIRECTION = GridLayoutMixin.Direction.TopLeftToBottomRight;
	local GRID_STRIDE    = self:GetIconGridSize();
	local GRID_PADDING_X = 4;
	local GRID_PADDING_Y = 4;

	self.iconPool   = CreateFramePool("CheckButton", self, "TRP3_PetBrowserIconButton");
	self.iconAnchor = AnchorUtil.CreateAnchor("TOPLEFT", self.IconPager, "TOPLEFT", 57, -12);
	self.iconLayout = AnchorUtil.CreateGridLayout(GRID_DIRECTION, GRID_STRIDE, GRID_PADDING_X, GRID_PADDING_Y);
end

function TRP3_PetBrowserMixin:OnEvent(event)
	if not self:IsShown() then
		return;
	end

	if event == "PET_STABLE_SHOW" or event == "PET_STABLE_UPDATE" or event == "SPELLS_CHANGED" then
		self:UpdateVisualization();
	elseif event == "PET_STABLE_UPDATE_PAPERDOLL" then
		self:UpdateModelVisualization();
	elseif event == "UNIT_NAME_UPDATE" then
		self:UpdateNameVisualization();
		self:UpdateTooltipVisualization();
	end
end

function TRP3_PetBrowserMixin:OnShow()
	PlaySound(SOUNDKIT.IG_ABILITY_OPEN);

	self:RegisterEvent("PET_STABLE_SHOW");
	self:RegisterEvent("PET_STABLE_UPDATE");
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("PET_STABLE_UPDATE_PAPERDOLL");
	self:RegisterUnitEvent("UNIT_NAME_UPDATE", "pet");

	self:UpdateVisualization();
end

function TRP3_PetBrowserMixin:OnHide()
	if self.closedCallback then
		self.closedCallback();
	end

	PlaySound(SOUNDKIT.IG_ABILITY_CLOSE);

	self:SetAcceptCallback(nil);
	self:SetCancelCallback(nil);
	self:SetClosedCallback(nil);
	self:SetCurrentPage(1);
	self:SetSelectedSlot(nil);
	self:UnregisterAllEvents();
end

function TRP3_PetBrowserMixin:OnMouseWheel(delta)
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
	self:AdvancePage(-delta);
end

function TRP3_PetBrowserMixin:OnMouseUp()
	if not self:GetSelectedSlot() then
		return;
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	self:SetSelectedSlot(nil);
end

function TRP3_PetBrowserMixin:SetAcceptCallback(acceptCallback)
	self.acceptCallback = acceptCallback;
end

function TRP3_PetBrowserMixin:SetCancelCallback(cancelCallback)
	self.cancelCallback = cancelCallback;
end

function TRP3_PetBrowserMixin:SetClosedCallback(closedCallback)
	self.closedCallback = closedCallback;
end

-- Child Widget Scripts

function TRP3_PetBrowserMixin:OnCloseButtonClicked()
	if self.cancelCallback then
		self.cancelCallback();
	end

	self:Hide();
end

function TRP3_PetBrowserMixin:OnAcceptButtonClicked()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = self:GetPetInfoBySlot(slotIndex);

	if self.acceptCallback then
		self.acceptCallback(petInfo);
	end

	self:Hide();
end

function TRP3_PetBrowserMixin:OnPrevPageButtonClicked()
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
	self:PrevPage();
end

function TRP3_PetBrowserMixin:OnNextPageButtonClicked()
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
	self:NextPage();
end

function TRP3_PetBrowserMixin:OnIconButtonClicked(iconButton, slotIndex)
	-- Ensure the source button stays checked until we process the slot
	-- update; this prevents it deselecting itself visually when the user
	-- clicks the same slot repeatedly.
	iconButton:SetChecked(true);

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	self:SetSelectedSlot(slotIndex);
end

function TRP3_PetBrowserMixin:OnIconButtonEnter(iconButton)
	local tooltipFrame = GameTooltip;

	tooltipFrame:SetOwner(iconButton, "ANCHOR_RIGHT");
	self:SetTooltipFrame(tooltipFrame);
end

function TRP3_PetBrowserMixin:OnIconButtonLeave()
	local tooltipFrame = self:GetTooltipFrame();

	if tooltipFrame then
		tooltipFrame:ClearLines();
		tooltipFrame:Hide();
	end

	self:SetTooltipFrame(nil);
end

-- UI Functions

function TRP3_PetBrowserMixin:GetIconGridSize()
	-- Icons per row, number of rows.
	return 5, 2;
end

function TRP3_PetBrowserMixin:GetNumIconsPerPage()
	local stride, rows = self:GetIconGridSize();
	return stride * rows;
end

function TRP3_PetBrowserMixin:GetNumPages()
	return math.ceil(self:CountFilledSlots() / self:GetNumIconsPerPage());
end

function TRP3_PetBrowserMixin:GetCurrentPage()
	return self.pageNumber;
end

function TRP3_PetBrowserMixin:SetCurrentPage(pageNumber)
	pageNumber = Clamp(pageNumber, 1, self:GetNumPages());

	if self.pageNumber == pageNumber then
		return;
	end

	self.pageNumber = pageNumber;

	if self:IsShown() then
		self:UpdatePagerVisualization();
	end
end

function TRP3_PetBrowserMixin:AdvancePage(delta)
	self:SetCurrentPage(self:GetCurrentPage() + delta);
end

function TRP3_PetBrowserMixin:NextPage()
	self:AdvancePage(1);
end

function TRP3_PetBrowserMixin:PrevPage()
	self:AdvancePage(-1);
end

function TRP3_PetBrowserMixin:GetSelectedSlot()
	return self.selectedSlot;
end

function TRP3_PetBrowserMixin:SetSelectedSlot(slotIndex)
	slotIndex = self:IsValidSlot(slotIndex) and slotIndex or nil;

	if self.selectedSlot == slotIndex then
		return;
	end

	self.selectedSlot = slotIndex;

	if self:IsShown() then
		self:UpdateVisualization();
	end
end

function TRP3_PetBrowserMixin:GetTooltipFrame()
	return self.tooltipFrame;
end

function TRP3_PetBrowserMixin:SetTooltipFrame(tooltipFrame)
	if self.tooltipFrame == tooltipFrame then
		return;
	end

	self.tooltipFrame = tooltipFrame;
	self:UpdateTooltipVisualization();
end

function TRP3_PetBrowserMixin:GetFirstPetSlotByPage(pageNumber)
	-- The API works in terms of slot indexes, and players can place pets
	-- in any slot with gaps in between each. We compress this down in the
	-- UI to omit the empty slots and group pets together.
	--
	-- The logic here counts the number of slots that should preceed the
	-- given page index (zero if the first page) and will enumerate the
	-- filled slots until that number decrements to zero. Once at zero,
	-- the next slot after that is the first one for the requested page.

	local slotIndex      = 0;
	local slotsRemaining = self:GetNumIconsPerPage() * (pageNumber - 1);

	while slotsRemaining > 0 do
		slotIndex = self:NextFilledSlot(slotIndex);
		if not slotIndex then
			return nil;
		end

		slotsRemaining = slotsRemaining - 1;
	end

	return self:NextFilledSlot(slotIndex);
end

function TRP3_PetBrowserMixin:UpdateVisualization()
	self:UpdatePagerVisualization();
	self:UpdateModelVisualization();
	self:UpdateNameVisualization();
	self:UpdateTooltipVisualization();
	self:UpdateOverlayTextVisualization();
end

function TRP3_PetBrowserMixin:UpdatePagerVisualization()
	self.iconPool:ReleaseAll();

	local iconsPerPage = self:GetNumIconsPerPage();
	local pageIndex    = self:GetCurrentPage();
	local pageCount    = self:GetNumPages();
	local slotIndex    = self:GetFirstPetSlotByPage(pageIndex);

	self.IconPager.PrevPageButton:SetEnabled(pageIndex > 1);
	self.IconPager.NextPageButton:SetEnabled(pageIndex < pageCount);
	self.AcceptButton:SetEnabled(self:GetSelectedSlot() ~= nil);

	-- On each page we'll always show the maximum number of icons and fill
	-- them in with pets from top-left to bottom-right. Empty spaces will
	-- just have a placeholder that does nothing.

	local iconButtons = {};

	for _ = 1, iconsPerPage do
		local iconButton = self.iconPool:Acquire();
		self:UpdateIconButtonVisualization(iconButton, self:GetPetInfoBySlot(slotIndex));
		table.insert(iconButtons, iconButton);

		-- Only advance to the next slot if the current one was valid,
		-- otherwise keep it nil or we'll end up wrapping the iterator.
		slotIndex = slotIndex and self:NextFilledSlot(slotIndex);
	end

	AnchorUtil.GridLayout(iconButtons, self.iconAnchor, self.iconLayout);
end

function TRP3_PetBrowserMixin:UpdateIconButtonVisualization(iconButton, petInfo)
	iconButton:SetEnabled(petInfo ~= nil);
	iconButton:SetChecked(petInfo and petInfo.slot == self:GetSelectedSlot());
	iconButton:Show();

	if petInfo then
		-- Filled slot that has a valid pet.
		iconButton:SetID(petInfo.slot);
		iconButton.Icon:SetTexture(petInfo.icon);
	else
		-- Empty slot with no pet.
		iconButton:SetID(0);
		iconButton.Icon:SetAtlas([[auctionhouse-itemicon-empty]]);
	end
end

function TRP3_PetBrowserMixin:UpdateModelVisualization()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = self:GetPetInfoBySlot(slotIndex);

	if petInfo then
		SetPetStablePaperdoll(self.Model, slotIndex);
	else
		self.Model:ClearModel();
	end
end

function TRP3_PetBrowserMixin:UpdateNameVisualization()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = self:GetPetInfoBySlot(slotIndex);

	if petInfo then
		self.Header.Text:SetText(petInfo.name);
		self.Header:Show();
	else
		self.Header:Hide();
	end
end

function TRP3_PetBrowserMixin:UpdateTooltipVisualization()
	local tooltipFrame = self:GetTooltipFrame();
	if not tooltipFrame then
		return;
	end

	local slotIndex = tooltipFrame and tooltipFrame:GetOwner():GetID() or nil;
	local petInfo   = self:GetPetInfoBySlot(slotIndex);

	tooltipFrame:ClearLines();

	if petInfo then
		local titleText = petInfo.name;
		local levelText = format(UNIT_TYPE_LEVEL_TEMPLATE, petInfo.level, petInfo.family);

		GameTooltip_SetTitle(tooltipFrame, titleText, false);
		GameTooltip_AddNormalLine(tooltipFrame, levelText);

		-- Add a warning for pets that are bound to existing profiles.

		local boundProfileName = GetCompanionProfileName(petInfo.name);
		if boundProfileName then
			local boundText = format(L.UI_PET_BROWSER_BOUND_WARNING, boundProfileName);

			GameTooltip_AddBlankLineToTooltip(tooltipFrame);
			GameTooltip_AddColoredLine(tooltipFrame, boundText, RED_FONT_COLOR);
		end

		tooltipFrame:Show();
	else
		tooltipFrame:Hide();
	end
end

function TRP3_PetBrowserMixin:UpdateOverlayTextVisualization()
	-- The overlay text is used to show some help when in an empty state with
	-- either no selected pet, or the edge case where we've been opened but
	-- the user literally has no pets.
	--
	-- This is a child of the model for UI layering reasons.

	local firstSlot = self:NextFilledSlot(nil);
	local slotIndex = self:GetSelectedSlot();

	if not firstSlot then
		self.Model.OverlayText:SetText(L.UI_PET_BROWSER_EMPTY_TEXT);
		self.Model.OverlayText:Show();
	elseif not slotIndex then
		self.Model.OverlayText:SetText(L.UI_PET_BROWSER_INTRO_TEXT);
		self.Model.OverlayText:Show();
	else
		self.Model.OverlayText:Hide();
	end
end

-- Data Functions

function TRP3_PetBrowserMixin:CheckUsageConditions()
	-- Only suggest that this browser be used for Hunters as we're using
	-- the stable APIs for populating it.
	return select(2, UnitClass("player")) == "HUNTER";
end

function TRP3_PetBrowserMixin:GetNumSlots()
	return self:GetNumCallableSlots() + self:GetNumStableSlots();
end

function TRP3_PetBrowserMixin:GetNumCallableSlots()
	-- These globals are defined in FrameXML\PetStable.lua
	return NUM_PET_ACTIVE_SLOTS;
end

function TRP3_PetBrowserMixin:GetNumStableSlots()
	-- These globals are defined in FrameXML\PetStable.lua
	return NUM_PET_STABLE_PAGES * NUM_PET_STABLE_SLOTS;
end

function TRP3_PetBrowserMixin:IsValidSlot(slotIndex)
	if type(slotIndex) ~= "number" then
		return false;
	end

	return slotIndex >= 1 and slotIndex <= self:GetNumSlots();
end

function TRP3_PetBrowserMixin:GetPetInfoBySlot(slotIndex)
	if not self:IsValidSlot(slotIndex) then
		return nil;
	end

	local icon, name, level, family = GetStablePetInfo(slotIndex);

	if not name then
		return nil;
	end

	return {
		slot   = slotIndex,
		icon   = icon,
		name   = name,
		level  = level,
		family = family,
	};
end

function TRP3_PetBrowserMixin:CountFilledSlots()
	local count = 0;

	for i = 1, self:GetNumSlots() do
		if GetStablePetInfo(i) then
			count = count + 1;
		end
	end

	return count;
end

function TRP3_PetBrowserMixin:IsSlotFilled(slotIndex)
	local _, name = GetStablePetInfo(slotIndex);
	return name ~= nil;
end

function TRP3_PetBrowserMixin:NextFilledSlot(slotIndex)
	local slotCount = self:GetNumSlots();
	slotIndex = slotIndex or 0;

	while slotIndex < slotCount do
		slotIndex = slotIndex + 1;

		if self:IsSlotFilled(slotIndex) then
			return slotIndex;
		end
	end

	return nil;
end
