## The Total RP 3 world map button is back

After trying to put our scanning options in the world map filters dropdown (as it made a lot of sense for them to be there), we found out it was causing so many issues that it wasn't worth it. We have restored our Total RP 3 world map button to access the scanning options (quick reminder that you can move it around in the settings).

![Total RP 3's world map button is back!](https://totalrp3.info/documentation/changelogs/1_0_map_button.jpg)

## Bug fixes

- Fixed a Lua error when trying to get class color and there is no english class available ([ticket #78](https://wow.curseforge.com/projects/total-rp-3/issues/78)).
- Fixed a Lua error for unknown profiles when the mature filter is enabled ([ticket #76](https://wow.curseforge.com/projects/total-rp-3/issues/76)).
- Fixed a taint issue causing a message about an action blocked to be displayed in the chat frame when opening the world map during combat, by restoring the good old world map button. ([ticket #58](https://wow.curseforge.com/projects/total-rp-3/issues/58)).
- Fixed a taint issue preventing from queuing for battlegrounds by switching to a dedicated dropdown library ([ticket #59](https://wow.curseforge.com/projects/total-rp-3/issues/59)).
- Fixed an issue where the world map button anchoring position setting was not saved.
- Fixed the anchoring of the world map button so it is nicely placed in a good spot in all four corners.
- Fixed a Lua error in the Prat module ([ticket #81](https://wow.curseforge.com/projects/total-rp-3/issues/81)).

## Other improvements

- Added cooldown effect on the world map button while scanning.
- Total RP 3 will now honor the chat settings for coloring class names in the chat frame, so that it won't force class colors if you have disabled them. Note that the custom Total RP 3 colors are independent and will always be shown if you have the settings to show custom colors in chat enabled. Remember you can disable Total RP 3's customizations for individual channels in the settings ([ticket #79](https://wow.curseforge.com/projects/total-rp-3/issues/79)).
- Total RP 3 was always removing the realm info from player names, now you have an option disable that behavior in the chat settings ([ticket #80](https://wow.curseforge.com/projects/total-rp-3/issues/80)).
- Existing profiles are now sanitized on the first launch of the add-on.