extends Node2D

var deck = []
var cardfunc = Universalfunc.new()

# a change

func createStarterDeck(deck):
     var data_cbd = cardfunc.readDatabase()
     var zombieentry = cardfunc.findCard(data_cbd, 0, "SummonData", "numID")
     #var zombiecard = cardfunc.createCard(zombieentry, 'summon_data')
     
     var manaballentry = cardfunc.findCard(data_cbd, 0, 'spell_sheet', 'numID')
     print(zombieentry)
     #var manaballcard = cardfunc.createCard(manaballentry, 'spell_sheet')
    
     #for i in range(5):
         #deck.append(zombiecard.duplicate())
     
     #for i in range(5):
         #deck.append(manaballcard.duplicate())

# Called when the node enters the scene tree for the first time.
func _ready():
    cardfunc.copyDatabase()
    createStarterDeck(deck)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
