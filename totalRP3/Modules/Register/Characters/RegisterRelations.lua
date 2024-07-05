-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3_API.loc;
local EMPTY = TRP3_API.globals.empty;

TRP3_API.register.relation = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEFAULT_RELATIONS = {
	NONE = { id = "NONE", order = 0, texture = TRP3_InterfaceIcons.RelationNone },
	UNFRIENDLY = { id = "UNFRIENDLY", order = 1, texture = TRP3_InterfaceIcons.RelationUnfriendly, color = TRP3_API.Colors.Red:GenerateHexColorOpaque() },
	NEUTRAL = { id = "NEUTRAL", order = 2, texture = TRP3_InterfaceIcons.RelationNeutral, color = TRP3_API.CreateColor(0.5, 0.5, 1):GenerateHexColorOpaque() },
	BUSINESS = { id = "BUSINESS", order = 3, texture = TRP3_InterfaceIcons.RelationBusiness, color = TRP3_API.CreateColor(1, 1, 0):GenerateHexColorOpaque() },
	FRIEND = { id = "FRIEND", order = 4, texture = TRP3_InterfaceIcons.RelationFriend, color = TRP3_API.Colors.Green:GenerateHexColorOpaque() },
	LOVE = { id = "LOVE", order = 5, texture = TRP3_InterfaceIcons.RelationLove, color = TRP3_API.Colors.Pink:GenerateHexColorOpaque() },
	FAMILY = { id = "FAMILY", order = 6, texture = TRP3_InterfaceIcons.RelationFamily, color = TRP3_API.CreateColor(1, 0.75, 0):GenerateHexColorOpaque() },
};
local ACTIONS = {
	DELETE= "DEL",
	EDIT= "EDT",
};

--getRelationList function should get relations stored in config, or default relations if none are stored
local function getRelationList(sorted)
	local relationList = TRP3_API.configuration.getValue("register_relation_list");
	if not relationList then
		relationList = CopyTable(DEFAULT_RELATIONS);
		TRP3_API.configuration.setValue("register_relation_list", relationList);
	end

	if not sorted then
		return relationList;
	else
		-- Using a table with int keys for sorting
		local relationsSorted = {};
		for _, relation in pairs(relationList) do
			tinsert(relationsSorted, relation);
		end
		table.sort(relationsSorted, function(a,b) return a.order < b.order end);

		return relationsSorted;
	end
end
TRP3_API.register.relation.getRelationList = getRelationList;

--getRelationInfo function should get relation info from relationList, or default relation info if relation is not in relationList
local function getRelationInfo(relation)
	if not relation then
		return DEFAULT_RELATIONS.NONE;
	end
	if relation.id then
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
	local profile = TRP3_API.profile.getPlayerCurrentProfile();
	if not profile.relation then
		profile.relation = {};
	end
	profile.relation[profileID] = relation;
end
TRP3_API.register.relation.setRelation = setRelation;

local function getRelation(profileID)
	local relationTab = TRP3_API.profile.getData("relation") or EMPTY;
	return getRelationInfo(relationTab[profileID]);
end
TRP3_API.register.relation.getRelation = getRelation;

local function getRelationText(profileID)
	local relation = getRelation(profileID);
	if relation.id == getRelation().id then
		return "";
	end
	return relation.name or loc:GetText("REG_RELATION_" .. relation.id);
end
TRP3_API.register.relation.getRelationText = getRelationText;


local function getRelationTooltipText(profileID, profile)
	local description = getRelation(profileID).description or loc:GetText("REG_RELATION_" .. getRelation(profileID).id .. "_TT");
	local player = TRP3_API.register.getPlayerCompleteName(true);
	local target = TRP3_API.register.getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true);
	return description:format(player, target);
end
TRP3_API.register.relation.getRelationTooltipText = getRelationTooltipText;

local function getRelationTexture(profileID)
	return getRelation(profileID).texture;
end
TRP3_API.register.relation.getRelationTexture = getRelationTexture;

local function getRelationColors(profileID)
	local relation = getRelation(profileID);
	if relation.color then
		return TRP3_API.CreateColorFromHexString(relation.color);
	end
end
TRP3_API.register.relation.getRelationColors = getRelationColors;

local function getColor(relation)
	local relationColor = getRelationInfo(relation).color;
	if relationColor then
		return TRP3_API.CreateColorFromHexString(relationColor);
	end
end
TRP3_API.register.relation.getColor = getColor;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function checkRelationUse()
	local relationList = getRelationList();
	for _, relation in pairs(relationList) do
		relation.inUse = false;
	end
	local profiles = TRP3_API.profile.getProfiles();
	for _, profile in pairs(profiles) do
		local relations = TRP3_API.profile.getData("relation", profile);
		if not relations then
			relations = {};
		end
		for _, relation in pairs(relations) do
			getRelationInfo(relation).inUse = true;
		end
	end
end

local draftRelationTexture;

-- Init the relation popup
local function initRelationEditor(relationID)
	if relationID then
		TRP3_RelationsList.Editor.Content.Title:SetText(loc.CO_RELATIONS_MENU_EDIT);
	else
		TRP3_RelationsList.Editor.Content.Title:SetText(loc.CO_RELATIONS_NEW);
	end
	TRP3_RelationsList.Editor.Content.ID = relationID;

	local relation;
	if relationID then
		relation = getRelationInfo(relationID);
	else
		relation = { name = "", description = "" };
	end
	draftRelationTexture = relation.texture or TRP3_InterfaceIcons.ProfileDefault;
	-- set icon, name, description, color
	TRP3_API.ui.frame.setupIconButton(TRP3_RelationsList.Editor.Content.Icon, relation.texture or TRP3_InterfaceIcons.ProfileDefault);
	TRP3_RelationsList.Editor.Content.Icon:SetScript("OnClick", function()
		TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {function(icon)
			draftRelationTexture = icon;
			TRP3_API.ui.frame.setupIconButton(TRP3_RelationsList.Editor.Content.Icon, icon or TRP3_InterfaceIcons.Default);
		end, nil, nil, draftRelationTexture});
	end);

	local nameText = relation.name;
	if not nameText then
		nameText = loc:GetText("REG_RELATION_" .. relation.id);
	end
	TRP3_RelationsList.Editor.Content.Name:SetText(nameText);

	local descriptionText = relation.description;
	if not descriptionText then
		descriptionText = loc:GetText("REG_RELATION_" .. relation.id .. "_TT");
	end
	TRP3_RelationsList.Editor.Content.Description:SetText(descriptionText:gsub("%%.$s", { ["%1$s"] = "%p", ["%2$s"] = "%t" }));

	if relation.color then
		TRP3_RelationsList.Editor.Content.Color.setColor(TRP3_API.CreateColorFromHexString(relation.color):GetRGBAsBytes());
	else
		TRP3_RelationsList.Editor.Content.Color.setColor(nil);
	end
end

function TRP3_API.register.relation.showEditor(relationID)
	TRP3_RelationsList.Editor:ClearAllPoints();
	TRP3_RelationsList.Editor:SetAllPoints(TRP3_MainFramePageContainer);
	TRP3_RelationsList.Editor:Show();

	initRelationEditor(relationID);
end

local updateRelationsList;

local function onActionSelected(selectedAction)
	local action = selectedAction:sub(1, 3);
	local relationID = selectedAction:sub(4);
	local relation = getRelationInfo(relationID);
	local originalRelation = (getColor(relation) or TRP3_API.Colors.White)(relation.name or loc:GetText("REG_RELATION_" .. relation.id));
	if action == ACTIONS.EDIT then
		TRP3_API.register.relation.showEditor(relation.id);
	elseif not relation.inUse and action == ACTIONS.DELETE then
		TRP3_API.popup.showConfirmPopup(loc.CO_RELATIONS_DELETE_WARNING:format(originalRelation), function()
			local relationList = getRelationList();
			local deletedOrder = relationList[relationID].order;
			relationList[relationID] = nil;
			-- Shift relation order to stay consecutive
			for _, relationToUpdate in pairs(relationList) do
				if relationToUpdate.order > deletedOrder then
					relationToUpdate.order = relationToUpdate.order - 1;
				end
			end
			updateRelationsList();
		end)
	end
end

local widgetsList = {};

function updateRelationsList()
	local relations = getRelationList(true);

	local widgetCount = 1;
	for _, relation in ipairs(relations) do
		local widget = widgetsList[widgetCount];
		if not widget then
			widget = CreateFrame("Frame", nil, TRP3_RelationsList.Inner.Scroll.Container, "TRP3_ConfigurationRelationsFrame");
			widget:ClearAllPoints();
			widget:SetPoint("LEFT", TRP3_RelationsList.Inner.Scroll.Container, "LEFT", 0, 0);
			widget:SetPoint("RIGHT", TRP3_RelationsList.Inner.Scroll.Container, "RIGHT", -10, 0);
			if widgetCount > 1 then
				widget:SetPoint("TOP", widgetsList[widgetCount - 1], "BOTTOM", 0, 0);
			else
				widget:SetPoint("TOP", TRP3_RelationsList.Inner.Scroll.Container, "TOP", 0, 0);
				widget.Actions:Hide();
			end
			widgetsList[widgetCount] = widget;
		end
		widget.Title:SetText((getColor(relation) or TRP3_API.Colors.White)(relation.name or loc:GetText("REG_RELATION_"..relation.id)));
		widget.Text:SetText(loc:GetText(relation.description or "REG_RELATION_" .. relation.id .. "_TT"):format("%p", "%t"));
		TRP3_API.ui.frame.setupIconButton(widget.Icon, relation.texture or TRP3_InterfaceIcons.ProfileDefault);
		widget.Actions:SetScript("OnClick", function(button)
			local values = {};
			table.insert(values, {loc.CO_RELATIONS_MENU_EDIT, ACTIONS.EDIT..relation.id});
			checkRelationUse();
			if not relation.inUse then
				table.insert(values, {loc.CO_RELATIONS_MENU_DELETE, ACTIONS.DELETE..relation.id});
			end
			TRP3_API.ui.listbox.displayDropDown(button, values, onActionSelected, 0, true);
		end);
		widget:Show();

		widgetCount = widgetCount + 1;
	end

	if widgetCount <= #widgetsList then
		for i = widgetCount, #widgetsList do
			widgetsList[i]:Hide();
		end
	end
end

local function saveCurrentRelation()
	if not TRP3_API.utils.str.emptyToNil(TRP3_RelationsList.Editor.Content.Name:GetText()) then
		TRP3_API.utils.message.displayMessage(loc.CO_RELATIONS_NEW_ERROR, TRP3_API.utils.message.type.ALERT_MESSAGE);
		return
	end

	local relationToUpdate;
	if TRP3_RelationsList.Editor.Content.ID then
		relationToUpdate = getRelationInfo(TRP3_RelationsList.Editor.Content.ID);
	else
		-- Create new
		local relationList = getRelationList();
		local i = 1;
		local newID = "CUSTOM" .. i;
		while relationList[newID] do
			i = i + 1;
			newID = "CUSTOM" .. i;
		end
		local maxOrder = 0;
		for _, relation in pairs(relationList) do
			if relation.order > maxOrder then
				maxOrder = relation.order;
			end
		end
		relationToUpdate = {
			id = newID,
			order = maxOrder + 1,
			inUse = false,
		};
		relationList[newID] = relationToUpdate;
	end
	relationToUpdate.texture = draftRelationTexture;
	relationToUpdate.name = TRP3_RelationsList.Editor.Content.Name:GetText();
	relationToUpdate.description = TRP3_RelationsList.Editor.Content.Description:GetText():gsub("%%p", '%%1$s'):gsub("%%t", '%%2$s');
	if TRP3_RelationsList.Editor.Content.Color.red and TRP3_RelationsList.Editor.Content.Color.green and TRP3_RelationsList.Editor.Content.Color.blue then
		relationToUpdate.color = TRP3_API.CreateColorFromBytes(TRP3_RelationsList.Editor.Content.Color.red, TRP3_RelationsList.Editor.Content.Color.green, TRP3_RelationsList.Editor.Content.Color.blue):GenerateHexColorOpaque();
	else
		relationToUpdate.color = nil;
	end

	updateRelationsList();
	TRP3_RelationsList.Editor:Hide();
	TRP3_API.popup.hidePopups();
end

local RELATIONS_PAGE_ID = "main_config_relations";
local RELATIONS_MENU_ID = "main_41_customization_relations";

TRP3_API.register.inits.relationsInit = function()
	local configDefault = CopyTable(DEFAULT_RELATIONS);
	TRP3_API.configuration.registerConfigKey("register_relation_list", configDefault);

	-- Register menu
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()

		TRP3_RelationsList.Title:SetText(loc.CO_RELATIONS);
		TRP3_RelationsList.Inner.CreateNew:SetText(loc.CO_RELATIONS_NEW);
		TRP3_RelationsList.Editor.Content.CloseButton:SetScript("OnClick", function()
			TRP3_RelationsList.Editor:Hide();
			TRP3_API.popup.hidePopups();
		end);
		TRP3_RelationsList.Editor.Content.Name.title:SetText(loc.CM_NAME);
		TRP3_RelationsList.Editor.Content.Description.title:SetText(loc.CO_RELATIONS_DESCRIPTION);
		TRP3_API.ui.tooltip.setTooltipForSameFrame(TRP3_RelationsList.Editor.Content.Description.help, "RIGHT", 0, 5, loc.CO_RELATIONS_DESCRIPTION, loc.CO_RELATIONS_DESCRIPTION_TT);
		TRP3_RelationsList.Editor.Content.Save:SetText(loc.CM_SAVE);
		TRP3_RelationsList.Editor.Content.Save:SetScript("OnClick", function()
			saveCurrentRelation();
		end);

		updateRelationsList();

		TRP3_API.navigation.page.registerPage({
			id = RELATIONS_PAGE_ID,
			frame = TRP3_RelationsList,
		});

		TRP3_API.navigation.menu.registerMenu({
			id = "main_40_customization",
			text = loc.CO_CUSTOMIZATION,
			onSelected = function()
				TRP3_API.navigation.menu.selectMenu(RELATIONS_MENU_ID);
			end,
		});
		TRP3_API.navigation.menu.registerMenu({
			id = RELATIONS_MENU_ID,
			text = loc.CO_RELATIONS,
			isChildOf = "main_40_customization",
			onSelected = function()
				TRP3_API.navigation.page.setPage(RELATIONS_PAGE_ID);
				TRP3_RelationsList.Inner.Scroll.Container:SetWidth(TRP3_RelationsList.Inner.Scroll:GetWidth());
			end,
		});
	end)

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.NAVIGATION_RESIZED, function(_)
		TRP3_RelationsList.Inner.Scroll.Container:SetWidth(TRP3_RelationsList.Inner.Scroll:GetWidth());
	end);
end
