# Changelog version 3.0.0

This version adds support for patch 11.0.

Thanks to Raenore for the help on some of these features, and keyboardturner for the new silhouette logo.

## Added
- Added a new Relations menu located in the Customization section, alongside the moved Automation settings.
  - This menu lets you edit the preset relations you can have with other players, as well as create new ones.
  - Those relations are still only personal, and not shared with other players.
  - The relation will now be shown as a line on the tooltip in addition to the border color. This can be disabled in Tooltip settings.
- Added a "Currently" toolbar button letting you open a frame to quickly modify your Currently info.
- Added a toolbar button to open/close the main Total RP 3 window.
- Added a target frame button for your own companion to auto-fill the speech window with its name in brackets.
  - This will apply RP name customization to its speech lines.
- Added a dropdown to set whether you are open to other players walking up to your character.
  - This will show as an icon on your tooltip.
  - Existing tooltip bottom icons have also been changed for clarity.
    - **TODO: INSERT IMAGE**
- Added the ability to drag and drop personality traits to reorder them
  - Additional info now uses the same button style rather than drag and dropping the icon itself.
- Added the ability to duplicate a personality trait or additional info line.
  - This is located within the new Options button at the end of the line, alongside deletion of the trait.
- Added the ability to right-click an icon button to copy/paste icons between buttons or copy the name of the selected icon.
- Added 32 new background options for the "About" section (and Extended documents).
- The toolbar will now be skinned while using ElvUI.
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
- Other players default profiles will no longer appear in your directory or be used for chat/nameplate customization.
- Character names are now customized in the TRP dice roll output.
- Glances with empty names will now show as such instead of replacing it with "...".
- Glances from your character still show their icons on your profile and target frame while disabled.
  - These will still not be sent to other players.
- Toolbar button and slash command for the NPC speech window now closes it if already shown.
- Clicking the target frame button for companion profiles now directly opens the profile.
  - The options menu to unbind/select a new profile can still be accessed with a right-click.
- The companion/mount profile buttons no longer change icon based on the selected profile.
- Tooltip texts across the addon were reworked to follow a more consistent format and add clarity when needed.

## Fixed
- Fixed some causes of lingering tooltips.
  - A tooltip option to disable soft target support has been added should the issues still persist.
- Fixed an issue where disabling the KuiNameplates module would break KuiNameplates itself.
- Fixed an issue when disabling Extended while a launcher action was set to an Extended action.
- Fixed target companion names not getting customized on tooltips.
- Fixed mount titles not wrapping properly on their tooltip.
- Fixed the directory tutorial not properly scaling with the window and reworked its content.
- Fixed an issue where the glance editor would sometimes overlap with other elements in the UI (like the target frame).
- Fixed an issue with non-Latin alphabets displaying incorrectly or causing a different font to linger in some cases.
- Fixed cases where the TRP tooltip would fail to display in the correct position while using ElvUI.
- Fixed an issue when trying to change language from Traditional Chinese.

## Removed
- Removed UI sound and animation settings.
- Removed Info tooltip size setting. (The game should already auto-adjust font size on high resolutions)
- Removed the ability to copy glances from other players.

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
