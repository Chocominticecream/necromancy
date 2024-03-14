extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("reParentChild", reParentChild)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

#signal functions
func reParentChild(card, target):
    var targetcard = card
    
    #save position and scale before reparenting
    var startGlob = targetcard.global_position

    card.get_parent().remove_child(targetcard)
    target.add_child(targetcard)
    #reset values
    targetcard.global_position = startGlob
