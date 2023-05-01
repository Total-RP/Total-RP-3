-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:rpstatus",
	category = L.AUTOMATION_CATEGORY_PROFILE,
	name = L.AUTOMATION_ACTION_ROLEPLAY_STATUS,
	description = L.AUTOMATION_ACTION_ROLEPLAY_STATUS_DESCRIPTION,
	help = TRP3_AutomationUtil.FormatOptionHelp(TRP3_AutomationUtil.ROLEPLAY_STATUS_OPTIONS),
	example = "[flying][instance] ooc; ic",

	ParseOption = function(context)
		local ok, status = TRP3_AutomationUtil.ParseRoleplayStatusString(context.option);

		if not ok then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.ROLEPLAY_STATUS_OPTIONS);
			context:Errorf(L.AUTOMATION_ACTION_ROLEPLAY_STATUS_ERROR, reason);
		else
			context:Apply(status);
		end
	end,

	Apply = function(context, status)
		local player = AddOn_TotalRP3.Player.GetCurrentUser();

		if status == nil then
			return;  -- User used the "unset" token which applies no change.
		elseif player:GetRoleplayStatus() == status then
			return;  -- Already in the desired state.
		end

		local statusText;

		if status == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER then
			statusText = L.AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_IC;
		else
			statusText = L.AUTOMATION_ACTION_ROLEPLAY_STATUS_CHANGED_OOC;
		end

		player:SetRoleplayStatus(status);
		context:Print(statusText);
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:profile",
	category = L.AUTOMATION_CATEGORY_PROFILE,
	name = L.AUTOMATION_ACTION_PROFILE_CHANGE,
	description = L.AUTOMATION_ACTION_PROFILE_CHANGE_DESCRIPTION,
	help = L.AUTOMATION_ACTION_PROFILE_CHANGE_HELP,
	example = "[form:2][mounted] Solanya Stormbreaker; Captain Placeholder",

	ParseOption = function(context)
		local candidateProfileNames = {};
		local candidateProfileIDs = {};

		for profileID, profile in pairs(TRP3_Profiles) do
			local profileName = profile.profileName;
			table.insert(candidateProfileNames, profileName);
			candidateProfileIDs[profileName] = profileID;
		end

		local matchingProfileName = TRP3_StringUtil.FindClosestMatch(context.option, candidateProfileNames);
		local matchingProfileID = candidateProfileIDs[matchingProfileName];

		if matchingProfileID == nil then
			context:Errorf(L.AUTOMATION_ERROR_INVALID_PROFILE, context.option);
		else
			context:Apply(matchingProfileID);
		end
	end,

	Apply = function(_, profileID)
		if TRP3_API.profile.getPlayerCurrentProfileID() ~= profileID then
			TRP3_API.profile.selectProfile(profileID);
		end
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:location",
	category = L.AUTOMATION_CATEGORY_MAP_SCANS,
	name = L.AUTOMATION_ACTION_MAP_SCANS_BROADCAST,
	description = L.AUTOMATION_ACTION_MAP_SCANS_BROADCAST_DESCRIPTION,
	help = TRP3_AutomationUtil.FormatOptionHelp(TRP3_AutomationUtil.BOOLEAN_OPTIONS),
	example = "[ic] 1; 0",

	ParseOption = function(context)
		local enabled = TRP3_AutomationUtil.ParseBooleanString(context.option);

		if enabled == nil then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.BOOLEAN_OPTIONS);
			context:Errorf(L.AUTOMATION_ACTION_MAP_SCANS_BROADCAST_ERROR, reason);
		else
			context:Apply(enabled);
		end
	end,

	Apply = function(context, enabled)
		if TRP3_API.IsLocationBroadcastEnabled() == enabled then
			return;  -- Already in the desired state.
		end

		local enabledText;

		if enabled then
			enabledText = L.AUTOMATION_ACTION_MAP_SCANS_BROADCAST_ENABLED;
		else
			enabledText = L.AUTOMATION_ACTION_MAP_SCANS_BROADCAST_DISABLED;
		end

		TRP3_API.SetLocationBroadcastEnabled(enabled);
		context:Print(enabledText);
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:nameplates:enable",
	category = L.AUTOMATION_CATEGORY_NAMEPLATES,
	name = L.AUTOMATION_ACTION_NAMEPLATES_ENABLE,
	description = L.AUTOMATION_ACTION_NAMEPLATES_ENABLE_DESCRIPTION,
	help = TRP3_AutomationUtil.FormatOptionHelp(TRP3_AutomationUtil.BOOLEAN_OPTIONS),
	example = "[instance][ooc] 0; 1",

	ParseOption = function(context)
		local enabled = TRP3_AutomationUtil.ParseBooleanString(context.option);

		if enabled == nil then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.BOOLEAN_OPTIONS);
			context:Errorf(L.AUTOMATION_ACTION_NAMEPLATES_ENABLE_ERROR, reason);
		else
			context:Apply(enabled);
		end
	end,

	Apply = function(context, enabled)
		if TRP3_NamePlates:IsEnabled() == enabled then
			return;  -- Already in the desired state.
		end

		if enabled == true then
			TRP3_NamePlates:Enable();
			context:Print(L.AUTOMATION_ACTION_NAMEPLATES_ENABLE_ENABLED);
		elseif enabled == false then
			TRP3_NamePlates:Disable();
			context:Print(L.AUTOMATION_ACTION_NAMEPLATES_ENABLE_DISABLED);
		end
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:nameplates:showfriends",
	category = L.AUTOMATION_CATEGORY_NAMEPLATES,
	name = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS,
	description = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_DESCRIPTION,
	help = TRP3_AutomationUtil.FormatOptionHelp(TRP3_AutomationUtil.BOOLEAN_OPTIONS),
	example = "[instance][ooc] 0; 1",

	ParseOption = function(context)
		local enabled = TRP3_AutomationUtil.ParseBooleanString(context.option);

		if enabled == nil then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.BOOLEAN_OPTIONS);
			context:Errorf(L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_ERROR, reason);
		else
			context:Apply(enabled);
		end
	end,

	Apply = function(context, enabled)
		if C_CVar.GetCVarBool("nameplateShowFriends") == enabled then
			return;  -- Already in the desired state.
		end

		local enabledText;

		if enabled then
			enabledText = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_ENABLED;
		else
			enabledText = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDS_DISABLED;
		end

		C_CVar.SetCVar("nameplateShowFriends", enabled and "1" or "0");
		context:Print(enabledText);
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:nameplates:showfriendlynpcs",
	category = L.AUTOMATION_CATEGORY_NAMEPLATES,
	name = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS,
	description = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_DESCRIPTION,
	help = TRP3_AutomationUtil.FormatOptionHelp(TRP3_AutomationUtil.BOOLEAN_OPTIONS),
	example = "[instance][ooc] 0; 1",

	ParseOption = function(context)
		local enabled = TRP3_AutomationUtil.ParseBooleanString(context.option);

		if enabled == nil then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.BOOLEAN_OPTIONS);
			context:Errorf(L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_ERROR, reason);
		else
			context:Apply(enabled);
		end
	end,

	Apply = function(context, enabled)
		if C_CVar.GetCVarBool("nameplateShowFriendlyNPCs") == enabled then
			return;  -- Already in the desired state.
		end

		local enabledText;

		if enabled then
			enabledText = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_ENABLED;
		else
			enabledText = L.AUTOMATION_ACTION_NAMEPLATES_SHOW_FRIENDLY_NPCS_DISABLED;
		end

		C_CVar.SetCVar("nameplateShowFriendlyNPCs", enabled and "1" or "0");
		context:Print(enabledText);
	end,
});

TRP3_AutomationUtil.RegisterAction({
	id = "trp3:equipset",
	category = L.AUTOMATION_CATEGORY_CHARACTER,
	name = L.AUTOMATION_ACTION_CHARACTER_EQUIPSET,
	description = L.AUTOMATION_ACTION_CHARACTER_EQUIPSET_DESCRIPTION,
	help = L.AUTOMATION_ACTION_CHARACTER_EQUIPSET_HELP,
	example = "[ic] Set 1; Set 2",

	ParseOption = function(context)
		local equipmentSetName = context.option;
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName) or tonumber(context.option);

		if not equipmentSetID or not C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) then
			context:Errorf(L.AUTOMATION_ACTION_CHARACTER_EQUIPSET_INVALID, "|cff33ff99" .. context.option .. "|r");
		else
			context:Apply(equipmentSetID);
		end
	end,

	Apply = function(context, equipmentSetID)
		local equipmentSetName, _, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID);

		if not isEquipped and not InCombatLockdown() then
			C_EquipmentSet.UseEquipmentSet(equipmentSetID);
			context:Printf(L.AUTOMATION_ACTION_CHARACTER_EQUIPSET_APPLIED, "|cff33ff99" .. equipmentSetName .. "|r");
		end
	end,
})
