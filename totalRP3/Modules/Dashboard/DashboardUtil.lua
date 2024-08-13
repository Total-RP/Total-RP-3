-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_DashboardUtil = {};

function TRP3_DashboardUtil.GenerateListBullets(description)
	local minLevel = math.max(1, description and description.minimumListLevel or -math.huge);
	local maxLevel = math.min(5, description and description.maximumListLevel or math.huge);
	local base = "interface/addons/totalrp3/resources/ui/ui-list-bullet-%d";

	local bullets = {};

	for level = minLevel, maxLevel do
		local file = string.format(base, level);
		local markup = TRP3_MarkupUtil.GenerateFileMarkup(file, description);

		table.insert(bullets, markup);
	end

	return bullets;
end

function TRP3_DashboardUtil.GenerateDefaultListSpacer()
	return TRP3_MarkupUtil.GenerateSpacerMarkup({ size = 12, offsetY = -5 });
end

function TRP3_DashboardUtil.GenerateDefaultListBullets()
	return TRP3_DashboardUtil.GenerateListBullets({ size = 12, offsetY = -5 });
end

function TRP3_DashboardUtil.GenerateListMarkup(str, description)
	local spacer;
	local bullets;

	if description then
		spacer = description.spacer;
		bullets = description.bullets;
	end

	if not spacer then
		spacer = TRP3_DashboardUtil.GenerateDefaultListSpacer();
	end

	if not bullets then
		bullets = TRP3_DashboardUtil.GenerateDefaultListBullets();
	end

	local function FormatListItem(indent)
		repeat
			-- Consider non-breaking spaces to be leading whitespace.
			local replaced;
			indent, replaced = string.gsub(indent, "\194\160", " ");
		until replaced == 0;

		local level = (#indent / 2) + 1;
		local bullet = bullets[Clamp(level, 1, #bullets)];

		return string.gsub(indent, "..", spacer) .. bullet;
	end

	local lines = { string.split("\n", str) };

	for index, line in ipairs(lines) do
		line = string.gsub(line, "^([ \194\160]*)%-", FormatListItem);
		lines[index] = line;
	end

	return table.concat(lines, "\n");
end
