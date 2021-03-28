---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.ColorManager then
	return
end

--- Used for Color related operations and managing a palette of predefined Colors
local ColorManager = {};
Ellyb.ColorManager = ColorManager;

---Converts color bytes into bits, from a 0-255 range to 0-1 range.
---@param red number Between 0 and 255
---@param green number Between 0 and 255
---@param blue number Between 0 and 255
---@param alpha number Between 0 and 255
---@return number, number, number, number
---@overload fun(red:number, green:number, blue:number):number, number, number, number
function ColorManager.convertColorBytesToBits(red, green, blue, alpha)
	if alpha == nil then
		alpha = 255;
	end

	return red / 255, green / 255, blue / 255, alpha / 255;
end

--- Extracts RGB values (255 based) from an hexadecimal code
---@param hexadecimalCode string An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
---@return number, number, number red, green, blue
function ColorManager.hexaToNumber(hexadecimalCode)
	local red, green, blue, alpha;

	-- We make sure we remove possible prefixes
	hexadecimalCode = hexadecimalCode:gsub("#", "");
	hexadecimalCode = hexadecimalCode:gsub("|c", "");

	local hexadecimalCodeLength = hexadecimalCode:len();

	if hexadecimalCodeLength == 3 then
		-- #FFF
		local r = hexadecimalCode:sub(1, 1);
		local g = hexadecimalCode:sub(2, 2);
		local b = hexadecimalCode:sub(3, 3);
		red = tonumber(r .. r, 16)
		green = tonumber(g .. g, 16)
		blue = tonumber(b .. b, 16)
	elseif hexadecimalCodeLength == 6 then
		-- #FAFAFA
		red = tonumber(hexadecimalCode:sub(1, 2), 16)
		green = tonumber(hexadecimalCode:sub(3, 4), 16)
		blue = tonumber(hexadecimalCode:sub(5, 6), 16)
	elseif hexadecimalCodeLength == 8 then
		-- #ffbababa
		alpha = tonumber(hexadecimalCode:sub(1, 2), 16)
		red = tonumber(hexadecimalCode:sub(3, 4), 16)
		green = tonumber(hexadecimalCode:sub(5, 6), 16)
		blue = tonumber(hexadecimalCode:sub(7, 8), 16)
	end

	return ColorManager.convertColorBytesToBits(red, green, blue, alpha);
end

--- Get the associated Color for the given class.
--- This function always creates a new Color that can be mutated (unlike the Color constants)
--- It will fetch the color from the RAID_CLASS_COLORS global table and will reflect any changes made to the table.
---@param class string A valid class ("HUNTER", "DEATHKNIGHT")
---@return Ellyb_Color color The Color corresponding to the class
function ColorManager.getClassColor(class)
	if RAID_CLASS_COLORS[class] then
		return Ellyb.Color:new(RAID_CLASS_COLORS[class]);
	end
end

--- Get the chat color associated to a specified channel in the settings
--- It will fetch the color from the ChatTypeInfo global table and will reflect any changes made to the table.
---@param channel string A chat channel ("WHISPER", "YELL", etc.)
---@return Ellyb_Color chatColor
function ColorManager.getChatColorForChannel(channel)
	assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel);
	return Ellyb.Color:new(ChatTypeInfo[channel]);
end

--- Compares two colors based on their HSL values (first comparing H, then comparing S, then comparing L)
---@param color1 Ellyb_Color @ A color
---@param color2 Ellyb_Color @ The color to compare
---@return boolean isLesser @ true if color1 is "lesser" than color2
function ColorManager.compareHSL(color1, color2)
	local h1, s1, l1 = color1:GetHSL();
	local h2, s2, l2 = color2:GetHSL();

	if (h1 == h2) then
		if (s1 == s2) then
			return (l1 < l2)
		end
		return (s1 < s2)
	end
	return (h1 < h2)
end

---
--- Function to test if a color is correctly readable on a dark background.
--- We will calculate the luminance of the text color
--- using known values that take into account how the human eye perceive color
--- and then compute the contrast ratio.
--- The contrast ratio should be higher than 50%.
--- @external [](http://www.whydomath.org/node/wavlets/imagebasics.html)
---
--- @param color Ellyb_Color The text color to test
--- @return boolean True if the text will be readable
function ColorManager.isTextColorReadableOnADarkBackground(color)
	return ((
		0.299 * color:GetRed() +
		0.587 * color:GetGreen() +
		0.114 * color:GetBlue()
	)) >= 0.5;
end

-- We create a bunch of common Color constants to be quickly available everywhere
-- The Colors are frozen so they cannot be altered

-- Common colors
ColorManager.RED = Ellyb.Color:new(1, 0, 0):Freeze();
ColorManager.ORANGE = Ellyb.Color:new(255, 153, 0):Freeze();
ColorManager.YELLOW = Ellyb.Color:new(1, 0.82, 0):Freeze();
ColorManager.GREEN = Ellyb.Color:new(0, 1, 0):Freeze();
ColorManager.CYAN = Ellyb.Color:new(0, 1, 1):Freeze();
ColorManager.BLUE = Ellyb.Color:new(0, 0, 1):Freeze();
ColorManager.PURPLE = Ellyb.Color:new(0.5, 0, 1):Freeze();
ColorManager.PINK = Ellyb.Color:new(1, 0, 1):Freeze();
ColorManager.WHITE = Ellyb.Color:new(1, 1, 1):Freeze();
ColorManager.GREY = Ellyb.Color:new("#CCC"):Freeze();
ColorManager.BLACK = Ellyb.Color:new(0, 0, 0):Freeze();

-- Classes colors
ColorManager.HUNTER = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.HUNTER]):Freeze();
ColorManager.WARLOCK = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.WARLOCK]):Freeze();
ColorManager.PRIEST = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.PRIEST]):Freeze();
ColorManager.PALADIN = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.PALADIN]):Freeze();
ColorManager.MAGE = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.MAGE]):Freeze();
ColorManager.ROGUE = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.ROGUE]):Freeze();
ColorManager.DRUID = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.DRUID]):Freeze();
ColorManager.SHAMAN = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.SHAMAN]):Freeze();
ColorManager.WARRIOR = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.WARRIOR]):Freeze();
ColorManager.DEATHKNIGHT = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.DEATHKNIGHT]):Freeze();
ColorManager.MONK = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.MONK]):Freeze();
ColorManager.DEMONHUNTER = Ellyb.Color:new(RAID_CLASS_COLORS[Ellyb.Enum.CLASSES.DEMONHUNTER]):Freeze();

-- Brand colors
ColorManager.TWITTER = Ellyb.Color:new("#1da1f2"):Freeze();
ColorManager.BATTLE_NET = Ellyb.Color:new(FRIENDS_BNET_NAME_COLOR):Freeze();

-- Item colors
-- ITEM QUALITY
-- BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Common or Enum.ItemQuality.Standard] is actually the POOR (grey) color.
-- There is no common quality color in BAG_ITEM_QUALITY_COLORS. Bravo Blizzard 👏
ColorManager.ITEM_POOR = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Common or Enum.ItemQuality.Standard]):Freeze();
ColorManager.ITEM_COMMON = Ellyb.Color:new(0.95, 0.95, 0.95):Freeze(); -- Common quality is a slightly faded white
ColorManager.ITEM_UNCOMMON = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Uncommon or Enum.ItemQuality.Good]):Freeze();
ColorManager.ITEM_RARE = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Rare or Enum.ItemQuality.Superior]):Freeze();
ColorManager.ITEM_EPIC = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Epic]):Freeze();
ColorManager.ITEM_LEGENDARY = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Legendary]):Freeze();
ColorManager.ITEM_ARTIFACT = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Artifact]):Freeze();
ColorManager.ITEM_HEIRLOOM = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.Heirloom]):Freeze();
ColorManager.ITEM_WOW_TOKEN = Ellyb.Color:new(BAG_ITEM_QUALITY_COLORS[Enum.ItemQuality.WoWToken]):Freeze();

-- FACTIONS
ColorManager.ALLIANCE = Ellyb.Color:new(PLAYER_FACTION_COLORS[1]):Freeze();
ColorManager.HORDE = Ellyb.Color:new(PLAYER_FACTION_COLORS[0]):Freeze(); -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

-- POWERBAR COLORS
ColorManager.POWER_MANA = Ellyb.Color:new(PowerBarColor["MANA"]):Freeze();
ColorManager.POWER_RAGE = Ellyb.Color:new(PowerBarColor["RAGE"]):Freeze();
ColorManager.POWER_FOCUS = Ellyb.Color:new(PowerBarColor["FOCUS"]):Freeze();
ColorManager.POWER_ENERGY = Ellyb.Color:new(PowerBarColor["ENERGY"]):Freeze();
ColorManager.POWER_COMBO_POINTS = Ellyb.Color:new(PowerBarColor["COMBO_POINTS"]):Freeze();
ColorManager.POWER_RUNES = Ellyb.Color:new(PowerBarColor["RUNES"]):Freeze();
ColorManager.POWER_RUNIC_POWER = Ellyb.Color:new(PowerBarColor["RUNIC_POWER"]):Freeze();
ColorManager.POWER_SOUL_SHARDS = Ellyb.Color:new(PowerBarColor["SOUL_SHARDS"]):Freeze();
ColorManager.POWER_LUNAR_POWER = Ellyb.Color:new(PowerBarColor["LUNAR_POWER"]):Freeze();
ColorManager.POWER_HOLY_POWER = Ellyb.Color:new(PowerBarColor["HOLY_POWER"]):Freeze();
ColorManager.POWER_MAELSTROM = Ellyb.Color:new(PowerBarColor["MAELSTROM"]):Freeze();
ColorManager.POWER_INSANITY = Ellyb.Color:new(PowerBarColor["INSANITY"]):Freeze();
ColorManager.POWER_CHI = Ellyb.Color:new(PowerBarColor["CHI"]):Freeze();
ColorManager.POWER_ARCANE_CHARGES = Ellyb.Color:new(PowerBarColor["ARCANE_CHARGES"]):Freeze();
ColorManager.POWER_FURY = Ellyb.Color:new(PowerBarColor["FURY"]):Freeze();
ColorManager.POWER_PAIN = Ellyb.Color:new(PowerBarColor["PAIN"]):Freeze();
ColorManager.POWER_AMMOSLOT = Ellyb.Color:new(PowerBarColor["AMMOSLOT"]):Freeze();
ColorManager.POWER_FUEL = Ellyb.Color:new(PowerBarColor["FUEL"]):Freeze();

-- OTHER GAME STUFF
ColorManager.CRAFTING_REAGENT = Ellyb.Color:new("#66bbff"):Freeze();

ColorManager.LINKS = {
	achievement = Ellyb.Color:new("#ffff00"):Freeze(),
	talent = Ellyb.Color:new("#4e96f7"):Freeze(),
	trade = Ellyb.Color:new("#ffd000"):Freeze(),
	enchant = Ellyb.Color:new("#ffd000"):Freeze(),
	instancelock = Ellyb.Color:new("#ff8000"):Freeze(),
	journal = Ellyb.Color:new("#66bbff"):Freeze(),
	battlePetAbil = Ellyb.Color:new("#4e96f7"):Freeze(),
	battlepet = Ellyb.Color:new("#ffd200"):Freeze(),
	garrmission = Ellyb.Color:new("#ffff00"):Freeze(),
	transmogillusion = Ellyb.Color:new("#ff80ff"):Freeze(),
	transmogappearance = Ellyb.Color:new("#ff80ff"):Freeze(),
	transmogset = Ellyb.Color:new("#ff80ff"):Freeze(),
}
