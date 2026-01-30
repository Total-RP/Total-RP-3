-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_CVarConstants = {
	ChatClassColorOverride = "chatClassColorOverride",
	ColorblindMode = "colorblindMode",
	NamePlateShowFriendlyNPCs = "nameplateShowFriendlyNPCs",
	NamePlateShowFriends = "nameplateShowFriends",
	NamePlateShowOnlyNameForFriendlyPlayerUnits = "nameplateShowOnlyNameForFriendlyPlayerUnits",
	ProfanityFilter = "profanityFilter",
};

-- Copy/paste of Blizzard's CVarCallbackRegistry to improve performance for
-- CVar value queries by caching state in Lua. We don't use the global
-- registry provided by Blizzard as it has a few taint issues in certain
-- clients.

TRP3_CVarCacheMixin = {};

function TRP3_CVarCacheMixin:OnLoad()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.cachable = {};
	self.cvarValueCache = {};

	self:SetScript("OnEvent", self.OnEvent);
	self:RegisterEvent("CVAR_UPDATE");
end

function TRP3_CVarCacheMixin:OnEvent(event, ...)
	if event == "CVAR_UPDATE" then
		local cvar, value = ...;

		if self.cachable[cvar] then
			self.cvarValueCache[cvar] = value;
		end

		self.callbacks:Fire(cvar, value);
	end
end

function TRP3_CVarCacheMixin:GetCVarValue(cvar)
	local value = self.cvarValueCache[cvar];

	if value == nil then
		value = C_CVar.GetCVar(cvar);

		if self.cachable[cvar] then
			self.cvarValueCache[cvar] = value;
		end
	end

	return value;
end

function TRP3_CVarCacheMixin:GetCVarBool(cvar)
	local value = self:GetCVarValue(cvar);
	return (value ~= nil) and value ~= "0";
end

function TRP3_CVarCacheMixin:GetCVarNumber(cvar)
	local value = self:GetCVarValue(cvar);
	return (value ~= nil) and tonumber(value);
end

function TRP3_CVarCacheMixin:SetCVarCachable(cvar)
	self.cachable[cvar] = true;
end

function TRP3_CVarCacheMixin:ClearCache(cvar)
	self.cvarValueCache[cvar] = nil;
end

TRP3_CVarCache = CreateFrame("Frame");
FrameUtil.SpecializeFrameWithMixins(TRP3_CVarCache, TRP3_CVarCacheMixin);

for _, cvar in pairs(TRP3_CVarConstants) do
	TRP3_CVarCache:SetCVarCachable(cvar);
end
