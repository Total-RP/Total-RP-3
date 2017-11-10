----------------------------------------------------------------------------------
--- Total RP 3
--- Colors
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@class TRP3_Colors
--- # Total RP 3 Colors
---
--- Custom Colors API, piggy backing on WoW's ColorMixin
--- @see ColorMixin
local Colors = {};
TRP3_API.Colors = Colors;

--- WoW imports
local CreateFromMixins = CreateFromMixins;
local ColorMixin = ColorMixin;
local strlength = string.len;
local tonumber = tonumber;

--- Total RP 3 imports
local Debug = TRP3_API.Debug;

---@class TRP3_ColorMixin : ColorMixin
local TRP3_ColorMixin = {};

---Convert color bytes into bits, from a 0-255 range to 0-1 range.
---@param red number @ Between 0 and 255
---@param green number @ Between 0 and 255
---@param blue number @ Between 0 and 255
---@param optional alpha number @ Between 0 and 255
---@return number, number, number, number
local function convertColorBytesToBits(red, green, blue, alpha)

	Debug.assertNotNil(red, "red");
	Debug.assertNotNil(green, "green");
	Debug.assertNotNil(blue, "blue");

	if alpha == nil then
		alpha = 255;
	end

	return red / 255, green / 255, blue / 255, alpha / 255;
end

---CreateColor
---@param red number @ Value of the red channel
---@param green number @ Value of the green channel
---@param blue number @ Value of the blue channel
---@param optional alpha number @ Value of the alpha channel (default 1)
---@return TRP3_ColorMixin
function Colors.CreateColor(red, green, blue, alpha)

	Debug.assertType(red, "red", "number");
	Debug.assertType(green, "green", "number");
	Debug.assertType(blue, "blue", "number");

	-- Check if we were given numbers based on a 0 to 255 scale
	if red > 1 or green > 1 or blue > 1 or alpha > 1 then
		-- If that's the case, we will convert the numbers into the 0 to 1 scale
		red, green, blue, alpha = convertColorBytesToBits(red, green, blue, alpha);
	end

	-- Alpha channel is optional and default to 1 (full opacity)
	if alpha == nil then
		alpha = 1;
	end

	---@type TRP3_ColorMixin
	local color = CreateFromMixins(ColorMixin, TRP3_ColorMixin);
	color:OnLoad(red, green, blue, alpha);
	return color;
end

---CreateColorFromTable
---@param table table @ A color table with the r, g, b, a fields.
---@return TRP3_ColorMixin
function Colors.CreateColorFromTable(table)
	return Colors.CreateColor(table.r, table.g, table.b, table.a);
end

--- Creates a new TRP3_ColorMixin using an hexadecimal code.
---
--- _Note: This has lesser performances than `Colors.CreateColor(red, green, blue, alpha)` and should only be used if necessary. `Colors.CreateColor(red, green, blue, alpha)` should be preferred when possible._
---
---@param hexadecimalCode string @ An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`)
---@return TRP3_ColorMixin
function Colors.CreateColorFromHexadecimalCode(hexadecimalCode)
	Debug.assertType(hexadecimalCode, "hexadecimalCode", "string");

	local red, green, blue, alpha = 1, 1, 1, 1;

	hexadecimalCode = hexadecimalCode:gsub("#", "");

	local hexadecimalCodeLength = strlength(hexadecimalCode);
	if hexadecimalCodeLength == 3 then
		local r = hexadecimalCode:sub(1, 1);
		local g = hexadecimalCode:sub(2, 2);
		local b = hexadecimalCode:sub(3, 3);
		red = tonumber(r .. r, 16)
		green = tonumber(g .. g, 16)
		blue = tonumber(b .. b, 16)
	elseif hexadecimalCodeLength == 6 then
		red = tonumber(hexadecimalCode:sub(1, 2), 16)
		green = tonumber(hexadecimalCode:sub(3, 4), 16)
		blue = tonumber(hexadecimalCode:sub(5, 6), 16)
	elseif hexadecimalCodeLength == 8 then
		alpha = tonumber(hexadecimalCode:sub(1, 2), 16)
		red = tonumber(hexadecimalCode:sub(3, 4), 16)
		green = tonumber(hexadecimalCode:sub(5, 6), 16)
		blue = tonumber(hexadecimalCode:sub(7, 8), 16)
	end

	return Colors.CreateColor(red, green, blue, alpha);
end

Colors.COLORS = {
	ORANGE = Colors.CreateColor(255, 153, 0),
	WHITE = Colors.CreateColor(1, 1, 1),
	YELLOW = Colors.CreateColor(1, 1, 0),

	HUNTER = Colors.CreateColorFromTable(RAID_CLASS_COLORS.HUNTER),
	WARLOCK = Colors.CreateColorFromTable(RAID_CLASS_COLORS.WARLOCK),
	PRIEST = Colors.CreateColorFromTable(RAID_CLASS_COLORS.PRIEST),
	PALADIN = Colors.CreateColorFromTable(RAID_CLASS_COLORS.PALADIN),
	MAGE = Colors.CreateColorFromTable(RAID_CLASS_COLORS.MAGE),
	ROGUE = Colors.CreateColorFromTable(RAID_CLASS_COLORS.ROGUE),
	DRUID = Colors.CreateColorFromTable(RAID_CLASS_COLORS.DRUID),
	SHAMAN = Colors.CreateColorFromTable(RAID_CLASS_COLORS.SHAMAN),
	WARRIOR = Colors.CreateColorFromTable(RAID_CLASS_COLORS.WARRIOR),
	DEATHKNIGHT = Colors.CreateColorFromTable(RAID_CLASS_COLORS.DEATHKNIGHT),
	MONK = Colors.CreateColorFromTable(RAID_CLASS_COLORS.MONK),
	DEMONHUNTER = Colors.CreateColorFromTable(RAID_CLASS_COLORS.DEMONHUNTER),
}