extends Resource
class_name Status



var statusTypeEnum : DataManager.STATUS = DataManager.STATUS.test
#originalvalue variable is for cartain stacking debuffing status effects 
var originalValue : int = 0
var value : int = 0
#to set DRAWTIME to a global singleton variable
var DRAWTIME = 0.2

func _ready():
    pass
        
#construct status with value and effect
func _init(status : DataManager.STATUS, val : int):
    statusTypeEnum = status
    value = val
#sleep
func applyStatus(card : BaseCard, altTrigger : bool = true):
    var copyArray = card.status.duplicate()
    match statusTypeEnum:
        DataManager.STATUS.sleep:
            copyArray.erase(self)
            card.status = copyArray
        DataManager.STATUS.poison:
            print(card.printedname + " has taken " + str(value) + " poison damage !")
            card.onTakeDamage(!card.alliance, value, [card.index], -1, [])
            copyArray[copyArray.find(self)].value -= 1
            if copyArray[copyArray.find(self)].value <= 0:
              copyArray.erase(self)
            card.status = copyArray
        DataManager.STATUS.hex:
            if altTrigger:
              print(card.printedname + " has been hexed for " + str(-value) + "!")
              card.attack = card.attack + value - originalValue
              originalValue = value
            elif !altTrigger:
              card.attack = card.attack - value
              copyArray.erase(self)
              card.status = copyArray
        DataManager.STATUS.attackUp:
            card.attack = card.attack + value
        DataManager.STATUS.attack:
            EventsBus.emit_signal("addDelay", DataManager.DRAWTIME*2.0)
            await DataManager.scene_tree.create_timer(DataManager.DRAWTIME*2.0).timeout
            await card.onAttack()
        _:
            pass
            
