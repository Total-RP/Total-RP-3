# Changelog version 3.0.0

This version adds support for patch 11.0.

Thanks to Raenore for the help on some of these features.

## Added
- Added a "Currently" toolbar button letting you open a frame to quickly modify your Currently info.
- Added the ability to drag and drop personality traits to reorder them
  - Additional info now uses the same button style rather than drag and dropping the icon itself.
- Added 32 new background options for the "About" section (and Extended documents).
- Added X icons, X images and X musics from patch 11.0.

## Changed
- The UI has received an extensive makeover.
- The roleplay styles options at the bottom of the Miscellaneous section have been revised.
  - Removed "in-character frequence" and "battle resolution".
  - Added more settings to indicate what RP types your character is open to: "criminal activity" (theft, mugging) and "loss of control" (getting imprisoned or mind controlled).
- New profiles (and the default profile) now default to OOC when created.
- RP proficiency is now an account-wide setting rather than per profile, and has been adjusted to add an option between Beginner and Experienced.
  - Beginner/Guide icons have been updated on Retail.
  - As part of this change, the setting has been reset and should be set again.
- Tooltip bottom icons have been changed.
  - **TODO: INSERT IMAGE**
- Other players default profiles will no longer appear in your directory or be used for chat/nameplate customization.
- Toolbar button and slash command for the NPC speech window now closes it if already shown.

## Fixed
- Fixed some causes of lingering tooltips.
  - A tooltip option to disable soft target support has been added should the issues still persist.
- Fixed an issue where disabling the KuiNameplates module would break KuiNameplates itself.
- Fixed an issue when disabling Extended while a launcher action was set to an Extended action.
- Fixed target companion names not getting customized on tooltips.
- Character names are now customized in the TRP dice roll output.
- Fixed mount titles not wrapping properly on their tooltip.
- Glances with empty names will now show as such instead of replacing it with "...".
- Fixed the directory tutorial not properly scaling with the window and reworked its content.
- Fixed an issue where the glance editor would sometimes overlap with other elements in the UI (like the target frame).
- Fixed an issue with non-Latin alphabets displaying incorrectly or causing a different font to linger in some cases.
- Fixed cases where the TRP tooltip would fail to display in the correct position while using ElvUI.
- Fixed an issue when trying to change language from Traditional Chinese.

## Removed
- Removed UI sound and animation settings.
- Removed Info tooltip size setting. (The game should already auto-adjust font size on high resolutions)

# Changelog version 2.8.4

## Added

- The original tooltip can now be shown instead of the TRP tooltip by pressing Alt.
  - This can be disabled (or the modifier key can be changed) in Tooltip settings > "Hide on modifier key".
- Added profile tooltip support for soft targets.
  - This is mostly relevant to ConsolePort users with "Enable Soft Friend Targeting" and "Show Friendly Tooltip", but impacts anyone with the SoftTargetFriend and SoftTargetTooltipFriend CVars enabled.

## Fixed

- Fixed companion titles not wrapping properly on tooltips.
- Fixed the timerunner icon not showing when names are customized in chat (unless the profile icon is included in the customization).
- The temporary workaround for disconnects has been extended indefinitely.
  - It was set to expire at the end of May assuming the issue would be fixed by then, which has not been the case. As we don't know for sure when it will, we'll just release a new version to remove it once it has.
