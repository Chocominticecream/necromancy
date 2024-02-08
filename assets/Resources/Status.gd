extends Resource
class_name Status

var statusTypeEnum 
var value : int = 0

#sleep
func applyStatus(card : BaseCard):
    match statusTypeEnum:
        DataManager.STATUS.sleep:
            var copyArray = card.status.duplicate()
            copyArray.erase(self)
            card.status = copyArray
        _:
            pass
            
