-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- AddOns imports
local LibDeflate = LibStub:GetLibrary("LibDeflate");

local Compression = {};

-- Protocol break for 12.0: Historically, data compression intended for use
-- in addon messages has been using a codec for regular chat messages. This
-- incurs a ~53% overhead in transmission size as over half of the range of
-- bytes needs to be escaped.
local useAddonChatEncoding = (select(4, GetBuildInfo()) >= 120000);

function Compression.compress(data, willBeSentViaAddOnChannel)
	local compressedData = TRP3_EncodingUtil.CompressString(data);

	if willBeSentViaAddOnChannel then
		if useAddonChatEncoding then
			compressedData = TRP3_EncodingUtil.EncodeAddOnMessage(compressedData);
		else
			compressedData = LibDeflate:EncodeForWoWChatChannel(compressedData);
		end
	end

	return compressedData;
end

function Compression.decompress(compressedData, wasReceivedViaAddOnChannel)
	if wasReceivedViaAddOnChannel then
		if useAddonChatEncoding then
			compressedData = TRP3_EncodingUtil.DecodeAddOnMessage(compressedData);
		else
			compressedData = assert(LibDeflate:DecodeForWoWChatChannel(compressedData));
		end
	end

	local decompressedData = TRP3_EncodingUtil.DecompressString(compressedData);
	return decompressedData;
end

AddOn_TotalRP3.Compression = Compression;
