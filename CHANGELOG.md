# Changelog version 2.4.2

## Fixed

- Fixed missing dracthyr default profile icon.
- Fixed companion profiles not working properly on the second pet from Animal Companion talent.
- Fixed companion profiles on water elementals in WotLK Classic (for real this time).
- Fixed broadcast channel order setting being checked before configuration was set up.
- Fixed an issue with chat links that could lead to blocked actions.

# Changelog version 2.4.1

## Added

- Added support for Retail 10.0.2.
- Added 5 icons, 68 images and 218 musics from patch 10.0.2 and before.
- Added the ability to right-click a pin after a map scan to open someone's profile.

## Fixed

- Fixed the "Hide immediately instead of fading" tooltip setting.
- Fixed another issue with water elemental pets not being valid targets to bind a companion profile to in WotLK Classic
- Fixed an issue with colorblind mode preventing companion tooltips from displaying.

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
