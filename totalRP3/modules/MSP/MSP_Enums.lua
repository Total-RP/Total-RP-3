--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

TRP3_MSPField =
{
	AddOnVersions = "VA",
	Age = "AG",
	Birthplace = "HB",
	CharacterStatus = "FC",
	Class = "RC",
	CurrentlyText = "CU",
	Description = "DE",
	EyeColor = "AE",
	FullTitle = "FT",
	Glances = "PE",
	Height = "AH",
	History = "HI",
	HouseName = "NH",
	Icon = "IC",
	Motto = "MO",
	Music = "MU",
	Name = "NA",
	Nickname = "NI",
	OOCText = "CO",
	PersonalityTraits = "PS",
	PrefixTitle = "PX",
	ProfileID = "VI",
	Pronouns = "PN",
	ProtocolVersion = "VP",
	Race = "RA",
	RelationshipStatus = "RS",
	Residence = "HH",
	RoleplayExperience = "FR",
	Tooltip = "TT",
	TrialStatus = "TR",
	Weight = "AW",
};

TRP3_MSPRequestType =
{
	Full = 1,       -- Issues a full profile request for all data.
	Probe = 2,      -- Issues a minimal request for profile and addon IDs.
	Tooltip = 3,    -- Issues a tooltip-only request.
	NamePlate = 4,  -- Issues a request for nameplate related fields.
};
