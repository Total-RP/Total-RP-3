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
			local campaignID = args[1];
			local questID = args[2];
			return ("lastEffectReturn = startQuest(\"%s\", \"%s\");"):format(campaignID, questID);
		end,
		env = {
			startQuest = "TRP3_API.quest.startQuest",
		}
	},

	["quest_goToStep"] = {
		codeReplacementFunc = function (args)
			local campaignID = args[1];
			local questID = args[2];
			local stepID = args[3];
			return ("lastEffectReturn = goToStep(\"%s\", \"%s\", \"%s\");"):format(campaignID, questID, stepID);
		end,
		env = {
			goToStep = "TRP3_API.quest.goToStep",
		}
	},

	["quest_revealObjective"] = {
		codeReplacementFunc = function (args)
			local campaignID = args[1];
			local questID = args[2];
			local objectiveID = args[3];
			return ("lastEffectReturn = revealObjective(\"%s\", \"%s\", \"%s\");"):format(campaignID, questID, objectiveID);
		end,
		env = {
			revealObjective = "TRP3_API.quest.revealObjective",
		}
	},

	["quest_markObjDone"] = {
		codeReplacementFunc = function (args)
			local campaignID = args[1];
			local questID = args[2];
			local objectiveID = args[3];
			return ("lastEffectReturn = markObjectiveDone(\"%s\", \"%s\", \"%s\");"):format(campaignID, questID, objectiveID);
		end,
		env = {
			markObjectiveDone = "TRP3_API.quest.markObjectiveDone",
		}
	},

}