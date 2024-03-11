extends Node2D

var tweener
# Called when the node enters the scene tree for the first time.
func _ready():
    await get_tree().create_timer(1.0).timeout;
    titleFloat()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func titleFloat():
    tweener = create_tween().set_loops()
    tweener.tween_property(self, "global_position", global_position + Vector2(0,20), 3.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    tweener.tween_property(self, "global_position", global_position - Vector2(0,20), 3.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
