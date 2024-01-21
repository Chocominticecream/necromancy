extends BaseCard
class_name SummonCard

#this is a summon card
var hp : int :get = hpget, set = hpset
var attack : int : get = attget, set = attset
var counter: int : get = counterget, set = counterset

var maxcounter : int

func _ready():
    super._ready()
    maxcounter = counter
    #battle logic signals

#-------- SETTER AND GETTERS---------------

func hpset(val):
    $spriteNodes/TextNormal/Hp.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Hp.text = "[center][b]" + str(val) 
    hp = val 

func hpget():
    return hp

func attset(val):
    $spriteNodes/TextNormal/Attack.text = "[center]" + str(val) 
    $spriteNodes/TextFocused/Attack.text = "[center][b]" + str(val) 
    attack = val 

func attget():
    return attack
    
func counterset(val):
    $spriteNodes/TextNormal/Counter.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Counter.text = "[center][b]" + str(val)  
    counter = val

func counterget():
    return counter

#-------- END OF SETTER AND GETTERS---------------

func fight():
    TweenNode = create_tween()
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,50) , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,-100) , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    await get_tree().create_timer(DRAWTIME*2).timeout;
    counterset(maxcounter)

