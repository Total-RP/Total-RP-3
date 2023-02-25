-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "1Q1EZjoos8Vl8pluvIlEzGK7YDflbiSBcqHHDURMedk2YexJXIY2Kzy254Z(Pw(9BBiHudJWsDRFDRwT6UTeBiUuuOHOWsIfsBX8wN2mfTdVxdzHnffSoUhlk8gH8nrHwIclMB3T5PnkeJtBMddZimjnfN2SvNo94ff4fN2Ot3UnA0Pzx6pBlk8aLFgMeDvPRFIq0hFazilk0LoorHoIt55Vru4gar3Jv1vTurAQ)ezPs0ffuoOlbToTP6oI8s0RA4AN(JtBS)tv50MLu4VEA)Ngo)X(lhkSU)93pB6PniD5u77U7oTPITuu50gR3W6(S09V0i90gDvn)HJPtZFq)suWtBCAtFzzSCiSBI1uU60MduPBIStJrgukUcyX7m5I2mfruNy53h33jgFtvFRdW3yGToyO7GexQCh8TR2ltHKh2Q6nX1CG9Kpkf(PF5OBYu1ZgvE6ExrsbPzIJOR9gvCneBkhq0vu3EWGjoCpn7(vpoCD)blN8x9xoz20VwXYyFR16EMUvEjnuexHFxmiLhIHFTPGS2Y4q(cR)YJ3smScwTw8jXtVmXKAqot)rcIAwwTI7E(k1stYZrQsgIXGAmCSEmhBjQ)8jzA8MoR80B(85UW8nBs89yfIq4XZTFCotP)ixzbM6jYewxPZOhzKftu40isfrhKUJjVTvLrtcoeUx1KQvoorxHWy0F))YGapp0y5uhCgKV9GQMmORgq0GdtsuvCGQbn5KGry)9aImEKgbzrDGThj9npFt0UH97ryBTA5HGNW7EfB8jGHamojuKbUuoOPTu1s7dwZeMTzQzoyIhLbiCyy8rvgP0aJKpMG)UsSPNB47yDltkR2QAsn4hG00Efe9kdMnD0KXRwWC1VEWd9NoE49vUY3TzvooUA(UD88Hotp05gdEdPVL6Reg9)G5DQ2hmsxmC8eHLdxS(((l7VE1C6)vuKUWHz3JSq2hVF(an9ZFYNyNyl6RP57wnPZHCfHZ98TXyRvHDsXIIzj5By9mMU08W9vpIF5CqJqgOHU8j7)8Af3RBqmblfb4YzQXMsm2z7KgqlSaLPsJE2dsZoS0P2rLcnxGrA7yaQqmjJJ(dWnWRsqMdhCvjVircJMqYh7XmSv7SdrX1MXv(pTHJJcRRRy3WF2pJfJSIapt9fBq(6l2p5qsweJL08PCdLwXqLIfTJG9clKAy8H5bNDCbZ0fKmWquxfkQVloCVOU8ZEwDSaHOlcDQtQH3gC(SPIPqyEzYzUYtsZuIlOAWrEyR5oRK3fBnXUJS2nY2RXi1NtC6UHAUYBePXd5iH2Ls4WL1jBQZ3I5oSyQRiRNuWWfl(YVwypAV4PDtrDKHDAiv0fLwYLD4q8NC91ugYWefQm9PfX5NaB)ntqF70vIYxGjKZHbzUXaOXXsiSc(kNKaR54W2VIovk6MT4wgPfD7mn5TezvLJvJI)mCdGtmf1ZheMw0aSni7JHHRYoNqUN6)FyPNbHFUqOwz9UKPyeh(5SADXoXJmJN12JRVEIUj2W1sgmznTqwhmDMhSe20ezCmFBydIg4W6OGd5f6iL9gyfSHbwwW6Owsl6HxabFnZDjz2Sbt0LvLq0tDzKN3jrzHwyNdRsmRDlbd3q9d7m5wm7riB()7AHL9xUsGB2QLRNnIza1FanjHIUfdaqmPf2UoHMyuH3Ow09krS7PQQ1W8yhYuyIZDol2U30rwLFjPq)uN(XjMTkF1PHFDx4g80AkkD6)LFrduQY5H2eT7)acAiYofi1D79lwqY25V)WlxFNIWg98noZ3ih0KFqvgxWnpb4yzDw6rAr8yUCYYhZ3LjiVzvTIZ9KOipHzF8SEudOOfOb6mG(Hr1VsS8Bx4zuPcVOy4tYOS)(9Wy3WkWvwXBeigv26RDrvaRUVVMr86IgfsaozNzZy3c8f00oKI5wfvD5Qv(NolBzXbMg8FLFbWlkIaNS2jzbYD4(UuNUfZ2mErnzdS4kJmnC)OCtxczjqjI)uKKppx40J4D8FRkbvc47QYBHW4zjQc(Jjyt9FJ2a)dvtRRc3bu5fwbdypkxh(2ZG)gIaAhWt7KiDFEhfitYxF6M(oDc)IJ8gkN1BhyGPTxI)bn0rCvAsHujTs)fl)YSf)zLAfylOhNVDGggz0xtBorv3YSA5iMMrfJUQvwmz8dlHsUgqPn4an0jDVqQfSmu13ci9XHJyJ9620VQxdwNPwSOJq4RWlcbsmZaVhbuFAZRit4HGY)nmsZ6Txrg)7sbtyDPisw(JirtI7cTuv(uuYWo8tXembMwcZGKOMAh4AmMwunuvdmu3HfvERv(zuq9NrNUiXcfm5dGkgfNXm9ryJxU5KEgFIvG1XAjrZIYVON2(Ic7DELJ3vD)RRX7QMQVQQPAvGmqlUjRxP(shZzEAQp9PQAlQm7xfjj7tujkjxvjivJ9gefvnVXwqnc7O6IeWt8GccYm2CE7xmq7HDDt0h4(koRgIUpgLratah9cOiK8sLW15n4pVCkIhCOlBvHteJua5viwg1vdE7GIRDOUiwm(3zUqs0Zqb1e55rW1dzUAE)AAhQU0Pe0xw4Ou0x23atUVNs2DBB9vHSluP8rDps1WS6aFx1SYr753gweYmgPaLZ3)nb4njC(ppZmII(EHksP4kZTbltZOIRSt(9th4flYEV2z)MVUGAngQcbbFvcU89Lcw4Jagb0vRal(Cbx8hrmaB1QzpL5urJatflojFvWD3L7B113ok(BfQgmdfl)ZunrsWoT2LK5uzSKs9ozC(xkbV7RPLOqp4kNAH0OU(OTOpyRb5WE7MsAitt7M7q7xRk78dOMU2T2)((G0AUhlz3cPOO(d7MyDjYbD6EHamajzZaA7vtUxuO(p60QxRg30KVjpUHuRgikOisVJnmHlK50gqrn5PSvwgUFM2hAikq2dkfGPtzxMx4DcloL3(EOsffiRy2PjMIc)fs7a9zJTlFJTPLtU1doyAr25D7p)t8Xq0(i6vSMOae6fCvrPZScf)pZQIT5Z2y5z1DOTyZNTr0AnBsUhBkjkmy2JZwqf1Pn9XydxmghpUqLjuJ614M2D7X3T3nDQ39MwDfvUMNhyfTZPTehX39MM96WZFtBqd61FBOFRGYIxTekNKiztIJKejYPG1cJLON)vkfK3wPlV2vPjrjUtN217uNk2T5PFAwhKO2GepQx9g9A0TDD(61B3OhFhONwW0a6I4sCGkbD5YSIx8qHfAQQqbRPr(Uxh7ytltb0obJYWfq13Wec70PiQzywgH6l10eajFcRsrbteBYMD4B3QE7E0VB3QtpN1b6kuxQXkFZBAX3Uzd6)A7Tcr7PrZM17wVENw1PnCPj0QwyH7JXo1U(yoV8aZKSs74l)TDL)vWvw2w)7TCWSa8umUAKF3b7XkeF5G)ReI3IYqDWjUDG4hmXHZAr6nIjesa6vY7SyZOrzGKdSNmE6lm)SwII)))";

TRP3_PlaterNamePlates = {}; -- magic public table

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if GetAddOnEnableState(nil, PlaterAddonName) ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_NAMEPLATES_ADDON = PlaterAddonName;

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod);
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded(PlaterAddonName) then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	Plater = _G.Plater;

	-- Setting the global TRP3_NAMEPLATES_ADDON is done via the mod and should not be set here.
	local success, scriptAdded, _ = Plater.ImportScriptString(importString, false);

	-- If the mod was not installed (is already up to date) then find the installed mod object so we can still control it
	if not success and not scriptAdded then
		local scriptType = "hook";

		local scriptDB = Plater.GetScriptDB(scriptType);
		local newScriptTable = Plater.DecompressData(importString, "print");
		local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType);

		for i = 1, #scriptDB do
			local scriptObject = scriptDB[i];
			if scriptObject.Name == newScript.Name then
				scriptAdded = scriptObject;
			end
		end
	end

	if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

	scriptAdded.Enabled = true;

	Plater.RecompileScript(scriptAdded);

	TRP3_NAMEPLATES_ADDON = PlaterAddonName;

	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = scriptAdded;
end

function TRP3_PlaterNamePlates:OnModuleDisable()
	self.PlaterMod.Enabled = false;

	if TRP3_NAMEPLATES_ADDON == PlaterAddonName then
		TRP3_NAMEPLATES_ADDON = nil;
	end
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_plater_nameplates",
	name = L.PLATER_NAMEPLATES_MODULE_NAME,
	description = L.PLATER_NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 0,
	requiredDeps = { { PlaterAddonName, "external" } },
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});
