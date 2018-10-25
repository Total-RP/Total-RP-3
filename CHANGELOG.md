# Changelog version 1.5.0

## Changes from beta 2 to beta 3

- Fixed an issue with the workaround to restore the selected language after a loading screen when no languages had ever been saved before.
- Fixed an issue causing the localized text for the map scans button to always use English instead of the current locale.


## Changes from beta 1 to beta 2

- Fixed an incompatibility issue with the Details! add-on introduced with the workaround for the broadcast channel position.

## Re-implemented map scans feature

You can now once again scan for Total RP 3 users on the world map.

- Added support for War Mode. Players that are not in the same War Mode as you will not appear on the world map by default.
- In the Location settings (Register settings tab) you can enable the option to show people who are in a different War Mode, they will appear greyed out and semi-transparent on the world map, and will be grouped separately when displayed in the tooltip.
- You can opt in to not be visible to other players while you are in War Mode.
- Map scans now differentiate between levels of a same zone (like Dalaran), and setting your home to a specific level of map will now correctly show on that level when users click on the home button on your profile.

Please note: Only players with Total RP 3 version 1.5.0 and above will show up. Total RP 3: Extended's scans will be updated to working with this new system.

## Profile reporting

Since patch 8.0.1 you are able to report profiles that violates Blizzard's Terms of Services by opening a support ticket.

- Following Blizzard's guidance, you can now report a player who have a profile that goes against the Code of Conduct via Total RP 3's target frame. A standard game report window will open pre-filled with information about the player you are reporting.

![](https://www.dropbox.com/s/ly0r2za3h8zwqto/report_icon.png?raw=1)

- Since it is not technically possible to report a player you cannot target, we have added a button to the profile page when opening a profile that opens up a link to a Blizzard support page on how to report add-on text.

## Added

- Added a workaround against a current game bug that will always reset the language currently selected after a loading screen. You can disable this workaround in cases of issues in the advanced settings.
- Added a workaround to make sure Total RP 3's broadcast channel (xtensionxtooltip2) is always at the bottom of the channel list. This should fix issues where it would be the first channel and move all others channels you have joined down in the list. You can disable this workaround in cases of issues in the advanced settings.
