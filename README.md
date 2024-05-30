# unnamed necromancy game
 The godot 4 version of the card game I am working on. Base features from the godot 3 version have been re implemented + more. 

 mechanics roadmap(in order of importance):
 - ~~Enemy and hero taking direct damage~~ + game over screen
 - ~~death animations~~ (to be improved)
 - ~~main menu~~

 - ~~basic innate card effects: apply poison on hit, apply hex on hit, attack up on attack~~ + ~~counter attacking~~
 (OOP structure of the cards seem fine enough)
 - ~~basic buffs and debuffs: sleep, poison, attack up , hex, symbols~~

 - ~~spells~~ (made a simple damage spell might implement more)
 - other events (WIP idea)
 -  ~~implement waves mechanic (debug room)~~
 -  implement lose/win condition (debug room)
 - map navigation system (WIP idea)
 - hub area (WIP idea)

The UI doesnt have to be perfect, but it just has to have some concept of an art direction, using inkscape for vector art
and krita for drawn art

 UI roadmap(not in order of importance):
 - ~~main menu~~ (entire main menu is done might as well put it here)

 BattleUI:
 - ~~action button design~~
 - ~~card back design (easy)~~
 - ~~Health bar design~~
 - swap out ugly font for better appropriate font (partly done)
 - character/enemy portrait (hmm where do i put this?)
 - ~~make cards less curved~~
 - ~~programatically fit card art into card~~
 - ~~card front design (hard)~~
 - ~~fix glitchy action buttons in the battle UI (i would reimplement the buttons to use state machines instead of stopping variables)~~
 - ~~fix graphic on star particles (star particles have a hole in them and are also pixelated, to be replaced with better graphic~~


things that might need revisting:
 - revisit Health bar graphic, maybe replace with dynamic health bars?
 - as of now, the code relies on firing signals using delays to send information to each other, this could spell disaster when the game is played on different computers, might have to revisit this problem
 - death delay and positions not updating correcly unless certain hacky methods are used (setting artificial delays or spawning the cards using visibility changes and invisible nodes, very weird)
