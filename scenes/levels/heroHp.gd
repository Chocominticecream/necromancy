extends Control

var hp : int : get = hpget, set = hpset
var maxhp

func _ready():
    hp = DataManager.heroHp
    maxhp = hp
    hp = DataManager.heroHp
    EventsBus.connect("onTakeDirectDamage", onTakeHeroDamage) 

func hpget():
    return hp

func hpset(val : int):
    $heroHpLabel.text = "[center]Hero:" + str(val) + "/" + str(maxhp)
    hp = val

func onTakeHeroDamage(val : int,  alliance : bool):
    if alliance:
      hpset(hp - val)
