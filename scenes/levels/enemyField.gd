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
    EventsBus.connect("checkSummons", checkSummons)
    

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

func checkSummons():
    if wavequeue.is_empty() and enemywavevalue.is_empty():
        EventsBus.emit_signal("disableBell")
        return
    for i in range(5):
        if get_child(i).activeCard == null:
           print("empty field! slot  " + str(i))
           EventsBus.emit_signal("detectFullField", false)
           return
    EventsBus.emit_signal("detectFullField", true)
    print("full field!")
    return
    
    
