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

local function GetPetCompanionProfile(petName)
	local profileID = TRP3_API.companions.player.getCompanionProfileID(petName);
	if not profileID then
		return nil;
	end

	local profileData = TRP3_API.companions.player.getCompanionProfileByID(profileID);
	if not profileData then
		return nil;
	end

	return profileData;
end

local function GetNumPetSlots()
	-- These globals are defined in FrameXML\PetStable.lua
	local NUM_CALLABLE_SLOTS = NUM_PET_ACTIVE_SLOTS;
	local NUM_STABLE_SLOTS   = NUM_PET_STABLE_PAGES * NUM_PET_STABLE_SLOTS;

	return NUM_CALLABLE_SLOTS + NUM_STABLE_SLOTS;
end

local function IsValidPetSlot(slotIndex)
	if type(slotIndex) ~= "number" then
		return false;
	end

	return slotIndex >= 1 and slotIndex <= GetNumPetSlots();
end

local function GetPetInfoBySlot(slotIndex)
	if not IsValidPetSlot(slotIndex) then
		return nil;
	end

	-- The information fetched by this function is a structured combination
	-- of the results of the stable master APIs and data on any associated
	-- companion profile the pet has.

	local icon, name, level, family = GetStablePetInfo(slotIndex);
	if not name then
		return nil;
	end

	local profileID   = TRP3_API.companions.player.getCompanionProfileID(name);
	local profileData = GetPetCompanionProfile(name);

	-- The level squish is only applied to pets after they're summoned for the
	-- first time since the launch of patch 9.0; the stable master APIs will
	-- return pre-squish levels until this occurs so we'll hack it for UI
	-- purposes to automatically squish pet levels if they're greater than
	-- the maximum attainable player level.

	if level > GetMaxLevelForLatestExpansion() then
		level = C_LevelSquish.ConvertPlayerLevel(level);
	end

	return {
		slot        = slotIndex,
		icon        = icon,
		name        = name,
		level       = level,
		family      = family,
		profileID   = profileID,
		profileName = profileData and profileData.profileName or nil,
	};
end

local function CountFilledPetSlots()
	local count = 0;

	for i = 1, GetNumPetSlots() do
		if GetStablePetInfo(i) then
			count = count + 1;
		end
	end

	return count;
end

local function IsPetSlotFilled(slotIndex)
	local _, name = GetStablePetInfo(slotIndex);
	return name ~= nil;
end

local function NextFilledPetSlot(slotIndex)
	local slotCount = GetNumPetSlots();
	slotIndex = slotIndex or 0;

	while slotIndex < slotCount do
		slotIndex = slotIndex + 1;

		if IsPetSlotFilled(slotIndex) then
			return slotIndex;
		end
	end

	return nil;
end

--
-- UI APIs
--

AddOn_TotalRP3.Ui = AddOn_TotalRP3.Ui or {};

function AddOn_TotalRP3.Ui.IsPetBrowserEnabled()
	-- Only suggest that this browser be usable for Hunters as we're using
	-- the stable APIs for populating it. On Classic, this will always
	-- be disabled as we don't support companion profiles there.

	return TRP3_API.globals.player_character.class == "HUNTER" and not TRP3_API.globals.is_classic;
end

function AddOn_TotalRP3.Ui.GetPetBrowserFrame()
	if TRP3_PetBrowserFrame then
		return TRP3_PetBrowserFrame;
	elseif AddOn_TotalRP3.Ui.IsPetBrowserEnabled() then
		return CreateFrame("Frame", "TRP3_PetBrowserFrame", TRP3_PopupsFrame, "TRP3_PetBrowserFrameTemplate");
	else
		return nil; -- Browser isn't enabled, so no frame for you.
	end
end

--
-- PetBrowserMixin
--

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

function TRP3_PetBrowserMixin:SetAcceptCallback(acceptCallback)
	self.acceptCallback = acceptCallback;
end

function TRP3_PetBrowserMixin:SetCancelCallback(cancelCallback)
	self.cancelCallback = cancelCallback;
end

function TRP3_PetBrowserMixin:SetClosedCallback(closedCallback)
	self.closedCallback = closedCallback;
end

function TRP3_PetBrowserMixin:GetIconGridSize()
	-- Icons per row, number of rows.
	return 5, 2;
end

function TRP3_PetBrowserMixin:GetNumIconsPerPage()
	local stride, rows = self:GetIconGridSize();
	return stride * rows;
end

function TRP3_PetBrowserMixin:GetNumPages()
	return math.ceil(CountFilledPetSlots() / self:GetNumIconsPerPage());
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
	slotIndex = IsValidPetSlot(slotIndex) and slotIndex or nil;

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
		slotIndex = NextFilledPetSlot(slotIndex);
		if not slotIndex then
			return nil;
		end

		slotsRemaining = slotsRemaining - 1;
	end

	return NextFilledPetSlot(slotIndex);
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
		self:UpdateIconButtonVisualization(iconButton, GetPetInfoBySlot(slotIndex));
		table.insert(iconButtons, iconButton);

		-- Only advance to the next slot if the current one was valid,
		-- otherwise keep it nil or we'll end up wrapping the iterator.
		slotIndex = slotIndex and NextFilledPetSlot(slotIndex) or nil;
	end

	AnchorUtil.GridLayout(iconButtons, self.iconAnchor, self.iconLayout);
end

function TRP3_PetBrowserMixin:UpdateIconButtonVisualization(iconButton, petInfo)
	iconButton:SetEnabled(petInfo ~= nil);
	iconButton:SetChecked(petInfo and petInfo.slot == self:GetSelectedSlot());
	iconButton:Show();

	if petInfo then
		iconButton:SetID(petInfo.slot);
		iconButton.Icon:SetTexture(petInfo.icon);
	else
		iconButton:SetID(0);
		iconButton.Icon:SetAtlas([[auctionhouse-itemicon-empty]]);
	end
end

function TRP3_PetBrowserMixin:UpdateModelVisualization()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = GetPetInfoBySlot(slotIndex);

	if petInfo then
		SetPetStablePaperdoll(self.Model, slotIndex);
	else
		self.Model:ClearModel();
	end
end

function TRP3_PetBrowserMixin:UpdateNameVisualization()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = GetPetInfoBySlot(slotIndex);

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
	local petInfo   = GetPetInfoBySlot(slotIndex);

	tooltipFrame:ClearLines();

	if petInfo then
		local titleText = petInfo.name;
		local levelText = format(UNIT_TYPE_LEVEL_TEMPLATE, petInfo.level, petInfo.family);

		GameTooltip_SetTitle(tooltipFrame, titleText, false);
		GameTooltip_AddNormalLine(tooltipFrame, levelText);

		-- Add a warning for pets that are bound to existing profiles.

		if petInfo.profileID then
			local boundText = format(L.UI_PET_BROWSER_BOUND_WARNING, petInfo.profileName);

			GameTooltip_AddBlankLineToTooltip(tooltipFrame);
			GameTooltip_AddNormalLine(tooltipFrame, boundText, true);
		end

		-- Add a warning for pets that share the same name as their family.
		--
		-- This is intended as a basic way to suggest that the user should
		-- rename their pet to avoid collisions if they tame another unnamed
		-- pet from the same family. It isn't perfect since some tames don't
		-- default to the family name, but it's better than nothing.

		if petInfo.name == petInfo.family then
			GameTooltip_AddBlankLineToTooltip(tooltipFrame);
			GameTooltip_AddNormalLine(tooltipFrame, L.UI_PET_BROWSER_NAME_WARNING, true);
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

	local firstSlot = NextFilledPetSlot(nil);
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

function TRP3_PetBrowserMixin:OnCloseButtonClicked()
	if self.cancelCallback then
		self.cancelCallback();
	end

	self:Hide();
end

function TRP3_PetBrowserMixin:OnAcceptButtonClicked()
	local slotIndex = self:GetSelectedSlot();
	local petInfo   = GetPetInfoBySlot(slotIndex);

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
