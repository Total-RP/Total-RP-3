-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local AceDB = LibStub:GetLibrary("AceDB-3.0");

local AUTOMATION_UPDATE_THROTTLE = 1;
local AUTOMATION_MESSAGE_THROTTLE = 5;

local SavedAutomationDefaults = {
	profile = {
		actions = {
			["**"] = {
				expression = "",
			},
		},
	},
};

local BaseContext = {};

function BaseContext:Error(message)
	TRP3_Automation:OnContextError(message);
end

function BaseContext:Errorf(format, ...)
	TRP3_Automation:OnContextError(string.format(format, ...));
end

function BaseContext:Print(message)
	TRP3_Automation:OnContextMessage(message);
end

function BaseContext:Printf(format, ...)
	TRP3_Automation:OnContextMessage(string.format(format, ...));
end

local ConditionContext = CreateFromMixins(BaseContext);

function ConditionContext:__init(condition, option)
	self.condition = condition;
	self.option = option;
end

local function CreateConditionContext(condition, option)
	return TRP3_API.CreateObject(ConditionContext, condition, option);
end

local ActionContext = CreateFromMixins(BaseContext);

function ActionContext:__init(action, option)
	self.action = action;
	self.option = option;
end

function ActionContext:Apply(...)
	self.action.Apply(self, ...);
end

local function CreateActionContext(action, option)
	return TRP3_API.CreateObject(ActionContext, action, option);
end

TRP3_Automation = TRP3_Addon:NewModule("Automation", "AceConsole-3.0");

function TRP3_Automation:OnLoad()
	self.actionsByID = {};
	self.conditionsByID = {};
	self.conditionsByToken = {};
	self.messageCooldowns = {};
	self.monitor = CreateFrame("Frame");
	self.monitor:SetScript("OnEvent", function() self:OnDirtyEvent(); end);
	self.settersByField = {};

	self:SetEnabledState(false);
end

function TRP3_Automation:OnInitialize()
	local useDefaultProfile = true;
	self.db = AceDB:New("TRP3_SavedAutomation", SavedAutomationDefaults, useDefaultProfile);
	self.db.RegisterCallback(self, "OnProfileChanged");
	self.db.RegisterCallback(self, "OnProfileCopied");
	self.db.RegisterCallback(self, "OnProfileDeleted");
	self.db.RegisterCallback(self, "OnProfileReset");

	-- The initial implementation of automation used one settings table
	-- without profile support. For users with saved automation rules, we
	-- need to import them into the new profile-based system.

	if TRP3_SavedAutomation.actions then
		for actionID, actionSettings in pairs(TRP3_SavedAutomation.actions) do
			self.db.profile.actions[actionID].expression = actionSettings.expression;
		end

		TRP3_SavedAutomation.actions = nil;
	end

	TRP3_API.slash.registerCommand({
		id = "set",
		helpLine = " " .. L.SLASH_CMD_SET_HELP,
		handler = GenerateClosure(self.OnFieldSetCommand, self),
	});
end

function TRP3_Automation:OnEnable()
	-- The monitor frame listens to a set of events that can trigger changes to
	-- builtin macro conditions and will trigger a deferred evaluation of all
	-- actions at the end of the current frame if any of these fire.

	self.monitor:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- Disabled due to a client performance issue in Classic Wrath.
	-- self.monitor:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	self.monitor:RegisterEvent("UPDATE_STEALTH");
	self.monitor:RegisterEvent("PLAYER_TARGET_CHANGED");
	self.monitor:RegisterEvent("PLAYER_FOCUS_CHANGED");
	self.monitor:RegisterEvent("PLAYER_REGEN_DISABLED");
	self.monitor:RegisterEvent("PLAYER_REGEN_ENABLED");
	self.monitor:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED");

	-- We'll update all configured actions periodically at a slower rate if no
	-- specific event occurs otherwise.

	self.ticker = C_Timer.NewTicker(AUTOMATION_UPDATE_THROTTLE, function() self:OnDirtyUpdate(); end);
end

function TRP3_Automation:OnDisable()
	self.monitor:UnregisterAllEvents();

	self.ticker:Cancel();
	self.ticker = nil;
end

function TRP3_Automation:OnProfileChanged(_, _, profileName)
	TRP3_AutomationEvents:TriggerEvent("OnProfileChanged", profileName);
end

function TRP3_Automation:OnProfileCopied()
	TRP3_AutomationEvents:TriggerEvent("OnProfileModified", self.db:GetCurrentProfile());
end

function TRP3_Automation:OnProfileDeleted(_, _, profileName)
	TRP3_AutomationEvents:TriggerEvent("OnProfileDeleted", profileName);
end

function TRP3_Automation:OnProfileReset()
	TRP3_AutomationEvents:TriggerEvent("OnProfileModified", self.db:GetCurrentProfile());
end

function TRP3_Automation:OnDirtyEvent()
	self:MarkDirty();
end

function TRP3_Automation:OnDirtyUpdate()
	self:ProcessAllActions();
end

function TRP3_Automation:OnContextError(message)
	local expirationTime = self.messageCooldowns[message] or -math.huge;
	local currentTime = GetTime();

	if expirationTime <= currentTime then
		self.messageCooldowns[message] = currentTime + AUTOMATION_MESSAGE_THROTTLE;
		TRP3_Addon:Print(message);
	end
end

function TRP3_Automation:OnContextMessage(message)
	TRP3_Addon:Print(message);
end

function TRP3_Automation:GetAllProfiles()
	return self.db:GetProfiles();
end

function TRP3_Automation:GetCurrentProfile()
	return self.db:GetCurrentProfile();
end

function TRP3_Automation:SetCurrentProfile(profileName)
	self.db:SetProfile(profileName);
end

function TRP3_Automation:DeleteProfile(profileName)
	local silent = true;
	self.db:DeleteProfile(profileName, silent);
end

function TRP3_Automation:CopyProfile(profileName)
	local silent = true;
	self.db:CopyProfile(profileName, silent);
end

function TRP3_Automation:ResetCurrentProfile()
	self.db:ResetProfile();
end

function TRP3_Automation:RegisterAction(action)
	assert(type(action) == "table", "attempted to register an invalid action: expected table");
	assert(type(action.id) == "string", "attempted to register an invalid action: 'id' field must be a string");
	assert(type(action.ParseOption) == "function", "attempted to register an invalid action: 'ParseOption' field must be a function");
	assert(type(action.Apply) == "function", "attempted to register an invalid action: 'Apply' field must be a function");
	assert(not self.actionsByID[action.id], "attempted to register a duplicate action");

	self.actionsByID[action.id] = action;
end

function TRP3_Automation:RegisterCondition(condition)
	assert(type(condition) == "table", "attempted to register an invalid condition: expected table");
	assert(type(condition.id) == "string", "attempted to register an invalid condition: 'id' field must be a string");
	assert(type(condition.tokens) == "table", "attempted to register an invalid condition: 'tokens' field must be a table");
	assert(type(condition.Evaluate) == "function", "attempted to register an invalid condition: 'Evaluate' field must be a function");
	assert(not self.conditionsByID[condition.id], "attempted to register a duplicate condition");

	for _, token in ipairs(condition.tokens) do
		assert(not self.conditionsByToken[token], "attempted to register a duplicate condition token");
	end

	self.conditionsByID[condition.id] = condition;

	for _, token in ipairs(condition.tokens) do
		self.conditionsByToken[token] = condition;
	end
end

function TRP3_Automation:EnumerateActions()
	return pairs(self.actionsByID);
end

function TRP3_Automation:EnumerateConditions()
	return pairs(self.conditionsByID);
end

function TRP3_Automation:GetActionByID(actionID)
	return self.actionsByID[actionID];
end

function TRP3_Automation:GetConditionByID(conditionID)
	return self.conditionsByID[conditionID];
end

function TRP3_Automation:GetConditionByToken(conditionToken)
	return self.conditionsByToken[conditionToken];
end

function TRP3_Automation:GetActionExpression(actionID)
	local actionSettings = self.db.profile.actions[actionID];
	local actionExpression = "";

	if actionSettings then
		actionExpression = actionSettings.expression;
	end

	return actionExpression;
end

function TRP3_Automation:SetActionExpression(actionID, expression)
	self.db.profile.actions[actionID].expression = string.trim(expression or "");
	TRP3_AutomationEvents:TriggerEvent("OnProfileModified", self.db:GetCurrentProfile());
	self:ResetMessageCooldowns();
	self:MarkDirty();
end

function TRP3_Automation:ResetMessageCooldowns()
	self.messageCooldowns = {};
end

function TRP3_Automation:MarkDirty()
	self.monitor:SetScript("OnUpdate", function() self:ProcessAllActions(); end);
end

function TRP3_Automation:MarkClean()
	self.monitor:SetScript("OnUpdate", nil);
end

function TRP3_Automation:ProcessAction(actionID)
	local action = self:GetActionByID(actionID);
	local expression = self:GetActionExpression(actionID);

	if expression == "" then
		return;  -- Not configured.
	end

	local option = self:ParseMacroOption(expression);
	local context = CreateActionContext(action, option);
	securecallfunction(action.ParseOption, context);
end

function TRP3_Automation:ProcessAllActions()
	self:MarkClean();

	for actionID in self:EnumerateActions() do
		self:ProcessAction(actionID);
	end
end

-- Options parsing is handled by SecureCmdOptionParse to avoid re-implementing
-- parsing logic.
--
-- For custom conditionals our work is limited to scanning a given options
-- string to find conditions, evaluating them, and then replacing their
-- tokens in the option string with Blizzard-provided states that are known
-- ahead-of-time to evaluate to true or false as necessary.
--
-- Evaluation of a conditional occurs once per unique combination of a
-- conditional name and associated data string, eg. "[ooc][ooc]" would only
-- evaluate the "ooc" condition a single time and will cache the result.

local function EvaluateCustomCondition(self, text)
	local token, option = string.split(":", text, 2);
	local invert = false;

	token = string.trim(token or "");
	option = string.trim(option or "");

	if string.find(token, "^no") then
		token = string.trim(string.sub(token, 3));
		invert = true;
	end

	local condition = self:GetConditionByToken(token);

	if not condition then
		return;  -- Leave unmodified; SecureCmdOptionParse will tell the user.
	end

	local context = CreateConditionContext(condition, option);
	local state = securecallfunction(condition.Evaluate, context);
	return state ~= invert;
end

local function EvaluateAllCustomConditions(self, expression)
	local TRUE_STATE = SecureCmdOptionParse("[combat]combat;nocombat");
	local FALSE_STATE = SecureCmdOptionParse("[nocombat]combat;nocombat");

	local cache = setmetatable({}, {
		__index = function(cache, text)  -- luacheck: ignore 432 (shadowing cache)
			local state = EvaluateCustomCondition(self, text);
			local replacement;

			if state ~= nil then
				replacement = state and TRUE_STATE or FALSE_STATE;
				cache[text] = replacement;
			end

			return replacement;
		end,
	});

	local function EvaluateConditionBlock(text)
		text = string.sub(text, 2, -2);
		return "[" .. string.gsub(text, "[^,%]]+", cache) .. "]";
	end

	return string.gsub(expression, "%b[]", EvaluateConditionBlock);
end

function TRP3_Automation:ParseMacroOption(expression)
	local modifiedExpression = EvaluateAllCustomConditions(self, expression);
	return string.trim(SecureCmdOptionParse(modifiedExpression) or "");
end

-- Field Setters (/trp3 set)
------------------------------------------------------------------------------

function TRP3_Automation:RegisterFieldSetter(field, handler)
	assert(not self.settersByField[field]);
	self.settersByField[field] = handler;
end

function TRP3_Automation:GetFieldSetter(field)
	return self.settersByField[field];
end

function TRP3_Automation:GetFieldSetterNames()
	local names = {};

	for field in pairs(self.settersByField) do
		table.insert(names, field);
	end

	table.sort(names);

	return names;
end

function TRP3_Automation:IsFieldSetterKnown(field)
	return self.settersByField[field] ~= nil;
end

function TRP3_Automation:OnFieldSetCommand(field, ...)
	field = string.trim(field or "");
	local data = string.trim(string.join(" ", ...));

	if string.find(data, "^%[") then
		data = self:ParseMacroOption(data);
	end

	local player = AddOn_TotalRP3.Player.GetCurrentUser();

	if field == "" or field == "help" then
		local STEM_COLOR = "ffffffff"
		local ARG1_COLOR = "ffffcc00"
		local ARG2_COLOR = "ffcccccc"
		local ARG3_COLOR = "ff82c5ff"

		local stem = WrapTextInColorCode("/trp3 set", STEM_COLOR);
		local arg1 = WrapTextInColorCode(L.SLASH_CMD_SET_HELP_ARG1, ARG1_COLOR);
		local arg2 = WrapTextInColorCode(L.SLASH_CMD_SET_HELP_ARG2, ARG2_COLOR);
		local arg3 = WrapTextInColorCode(L.SLASH_CMD_SET_HELP_ARG3, ARG3_COLOR);

		local examples = {
			"",  -- Empty initial line to force a break.
			string.join(" ", stem, WrapTextInColorCode("currently", ARG1_COLOR), WrapTextInColorCode(L.SLASH_CMD_SET_HELP_EXAMPLE1, ARG3_COLOR)),
			string.join(" ", stem, WrapTextInColorCode("title", ARG1_COLOR), WrapTextInColorCode("[form:1]", ARG2_COLOR), WrapTextInColorCode(L.SLASH_CMD_SET_HELP_EXAMPLE2, ARG3_COLOR)),
			string.join(" ", stem, WrapTextInColorCode("classcolor", ARG1_COLOR), WrapTextInColorCode("#ff0000", ARG3_COLOR)),
		};

		TRP3_Addon:Print(string.format(L.SLASH_CMD_HELP_USAGE, string.join(" ", stem, arg1, arg2, arg3)));
		TRP3_Addon:Print(string.format(L.SLASH_CMD_HELP_FIELDS, WrapTextInColorCode(table.concat(self:GetFieldSetterNames(), LIST_DELIMITER), ARG1_COLOR)));
		TRP3_Addon:Print(string.format(L.SLASH_CMD_HELP_EXAMPLES, table.concat(examples, "|n")));
	elseif not self:IsFieldSetterKnown(field) then
		TRP3_Addon:Print(string.format(L.SLASH_CMD_SET_FAILED_INVALID_FIELD, field));
	elseif player:IsProfileDefault() then
		TRP3_Addon:Print(L.SLASH_CMD_SET_FAILED_DEFAULT_PROFILE);
	else
		local setter = self:GetFieldSetter(field);
		local ok, err = setter(player, field, data);

		if ok then
			TRP3_Addon:Print(string.format(L.SLASH_CMD_SET_SUCCESS, field));
		else
			TRP3_Addon:Print(err);
		end
	end
end

-- Module registration
------------------------------------------------------------------------------

TRP3_Automation:OnLoad();

TRP3_API.module.registerModule({
	id = "trp3_automation",
	name = L.AUTOMATION_MODULE_NAME,
	description = L.AUTOMATION_MODULE_DESCRIPTION,
	version = 1,
	hotReload = true,

	onStart = function()
		TRP3_Automation:Enable();
		TRP3_AutomationUtil.RegisterSettingsPage();
	end,

	onDisable = function()
		TRP3_Automation:Disable();
	end,
});
