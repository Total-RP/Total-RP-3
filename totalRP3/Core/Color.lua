-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

local ConvertHSLToHSV;
local ConvertHSLToRGB;
local ConvertHSVToHSL;
local ConvertHSVToRGB;
local ConvertHWBToRGB;
local ConvertRGBToHSL;
local ConvertRGBToHSV;
local ConvertRGBToHWB;

-- Color prototype
--
-- The 'rgba' fields on color objects are considered public and may be freely
-- read by any code. Do not, however, modify them. If modification of a color
-- is required, prefer to instead create a new one from scratch.

local Color = {};

function Color:IsEqualTo(other)
	return self.r == other.r and self.g == other.g and self.b == other.b and self.a == other.a;
end

function Color:GetRGB()
	return self.r, self.g, self.b;
end

function Color:GetRGBA()
	return self.r, self.g, self.b, self.a;
end

function Color:GetRGBAAsBytes()
	return self.r * 255, self.g * 255, self.b * 255, self.a * 255;
end

function Color:GetRGBATable()
	return { r = self.r, g = self.g, b = self.b, a = self.a };
end

function Color:GetRGBAsBytes()
	return self.r * 255, self.g * 255, self.b * 255;
end

function Color:GetRGBTable()
	return { r = self.r, g = self.g, b = self.b };
end

function Color:GetHSL()
	return ConvertRGBToHSL(self:GetRGB());
end

function Color:GetHSLA()
	local h, s, l = self:GetHSL();
	return h, s, l, self.a;
end

function Color:GetHSV()
	return ConvertRGBToHSV(self:GetRGB());
end

function Color:GetHSVA()
	local h, s, v = self:GetHSV();
	return h, s, v, self.a;
end

function Color:GetHWB()
	return ConvertRGBToHWB(self:GetRGB());
end

function Color:GetHWBA()
	local h, w, b = self:GetHWB();
	return h, w, b, self.a;
end

function Color:GenerateHexColor()
	local r, g, b, a = self:GetRGBAAsBytes();
	return string.format("%02x%02x%02x%02x", a, r, g, b);
end

function Color:GenerateHexColorOpaque()
	local r, g, b = self:GetRGBAsBytes();
	return string.format("%02x%02x%02x", r, g, b);
end

function Color:GenerateHexColorMarkup()
	local r, g, b = self:GetRGBAsBytes();
	return string.format("|cff%02x%02x%02x", r, g, b);
end

local function IsShort(c)
	return (math.floor(c * 255) % 17 == 0);
end

function Color:GenerateColorString()
	local r, g, b, a = self:GetRGBA();
	local mult = 255;
	local format;

	if IsShort(r) and IsShort(g) and IsShort(b) and IsShort(a) then
		mult = 15;

		if a ~= 1 then
			format = "#%4$x%1$x%2$x%3$x";
		else
			format = "#%x%x%x";
		end
	elseif a ~= 1 then
		format = "#%4$02x%1$02x%2$02x%3$02x";
	else
		format = "#%02x%02x%02x";
	end

	return string.format(format, r * mult, g * mult, b * mult, a * mult);
end

function Color:WrapTextInColorCode(text)
	local r, g, b = self:GetRGBAsBytes();
	return string.format("|cff%02x%02x%02x%s|r", r, g, b, tostring(text));
end

function Color:__call(text)
	return self:WrapTextInColorCode(text);
end

function Color:__eq(other)
	return self:IsEqualTo(other);
end

function Color:__tostring()
	return string.format("Color <%s>", self:GenerateColorString());
end

-- Color cache
--
-- To reduce some memory churn from color creation the constructor functions
-- acquire colors from a cache keyed by the hexadecimal representation of a
-- 32-bit ARGB color. This also provides a slight CPU usage decrease despite
-- the extra work for making keys, as most of our color creations do end up
-- actually hitting the cache.

local ColorCache = { cache = setmetatable({}, { __mode = "kv" }) };

function ColorCache:Acquire(r, g, b, a)
	local key = string.format("#%02x%02x%02x%02x", a * 255, r * 255, g * 255, b * 255);
	local color = self.cache[key];

	if not color then
		assert(r >= 0 and r <= 1, "invalid color component: r");
		assert(g >= 0 and g <= 1, "invalid color component: g");
		assert(b >= 0 and b <= 1, "invalid color component: b");
		assert(a >= 0 and a <= 1, "invalid color component: a");

		color = TRP3_API.ApplyPrototypeToObject({ r = r, g = g, b = b, a = a }, Color);
		self.cache[key] = color;
	end

	return color;
end

-- Color constructors
--
-- The following utility functions are for creating colors with methods
-- inherited from our prototype.

function TRP3_API.ApplyColorPrototype(color)
	return TRP3_API.ApplyPrototypeToObject(color, Color);
end

function TRP3_API.CreateColor(r, g, b, a)
	return ColorCache:Acquire(r, g, b, a or 1);
end

function TRP3_API.CreateColorFromBytes(r, g, b, a)
	return ColorCache:Acquire(r / 255, g / 255, b / 255, a and (a / 255) or 1);
end

function TRP3_API.CreateColorFromTable(t)
	return ColorCache:Acquire(t.r, t.g, t.b, t.a or 1);
end

function TRP3_API.CreateColorFromHSLA(h, s, l, a)
	local r, g, b = ConvertHSLToRGB(h, s, l);
	return ColorCache:Acquire(r, g, b, a or 1);
end

function TRP3_API.CreateColorFromHSVA(h, s, v, a)
	local r, g, b = ConvertHSVToRGB(h, s, v);
	return ColorCache:Acquire(r, g, b, a or 1);
end

function TRP3_API.CreateColorFromHWBA(h, w, b, a)
	local r, g, b = ConvertHWBToRGB(h, w, b);  -- luacheck: no redefined
	return ColorCache:Acquire(r, g, b, a or 1);
end

function TRP3_API.CreateColorFromName(name)
	local color = TRP3_API.ParseColorFromName(name);

	if not color then
		error("attempted to create a color from an invalid color name");
	end

	return color;
end

function TRP3_API.CreateColorFromHexString(str)
	local color = TRP3_API.ParseColorFromHexString(str);

	if not color then
		error("attempted to create a color from an invalid hexadecimal color string");
	end

	return color;
end

function TRP3_API.CreateColorFromHexMarkup(str)
	local color = TRP3_API.ParseColorFromHexMarkup(str);

	if not color then
		error("attempted to create a color from an invalid color markup string");
	end

	return color;
end

function TRP3_API.CreateColorFromString(str)
	local color = TRP3_API.ParseColorFromName(str) or TRP3_API.ParseColorFromHexString(str) or TRP3_API.ParseColorFromHexMarkup(str);

	if not color then
		error("attempted to create a color from an invalid color string");
	end

	return color;
end

function TRP3_API.GetChatTypeColor(chatType)
	local chatTypeInfo = ChatTypeInfo[chatType];
	return chatTypeInfo and TRP3_API.CreateColorFromTable(chatTypeInfo) or nil;
end

function TRP3_API.GetClassBaseColor(classToken)
	local classColor = RAID_CLASS_COLORS[classToken];
	return classColor and TRP3_API.CreateColorFromTable(classColor) or nil;
end

function TRP3_API.GetClassDisplayColor(classToken)
	local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classToken] or RAID_CLASS_COLORS[classToken];
	return classColor and TRP3_API.CreateColorFromTable(classColor) or nil;
end

function TRP3_API.GenerateBlendedColor(colorA, colorB)
	local r, g, b, a = colorA:GetRGBA();

	if a < 1 then
		local R, G, B = colorB:GetRGB();
		local A = 1 - a;

		r = Saturate((R * A) + (r * a));
		g = Saturate((G * A) + (g * a));
		b = Saturate((B * A) + (b * a));
		a = 1;
	end

	return TRP3_API.CreateColor(r, g, b, a);
end

function TRP3_API.GenerateInterpolatedColor(colorA, colorB, ratio)
	local h1, s1, l1, a1 = colorA:GetHSLA();
	local h2, s2, l2, a2 = colorB:GetHSLA();

	-- If we'd traverse > 180 degrees of hue then go the other way instead.
	if (h2 - h1) > 0.5 then
		h2 = 1 - h2;
	end

	local ht = Lerp(h1, h2, ratio);
	local st = Lerp(s1, s2, ratio);
	local lt = Lerp(l1, l2, ratio);
	local at = Lerp(a1, a2, ratio);

	return TRP3_API.CreateColorFromHSLA(ht, st, lt, at);
end

-- Color parsing utilities
--
-- These utility functions are permitted to return nil values if the supplied
-- values can't represent a color. This differs from the constructor functions
-- which will error in such cases.

function TRP3_API.ParseColorFromName(name)
	local key = string.upper(name);
	return TRP3_API.NamedColors[key];
end

function TRP3_API.ParseColorFromHexString(str)
	if type(str) ~= "string" then
		return nil;
	end

	str = string.gsub(str, "^#", "");

	local i, j = string.find(str, "^%x%x%x%x?%x?%x?%x?%x?");
	local len = i and (j - i) + 1 or 0;

	if len ~= 3 and len ~= 4 and len ~= 6 and len ~= 8 then
		return nil;
	end

	local a, r, g, b;

	if len == 3 then
		r, g, b = string.match(str, "^(%x)(%x)(%x)");
	elseif len == 4 then
		a, r, g, b = string.match(str, "^(%x)(%x)(%x)(%x)");
	elseif len == 6 then
		r, g, b = string.match(str, "^(%x%x)(%x%x)(%x%x)");
	else
		a, r, g, b = string.match(str, "^(%x%x)(%x%x)(%x%x)(%x%x)");
	end

	a = tonumber(a or "ff", 16);
	r = tonumber(r, 16);
	g = tonumber(g, 16);
	b = tonumber(b, 16);

	if len <= 4 then
		-- Shorthand notation; convert from 4-bit space to 8-bit.
		r = (r * 16) + r;
		g = (g * 16) + g;
		b = (b * 16) + b;
	end

	if len == 4 then
		a = (a * 16) + a;
	end

	return TRP3_API.CreateColorFromBytes(r, g, b, a);
end

function TRP3_API.ParseColorFromHexMarkup(str)
	if type(str) ~= "string" then
		return nil;
	end

	local a, r, g, b = string.match(str, "^|c(%x%x)(%x%x)(%x%x)(%x%x)");

	if not a then
		return nil;
	end

	a = tonumber(a, 16);
	r = tonumber(r, 16);
	g = tonumber(g, 16);
	b = tonumber(b, 16);

	return TRP3_API.CreateColorFromBytes(r, g, b, a);
end

function TRP3_API.ParseColorFromString(str)
	return TRP3_API.ParseColorFromName(str) or TRP3_API.ParseColorFromHexString(str) or TRP3_API.ParseColorFromHexMarkup(str);
end

-- Color conversion utilities

function ConvertHSLToHSV(h, s, l)
	local H, S, V;

	H = h;
	V = l + s * math.min(l, 1 - l);
	S = (V == 0 and 0 or (2 * (1 - (l / V))));

	return H, S, V;
end

local function ConvertHSLComponent(n, h, s, l)
	local k = (n + h * 12) % 12;
	local a = s * math.min(l, 1 - l);

	return l - a * math.max(-1, math.min(k - 3, 9 - k, 1));
end

function ConvertHSLToRGB(h, s, l)
	local r = ConvertHSLComponent(0, h, s, l);
	local g = ConvertHSLComponent(8, h, s, l);
	local b = ConvertHSLComponent(4, h, s, l);

	return r, g, b;
end

function ConvertHSVToHSL(h, s, v)
	local H, S, L;

	H = h;
	L = v * (1 - (s / 2));
	S = ((L == 0 or L == 1) and 0 or ((v - L) / math.min(L, 1 - L)));

	return H, S, L;
end

function ConvertHSVToRGB(h, s, v)
	return ConvertHSLToRGB(ConvertHSVToHSL(h, s, v));
end

function ConvertHWBToRGB(h, w, b)
	if w + b >= 1 then
		local g = w / (w + b);
		return g, g, g;
	else
		local R, G, B = ConvertHSLToRGB(h, 1, 0.5);
		R = (R * (1 - w - b)) + w;
		G = (G * (1 - w - b)) + w;
		B = (B * (1 - w - b)) + w;
		return R, G, B;
	end
end

function ConvertRGBToHSL(r, g, b)
	local cmax = math.max(r, g, b);
	local cmin = math.min(r, g, b);
	local c = cmax - cmin;

	local h = 0;
	local s = 0;
	local l = (cmin + cmax) / 2;

	if c ~= 0 then
		s = (l == 0 or l == 1) and 0 or ((cmax - l) / math.min(l, 1 - l));

		if cmax == r then
			h = (g - b) / c + (g < b and 6 or 0);
		elseif cmax == g then
			h = (b - r) / c + 2;
		else
			h = (r - g) / c + 4;
		end

		h = h / 6;
	end

	return h, s, l;
end

function ConvertRGBToHSV(r, g, b)
	return ConvertHSLToHSV(ConvertRGBToHSL(r, g, b));
end

function ConvertRGBToHWB(r, g, b)
	local h = ConvertRGBToHSL(r, g, b);
	local w = math.min(r, g, b);
	local b = 1 - math.max(r, g, b);  -- luacheck: no redefined

	return h, w, b;
end

-- Contrast adjustment utilities
--
-- The following functions implement our "Increase color contrast" setting
-- based off the APCA-W3 algorithms for lightness contrast and screen luminance.
--
-- Note: Where possible prefer to instead use font outlines instead of contrast
--       adjustments. It's basically impossible to know ahead of time what
--       background you're visually adjusting against - and our assumption of
--       black is almost always wrong. Outlines are consistent and are far more
--       correct, and don't effectively destroy the custom color.

TRP3_API.ColorContrastOption =
{
	None = 1,
	VeryLow = 2,
	Low = 3,         -- Recommended default; won't touch most colors.
	MediumLow = 4,
	MediumHigh = 5,
	High = 6,
	VeryHigh = 7,

	-- Aliases and other magical values.
	Default = 3,
	UseConfiguredLevel = nil,
};

local ColorContrastLevels =
{
	[TRP3_API.ColorContrastOption.VeryLow] = 15,
	[TRP3_API.ColorContrastOption.Low] = 30,
	[TRP3_API.ColorContrastOption.MediumLow] = 45,
	[TRP3_API.ColorContrastOption.MediumHigh] = 60,
	[TRP3_API.ColorContrastOption.High] = 75,
	[TRP3_API.ColorContrastOption.VeryHigh] = 90,
};

local function CalculateLuminance(r, g, b)
	-- Estimated Screen Luminance (Ys)
	-- <https://github.com/Myndex/SAPC-APCA/blob/master/documentation/regardingexponents.md>

	local EXP = 2.4;
	local RCO = 0.2126729;
	local GCO = 0.7151522;
	local BCO = 0.0721750;

	return ((r ^ EXP) * RCO) + ((g ^ EXP) * GCO) + ((b ^ EXP) * BCO);
end

local function CalculateLightnessContrast(foregroundYs, backgroundYs)
	-- APCA-W3 Algorithm
	--
	-- Returns a lightness constrast (Lc) value within [-108, 106]. Positive
	-- values indicate dark text on a light background.
	--
	-- <https://github.com/Myndex/SAPC-APCA/blob/master/documentation/APCA-W3-LaTeX.md>

	local BLACK_THRESHOLD = 0.022;
	local BLACK_CLAMP = 1.414;
	local DELTA_YS_MIN = 0.0005;

	if foregroundYs <= BLACK_THRESHOLD then
		foregroundYs = foregroundYs + ((BLACK_THRESHOLD - foregroundYs) ^ BLACK_CLAMP);
	end

	if backgroundYs <= BLACK_THRESHOLD then
		backgroundYs = backgroundYs + ((BLACK_THRESHOLD - backgroundYs) ^ BLACK_CLAMP);
	end

	if math.abs(backgroundYs - foregroundYs) < DELTA_YS_MIN then
		return 0;
	end

	local BG_BOW = 0.56;
	local BG_WOB = 0.65;
	local FG_BOW = 0.57;
	local FG_WOB = 0.62;
	local LOW_CLIP = 0.1;
	local LOW_OFFSET = 0.027;
	local SCALE = 1.14;

	local Lc;

	if backgroundYs > foregroundYs then
		Lc = ((backgroundYs ^ BG_BOW) - (foregroundYs ^ FG_BOW)) * SCALE;
		Lc = (Lc < LOW_CLIP) and 0 or (Lc - LOW_OFFSET);
	else
		Lc = ((backgroundYs ^ BG_WOB) - (foregroundYs ^ FG_WOB)) * SCALE;
		Lc = (Lc > LOW_CLIP) and 0 or (Lc + LOW_OFFSET);
	end

	return Lc * 100;
end

function TRP3_API.GenerateContrastingColor(backgroundColor)
	local Ys = CalculateLuminance(backgroundColor:GetRGB());

	if Ys >= 0.38 then
		return TRP3_API.CreateColor(0, 0, 0);
	else
		return TRP3_API.CreateColor(1, 1, 1);
	end
end

local ReadableColorCache = (function()
	local level3 = { __mode = "kv" };
	local level2 = { __index = function(self, k) local v = setmetatable({}, level3); self[k] = v; return v; end, __mode = "kv" };
	local level1 = { __index = function(self, k) local v = setmetatable({}, level2); self[k] = v; return v; end, __mode = "kv" };

	return { cache = setmetatable({}, level1); };
end)();

function ReadableColorCache:Get(targetContrast, backgroundColor, foregroundColor)
	return self.cache[targetContrast][backgroundColor][foregroundColor];
end

function ReadableColorCache:Set(targetContrast, backgroundColor, foregroundColor, readableColor)
	self.cache[targetContrast][backgroundColor][foregroundColor] = readableColor;
end

local function ProcessTargetContrastOption(targetContrast)
	if targetContrast == TRP3_API.ColorContrastOption.UseConfiguredLevel then
		local targetLevel = TRP3_API.configuration.getValue("color_contrast_level");
		targetContrast = ColorContrastLevels[targetLevel];
	end

	return targetContrast or 0;
end

TRP3_ReadabilityOptions = {
	TextOnBlackBackground = { backgroundColor = TRP3_API.CreateColor(0, 0, 0), targetContrast = TRP3_API.ColorContrastOption.UseConfiguredLevel },
	TextOnWhiteBackground = { backgroundColor = TRP3_API.CreateColor(1, 1, 1), targetContrast = TRP3_API.ColorContrastOption.UseConfiguredLevel },
};

function TRP3_API.GenerateReadableColor(foregroundColor, options)
	local targetContrast = ProcessTargetContrastOption(options.targetContrast);

	if targetContrast == 0 then
		return foregroundColor;
	end

	local backgroundColor = options.backgroundColor;
	local readableColor = ReadableColorCache:Get(targetContrast, backgroundColor, foregroundColor);

	if readableColor then
		return readableColor;
	end

	local BgR, BgG, BgB = backgroundColor:GetRGB();
	local FgR, FgG, FgB = TRP3_API.GenerateBlendedColor(foregroundColor, backgroundColor):GetRGB();
	local FgH, FgS, FgL = ConvertRGBToHSL(FgR, FgG, FgB);

	local BgYs = CalculateLuminance(BgR, BgG, BgB);
	local FgYs = CalculateLuminance(FgR, FgG, FgB);
	local FgLc = CalculateLightnessContrast(FgYs, BgYs);

	if math.abs(FgLc) < targetContrast then
		local MiCd = math.huge;
		local L = 0;
		local R = 100;

		while L <= R do
			local M = math.floor((L + R) / 2);
			local StL = M / 100;
			local StYs = CalculateLuminance(ConvertHSLToRGB(FgH, FgS, StL));
			local StLc = CalculateLightnessContrast(StYs, BgYs);
			local StCd = math.abs(StLc) - targetContrast;

			if math.abs(StLc) < targetContrast then
				L = M + 1;    -- Lightness contrast too low; check upper.
			elseif StCd >= MiCd then
				R = M - 1;    -- Contrast met but is too high; check lower.
			else
				MiCd = StCd;  -- Contrast met and is the closest match so far.
				FgL = StL;
				R = M - 1;
			end
		end

		FgR, FgG, FgB = ConvertHSLToRGB(FgH, FgS, FgL);
		FgYs = CalculateLuminance(FgR, FgG, FgB);
		FgLc = CalculateLightnessContrast(FgYs, BgYs);
	end

	-- If the required contrast still hasn't been met use an appropriate
	-- contrasting color (pure white or black) based on background luminance.

	if math.abs(FgLc) < targetContrast then
		FgL = (BgYs >= 0.38 and 0 or 1);
	end

	readableColor = TRP3_API.CreateColorFromHSLA(FgH, FgS, FgL);
	ReadableColorCache:Set(targetContrast, backgroundColor, foregroundColor, readableColor);
	return readableColor;
end

function TRP3_API.IsColorReadable(foregroundColor, options)
	local targetContrast = ProcessTargetContrastOption(options.targetContrast);

	if targetContrast == 0 then
		return true;
	end

	local backgroundColor = options.backgroundColor;
	local BgYs = CalculateLuminance(backgroundColor:GetRGB());
	local FgYs = CalculateLuminance(TRP3_API.GenerateBlendedColor(foregroundColor, backgroundColor):GetRGB());
	local FgLc = CalculateLightnessContrast(FgYs, BgYs);

	return math.abs(FgLc) >= targetContrast;
end
