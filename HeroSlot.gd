extends BaseSlot

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
    self.activeCard.index = get_index()
    EventsBus.emit_signal("countdown", self.activeCard.energy)
    EventsBus.emit_signal("resetCards")
