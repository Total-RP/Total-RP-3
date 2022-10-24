# Changelog version 2.4

## Added

- Added support for Retail 10.0.0.
- Added 2246 icons from patch 10.0.0.
- Added 2 new command lines for use in macros:
  - /trp3 set: Allows you to set a profile field to a given value.
  ![](https://user-images.githubusercontent.com/287102/197398575-4ea8f528-a212-4cdb-a4ce-9297638d4de9.png)
  - /trp3 location: Allows you to control whether or not you appear on the map scan.
- Added macro conditionals for the 2 aforementioned command lines:
  - [ic], [ooc], [rpstatus:{status}] - IC/OOC status
  - [loc:{location name}], [location:{location name}] - Current location
  - [profile:{profile name}] - Current profile name
  - Regular macro conditionals are also supported

## Fixed

- Fixed an issue with the color picker not working in WotLK Classic.
- Fixed an issue with water elemental pets not being valid targets to bind a companion profile to in WotLK Classic.
- More tooltip cleanup.

## Removed

- Removed temporarily right-click menu options in Retail due to a conflict with Edit Mode that can prevent the use of abilities in combat. They will be re-added once the conflict has been resolved.
