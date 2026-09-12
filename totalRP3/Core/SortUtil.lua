-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_SortUtil = {};

---@param array table
---@param comparator fun(a: any, b: any): boolean
function TRP3_SortUtil.MergeSort(array, comparator)
	local count = #array;
	local buffer = {};
	local source, target = array, buffer;
	local width = 1;

	while width < count do
		for left = 1, count, width * 2 do
			local middle = math.min(left + width, count + 1);
			local right = math.min(left + width * 2, count + 1);
			local targetIndex = left;
			local leftIndex, rightIndex = left, middle;

			while leftIndex < middle and rightIndex < right do
				if comparator(source[leftIndex], source[rightIndex]) then
					target[targetIndex] = source[leftIndex];
					leftIndex = leftIndex + 1;
				else
					target[targetIndex] = source[rightIndex];
					rightIndex = rightIndex + 1;
				end
				targetIndex = targetIndex + 1;
			end

			while leftIndex < middle do
				target[targetIndex] = source[leftIndex];
				leftIndex = leftIndex + 1;
				targetIndex = targetIndex + 1;
			end

			while rightIndex < right do
				target[targetIndex] = source[rightIndex];
				rightIndex = rightIndex + 1;
				targetIndex = targetIndex + 1;
			end
		end

		source, target = target, source;
		width = width * 2;
	end

	if source ~= array then
		for index = 1, count do
			array[index] = source[index];
		end
	end
end
