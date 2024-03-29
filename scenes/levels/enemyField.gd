extends Control

var enemydeck = []
var enemywaves = []
var currentwave = []

var cardfunc =  Universalfunc.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    enemydeck = cardfunc.createProxyDeck(DataManager.enemydeck)
    enemywaves = DataManager.enemywaves.duplicate()
    EventsBus.connect("summonWave", summonWave)
    

func takeDamage():
    pass

func summonWave():
    if enemywaves.is_empty():
        return
    
    currentwave = enemywaves[0]
    enemywaves.erase(enemywaves[0])
    DataManager.phase = DataManager.drawingPhase
    
    #iterate through first wave pair value to summon that many cards
    for i in range(currentwave[0]):
        EventsBus.emit_signal("setAnimationstate", false)
        var summonFlag = false
        while !summonFlag:
            #choose a random slot to summon the card in
            var slot = randi() % 5
            #if slot is empty, summon, else reset while loop
            if get_child(slot).activeCard == null:
               summonFlag = true
               enemydeck[0].index = slot
               get_child(slot).activeCard = enemydeck[0]
               get_child(slot).summonEnemy(enemydeck[0])
               enemydeck.erase(enemydeck[0])
               await get_tree().create_timer(DataManager.DRAWTIME).timeout;
    DataManager.phase = DataManager.playPhase
        
    
