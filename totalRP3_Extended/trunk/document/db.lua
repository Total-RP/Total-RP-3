----------------------------------------------------------------------------------
-- Total RP 3: Document DB
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

TRP3_DB.document = {

	
};

local missing = {
	missing = true,
	BA = {
		IC = "inv_misc_questionmark",
		NA = "|cffff0000MISSING ITEM CLASS",
		DE = "The information relative to this document are missing. It's possible the class was deleted or that it relies on a missing module.",
	}
}

setmetatable(TRP3_DB.document, {
	__index = function(table, key)
		local value = rawget(table, key);
		return value or missing;
	end
});