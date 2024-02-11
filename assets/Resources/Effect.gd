extends Resource
class_name Effect


var effectTypeEnum : DataManager.EFFECTS
var statusArray = []

#construct status with value and effect
func _init(effect : DataManager.EFFECTS, status: DataManager.STATUS, val : int = 0):
    effectTypeEnum = effect
    statusArray.append(Status.new(status, val))

func applyEffect(card : BaseCard):
    match effectTypeEnum:
        DataManager.EFFECTS.applyEffectOnHit:
            card.status = card.universalMethods.editStatusArray(card.status, true, DataManager.STATUS.poison)
            return 
        _:
            pass
            
