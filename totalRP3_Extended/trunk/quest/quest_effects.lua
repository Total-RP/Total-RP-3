----------------------------------------------------------------------------------
-- Total RP 3
-- Scripts : Campaign/Quest Effects
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Effetc structure
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tostring = tostring;

TRP3_API.quest.EFFECTS = {

	["quest_start"] = {
		codeReplacementFunc = function (args)
			local questID = args[1];
			return ("lastEffectReturn = startQuest(args.campaignID, \"%s\");"):format(questID);
		end,
		env = {
			startQuest = "TRP3_API.quest.startQuest",
		}
	},

	["quest_goToStep"] = {
		codeReplacementFunc = function (args)
			local questID = args[1];
			local stepID = args[2];
			return ("lastEffectReturn = goToStep(args.campaignID, \"%s\", \"%s\");"):format(questID, stepID);
		end,
		env = {
			goToStep = "TRP3_API.quest.goToStep",
		}
	},

	["quest_revealObjective"] = {
		codeReplacementFunc = function (args)
			local questID = args[1];
			local objectiveID = args[2];
			return ("lastEffectReturn = revealObjective(args.campaignID, \"%s\", \"%s\");"):format(questID, objectiveID);
		end,
		env = {
			revealObjective = "TRP3_API.quest.revealObjective",
		}
	},

}