-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3_API.loc;
local EMPTY = TRP3_API.globals.empty;
local getProfile = TRP3_API.register.getProfile;
local hasProfile = TRP3_API.register.hasProfile;
local getUnitID = TRP3_API.utils.str.getUnitID;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll
local setupIconButton = TRP3_API.ui.frame.setupIconButton;

TRP3_API.register.relation = {};

local GetRelationsList = TRP3_FunctionUtil.GetOrCreate(function()
	return CreateFrame("Frame", nil, TRP3_MainFramePageContainer, "TRP3_RelationsListTemplate");
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Relation
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function GenerateFormattedDescription(description, player, target)
	-- Players may enter arbitrary '%' signs into descriptions, and as such
	-- we should avoid using string.format as it may blow up catastrophically.
	--
	-- As such - we just gsub the two exact format string tokens that we're
	-- looking for with the intended replacements.

	local replacements = {
		["%1$s"] = player,
		["%2$s"] = target,
	};

	return (string.gsub(description, "%%[12]$s", replacements));
end

local function GenerateEditDescription(description)
	return GenerateFormattedDescription(description, "%p", "%t");
end

local DEFAULT_RELATIONS = {
	NONE = { id = "NONE", order = 0, texture = TRP3_InterfaceIconIDs.RelationNone },
	UNFRIENDLY = { id = "UNFRIENDLY", order = 1, texture = TRP3_InterfaceIconIDs.RelationUnfriendly, color = TRP3_API.RelationColors.Unfriendly:GenerateHexColorOpaque() },
	NEUTRAL = { id = "NEUTRAL", order = 2, texture = TRP3_InterfaceIconIDs.RelationNeutral, color = TRP3_API.RelationColors.Neutral:GenerateHexColorOpaque() },
	BUSINESS = { id = "BUSINESS", order = 3, texture = TRP3_InterfaceIconIDs.RelationBusiness, color = TRP3_API.RelationColors.Business:GenerateHexColorOpaque() },
	FRIEND = { id = "FRIEND", order = 4, texture = TRP3_InterfaceIconIDs.RelationFriend, color = TRP3_API.RelationColors.Friend:GenerateHexColorOpaque() },
	LOVE = { id = "LOVE", order = 5, texture = TRP3_InterfaceIconIDs.RelationLove, color = TRP3_API.RelationColors.Love:GenerateHexColorOpaque() },
	FAMILY = { id = "FAMILY", order = 6, texture = TRP3_InterfaceIconIDs.RelationFamily, color = TRP3_API.RelationColors.Family:GenerateHexColorOpaque() },
};

local ACTIONS = {
	DELETE = "DEL",
	EDIT = "EDT",
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

local function getRelationText(profileID, ignoreNone)
	local relation = getRelation(profileID);
	if relation.id == DEFAULT_RELATIONS.NONE.id and ignoreNone then
		return "";
	end
	return relation.name or loc:GetText("REG_RELATION_" .. relation.id);
end
TRP3_API.register.relation.getRelationText = getRelationText;

local function getRelationTooltipText(profileID, profile)
	local description = getRelation(profileID).description or loc:GetText("REG_RELATION_" .. getRelation(profileID).id .. "_TT");
	local player = TRP3_API.register.getPlayerCompleteName(true);
	local target = TRP3_API.register.getCompleteName(profile.characteristics or EMPTY, UNKNOWN, true);
	return GenerateFormattedDescription(description, player, target);
end
TRP3_API.register.relation.getRelationTooltipText = getRelationTooltipText;

local function getRelationTexture(profileID)
	return getRelation(profileID).texture;
end
TRP3_API.register.relation.getRelationTexture = getRelationTexture;

local function getRelationColor(profileID)
	local relation = getRelation(profileID);
	if relation.color then
		return TRP3_API.CreateColorFromHexString(relation.color);
	end
end
TRP3_API.register.relation.getRelationColor = getRelationColor;

local function getColor(relation)
	local relationColor = getRelationInfo(relation).color;
	if relationColor then
		return TRP3_API.CreateColorFromHexString(relationColor);
	end
end
TRP3_API.register.relation.getColor = getColor;

local draftRelationTexture;

--- pasteCopiedIcon handles receiving an icon from the right-click menu.
---@param frame Frame The frame the icon belongs to.
---@param copiedIcon string? The icon supplied by the right-click menu.
local function pasteCopiedIcon(frame, copiedIcon)
	local icon = copiedIcon or TRP3_InterfaceIconIDs.ProfileDefault;
	draftRelationTexture = icon;
	setupIconButton(frame, icon);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function removeRelationFromProfiles(relationID)
	local profiles = TRP3_API.profile.getProfiles();
	for _, profile in pairs(profiles) do
		local relations = TRP3_API.profile.getData("relation", profile);
		if relations then
			for profileID, profileRelationID in pairs(relations) do
				if profileRelationID == relationID then
					relations[profileID] = nil;
				end
			end
		end
	end
end

-- Init the relation popup
local function initRelationEditor(relationID)
	local TRP3_RelationsList = GetRelationsList();
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
	draftRelationTexture = relation.texture or TRP3_InterfaceIconIDs.ProfileDefault;
	-- set icon, name, description, color
	setupIconButton(TRP3_RelationsList.Editor.Content.Icon, draftRelationTexture);
	setTooltipAll(TRP3_RelationsList.Editor.Content.Icon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	TRP3_RelationsList.Editor.Content.Icon:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {function(_iconName, iconInfo)
				draftRelationTexture = iconInfo.id;
				setupIconButton(TRP3_RelationsList.Editor.Content.Icon, iconInfo.id or TRP3_InterfaceIconIDs.ProfileDefault);
			end, nil, nil, draftRelationTexture});
		elseif button == "RightButton" then
			draftRelationTexture = draftRelationTexture or relation.texture or TRP3_InterfaceIconIDs.ProfileDefault;
			local handler = TRP3_MenuTemplates.CreateIconContextMenuHandler();
			handler:SetPasteCallback(function(copiedIcon) pasteCopiedIcon(TRP3_RelationsList.Editor.Content.Icon, copiedIcon); end);
			TRP3_MenuTemplates.CreateIconContextMenu(self, handler, draftRelationTexture);
		end
	end);

	local frame = TRP3_RelationsList.Editor;
	frame:SetScript("OnKeyDown", function(_, key)
		-- Do not steal input if we're in combat.
		if InCombatLockdown() then return; end

		if key == "ESCAPE" then
			PlaySound(TRP3_InterfaceSounds.PopupClose);
			frame:SetPropagateKeyboardInput(false);
			frame:Hide();
		else
			frame:SetPropagateKeyboardInput(true);
		end
	end);

	local nameText = relation.name;
	if not nameText then
		nameText = loc:GetText("REG_RELATION_" .. relation.id);
	end
	TRP3_RelationsList.Editor.Content.Name:SetText(nameText);
	TRP3_RelationsList.Editor.Content.Name:SetFocus();

	local descriptionText = relation.description;
	if not descriptionText then
		descriptionText = loc:GetText("REG_RELATION_" .. relation.id .. "_TT");
	end
	TRP3_RelationsList.Editor.Content.Description:SetText(GenerateEditDescription(descriptionText));

	setTooltipAll(TRP3_RelationsList.Editor.Content.Color, "RIGHT", 0, 5, loc.CO_RELATIONS_NEW_COLOR, loc.CO_RELATIONS_NEW_COLOR_TT
	.. "|n|n" .. TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.REG_PLAYER_COLOR_TT_SELECT)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_COLOR_TT_OPTIONS)
	.. "|n" .. TRP3_API.FormatShortcutWithInstruction("SHIFT-CLICK", loc.REG_PLAYER_COLOR_TT_DEFAULTPICKER));
	if relation.color then
		TRP3_RelationsList.Editor.Content.Color.setColor(TRP3_API.CreateColorFromHexString(relation.color):GetRGBAsBytes());
	else
		TRP3_RelationsList.Editor.Content.Color.setColor(nil);
	end
end

function TRP3_API.register.relation.showEditor(relationID)
	local TRP3_RelationsList = GetRelationsList();
	TRP3_RelationsList.Editor:ClearAllPoints();
	TRP3_RelationsList.Editor:SetAllPoints(TRP3_MainFramePageContainer);
	TRP3_RelationsList.Editor:Show();

	initRelationEditor(relationID);
end

local function updateRelationsList(relationToScrollTo)
	local TRP3_RelationsList = GetRelationsList();

	local sorted = true;
	TRP3_RelationsList:SetDataProvider(CreateDataProvider(getRelationList(sorted)));

	if relationToScrollTo then
		TRP3_RelationsList.ScrollBox:ScrollToElementData(relationToScrollTo);
	end
end

local function onActionSelected(selectedAction)
	local action = selectedAction:sub(1, 3);
	local relationID = selectedAction:sub(4);
	local relation = getRelationInfo(relationID);
	local originalRelation = (getColor(relation) or TRP3_API.Colors.White)(relation.name or loc:GetText("REG_RELATION_" .. relation.id));
	if action == ACTIONS.EDIT then
		TRP3_API.register.relation.showEditor(relation.id);
	elseif action == ACTIONS.DELETE then
		TRP3_API.popup.showConfirmPopup(loc.CO_RELATIONS_DELETE_WARNING:format(originalRelation), function()
			local relationList = getRelationList();
			removeRelationFromProfiles(relationID);
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

local function ShowRelationEditor(_owner, relation)
	onActionSelected(ACTIONS.EDIT .. relation.id);
end

local function ShowRelationActionMenu(owner, relation)
	TRP3_MenuUtil.CreateContextMenu(owner, function(_, description)
		description:CreateTitle(relation.name or loc:GetText("REG_RELATION_" .. relation.id));
		description:CreateButton(loc.CO_RELATIONS_MENU_EDIT, onActionSelected, ACTIONS.EDIT .. relation.id);
		description:CreateButton("|cnRED_FONT_COLOR:" .. loc.CO_RELATIONS_MENU_DELETE .. "|r", onActionSelected, ACTIONS.DELETE .. relation.id);
	end);
end

local function saveCurrentRelation()
	local TRP3_RelationsList = GetRelationsList();
	if not TRP3_API.utils.str.emptyToNil(TRP3_RelationsList.Editor.Content.Name:GetText()) then
		TRP3_API.utils.message.displayMessage(loc.CO_RELATIONS_NEW_ERROR, TRP3_API.utils.message.type.ALERT_MESSAGE);
		return
	end

	local relationToUpdate;
	local isNewRelation = not TRP3_RelationsList.Editor.Content.ID;
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

	local relationToScrollTo = isNewRelation and relationToUpdate or nil;
	updateRelationsList(relationToScrollTo);
	TRP3_RelationsList.Editor:Hide();
	TRP3_API.popup.hidePopups();
end

local RELATIONS_PAGE_ID = "main_config_relations";
local RELATIONS_MENU_ID = "main_41_customization_relations";

local function onRelationSelected(value)
	local unitID = getUnitID("target");
	if hasProfile(unitID) then
		TRP3_API.register.relation.setRelation(hasProfile(unitID), value);
		TRP3_Addon:TriggerEvent(TRP3_Addon.Events.REGISTER_DATA_UPDATED, unitID, hasProfile(unitID), "characteristics");
	end
end

local function onTargetButtonClicked(_, _, _, button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		local relations = TRP3_API.register.relation.getRelationList(true);
		for _, thisRelation in ipairs(relations) do
			description:CreateButton(thisRelation.name or loc["REG_RELATION_" .. thisRelation.id], onRelationSelected, thisRelation.id);
		end
	end);
end

TRP3_API.register.inits.relationsInit = function()
	local configDefault = CopyTable(DEFAULT_RELATIONS);
	TRP3_API.configuration.registerConfigKey("register_relation_list", configDefault);

	-- Register target frame button
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
		if not TRP3_API.target then
			-- Target bar module disabled.
			return;
		end

		TRP3_API.target.registerButton({
			id = "aa_player_d_relation",
			configText = loc.REG_RELATION,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return UnitIsPlayer("target") and unitID ~= TRP3_API.globals.player_id and hasProfile(unitID);
			end,
			onClick = onTargetButtonClicked,
			adapter = function(buttonStructure, unitID)
				local profileID = hasProfile(unitID);
				local relationColoredName = getRelationText(profileID);
				local relationColor = TRP3_API.register.relation.getRelationColor(profileID);
				if relationColor then
					relationColoredName = relationColor:WrapTextInColorCode(relationColoredName);
				end
				buttonStructure.tooltip = loc.REG_RELATION .. ": " .. relationColoredName;
				buttonStructure.tooltipSub = TRP3_API.register.relation.getRelationTooltipText(profileID, getProfile(profileID)) .. "\n\n" .. TRP3_API.FormatShortcutWithInstruction("CLICK", loc.REG_RELATION_TARGET);
				buttonStructure.icon = TRP3_API.register.relation.getRelationTexture(profileID);
			end,
		});
	end);

	-- Register menu
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		local TRP3_RelationsList = GetRelationsList();

		TRP3_RelationsList.Title:SetText(loc.CO_RELATIONS);
		TRP3_RelationsList.CreateNew:SetText(loc.CO_RELATIONS_NEW);
		TRP3_RelationsList.Editor.Content.CloseButton:SetScript("OnClick", function()
			PlaySound(TRP3_InterfaceSounds.PopupClose);
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
		TRP3_API.ui.frame.setupEditBoxesNavigation({ TRP3_RelationsList.Editor.Content.Name, TRP3_RelationsList.Editor.Content.Description });
		TRP3_RelationsList:SetEditCallback(ShowRelationEditor);
		TRP3_RelationsList:SetMenuCallback(ShowRelationActionMenu);

		updateRelationsList();

		TRP3_API.navigation.page.registerPage({
			id = RELATIONS_PAGE_ID,
			frame = TRP3_RelationsList,
			tutorialProvider = function()
				return TRP3_RelationsList:GetTutorialStructure();
			end,
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
			end,
		});
	end)
end
