-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "1Q1EZjoos8Vl8pluvIlEdj3L7kwscHDtakmCZD1KXGITCIRXyrzBYmS3C8z)6w(TXpH8OcryPU1VUvRwD3YsnKwij2qsCbZMOpFwRdRNq2q3QtSPwsI273sLeFJX(UKyljX5ZC626WAvM5H1ZWHzgLKMstA2QB3(DKe7inPr3E9A0OvJw9KeBlj(aWptlMHM8LpXygJ2rmvKe7bJtsSR0KoTbQUcr0TundnBnIU2FrS1ygsIQ7mKXwhwxDdtzb5fDATd)XH1o)QPEy9ca(RMm4P7M94Gf3jUAWT3oDYH1edLu77MBoSUIJuu5WA73OgbS0730i9WAdn9GHtHP5pGpKe91ghwpqrHQeb7wuD1loSEhiDJvCBCVjqXfilENlxqZeerVhD9YTkaZ9NLQ(SOMlag)rP6o8lxPmtLiFu5PfnP27mbeOs0TOX0A(JYVvaI9LAuOQw7ygJW3GzFy9ylqBp14rgb05vR4zqxPwAqkhOLmepcQhHJvJe4kQbZg7oZ(ZqbzLNmhIp3eLVztsW2XieIpEMZJZzkdg5sBC1prMW7kDg9iNSJefbDMCr0bPVRZ3sRmAsCpYTAwGwz)ydvgNr)3)xge47(HQK6GZG8x3PPRG6QHmD0tzIQIDGg0sqghHZNdzk071zeByp9wI8393UcDBOQ9Am2wRwEi4j6MxOMFcyieJtcfzGl1D66l0S1)G1mrzBMAMDw07ZaeUm84rvgP0Ksu2Z5RT5o6jTPx4U3Pg2waREvZcm4hs01Fbf9kdNo5(XJwoFWIXtNSA4ddMm6UBRCrGBZQccc1cC747dDQXqUWTZKFYWW3igVc(kXr)34ENG)9Xc153nAS4I7MV62blgSA5m4FffQZDz2TeBIZrENosDpZCGUEGVXKomXdgrx0k(HuJO2lJ6PHF68c23PgzmDP5M6R(e)TtbnIzGgyjqj451kURZWycTVdXLtuJnHzUXXtlIwCbktLgCacr3jWPjoXnHnNtj6B4aQqmjJZVdXn01qyMJN(ujVWjIIMiYh)XCSv7KJZWZMXt(pSwqaG1LvCAem7NWIrwrwMP(IpOa9f)RcezBM5ciIFVqevn1aSOVhTx4HkIJpkpeCoCFQHOSjfdDQqHUD2XSf3VD2ZQRfigIqKJosng1WZNdvCfc3ltoZvEsAMsCbvdUYdFn3DL8MJwtC6iRDJ89ACsd4KGHx8Il9hrA8qjw8zPetBzDYM68nFMllM4jYgjfrBXcs8Rf2J2381UPOoYWonIk6SYT48oC44NC5Lad5ycGkxFAZC)kY2FZc13UDLO8fAcfCzqMBmqACTeIQGVWntUAUoSdQ5qLIUz7ylJ0crDQUYRmfn19vJJ)mCdqtmpZthew2quYMSThHHlYoXoHNg8V55yHXqoxSwz9UKPyCm8Zz16SDIhBgpPThxE5ydlQPNLmAYAztS3z5opuzQLfXCF(2WMmD0H1ErxYl0rkBnPQuttQIO9E9Kw0JUaI(AM5rY0PdhBOOjtGtD5KN3jrzHwCNdVCkR8QJIWDg72yjmF6Jyk5)NvIlgSyPOW0Llwn9EUb0GHqG(fDlgcGJKwC76yi7McVrTO7vIz3dQQv484eYuuIZDol2U30rwLFjRc)uh(XnMTkF1TrqXteg(0kaLU9)TFbbkv50qBI29FabneBNcM)TZ(fBmJ583F4NWUBXfJF(MG1BSD6kpOPql4MNqCSSol9jTiEmxmEXJ57YeL3Sk5WPEsuSNWTpE2iUbu8QSGDgs)WP6xjwdTZ8mQuHxCm8jzuoy7wCSR5vPkR4ncfJkF91PYiOv3pwXjEvrJcjeNCYSzKxv6cBAhrXCTQMHs1k)D3LTS4axd(pYVk2ffrOtwNKSq5oAFNRt3IzBECLj5dS4kJmnC)OCtxczjuDE)uKKppx4Wr8U(V1KXkb8dnLxXW45jQI(JzulJFdAq)PML9fr7aR8cVGb8hLRdFNziydriTd6PDCSUpTJcuy5Rp9sFhMWV4kVrYz96HMuO9c6pHqhPvHKcbjTYG5l(Y05)zLAfylOpNVEOoLyoqxFgtZW2QA5igYOItx1kZhp6HfyztdP0gUdcDYWpKArBtnJxrK(4D3Zh7LTHpQxdxNblwYEm8v82mWeZmPBji1hw)cXcFiQ8FJs0TF7fI5)SuWexxkIKL)is0K4MilvLpfLmSd)umbtGPLWmijQb7apJX0IQbun4q9gwC5Tw5NrrT)k(0flwOWjFGuXP4eMPpcB8YnNWz8jwbwxRLenlk)IEA7lkS35LUExncEHcExZs7fnDn7cKbAXnz9l1x6yoZttdOpvvBrL5GQij7CIktn5QkHPAS1KPQP7p2cQr4hvxKaEooOGWmJpNx)ftYwCx3yJHE3tz1i09XOmczc4QxqfHSFQeEoVr)5Ltr8GlDzRkCJyeaKFHy5uxn87VYXAhWfX8r)o3fsIEgkOMippcEEiZvZhut7i1LoLG(YchLI(YEdm5EpL83(QvxeXUqd4J2wIMPv1HbUQ5LJ23VnUiKzmsHkNFWnb4pjcbppZmIIFVqfPuCL5TCktZOIRSt(oMdDXI87Mo7B(6mQ1yKkee(Qe8473kyHpczeaRwHw8fcV4FpZeTvRM9uMtfncnv84Kcub3CtU3QBGD0X3kunCgkw(NPAIKGDATZjZPYyjL6lwXP)sj4)gfAlj2hFPiTj6GRpOf8Gxnz7260uwNyz50Cdz7knf3VysKPoT2((2W0ATLk70IOQQ9tNMudz2odyVqigW0Dya0E54BLeR)ZUT63QXvn70SdTHCRgeaum53PMw4lA4Kgyrn7aSvrbFVdDo0qsKTfvkitNWFDtX7ewAshN3usquWSI5NMyjj(Vi67GNnYP8noMwU5wpCNLnBJ)B14Fs3hH2hjVq1LeXqVWxbsyMvbfWZ8QyB9SdwEwBd5vQ1ZoiALUdj3sTKLeho9XPZbrDsZam2WdJhJhpOYfQ7734Q2963Px)R6wV3vT6jPEzNoiRGoN0s6(o9UQz)UD6CvBud63FBSF7WYIFTekNKi7qIRKelYPW1cJNONrW7RRncVuLxNQ0KOe3TB76DRdID7oWpnRJsuBuIVVF9g9B0RD9o1R3Ur)oDXEAHtdQlowIdvjOZxMv9JhkQqdQcvQUo7h(DSHpTCfq7emkJwa1adtmSt3IOMHzzmQpxtteKDsyvkoyIzt2SBN2TQ3Up8z7wD77UoaRq9aJ1onVQvN2nBa)12Ffc6PrZM17vVE3w1HgE0ezvlQW9XyN6uFm3lpWkjR0UbYFBp5FPf1t)7VCWTa8vmEAKF3f7hvi(Yb)xym)fL7mqN4obIVZIgnRf53ywyibKxyVZJndIYGOeAp5XPVW9ZAlj9))d";

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
	requiredDeps = { { "trp3_nameplates", 1 }, { PlaterAddonName, "external" } }, -- by replacing the version with "external", we can specify other addons as a dependency for our module
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});
