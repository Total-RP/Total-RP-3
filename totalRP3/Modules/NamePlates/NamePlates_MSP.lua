-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MSPNamePlates = {};

function TRP3_MSPNamePlates:OnLoad()
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "PLAYER_ENTERING_WORLD", self.OnEnterWorld, self);
end

function TRP3_MSPNamePlates:OnEnterWorld()
	if not TRP3_NamePlatesUtil.HasMSPNamePlateAddOn() then
		return;
	end

	TRP3_NamePlates.RegisterCallback("OnNamePlateDataUpdated", self);
end

function TRP3_MSPNamePlates:OnNamePlateDataUpdated()
	-- Dummy handler; we don't implement MSP-based decorations ourselves, but
	-- we need to keep the data update callback registered so that we can
	-- send off requests for visible nameplates.
end

TRP3_MSPNamePlates:OnLoad();
