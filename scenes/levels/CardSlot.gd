extends MarginContainer

signal resetCards

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _can_drop_data(at_position, data):
    return data is BaseCard
    
func _drop_data(at_position, data):
    data.position.x = self.position.x
    data.position.y = self.position.y
    data.get_node("spriteNodes").z_index = 0
    data.state = data.inPlay
    data.get_parent().remove_child(data)
    self.add_child(data)
    emit_signal("resetCards")
    
