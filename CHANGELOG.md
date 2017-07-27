This is a small "improvements and bug fixes" update while I'm working on bigger projects (profile changes automation) for version 1.3 :)

## Improvements

- Since we kept seeing invalid bug reports from users who are inserting non-supported codes inside their profiles, Total RP 3 will now clean the user profile from these invalid codes on launch and try to prevent advanced editing on runtime. From now on, any bug report involving profiles that have non supported codes injected in them will be systematically ignored.
- Added custom module for the [TinyTooltip](https://mods.curse.com/addons/wow/268266-tinytooltip) add-on to apply its tooltip modifications to Total RP 3's tooltips.
- Added character limitation on the NPC speeches window and a character count to indicate how many characters are remaining for your message — [Issue #101](https://wow.curseforge.com/projects/total-rp-3/issues/101)
- Added a button to reset the mature filter dictionary to its default values — [Issue #97](https://wow.curseforge.com/projects/total-rp-3/issues/97)

## Bug fixes

- Fixed alignment of the text field labels for personality traits.
- Fixed an issue where the text popup for copying the URL of a link clicked in a profile had truncated text if another add-on added a limit on the text input before Total RP 3 opened the pop-up — [Issue #113](https://wow.curseforge.com/projects/total-rp-3/issues/113)
- Fixed an issue with the custom WIM integration — [Issue #108](https://wow.curseforge.com/projects/total-rp-3/issues/108)
- Updated the libraries used by the add-on the their latest version, including the drop-downs library, in order to fix some issues with the drop-downs.
