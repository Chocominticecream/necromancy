extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _on_redraw_button_mouse_entered():
    $redrawButton.self_modulate = Color(1,1,1,0.5)


func _on_redraw_button_mouse_exited():
    $redrawButton.self_modulate = Color(1,1,1,1)
