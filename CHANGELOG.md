# Changelog version 2.3.5

## Added

- Added support for Burning Crusade Classic.

## Fixed

- Fixed several performance issues when requesting character profiles.

# Changelog version 2.3.4

## Fixed

- Fixed an issue with links in brackets displaying incorrectly in chat while using ElvUI.

# Changelog version 2.3.3

## Added
- Added tooltip fields for character zone and health. These fields can be toggled in Tooltip settings.
  - The zone field will only show when the character is in another zone (if looking at a party member for instance).
  - The health field will only show if the character is not full health. It is disabled by default.

## Fixed
- Fixed a few issues with profile transfer.
- Fixed Kui name-only RP nameplates not updating when level text and health were both disabled.
- Fixed inability to set a pet profile when the pet is first summoned.
- Fixed TRP tooltip overlapping with the main tooltip if the profile has been caught by the mature filter.
- Fixed TRP chat links breaking from emote/OOC/speech detection.
- Fixed Currently/OOC fields not properly hiding on tooltips if they only contained whitespaces.

# Changelog version 2.3.2

## Added

- Added settings for right-click options on unit frames and chat names.

## Fixed

- Fixed incorrect names showing up on Blizzard NPC nameplates.
- Fixed display issue with KuiNameplates tank mode.
- Fixed a dependency issue preventing chat customization from working when using Prat and Listener.
- Fixed localization not being properly applied to various settings.

# Changelog version 2.3

## Added

- Added a module to customize nameplates with RP information. At present, **only default Blizzard nameplates and KuiNameplates** are supported.

*As it is now redundant, the TRP3: KuiNameplates module will now disable itself and should be uninstalled.*

- Added support for companion profiles in Classic.
- Added entries on unit frames right-click menu to open profile + change roleplay status.
- Added a window to copy character names linked to a profile when right-clicking it in the directory list.
- Added an option to disable profile tooltips in instances.

## Changed

- The URL copy window now closes after pressing the copy shortcut.
- The default profile no longer shows the amount of characters bound to it.
- Cropped characteristic fields will now show a tooltip on hover with the full content of the field.
- The description editor will now receive input focus after clicking any formatting tool button.
- Customized names in chat frames that have excessively large lengths will now be cropped.
- Custom colors for personality traits now apply to attribute names.

## Fixed

- Fixed an issue with chat customization not properly registering on login while using Prat.
- Fixed missing sound cue when opening/closing the main window.
- Fixed an issue that could cause PvP flagged players to show their location on map scans in Classic.
- Fixed missing vulpera language icon.

# Changelog version 2.2

## Added

- Added Pronouns preset in Additional information. When using this preset, the pronouns will be shown on your tooltip.
- Added support for companion profiles on the secondary pet summoned with the hunter talent Animal Companion.
- Added a hunter pet browser when binding a companion profile through the profile list.

## Fixed

- Fixed chat link tooltips being invisible when first opening one.
- Fixed formatting issues with chat links.
- Fixed an issue causing the battle pet browser to show an incomplete list if the battle pet collection had search filters applied.
- Fixed invalid icons in the About tab when receiving a profile from other RP addons on Classic.
- Fixed incorrect information on the tooltip of the NPC speech prefix setting.
- Fixed an issue with Tukui chat history.
