## Patch notes
* The about template 2 edition works now correctly.
* You can now click anywhere on a test area to gain focus.
* The right side of text area is not cropped anymore
* When creating a new profile, the icon will be the racial one by default.
* Drop list can be closed by clicking again on the button.
* Drop list are closed when selecting a embedded level item.
* If a icon can't be rounded, it will be displayed as it and won't be replaced by a default Wow rounded icon.
* Complete revamp of "minimap button" location system. Please read the note below.
* There is no check button on the ignored list anymore.
* When "only when IC" option is selected for target frame display, the frame will correctly appears if passing to IC mode when selecting someone.
* Description vote counter is correctly refreshed when receiving a vote while having the description displayed.
* Adding "Getting position" buttons right to Birthplace and Residence fields.
* Add a "Delete all profiles" option on the purge actions.
* Changing "Miscellaneous" text to "More information" on characteristics.
* Add a "Close all" button on directory sub-menus.
* TRP main frame is closing when pressing ESC key.
* Alert when changing character edit tabs without saving.
* Directory third column now contains the "At first glance" and the "Unread description" flags.
* The IC icon on toolbar is the current profile character icon. The OOC icon is now the silhouette icon.
* Tooltip parameters - Anchor points are now present.
* You can use Tab key to cycle characteristics field (edit mode). Use shift + Tab key to cycle backward.
* "Save" text on Glance slot editor changed to "Save as preset".
* Add new eye color feature.
* Add new class color feature.
* Enter can be used to confirm prompt popup.
* Adding preview when selection background.

## Minimap button
As we (internaly) changed the way the minimap button is placed, it's more than probable that the button will be misplaced when launching 0.1.1 the first time. This is not a bug. Smile
If the button is out of range, please use this command to reset its position.

	/run TRP3_Configuration.minimap_x=0;TRP3_Configuration.minimap_y=0;ReloadUI();