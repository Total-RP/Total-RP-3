-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

local Workarounds = {};
TRP3_API.Workarounds = Workarounds ;

local workaroundsToApply = {};

function Workarounds.applyWorkarounds()
	for _, workaround in pairs(workaroundsToApply) do
		workaround();
	end
end


Workarounds.applyWorkarounds();
