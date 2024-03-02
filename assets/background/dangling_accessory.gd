extends Node2D

@onready var pivotAccessory = $pivot
@export var swingExtremity = 0.1
@export var swingTime = 5.0
@export var startingDirection = true
var pivotTween

# Called when the node enters the scene tree for the first time.
func _ready():
    pivotAnimation() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func pivotAnimation():
    pivotTween = create_tween().set_loops()
    if startingDirection:
      pivotTween.tween_property(pivotAccessory, "rotation", swingExtremity, swingTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
      pivotTween.tween_property(pivotAccessory, "rotation", -swingExtremity, swingTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    else:
      pivotTween.tween_property(pivotAccessory, "rotation", -swingExtremity, swingTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
      pivotTween.tween_property(pivotAccessory, "rotation", swingExtremity, swingTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
