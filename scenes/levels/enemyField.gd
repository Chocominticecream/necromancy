extends Control

#all waves and enemy summon deck

var enemydeck = []
var enemywavevalue = []

#current wave and enemy deck
var wavequeue = []
var currentwave : int = 0

var cardfunc =  Universalfunc.new()
# Called when the node enters the scene tree for the first time.
func _ready():
    enemydeck = cardfunc.createProxyDeck(DataManager.enemydeck)
    var enemywavestorage = DataManager.enemywaves.duplicate()
    for wave in enemywavestorage:
        enemywavevalue.append(wave[0])
    EventsBus.connect("summonWave", summonWave)
    print(enemywavevalue)
    

func takeDamage():
    pass

func summonWave():
    if enemywavevalue.is_empty() and wavequeue.is_empty():
        return
    
    #get the enemy wave value
    if wavequeue.is_empty():
      currentwave = enemywavevalue[0]
      enemywavevalue.pop_front()
    
      for i in currentwave:
          if !enemydeck.is_empty():
            wavequeue.append(enemydeck.pop_front())
    
    DataManager.phase = DataManager.drawingPhase
    
    #iterate through first wave pair value to summon that many cards
    for i in len(wavequeue):
        
        var avaliableSlots = [0,1,2,3,4]
        EventsBus.emit_signal("setAnimationstate", false)
        var summonFlag = false
        while !summonFlag:
            
            #check if slots are empty
            if avaliableSlots.is_empty():
               summonFlag = true
            else:
              #choose a random slot to summon the card in
              avaliableSlots.shuffle()
              var slot = avaliableSlots[0]
             #if slot is empty, summon, else reset while loop and pop out frontmost number
              if get_child(slot).activeCard == null:
                 summonFlag = true
                 wavequeue[0].index = slot
                 get_child(slot).summonEnemy(wavequeue[0])
                 wavequeue.erase(wavequeue[0])
                 await get_tree().create_timer(DataManager.DRAWTIME).timeout;
              else:
                 avaliableSlots.pop_front() 
    
    #check if wavequeue and enemywavevalue is empty (no more summons), disable the bell
    if wavequeue.is_empty() and enemywavevalue.is_empty():
        EventsBus.emit_signal("disableBell")
    #check if field is full by checking wavequeue contents, if it is set the bell's state to detect a full field
    elif !wavequeue.is_empty():
        EventsBus.emit_signal("detectFullField", true)
    #if wavequeue is empty and enemyarray still have enemies, set the bell state to be able to summon a new wave
    elif wavequeue.is_empty():
        EventsBus.emit_signal("detectFullField", false)
    
    DataManager.phase = DataManager.playPhase
    
