extends Node2D

#tween variables
var moonTween
var pivotTween


@onready var moonSprite = $Moon
@onready var blinkingStars = $Stars
# Called when the node enters the scene tree for the first time.
func _ready():
    moonFloat()
    blinkingStars.explosiveness = 1.0
    await get_tree().create_timer(0.05).timeout;
    blinkingStars.explosiveness = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func moonFloat():
    moonTween = create_tween().set_loops()
    moonTween.tween_property(moonSprite, "global_position", moonSprite.global_position + Vector2(0,20), 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    moonTween.tween_property(moonSprite, "global_position", moonSprite.global_position - Vector2(0,20), 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


    
