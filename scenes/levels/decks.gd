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

#DRAW LOGIC
func carddrawer(drawno):
     var drawglobal = $draw
     var handglobal = $hand
     var drawvalue = drawno
     var drawdeck = drawglobal.drawdeck
     #append the top card to hand and then remove it 
     for i in range(drawvalue):
         if len(drawdeck) < 1:
            pass
            if len(drawdeck) < 1:
               break
          
         var childcard = drawdeck[0]
         
         #reorganise the hand
         handglobal.add_child(childcard)
         #to be used to play card drawing animation
         childcard.global_position = drawglobal.global_position
         childcard.target = cardpositioner(i)
         childcard.targetrot = cardrotater(i)
         childcard.state = moveDrawnCardToHand
         drawdeck.erase(drawdeck[0])
         await get_tree().create_timer(childcard.DRAWTIME).timeout;
         $draw/drawValue.text = "[center]" + str(int($draw/drawValue.text) - 1) + "[/center]"
         #if is_instance_valid(drawdeck[0]):
         #   drawdeck[0].free()
         reorganiser()
         
     #reorganise the hand one last time
     reorganiser()
    
#END TURN LOGIC

#CARD POSITIONING LOGIC
#take an integer value and positions the card
func cardpositioner(i):
    
    var cardspread = cardspreadval
    
    var num_cards = $hand.get_child_count()-1
    var newposition
    
    var projresolution = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
    var centreCardOval = projresolution * Vector2(0.5, 1.25)
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

# Called when the node enters the scene tree for the first time.
func _ready():
    $draw.drawdeck = DataManager.maindeck.duplicate()
    $draw/drawValue.text = str(len(DataManager.maindeck))
    # for i in range(10):
       # var base = load("res://scenes/widgets/Summoncard.tscn").instantiate()
       # $draw.drawdeck.append(base)
    carddrawer(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func startTurn():
    pass
    
func _on_redraw_button_pressed():
    pass # Replace with function body.
