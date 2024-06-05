extends Node2D

var cardfunc = Universalfunc.new()

# a change

#debug battle stat load in
func createTestStarterDeck(deck : Array):
     var data_cbd = cardfunc.readDatabase()
    
     for i in range(3):
         var zombieentry = cardfunc.findCard(data_cbd, 0, "SummonData", "numID")
         var zombiecard = cardfunc.createResource(zombieentry, 'summon')
         deck.append(zombiecard)
    
     for i in range(2):
         var swampentry = cardfunc.findCard(data_cbd, 1, "SummonData", "numID")
         var swampcard = cardfunc.createResource(swampentry, 'summon')
         swampcard.alliance = true
         deck.append(swampcard)
    
     for i in range(2):
         var mummyentry = cardfunc.findCard(data_cbd, 2, "SummonData", "numID")
         var mummycard = cardfunc.createResource(mummyentry, 'summon')
         deck.append(mummycard)
        
     for i in range(2):
         var bruteCard = cardfunc.createResource(cardfunc.findCard(data_cbd, 3, "SummonData", "numID") , 'summon')
         deck.append(bruteCard)
     
     for i in range(3):
         var manaballentry = cardfunc.findCard(data_cbd, 0, 'SpellData', 'numID')
         var manaballcard = cardfunc.createResource(manaballentry, 'spell')
         deck.append(manaballcard)
    
     for i in range(2):
         var manaballentry = cardfunc.findCard(data_cbd, 1, 'SpellData', 'numID')
         var deathcard = cardfunc.createResource(manaballentry, 'spell')
         deck.append(deathcard)

#hardcoded function to create a bunch of test 
func createTestEnemyDeck(deck : Array, wavedeck : Array):
    var data_cbd = cardfunc.readDatabase()
    
    #for i in range(5):
    var soldierentry = cardfunc.findCard(data_cbd, 1, "EnemyData", "numID")
    var soldiercard = cardfunc.createResource(soldierentry , 'enemySummon')
    deck.append(soldiercard)
    
    var spiderCard = cardfunc.createResource(cardfunc.findCard(data_cbd, 2, "EnemyData", "numID") , 'enemySummon')
    deck.append(spiderCard)
    deck.append(spiderCard)
    
    var testCard = cardfunc.createResource(cardfunc.findCard(data_cbd, 0, "EnemyData", "numID") , 'enemySummon')
    deck.append(testCard)
    deck.append(testCard)
    deck.append(testCard)
    
    var repeater = cardfunc.createResource(cardfunc.findCard(data_cbd, 3, "EnemyData", "numID") , 'enemySummon')
    deck.append(repeater)
    
    #appending wave deck value, first value is the amount of enemies summoned, second number is time til the next wave
    wavedeck.append([2,0])
    wavedeck.append([3,1])
    wavedeck.append([1,1])
    wavedeck.append([1,1])
# Called when the node enters the scene tree for the first time.
        
func _ready():
    cardfunc.copyDatabase()
    createTestStarterDeck(DataManager.maindeck)
    createTestEnemyDeck(DataManager.enemydeck, DataManager.enemywaves)
    DataManager.maindeck.shuffle()
    #print(DataManager.enemydeck)
    #print(DataManager.maindeck)
    #print(DataManager.enemywaves)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_transition_button_pressed():
    get_tree().change_scene_to_file("res://scenes/levels/battleScene.tscn")
