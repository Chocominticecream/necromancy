extends Node2D

@onready var pivotAccessory = $pivot
var pivotTween

# Called when the node enters the scene tree for the first time.
func _ready():
    pivotAnimation() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func pivotAnimation():
    pivotTween = create_tween().set_loops()
    pivotTween.tween_property(pivotAccessory, "rotation", 0.1, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    pivotTween.tween_property(pivotAccessory, "rotation", -0.1, 5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
