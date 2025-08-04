-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Chomp = LibStub:GetLibrary("Chomp");
local LibDeflate = LibStub:GetLibrary("LibDeflate");

TRP3_EncodingUtil = {};

---@param data string
---@return string
function TRP3_EncodingUtil.CompressString(data)
	if C_EncodingUtil and C_EncodingUtil.CompressString then
		return C_EncodingUtil.CompressString(data);
	else
		return assert(LibDeflate:CompressDeflate(data));
	end
end

---@param data string
---@return string
function TRP3_EncodingUtil.DecompressString(data)
	if C_EncodingUtil and C_EncodingUtil.DecompressString then
		return C_EncodingUtil.DecompressString(data);
	else
		return assert(LibDeflate:DecompressDeflate(data));
	end
end

-- The following functions encode and decode data suitable for transmission
-- over addon chat channels, which disallow null bytes. The format used is
-- compatible with LibDeflate's EncodeForWoWAddonChannel implementation.

local BINARY_ENCODE_TABLE = { ["\000"] = "\001\002", ["\001"] = "\001\003" };
local BINARY_DECODE_TABLE = { ["\001\002"] = "\000", ["\001\003"] = "\001" };

---@param data string
function TRP3_EncodingUtil.EncodeBinary(data)
	return (string.gsub(data, "[%z\001]", BINARY_ENCODE_TABLE));
end

---@param data string
function TRP3_EncodingUtil.DecodeBinary(data)
	return (string.gsub(data, "\001[\002\003]", BINARY_DECODE_TABLE));
end

---@enum TRP3_CommunicationsPrefix
TRP3_CommunicationsPrefix = {
	V3 = "TRP3.3",
	V4 = "TRP3.4",
};

---@param data boolean|number|string|table|nil
---@param prefix TRP3_CommunicationsPrefix
function TRP3_EncodingUtil.EncodeLoggedAddOnMessage(data, prefix)
	if prefix == TRP3_CommunicationsPrefix.V3 then
		return Chomp.Serialize(data);
	else
		return TRP3_EncodingUtil.SerializeLogged(data);
	end
end

---@param data string
---@param prefix TRP3_CommunicationsPrefix
function TRP3_EncodingUtil.DecodeLoggedAddOnMessage(data, prefix)
	if prefix == TRP3_CommunicationsPrefix.V3 then
		return Chomp.Deserialize(data);
	else
		return TRP3_EncodingUtil.DeserializeLogged(data);
	end
end

---@param data boolean|number|string|table|nil
---@param prefix TRP3_CommunicationsPrefix
---@return boolean|number|string|table|nil
function TRP3_EncodingUtil.EncodeBinaryAddOnMessage(data, prefix)
	if prefix == TRP3_CommunicationsPrefix.V3 then
		data = Chomp.Serialize(data);
	else
		data = C_EncodingUtil.SerializeCBOR(data);
	end

	data = TRP3_EncodingUtil.CompressString(data);

	if prefix == TRP3_CommunicationsPrefix.V3 then
		data = LibDeflate:EncodeForWoWChatChannel(data);
	else
		data = TRP3_EncodingUtil.EncodeBinary(data);
	end

	return data;
end

---@param data string
---@param prefix TRP3_CommunicationsPrefix
---@return boolean|number|string|table|nil
function TRP3_EncodingUtil.DecodeBinaryAddOnMessage(data, prefix)
	if prefix == TRP3_CommunicationsPrefix.V3 then
		data = assert(LibDeflate:DecodeForWoWChatChannel(data));
	else
		data = TRP3_EncodingUtil.DecodeBinary(data);
	end

	data = TRP3_EncodingUtil.DecompressString(data);

	if prefix == TRP3_CommunicationsPrefix.V3 then
		data = Chomp.Deserialize(data);
	else
		data = C_EncodingUtil.DeserializeCBOR(data);
	end

	return data;
end

--
-- Logged Data Serialization Utilities
--

local LOGGED_STRING_ENCODE_PATTERN = '[%z\r\n\\"]';
local LOGGED_STRING_ENCODE_TABLE = { ["\000"] = "\\z", ["\r"] = "", ["\n"] = "\\n", ["\\"] = "\\\\", ['"'] = "\\q" };
local LOGGED_STRING_DECODE_PATTERN = "\\[qnz\\]";
local LOGGED_STRING_DECODE_TABLE = { ["\\z"] = "\0", ["\\n"] = "\n", ["\\\\"] = "\\", ["\\q"] = '"' };

local LoggedSerializer = {};

---@param _nil nil
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeNil(_nil, output)
	output:Append("nil");
end

---@param bool boolean
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeBoolean(bool, output)
	output:Append(bool and "true" or "false");
end

---@param num number
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeNumber(num, output)
	-- Format to 5 decimal places and strip trailing zeroes for floating point numbers.
	output:Append((string.format("%.5f", num):match("^(.-)%.?0*$")));
end

---@param str string
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeString(str, output)
	output:Append('"');
	output:Append((string.gsub(str, LOGGED_STRING_ENCODE_PATTERN, LOGGED_STRING_ENCODE_TABLE)));
	output:Append('"');
end

---@param str string
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeStringAsKey(str, output)
	if string.find(str, "^[a-zA-Z_-][a-zA-Z0-9_-]*$") then
		output:Append(":" .. str);
	else
		LoggedSerializer.SerializeString(str, output);
	end
end

---@param num integer
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeNumberAsKey(num, output)
	if num == math.floor(num) then
		output:Append(tostring(num));
	else
		error("attempted to serialize a non-integral numeric key");
	end
end

---@param key string|number
---@param output TRP3.StringBuilder
function LoggedSerializer.SerializeKey(key, output)
	local keyType = type(key);

	if keyType == "string" then
		LoggedSerializer.SerializeStringAsKey(key, output);
	elseif keyType == "number" then
		LoggedSerializer.SerializeNumberAsKey(key, output);
	else
		error(string.format("attempted to serialize a %s key", keyType));
	end
end

---@param tbl table
---@param size integer
---@param output TRP3.StringBuilder
---@param objects { [table]: true? }
function LoggedSerializer.SerializeArray(tbl, size, output, objects)
	output:Append("[");

	for index = 1, size do
		LoggedSerializer.SerializeValue(tbl[index], output, objects);
		output:Queue(" ");
	end

	output:ClearQueue();
	output:Append("]");
end

---@param tbl table
---@param _size integer
---@param output TRP3.StringBuilder
---@param objects { [table]: true? }
function LoggedSerializer.SerializeObject(tbl, _size, output, objects)
	output:Append("{");

	for key, value in pairs(tbl) do
		LoggedSerializer.SerializeKey(key, output);
		output:Append(" ");
		LoggedSerializer.SerializeValue(value, output, objects);
		output:Queue(" ");
	end

	output:ClearQueue();
	output:Append("}");
end

---@param tbl table
local function CalculateTableSize(tbl)
	local numTableElements = 0;
	local numArrayElements = 0;
	local maxArrayIndex = 0;

	for key in pairs(tbl) do
		numTableElements = numTableElements + 1;

		if type(key) == "number" and key == math.floor(key) then
			numArrayElements = numArrayElements + 1;
			maxArrayIndex = math.max(maxArrayIndex, key);
		end
	end

	return numTableElements, numArrayElements, maxArrayIndex;
end

---@param tbl table
---@param output TRP3.StringBuilder
---@param objects { [table]: true? }
function LoggedSerializer.SerializeTable(tbl, output, objects)
	if objects[tbl] then
		error("attempted to serialize a recursive table structure");
	end

	objects[tbl] = true;

	local numTableElements, numArrayElements, maxArrayIndex = CalculateTableSize(tbl);

	if numTableElements == numArrayElements and numArrayElements == maxArrayIndex then
		LoggedSerializer.SerializeArray(tbl, numTableElements, output, objects);
	else
		LoggedSerializer.SerializeObject(tbl, numTableElements, output, objects);
	end

	objects[tbl] = nil;
end

---@param value number|string|table|boolean|nil
---@param output TRP3.StringBuilder
---@param objects { [table]: true? }
function LoggedSerializer.SerializeValue(value, output, objects)
	local valueType = type(value);

	if valueType == "number" then
		LoggedSerializer.SerializeNumber(value, output);
	elseif valueType == "string" then
		LoggedSerializer.SerializeString(value, output);
	elseif valueType == "table" then
		LoggedSerializer.SerializeTable(value, output, objects);
	elseif valueType == "boolean" then
		LoggedSerializer.SerializeBoolean(value, output);
	elseif valueType == "nil" then
		LoggedSerializer.SerializeNil(value, output);
	else
		error(string.format("attempted to serialize a %s value", valueType));
	end
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseString(reader)
	local str = reader:ReadPattern('^(%b"")');

	if not str then
		error(string.format("unterminated string starting at byte %d", reader:GetOffset()));
	end

	str = string.sub(str, 2, -2);
	str = string.gsub(str, LOGGED_STRING_DECODE_PATTERN, LOGGED_STRING_DECODE_TABLE);
	return str;
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseKeyword(reader)
	local keyword = reader:ReadPattern("^:([a-zA-Z_-][a-zA-Z0-9_-]*)");

	if not keyword then
		error(string.format("unterminated keyword starting at byte %d", reader:GetOffset()));
	end

	---@cast keyword string
	return keyword;
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseObject(reader)
	local object = table.create(0, 8);

	reader:AdvanceBy(1);
	reader:SkipWhitespace();

	if reader:PeekChar() == "}" then
		reader:AdvanceBy(1);
		return object;
	end

	while true do
		reader:SkipWhitespace();
		local key = LoggedSerializer.ParseValue(reader);
		reader:SkipWhitespace();
		local value = LoggedSerializer.ParseValue(reader);
		---@cast key any
		object[key] = value;
		reader:SkipWhitespace();

		if reader:PeekChar() == "}" then
			reader:AdvanceBy(1);
			break;
		end
	end

	return object;
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseArray(reader)
	local array = table.create(8, 0);
	local index = 0;

	reader:AdvanceBy(1);
	reader:SkipWhitespace();

	if reader:PeekChar() == "]" then
		reader:AdvanceBy(1);
		return array;
	end

	while true do
		reader:SkipWhitespace();
		index = index + 1;
		array[index] = LoggedSerializer.ParseValue(reader);
		reader:SkipWhitespace();

		if reader:PeekChar() == "]" then
			reader:AdvanceBy(1);
			break;
		end
	end

	return array;
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseNumberOrLiteral(reader)
	local number = reader:ReadPattern("^(%-?%d+%.?%d*)");

	if number then
		return tonumber(number);
	end

	local keyword = reader:ReadPattern("^(%a+)");

	if keyword == "true" then
		return true;
	elseif keyword == "false" then
		return false;
	elseif keyword == "nil" then
		return nil;
	else
		error(string.format("invalid token at byte %d", reader:GetOffset()));
	end
end

---@param reader TRP3.StringReader
function LoggedSerializer.ParseValue(reader)
	reader:SkipWhitespace();

	local char = reader:PeekChar();

	if char == '"' then
		return LoggedSerializer.ParseString(reader)
	elseif char == ":" then
		return LoggedSerializer.ParseKeyword(reader);
	elseif char == "{" then
		return LoggedSerializer.ParseObject(reader);
	elseif char == "[" then
		return LoggedSerializer.ParseArray(reader);
	else
		return LoggedSerializer.ParseNumberOrLiteral(reader);
	end
end

---@param data number|string|table|boolean|nil
function TRP3_EncodingUtil.SerializeLogged(data)
	local buffer = TRP3_StringUtil.CreateStringBuilder(128);
	local objects = table.create(0, 16);
	LoggedSerializer.SerializeValue(data, buffer, objects);
	return buffer:Concat();
end

---@param data string
---@return number|string|table|boolean|nil
function TRP3_EncodingUtil.DeserializeLogged(data)
	local reader = TRP3_StringUtil.CreateStringReader(data);
	local value = LoggedSerializer.ParseValue(reader);
	return value;
end

--
-- PEM Encoding and Decoding Utilities
--

function TRP3_EncodingUtil.IsPEMEncodingSupported()
	return C_EncodingUtil and C_EncodingUtil.EncodeBase64;
end

local PEMEncoder = {};

function PEMEncoder:__init()
	self.buffer = {};
	self.queueBlankLine = false;
end

function PEMEncoder:Encode(label, data, headers)
	self:WriteBeginLabel(label);

	if headers then
		self:WriteHeaders(headers);
		self:QueueBlankLine();
	end

	self:WriteData(data);
	self:WriteEndLabel(label);
	self:QueueBlankLine();
end

function PEMEncoder:Finalize()
	return table.concat(self.buffer, "\n");
end

function PEMEncoder:WriteBeginLabel(label)
	self:WriteFormattedLine("-----BEGIN %s-----", label);
end

function PEMEncoder:WriteHeader(header, value)
	self:WriteFormattedLine("%s: %s", header, value);
end

function PEMEncoder:WriteHeaders(headers)
	if headers then
		for _, header in ipairs(headers) do
			if header.value ~= nil then
				self:WriteHeader(header.key, header.value);
			end
		end
	end
end

function PEMEncoder:WriteData(data)
	local encodedData = C_EncodingUtil.EncodeBase64(data);
	local offset = 1;
	local length = #encodedData;
	local lineLength = 78;

	while offset <= length do
		local line = string.sub(encodedData, offset, offset + lineLength - 1);
		self:WriteLine(line);
		offset = offset + lineLength;
	end
end

function PEMEncoder:WriteEndLabel(label)
	self:WriteFormattedLine("-----END %s-----", label);
end

function PEMEncoder:WriteFormattedLine(format, ...)
	self:WriteLine(string.format(format, ...));
end

function PEMEncoder:WriteLine(line)
	if self.queueBlankLine then
		self.queueBlankLine = false;
		table.insert(self.buffer, "");
	end

	table.insert(self.buffer, line);
end

function PEMEncoder:QueueBlankLine()
	self.queueBlankLine = true;
end

function TRP3_EncodingUtil.CreatePEMEncoder()
	local encoder = TRP3_API.AllocateObject(PEMEncoder);
	encoder:__init();
	return encoder;
end

function TRP3_EncodingUtil.EncodePEM(label, data, headers)
	local encoder = TRP3_EncodingUtil.CreatePEMEncoder();
	encoder:Encode(label, data, headers);
	return encoder:Finalize();
end

local PEMDecoder = {};

function PEMDecoder:__init(data)
	self.data = data;
	self.offset = 1;
end

function PEMDecoder:Decode()
	if self.offset > #self.data then
		return;
	end

	-- Rather than mess around with line-by-line parsing, extract a full
	-- PEM block through a basic pattern match.

	local BLOCK_PATTERN = "%-%-%-%-%-BEGIN ([^-]+)%-%-%-%-%-%s+(.-)%s+-%-%-%-%-END %1-%-%-%-%-()";
	local label, block, blockEnd = string.match(self.data, BLOCK_PATTERN, self.offset);

	if not label then
		return;
	end

	-- The block body may contain a preamble of headers delimited by two newlines.
	-- If we can't find this, assume there's no header and that the block body
	-- is the full data.

	local BLOCK_SPLIT_PATTERN = "^(.-\n)\n(.*)$";
	local header, encodedData = string.match(block, BLOCK_SPLIT_PATTERN);

	if not header then
		header = "";
		encodedData = block;
	end

	-- Parse the headers as newline terminated "Some-Key: Value" strings.

	local BLOCK_HEADER_PATTERN = "([%w%-]+):%s*(.-)\n";
	local headers = {};

	for key, value in string.gmatch(header, BLOCK_HEADER_PATTERN) do
		headers[key] = value;
	end

	-- The data itself is a base64 encoded blob that may be separated across
	-- multiple lines; trim the whitespace and decode.

	encodedData = string.gsub(encodedData, "%s*", "");
	local data = C_EncodingUtil.DecodeBase64(encodedData);
	self.offset = blockEnd + 1;

	return label, data, headers;
end

function PEMDecoder:DecodeAll()
	local function DecodeNext(decoder, index)
		local label, data, headers = decoder:Decode();

		if label then
			return index + 1, label, data, headers;
		end
	end

	local index = 0;
	return DecodeNext, self, index;
end

function TRP3_EncodingUtil.CreatePEMDecoder(data)
	local decoder = TRP3_API.AllocateObject(PEMDecoder);
	decoder:__init(data);
	return decoder;
end

function TRP3_EncodingUtil.DecodePEM(data)
	local decoder = TRP3_EncodingUtil.CreatePEMDecoder(data);
	return decoder:Decode();
end
