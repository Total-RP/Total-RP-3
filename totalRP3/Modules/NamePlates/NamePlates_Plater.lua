-- back from the grave
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater

-- The import string for our Plater mod
local importString = "1QXAtjUs2)l8LluLMcqaXzx3TyrXH7vblcSZDRXjqtshn1ettLoXz4UZYV99C68oKesquNbdP7ZPpV6ZRUvAPmxrULI8CMdXC2JxSB1eYR0nMehkxr2z7gQI8lm23vKVqrE2JEdZ3TsNzVB1J40StcsBLjTVOxV(DvK7QmPvVlB1TDRoDGLOJI8Nb8zZzwgQN)aJzDNlXwtr(syEkY9uM0PFFf5Rqk6gQHLHJbX04ViogmlfzDxlv8PDRQ)ktBozTjTXUFF3kVFn03TAoq(lNm4HBF8(bZVvE5GBUz6KDRCEHAfnXGFZzYxVBLLHz00PwA7(D4df5qEC3QbAAuTeueNAQF2UvUanpwZ)Hr2aeNHO4nb1cpMbHh8QpTyJgG8WvPEikA4taJpvcKD)YNlZr0CiqR5P2RLh8b)AtDCTbYtNyYP7pnHOnZVe9uepgkNqXq9gzt1wmNDRgZb9ZuR7zeqlvVwGHDTgNs6DFsnTcvsich84yHr1Y7(ATGxu7BhaQOTtjHfFVq2ZpikIn3foOQoB8GJviUUxa5E8KKjtTmcJ83LfAevfrkUN4gdoiB2o2sNjq0)9)vju8SRHPgkagYmrxyzYDUGyHlPIZW7ZHmn6itgXb2wUHO(9WDCWWw6gpNcTnACik4b6RRP2Fa0qmeNfvuaDP7AAo3WX8elzsI2cLmUC6OcicFeU)SQcxAtjABf41X2LEuBOLU9nQLdhq1ZgCWgEiX0CnY61goDYOX3Ty2G5JNoz5WppyYD3EtTZI8JvxssQrKNMqNAtTgkyoxBHZ9HVqSEgCEHZ(Vj88a)50sQZU9UXYZVD2YBgmFWYfpc)PSK6mFKDdXH4f164Pu)WEdmnJC6LL39aYiPsR8rnUJ6SiPZdra25SVtTky5YZZZxdb(Bhd1ixa1aQaTO33O8EdJttO9DmSCm0yr5JKBS3WjTBfU7n8RsevhM9Ci7VGCi0TnaAXClsIICjW5NehsEHiMAjRAtPwLm89Xg3oKhs7QO4vfcesGWRy2Qj8wLBEkXxppOeceHH9bwRdXPfYXLum4ZpcDUVM8690jEdKhSH2HcqJWKKvqEhlcNrE4qlvu(CYpQQ7RZD9M9OpkMeWYjkdOeMnjOyHEm0lsfZC895Ey)3C(5acf0eqQc2ZH5)veT)ghzF)HYK)ITGs(iOq7uegFfdkotq8IKRH4kxJobUNztxtP(7(lfirvqwRSBx2x3MxEntn1EMPzOVTEAwUGnY0mRw44jcUdKALnBZE0WzfNJV0dd(trU2yIhZKBuv)dfYg7t(hqB9UDdNAfpQDuNF(ylo1oW4hTY5oehxU)6qvPCoXE7Hn7TzMOlNTY(GxQGcBSP6uBBQMSZwZSu6jvGOZShdaz60HJT0mujqCtb4hkwsrulUZruu8YGQHLU1Y9vU0SP3JLM9FwkpFW8fYstxmF50rcdObdHSdl7wmKa2JBXTRJHuIl9g1YUxjLDpiQwIRZUvssPb(GRz529MpLv7xQ6WpnHFQ5ra1(Q)drfrln8HLav6p(3(f4SR2XrTzA3Fcc7NANcw0M3(fhSmRdV)iSkVDRiWkUxirj(lmxtTpBOrl5MNyySQoldbTmEmNpE(9h2LjYVfvN6Xgjk1Be2hpzL2akDP54GXKpcO(vM9s5DgJkxYlnn8bzuoyZgCUReT2OOuuILLPq)6vonA19JLcGxw2exIHjVAtUlO1oXnTtiy(KUHLw9A)DF1wryqib)hhUxKLLIqNSELjH8DYXEVoDlNT5(TZsmXYlmk0W9u5MUc8sSMd(HWjFCUWHq8((VnuXA5)HH2ZyM)Isnr)Xmk363GhO)0G7CwYbWtTquYV4vh0HV3keTHiM0b90oo1WhxOan2HLNbfGdl4x853evD(PHqD8o050FcPosRdL1bCATbZM)LPZ(JAnkXwWqm)PHMuI9atZhzgwo86vdyOimbC1RnB8DFEo2RTycTHUqQtwHPul7yBy9msP3F7iXCpVd8rZgOEgSyjBX0xPAE1Yzt3qqO3TAnHJVef(VqjMoVSMy)pRezI6LYWzhEgzAsCDcvv1lrPa7WpetWmqAfmdYcAWoiWymVSAardo1GPLMFBu9vu24VsVCPYfkEXhiucioIv6uyJxT1eIXNLoiWAjtZIQR0ZBFrP9oVW37Qv0bj)Mb3yTHPHtjQaT8MSHnRlFAUWOPrWNROTS8CuJNu9IOY0ZUruyPgBSz6gMHZTKserO6YKWZ(jfehzI18tFXMSb31n2AyWHBvpbCNgHrmtaF5ckiudlLiW5n6pVAcIp7dxXIc)mgbckSvQcORh)ElSV0bCrm7U)LWfsMEgkPK4qEec8qEqjFuxPt0z5Cs6Ri6OsWx1Zq5GhUL4U0S8Se2fgaEm2qmS51hg5Qgvbr(TrLqH5ifRH8r9YpCrKIEFHveL(KDktR4QYTB5yUyiysqoVyWHDnEMqMBJLFlitGa)BHjiIVS2fE33P0nWx9s411sCPigdGtWB8bEYR4zw56NTShQX)VHXbF0M0OdOQifE2hoA82J6DQQh4i08p9KWJedTkhZ9kWl(5BCCDfno5SeFX1ERqYw52i3ZkjMvkazmRtP4wNJy2isleHcMocBf70kxBPmmOBCYUUrfCY8h)PAhERYCuK7Jx3nhIjyddpbV4zBM7gVhvnjCU3JVs2S0qZ)ly)D9EAZBBIdlFdv17jIUUXp9EKAPYadEQDmequ9qa88IX3Oi38N9UO)fTUQD32DPTuVOfbikM6BuBoEzZM0cBWzBaTAA4DpZlaIImBdkuqKorCrcXt4vzsxf5)GUf4eSazrGf(9K1utf5)nX0LQiFNx7C8C06xR9qxUd71WB3gowcmOiJPHHxdoyL1b6)jrhT5p5rlpz8k5zk)jpkAPP36DdLRQipC69tNbS6K2r0yR40yyj)buOGFg1V1vDUSF3l7FvVMxE1fxQOFE3UiwGbNCHYOUxEv7(9629QoOWlC8o44obSW(8A14evpq85KuzrfVVyII(SIUjMoinMn)gRDnj54E960SxtGT70f(PDtKJ6GC8O(nB1V1LDA2TzZoT63ThoYf4kGYIm5yVf5KXZ6H5gLKPbrHo10K9JWbEvSWcbqN9nkt2l1ugMyAO(nvTiZYu44DyAIez391sjxGK6OUTBF5Ln73Sn8VE973k0QmtTxo6O0m6PXM0RVy(hAapllYEr8AhFEDVUPhWURdi2fCAGIiuVimhc5IQr(RzSqfWTwer0DmbCxonz1kQVW4yawYA2BICYGi7eTy7)2VSfHpvhfL)p"

local TRP3_PlaterNamePlates = {}

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if GetAddOnEnableState(nil, "Plater") ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod)
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded("Plater") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY
	end

	Plater = _G.Plater

	-- Setting the global TRP3_NAMEPLATES_ADDON is done via the mod and should not be set here.
	local success, scriptAdded, wasEnabled = Plater.ImportScriptString(importString, false)

	-- If the mod was not installed (is already up to date) then find the installed mod object so we can still control it
	if not success and not scriptAdded then
		local scriptType = "hook"

		local scriptDB = Plater.GetScriptDB(scriptType)
		local newScriptTable = Plater.DecompressData(importString, "print")
		local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType)

		for i = 1, #scriptDB do
			local scriptObject = scriptDB[i]
			if scriptObject.Name == newScript.Name then
				scriptAdded = scriptObject
			end
		end
	end

	if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

	if not wasEnabled then
		scriptAdded.Enabled = true
	end

	Plater.RecompileScript(scriptAdded)

	TRP3_NAMEPLATES_ADDON = "Plater"

	self.PlaterMod = scriptAdded
end

function TRP3_PlaterNamePlates:OnModuleDisable()
	self.PlaterMod.Enabled = false

	if not TRP3_PlaterNamePlates.PlaterMod.Enabled then
		TRP3_NAMEPLATES_ADDON = nil
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
	requiredDeps = { { "Plater", "external" } }, -- by replacing the version with "external", we can specify other addons as a dependency for our module
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});

_G.TRP3_PlaterNamePlates = TRP3_PlaterNamePlates
