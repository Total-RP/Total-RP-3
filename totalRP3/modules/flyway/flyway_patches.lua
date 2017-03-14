----------------------------------------------------------------------------------
-- Total RP 3
-- Schema migration tool : Patches
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

TRP3_API.flyway.patches = {};

local pairs, wipe = pairs, wipe;

-- Delete notification system
TRP3_API.flyway.patches["3"] = function()
	if TRP3_Characters then
		for _, character in pairs(TRP3_Characters) do
			if 	character.notifications then
				wipe(character.notifications);
			end
			character.notifications = nil;
		end
	end
end

TRP3_API.flyway.patches["4"] = function()
	if TRP3_Configuration and TRP3_Configuration["register_mature_filter"] and TRP3_Configuration["register_mature_filter"] == "0" then
		TRP3_Configuration["register_mature_filter"] = false;
	end
end

TRP3_API.flyway.patches["5"] = function()
	-- Sanitize existing profiles
	if TRP3_API.configuration.getValue("register_sanitization") then
		local sanitizeFullProfile = TRP3_API.register.sanitizeFullProfile;
		for _, profile in pairs(TRP3_Register.profiles) do
			sanitizeFullProfile(profile);
		end
	end
end