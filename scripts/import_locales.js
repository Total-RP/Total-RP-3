const fs = require('fs');
const requestPromise = require('request-promise');
const parser = require('luaparse');

const API_KEY = require("./API_KEY");
const filePath = "../totalRP3/core/impl/locale/";

const PROJECT_ID = 75973;
const EXPORT_LOCALES_URL = "https://wow.curseforge.com/api/projects/" + PROJECT_ID + "/localization/export";

const YEAR = new Date().getFullYear();

const languages = [
	{
		code : "deDE",
		value: "Deutsch"
	},
	{
		code : "esES",
		value: "Español"
	},
	{
		code : "esMX",
		value: "Español (Latin American)"
	},
	{
		code : "frFR",
		value: "Français"
	},
	{
		code : "itIT",
		value: "Italian"
	},
	{
		code : "ptBR",
		value: "Brazilian Portuguese"
	},
	{
		code : "ruRU",
		value: "Russian"
	},
	{
		code : "zhCN",
		value: "Chinese"
	}
];

for (let language of languages) {
	const fileName = `${filePath}locale_${language.code}.lua`;
	
	let localeContent = `----------------------------------------------------------------------------------
-- Total RP 3
-- ${language.value} locale
-- ---------------------------------------------------------------------------
-- Copyright ${YEAR} Sylvain "Telkostrasz" Cossement <telkostrasz@totalrp3.info> @Telkostrasz
-- Copyright ${YEAR} Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

local LOCALE = {
	locale = "${language.code}",
	localeText = "${language.value}",

	localeContent = {}
};

`;
	
	requestPromise({
		method : "GET",
		uri    : EXPORT_LOCALES_URL,
		headers: {
			"X-Api-Token": API_KEY
		},
		qs     : {
			"export-type": "Table",
			"lang"       : language,
			"unlocalized": "Ignore"
		}
	})
		.then(function (localization) {
			
			localeContent += `local ${localization}`;
			
			localeContent += `
-- CurseForge gives us an output that explicitly declares a table L,
-- so we no longer can insert the output inside our table declaration…
LOCALE.localeContent = L;
TRP3_API.locale.registerLocale(LOCALE);

`;
			try {
				parser.parse(localeContent);
			}
			catch (e) {
				console.error(`Locale ${language.code} could not be parsed! A formatting error must have happened :(`);
				console.error(e);
			}
			
			fs.writeFileSync(fileName, localeContent);
			console.log(`Locale ${language.code} successfully imported 👍`)
		});
}