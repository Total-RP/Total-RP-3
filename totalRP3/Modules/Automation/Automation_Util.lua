-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local hasRegisteredSettings;

TRP3_AutomationUtil = {};

function TRP3_AutomationUtil.RegisterAction(action)
	TRP3_Automation:RegisterAction(action);
end

function TRP3_AutomationUtil.RegisterCondition(condition)
	TRP3_Automation:RegisterCondition(condition);
end

function TRP3_AutomationUtil.GetRegisteredActions()
	local actions = {};

	for actionID in TRP3_Automation:EnumerateActions() do
		table.insert(actions, TRP3_AutomationUtil.GetActionByID(actionID));
	end

	return actions;
end

function TRP3_AutomationUtil.GetRegisteredConditions()
	local conditions = {};

	for conditionID in TRP3_Automation:EnumerateConditions() do
		table.insert(conditions, TRP3_AutomationUtil.GetConditionByID(conditionID));
	end

	return conditions;
end

function TRP3_AutomationUtil.GetActionByID(actionID)
	local action = TRP3_Automation:GetActionByID(actionID);

	if action then
		local shallow = true;
		action = CopyTable(action, shallow);
		action.expression = TRP3_Automation:GetActionExpression(actionID);
	end

	return action;
end

function TRP3_AutomationUtil.GetConditionByID(conditionID)
	local condition = TRP3_Automation:GetConditionByID(conditionID);

	if condition then
		local shallow = true;
		condition = CopyTable(condition, shallow);
	end

	return condition;
end

function TRP3_AutomationUtil.GetConditionByToken(conditionName)
	local condition = TRP3_Automation:GetConditionByToken(conditionName);

	if condition then
		local shallow = true;
		condition = CopyTable(condition, shallow);
	end

	return condition;
end

function TRP3_AutomationUtil.GetActionExpression(actionID)
	local action = TRP3_Automation:GetActionByID(actionID);
	local expression;

	if action ~= nil then
		expression = TRP3_Automation:GetActionExpression(actionID);
	end

	return expression;
end

function TRP3_AutomationUtil.SetActionExpression(actionID, expression)
	local action = TRP3_Automation:GetActionByID(actionID);

	if action ~= nil then
		TRP3_Automation:SetActionExpression(actionID, expression);
	end
end

function TRP3_AutomationUtil.ParseMacroOption(expression)
	return TRP3_Automation:ParseMacroOption(expression);
end

--
-- String formatting utilities
--

local function GenerateOptionList(...)
	local options = { ... };

	for index, option in ipairs(options) do
		options[index] = string.format("|cff33ff99%s|r", option);
	end

	return options;
end

-- These state string tables are only used for error reporting; the exact
-- matched strings may vary a bit - for example booleans also accept any
-- string beginning with "t" or "f" for true/false.

TRP3_AutomationUtil.BOOLEAN_OPTIONS = GenerateOptionList("1", "0", "on", "off", "true", "false", "nochange");
TRP3_AutomationUtil.ROLEPLAY_STATUS_OPTIONS = GenerateOptionList("ic", "ooc", "nochange");

function TRP3_AutomationUtil.FormatOptionError(str, options)
	return string.format(L.AUTOMATION_ERROR_INVALID_OPTION, str, table.concat(options, LIST_DELIMITER));
end

function TRP3_AutomationUtil.FormatOptionHelp(options)
	return string.format(L.AUTOMATION_ACTION_OPTIONS_HELP, table.concat(options, LIST_DELIMITER));
end

--
-- String processing utilities
--

function TRP3_AutomationUtil.ParseBooleanString(str)
	if str == "nochange" or str == L.AUTOMATION_STATE_UNSET then
		return true, nil;
	else
		-- Will return nil if the supplied string is ambiguous.
		local state = StringToBoolean(str);
		return (state ~= nil), state;
	end
end

function TRP3_AutomationUtil.ParseRoleplayStatusString(str)
	if str == "ic" or str == L.AUTOMATION_STATE_IC then
		return true, AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
	elseif str == "ooc" or str == L.AUTOMATION_STATE_OOC then
		return true, AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
	elseif str == "nochange" or str == L.AUTOMATION_STATE_UNSET then
		return true, nil;
	else
		return false;
	end
end

--
-- Settings utilities
--

local SETTINGS_PAGE_ID = "main_automation";
local SETTINGS_MENU_ID = "main_91_config_main_config_automation";

function TRP3_AutomationUtil.OpenSettingsPage()
	if hasRegisteredSettings then
		TRP3_API.navigation.page.setPage(SETTINGS_PAGE_ID);
	end
end

function TRP3_AutomationUtil.RegisterSettingsPage()
	if hasRegisteredSettings then
		return;
	end

	TRP3_API.navigation.page.registerPage({
		id = SETTINGS_PAGE_ID,
		templateName = "TRP3_AutomationSettingsTemplate",
		frameName = "TRP3_AutomationSettingsFrame",
	});

	TRP3_API.navigation.menu.registerMenu({
		id = SETTINGS_MENU_ID,
		text = L.AUTOMATION_MODULE_NAME,
		isChildOf = "main_90_config",
		onSelected = function() TRP3_API.navigation.page.setPage(SETTINGS_PAGE_ID); end,
	});

	hasRegisteredSettings = true;
end
