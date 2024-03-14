extends Node

enum{
      neutral, # not in a fight
      playPhase, # in a fight and playing cards
      countDownPhase, # in a fight but countdowns are happening
      drawingPhase, # in a fight and cards are being drawn and shuffled
      restPhase, #the phase after a play phase, to avoid continous calling of signals as it is needed for certain signals to work
    }

#get scene tree for time based functions
var scene_tree := Engine.get_main_loop() as SceneTree
var phase = neutral
var firstTurn = true #checks if its the first turn, required for inital battle logic to activate

#values for hero
var maindeck = []
var heroHp = 50

#values for enemy
var enemydeck = []
var enemywaves = []
var enemyHp = 50

#options values
var DRAWTIME = 0.2

#stored shaders
var nebulaShader

enum STATUS {
    test,
    empty,
    sleep, # for cards first summoned on the field, cards that are just summoned, cannot deplete their counter
    poison, #poison damage, take damage after attacking
    hex, #temporary attack "debuff"
    damage, #extra indirect damage 
    attack, #activate the onAttack function on summon cards
    attackUp, 
}

enum EFFECTS {
    test,
    empty,
    
    #spell effects
    castSpell,
    
    #summon effects
    applyEffectOnHit, #applies a status effect onto the enemy when attacking
    applyEffectOnAttack,  #applies a status effect onto self when attacking
    applyEffectWhenAttack,  #applies a status effect onto self/field when hit
    applyEffectWhenHit, #applies a status effect onto the enemy when hit
}


func _ready():
    preloadShaders()

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

func preloadShaders():
    nebulaShader = load("res://scenes/widgets/NebulaShader.tscn").instantiate()
