extends Node2D

#original color : 5b5a7f

# Called when the node enters the scene tree for the first time.
func _ready():
    DataManager.clearDeck()
    DataManager.phase = DataManager.restPhase


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_start_button_pressed():
    get_tree().change_scene_to_file("res://scenes/levels/Transition.tscn")
