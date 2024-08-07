extends Node

#card animation signals
signal resetCards()
signal setState(val)
signal setAnimationstate(val)

#card logic signals
signal redrawCards()
signal summonWave()
signal countdown(val)
signal activeCardToNull(idx, alliance)
signal addDelay(val)
signal addDeathDelay(val)
signal discardCard(card)
signal drawCards(val)
signal depleteBell(val)
signal disableBell()
signal detectFullField(val)
signal setWaveJustSummoned(val)
signal checkSummons()
signal winBattle()
signal loseBattle()

#basic card action signals
signal onTakeDamage(alliance, damage, attackingFoe)
signal onAttack()
signal onTakeDirectDamage(val, alliance)



#button signals
signal buttonActivation(val)
signal animationActivation(val)

#debug signals
signal reParentChild(card, target)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
