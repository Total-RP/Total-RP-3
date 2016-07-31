----------------------------------------------------------------------------------
-- Total RP 3
-- ---------------------------------------------------------------------------
-- Copyright 2014 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local dictionnary = {}

dictionnary["enUS"] = {
	"f%-list",
	"gore",
	"scat",
	"slave",
	"futa",
	"cum",
	"vaginal",
	"anal",
	"rape",
	"incest",
	"ass",
	"cunt",
	"dick",
	"tits",
	"bulge",
	"cock"
}

-- Provided by the great guys from Wiki Errantes <3
dictionnary["esES"] = {
	"puta",
	"maricón",
	"joder",
	"mierda",
	"pendejo",
	"polla",
	"coño",
	"verga",
	"zorra",
	"cabrón",
	"follar",
	"gilipollas",
	"hostia",
	"cojones",
	"joputa",
	"zorrupia",
	"putada",
	"pajero",
	"joto",
	"boludo",
	"chingar",
	"marica",
	"tonto",
	"idiota",
	"imbécil",
}

dictionnary["frFR"] = {
	"salope",
	"chibre",
	"soumise"
}

local DEFAULT_LOCALE = "enUS";
local currentLocale = DEFAULT_LOCALE;

function TRP3_API.utils.resources.getMatureFilterDictionnary()

	currentLocale = TRP3_API.configuration.getValue("AddonLocale");
	if not dictionnary[currentLocale] then
		currentLocale = DEFAULT_LOCALE;
	end

	return dictionnary[currentLocale]
end