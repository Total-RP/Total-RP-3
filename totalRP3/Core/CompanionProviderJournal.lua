-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local cachedSummonedMountID = nil;

local CompanionProviderJournal = {};

function CompanionProviderJournal:CanRenameCompanionPets()
	return true;
end

function CompanionProviderJournal:GetCompanionPetIDs()
	return C_PetJournal.GetOwnedPetIDs();
end

function CompanionProviderJournal:GetCompanionPetInfo(petID)
	local speciesID, customName, _, _, _, _, _, speciesName, icon, _, _, _, description = C_PetJournal.GetPetInfoByPetID(petID);

	if not speciesID then
		return;
	end

	return {
		id = petID,
		name = (customName ~= "") and customName or speciesName,
		customName = customName ~= "" and customName or nil,
		icon = icon,
		description = description,
		speciesName = speciesName,
		isCollected = true,
	};
end

function CompanionProviderJournal:IsCompanionPetUnit(unitToken)
	return UnitIsBattlePetCompanion(unitToken);
end

function CompanionProviderJournal:GetCompanionPetUnitName(unitToken)
	return UnitNameUnmodified(unitToken);
end

function CompanionProviderJournal:GetSummonedCompanionPetID()
	return C_PetJournal.GetSummonedPetGUID();
end

function CompanionProviderJournal:GetMountIDs()
	return C_MountJournal.GetMountIDs();
end

function CompanionProviderJournal:GetMountInfo(mountID)
	local name, spellID, icon, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID);
	local _, description = C_MountJournal.GetMountInfoExtraByID(mountID);

	if not spellID then
		return;
	end

	return {
		id = mountID,
		name = name,
		icon = icon,
		description = description,
		isCollected = isCollected,
		spellID = spellID,
	};
end

function CompanionProviderJournal:GetMountSpellID(mountID)
	local _, spellID = C_MountJournal.GetMountInfoByID(mountID);
	return spellID;
end

function CompanionProviderJournal:GetSummonedMountID()
	if not IsMounted() then
		return nil;
	end

	-- Is the last mount that we tested still the current summon?
	if cachedSummonedMountID ~= nil then
		local _, _, _, isActive = C_MountJournal.GetMountInfoByID(cachedSummonedMountID);

		if not isActive then
			cachedSummonedMountID = nil;
		end
	end

	-- Has our cache been invalidated? If so, scan the journal.
	if cachedSummonedMountID == nil then
		for _, mountID in ipairs(self:GetMountIDs()) do
			local _, _, _, isActive = C_MountJournal.GetMountInfoByID(mountID);

			if isActive then
				cachedSummonedMountID = mountID;
				break;
			end
		end
	end

	return cachedSummonedMountID;
end

function TRP3_CompanionUtil.GetDataProvider()
	return CompanionProviderJournal;
end
