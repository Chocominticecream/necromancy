extends BaseSlot

var universalMethods = Universalfunc.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    super._ready()
    alliance = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func summonEnemy(enemy : SummonCard):
    var TweenNode = create_tween()
    activeCard = enemy
    activeCard.get_node("spriteNodes").z_index = 0
    #summon an enemy from a summon point to update position correctly
    $summonPoint.add_child(activeCard)
    activeCard.state = activeCard.inEnemyPlay
    activeCard.status = universalMethods.editStatusArray(activeCard.status, true, DataManager.STATUS.sleep)
    if !DataManager.firstTurn:
        activeCard.freshCard = true
    else:
        EventsBus.emit_signal("addDelay", DataManager.DRAWTIME)    
        
    TweenNode.tween_property(enemy, "global_position", self.global_position , DataManager.DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    await get_tree().create_timer(DataManager.DRAWTIME).timeout;
