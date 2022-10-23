# Changelog version 2.3.13

## Fixed

- Fixed missing death knight icons on Classic WotLK.
- Fixed some more profile modifications.

# Changelog version 2.3.12

**Classic users: Companion profiles may have to be relinked due to API changes.**

## Added

- Added settings to change the colors you see for other players' tooltips.
- Added 5 new music files from patch 9.2.7, as well as data for WotLK Classic.
- Added macro conditionals support for the "/trp3 profile" command.
- Added a tooltip to view settings texts in full even if they are too long.
- Added Evoker class color preset to the color picker.

## Fixed

- Fixed an issue with tooltip color rendering when using some Unicode characters.
- Fixed inconsistent linebreaks in Template 1.
- Removed some unwanted modifications in profiles.
- Fixed a potential crash when reordering miscellaneous information lines.
- Added a delay before joining the broadcast channel to reduce issues with chat channels swapping numbers/colors.
- Fixed dead links in "About Total RP 3".

# Changelog version 2.3.11

**With the recent changes of patch 9.2.5, profiles can now be seen cross-faction for players in your party, or with whom you share a cross-faction WoW community.**

## Added

- Added 3 icons and 4 music files from patch 9.2.5.
- Surrounding link tags with color tags will now apply the color to the link.

## Fixed

- Fixed the target frame not having the proper skin when using ElvUI.

# Changelog version 2.3.10

## Added

- Added 438 icons, 133 music files and 10 images from patch 9.2.0, 2 icons from Burning Crusade Classic and 3 icons from Classic Era.

# Changelog version 2.3.9

## Added

- Added 32 icons and 7 music files from patch 9.1.5, 21 icons from Burning Crusade Classic and 2 icons from Classic Era.

## Fixed

- Fixed an issue with the character scan tooltips not showing since patch 9.1.5.

# Changelog version 2.3.8

## Fixed

- Fixed tooltip issues for patch 9.1.5.

# Changelog version 2.3.7

This version is updated for TBC Classic 2.5.2.

## Fixed

- 9.1 icons and musics have been properly added for retail.
- Fixed an issue with TRP3: Extended creation exchange failing in very specific cases.

# Changelog version 2.3.6

## Added

- Added 323 new icons, 7 images and 138 new music files from patch 9.1.0.

## Removed

- Removed the roleplay language flag.
- Fixed a bug with chat channels on Classic.

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
