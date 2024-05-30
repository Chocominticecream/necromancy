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
var phase = neutral : set = phaseSet
var firstTurn = true #checks if its the first turn, required for inital battle logic to activate

#values for hero
var maindeck = []
var heroHp = 50

#values for enemy
var enemydeck = []
var enemywaves = []
var enemyHp = 60

#options values
var DRAWTIME = 0.2

#stored shaders
var nebulaShader

#delay values for ensuring cards get timed properly
var delay : Array = []
var deathdelay: Array = []

#enums and signal controllers
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

func phaseSet(value):
    phase = value

func _ready():
    preloadShaders()
    EventsBus.connect("addDelay", addDelay)
    EventsBus.connect("addDeathDelay", addDeathDelay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 
  if firstTurn:
    EventsBus.emit_signal("setAnimationstate", false)
    #EventsBus.emit_signal("buttonActivation", true)
  else:
    match phase:
        playPhase:
           EventsBus.emit_signal("setAnimationstate", true)
           EventsBus.emit_signal("buttonActivation", false)
           EventsBus.emit_signal("animationActivation", false)
           EventsBus.emit_signal("setWaveJustSummoned", false)
           phase = restPhase
        countDownPhase:
           EventsBus.emit_signal("setAnimationstate", false)
           EventsBus.emit_signal("buttonActivation", true)
        drawingPhase:
           EventsBus.emit_signal("setAnimationstate", false)
           EventsBus.emit_signal("buttonActivation", true)
        restPhase:
           pass

#code that plays status effects that activate during a turn
func addDelay(delayval: float):
    delay.append(delayval)

func clearDeck():
    maindeck.clear()
    enemydeck.clear()
    enemywaves.clear()

#code that waits for death before executing other functions
func addDeathDelay(delayval: float):
    deathdelay.append(delayval)
    
func preloadShaders():
    nebulaShader = load("res://scenes/widgets/NebulaShader.tscn").instantiate()


