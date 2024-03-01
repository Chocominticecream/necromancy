extends TextureButton

#ffffcd color code for highlighted text?

@export var bbText : String
@onready var textLabel = $TextLabel

var initialTextPos
var textTween
# Called when the node enters the scene tree for the first time.
func _ready():
    initialTextPos =  textLabel.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_mouse_entered():
    textTween = create_tween()
    textTween.tween_property(textLabel, "global_position", initialTextPos + Vector2(100,0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _on_mouse_exited():
    textTween = create_tween()
    textTween.tween_property(textLabel, "global_position", initialTextPos, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
