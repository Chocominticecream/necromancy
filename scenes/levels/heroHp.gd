extends Control

var hp : int : get = hpget, set = hpset
var maxhp : int
var tween : Tween
@onready var animation : AnimationPlayer = $AnimationPlayer
@export var alliance : bool

@onready var tinyCircle = $component3

func _ready():
    if alliance:
      hp = DataManager.heroHp
      maxhp = hp
      hp = DataManager.heroHp
      EventsBus.connect("onTakeDirectDamage", onTakeDirectDamage) 
    else:
      hp = DataManager.enemyHp
      maxhp = hp
      hp = DataManager.enemyHp
      EventsBus.connect("onTakeDirectDamage", onTakeDirectDamage) 

func _process(delta):
    spinCircle()
    
func hpget():
    return hp

func hpset(val : int):
    if alliance:
      $HpLabel.text = "[center]Hero:" + str(val) + "/" + str(maxhp)
      hp = val
    else:
      $HpLabel.text = "[center]Enemy:" + str(val) + "/" + str(maxhp)
      hp = val

func spinCircle():
    tween = create_tween()
    tween.tween_property(tinyCircle, "rotation", 1.5, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()

func onTakeDirectDamage(val : int,  allianceArg : bool):
    if alliance == allianceArg:
      hpset(hp - val)
      animation.play("hurt")
