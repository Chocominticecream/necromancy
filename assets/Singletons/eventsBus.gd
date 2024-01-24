extends Node

#card animation signals
signal resetCards()
signal setState(val)
signal setAnimationstate(val)

#card logic signals
signal redrawCards()
signal summonWave()

#basic card action signals
signal takeDamage(alliance, damage, attackingFoe)
signal attack()
signal countdown(val)

#button signals
signal buttonActivation(val)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
