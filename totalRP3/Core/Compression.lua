-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = TRP3.Ellyb;

-- AddOns imports
local LibDeflate = LibStub:GetLibrary("LibDeflate");

local Compression = {};

function Compression.compress(data, willBeSentViaAddOnChannel)
	Ellyb.Assertions.isType(data, "string", "data");

	local compressedData = TRP3_EncodingUtil.CompressString(data);

	if willBeSentViaAddOnChannel then
		compressedData = LibDeflate:EncodeForWoWChatChannel(compressedData);
	end

	return compressedData;
end

function Compression.decompress(compressedData, wasReceivedViaAddOnChannel)
	Ellyb.Assertions.isType(compressedData, "string", "data");

	if wasReceivedViaAddOnChannel then
		local decodedCompressedData = LibDeflate:DecodeForWoWChatChannel(compressedData);
		-- TODO Clean that up, instead of just returning the passed data
		if not decodedCompressedData then
			return compressedData;
		else
			compressedData = decodedCompressedData;
		end
	end

	local decompressedData = TRP3_EncodingUtil.DecompressString(compressedData);
	return decompressedData;
end

TRP3.Compression = Compression;
