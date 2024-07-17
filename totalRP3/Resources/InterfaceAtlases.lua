-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--
-- Interface Atlas Data
--

TRP3_InterfaceAtlases = {
	--
	-- Target Bar Icons
	--

	TargetIgnoreCharacter = { "GM-raidMarker-remove", "common-icon-redx" },
};

--
-- Data Initialization
--

do
	local function GetFirstValidAtlas(atlases)
		for _, atlas in ipairs(atlases) do
			if C_Texture.GetAtlasInfo(atlas) then
				return atlas;
			end
		end
	end

	for id, atlases in pairs(TRP3_InterfaceAtlases) do
		local name = GetFirstValidAtlas(atlases);

		if not name and TRP3_API.globals.DEBUG_MODE then
			securecallfunction(error, string.format("Invalid interface atlas %q: No valid atlas found", id));
		end

		-- No default atlas, but all assets with a potential non-valid atlas
		-- will have an iconFile attached to have an Icon fallback.
		TRP3_InterfaceAtlases[id] = name;
	end
end
