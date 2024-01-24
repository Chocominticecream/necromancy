extends Control

#card positioning stats
var cardspreadmax = 0.20
var cardspreadval = cardspreadmax

#for card state machine
enum{
    inHand, #check in hand, no focus
    inPlay, #check in play, already assigned to a cardslot
    inMouse, #check if its held in the mouse (ready to be played)
    
    focusing, #playing focus animation
    focusInHand, #check if in hand, focussing
    unfocusing, #playing unfocus
    
    moveDrawnCardToHand, #check if card is being moved to hand
    reOrganiseHand, #reorganise (card is being moved to hand)
    discardCard, #card is being discarded to the pile
    inSlot, #card is held in mouse and about to be played into a cardslot
    inDeck #card is in a deck
    }

# Called when the node enters the scene tree for the first time.
func _ready():
   
    $draw.drawdeck = DataManager.maindeck.duplicate()
    $draw/drawValue.text = str(len(DataManager.maindeck))
    EventsBus.connect("resetCards", reorganiser)
    EventsBus.connect("redrawCards", cardRedrawer)
    # for i in range(10):
       # var base = load("res://scenes/widgets/Summoncard.tscn").instantiate()
       # $draw.drawdeck.append(base)
    DataManager.firstTurn = true
    await get_tree().create_timer(0.1).timeout;
    EventsBus.emit_signal("summonWave")
    await get_tree().create_timer(0.5).timeout;
    carddrawer(5)
    DataManager.firstTurn = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    
#DRAW LOGIC
func carddrawer(drawno):
     DataManager.phase = DataManager.drawingPhase
     var drawglobal = $draw
     var handglobal = $hand
     var drawvalue = drawno
     var drawdeck = drawglobal.drawdeck
     var discarddeck = $discard.discarddeck
     #append the top card to hand and then remove it 
     for i in range(drawvalue):
         if len(drawdeck) < 1:
            reshuffleIntoDraw(drawglobal, $discard)
            await get_tree().create_timer(0.2).timeout
            if len(drawdeck) < 1:
               break
          
         var childcard = drawdeck[0]
         #reorganise the hand
         handglobal.add_child(childcard)
         #to be used to play card drawing animation
         
         childcard.animationFinished = false
         childcard.global_position = drawglobal.global_position
         childcard.target = cardpositioner(i)
         childcard.targetrot = cardrotater(i)
         childcard.state = childcard.moveDrawnCardToHand
         drawdeck.erase(drawdeck[0])
         await get_tree().create_timer(childcard.DRAWTIME).timeout;
         $draw/drawValue.text = "[center]" + str(int($draw/drawValue.text) - 1) + "[/center]"
         reorganiser()
         #if is_instance_valid(drawdeck[0]):
         #   drawdeck[0].free()
     #reorganise the hand one last time
     reorganiser()
     DataManager.phase = DataManager.playPhase
    
#END TURN LOGIC
func cardRedrawer():
    var discardGlobal = $discard
    var handGlobal = $hand
    var discardDeck = discardGlobal.discarddeck
    var awaitTime = 0
    DataManager.phase = DataManager.drawingPhase
    for card in handGlobal.get_children():
        card.target = discardGlobal.global_position
        card.targetrot = 0
        card.state = card.redrawCard
        discardDeck.append(card)
        await get_tree().create_timer(card.DRAWTIME).timeout;
        if card.get_parent() != null:
          card.get_parent().remove_child(card)
        reorganiser()
        $discard/discardValue.text = "[center]" + str(int($discard/discardValue.text) + 1) + "[/center]"
        awaitTime += card.DRAWTIME
    await carddrawer(5)
    EventsBus.emit_signal("countdown", 3)

func reshuffleIntoDraw(drawdeck, discarddeck):
     
     #buggy code to set the position correctly (omg)
     for i in range(len(discarddeck.discarddeck)):
         var card = discarddeck.discarddeck[i]
         card.state = card.inDiscard
         card.visible = false
         $draw.add_child(card)
         #dummy timer so that the card can register its position, the methods after this may have processed way too fast
         #causing the card to not update its position properly, though tweening methods work fine
         await get_tree().create_timer(0.00000001).timeout;
         card.global_position = $draw.global_position
        
     for i in range(len(discarddeck.discarddeck)):
         var card = discarddeck.discarddeck[i]
         $draw.remove_child(card)
         card.visible = true
         #$draw.add_child(card)   
    
     for i in range(len(discarddeck.discarddeck)):  
         drawdeck.drawdeck.append(discarddeck.discarddeck[0])
         discarddeck.discarddeck.erase(discarddeck.discarddeck[0])
         drawdeck.drawdeck[0].state = drawdeck.drawdeck[0].inDraw
         drawdeck.get_node("drawValue").text = "[center]" + str(int(drawdeck.get_node("drawValue").text) + 1) + "[/center]"
         discarddeck.get_node("discardValue").text = "[center]" + str(int(discarddeck.get_node("discardValue").text) - 1) + "[/center]"
     drawdeck.drawdeck.shuffle()

#CARD POSITIONING LOGIC
#take an integer value and positions the card
func cardpositioner(i):
    
    var cardspread = cardspreadval
    
    var num_cards = $hand.get_child_count()-1
    var newposition
    
    var projresolution = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
    var centreCardOval = projresolution * Vector2(0.48, 1.25)
    var Hor_rad = projresolution.x * 0.6
    var Ver_rad = projresolution.y * 0.5
    var angle = PI/2 + cardspread * (float(num_cards)/1.7 - num_cards)
    var ovalAngleVector = Vector2()
    
    angle+= cardspread * i 
    ovalAngleVector = Vector2(Hor_rad * cos(angle), -Ver_rad * sin(angle))
    newposition = centreCardOval + ovalAngleVector 
         #might need this later (- Vector2(67,100)/2)
    
    return newposition

#rotates the card accordingly after positioning them, take an integer
func cardrotater(i):
    var cardspread = cardspreadval
    var num_cards = $hand.get_child_count()-1
    
    var angle = PI/2 + cardspread * (float(num_cards)/2 - num_cards)
    var newrotation
    
    angle += cardspread * i
    newrotation = (90 - rad_to_deg(angle))/4
    return newrotation
    
#reogranise the hand (after drawing or discarding)
func reorganiser():
     var increment = 0
     #first find the amount of cildren to set cardspread accordingly
     for card in $hand.get_children():
         cardspreadval = cardspreadmax - 0.01 * increment
         increment += 1
     increment = 0  
     for card in $hand.get_children():
         card.target = cardpositioner(increment)
         card.targetrot = cardrotater(increment)
         card.state = reOrganiseHand
         increment += 1
     cardspreadval = cardspreadmax

func startTurn():
    pass
    
func _on_redraw_button_pressed():
    DataManager.phase = DataManager.drawingPhase
    cardRedrawer()

func _on_pass_button_pressed():
    DataManager.phase = DataManager.countDownPhase
    EventsBus.emit_signal("countdown", 1)
    
   
