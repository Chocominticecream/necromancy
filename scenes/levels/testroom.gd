extends Node2D

var testarray = []
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_button_pressed():
    testarray.append($Button/BaseCard)
    $Button.remove_child($Button/BaseCard)
    $Button.add_child(testarray[0])
    testarray[0].position += Vector2(0,100)
