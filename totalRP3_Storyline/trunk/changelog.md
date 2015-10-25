# Change-log version 1.2

## New features

- **New scaling system**: the 3D model scale has to be manually defined for each model against each other. That's a huge task. We added a quick and easy way for **you** to re-scale models while questing. You can now resize the 3D models (yours or your target) by maintaining the ALT key down and scrolling the model you wish to resize (hold SHIFT to go faster). The resizing will be saved between session for the combination of models, which means that you will only have to scale once your character against a specific model to see them scaled forever.  
 _In the future, we will create an online form for people who are willing to share their scaling data with us to upload them, so we can combine everyone's data into a crowd sourced scaling table that will be included with the add-on. We will inform you when that's ready._  
![Hold the ALT key and scroll to resize a model](http://totalrp3.info/documentation/changelogs/1_2_scaling_1.png) 
![Hold the ALT key and click left or right to move the model](http://totalrp3.info/documentation/changelogs/1_2_scaling_3.png)

- **Use keyboard keys to navigate inside the dialog**: you can now use the **space key to** get the same result as if you've clicked on the text with your mouse. You can **advance in the dialog, accept quests or complete quests** that does not require you to pick a reward. You can use the **numeric keys**, from 1 to 0, to select one of the available choices. A small number icon indicates what numeric key correspond to which choice. You can also use the **backspace key** to go **back to the beginning** of the dialog.
![New keyboard shortcuts make it easier to navigate inside dialogs](http://totalrp3.info/documentation/changelogs/1_2_keyboard_shortcuts.png)

- **The options have been moved to the Interface menu**. As we are adding more and more options (and as we are planning on a fullscreen mode), we have decided to move our options to the Interface menu. The little cog icon at the bottom left of the Storyline frame is still here and will open the Interface menu directly into Storyline's options.

- **Text styling options**: you can now change the size and font of various text elements (more are coming). We are using LibSharedMedia to gather fonts provided by other add-ons. You can manually add fonts using the [SharedMedia add-on](http://www.curse.com/addons/wow/sharedmedia). We are currently providing only one additional font: [OpenDyslexic](http://opendyslexic.org), a free open source font created to increase readability for readers with dyslexia.  
![OpenDyslexic font in Storyline](http://totalrp3.info/documentation/changelogs/1_2_fonts.png)

- **Lock the frame**: you can now lock the Storyline frame in place by checking the option to lock the frame.
![Lock the frame in place so you don't move it by mistake](http://totalrp3.info/documentation/changelogs/1_2_lock_frame.png)

## Localization

We have added the following localization:

- German (thanks to Flairon	and pas06)
- Italian (thanks to crashriderwarcraft)
- Russian (thanks to far2ke, pankopriest and Sincerity7009)
- Spanish (thanks to NeoSaro)
- Traditional Chinese (thanks to gaspy10)

## Minor tweaks

- Low level quests will know use the correct icons, displayed before the quest title, instead of a seal icon in parenthesis after the quest title.

## Bug fixes

- **We are using a different widget for 3D models**. One of the advantages of this new widget is that **models feet are all on the same levels** (previously dwarfs were higher and dryads were lower for example).

- Also the new 3D model widget allows us to **extend the boundaries of each models** so that they take the whole width of the frame. This means **the models will no longer be cut in the middle** and the two models can overlap each other.
![Models are no longer cut and can be overlayed](http://totalrp3.info/documentation/changelogs/1_2_models_boundaries.png)

- **Dead NPCs will now be shown as dead**. _Please note that we cannot retrieve the NPC current animation in the world. We are only relying on a “dead” flag or the health points to determine if an NPC is dead and show him dead. NPC's that are wounded or just lying on the ground or are kneeling will still be shown standing up._
![Dead NPCs will now be shown as dead](http://totalrp3.info/documentation/changelogs/1_2_dead_npcs.png)