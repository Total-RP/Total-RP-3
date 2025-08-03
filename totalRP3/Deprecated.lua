-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Anything in this file is deprecated and will be removed in future versions
-- of TRP, potentially without warning.

local LibDeflate = LibStub:GetLibrary("LibDeflate");

AddOn_TotalRP3.Compression = {};

-- Replaced by either TRP3_EncodingUtil.EncodeBinaryAddOnMessage or EncodeLoggedAddOnMessage.
function AddOn_TotalRP3.Compression.compress(data, willBeSentViaAddOnChannel)
	local compressedData = TRP3_EncodingUtil.CompressString(data);

	if willBeSentViaAddOnChannel then
		compressedData = LibDeflate:EncodeForWoWChatChannel(compressedData);
	end

	return compressedData;
end

-- Replaced by either TRP3_EncodingUtil.DecodeBinaryAddOnMessage or DecodeLoggedAddOnMessage.
function AddOn_TotalRP3.Compression.decompress(compressedData, wasReceivedViaAddOnChannel)
	if wasReceivedViaAddOnChannel then
		compressedData = assert(LibDeflate:DecodeForWoWChatChannel(compressedData));
	end

	local decompressedData = TRP3_EncodingUtil.DecompressString(compressedData);
	return decompressedData;
end
