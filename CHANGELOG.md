# Changelog for version 1.3.4.2

- The NPC speeches frame now closes when pressing the escape key.
- Updated the list of Patreon supporters in the About tab.

## Chat links fixes

- Fixed a Lua error that would happen when the directory is being purged of old profiles and one of them was received from a chat link, and was not properly formatted.
- Simplified wording when creating a new chat link so that the alert is more quickly readable and the buttons actions are more obvious.
- The technical information shown in the chat links tooltip (type of link, sender name, size) are now only shown when the Alt key is held down, so that by default links only show RP-related information.
- The chat links tooltip title now uses the text size defined in the tooltip settings.
- Fixed an issue where player profiles that were marked as non-importable when creating a link would still show the import button in the tooltip.
- Fixed and improved the buttons alignment in the chat links tooltip.
- **Directory profiles can no longer be made importable**, only the players who were seen with a linked profile will be able to import it (so that you can still link someone their profile if they lost it and they will be able to import them back).

# Changelog for version 1.3.4.1

- Fixed a possible issues with other add-ons drop down menus.

# Changelog for version 1.3.4

## Added

- Chat links now indicate the size of the content in the tooltip.
- Added an option in the tooltip settings to use the old OOC indicator (the red dot in the top right corner) instead of the [OOC] red text.
- Added information text on the profile export window to warn about using advanced text editing software when copy-pasting serialized profile as they can alter the data when replacing special characters like quotes.

## Modified

- The dashboard has received under-the-hood improvements to improve localization and prepare for future features.
- Streamlined color picker presets UI to avoid confusions. Only the presets button is now visible, bellow the color preview. The presets dropdown now gives access to saving, renaming and deleting custom presets.
- Player personality traits now only show the value numbers when the cursor is on the bar.
- Improved generation of chat links for better efficiency.
- Updated list of Patreon supporters.

## Fixed

- Fixed a missing option dependency for the mature filter strength slider so that it is correctly disabled when the mature filter is disable.
- Fixed an issue with the import/export profile UI when a profile had the `~` character inside a field.
