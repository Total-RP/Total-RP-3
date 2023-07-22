-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.0");

function TRP3_API.utils.resources.getIconList(filter)
	local list = {};

	local n = 1;
	for _, name in LibRPMedia:FindIcons(filter or "", { method = "substring", reuseTable = {} }) do
		list[n] = name;
		n = n + 1;
	end

	return list;
end

function TRP3_API.utils.resources.getIconListSize()
	return LibRPMedia:GetNumIcons();
end
