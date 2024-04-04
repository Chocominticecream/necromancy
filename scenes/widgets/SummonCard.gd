extends BaseCard
class_name SummonCard

#this is a summon card
var hp : int :get = hpget, set = hpset
var attack : int : get = attget, set = attset
var counter: int : get = counterget, set = counterset
var multihit: int = 1 #multi hit variable to determine how many tiems the card hits
var index: int: get = indexget , set = indexset #returns value of card's cardslot index

var maxcounter : int
#true = hero side false = enemy side
var alliance : bool = true
#grab the targetting foe, by default it is the opposing card
var attackingFoe : Array = [index]
#the attacking index, the default value is the index val
var atkindex: int

func _ready():
    super._ready()
    maxcounter = counter
    #battle logic signals

func _process(delta):
    super._process(delta)
    
    #disable the energy bubble if card is an enemy
    if !alliance:
        $spriteNodes/TextNormal/Energy.visible = false
        $spriteNodes/TextFocused/Energy.visible = false
        $spriteNodes/graphicsScaler/EnergySprite.visible = false
    else: 
        $spriteNodes/TextNormal/Energy.visible = true
        $spriteNodes/TextFocused/Energy.visible = true
        $spriteNodes/graphicsScaler/EnergySprite.visible = true

func _on_gui_input(event):
    super._on_gui_input(event)
    #test function , to be removed in final prototype
    if Input.is_action_just_pressed("ui_left_click") and state == inPlay and animationFinished == true:
        self.scale = Vector2(1,1)
        animation.play("normal")
        EventsBus.emit_signal("reParentChild", self , get_node("/root/battleScene/battleUI/decks/hand"))
        EventsBus.emit_signal("resetCards")
        EventsBus.emit_signal("activeCardToNull", index, alliance)
        #self.scale = self.scale * 1.2
#-------- SETTER AND GETTERS---------------

func hpset(val : int):
    $spriteNodes/TextNormal/Hp.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Hp.text = "[center][b]" + str(val) 
    hp = val 
    if hp <= 0:
      onDeath()

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

func indexset(val):
    index = val
    atkindex = val

func indexget():
    return index
#-------- END OF SETTER AND GETTERS---------------

#fight function, activate attack 
func onAttack(reset : bool = true):
    #fight factor controls the tweening of rhe card when the fight function is called
    # it also sets the targets to attack for based on the card's ability
    if state == death:
        return
    
    attackingFoe = [atkindex]
    TweenNode = create_tween()
    var fightfactor = 1
    if alliance:
        fightfactor = 1
    else:
        fightfactor = -1
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,50*fightfactor) , DataManager.DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,-100*fightfactor) , DataManager.DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    TweenNode.tween_property(self, "global_position", global_position , DataManager.DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    await get_tree().create_timer(DataManager.DRAWTIME).timeout;
    EventsBus.emit_signal("onTakeDamage", alliance, attack, attackingFoe, index, effect)
    await universalMethods.triggerStatuses(DataManager.STATUS.hex, self, false)
    await get_tree().create_timer(DataManager.DRAWTIME).timeout;
    #if reset, resets the counter, used for cards that attack based on a condition
    if reset:
      counterset(maxcounter)
    
    triggerCardEffects(DataManager.EFFECTS.applyEffectOnAttack)
    
    await universalMethods.triggerStatuses(DataManager.STATUS.poison, self)

func onTakeDamage(ally : bool , damage : int, targetingFoe: Array, attacker: int, effects: Array):
     var fightfactor = 1
     TweenNode = create_tween()
     if alliance:
        fightfactor = 1
     else:
        fightfactor = -1
     if !ally == alliance:
        for idx in targetingFoe:
            if index == idx:
               if ally:
                 print("enemy card in slot " + str(index) + " has taken " + str(damage) + " damage from hero")
               else:
                 print("hero card in slot " + str(index) + " has taken " + str(damage) + " damage from enemy")
               animation.play("hurt")
               TweenNode.tween_property(self, "global_position", global_position + Vector2(0,20*fightfactor) , DataManager.DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
               TweenNode.tween_property(self, "global_position", global_position , DataManager.DRAWTIME/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
               if damage <= 0:
                 hpset(hp)
               else:
                 hpset(hp-damage)
                 
                 #trigger effects on to self from enemy
               triggerCardEffects(DataManager.EFFECTS.applyEffectOnHit, effects)
                 
                 #check if there is an attacker, if the attacker is -1, then it is damage taken from status/spell and the effects wont trigger
               triggerCardEffects(DataManager.EFFECTS.applyEffectWhenAttack, effect, attacker)

func onDeath():
    emit_signal("activeCardToNull", index, alliance)
    TweenNode = create_tween()
    z_index = 1
    state = death
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,-400) , DataManager.DRAWTIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
    TweenNode.tween_property(self, "global_position", global_position + Vector2(0,1450) , DataManager.DRAWTIME*3.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
    animationAlt.play("death")
    await get_tree().create_timer(DataManager.DRAWTIME*6.0).timeout;
    self.queue_free()
    
func triggerCardEffects(cardEffect : DataManager.EFFECTS, effectsArray : Array = effect, placeholderVar = 0):
    if cardEffect ==  DataManager.EFFECTS.applyEffectWhenAttack:
      if state != death and placeholderVar != -1:
        atkindex = placeholderVar    
        super.triggerCardEffects(cardEffect, effectsArray, placeholderVar)
        atkindex = index
    else:
        super.triggerCardEffects(cardEffect, effectsArray, placeholderVar)

