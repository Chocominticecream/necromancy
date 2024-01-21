extends Control

var hp : int : get = hpget, set = hpset
var maxhp

func _ready():
    maxhp = hp 

func hpget():
    return hp

func hpset(val):
    $enemyHpLabel.text = "[center]Enemy:" + str(val) + "/" + str(maxhp)
    hp = val


