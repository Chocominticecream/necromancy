extends BaseSlot

var universalMethods = Universalfunc.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    alliance = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _can_drop_data(at_position, data):
    return data is SummonCard and activeCard == null
    
func slotted_logic():
    activeCard.index = get_index()
    #copy array, append and then assign that new array to activate the setter 
    activeCard.status = universalMethods.editStatusArray(activeCard.status, true, DataManager.STATUS.sleep)
    EventsBus.emit_signal("countdown", activeCard.energy)
    EventsBus.emit_signal("resetCards")
