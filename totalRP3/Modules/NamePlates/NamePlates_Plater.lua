-- back from the grave
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- I'm aware this is horrendous. Will definitely need to figure out a better way to handle this string
local importString = "1QXAZPTo2)l8LlmtIhGWR0D7Udl5r5EtHmyy7DN2AqylN4PowESStl3Tl)23Zr(TX2ytjjTeJLohDE)qskDuwQi3rrEjZLyU4XR2Vzg5fQTjXLYvKD3ztvKFMX(MI8vkYlE0Fy((n6mN9BEeNMtAq6QmR7vdgmQVICFLzDgmSt32T71VTICpf5hyo0Tu6LFKXS2V5EpIJMI8qyAkYduM1Byxf5Rrc6gQHLHRbX04ViUgmlfzDplv8P9BA(ctBjzRjT1(FF)g)Fn03Vzjq9RNn(J3(4dJxER86X3CZ8z734(m1kEIH)wWKF)(nwgMXtNAPT)3HpuKJyX9BgRPr1srrCQP(f734b08uTGhUZbG4cefVkOw4XCi8Wx9Uv2AaYJwLMrOOvabm9Cjq2)ZaUSarZXaTHVwVrrWh(Rd11ZbipDIjNE40eI2C)s8tX8yKCcfdnBLpvBXC3Vzkh0pZTEGraTuZgH21nADoP3dj1SkujHiC8JtfgvRV)ZncFrJVEeOI9Msdl(EHSNFuuKyURCrvD(4bhRuC9GaYd4jjtMAvegf7Lfzevhrk6tCJbhKn7MAPZei6)()QfkEYZWudfatyMyeSC5opqSWLuXz4)5eMg9otgXfClTjQFlYJdg2s34PmOTvRJrbFK(YwQZBanKaX5rfLqx6EMMlnCnpZsM0OTujJhNExjeracpCw1HlDOeTDc8664rpjhAPBFLA5Ybu9KbhSHNqmn3ISEJjZND307xTy8YPZNTEYhgp7(BVPXfXXXAkjj1kostuqT5wtemNNJi4(KNjwpbbVWz)3erEG)CEj1f3E)u5L3Uy9nJxoE9QhH)uvsDraYUH4s8ZAD6uAqAVXMMXb9Yl6EizKwPv9Sg3tDxLo4Hib7s23OwLSCff55Zra)1tHAKlHAavGw87Bv9OHjPj0(obwofASS6rkm3B0K2Vb9EJ(Qer1L5SekMmSgcDhdGwm3HKOOwcC(PXHKFkI5wYQouQvftFFQ5TJ4HSHkkFvHeHei9kwTAQOvfwNsY1ZhkHaryyFK16yCAPCCffdb8JqNhOjF)b6e)bkc2i7qbOXysYkSUJvrZOiCOLjlFb1hvx)6cxVfpgGIzHSCQ2aQGztkkwOhJIIuZkh)1cpC4BU8saHcAcivb75Yc(kI2FJJSFWq5YFjwqPaeuQDkctGIbfNPiErX1qEL3Jbbc6gmW7VsG8bigIdNzzO2OQUlhQBlQUM5MApX0m031mllxIJmn3UfoDIG7cLw5WSpGgUO8A8L(44)uuRnw4Xc5w1n(qPSXHK)r0w)YHHZSINKh1Lxo1ItDcn(rRCUlX1JhSouvkNtC2DCZEhMjgYzNCa4vkPGTdvN64q1KD3zMNspTcedM9yiiZNpzQLMHkbYBka)y5skJArphrtXRd7gw6wlVx4slM)a2A2)zT8YXlxjlnF1Y1ZVtyanEcuDyvDXqc4aUfDxNcLexzh1Q6RKXUhevRX1z)gjPSaF01SAEVftzn(PQo8tB4Ng(eqJph8qCt0st(4AGkdg)R)ec2140O2CT7pdP9Z4PGnT57V4ITzDC)JOU82VHaR4bPeL4pZ8m1(GHgTIopjWyDdwgbAvIyUC6YhoEitKFlRp1tntuM3iSp(IvwdOSTMJdMq(iG6N5Uxk)I5OkK8YsdVrgLJTTX5UrS1gLvIsIQmf6x)2PrRUVVwa86Qw4scm53BY9HBTtst7ucM3PByP1SXFpqTvggesW)XX3lYQsryqw)2Kq(o9y)QbDRMT5HBNLyIvxyuQH75kmDn4LeBo4BcN82fchsXhe)2qf7L)7gApHv(lA1eJhZOCRFdEG(ddU7fPhap1crl)IxD0a((RqSdrcPdgPDAMHpTubASJlpdBahwWpfWVP668DtG(4DPlP)akDK2eARd40gJxS8tZx8hnAvbxWim)UjMuIZytZhzgwU8M1dyOjmbCnBSy69FyjUxBjeAt8GsNSIkPw21XW6jKsF427eZ9YEWhTBH6zWILSdlFLQ53lNd1MGqVFZwchFjk8FMsmDFElX5FwlYe1lvHZo(mY1K49Puv1VfLsSdFtmbZbP1WmipOb7GqJXIQQben4udNww(Tv9xrzJ)k7YLPwOKnFGqjG4ewPZHnE9wtihFE6GqRLCnlQVsVi)IkhDEvq0vR4ds(vdUXwdtd3k0bA1nzJ2SUIP5sZMgdFHI2QYZXB8KQFgvME(Bef2QHTdt3WmAUvuIisvxLcEoSOGKitSMV7toeB0RBQ1KWd3Qzk4opcJeMabYfuqOg1kryWBmEE9eeFiaUYffbvmceu0wPkGUzY7TWHshieXI7)xIqi5gzOIsIJfrimc5rL8X7kDQDwUGI(kJoQf819muo6HBjUknRViLDHbGhdBIHdV5K4q1OkioUnQekTgPeBiF8E5hTisXVV0oIYEYovzR4QZTB5uUyiyrqUpBWbVgFtiZDjQVfKjqI)DWee5x26bV7BuQn8v)cE9SexkIPa4e8gFGN8kEMvEbvl7JA8)2moeJ2KgFavLPWZ)WrtU9O(NQ6rocTGtpj6iXqRYPC)g8sE(gN2UIMKCwJV49(Rq6TYTvHNvscRuaYewNsjToVJ5GiTueky6ySvEqRcTLYXGU1z76gvYjZF6NQD0TkZvrEeED3CjMGnm8e8INCyE2(pQAs4C)hFHyV2ql4loevQ)t2VANewUnv1)jIUUXp8FKAPYadEQtceWm9ra88QP3Oi3(hdUA0vDUUB)U9PDuVQdbikM6RuhoEzZM1b3GZUaA10W7EMFcefzMnkuqKotCpcXt4vzwFf5)GUd4eSbzrIf(dKTutf5)nX0JQiFV)254hOnOx7jECx2lr3UnCSuyqrglddVgCWkRdcGVi2rB(x8PLVy8c5jk)l(u0At)17gkxvrEY8hMVay1zDJPXojPXOw(dPqb)C3Oox3B4O(dhD9G2dV(QHk6x2VpIfyWzxPCx)Hx3D0G(9VUhk8IgVhoUBilCiVwpor1hKaojtvuj3xmrtFwXxetxKgZNFtSDnP54bd61EqBGT71h(PBBKJ6HC8DJA3zuNH9A3VD7EDg1FaoYv4kGYIC5y)f5SXZ6r1gLMPbrHo10K99ObErSWcbqVdnktVxQzmmXYqd2u1YmlZGJFbttKi7FOwk9cKwh1VB3HdBpQDx4FdgnQtKvzUAVc0rzz0ZJnP)(IfCOb88SiheZR9c41d2n9q2DBiXUItdver6fH5qexupYFlJfPaU1IiYUJfG7XPf3ocurgKxNOLW7lyaBd1VHCnzl7vQiMQRIY))p"

local Plater

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
	local success, scriptAdded, wasEnabled = Plater.ImportScriptString(importString, true)

	if success ~= true then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end
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
	minVersion = 92,
	requiredDeps = { { "trp3_nameplates", 1 } },
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});

_G.TRP3_PlaterNamePlates = TRP3_PlaterNamePlates
