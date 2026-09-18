-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_CompanionUtil = {};

function TRP3_CompanionUtil.GetDataProvider()
	return nil;
end

function TRP3_CompanionUtil.CanRenameCompanionPets()
	return TRP3_CompanionUtil.GetDataProvider():CanRenameCompanionPets();
end

function TRP3_CompanionUtil.GetCompanionPetIDs()
	return TRP3_CompanionUtil.GetDataProvider():GetCompanionPetIDs();
end

function TRP3_CompanionUtil.GetCompanionPetInfo(petID)
	return TRP3_CompanionUtil.GetDataProvider():GetCompanionPetInfo(petID);
end

function TRP3_CompanionUtil.IsCompanionPetUnit(unitToken)
	return TRP3_CompanionUtil.GetDataProvider():IsCompanionPetUnit(unitToken);
end

function TRP3_CompanionUtil.GetCompanionPetUnitName(unitToken)
	return TRP3_CompanionUtil.GetDataProvider():GetCompanionPetUnitName(unitToken);
end

function TRP3_CompanionUtil.GetSummonedCompanionPetID()
	return TRP3_CompanionUtil.GetDataProvider():GetSummonedCompanionPetID();
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
	return TRP3_CompanionUtil.GetDataProvider():GetMountIDs();
end

function TRP3_CompanionUtil.GetMountInfo(mountID)
	return TRP3_CompanionUtil.GetDataProvider():GetMountInfo(mountID);
end

function TRP3_CompanionUtil.GetMountSpellID(mountID)
	return TRP3_CompanionUtil.GetDataProvider():GetMountSpellID(mountID);
end

function TRP3_CompanionUtil.GetSummonedMountID()
	return TRP3_CompanionUtil.GetDataProvider():GetSummonedMountID();
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
