----------------------------------------------------------------------------------
-- Total RP 3
-- English locale (default locale)
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

-- Fixed some typos in the English localization - Paul Corlay

local LOCALE_EN = {
	locale = "enUS",
	localeText = "English",
	localeContent = TRP3_API.loc,
};

TRP3_API.locale.registerLocale(LOCALE_EN);
