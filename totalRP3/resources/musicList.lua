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

function TRP3_API.utils.resources.getMusicList(filter)
	local list = {};
	local options = { reuseTable = {} };

	for music in LibRPMedia:FindMusic(filter, options) do
		list[#list + 1] = {music.names[1], music.id, music.duration};
	end

	return list;
end

function TRP3_API.utils.resources.getMusicListSize()
	return LibRPMedia:GetNumMusic();
end
