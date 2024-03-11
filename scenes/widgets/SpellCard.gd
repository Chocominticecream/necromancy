extends BaseCard
class_name SpellCard

var attack : int = 0

func _ready():
    super._ready()


func _can_drop_data(at_position, data):
    return 
    
func castSpell(card: BaseCard):
    #probably use the state machine for this?
    state = playingSpell
    TweenNode = create_tween()
    EventsBus.emit_signal("onTakeDamage", !card.alliance , attack, [card.index], -1, effect)
    animation.play("normal")
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,-200) , DataManager.DRAWTIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
