-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = TRP3_API.Ellyb;

local Color = Ellyb.Color;

local Globals = TRP3_API.globals;
local loc = TRP3_API.loc;
local EMPTY = Globals.empty;
local tcopy = TRP3_API.utils.table.copy;
local get = TRP3_API.profile.getData;
local getPlayerCurrentProfile = TRP3_API.profile.getPlayerCurrentProfile;
local Events = TRP3_API.events;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local getProfiles = TRP3_API.profile.getProfiles;
local gsub = string.gsub;

-- These functions get replaced by the proper TRP3 ones once the addon has finished loading
local function getPlayerCompleteName()
	return TRP3_API.globals.player
end
local function getCompleteName()
	return UNKNOWN
end

TRP3_API.register.relation = {};


Events.listenToEvent(Events.WORKFLOW_ON_LOAD, function()
	getCompleteName, getPlayerCompleteName = TRP3_API.register.getCompleteName, TRP3_API.register.getPlayerCompleteName;
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEFAULT_RELATIONS = {
	UNFRIENDLY = { id = "UNFRIENDLY", order = 5, texture = TRP3_InterfaceIcons.RelationUnfriendly, color = Ellyb.ColorManager.RED:GenerateHexadecimalColor() },
	NONE = { id = "NONE", order = 6, texture = TRP3_InterfaceIcons.RelationNone, color = Ellyb.ColorManager.WHITE:GenerateHexadecimalColor() },
	NEUTRAL = { id = "NEUTRAL", order = 4, texture = TRP3_InterfaceIcons.RelationNeutral, color = Ellyb.Color.CreateFromRGBA(0.5, 0.5, 1, 1):GenerateHexadecimalColor() },
	BUSINESS = { id = "BUSINESS", order = 3, texture = TRP3_InterfaceIcons.RelationBusiness, color = Ellyb.Color.CreateFromRGBA(1, 1, 0, 1):GenerateHexadecimalColor() },
	FRIEND = { id = "FRIEND", order = 2, texture = TRP3_InterfaceIcons.RelationFriend, color = Ellyb.ColorManager.GREEN:GenerateHexadecimalColor() },
	LOVE = { id = "LOVE", order = 1, texture = TRP3_InterfaceIcons.RelationLove, color = Ellyb.ColorManager.PINK:GenerateHexadecimalColor() },
	FAMILY = { id = "FAMILY", order = 0, texture = TRP3_InterfaceIcons.RelationFamily, color = Ellyb.Color.CreateFromRGBA(1, 0.75, 0, 1):GenerateHexadecimalColor() },
};


--getRelationList function should get relations stored in config, or default relations if none are stored
local function getRelationList()
	local relationList = TRP3_API.configuration.getValue("register_relation_list");
	if not relationList then
		relationList = {}
		tcopy(relationList, DEFAULT_RELATIONS);
	end
	return relationList;
end
TRP3_API.register.relation.getRelationList = getRelationList;

--getRelationInfo function should get relation info from relationList, or default relation info if relation is not in relationList
local function getRelationInfo(relation)
	if not relation then
		return DEFAULT_RELATIONS.NONE;
	end
	if (relation.id) then
		relation = relation.id;
	end
	local relationList = getRelationList();
	local relationInfo = relationList[relation];
	if not relationInfo then
		relationInfo = DEFAULT_RELATIONS.NONE;
	end
	return relationInfo;
end
TRP3_API.register.relation.getRelationInfo = getRelationInfo;

local function setRelation(profileID, relation)
	local profile = getPlayerCurrentProfile();
	if not profile.relation then
		profile.relation = {};
	end
	profile.relation[profileID] = relation;
end
TRP3_API.register.relation.setRelation = setRelation;

local function getRelation(profileID)
	local relationTab = get("relation") or EMPTY;
	return getRelationInfo(relationTab[profileID])
end
TRP3_API.register.relation.getRelation = getRelation;

local function getRelationText(profileID)
	local relation = getRelation(profileID);
	if relation == getRelation("NONE") then
		return "";
	end
	return relation.name or loc:GetText("REG_RELATION_"..relation.id);
end
TRP3_API.register.relation.getRelationText = getRelationText;


local function getRelationTooltipText(profileID, profile)
	local description = getRelation(profileID).description or loc:GetText("REG_RELATION_" .. getRelation(profileID).id .. "_TT");
	local player = getPlayerCompleteName(true);
	local target = getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true);
	local playerIdentifier = "{"..loc.REG_RELATION_REPLACE_PLAYER.."}";
	local targetIdentifier = "{"..loc.REG_RELATION_REPLACE_TARGET.."}";
	return gsub(description, playerIdentifier, player):gsub(targetIdentifier, target):format(player, target) -- we do the format for backwards compatibility with slow-to update translations
end
TRP3_API.register.relation.getRelationTooltipText = getRelationTooltipText;

local function getRelationTexture(profileID)
	return getRelation(profileID).texture;
end
TRP3_API.register.relation.getRelationTexture = getRelationTexture;

local function getRelationColors(profileID)
	local relation = getRelation(profileID);
	local color = Color(relation.color);
	return color:GetRed(), color:GetGreen(), color:GetBlue(), color:GetAlpha();
end
TRP3_API.register.relation.getRelationColors = getRelationColors;

local function getColor(relation)
	return Color('#'..getRelationInfo(relation).color);
end
TRP3_API.register.relation.getColor = getColor;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function checkRelationUse()
	local relationList = getRelationList()
	for _, relation in pairs(relationList) do
		relation.inUse = false
	end
	local profiles = getProfiles()
	for _, profile in pairs(profiles) do
		local relations = get("relation", profile)
		if not relations then
			relations = {}
		end
		for _, relation in pairs(relations) do
			getRelationInfo(relation).inUse = true
		end
	end
end
local buildConfigPageElements

local function onActionSelected(relationID)
	local relation = getRelationInfo(relationID)
	if not relation.inUse then
		TRP3_API.popup.showConfirmPopup(loc.REG_RELATION_DELETE_CONFIRM_TITLE, function()
			local relationList = getRelationList()
			TRP3_API.configuration.setValue("register_relation_list", relationList)
			TRP3_API.configuration.removeElementFromPageByTitle("main_config_relations", getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id)))
			relationList[relationID] = nil
		end)
	end
end

buildConfigPageElements = function ()
	local relations = getRelationList();
	local relationElements = {};

	table.insert(relationElements, {
		title="",
		text=loc.CO_RELATIONS_NEW,
		inherit = "TRP3_ConfigButton",
		width = 200,
		OnClick = function()
			--todo: add dedicated popup to create new relation (and edit existing ones)
			TRP3_API.popup.showTextInputPopup(loc.CO_RELATIONS_NEW_TITLE, function(relationTitle)
				local relationID = strtrim(string.upper(relationTitle)):gsub('%W','_');
				local relationList = getRelationList();
				if relationID == "" then
					TRP3_API.popup.showAlertPopup(loc.CO_RELATIONS_NEW_ERROR);
					return;
				elseif relationList[relationID] then
					TRP3_API.popup.showAlertPopup(loc.CO_RELATIONS_NEW_ERROR_ID);
					return;
				end
				TRP3_API.popup.showPopup(
						TRP3_API.popup.COLORS,
						{},
						{function(red, green, blue)
							TRP3_API.popup.showTextInputPopup(loc.CO_RELATIONS_NEW_DESCRIPTION:format(loc.REG_RELATION_REPLACE_PLAYER, loc.REG_RELATION_REPLACE_TARGET), function(relationTT)
								if relationTT == "" then
									TRP3_API.popup.showAlertPopup(loc.CO_RELATIONS_NEW_ERROR_DESCRIPTION);
									return;
								end
								TRP3_API.popup.showPopup(
										TRP3_API.popup.ICONS,
										{},
										{function(relationIcon)
											relationList[relationID] = {
												id = relationID,
												name = relationTitle,
												description = relationTT,
												texture = relationIcon,
												color = Color(red, green, blue):GenerateHexadecimalColor(),
												order = 0,
												inUse = false,
											};
											TRP3_API.configuration.setValue("register_relation_list", relationList);
											TRP3_API.configuration.insertElementIntoPage("main_config_relations", {
												inherit = "TRP3_ConfigurationRelationsFrame",
												title = getColor(relationList[relationID])(relationList[relationID].name or loc:GetText("REG_RELATION_"..relationList[relationID].id)),
												text = relationList[relationID].description or loc:GetText( "REG_RELATION_" .. relationList[relationID].id .. "_TT"),
												icon = relationList[relationID].texture,
												OnClick = function(button)
													local values = {};
													checkRelationUse()
													if not relationList[relationID].inUse then
														table.insert(values, {loc.CO_RELATIONS_DELETE, relationID});
													end
													displayDropDown(button, values, onActionSelected, 0, true);
												end,
											}, -2);

										end}

								);
							end);
						end}
				);

			end)
		end,
	})
	--]]

	for _, relation in pairs(relations) do
		table.insert(relationElements, {
			inherit = "TRP3_ConfigurationRelationsFrame",
			title = getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id)),
			text = loc:GetText(relation.description or "REG_RELATION_" .. relation.id .. "_TT"),
			icon = relation.texture,
			OnClick = function(button)
				local values = {};
				checkRelationUse()
				if not relation.inUse then
					table.insert(values, {loc.CO_RELATIONS_DELETE, relation.id});
				end
				displayDropDown(button, values, onActionSelected, 0, true);
			end,
		});
	end
	return relationElements;
end

TRP3_API.register.inits.relationsInit = function()
	local configDefault = {}
	tcopy(configDefault,DEFAULT_RELATIONS)
	TRP3_API.configuration.registerConfigKey("register_relation_list", configDefault);

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_FINISH, function()

	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_relations",
		menuText = loc.CO_RELATIONS,
		pageText = loc.CO_RELATIONS,
		elements = buildConfigPageElements()
	});
	end)
end

