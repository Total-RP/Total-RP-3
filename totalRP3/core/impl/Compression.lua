-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = Ellyb(...);
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- AddOns imports
local LibDeflate = LibStub:GetLibrary("LibDeflate");
local RED, GREY, ORANGE = Ellyb.ColorManager.RED, Ellyb.ColorManager.GREY, Ellyb.ColorManager.ORANGE;

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

-- Documentation
Ellyb.Documentation:AddDocumentationTable("TotalRP3.Compression", {
	Name = "TotalRP3.Compression",
	Type = "System",
	Namespace = "AddOn_TotalRP3.Compression",

	Functions = {
		{
			Name = "compress",
			Type = "Function",
			Documentation = { "Compress a string." },
			Arguments = {
				{ Name = "data", Type = "string", Nilable = false, Documentation = { "The data we want to compress" } },
				{ Name = "willBeSentViaAddOnChannel", Type = "boolean", Nilable = true, Documentation = { "Set to true if the data is meant to be sent via addon channels. Some special characters not suitable for communication channels will be escaped." } },
			},
			Returns = {
				{ Name = "compressedData", Type = "sring", Nilable = false, Documentation = { "The compressed data." } },
			},
		},
		{
			Name = "decompress",
			Type = "Function",
			Documentation = { "Decompress a previously compressed string." .. ORANGE("\nWill throw an error if the algorithm was not able to decompress the data.") },
			Arguments = {
				{ Name = "compressedData", Type = "string", Nilable = false, Documentation = { "The data that was compressed and that we want to decompress" } },
				{ Name = "wasReceivedViaAddOnChannel", Type = "boolean", Nilable = true, Documentation = { "Set to true if the data was received via addon channels. Some special characters have been escaped and need to be unescaped before the data can be decompressed." } },
			},
			Returns = {
				{ Name = "data", Type = "sring", Nilable = false, Documentation = { "The decompressed data." } },
			},
		},
	},
});
