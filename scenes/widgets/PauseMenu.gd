extends CanvasLayer

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var menu = $pivot
@onready var stoppingscreen = $Blackscreen

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_exit_pressed():
    get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")
    menu.visible = false
    stoppingscreen.visible = false

#pause
func _input(event):
    if Input.is_action_just_pressed("ui_cancel"):
       if !menu.visible:
          menu.visible = true
          stoppingscreen.visible = true
          animation.play("transition")
       else:
          menu.visible = false
          stoppingscreen.visible = false


func _on_resume_pressed():
    menu.visible = false
    stoppingscreen.visible = false
