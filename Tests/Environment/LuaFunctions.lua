-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

function canaccessvalue(_value)
	return true;
end

function canaccessallvalues(...)
	for index = 1, select("#", ...) do
		if not canaccessvalue(select(index, ...)) then
			return false;
		end
	end

	return true;
end

function scrubsecretvalues(...)
	local values = { n = select("#", ...), ... };
	for index = 1, values.n do
		if not canaccessvalue(values[index]) then
			values[index] = nil;
		end
	end
	return unpack(values, 1, values.n);
end

function securecallfunction(callback, ...)
	return callback(...);
end

function string.concat(...)
	return table.concat({ ... }, "", 1, select("#", ...));
end

function string.contains(value, substring)
	return string.find(value, substring, 1, true) ~= nil;
end

function string.join(separator, ...)
	return table.concat({ ... }, separator, 1, select("#", ...));
end

function string.split(delimiters, value, limit)
	limit = limit or math.huge;

	if limit <= 1 then
		return value;
	end

	local parts = {};
	local start = 1;
	local count = 0;

	local escaped = string.gsub(delimiters, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1");
	local pattern = "[" .. escaped .. "]";

	while count < limit - 1 do
		local pos = string.find(value, pattern, start);

		if not pos then
			break;
		end

		count = count + 1;
		parts[count] = string.sub(value, start, pos - 1);
		start = pos + 1;
	end

	count = count + 1;
	parts[count] = string.sub(value, start);

	return unpack(parts);
end

function table.wipe(tbl)
	for k in pairs(tbl) do
		tbl[k] = nil;
	end

	return tbl;
end

function tInvert(values)
	local inverted = {};

	for key, value in pairs(values) do
		inverted[value] = key;
	end

	return inverted;
end

function tContains(values, value)
	for _, candidate in ipairs(values) do
		if candidate == value then
			return true;
		end
	end

	return false;
end

FrameUtil = {};

function FrameUtil.SpecializeFrameWithMixins(object, ...)
	Mixin(object, ...);
	if object.OnLoad then
		object:OnLoad();
	end
end

foreach = table.foreach;
foreachi = table.foreachi;
getn = table.getn;
tinsert = table.insert;
tremove = table.remove;
sort = table.sort;
wipe = table.wipe;

abs = math.abs;
acos = function(x) return math.deg(math.acos(x)); end;
asin = function(x) return math.deg(math.asin(x)); end;
atan = function(x) return math.deg(math.atan(x)); end;
atan2 = function(x, y) return math.deg(math.atan2(x, y)); end;
ceil = math.ceil;
cos = function(x) return math.cos(math.rad(x)); end;
deg = math.deg;
exp = math.exp;
floor = math.floor;
frexp = math.frexp;
ldexp = math.ldexp;
log = math.log;
log10 = math.log10;
max = math.max;
min = math.min;
mod = math.fmod;
PI = math.pi;
rad = math.rad;
random = math.random;
sin = function(x) return math.sin(math.rad(x)); end;
sqrt = math.sqrt;
tan = function(x) return math.tan(math.rad(x)); end;

strbyte = string.byte;
strchar = string.char;
strfind = string.find;
format = string.format;
gmatch = string.gmatch;
gsub = string.gsub;
strlen = string.len;
strlower = string.lower;
strmatch = string.match;
strrep = string.rep;
strrev = string.reverse;
strsub = string.sub;
strtrim = string.trim;
strupper = string.upper;

date = os.date;
