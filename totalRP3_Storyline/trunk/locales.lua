----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
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

TRP3_StorylineAPI = {};

TRP3_StorylineAPI.LOCALE = {

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_EN
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["enUS"] = {
		SL_STORYLINE = "Storyline",
		SL_SELECT_DIALOG_OPTION = "Select dialog option",
		SL_SELECT_AVAILABLE_QUEST = "Select available quest",
		SL_WELL = "Well ...",
		SL_ACCEPTANCE = "I accept.",
		SL_DECLINE = "I refuse.",
		SL_NEXT = "Continue",
		SL_CONTINUE = "Complete quest",
		SL_NOT_YET = "Come back when it's done",
		SL_CHECK_OBJ = "Check objectives",
		SL_RESET = "Rewind",
		SL_RESET_TT = "Rewind this dialogue.",
		SL_REWARD_MORE = "You will also get",
		SL_REWARD_MORE_SUB = "\nMoney: |cffffffff%s|r\nExperience: |cffffffff%s xp|r\n\n|cffffff00Click:|r Get your reward!",
		SL_GET_REWARD = "Get your reward",
		SL_SELECT_REWARD = "Select your reward",
		SL_CONFIG = "Parameters",
		SL_CONFIG_TEXTSPEED = "Text speed: %.1fx",
		SL_CONFIG_TEXTSPEED_INSTANT = "No anim",
		SL_CONFIG_TEXTSPEED_HIGH = "High",
	},
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_FR
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["frFR"] = {
		SL_STORYLINE = "Storyline",
		SL_SELECT_DIALOG_OPTION = "Sélectionnez une option",
		SL_SELECT_AVAILABLE_QUEST = "Sélectionnez une quête",
		SL_WELL = "Et bien ...",
		SL_ACCEPTANCE = "J'accepte.",
		SL_DECLINE = "Je refuse.",
		SL_NEXT = "Continuer",
		SL_CONTINUE = "Terminer la quête",
		SL_NOT_YET = "Revenez quand cela sera fait",
		SL_CHECK_OBJ = "Vérifier objectifs",
		SL_RESET = "Début",
		SL_RESET_TT = "Revenir au début du dialogue",
		SL_REWARD_MORE = "Vous recevrez aussi",
		SL_REWARD_MORE_SUB = "\nArgent: |cffffffff%s|r\nExpérience: |cffffffff%s xp|r\n\n|cffffff00Clic:|r Prenez votre récompense !",
		SL_GET_REWARD = "Prenez votre récompense",
		SL_SELECT_REWARD = "Choisissez votre récompense",
	},
}