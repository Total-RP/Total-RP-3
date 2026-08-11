-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local CHANGELOG_TEXT = [[
# Changelog version 3.4.0

## Added

- Added 399 icons, 58 images and 92 musics from patch 12.1.0 and earlier.
  - Note: For the foreseeable future, expect many new icons to not be added to the icon browser, as Blizzard is removing icon names from the game files.
- Added a Directory setting to make the About page easier to read. It forces the background to black and removes custom text colours.
- Added handles to reorder relations.
- Added RP name support to the raid warning channel.

## Changed

- The profile list page has been overhauled, including a new flow for profile creation.
  - Importing a profile is now done through profile creation (rather than overwriting an existing profile).
- Relations can now be deleted even when still assigned to any profile.

## Fixed

- Fixed some errors related to patch 12.1 API changes.

# Changelog version 3.3.8

- Classic versions are now fully supported again, bringing them all improvements made since version 3.1.2, including Platynator support and tag search in the icon browser.

# Changelog version 3.3.7

## Added

- Added 71 icons and 12 musics from patch 12.0.7.

## Changed

- Imported profiles will now reuse their IDs if possible, to avoid losing profile-specific notes as well as others losing notes and relations.

## Fixed

- Fixed conflicts with other chat addons (Chattery, Languages) when parsing chat tokens.
- Fixed an error with pets in instances.
- Fixed an error with nameplate colors in instances.
]];

function TRP3_DashboardUtil.GenerateChangelog()
	return TRP3_DashboardUtil.GenerateListMarkup(CHANGELOG_TEXT);
end
