-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = Ellyb(...);
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- AddOns imports
local LibDeflate = LibStub:GetLibrary("LibDeflate");
local RED, GREY = Ellyb.ColorManager.RED, Ellyb.ColorManager.GREY;

local Compression = {};

function Compression.compress(data, willBeSentViaAddOnChannel)
	Ellyb.Assertions.isType(data, "string", "data");

	local compressedData = LibDeflate:CompressDeflate(data);

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

	local decompressedData, _ = LibDeflate:DecompressDeflate(compressedData);
	if decompressedData == nil then
		error(RED("[AddOn_TotalRP3.Compression.decompress ERROR]:") .. "\nCould not decompress data \"" .. GREY(tostring(compressedData)) .. "\"");
	end

	return decompressedData;
end

AddOn_TotalRP3.Compression = Compression;
