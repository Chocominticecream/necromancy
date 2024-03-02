extends TextureButton

#ffffcd color code for highlighted text?

@export var bbText : String
@onready var textLabel = $TextLabel
@onready var animation = $Juicy
@onready var animationloop = $Juicyloop

var initialTextPos
var textTween
# Called when the node enters the scene tree for the first time.
func _ready():
    initialTextPos =  textLabel.global_position
    animation.speed_scale = 1/DataManager.DRAWTIME


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_mouse_entered():
    textTween = create_tween().set_loops()
    #textTween.tween_property(textLabel, "global_position", initialTextPos + Vector2(100,0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    #textTween.tween_property(self, "scale", Vector2(1.1,1.1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    #textTween.tween_property(self, "scale", Vector2(1.05,1.05), 0.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    #textTween.tween_property(self, "scale", Vector2(1.1,1.1), 0.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    animation.play("expand")
    #animationloop.play("expand_loop")


func _on_mouse_exited():
    textTween = create_tween()
    #textTween.tween_property(self, "scale", Vector2(1.0,1.0), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    #textTween.tween_property(textLabel, "global_position", initialTextPos, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    animation.play("shrink")
    #animationloop.play("shrink")

