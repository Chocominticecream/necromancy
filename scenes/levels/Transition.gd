extends Node2D

var cardfunc = Universalfunc.new()

# a change

func createStarterDeck(deck : Array):
     var data_cbd = cardfunc.readDatabase()
    
     for i in range(3):
         var zombieentry = cardfunc.findCard(data_cbd, 0, "SummonData", "numID")
         var zombiecard = cardfunc.createCard(zombieentry, 'summon')
         deck.append(zombiecard)
    
     for i in range(2):
         var swampentry = cardfunc.findCard(data_cbd, 1, "SummonData", "numID")
         var swampcard = cardfunc.createCard(swampentry, 'summon')
         swampcard.alliance = true
         deck.append(swampcard)
    
     for i in range(2):
         var mummyentry = cardfunc.findCard(data_cbd, 2, "SummonData", "numID")
         var mummycard = cardfunc.createCard(mummyentry, 'summon')
         deck.append(mummycard)
        
     for i in range(2):
         var bruteCard = cardfunc.createCard(cardfunc.findCard(data_cbd, 3, "SummonData", "numID") , 'summon')
         deck.append(bruteCard)
     
     for i in range(5):
         var manaballentry = cardfunc.findCard(data_cbd, 0, 'SpellData', 'numID')
         var manaballcard = cardfunc.createCard(manaballentry, 'spell')
         deck.append(manaballcard)

#to expand on this function
func createEnemyDeck(deck : Array, wavedeck : Array):
    var data_cbd = cardfunc.readDatabase()
    
    #for i in range(5):
    var soldierentry = cardfunc.findCard(data_cbd, 1, "EnemyData", "numID")
    var soldiercard = cardfunc.createCard(soldierentry , 'enemySummon')
    deck.append(soldiercard)
    
    var spiderCard = cardfunc.createCard(cardfunc.findCard(data_cbd, 2, "EnemyData", "numID") , 'enemySummon')
    deck.append(spiderCard)
    
    var testCard = cardfunc.createCard(cardfunc.findCard(data_cbd, 0, "EnemyData", "numID") , 'enemySummon')
    deck.append(testCard)
    
    var repeater = cardfunc.createCard(cardfunc.findCard(data_cbd, 3, "EnemyData", "numID") , 'enemySummon')
    deck.append(repeater)
    
    #appending wave deck value, first value is the amount of enemies summoned, second number is time til the next wave
    wavedeck.append([4,3])  
# Called when the node enters the scene tree for the first time.
func _ready():
    cardfunc.copyDatabase()
    createStarterDeck(DataManager.maindeck)
    createEnemyDeck(DataManager.enemydeck, DataManager.enemywaves)
    DataManager.maindeck.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
