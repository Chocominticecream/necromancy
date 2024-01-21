extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

#signal functions
func reParentChild(card, target):
    var targetcard = card
    
    #save position and scale before reparenting
    var startGlob = targetcard.global_position
    var startScale = targetcard.scale
    #gets grandparent scale 
    var parentScale = targetcard.get_parent().get_parent().scale
    #reparent the child to target node
    card.get_parent().remove_child(targetcard)
    target.add_child(targetcard)
    #reset values
    targetcard.global_position = startGlob


func _on_pass_button_pressed():
    EventsBus.emit_signal("countdown", 1)
