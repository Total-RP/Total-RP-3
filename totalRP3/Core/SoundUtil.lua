-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_SoundUtil = {};

function TRP3_SoundUtil.IsMusicEffectivelyDisabled()
	if not TRP3_CVarCache:GetCVarBool(TRP3_CVarConstants.EnableAllSound) then
		return true;
	elseif not TRP3_CVarCache:GetCVarBool(TRP3_CVarConstants.EnableMusic) then
		return true;
	elseif (TRP3_CVarCache:GetCVarNumber(TRP3_CVarConstants.MusicVolume) or 1) <= MathUtil.ApproxZero then
		return true;
	end

	return false;
end
