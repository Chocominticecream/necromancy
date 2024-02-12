extends Resource
class_name Effect


var effectTypeEnum : DataManager.EFFECTS
var statusArray = []

func _ready():
    pass
#construct status with value and effect
func _init(effect : DataManager.EFFECTS, status: DataManager.STATUS, val : int = 0):
    effectTypeEnum = effect
    statusArray.append(Status.new(status, val))

func applyEffect(card : BaseCard):
    match effectTypeEnum:
        DataManager.EFFECTS.applyEffectOnHit:
            for statusEffect in statusArray:
              card.status = card.universalMethods.editStatusArray(card.status, true, statusEffect.statusTypeEnum, statusEffect.value)
            return 
        _:
            pass
            
