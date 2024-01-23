extends BaseCard
class_name SummonCard

#this is a summon card
var hp : int :get = hpget, set = hpset
var attack : int : get = attget, set = attset
var counter: int : get = counterget, set = counterset

var maxcounter : int
#true = hero side false = enemy side
var alliance : bool

func _ready():
    super._ready()
    maxcounter = counter
    #battle logic signals

func _process(delta):
    super._process(delta)
    
    if !alliance:
        $spriteNodes/TextNormal/Energy.visible = false
        $spriteNodes/TextFocused/Energy.visible = false
        $spriteNodes/graphicsScaler/EnergySprite.visible = false
    else: 
        $spriteNodes/TextNormal/Energy.visible = true
        $spriteNodes/TextFocused/Energy.visible = true
        $spriteNodes/graphicsScaler/EnergySprite.visible = true

#-------- SETTER AND GETTERS---------------

func hpset(val : int):
    $spriteNodes/TextNormal/Hp.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Hp.text = "[center][b]" + str(val) 
    hp = val 

func hpget():
    return hp

func attset(val : int):
    $spriteNodes/TextNormal/Attack.text = "[center]" + str(val) 
    $spriteNodes/TextFocused/Attack.text = "[center][b]" + str(val) 
    attack = val 

func attget():
    return attack
    
func counterset(val : int):
    $spriteNodes/TextNormal/Counter.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Counter.text = "[center][b]" + str(val)  
    counter = val

func counterget():
    return counter

#-------- END OF SETTER AND GETTERS---------------

#fight function if card is on the hero side
func fight():
    TweenNode = create_tween()
    var fightfactor = 1
    if alliance:
        fightfactor = 1
    else:
        fightfactor = -1
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,50*fightfactor) , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,-100*fightfactor) , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position , DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    await get_tree().create_timer(DRAWTIME*2).timeout;
    counterset(maxcounter)

func takeDamage(target: Array):
    pass
