# Changelog version 1.6.8

## Changed

- **Classic:** Due to 1.13.3 API changes, the map scan has been modified to find characters in yell range only. It will only show on the map you're in. **Only characters using Total RP 3 version 1.6.8 will be visible on the scan.**

*Reminder : You can disable your scan appearance by unchecking "Register settings > Location settings > Enable character location. Please don't hold on the update for visibility reasons.*

- Speech detection will now only apply to emotes (including NPC emotes).

## Fixed

- Fixed a rare issue where the addon loading process would be interrupted by a setting key unable to be read.

# Changelog version 1.6.7.1

## Fixed

- Fixed an issue with profiles not transmitting through Battle.net since 8.2.5 release. (Thanks for the useless wrapper, Blizzard.)

## Changed

- Updated logo artist credit (Kelandiir).

# Changelog version 1.6.7

## Added

- Added a setting to detect speech in emotes and automatically color it.
![Speech detection](https://i.imgur.com/qpw46yg.png)
- Added 7 icons and 1 music from patch 8.2.5.

## Changed

- The companion profiles list accessed through the target frame is now alphabetically sorted, and "Create new profile" has been moved out of it.

# Changelog version 1.6.6

## Added

- Added slash commands to change your roleplay status, which you can use in macros. You can now use `/trp3 status ic` to get in character, `/trp3 status ooc` to get out of character, or `/trp3 status toggle` to switch status.
- Added a chat setting to display the OOC indicator next to the name in chat.
- Added a setting to hide the map scan button if no scan is available.
- Added a roleplay language field to the main dashboard.
  - This setting is profile-based, defaults to your addon language, and allows you to indicate the language you're roleplaying in.
  - If your addon language doesn't match a player's roleplaying language, you'll see a flag at the bottom of their tooltip indicating their roleplaying language.
  - This change is mainly aimed at Classic roleplayers, as only English RP realms were made.
- Added back buttons to toggle helmet and cloak display for Classic.

## Changed

- Renamed the war mode setting to PvP mode for Classic.

## Fixed

- Fixed issues when the target bar module was disabled.
- Fixed an issue causing duplicate Mary-Sue Protocol profiles to appear in the register when unchecking "This realm only".
- Fixed a few remaining missing icons for Classic (default template 3 icons and `/trp3 roll` icons)
- Fixed an issue when using the "Right-click to open profile" setting on Classic.
