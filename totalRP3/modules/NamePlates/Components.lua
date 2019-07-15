-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
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

-- TRP3_API imports.
local TRP3_Navigation = TRP3_API.navigation;
local TRP3_Register = TRP3_API.register;
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Ellyb imports.
local ColorManager = TRP3_API.Ellyb.ColorManager;

-- NamePlates module imports.
local DEFAULT_GLANCE_ICON = NamePlates.DEFAULT_GLANCE_ICON;
local DEFAULT_GLANCE_TEXT = NamePlates.DEFAULT_GLANCE_TEXT;
local ICON_PATH = NamePlates.ICON_PATH;
local MAX_GLANCE_TITLE_CHARS = NamePlates.MAX_GLANCE_TITLE_CHARS;
local MAX_NAME_CHARS = NamePlates.MAX_NAME_CHARS;
local MAX_NUM_GLANCES = NamePlates.MAX_NUM_GLANCES;

-- Mixin that implements a button for display on a nameplate glance bar.
local GlanceButtonMixin = {};

-- Initializes the glance button with suitable defaults for display.
function GlanceButtonMixin:OnLoad()
	-- The glance data used by this button.
	self.glance = nil;

	-- The unit that owns this glance.
	self.owningUnit = nil;

	-- Initialize with a nil glance so we have defaults applied.
	self:SetGlance(nil);
end

-- Clears the glance button, unsetting its glance and owner.
function GlanceButtonMixin:Clear()
	self:SetGlance(nil);
	self:SetOwningUnit(nil);
end

-- Updates the button to display data from the given glance. If nil, the
-- button will display suitable defaults.
--
-- This will not update the display frame for a glance if opened; the
-- display frame is treated as a snapshot view rather than a live view.
function GlanceButtonMixin:SetGlance(glance)
	-- Store the glance locally.
	self.glance = glance;

	-- Update the visual display of the button.
	local iconName = glance and glance.IC or DEFAULT_GLANCE_ICON;
	SetPortraitToTexture(self.Icon, ICON_PATH .. iconName);
end

-- Updates the button, marking it as beloning to the specified unit. This
-- unit will have their name displayed in the display frame for a glance
-- if shown.
function GlanceButtonMixin:SetOwningUnit(owningUnit)
	self.owningUnit = owningUnit;
end

-- Handler triggered when the mouse clicks this button.
--[[private]] function GlanceButtonMixin:OnClick(button)
	if button == "LeftButton" then
		-- Update the glance frame with our data.
		if not self.glance then
			return;
		end

		TRP3_NamePlateGlanceDisplayFrame:SetGlance(self.glance, self.owningUnit);
	elseif button == "RightButton" then
		-- Open the profile.
		local registerID = NamePlates.GetRegisterIDForUnit(self.owningUnit);
		if not registerID then
			return;
		end

		-- We'll issue a request while we're at it.
		NamePlates.RequestUnitProfile(self.owningUnit);

		TRP3_Navigation.openMainFrame();
		TRP3_Register.openPageByUnitID(registerID);
	end
end

-- Handler triggered when the mouse enters the area of this button.
--[[private]] function GlanceButtonMixin:OnEnter()
	-- Grab the glance title and icon.
	local glance = self.glance;
	if not glance then
		return;
	end

	local title = glance.TI or DEFAULT_GLANCE_TEXT;
	local icon = glance.IC or DEFAULT_GLANCE_ICON;

	-- Crop the title text and prefix it with the icon.
	local titleText = TRP3_Utils.str.crop(title, MAX_GLANCE_TITLE_CHARS);
	local iconMarkup = CreateTextureMarkup(ICON_PATH .. icon, 64, 64, 16, 16, 0, 1, 0, 1);

	-- Display the tooltip with hints on the user can do.
	TRP3_MainTooltip:SetOwner(self, "ANCHOR_RIGHT");
	TRP3_MainTooltip:AddLine(strjoin(" ", iconMarkup, titleText));
	TRP3_MainTooltip:AddLine(glance.TX or DEFAULT_GLANCE_TEXT, 1, 1, 1, true);
	TRP3_MainTooltip:AddLine(" ");
	TRP3_MainTooltip:AddLine("|cffffff00Left-click:|r Show glance", 1, 1, 1);
	TRP3_MainTooltip:AddLine("|cffffff00Right-click:|r Open profile", 1, 1, 1);
	TRP3_MainTooltip:Show();
end

-- Handler triggered when the mouse leaves the area of this button.
--[[private]] function GlanceButtonMixin:OnLeave()
	-- Hide the tooltip.
	TRP3_MainTooltip:Hide();
end

-- Mixin that implements a glance bar for nameplates. This handles the
-- assignment and management of glances for a profile, using a pool of
-- button widgets to display them.
--
-- The buttons will be sized as squares deriving their width/height
-- from the height of the widget for this bar. The glances will be laid
-- out from left to right without gaps to conserve space, and the width
-- of the bar will be equal to the total space used by the displayed
-- glances.
local GlanceBarMixin = {};

-- Shared pool we'll use for handling glance buttons.
GlanceBarMixin.ButtonPool = CreateFramePool("Button", UIParent, "TRP3_NamePlateGlanceButton");

-- Internal vsibility states.
GlanceBarMixin.VisibilityState = tInvert({
	"ShowOpaque",
	"ShowTranslucent",
	"HideDelayed",
	"HideImmediate",
});

-- Alpha levels for an opaque vs. translucent display state.
GlanceBarMixin.AlphaLevelOpaque = 1.0;
GlanceBarMixin.AlphaLevelTranslucent = 0.5;

-- Number of seconds to delay hiding for in a HideDelayed state.
GlanceBarMixin.HideDelaySeconds = 0.3;

-- Period of time between ticks for the visibility test timer. This is only
-- used when a bar is actively shown. The larger this is, the more inaccurate
-- the HideDelaySeconds value will become.
GlanceBarMixin.VisibilityTestPeriod = 0.2;

-- Initializes the glance bar with no initial glances or owning unit.
function GlanceBarMixin:OnLoad()
	-- Glancesthat are assigned to this bar. A bar with no glances
	-- (either nil or a zero count) is always hidden.
	self.glances = nil;

	-- Unit that owns the bar. Used for our visibility rules. A bar with
	-- no owning unit is always hidden.
	self.owningUnit = nil;

	-- Current visibility state, the time at which we entered it, and a
	-- started ticker set when the bar is shown for visibility rule testing.
	self.visibilityState = GlanceBarMixin.HideImmediate;
	self.visibilityTransitionTime = GetTime();
	self.visibilityTicker = nil;

	-- List of buttons that we've acquired from the pool for this bar.
	self.buttons = {};

	-- Always start off hidden.
	self:Hide();
end

-- Clears the owning unit of this bar, causing it to hide immediately.
function GlanceBarMixin:ClearOwningUnit()
	self:SetOwningUnit(nil);
end

-- Clears all displayed glances from the bar.
function GlanceBarMixin:ClearGlances()
	self:SetGlances(nil);
end

-- Returns the unit token that currently owns this bar, or nil if none is set.
function GlanceBarMixin:GetOwningUnit()
	return self.owningUnit;
end

-- Returns the glances that are displayed on this bar, or nil if none were
-- assigned.
function GlanceBarMixin:GetGlances()
	return self.glances;
end

-- Sets the glances to be displayed on the bar. If the given glance table
-- is nil or empty, the bar will be hidden.
function GlanceBarMixin:SetGlances(glances)
	-- Update the bar after assigning the glances.
	self.glances = glances;
	self:UpdateBar();
end

-- Sets the unit token that owns this bar. If the given unit is nil, the
-- bar will be hidden.
function GlanceBarMixin:SetOwningUnit(owningUnit)
	-- Update the bar after the unit is set.
	self.owningUnit = owningUnit;
	self:UpdateBar();
end

-- Handler called when the mouse enters the area of the bar.
--[[private]] function GlanceBarMixin:OnEnter()
	-- Update visibility rules on the bar.
	self:UpdateVisibility();
end

-- Handler called when the mouse leaves the area of the bar.
--[[private]] function GlanceBarMixin:OnLeave()
	-- Update visibility rules on the bar.
	self:UpdateVisibility();
end

-- Handler called when the glance bar is shown.
--[[private]] function GlanceBarMixin:OnShow()
	-- Set up a timer that'll periodically test our visibility conditions.
	if not self.visibilityTicker then
		local period = GlanceBarMixin.VisibilityTestPeriod;
		self.visibilityTicker = C_Timer.NewTicker(period, function()
			self:UpdateVisibility();
		end);
	end
end

-- Handler called when the glance bar is hidden.
--[[private]] function GlanceBarMixin:OnHide()
	-- Cancel and delete the visibility ticker.
	if self.visibilityTicker then
		self.visibilityTicker:Cancel();
		self.visibilityTicker = nil;
	end
end

-- Returns the suggested size (width and height) for buttons on this bar.
--[[private]] function GlanceBarMixin:GetButtonSize()
	-- Use the height of the bar as the width/height of our buttons.
	return self:GetHeight(), self:GetHeight();
end

-- Returns true if we've been in the HideDelayed state for longer than the
-- maximum amount of time specified by HideDelaySeconds.
--
-- Returns false if not in the HideDelayed state, or if not enough time has
-- yet elapsed.
--[[private]] function GlanceBarMixin:HasHideDelayElapsed()
	-- If we're not in the HideDelayed state, it can't ever elapse.
	local VisibilityState = GlanceBarMixin.VisibilityState;
	if self.visibilityState ~= VisibilityState.HideDelayed then
		return false;
	end

	-- Test the transition time against now, adjusted for the delay timer.
	local transitionEndTime = (GetTime() - GlanceBarMixin.HideDelaySeconds);
	return self.visibilityTransitionTime <= transitionEndTime;
end

-- Returns the suggested visibility state of the bar.
--[[private]] function GlanceBarMixin:GetSuggestedVisibilityState()
	-- Grab the state enumeration and then test our conditions.
	local VisibilityState = GlanceBarMixin.VisibilityState;

	if not self.owningUnit or not self.glances or not next(self.glances) then
		-- Don't show if we have no owning unit or glances. This takes
		-- the highest priority.
		return VisibilityState.HideImmediate;
	elseif self:IsMouseOver() or UnitIsUnit(self.owningUnit, "target") then
		-- Show opaquely if there's mouse interaction or this is the target.
		return VisibilityState.ShowOpaque;
	elseif UnitIsUnit(self.owningUnit, "mouseover") then
		-- Show transluclently if this is the mouseover unit.
		return VisibilityState.ShowTranslucent;
	elseif self:HasHideDelayElapsed() then
		-- The hide delay elapsing requires an immediate hide, but is
		-- lower priority than conditions that'd cause us to show.
		return VisibilityState.HideImmediate;
	elseif self.visibilityState ~= VisibilityState.HideImmediate then
		-- The bar has been showing but no other criteria are met. We'll
		-- go to the HideDelayed state. This should be a last resort.
		return VisibilityState.HideDelayed;
	end

	-- Otherwise there's no applicable conditions, so default to always
	-- hiding it immediately.
	return VisibilityState.HideImmediate;
end

-- Updates the buttons and visibility of the bar.
--[[private]] function GlanceBarMixin:UpdateBar()
	self:UpdateVisibility();
	self:UpdateButtons();
end

-- Update the visibility of the bar according to its own visibility rules.
--[[private]] function GlanceBarMixin:UpdateVisibility()
	-- Update the overall visibility of the bar.
	local visibilityState = self:GetSuggestedVisibilityState();
	if self.visibilityState == visibilityState then
		-- No state change.
		return;
	end

	-- Transition accordingly.
	local VisibilityState = GlanceBarMixin.VisibilityState;

	if visibilityState == VisibilityState.ShowOpaque then
		self:SetAlpha(GlanceBarMixin.AlphaLevelOpaque);
		self:Show();
	elseif visibilityState == VisibilityState.ShowTranslucent then
		self:SetAlpha(GlanceBarMixin.AlphaLevelTranslucent);
		self:Show();
	elseif visibilityState == VisibilityState.HideDelayed then
		-- HideDelayed will also use the translucent alpha level.
		self:SetAlpha(GlanceBarMixin.AlphaLevelTranslucent);
		self:Show();
	elseif visibilityState == VisibilityState.HideImmediate then
		self:Hide();
	end

	-- Update the state and the transition time after applying changes.
	self.visibilityState = visibilityState;
	self.visibilityTransitionTime = GetTime();
end

-- Updates all the buttons on the bar, adding/updating/removing them as
-- needed in response to the assigned glances.
--[[private]] function GlanceBarMixin:UpdateButtons()
	-- Work out the number of glances we should be allowed to display.
	local maxGlances = self:IsShown() and MAX_NUM_GLANCES or 0;

	-- Set up buttons for the glances.
	local buttonIndex = 0;
	for glanceIndex = 1, maxGlances do
		-- Unlike other parts of the UI, we want nameplates to be compact
		-- so we'll remove gaps between missing/inactive glances.
		local glance = self.glances[tostring(glanceIndex)];
		if glance and glance.AC then
			-- Update the button for this glance.
			buttonIndex = buttonIndex + 1;

			local button = self:GetOrAcquireButton(buttonIndex);
			button:SetOwningUnit(self.owningUnit);
			button:SetGlance(glance);
		end
	end

	-- Clean up buttons that shouldn't be shown.
	local buttonCount = #self.buttons;
	for i = buttonCount, buttonIndex + 1, -1 do
		self:ReleaseButton(i, nil);
	end

	-- Update the dimensions of the bar so the UI renders it properly.
	local buttonWidth = self:GetButtonSize();
	self:SetWidth(buttonWidth * buttonCount);
end

-- Acquires a new button, appending it to the end of the bar.
--[[private]] function GlanceBarMixin:AcquireButton()
	-- Acquire and set up a button.
	local index = #self.buttons + 1;
	local width, height = self:GetButtonSize();

	local button = self.ButtonPool:Acquire();
	button:ClearAllPoints();
	button:SetParent(self);
	button:SetPoint("LEFT", (index - 1) * width, 0);
	button:SetSize(width, height);
	button:Show();

	self.buttons[index] = button;
	return button;
end

-- Returns a glance button at the specified index, acquiring one if required.
--
-- The given index must be in the range 1 through GetNumButtons + 1; buttons
-- may only be created at-most 1 index beyond the end.
--[[private]] function GlanceBarMixin:GetOrAcquireButton(index)
	-- Index must be in range of 1 through GetNumButtons + 1, since we allow
	-- creating new buttons at the end of the list only.
	assert(index >= 1 and index <= (#self.buttons + 1));
	return self.buttons[index] or self:AcquireButton();
end

-- Releases the button at the given index back into the shared pool.
--[[private]] function GlanceBarMixin:ReleaseButton(index)
	local button = self.buttons[index];
	if button then
		-- Clear data from the button.
		button:Clear();

		-- Remove and re-pool.
		tremove(self.buttons, index);
		self.ButtonPool:Release(button);
	end
end

-- Mixin for the display frame that appears when you click a glance.
local GlanceDisplayMixin = {};

-- Minimum width for the display frame when shown.
GlanceDisplayMixin.MinimumWidth = 300;

-- Initializes the frame with no initial glance data.
function GlanceDisplayMixin:OnLoad()
	-- Enable dragging so users can reposition the darn thing.
	self:RegisterForDrag("LeftButton");

	-- Start it in a cleared state, which will hide it.
	self:Clear();
end

-- Clears the display of any glance information.
function GlanceDisplayMixin:Clear()
	self:SetGlance(nil);
end

-- Sets the glance to be displayed, optionally marked as belonging to the
-- given unit token.
function GlanceDisplayMixin:SetGlance(glance, unitToken)
	-- Update the widget visuals.
	self:UpdateGlanceDisplay(glance);
	self:UpdateOwnerDisplay(unitToken);

	-- Play an update sound if we're replacing the contents while showing.
	local active = glance and glance.AC;
	if active and self:IsShown() then
		PlaySound(3093); -- WriteQuest
	end

	-- Update visibility.
	self:SetShown(active);

	-- Resize to fit contents only if active.
	if active then
		self:ResizeToFit();
	end
end

-- Handler called when the frame is shown.
--[[private]] function GlanceDisplayMixin:OnShow()
	-- Raise the frame to the top so it goes above frames and can be dragged.
	self:Raise();
	PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
end

-- Handler called when the frame is hidden.
--[[private]] function GlanceDisplayMixin:OnHide()
	PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
end

-- Updates the display to represent the given glance.
--[[private]] function GlanceDisplayMixin:UpdateGlanceDisplay(glance)
	-- Update all the fontstrings/textures on the widget.
	local icon = glance and glance.IC or DEFAULT_GLANCE_ICON;
	local title = glance and glance.TI or DEFAULT_GLANCE_TEXT;
	local description = glance and glance.TX or DEFAULT_GLANCE_TEXT;

	-- Trim the title down so it doesn't run on too long.
	title = TRP3_Utils.str.crop(title, MAX_GLANCE_TITLE_CHARS);

	self.Icon:SetTexture(ICON_PATH .. icon);
	self.Title:SetText(title);
	self.Description:SetText(description);
end

-- Updates the display to represent that the glance is owned by the given
-- unit token.
--[[private]] function GlanceDisplayMixin:UpdateOwnerDisplay(unitToken)
	local name = unitToken and NamePlates.GetUnitCustomName(unitToken);
	if not name then
		-- Clear the owner text and reposition the title to take the space.
		self.Owner:SetText("");
		self.Title:SetPoint("BOTTOMLEFT", self.Icon, "BOTTOMRIGHT", 8, 0);
		return;
	end

	-- Obtain the color for this owner.
	local color = NamePlates.GetUnitCustomColor(unitToken)
	if not color then
		color = NamePlates.GetUnitClassColor(unitToken);
		if not color then
			color = ColorManager.WHITE;
		end
	end

	-- Trim the name down so it doesn't run on too long.
	name = TRP3_Utils.str.crop(name, MAX_NAME_CHARS);

	-- Update the text and its color.
	self.Owner:SetText(name);
	self.Owner:SetTextColor(color:GetRGB());

	-- Ensure the title doesn't overlap the owner string.
	self.Title:SetPoint("BOTTOMLEFT", self.Icon, "RIGHT", 8, 0);
end

-- Resizes the frame to fit the content of its strings.
--[[private]] function GlanceDisplayMixin:ResizeToFit()
	-- We need to set the width first so that the description fontstring
	-- recalculates how much height it requires to fully display its content.
	self:SetWidth(self:GetSuggestedWidth());
	self:SetHeight(self:GetSuggestedHeight());
end

-- Returns the suggested width of the frame based on its contents.
--[[private]] function GlanceDisplayMixin:GetSuggestedWidth()
	-- The suggested width is derived from the wider of the title and owner
	-- fontstrings, which only have anchors set to control their height thus
	-- allowing the game to size their width to fit their contents.
	--
	-- We also have a minimum bound on the width to ensure the box isn't
	-- too small.
	--
	-- We need to increase it by the combined total of the following:
	--   - The inner padding of the frame content.
	--   - The width of the icon.
	--   - The spacing between the icon and the title/owner strings.

	-- Obtain the metrics we'll be using for this.
	local frameLeft = self:GetLeft();
	local iconLeft = self.Icon:GetLeft();
	local iconRight = self.Icon:GetRight();
	local titleLeft = self.Title:GetLeft();
	local titleWidth = self.Title:GetWidth();
	local ownerWidth = self.Owner:GetWidth();
	local closeButtonWidth = self.CloseButton:GetWidth();

	-- The inner padding can be calculated from the space between the left of
	-- the frame and the left of the icon, doubled.
	local padding = (iconLeft - frameLeft) * 2;

	-- The spacing between the icon is the difference between the left edge
	-- of the title string, and the right edge of the icon.
	local iconWidth = iconRight - iconLeft;
	local iconSpacing = titleLeft - iconRight;

	-- We want the larger of the content strings; the one catch here is the
	-- title overlaps the close button slightly so we need to artifically
	-- increase its width a small amount.
	local titleAdjustedWidth = (titleWidth + (closeButtonWidth * 0.75));
	local contentWidth = math.max(titleAdjustedWidth, ownerWidth);

	-- Increase the content width by the sum of our other values.
	contentWidth = contentWidth + padding + iconWidth + iconSpacing;

	-- Return the larger of the content width and our minimum size.
	return math.max(self.MinimumWidth, contentWidth);
end

-- Returns the suggested height of the frame based on its contents.
--[[private]] function GlanceDisplayMixin:GetSuggestedHeight()
	-- The suggested height is derived from the height of the description
	-- text, which only has one anchor to allow the game to size it to fit
	-- the contents.
	--
	-- We need to increase it by the combined total of the following:
	--   - The inner padding of the frame content.
	--   - The height of the icon.
	--   - The spacing between the icon and the description.

	-- Obtain the metrics we'll be using for this.
	local frameTop = self:GetTop();
	local iconTop = self.Icon:GetTop();
	local iconBottom = self.Icon:GetBottom();
	local descriptionTop = self.Description:GetTop();
	local descriptionHeight = self.Description:GetHeight();

	-- The inner padding can be calculated from the space between the top of
	-- the frame and the top of the icon, doubled.
	local padding = (frameTop - iconTop) * 2;

	-- The margin of the icon is the space between the bottom of the icon,
	-- and the top of the description.
	local iconHeight = iconTop - iconBottom;
	local iconSpacing = iconBottom - descriptionTop;

	-- The frame height is then just all this summed up.
	return descriptionHeight + padding + iconHeight + iconSpacing;
end

-- Module exports.
NamePlates.GlanceButtonMixin = GlanceButtonMixin;
NamePlates.GlanceBarMixin = GlanceBarMixin;
NamePlates.GlanceDisplayMixin = GlanceDisplayMixin;

TRP3_NamePlateGlanceButtonMixin = GlanceButtonMixin;
TRP3_NamePlateGlanceBarMixin = GlanceBarMixin;
TRP3_NamePlateGlanceDisplayMixin = GlanceDisplayMixin;
