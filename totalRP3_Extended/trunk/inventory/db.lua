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
			SI = "5x4",
		},
	},

	["smallbag"] = {
		BA = {
			IC = "inv_misc_bag_10",
			NA = "Small bag",
		},
		CO = {
			SI = "2x4",
			SR = 2,
		},
	},

	["tinybag"] = {
		BA = {
			IC = "inv_misc_bag_09",
			NA = "Tiny bag",
		},
		CO = {
			SI = "1x4",
			SR = 1,
		},
	},

	["coin1"] = {
		BA = {
			IC = "INV_Misc_Coin_19",
			NA = "Copper coin",
			DE = "A simple copper coin",
			QA = 2,
			WE = 0.02,
		},
		ST = {
			MA = 5,
		},
	},

	["fixcontainer"] = {
		BA = {
			IC = "inv_misc_armorkit_17",
			NA = "Bag patch",
			DE = "Fix one durability point for the bag where it stands.",
			QA = 3,
		},
		US = {
			AC = "Fix bag",
			SC = "onUse",
		},
		SC = {
			["onUse"] = {
				ST = {
					["1"] = {
						t = "list",
						e = {
							{
								id = "durability",
								args = {"con", 1}
							},
							{
								id = "consumme",
								args = {1}
							},
						}
					},
				}
			}
		},
	},

	["dammagecontainer"] = {
		BA = {
			IC = "trade_archaeology_rustedsteakknife",
			NA = "Old rusty knife",
			DE = "Damage for one durability point for the bag where it stands.\nBut you can also use it to kill someone.",
			QA = 3,
		},
		SC = {
			["onUse"] = {
				ST = {
					["1"] = {
						t = "list",
						e = {
							{
								id = "text",
								args = {"You are thinking of what to do ...", 4}
							},
						},
						n = "2"
					},

					["2"] = {
						t = "delay",
						d = 2,
						n = "3"
					},

					["3"] = {
						t = "branch",
						b = {
							{
								cond = { { { i = "tar_name" }, "==", {v = "nil"} } },
								condID = "hasTarget",
								n = "4"
							},
							{
								cond = { { { i = "cond", a = {"hasTarget"} }, "~=", {v = "true"} } },
								n = "5"
							}
						},
						n = "3"
					},

					["4"] = {
						t = "list",
						e = {
							{
								id = "durability",
								args = {"con", -1}
							},
						}
					},

					["5"] = {
						t = "list",
						e = {
							{
								id = "text",
								args = {"You murder your target.", 3}
							},
							{
								id = "addItem",
								args = {"coin1"}
							},

						}
					},
				},
			}
		},
		US = {
			AC = "Damage bag or kill target",
			SC = "onUse",
		},
	},
};

TRP3_DB.item.MISSING_ITEM = {
	BA = {
		IC = "inv_misc_questionmark",
		NA = "|cffff0000MISSING ITEM CLASS",
		DE = "The information relative to this item are missing. It's possible the class was deleted or that it relies on a missing module.",
	},
	US = {
		AC = "Remove item from container",
	}
}