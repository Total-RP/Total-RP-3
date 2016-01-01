----------------------------------------------------------------------------------
-- Total RP 3: Quest DB
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- PLAYER QUEST LOG STRUCTURE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local questlog = {

	["myFirstCampaign"] = {
		["quest1"] = {
			CS = "2", -- Current step
			OB = {
				["1"] = {
					VA = true,
				},

				["2"] = {
					VA = 14,
				},

				["3"] = {},
			}
		}
	}

}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CAMPAIGN DB
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DB.campaign = {

	["mySecondCampaign"] = {

		-- Base information, common to the whole campaign
		BA = {
			IM = "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES",
			NA = "A glamourous friendship",
			DE = "I'm looking for a boyfriend, and this farmer in Elwynn ask for help. I hope he's hotter than me.\nEver since I lost my husband, my life changed. I'm poor, I don't eat anymore.\nAll I need is love.",
			RA = {50, 80},
		},

	},

	["myFirstCampaign"] = {

		-- Base information, common to the whole campaign
		BA = {
			IC = "achievement_reputation_05",
			NA = "A dangerous friendship",
			DE = "I'm looking for a job, and this farmer in Elwynn ask for help. I hope he's richer than me.",
		},

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Quest list
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		QE = {
			["quest1"] = {

				-- Base information, common to the whole quest
				BA = {
					IC = "INV_jewelcrafting_Empyreansapphire_02",
					NA = "A dark omen",
					DE = "Help the farmer found his missing jewels.",
				},

				-- Different objective from all steps
				-- OB only contains information, no script trigger !
				OB = {
					-- Boolean objective: simple activation
					["1"] = {
						TX = "Go to the dark cavern.",
					},

					-- Count objective: do something a certain amount of time
					["2"] = {
						TX = "{val} / {obj} kobold killed",
						CT = 25,
						OP = true, -- Optional
						HI = true, -- Hidden
					},

					-- Component objective: must possess a certain amount of a component
					["3"] = {
						TX = "My seconde objective: {cur} / {obj}",
						CO = "quest1	2	jewel", -- tabs separate the id domains
						CT = 5,
						HI = true, -- Hidden
					},
				},

				-- Quest steps
				ST = {

					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
					-- Quest step 1: Found the cavern
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["1"] = {

						-- Quest step log information ONCE IN STEP
						LO = {
							TI = "Found the cavern",
							DE = "Should be north of Elwynn forest.",
						},

						-- Scripts for this step
						SC = {

							["STEP_START"] = {
								-- 1: Show dialog
							},

							["CAVERN_ENTER"] = {
								-- 1: check zone
								-- 2: complete obj 1
								-- 3: Go to step 2
							}
						},

						-- Wow/TRP3 Handlers for this step
						HA = {
							{"ZoneEntered", "CAVERN_ENTER" }
						},

						-- OnStart inner handler
						OS = "STEP_START",

					},

					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
					-- Quest step 2: Found the missing jewels
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["2"] = {

						-- Quest step log information ONCE IN STEP
						LO = {
							TI = "Find the missing jewels",
							DE = "I should kill some kibild and loot them.",
						},

						-- Scripts for this step
						SC = {
							["STEP_START"] = {
								-- 1: show obj 2
							},

							["KOBOLD_KILLED"] = {
								-- 1: test que l'enemy est bien un kobold
								-- 2: increment objective 2
							},

							["KOBOLD_LOOT"] = {
								-- 1: test que l'enemy est bien un kobold et est mort et n'est pas marqué comme looté
								-- 2: loot item jewel x[1-3]
							},

							["GIVE_JEWEL"] = {
								-- 1: test qu'on a les 5 jewels, si non => dialogue nous disant qu'on a pas fini
								-- 2: remove 5 jewel du sac (deposit system ?)
								-- 3: Go to step 3
							},
						},

						-- Handlers for this step
						HA = {
							{"OnEnemyKilled", "Activate script KOBOLD_KILLED"},
							{"TRP3_OnTargetLoot", "Activate script KOBOLD_LOOT"},
							{"TRP3_OnActionInterractTarget", "Activate script GIVE_JEWEL"},
						},

						-- OnStart inner handler
						OS = "STEP_START",

						-- Items specific for this step
						IT = {
							["jewel"] = {
								BA = {
									NA = "Jewel"
								}
							}
						},

					},

					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
					-- Quest step 3: Reward
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["3"] = {

						-- Scripts for this step
						SC = {

							["STEP_START"] = {
								-- 1: Show dialog REWARD
							},

							["CAVERN_ENTER"] = {
								-- 1: check zone
								-- 2: complete obj 1
								-- 3: Go to step 2
							}
						},

						-- Wow/TRP3 Handlers for this step
						HA = {
							{"ZoneEntered", "CAVERN_ENTER" }
						},

						-- Dialog for this step
						DI = {
							["REWARD"] = {
								-- 1: Propose reward
								-- 2: Si obj 2 remplit, and reward
								-- 3: Quest finish
							}
						},

						-- OnStart inner handler
						OS = "STEP_START",

					},
				},

				-- Scripts for quest
				SC = {
					["QUEST_START"] = {
						ST = {
							["1"] = {
								t = "list",
								e = {
									{
										id = "text",
										args = {"Quest start !", 3}
									},
								}
							},
						},
					},

					["H1"] = {
						ST = {
							["1"] = {
								t = "list",
								e = {
									{
										id = "text",
										args = {"Stop moving !", 3}
									},
								}
							},
						},
					},
				},

				-- Handler for quest
				HA = {
					PLAYER_STOPPED_MOVING = "H1",
				},

				-- OnStart inner handler
				OS = "QUEST_START",
			}
		},

		-- Handler for campaign
		HA = {
			PLAYER_STARTED_MOVING = "H1",
		},

		-- Scripts for campaign
		SC = {
			["CAMPAIGN_START"] = {
				ST = {
					["1"] = {
						t = "list",
						e = {
							{
								id = "text",
								args = {"Starting campaign.", 3}
							},
							{
								id = "startQuest",
								args = {"quest1"}
							},
						}
					},
				},
			},

			["H1"] = {
				ST = {
					["1"] = {
						t = "list",
						e = {
							{
								id = "text",
								args = {"You move !", 3}
							},
						}
					},
				},
			},
		},

		-- OnStart inner handler
		OS = "CAMPAIGN_START",
	}

};

local missingCampaign = {
	missing = true,
	BA = {
		IC = "inv_misc_questionmark",
		NA = "|cffff0000MISSING ITEM CLASS",
		DE = "The information relative to this campaign are missing. It's possible the class was deleted or that it relies on a missing module.",
	}
}

setmetatable(TRP3_DB.campaign, {
	__index = function(table, key)
		local value = rawget(table, key);
		return value or missingCampaign;
	end
});