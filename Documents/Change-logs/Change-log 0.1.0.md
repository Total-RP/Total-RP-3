## Scope of this release

* Total RP 3 base interface : toolbar, target frame, main frame, minimap button
* Dashboard page
* Character page
* Profile management
* Directory page
* Settings pages

This is the first version we release for Total RP 3 ! We worked very very very hard to create a stable and robust "engine" that will support all our future features.

The first set of features we are bringing to you is the Character module.
In Total RP 3 I wanted the addon to be centered again on your Character. More customization in order to let you have a very unique character. I want people to start reading other's description, like in the good old time.

If I have to give you a piece of advice : forget about Total RP 2. TRP3 is not a sequel. It's a brand new addon.
When coming from TRP2, it can take some time to get used to the new profile system. Don't forget that the directory stores PROFILES and not WoW characters.

Here are some key features for the Character module

* Profile system, allowing you to easily switch from a profile to another, but also to link several WoW character to the same profile.
* More freedom for your character information : show only what you want to show.
You think TRP is lacking a particular information ? Like a social status ? Wealth ? Reputation to your guild ? You can create the field yourself !
* Three different templates for your description, allowing you to create something visually unique.
* "At first glance" slots, replacing the "Currently" and the visual state system from TRP2. No more huge character tooltips. Wink
* Roleplay style page, allowing you to publicly show important OOC point about your character and your way of roleplaying.
* A great tutorial mode, just like the one used in the latest WoW interfaces.

## Known problems / bugs

(It's not necessary to report them)


* The character tooltip will not display any icon until the player edit his character page and change the icon.
* You can't use TAB to switch between field on the character edit page.
* On the character edit page - Characteristics - the birthplace mention a button allowing you to place your residence on the map. There is no such button at the moment.
* Personality traits have no descriptions.
* Theme playing is capricious. This is a WoW API limitation : the music from WoW will always "win" against addon music. So, for example, if you enter a new zone while playing a character them, the zone music will interrupt the theme.
Theme is playing loop. This is a WoW API limitation.
* At first glance - editor - The left side of the text area crops the text.
* When using a light background for the description and a black text, it's hard to see the text due to the text shadow. We are working on allowing disabling the text shadow.
* If you open your character about page, and receive a vote, the vote statistics don't refresh until changing tab and opening the about tab again.
* The Companions tab in the directory is out of scope for version 0.1
* When selecting an entry in the second/third level of a multiple-level drop list, the drop list stays open.
* Settings - Locale - French : placeholder.
* Settings - Communication - Broadcast channel is not used for now.
* Settings - Frames - Minimap Button : choosing a parent frame other than Minimap is buggy.
* Settings - Frames - Target frame : if "only when IC", changing RP status while targeting does not show/hide the target frame.
* Settings - Tooltip - Anchor point is empty.
* Settings - Module status is empty.