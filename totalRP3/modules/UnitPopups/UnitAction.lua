----------------------------------------------------------------------------------
--- Total RP 3
---
--- UnitPopup Integration
---	---------------------------------------------------------------------------
--- Copyright 2018 Daniel "Meorawr" Yates <me@meorawr.io>
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

-- Grab the module table or initialise it.
TRP3_API.UnitPopups = TRP3_API.UnitPopups or {};
local UnitPopups = TRP3_API.UnitPopups;

--region Lua imports
--endregion

--region WoW imports
--endregion

--region Ellyb imports
--endregion

--- Base class for action handlers on menus. The important method to override
--  is OnTriggered, which is called when the menu item is clicked by users.
-- @class UnitAction
local UnitAction, _private = Ellyb.Class("UnitAction")

--- Initializes the class with the given display text.
-- @param text The text to display on the action.
function UnitAction:initialize(text)
	-- Our private table itself is the actual button definition used by
	-- UnitPopup. This class just wraps it.
	_private[self] = {
		-- Text of the button. Usually contains human-readable content.
		text = text or "",
		-- Color of the text. Optional table of keyed RGB values.
		color = nil,

		-- Whether or not the action in question should be a header.
		isHeader = false,

		-- Icon to display alongside the text. Optional.
		icon = nil,

		-- Texture coordinates used by the icon, if present.
		iconCoordLeft = 0,
		iconCoordRight = 1,
		iconCoordTop = 0,
		iconCoordBottom = 1,
	};
end

--- Called when the action is triggered by user interaction.
-- @param unit The unit ID associated with the menu.
-- @param name The player name of the unit.
-- @param server The name of the realm associated with the unit.
function UnitAction:OnTriggered(unit, name, server)
end

--- Checks if the action should be visible.
-- @param unit The unit ID associated with the menu.
-- @param name The player name of the unit.
-- @param server The name of the realm associated with the unit.
-- @return true if the action should be shown at all.
function UnitAction:IsVisible(unit, name, server)
	return true;
end

--- Returns the text to be displayed by the action.
-- @return The text displayed by this action in menus.
function UnitAction:GetText()
	local private = _private[self];
	return private.text;
end

--- Changes the text to be displayed by the action.
-- @param text The text string to display for this action in menus.
function UnitAction:SetText(text)
	local private = _private[self];
	private.text = text or "";
end

--- Returns the color used to display text.
-- @return The color used for displaying action text, if overridden.
function UnitAction:GetTextColor()
	local private = _private[self];
	return private.color;
end

--- Sets the color used to display text.
-- @param color The color used for displaying action text, if overridden.
function UnitAction:SetTextColor(color)
	local private = _private[self];
	private.color = color;
end

--- Queries if the action is a header entry.
-- @return true if this action is considered to be a header.
function UnitAction:IsHeader()
	local private = _private[self];
	return private.isHeader;
end

--- Toggles the action as being a header entry.
-- @param isHeader true if this should be a header, false if not.
function UnitAction:SetHeader(isHeader)
	local private = _private[self];
	private.isHeader = isHeader;
end

--- Returns the path to the optional icon to display alongside this action.
-- @return The path of the icon, if present.
function UnitAction:GetIcon()
	local private = _private[self];
	return private.icon;
end

--- Changes the path of the optional icon to display alongside this action.
-- @param icon The path of the icon to display, or nil for no icon.
function UnitAction:SetIcon(icon)
	local private = _private[self];
	private.icon = icon;
end

--- Returns the texture coordinates used to display the icon.
-- @return The texture coordinates in left, right, top, and bottom order.
function UnitAction:GetIconCoords()
	local private = _private[self];

	return private.iconCoordLeft,
		private.iconCoordRight,
		private.iconCoordTop,
		private.iconCoordBottom;
end

--- Sets the texture coordinates used to display the icon.
-- @param left The left edge coordinate.
-- @param right The right edge coordinate.
-- @param top The top edge coordinate.
-- @param bottom The bottom edge coordinate.
function UnitAction:SetIconCoords(left, right, top, bottom)
	local private = _private[self];
	private.iconCoordLeft = left;
	private.iconCoordRight = right;
	private.iconCoordTop = top;
	private.iconCoordBottom = bottom;
end

-- Exports...
UnitPopups.UnitAction = UnitAction;
