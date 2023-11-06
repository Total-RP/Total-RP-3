-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- The functions in this file serve as our internal interface and should
-- be preferred over calling anything on the TRP3_Launcher module object
-- directly.

TRP3_LauncherUtil = {};

function TRP3_LauncherUtil.RegisterAction(action)
	TRP3_Launcher:RegisterAction(action);
end

function TRP3_LauncherUtil.GetActions()
	local actions = {};

	for actionID in TRP3_Launcher:EnumerateActions() do
		table.insert(actions, TRP3_LauncherUtil.GetActionInfo(actionID));
	end

	return actions;
end

function TRP3_LauncherUtil.GetActionInfo(actionID)
	local action = TRP3_Launcher:GetActionInfo(actionID);

	if action then
		local shallow = true;
		action = CopyTable(action, shallow);
		action.binding = TRP3_Launcher:GetActionBinding(actionID);
	end

	return action;
end

function TRP3_LauncherUtil.GetActionBinding(actionID)
	return TRP3_Launcher:GetActionBinding(actionID);
end

function TRP3_LauncherUtil.SetActionBinding(actionID, binding)
	TRP3_Launcher:SetActionBinding(actionID, binding);
end

function TRP3_LauncherUtil.GetBindingAction(binding)
	return TRP3_Launcher:GetBindingAction(binding);
end
