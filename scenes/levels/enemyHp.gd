extends Control

var hp : int : get = hpget, set = hpset
var maxhp

func _ready():
    hp = DataManager.enemyHp
    maxhp = hp
    hp = DataManager.enemyHp
    EventsBus.connect("onTakeDirectDamage", onTakeEnemyDamage) 

func hpget():
    return hp

func hpset(val : int):
    $enemyHpLabel.text = "[center]Enemy:" + str(val) + "/" + str(maxhp)
    hp = val

func onTakeEnemyDamage(val : int , alliance : bool):
    if !alliance:
      hpset(hp - val)
