----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Morgane "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.2");

local function SortIconsPredicate(a, b)
	return a.name < b.name;
end

function TRP3_API.utils.resources.getIconList(filter, options)
	local allowAtlases = options and options.allowAtlases or false;

	local list = {};

	for icon in LibRPMedia:FindIcons(filter) do
		if allowAtlases then
			list[#list + 1] = icon;
		elseif GetFileIDFromPath([[Interface\ICONS\]] .. icon.name) then
			-- Legacy mode; only spit out file-based icons identified by name.
			list[#list + 1] = icon.name;
		end
	end

	if allowAtlases then
		table.sort(list, SortIconsPredicate);
	else
		table.sort(list);  -- Sort by name.
	end

	return list;
end

function TRP3_API.utils.resources.getIconListSize()
	-- Note that in legacy mode this number will be slightly wrong as it
	-- includes atlases and unusable files.

	return LibRPMedia:GetNumIcons();
end
