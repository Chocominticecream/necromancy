extends Node

enum{
      neutral, # not in a fight
      playPhase, # in a fight and playing cards
      countDownPhase, # in a fight but countdowns are happening
      drawingPhase, # in a fight and cards are being drawn and shuffled
      restPhase, #the phase after a play phase, to avoid continous calling of signals as it is needed for certain signals to work
    }

var phase = neutral
var firstTurn = true #checks if its the first turn, required for inital battle logic to activate

#values for hero
var maindeck = []
var heroHp = 50

#values for enemy
var enemydeck = []
var enemywaves = []
var enemyHp = 50

enum STATUS {
    test,
    sleep, # for cards first summoned on the field, cards that are just summoned, cannot deplete their counter
    poison, 
}

enum EFFECTS {
    test,
    applyEffectOnHit,
}

func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if firstTurn:
    EventsBus.emit_signal("setAnimationstate", false)
    EventsBus.emit_signal("buttonActivation", true)
  else:
    match phase:
        playPhase:
           EventsBus.emit_signal("setAnimationstate", true)
           EventsBus.emit_signal("buttonActivation", false)
           phase = restPhase
        countDownPhase:
           EventsBus.emit_signal("setAnimationstate", false)
           EventsBus.emit_signal("buttonActivation", true)
        drawingPhase:
           EventsBus.emit_signal("setAnimationstate", false)
           EventsBus.emit_signal("buttonActivation", true)
        restPhase:
           pass
