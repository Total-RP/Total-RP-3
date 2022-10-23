-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.0");

function TRP3_API.utils.resources.getMusicList(filter)
	local list = {};

	for _, file, name in LibRPMedia:FindMusicFiles(filter or "", { method = "substring" }) do
		local duration = LibRPMedia:GetMusicFileDuration(file);
		list[#list + 1] = {name, file, duration};
	end

	return list;
end

function TRP3_API.utils.resources.getMusicListSize()
	return LibRPMedia:GetNumMusicFiles();
end
