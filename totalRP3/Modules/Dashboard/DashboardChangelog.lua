-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.0.11

## Added

- Added 65 icons, 7 images and 5 musics from patch 11.1.7.

## Fixed

- Fixed icon links being formatted incorrectly for MRP users.
- Fixed issues with tutorials.

For a visual guide to the major changes of version 3.0, please see [this article](https://github.com/Total-RP/Total-RP-3/wiki/Guide-to-version-3.0) on our wiki.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
