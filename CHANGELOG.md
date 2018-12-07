# Changelog version 1.5.1

## Fixed

- Fixed an issue that would make users still send their map location when the option to not send it when your roleplaying status is set to "Out of character" was enabled and they were indeed "Out of character".
- Fixed an issue that would prevent the `/trp3 roll` to work properly when in a group or a raid.
- Other layers' characters information without a profile attached to them are now correctly purged on startup to avoid storing them indefinitely.
- Profiles received from links are now correctly applied a "Last seen" timestamp so they are correctly treated by the automatic directory purge instead of being always deleted because of the lack of timestamp.
- The add-on will now warn you with a different message than the regular one if you are several versions behind and are at risk of issues because of that.
- The advanced settings would not get the user selected localization applied to their texts.
- Fixed issues related to upcoming API changes in patch 8.1.

# Changelog version 1.5.0

## Re-implemented map scans feature

You can now once again scan for Total RP 3 users on the world map.

![Location of players in a different War Mode](https://totalrp3.info/documentation/changelogs/1_5_0_location_war_mode.PNG)

- Added support for War Mode. Players that are not in the same War Mode as you will not appear on the world map by default.
- In the Location settings (Register settings tab) you can enable the option to show people who are in a different War Mode, they will appear greyed out and semi-transparent on the world map, and will be grouped separately when displayed in the tooltip.
- You can opt in to not be visible to other players while you are in War Mode.
- Map scans now differentiate between levels of a same zone (like Dalaran), and setting your home to a specific level of map will now correctly show on that level when users click on the home button on your profile.

Please note: Only players with Total RP 3 version 1.5.0 and above will show up. Total RP 3: Extended's scans will be updated to work with this new system.

## Profile reporting

Since patch 8.0.1 you are able to report profiles that violate Blizzard's Terms of Service by opening a support ticket.

- Following Blizzard's guidance, you can now report a player who has a profile that goes against the Code of Conduct via Total RP 3's target frame. A standard game report window will open pre-filled with information about the player you are reporting.

![The target frame report button](https://totalrp3.info/documentation/changelogs/1_5_0_report_target_button.png)

![Prefilled message when reporting a player](https://totalrp3.info/documentation/changelogs/1_5_0_report_window.PNG)

- Since it is not technically possible to report a player you cannot target, we have added a button to the profile page when opening a profile that opens up a link to a Blizzard support page on how to report add-on text.

![The profile page report button](https://totalrp3.info/documentation/changelogs/1_5_0_report_profile_button.PNG)

## Added

- Added a workaround against a current game bug that will always reset the language currently selected after a loading screen. You can disable this workaround in case of issues in the advanced settings.
- Added a workaround to make sure Total RP 3's broadcast channel (xtensionxtooltip2) is always at the bottom of the channel list. This should fix issues where it would be the first channel and move all other channels you have joined down in the list. You can disable this workaround in case of issues in the advanced settings.
