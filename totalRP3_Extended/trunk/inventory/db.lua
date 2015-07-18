----------------------------------------------------------------------------------
-- Total RP 3: Item DB
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

TRP3_DB.item = {
	["01pouicpouic123"] = {
		BA = {
			IC = "inv_misc_toy_02",
			NA = "Pouic",
			DE = "Un joli pouic à vapeur",
			QA = 3,
			CO = true,
		},
		US = {
			AC = "Pouiquer",
		},
	},
	["01pouicpouic124"] = {
		BA = {
			IC = "inv_misc_toy_05",
			NA = "Pouac",
			DE = "Un joli pouac",
			SB = true,
			WE = 0.2,
		},
		QE = {
			QH = true,
		},
	},

	["01container1234"] = {
		BA = {
			IC = "inv_misc_bag_11",
			NA = "Simple bag",
			DE = "Un sac à dos classique",
			UN = 5,
		},
		CO = {
			DU = 25,
			MW = 30,
		},
	},
	["01container1235"] = {
		BA = {
			IC = "inv_misc_bag_02",
			NA = "Pouic bag",
			DE = "Un sac à dos classique",
			UN = 5,
		},
		CO = {
			DU = 25,
			MW = 30,
		},
	},
};