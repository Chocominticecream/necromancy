extends BaseSlot

var universalMethods = Universalfunc.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    alliance = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func summonEnemy(enemy):
    var TweenNode = create_tween()
    enemy.get_node("spriteNodes").z_index = 0
    #summon an enemy from a summon point to update position correctly
    $summonPoint.add_child(enemy)
    enemy.state = enemy.inEnemyPlay
    activeCard.status = universalMethods.editStatusArray(activeCard.status, true, DataManager.STATUS.sleep)
    TweenNode.tween_property(enemy, "global_position", self.global_position , enemy.DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    await get_tree().create_timer(activeCard.DRAWTIME).timeout;
