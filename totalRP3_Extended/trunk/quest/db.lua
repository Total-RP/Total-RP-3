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

local DB_TEXTS = {
	doc1 = [[{h1}Contract for job{/h1}
The Valley of Northsire is under the attack of an armed group of orcs and gobelins.
The King is offering rewards to any brave soldiers willing to take the arms

If you want to help protecting your lands, please talk to an Army Registrar in front on the abbey.

For the King,
Marshal McBride





{img:Interface\PvPRankBadges\PvPRankAlliance.blp:128:128}]]
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CAMPAIGN DB
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DB.campaign = {

	["demoCampaign"] = {

		-- Base information, common to the whole campaign
		BA = {
			IC = "achievement_zone_elwynnForest",
			NA = "Save Northshire Valley",
			DE = "Take the arms and defend the abbey.",
			RA = {1, 5},
		},

		QE = {
			["quest1"] = {

				-- Base information, common to the whole quest
				BA = {
					IC = "ability_warrior_strengthofarms",
					NA = "To arms!",
					DE = "Succeed the registration test.",
				},

				-- Objectives
				OB = {
					["1"] = {
						TX = "Talk to a Stormwind Army Registrar",
					},
				},

				-- Inner objects
				IN = {
					recruitementDoc = {
						BA = {
							NA = "Recruitement missive"
						},

						PA = {
							{
								TX = DB_TEXTS.doc1,
							}
						},
					}
				},

				-- Scripts for quest
				SC = {
					["QUEST_START"] = {
						ST = {
							["1"] = {
								t = "list",
								e = {
									{
										id = "document_show",
										args = {"demoCampaign quest1 recruitementDoc" }
									},
									{
										id = "quest_goToStep",
										args = {"demoCampaign", "quest1", "1"}
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
					-- Quest step 1: Talk to a registrar
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["1"] = {

						-- Quest step log information ONCE IN STEP
						TX = "I should talk to a |cffffff00[Stormwind Army Registrar]|r in front of the Northshire Abbey.",

						-- Quest step log information ONCE FINISHED
						DX = "I talked to an Army Registrar.",

						AC = {
							TALK = {"REGISTRAR_TALK"},
						},

						-- Scripts for quest
						SC = {
							["STEP_START"] = {
								ST = {
									["1"] = {
										t = "list",
										e = {
											{
												id = "quest_revealObjective",
												args = {"demoCampaign", "quest1", "1"}
											},
										}
									},
								},
							},

							["REGISTRAR_TALK"] = {
								ST = {
									["1"] = {
										t = "list",
										e = {
											{
												id = "dialog_start",
												args = {"demoCampaign quest1 1 dialog"}
											},
										}
									},
								},
							},
						},

						IN = {
							dialog = {
								ST = {
									{ -- 1
										TX = "Hello, I'm here for the job.",
										ND = "LEFT"
									},

									{ -- 2
										TX = "Ah yes, the job about the orcs. We need to kill them all and free Northshire.\nBut it won't be an easy task.",
									},

									{ -- 3
										TX = "So, what do you say?",
										CH = {
											{
												TX = "Okay, I'll do it.",
												N = 4,
											},
											{
												TX = "Gimme more info.",
												N = 6,
											},
											{
												TX = "No thanks ...",
												N = 8,
											}
										}
									},

									{ -- 4
										TX = "Okay, I'm in!",
										ND = "LEFT"
									},

									{ -- 5
										TX = "Excellent! But first we have to evaluate your case. We don't want to send anybody to the field.\nSo I have a small list of questions here.",
										N = 999, -- Force end
									},

									{ -- 6
										TX = "Could you explain a little more what is going on?",
										ND = "LEFT"
									},

									{ -- 7
										TX = "Well as you can see, the orcs have invaded us.\nThey burn our fields, they rape our women.\n"
												.. "We don't have the strengh to fight them alone, so we seek for any volunteer to help us.",
										N = 3,
									},

									{ -- 8
										TX = "Well I'm not in the mood, actually.",
										ND = "LEFT"
									},

									{ -- 9
										TX = "Well thank you for wasting my time then... Now move on, citizen.",
										N = 999, -- Force end
									},
								}
							}
						},

						-- OnStart inner handler
						OS = "STEP_START",

					},

				},

			},
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
								args = {"demoCampaign", "quest1"}
							},
						}
					},
				},
			},
		},

		-- OnStart inner handler
		OS = "CAMPAIGN_START",

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
						TX = "Read and sign the contract.",
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
					-- Quest step 2: Read the contract and sign it
					--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

					["2"] = {

						-- Quest step log information ONCE IN STEP
						TX = "Kyle gave me a contract that I should read carefully and sign.",

						-- Quest step log information ONCE FINISHED
						DX = "I signed the contract.",

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
												args = {"Kyle says: Hello, take this contract and sign it.", 1}
											},
											{
												id = "quest_revealObjective",
												args = {"myFirstCampaign", "quest1", "2"}
											},
											{
												id = "item_loot",
												args = {"myFirstCampaign quest1 2 contractLoot"}
											},
										}
									},
								},
							},
						},

						AC = {
							TALK = {"STEP_START"},
						},

						-- OnStart inner handler
						OS = "STEP_START",

						-- Inner objects
						IN = {

							contractLoot = {
								IC = "inv_box_01",
								NA = "Quickloot",
								IT = {
									["1"] = {
										id = "myFirstCampaign quest1 2 contractItem",
										count = 1,
									}
								}
							},

							-- Document item
							contractItem = {
								BA = {
									IC = "inv_misc_toy_05",
									NA = "Contract",
									DE = "A simple contract, written on paper.",
									UN = 1,
									WE = 0.1,
								},
								US = {
									AC = "Read the contract",
									SC = "quest"
								},
								SC = {
									quest = {
										ST = {
											["1"] = {
												t = "list",
												e = {
													{
														id = "document_show",
														args = {"myFirstCampaign quest1 2 contractDoc"}
													},
												}
											}
										}
									}
								}
							},

							-- Document
							contractDoc = {
								BA = {
									NA = "Contract"
								},

								PA = {
									{
										TX = DB_TEXTS.doc1,
									}
								},

								AC = {
									sign = "sign",
								},

								SC = {
									["sign"] = {
										ST = {
											["1"] = {
												t = "list",
												e = {
													{
														id = "document_close",
														args = {"myFirstCampaign quest1 2 contractDoc"}
													},
													{
														id = "quest_markObjDone",
														args = {"myFirstCampaign", "quest1", "2"}
													},
													{
														id = "quest_goToStep",
														args = {"myFirstCampaign", "quest1", "3"}
													},
												}
											},
										},
									},
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
						},

						-- OnStart inner handler
--						OS = "STEP_START",

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