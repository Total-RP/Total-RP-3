-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local cachedSummonedMountID = nil;

TRP3_CompanionUtil = {};

function TRP3_CompanionUtil.CanRenameCompanionPets()
	return true;
end

function TRP3_CompanionUtil.GetCompanionPetIDs()
	return C_PetJournal.GetOwnedPetIDs();
end

function TRP3_CompanionUtil.GetCompanionPetInfo(petID)
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

function TRP3_CompanionUtil.IsCompanionPetUnit(unitToken)
	return UnitIsBattlePetCompanion(unitToken);
end

function TRP3_CompanionUtil.GetCompanionPetUnitName(unitToken)
	local name = UnitNameUnmodified(unitToken);
	return name;
end

function TRP3_CompanionUtil.GetSummonedCompanionPetID()
	return C_PetJournal.GetSummonedPetGUID();
end

function TRP3_CompanionUtil.EnumerateCompanionPets()
	local function GetNextPet(petIDs, petIndex)
		petIndex = petIndex + 1;
		local petID = petIDs[petIndex];

		if petID ~= nil then
			local petInfo = TRP3_CompanionUtil.GetCompanionPetInfo(petID);
			return petIndex, petInfo;
		end
	end

	local petIDs = TRP3_CompanionUtil.GetCompanionPetIDs();
	local petIndex = 0;
	return GetNextPet, petIDs, petIndex;
end

function TRP3_CompanionUtil.GetMountIDs()
	return C_MountJournal.GetMountIDs();
end

function TRP3_CompanionUtil.GetMountInfo(mountID)
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

function TRP3_CompanionUtil.GetMountSpellID(mountID)
	local _, spellID = C_MountJournal.GetMountInfoByID(mountID);
	return spellID;
end

function TRP3_CompanionUtil.GetSummonedMountID()
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
		for _, mountID in ipairs(TRP3_CompanionUtil.GetMountIDs()) do
			local _, _, _, isActive = C_MountJournal.GetMountInfoByID(mountID);

			if isActive then
				cachedSummonedMountID = mountID;
				break;
			end
		end
	end

	return cachedSummonedMountID;
end

function TRP3_CompanionUtil.EnumerateMounts()
	local function GetNextMount(mountIDs, mountIndex)
		mountIndex = mountIndex + 1;
		local mountID = mountIDs[mountIndex];

		if mountID ~= nil then
			local mountInfo = TRP3_CompanionUtil.GetMountInfo(mountID);
			return mountIndex, mountInfo;
		end
	end

	local mountIDs = TRP3_CompanionUtil.GetMountIDs();
	local mountIndex = 0;
	return GetNextMount, mountIDs, mountIndex;
end
