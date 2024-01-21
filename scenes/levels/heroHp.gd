extends Control

var hp : int : get = hpget, set = hpset
var maxhp

func _ready():
    maxhp = hp

func hpget():
    return hp

func hpset(val):
    $heroHpLabel.text = "[center]Hero:" + str(val) + "/" + str(maxhp)
    hp = val

