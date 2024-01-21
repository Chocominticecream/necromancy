extends Node2D

var deck = []
var cardfunc = Universalfunc.new()

# a change

func createStarterDeck(deck):
     var data_cbd = cardfunc.readDatabase()
    
     for i in range(5):
         var zombieentry = cardfunc.findCard(data_cbd, 0, "SummonData", "numID")
         var zombiecard = cardfunc.createCard(zombieentry, 'summon')
         deck.append(zombiecard)
     
     for i in range(5):
         var manaballentry = cardfunc.findCard(data_cbd, 0, 'SpellData', 'numID')
         var manaballcard = cardfunc.createCard(manaballentry, 'spell')
         deck.append(manaballcard)

# Called when the node enters the scene tree for the first time.
func _ready():
    cardfunc.copyDatabase()
    createStarterDeck(DataManager.maindeck)
    DataManager.maindeck.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
