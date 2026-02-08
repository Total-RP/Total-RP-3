-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_EncodingUtil = {};

function TRP3_EncodingUtil.CompressString(data)
	return C_EncodingUtil.CompressString(data);
end

function TRP3_EncodingUtil.DecompressString(data)
	return C_EncodingUtil.DecompressString(data);
end

--
-- PEM Encoding and Decoding Utilities
--

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
