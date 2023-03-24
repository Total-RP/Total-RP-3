-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.L;

local function SetCustomClassColor(player, field, data)
	local hexColorString = string.match(data, "^#?(%x%x%x%x%x%x)$");

	if hexColorString then
		player:SetCustomClassColor(hexColorString);
		return true;
	else
		return false, string.format(L.SLASH_CMD_SET_FAILED_INVALID_COLOR, field, data);
	end
end

local function SetCustomIcon(player, field, data)
	local iconIndex = LibStub:GetLibrary("LibRPMedia-1.0"):GetIconIndexByName(data);

	if iconIndex then
		player:SetCustomIcon(data);
		return true;
	else
		return false, string.format(L.SLASH_CMD_SET_FAILED_INVALID_ICON, field, data);
	end
end

local function GenerateFieldSetter(methodName)
	return function(player, _, data)
		player[methodName](player, data);
		return true;
	end
end

TRP3_Automation:RegisterFieldSetter("class", GenerateFieldSetter("SetCustomClass"));
TRP3_Automation:RegisterFieldSetter("currently", GenerateFieldSetter("SetCurrentlyText"));
TRP3_Automation:RegisterFieldSetter("classcolor", SetCustomClassColor);
TRP3_Automation:RegisterFieldSetter("icon", SetCustomIcon);
TRP3_Automation:RegisterFieldSetter("firstname", GenerateFieldSetter("SetFirstName"));
TRP3_Automation:RegisterFieldSetter("fulltitle", GenerateFieldSetter("SetFullTitle"));
TRP3_Automation:RegisterFieldSetter("lastname", GenerateFieldSetter("SetLastName"));
TRP3_Automation:RegisterFieldSetter("oocinfo", GenerateFieldSetter("SetOutOfCharacterInfo"));
TRP3_Automation:RegisterFieldSetter("race", GenerateFieldSetter("SetCustomRace"));
TRP3_Automation:RegisterFieldSetter("title", GenerateFieldSetter("SetTitle"));
