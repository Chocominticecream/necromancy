extends BaseSlot


# Called when the node enters the scene tree for the first time.
func _ready():
     pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _can_drop_data(at_position, data):
    return data is SummonCard and self.activeCard == null
    
func slotted_logic():
    EventsBus.emit_signal("resetCards")
