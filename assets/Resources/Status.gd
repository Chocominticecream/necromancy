extends Resource
class_name Status

var statusTypeEnum : DataManager.STATUS = DataManager.STATUS.test
var value : int = 0

#construct status with value and effect
func _init(status : DataManager.STATUS, val : int = 0):
    statusTypeEnum = status
    value = val
#sleep
func applyStatus(card : BaseCard):
    match statusTypeEnum:
        DataManager.STATUS.sleep:
            var copyArray = card.status.duplicate()
            copyArray.erase(self)
            card.status = copyArray
        _:
            pass
            
