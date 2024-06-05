extends CanvasLayer

@onready var animation : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("winBattle", winBattle)
    EventsBus.connect("loseBattle", loseBattle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_resume_pressed():
     get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")

func winBattle():
    animation.play("transition_win")

func loseBattle():
    animation.play("transition_lose")
