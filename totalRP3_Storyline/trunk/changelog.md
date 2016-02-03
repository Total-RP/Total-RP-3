# Change-log version 1.2.2

## UI improvements

- We are now using a **new system to hide the default quest frame and dialog frame**. The frames should no longer re-appear when opening other frames, and the other frames should be correctly aligned to the left of the screen without any gap. This new solution require a reload of the user interface.
- With the new system to hide the quest frame, we also implement an **option to use the default interface layout engine**. When opening default frames, they appear on the left of the screen, one next to the other, with priorities. Storyline can now use that layout engine to be placed just like the character pannel or spellbook.
- **Fast-forward**: you can now **right-click** or use **SHIFT + spacebar** to fast forward to the end of a dialog.
- **ConsolePort support**: We've implemented full [ConsolePort](http://www.curse.com/addons/wow/console-port) support in this update so you can keep using your favorite questing add-on with your gaming controllers. Storyline will automatically register itself to work with ConsolePort and we've also tweaked some of our stuff to make sure your workflow is as seamless as possible and the most used buttons of our interface are automatically focused by ConsolePort's custom cursor.