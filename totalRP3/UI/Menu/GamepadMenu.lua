-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Menus drawn by frames of our own, for use while the game shows its
-- controller interface.
--
-- With that interface shown, a Blizzard menu tells the controller's focus
-- manager that it opened. A menu opened by an addon makes the manager do its
-- bookkeeping while tainted; the game then refuses its own controller
-- navigation ("Interface action failed because of an AddOn") and blocks
-- SetPreferredGamepadInteractTarget from then on. Frames of our own never
-- reach the manager.
--
-- A menu is described through the same calls that Blizzard's menu
-- descriptions take, so that a single generator function can serve both.
-- Calls that have no meaning for these menus do nothing.

TRP3_GamepadMenu = {};

local RowHeight = 20;
local Padding = 10;
local MarkSize = 16;
local MinimumWidth = 120;
local MaximumRows = 20;
local ClickCloseWindow = 0.5;

--
-- Menu descriptions
--

local ElementKind = {
	Root = 1,
	Title = 2,
	Divider = 3,
	Button = 4,
	Checkbox = 5,
	Radio = 6,
};

local ElementDescription = {};

local function IgnoreCall(self)
	return self;
end

local ElementDescriptionMetatable = {
	__index = function(_, key)
		return ElementDescription[key] or IgnoreCall;
	end,
};

-- Every field other than 'data' is assigned a non-nil value, as reading a
-- missing field would otherwise give the do-nothing function above.

local function CreateElementDescription(kind, text, callback, data, isSelected)
	local description = {
		isGamepadMenuElement = true,
		kind = kind,
		text = text or "",
		callback = callback or false,
		data = data,
		isSelected = isSelected or false,
		enabled = true,
		tooltip = false,
		onEnter = false,
		onLeave = false,
		texture = false,
		icon = false,
		color = false,
		elements = {},
		queued = {},
	};

	return setmetatable(description, ElementDescriptionMetatable);
end

function ElementDescription:Insert(description)
	for _, queuedDescription in ipairs(self.queued) do
		table.insert(self.elements, queuedDescription);
	end

	self.queued = {};
	table.insert(self.elements, description);
	return description;
end

function ElementDescription:CreateTitle(text)
	return self:Insert(CreateElementDescription(ElementKind.Title, text));
end

function ElementDescription:CreateDivider()
	return self:Insert(CreateElementDescription(ElementKind.Divider));
end

function ElementDescription:CreateButton(text, callback, data)
	return self:Insert(CreateElementDescription(ElementKind.Button, text, callback, data));
end

function ElementDescription:CreateCheckbox(text, isSelected, setSelected, data)
	return self:Insert(CreateElementDescription(ElementKind.Checkbox, text, setSelected, data, isSelected));
end

function ElementDescription:CreateRadio(text, isSelected, setSelected, data)
	return self:Insert(CreateElementDescription(ElementKind.Radio, text, setSelected, data, isSelected));
end

-- Queued elements are only added if another element follows them.

function ElementDescription:QueueTitle(text)
	table.insert(self.queued, CreateElementDescription(ElementKind.Title, text));
end

function ElementDescription:QueueDivider()
	table.insert(self.queued, CreateElementDescription(ElementKind.Divider));
end

function ElementDescription:GetData()
	return rawget(self, "data");
end

function ElementDescription:SetData(data)
	self.data = data;
end

function ElementDescription:SetEnabled(enabled)
	self.enabled = enabled;
end

function ElementDescription:SetTooltip(tooltipFunc)
	self.tooltip = tooltipFunc or false;
end

function ElementDescription:SetOnEnter(onEnter)
	self.onEnter = onEnter or false;
end

function ElementDescription:SetOnLeave(onLeave)
	self.onLeave = onLeave or false;
end

function ElementDescription:SetTexture(texture)
	self.texture = texture or false;
end

function ElementDescription:SetIcon(icon)
	self.icon = icon or false;
end

function ElementDescription:SetColorSwatch(color)
	self.color = color or false;
end

local function IsElementEnabled(description)
	local enabled = description.enabled;

	if type(enabled) == "function" then
		enabled = enabled(description);
	end

	return enabled and true or false;
end

local function IsElementSelected(description)
	local isSelected = description.isSelected;
	return isSelected and isSelected(description:GetData()) and true or false;
end

local function IsElementSelectable(description)
	local kind = description.kind;
	return kind == ElementKind.Checkbox or kind == ElementKind.Radio;
end

local function HasSubmenu(description)
	return #description.elements > 0;
end

local function CanPickElement(description)
	local kind = description.kind;

	if kind ~= ElementKind.Button and not IsElementSelectable(description) then
		return false;
	else
		return IsElementEnabled(description);
	end
end

--
-- Menu frames
--

local GamepadButton = {
	Up = "PADDUP",
	Down = "PADDDOWN",
	Left = "PADDLEFT",
	Right = "PADDRIGHT",
	Accept = "PAD1",
	Cancel = "PAD2",
};

local levels = {};  -- Frames by menu depth; the first is the root menu.
local menuOwner;
local menuResponseCallback;
local lastClosedOwner;
local lastClosedTime = 0;
local focusDepth = 0;
local focusIndex = 0;

local ShowLevel;

local function HideLevels(depth)
	local tooltipOwner = GameTooltip:GetOwner();

	for i = depth, #levels do
		if tooltipOwner and tooltipOwner:GetParent() == levels[i] then
			GameTooltip:Hide();
		end

		levels[i]:Hide();
	end

	if focusDepth >= depth then
		focusDepth = math.max(depth - 1, 0);
		focusIndex = focusDepth > 0 and levels[focusDepth].openIndex or 0;
	end
end

local function CloseMenu()
	if not menuOwner then
		return;
	end

	local frame = levels[1];

	menuOwner = nil;
	menuResponseCallback = nil;
	frame:UnregisterEvent("GLOBAL_MOUSE_DOWN");
	frame:EnableGamePadButton(false);
	HideLevels(1);
end

local function UpdateRow(row)
	local description = row.description;
	local kind = description.kind;
	local isDivider = (kind == ElementKind.Divider);
	local fontObject;

	if kind == ElementKind.Title then
		fontObject = GameFontNormalSmall;
	elseif IsElementEnabled(description) then
		fontObject = GameFontHighlightSmall;
	else
		fontObject = GameFontDisableSmall;
	end

	row.Text:SetFontObject(fontObject);
	row.Text:SetText(isDivider and "" or description.text);
	row.Divider:SetShown(isDivider);
	row.Check:SetShown(IsElementSelectable(description) and IsElementSelected(description));
	row.Arrow:SetShown(HasSubmenu(description));

	if description.color then
		row.Swatch:SetColorTexture(description.color:GetRGB());
	end

	row.Swatch:SetShown(description.color ~= false);

	if description.icon then
		TRP3_IconUtil.SetTextureToIcon(row.Icon, description.icon);
	elseif description.texture and C_Texture.GetAtlasInfo(description.texture) then
		local useAtlasSize = false;
		row.Icon:SetAtlas(description.texture, useAtlasSize);
	elseif description.texture then
		row.Icon:SetTexture(description.texture);
	end

	row.Icon:SetShown(description.icon ~= false or (description.texture ~= false and description.texture ~= ""));
	row.Icon:SetPoint("RIGHT", HasSubmenu(description) and -MarkSize or 0, 0);
	row:SetEnabled(CanPickElement(description));
end

local function UpdateLevel(frame)
	local elements = frame.description.elements;
	local visibleCount = math.min(#elements, MaximumRows);

	frame.offset = Clamp(frame.offset, 0, #elements - visibleCount);

	for i = 1, visibleCount do
		local row = frame.rows[i];
		local index = frame.offset + i;

		row.description = elements[index];
		row.index = index;
		UpdateRow(row);
		row:SetLocked(frame.depth == focusDepth and index == focusIndex);
		row:Show();
	end

	for i = visibleCount + 1, #frame.rows do
		frame.rows[i]:Hide();
	end

	frame.MoreAbove:SetShown(frame.offset > 0);
	frame.MoreBelow:SetShown(frame.offset + visibleCount < #elements);
end

local function UpdateAllLevels()
	for _, frame in ipairs(levels) do
		if frame:IsShown() then
			UpdateLevel(frame);
		end
	end
end

local function OnRowEnter(row)
	local frame = row:GetParent();
	local description = row.description;

	if HasSubmenu(description) and IsElementEnabled(description) then
		frame.openIndex = row.index;
		ShowLevel(frame.depth + 1, description, row);
	else
		HideLevels(frame.depth + 1);
	end

	if description.tooltip then
		GameTooltip:SetOwner(row, "ANCHOR_RIGHT");
		description.tooltip(GameTooltip, description);
		GameTooltip:Show();
	end

	if description.onEnter then
		description.onEnter(row);
	end
end

local function OnRowLeave(row)
	local description = row.description;

	if GameTooltip:IsOwned(row) then
		GameTooltip:Hide();
	end

	if description.onLeave then
		description.onLeave(row);
	end
end

-- Responses follow those of Blizzard's menus: a checkbox keeps the menu open
-- and anything else closes it, unless the callback asks otherwise.

local function OnRowClick(row, buttonName)
	local description = row.description;
	local callback = description.callback;

	if not CanPickElement(description) or not callback then
		return;
	end

	local shouldStayOpen = (description.kind == ElementKind.Checkbox);
	local responseCallback = menuResponseCallback;
	local menuInputData = { buttonName = buttonName or "LeftButton" };
	local response = callback(description:GetData(), menuInputData);

	if response ~= nil then
		shouldStayOpen = (response == MenuResponse.Refresh or response == MenuResponse.Open);
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

	if responseCallback then
		responseCallback();
	end

	if not menuOwner then
		return;  -- The callback closed the menu, or its owner went away.
	elseif shouldStayOpen then
		UpdateAllLevels();
	else
		OnRowLeave(row);
		CloseMenu();
	end
end

local function SetRowLocked(row, locked)
	if locked then
		row:LockHighlight();
	else
		row:UnlockHighlight();
	end
end

local function CreateRow(frame, index)
	local row = CreateFrame("Button", nil, frame);
	row:SetHeight(RowHeight);
	row:SetPoint("TOPLEFT", Padding, -Padding - ((index - 1) * RowHeight));
	row:SetPoint("RIGHT", -Padding, 0);
	row:SetMotionScriptsWhileDisabled(true);
	row.SetLocked = SetRowLocked;

	local highlight = row:CreateTexture(nil, "HIGHLIGHT");
	highlight:SetAllPoints();
	highlight:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]]);
	highlight:SetBlendMode("ADD");
	row:SetHighlightTexture(highlight);

	row.Check = row:CreateTexture(nil, "ARTWORK");
	row.Check:SetSize(MarkSize, MarkSize);
	row.Check:SetPoint("LEFT");
	row.Check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]]);

	row.Swatch = row:CreateTexture(nil, "ARTWORK");
	row.Swatch:SetSize(MarkSize - 4, MarkSize - 4);
	row.Swatch:SetPoint("LEFT", 2, 0);

	row.Arrow = row:CreateTexture(nil, "ARTWORK");
	row.Arrow:SetSize(MarkSize, MarkSize);
	row.Arrow:SetPoint("RIGHT");
	row.Arrow:SetTexture([[Interface\ChatFrame\ChatFrameExpandArrow]]);

	row.Icon = row:CreateTexture(nil, "ARTWORK");
	row.Icon:SetSize(MarkSize, MarkSize);

	row.Divider = row:CreateTexture(nil, "ARTWORK");
	row.Divider:SetHeight(13);
	row.Divider:SetPoint("LEFT");
	row.Divider:SetPoint("RIGHT");
	row.Divider:SetTexture([[Interface\Common\UI-TooltipDivider-Transparent]]);

	row.Text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
	row.Text:SetPoint("LEFT", MarkSize + 2, 0);
	row.Text:SetPoint("RIGHT", -MarkSize, 0);
	row.Text:SetJustifyH("LEFT");
	row.Text:SetWordWrap(false);

	row:SetScript("OnEnter", OnRowEnter);
	row:SetScript("OnLeave", OnRowLeave);
	row:SetScript("OnClick", OnRowClick);

	return row;
end

local function ScrollLevel(frame, offset)
	local previousOffset = frame.offset;

	frame.offset = offset;
	HideLevels(frame.depth + 1);
	UpdateLevel(frame);

	return frame.offset ~= previousOffset;
end

local function OnLevelMouseWheel(frame, delta)
	ScrollLevel(frame, frame.offset - delta);
end

--
-- Controller navigation
--

local function CanFocusElement(description)
	return CanPickElement(description) or (HasSubmenu(description) and IsElementEnabled(description));
end

local function SetFocus(depth, index)
	local frame = levels[depth];
	local visibleCount = math.min(#frame.description.elements, MaximumRows);
	local offset = frame.offset;

	if index <= offset then
		offset = index - 1;
	elseif index > offset + visibleCount then
		offset = index - visibleCount;
	end

	local previousFrame = levels[focusDepth];
	local previousRow = previousFrame and previousFrame.rows[focusIndex - previousFrame.offset];

	if previousRow and previousRow:IsShown() then
		OnRowLeave(previousRow);
	end

	focusDepth = depth;
	focusIndex = index;
	ScrollLevel(frame, offset);
	UpdateAllLevels();

	local row = frame.rows[index - frame.offset];

	if row then
		OnRowEnter(row);
	end
end

local function MoveFocus(step)
	local frame = levels[focusDepth];

	if not frame or not frame:IsShown() then
		return;
	end

	local elements = frame.description.elements;
	local index = focusIndex;

	if index == 0 and step < 0 then
		index = 1;
	end

	for _ = 1, #elements do
		index = ((index - 1 + step) % #elements) + 1;

		if CanFocusElement(elements[index]) then
			SetFocus(focusDepth, index);
			return;
		end
	end
end

local function FocusLevel(depth)
	focusDepth = depth;
	focusIndex = 0;
	MoveFocus(1);
end

local function OnGamePadButtonDown(_, button)
	local frame = levels[focusDepth];
	local row = frame and frame.rows[focusIndex - frame.offset];
	local submenu = levels[focusDepth + 1];
	local isSubmenuOpen = (row and HasSubmenu(row.description) and submenu and submenu:IsShown());

	if button == GamepadButton.Up then
		MoveFocus(-1);
	elseif button == GamepadButton.Down then
		MoveFocus(1);
	elseif button == GamepadButton.Right or button == GamepadButton.Accept then
		if isSubmenuOpen then
			FocusLevel(focusDepth + 1);
		elseif row and button == GamepadButton.Accept then
			OnRowClick(row);
		end
	elseif button == GamepadButton.Left or button == GamepadButton.Cancel then
		if focusDepth > 1 then
			-- Back to the row that the submenu hangs from.
			local parentDepth = focusDepth - 1;
			local parentIndex = levels[parentDepth].openIndex;

			HideLevels(focusDepth);
			focusDepth = parentDepth;
			focusIndex = parentIndex;
			UpdateAllLevels();
		elseif button == GamepadButton.Cancel then
			CloseMenu();
		end
	end
end

--
-- Root menu behaviors
--

local function OnRootEvent(_, event)
	if event ~= "GLOBAL_MOUSE_DOWN" then
		return;
	end

	for _, frame in ipairs(levels) do
		if frame:IsShown() and frame:IsMouseOver() then
			return;
		end
	end

	-- A click on the region that the menu belongs to closes it; remember
	-- that, so that the same click doesn't then open it again.

	if menuOwner ~= UIParent and menuOwner:IsMouseOver() then
		lastClosedOwner = menuOwner;
		lastClosedTime = GetTime();
	end

	CloseMenu();
end

local function OnRootUpdate()
	-- The menu goes away with the frame that it belongs to.
	if menuOwner and menuOwner ~= UIParent and not menuOwner:IsVisible() then
		CloseMenu();
	end
end

local function GetOrCreateLevel(depth)
	local frame = levels[depth];

	if frame then
		return frame;
	end

	frame = CreateFrame("Frame", nil, UIParent, "TooltipBackdropTemplate");
	frame:SetFrameStrata("FULLSCREEN_DIALOG");
	frame:SetFrameLevel(100 + (depth * 10));
	frame:SetClampedToScreen(true);
	frame:EnableMouse(true);
	frame:EnableMouseWheel(true);
	frame:Hide();
	frame:SetScript("OnMouseWheel", OnLevelMouseWheel);

	frame.depth = depth;
	frame.offset = 0;
	frame.openIndex = 0;
	frame.rows = {};

	for i = 1, MaximumRows do
		frame.rows[i] = CreateRow(frame, i);
	end

	frame.Measure = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall");
	frame.Measure:Hide();

	frame.MoreAbove = frame:CreateTexture(nil, "OVERLAY");
	frame.MoreAbove:SetSize(Padding, Padding);
	frame.MoreAbove:SetPoint("TOP");
	frame.MoreAbove:SetTexture([[Interface\Buttons\Arrow-Up-Up]]);

	frame.MoreBelow = frame:CreateTexture(nil, "OVERLAY");
	frame.MoreBelow:SetSize(Padding, Padding);
	frame.MoreBelow:SetPoint("BOTTOM");
	frame.MoreBelow:SetTexture([[Interface\Buttons\Arrow-Down-Up]]);

	if depth == 1 then
		frame:SetScript("OnEvent", OnRootEvent);
		frame:SetScript("OnUpdate", OnRootUpdate);
		frame:SetScript("OnGamePadButtonDown", OnGamePadButtonDown);
	end

	levels[depth] = frame;
	return frame;
end

-- Shows the elements of a description as one level of the menu. The anchor
-- is the row that a submenu hangs from, an anchor object for the root menu,
-- or nil to place the root menu at the cursor.

function ShowLevel(depth, description, anchor)
	local frame = GetOrCreateLevel(depth);

	if frame:IsShown() and frame.description == description then
		return;
	end

	HideLevels(depth);

	local elements = description.elements;
	local width = MinimumWidth;

	for _, elementDescription in ipairs(elements) do
		frame.Measure:SetText(elementDescription.text);
		width = math.max(width, frame.Measure:GetStringWidth() + (MarkSize * 3) + 2);
	end

	frame.description = description;
	frame.offset = 0;
	frame.openIndex = 0;
	frame:SetSize(width + (Padding * 2), (math.min(#elements, MaximumRows) * RowHeight) + (Padding * 2));
	frame:ClearAllPoints();

	if depth > 1 then
		local hasRoomOnRight = (UIParent:GetRight() - anchor:GetRight()) >= frame:GetWidth();

		if hasRoomOnRight then
			frame:SetPoint("TOPLEFT", anchor, "TOPRIGHT", Padding, Padding);
		else
			frame:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -Padding, Padding);
		end
	elseif anchor then
		local clearAllPoints = true;
		anchor:SetPoint(frame, clearAllPoints);
	else
		local scale = UIParent:GetEffectiveScale();
		local cursorX, cursorY = GetCursorPosition();
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cursorX / scale, cursorY / scale);
	end

	UpdateLevel(frame);
	frame:Show();
end

--
-- Public API
--

--- Returns true if menus should be drawn by our own frames; this is the case
--- only while the game shows its controller interface.
function TRP3_GamepadMenu.IsEnabled()
	if InputUtil and InputUtil.IsGamepadUIEnabled then
		return InputUtil.IsGamepadUIEnabled() == true;
	else
		return false;
	end
end

--- Returns true if the given value is one of our own menu descriptions, as
--- opposed to one of Blizzard's.
function TRP3_GamepadMenu.IsElementDescription(description)
	return type(description) == "table" and rawget(description, "isGamepadMenuElement") == true;
end

function TRP3_GamepadMenu.IsOpen(ownerRegion)
	return menuOwner ~= nil and (ownerRegion == nil or menuOwner == ownerRegion);
end

--- Returns true if a menu belonging to the given region was just closed by
--- a mouse click on that region. The window covers a press and its release.
function TRP3_GamepadMenu.WasJustClosed(ownerRegion)
	return lastClosedOwner == ownerRegion and (GetTime() - lastClosedTime) < ClickCloseWindow;
end

function TRP3_GamepadMenu.Close()
	CloseMenu();
end

--- Opens a menu described by the given generator function.
---
--- The menu is placed at the given anchor (as created by AnchorUtil), or at
--- the cursor if none is given. The optional response callback is invoked
--- after each pick made in the menu.
---
---@param ownerRegion Region?
---@param menuGenerator fun(ownerRegion: Region?, rootDescription: table)
---@param menuAnchor table?
---@param responseCallback fun()?
---@return boolean opened
function TRP3_GamepadMenu.Open(ownerRegion, menuGenerator, menuAnchor, responseCallback)
	CloseMenu();

	local rootDescription = CreateElementDescription(ElementKind.Root);
	menuGenerator(ownerRegion, rootDescription);

	if not HasSubmenu(rootDescription) then
		return false;
	end

	menuOwner = ownerRegion or UIParent;
	menuResponseCallback = responseCallback;
	ShowLevel(1, rootDescription, menuAnchor);
	focusDepth = 1;
	focusIndex = 0;

	local frame = levels[1];
	frame:RegisterEvent("GLOBAL_MOUSE_DOWN");
	frame:EnableGamePadButton(true);

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	return true;
end

local dropdownMenuGenerators = setmetatable({}, { __mode = "k" });

local function OpenDropdownButtonMenu(button)
	if not button:IsEnabled() then
		return;
	elseif TRP3_GamepadMenu.IsOpen(button) or TRP3_GamepadMenu.WasJustClosed(button) then
		-- Clicking the button while its menu is open closes it.
		CloseMenu();
		return;
	end

	local function OnMenuResponse()
		-- The text of the button follows whatever was picked.
		button:GenerateMenu();

		if button.ValidateResetState then
			button:ValidateResetState();
		end
	end

	local menuAnchor = button.menuAnchor or AnchorUtil.CreateAnchor("TOPLEFT", button, "BOTTOMLEFT", 0, 0);
	TRP3_GamepadMenu.Open(button, dropdownMenuGenerators[button], menuAnchor, OnMenuResponse);
end

--- Makes one of our own dropdown buttons (a DropdownButton frame, already
--- given the same generator through its SetupMenu method) open a menu of our
--- own while the controller interface is shown.
---
--- The button opens its menu by calling its own OpenMenu method, which is
--- replaced on that one button; nothing of Blizzard's is changed.
function TRP3_GamepadMenu.RegisterDropdownButton(button, menuGenerator)
	local isRegistered = (dropdownMenuGenerators[button] ~= nil);
	dropdownMenuGenerators[button] = menuGenerator;

	if isRegistered then
		return;
	end

	local openBlizzardMenu = button.OpenMenu;

	button.OpenMenu = function(self)
		if TRP3_GamepadMenu.IsEnabled() then
			OpenDropdownButtonMenu(self);
		else
			openBlizzardMenu(self);
		end
	end;
end
