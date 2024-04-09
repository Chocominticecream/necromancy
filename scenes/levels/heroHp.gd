extends Control

var hp : int : get = hpget, set = hpset
var maxhp
@export var alliance : bool

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

func hpget():
    return hp

func hpset(val : int):
    if alliance:
      $HpLabel.text = "[center]Hero:" + str(val) + "/" + str(maxhp)
      hp = val
    else:
      $HpLabel.text = "[center]Enemy:" + str(val) + "/" + str(maxhp)
      hp = val

func onTakeDirectDamage(val : int,  allianceArg : bool):
    if alliance == allianceArg:
      hpset(hp - val)
