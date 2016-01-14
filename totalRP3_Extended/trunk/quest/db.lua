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
			PS = { -- Previous step
				"1"
			},
			CS = "2", -- Current step
			OB = {
				["1"] = true,
				["2"] = false,
				["3"] = {
					VA = 5,
				},
			}
		},
		["test"] = {
			DO = true
		},
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
			DE = "Looking for some easy money?\Be careful, some friendship can became dangerous...",
		},

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Quest list
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		QE = {

			["quest1"] = {

				-- Base information, common to the whole quest
				BA = {
					IC = "INV_jewelcrafting_Empyreansapphire_02",
					NA = "The first job",
					DE = "An Night Elf in Stormwind asks for help, so it's the good time to work.",
				},

				-- Different objective from all steps
				-- OB only contains information, no script trigger !
				OB = {
					-- Boolean objective: simple activation
					["1"] = {
						TX = "Find Kyle Radue.",
					},

					["2"] = {
						TX = "Find a beverage for Kyle.",
					},

					-- Count objective: do something a certain amount of time
					["x"] = {
						TX = "{val} / {obj} kobold killed",
						CT = 25,
					},

					-- Component objective: must possess a certain amount of a component
					["xx"] = {
						TX = "My seconde objective: {cur} / {obj}",
						CO = "quest1	2	jewel", -- tabs separate the id domains
						CT = 5,
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
										id = "quest_goToStep",
										args = {"myFirstCampaign", "quest1", "1"}
									},
								}
							},
						},
					},
				},

				-- OnStart inner handler
				OS = "QUEST_START",

				-- Quest steps
				ST = {

					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
					-- Quest step 1: Found the elf
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["1"] = {

						-- Quest step log information ONCE IN STEP
						TX = "I should find the Night Elf. He's name is Kyle Radue. He should be in the Canals in Stormwind.",

						-- Quest step log information ONCE FINISHED
						DX = "I found the Elf in the Storwind Canals.",

						AC = {
							TALK = {"FOUND_KYLE"},
						},

						-- Scripts for this step
						SC = {

							["STEP_START"] = {
								ST = {
									-- 1: add objective 1
									["1"] = {
										t = "list",
										e = {
											{
												id = "quest_revealObjective",
												args = {"myFirstCampaign", "quest1", "1"}
											},
										}
									},
								},
							},

							["FOUND_KYLE"] = {
								ST = {
									-- 1: add objective 1
									["1"] = {
										t = "branch",
										b = {
											{
												cond = { { { i = "tar_name" }, "==", {v = "Kyle Radue"} } },
												n = "2"
											}
										},
									},

									["2"] = {
										t = "list",
										e = {
											{
												id = "item_loot",
												args = {"myFirstCampaign quest1 1 firstPay"}
											},
											{
												id = "quest_markObjDone",
												args = {"myFirstCampaign", "quest1", "1"}
											},
											{
												id = "quest_goToStep",
												args = {"myFirstCampaign", "quest1", "2"}
											},
										}
									},
								},
							}
						},

						-- Inner object
						IN = {
							firstPay = {
								IC = "inv_box_01",
								NA = "A first pay",
								IT = {
									["1"] = {
										id = "coin1",
										count = 10,
									}
								}
							}
						},

						-- OnStart inner handler
						OS = "STEP_START",

					},

					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
					-- Quest step 2: Find a beer
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["2"] = {

						-- Quest step log information ONCE IN STEP
						TX = "Kyle asks me to find him a beverage. I know that this elf prefers a beer so I should look in some tavern.",

						-- Scripts for this step
						SC = {
							["STEP_START"] = {
								ST = {
									-- 1: add objective 1
									["1"] = {
										t = "list",
										e = {
											{
												id = "text",
												args = {"Kyle says: Hello, I'm thirsty, go find me a beer.", 1}
											},
											{
												id = "quest_revealObjective",
												args = {"myFirstCampaign", "quest1", "2"}
											},
										}
									},
								},
							},
						},

						-- Handlers for this step
						HA = {

						},

						-- OnStart inner handler
						OS = "STEP_START",

						-- Items specific for this step
						IT = {
							["beer"] = {
								BA = {
									NA = "Beer"
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

			}
		},

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Actions & script
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		-- Scripts for campaign
		SC = {
			["CAMPAIGN_START"] = {
				ST = {
					["1"] = {
						t = "list",
						e = {
							{
								id = "quest_start",
								args = {"myFirstCampaign", "quest1"}
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