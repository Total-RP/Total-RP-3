# Change-log for version @project-version@ of Total RP 3

## Bug fixes

- Fixed several issues with the new chat system introduced in version 1.2.5 that would prevent player names form being colored correctly ([ticket #50](https://wow.curseforge.com/projects/total-rp-3/issues/50)).
- Fixed a Lua error in the new WIM module ([ticket #55](https://wow.curseforge.com/projects/total-rp-3/issues/55)).
- Fixed an issue where the option to increase color contrast on player names in the tooltip was always enabled ([ticket #51](https://wow.curseforge.com/projects/total-rp-3/issues/51)).
- Fixed a Lua error when shift-clicking a spell name in the adventure journal ([ticket #61](https://wow.curseforge.com/projects/total-rp-3/issues/61)).
- Fixed an issue making the game freeze and possibly crash when trying to delete too many companion profiles from the directory. Additionally, companion profiles are now included in the automatic purge ([ticket #56](https://wow.curseforge.com/projects/total-rp-3/issues/56)).
- Fixed a long standing issue allowing advanced users to inject custom icons and color codes in places that were not meant for that, as this behaviour led to game crashes, as well as compatibility issues with other RP add-ons and stability issues in Total RP 3 itself ([ticket #63](https://wow.curseforge.com/projects/total-rp-3/issues/63)).
- The option to increase contrast on color names in the tooltip is now applied on the other colored fields, not just the name field.
- Added notice on the Auto add new players option of the directory to indicate that disabling this option will prevent you from receiving any new profile.