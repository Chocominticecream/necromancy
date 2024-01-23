extends Node2D

var cardfunc = Universalfunc.new()

# a change

func createStarterDeck(deck):
     var data_cbd = cardfunc.readDatabase()
    
     for i in range(5):
         var zombieentry = cardfunc.findCard(data_cbd, 0, "SummonData", "numID")
         var zombiecard = cardfunc.createCard(zombieentry, 'summon')
         zombiecard.alliance = true
         deck.append(zombiecard)
     
     for i in range(5):
         var manaballentry = cardfunc.findCard(data_cbd, 0, 'SpellData', 'numID')
         var manaballcard = cardfunc.createCard(manaballentry, 'spell')
         deck.append(manaballcard)

func createEnemyDeck(deck, wavedeck):
    var data_cbd = cardfunc.readDatabase()
    
    for i in range(5):
         var soldierentry = cardfunc.findCard(data_cbd, 0, "EnemyData", "numID")
         var soldiercard = cardfunc.createCard(soldierentry , 'enemySummon')
         soldiercard.alliance = false
         deck.append(soldiercard)
    #appending wave deck value, first value is the amount of enemies summoned, second number is time til the next wave
    wavedeck.append([2,3])  
# Called when the node enters the scene tree for the first time.
func _ready():
    cardfunc.copyDatabase()
    createStarterDeck(DataManager.maindeck)
    createEnemyDeck(DataManager.enemydeck, DataManager.enemywaves)
    DataManager.maindeck.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
