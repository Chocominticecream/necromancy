extends Resource
class_name Status

var statusTypeEnum : DataManager.STATUS = DataManager.STATUS.test
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
func applyStatus(card : BaseCard):
    var copyArray = card.status.duplicate()
    match statusTypeEnum:
        DataManager.STATUS.sleep:
            copyArray.erase(self)
            card.status = copyArray
        DataManager.STATUS.poison:
            print(card.printedname + " has taken " + str(value) + " poison damage !")
            card.onTakeDamage(!card.alliance, value, [card.index], [])
            copyArray[copyArray.find(self)].value -= 1
            if copyArray[copyArray.find(self)].value <= 0:
              copyArray.erase(self)
            card.status = copyArray
        _:
            pass
            
