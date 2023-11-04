-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Globals = TRP3_API.globals;
local loc = TRP3_API.loc;
local EMPTY = Globals.empty;
local tcopy = TRP3_API.utils.table.copy;
local get = TRP3_API.profile.getData;
local getPlayerCurrentProfile = TRP3_API.profile.getPlayerCurrentProfile;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local getProfiles = TRP3_API.profile.getProfiles;

-- These functions get replaced by the proper TRP3 ones once the addon has finished loading
local function getPlayerCompleteName()
	return TRP3_API.globals.player
end
local function getCompleteName()
	return UNKNOWN
end

TRP3_API.register.relation = {};


TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()
	getCompleteName, getPlayerCompleteName = TRP3_API.register.getCompleteName, TRP3_API.register.getPlayerCompleteName;
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEFAULT_RELATIONS = {
	UNFRIENDLY = { id = "UNFRIENDLY", order = 5, texture = TRP3_InterfaceIcons.RelationUnfriendly, color = TRP3_API.Colors.Red:GenerateHexColorOpaque() },
	NONE = { id = "NONE", order = 6, texture = TRP3_InterfaceIcons.RelationNone, color = TRP3_API.Colors.White:GenerateHexColorOpaque() },
	NEUTRAL = { id = "NEUTRAL", order = 4, texture = TRP3_InterfaceIcons.RelationNeutral, color = TRP3_API.CreateColor(0.5, 0.5, 1):GenerateHexColorOpaque() },
	BUSINESS = { id = "BUSINESS", order = 3, texture = TRP3_InterfaceIcons.RelationBusiness, color = TRP3_API.CreateColor(1, 1, 0):GenerateHexColorOpaque() },
	FRIEND = { id = "FRIEND", order = 2, texture = TRP3_InterfaceIcons.RelationFriend, color = TRP3_API.Colors.Green:GenerateHexColorOpaque() },
	LOVE = { id = "LOVE", order = 1, texture = TRP3_InterfaceIcons.RelationLove, color = TRP3_API.Colors.Pink:GenerateHexColorOpaque() },
	FAMILY = { id = "FAMILY", order = 0, texture = TRP3_InterfaceIcons.RelationFamily, color = TRP3_API.CreateColor(1, 0.75, 0):GenerateHexColorOpaque() },
};
local ACTIONS = {
	DELETE= 'DEL',
	UPDATE_TOOLTIP= 'UTT',
	UPDATE_ICON= 'UIC',
	UPDATE_COLOR= 'UCO',
}

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
	if relation.id == getRelation().id then
		return "";
	end
	return relation.name or loc:GetText("REG_RELATION_"..relation.id);
end
TRP3_API.register.relation.getRelationText = getRelationText;


local function getRelationTooltipText(profileID, profile)
	local description = getRelation(profileID).description or loc:GetText("REG_RELATION_" .. getRelation(profileID).id .. "_TT");
	local player = getPlayerCompleteName(true);
	local target = getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true);
	return description:format(player, target)
end
TRP3_API.register.relation.getRelationTooltipText = getRelationTooltipText;

local function getRelationTexture(profileID)
	return getRelation(profileID).texture;
end
TRP3_API.register.relation.getRelationTexture = getRelationTexture;

local function getRelationColors(profileID)
	local relation = getRelation(profileID);
	return TRP3_API.CreateColorFromHexString(relation.color):GetRGBAsBytes();
end
TRP3_API.register.relation.getRelationColors = getRelationColors;

local function getColor(relation)
	return TRP3_API.CreateColorFromHexString('#'..getRelationInfo(relation).color);
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

local function onActionSelected(selectedAction)
	local action = selectedAction:sub(1, 3)
	local relationID = selectedAction:sub(4)
	local relation = getRelationInfo(relationID)
	local originalRelation = getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id))
	local playerIdentifier = "{"..loc.REG_RELATION_REPLACE_PLAYER.."}";
	local targetIdentifier = "{"..loc.REG_RELATION_REPLACE_TARGET.."}";
	if action==ACTIONS.UPDATE_TOOLTIP then
		TRP3_API.popup.showTextInputPopup(loc.CO_RELATIONS_UPDATE_DESCRIPTION:format(originalRelation,loc.REG_RELATION_REPLACE_PLAYER, loc.REG_RELATION_REPLACE_TARGET), function(tooltip)
			if tooltip == "" then
				return TRP3_API.popup.showAlertPopup(loc.CO_RELATIONS_UPDATE_DESCRIPTION_ERROR:format(originalRelation))
			end
			local unlocalisedPlayer = '{player}';
			local unlocalisedTarget = '{target}';
			relation.description = tooltip:gsub(unlocalisedPlayer,'%%1$s'):gsub(unlocalisedTarget, '%%2$s'):gsub(playerIdentifier, '%%1$s'):gsub(targetIdentifier, '%%2$s')
			TRP3_API.configuration.setValue("register_relation_list", getRelationList())
			TRP3_API.configuration.updateElementByTitle("main_config_relations", originalRelation, "text", tooltip)
		end, function()  end, relation.description:format(playerIdentifier, targetIdentifier))
	elseif action==ACTIONS.UPDATE_ICON then
		TRP3_API.popup.showPopup(
			TRP3_API.popup.ICONS,
			{},
			{function(relationIcon)
				relation.texture = relationIcon
				TRP3_API.configuration.setValue("register_relation_list", getRelationList())
				TRP3_API.configuration.updateElementByTitle("main_config_relations", originalRelation, "icon", relationIcon)
			end}
		)
	elseif action==ACTIONS.UPDATE_COLOR then
		TRP3_API.popup.showPopup(
				TRP3_API.popup.COLORS,
				{},
				{function(red, green, blue)
					local color = TRP3_API.CreateColorFromBytes(red, green, blue)
					relation.color = color:GenerateHexColorOpaque()
					TRP3_API.configuration.setValue("register_relation_list", getRelationList())
					TRP3_API.configuration.updateElementByTitle("main_config_relations", originalRelation, "title", getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id)))
				end, TRP3_API.CreateColorFromHexString(relation.color):GetRGBAsBytes() }
		)
	elseif not relation.inUse and action==ACTIONS.DELETE then
		TRP3_API.popup.showConfirmPopup(loc.CO_RELATIONS_DELETE_WARNING:format(getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id))), function()
			local relationList = getRelationList()
			TRP3_API.configuration.setValue("register_relation_list", relationList)
			TRP3_API.configuration.removeElementFromPageByTitle("main_config_relations", originalRelation)
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
											local playerIdentifier = "{"..loc.REG_RELATION_REPLACE_PLAYER.."}";
											local targetIdentifier = "{"..loc.REG_RELATION_REPLACE_TARGET.."}";
											local unlocalisedPlayer = '{player}';
											local unlocalisedTarget = '{target}';
											local description = relationTT:gsub(unlocalisedPlayer,'%%1$s'):gsub(unlocalisedTarget, '%%2$s'):gsub(playerIdentifier, '%%1$s'):gsub(targetIdentifier, '%%2$s');
											local relation = {
												id = relationID,
												name = relationTitle,
												description = description,
												texture = relationIcon,
												color = TRP3_API.CreateColorFromBytes(red, green, blue):GenerateHexColorOpaque(),
												order = 0,
												inUse = false,
											};
											relationList[relationID] = relation
											TRP3_API.configuration.setValue("register_relation_list", relationList);
											TRP3_API.configuration.insertElementIntoPage("main_config_relations", {
												inherit = "TRP3_ConfigurationRelationsFrame",
												title = getColor(relation)(relation.name or loc:GetText("REG_RELATION_"..relation.id)),
												text = relation.description:format("{"..loc.REG_RELATION_REPLACE_PLAYER.."}", "{"..loc.REG_RELATION_REPLACE_TARGET.."}"),
												icon = relation.texture,
												OnClick = function(button)
													local values = {};
													checkRelationUse()
													if not relationList[relationID].inUse then
														table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_DELETE, ACTIONS.DELETE..relationID});
													end
													table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_DESCRIPTION, ACTIONS.UPDATE_TOOLTIP..relationID});
													table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_ICON, ACTIONS.UPDATE_ICON..relationID});
													table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_COLOR, ACTIONS.UPDATE_COLOR..relationID});
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
			text = loc:GetText(relation.description or "REG_RELATION_" .. relation.id .. "_TT"):format("{"..loc.REG_RELATION_REPLACE_PLAYER.."}", "{"..loc.REG_RELATION_REPLACE_TARGET.."}"),
			icon = relation.texture,
			OnClick = function(button)
				local values = {};
				checkRelationUse()
				if not relation.inUse then
					table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_DELETE, ACTIONS.DELETE..relation.id});
				end
				table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_DESCRIPTION, ACTIONS.UPDATE_TOOLTIP..relation.id});
				table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_ICON, ACTIONS.UPDATE_ICON..relation.id});
				table.insert(values, {loc.CO_RELATIONS_UPDATE_MENU_COLOR, ACTIONS.UPDATE_COLOR..relation.id});
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

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()

	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_relations",
		menuText = loc.CO_RELATIONS,
		pageText = loc.CO_RELATIONS,
		elements = buildConfigPageElements()
	});
	end)
end

