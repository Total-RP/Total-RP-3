-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

local TRP3_NamePlatesUtil = {};

TRP3_NamePlatesUtil.OOC_ICON = "|TInterface\\COMMON\\Indicator-Red:15:15|t";

function TRP3_NamePlatesUtil.GenerateCroppedNameText(name)
	return TRP3_API.utils.str.crop(name, TRP3_NamePlatesSettings.MaximumNameLength);
end

function TRP3_NamePlatesUtil.GenerateCroppedTitleText(fullTitle)
	return TRP3_API.utils.str.crop(fullTitle, TRP3_NamePlatesSettings.MaximumTitleLength);
end

function TRP3_NamePlatesUtil.GenerateCroppedGuildName(guildName)
	return TRP3_API.utils.str.crop(guildName, TRP3_NamePlatesSettings.MaximumGuildNameLength);
end

function TRP3_NamePlatesUtil.GetPreferredIconSize()
	local size = TRP3_NamePlatesSettings.IconSize;
	return size, size;
end

function TRP3_NamePlatesUtil.PrependRoleplayStatusToText(text, roleplayStatus)
	if roleplayStatus ~= AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		return text;
	end

	local preferredStyle = TRP3_NamePlatesSettings.PreferredOOCIndicator;

	if preferredStyle == TRP3_OOCIndicatorStyle.Icon then
		return string.join(" ", TRP3_NamePlatesUtil.OOC_ICON, text);
	else
		return string.format("|cffff0000[%1$s]|r %2$s", TRP3_API.loc.CM_OOC, text);
	end
end

function TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(fontstring, roleplayStatus)
	if roleplayStatus ~= AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		return;
	end

	local preferredStyle = TRP3_NamePlatesSettings.PreferredOOCIndicator;

	if preferredStyle == TRP3_OOCIndicatorStyle.Icon then
		fontstring:SetFormattedText("%s %s", TRP3_NamePlatesUtil.OOC_ICON, fontstring:GetText());
	else
		fontstring:SetFormattedText("|cffff0000[%1$s]|r %2$s", TRP3_API.loc.CM_OOC, fontstring:GetText());
	end
end

function TRP3_NamePlatesUtil.GetUnitCharacterID(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local characterID;

	if unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER then
		characterID = TRP3_API.utils.str.getUnitID(unitToken);
	elseif unitType == AddOn_TotalRP3.Enums.UNIT_TYPE.PET then
		characterID = TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType);
	end

	if characterID and string.find(characterID, UNKNOWNOBJECT, 1, true) == 1 then
		-- The player that owns this profile isn't yet known to the client.
		characterID = nil;
	end

	return characterID;
end

function TRP3_NamePlatesUtil.IsNameOnlyModePreferred()
	return TRP3_API.configuration.getValue("NamePlates_EnableNameOnlyMode");
end

function TRP3_NamePlatesUtil.SetNameOnlyModePreferred(preferred)
	TRP3_API.configuration.setValue("NamePlates_EnableNameOnlyMode", preferred);
end

function TRP3_NamePlatesUtil.IsNameOnlyModeEnabled()
	return C_CVar.GetCVarBool("nameplateShowOnlyNames");
end

function TRP3_NamePlatesUtil.SetNameOnlyModeEnabled(enabled)
	-- Effective configuration of the name-only mode state acts as a latch;
	-- we only ever enable the cvar based on the users' preferred state at
	-- load, and won't subsequently disable it until the user reloads the UI.

	if enabled then
		C_CVar.SetCVar("nameplateShowOnlyNames", "1");
	end
end

_G.TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
