extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("countdown", countdown)

func countdown(val : int):
  EventsBus.emit_signal("setAnimationstate", false)
  var cardTime = 0
  for i in range(val):
    #deplete count by 1 and assign the cardtime to delay the depletion of counter values
    for slot in $enemyField.get_children():
        if slot.activeCard != null:
            var actingCard = slot.activeCard
            actingCard.counter -= 1
            cardTime = actingCard.DRAWTIME
    for slot in $heroField.get_children():
        if slot.activeCard != null:
            var actingCard = slot.activeCard
            actingCard.counter -= 1
            cardTime = actingCard.DRAWTIME
    
    #checks for counter value and fights if counter is zero
    #input false if the card is on the enemy side and true if on hero side
    #and then execute the appropriate commands and delay by card time
    for slot in $enemyField.get_children():
        if slot.activeCard != null and slot.activeCard.counter <= 0:
            var actingCard = slot.activeCard
            actingCard.fight()
            await get_tree().create_timer(actingCard.DRAWTIME).timeout;
            
    for slot in $heroField.get_children():
        if slot.activeCard != null and slot.activeCard.counter <= 0:
            var actingCard = slot.activeCard
            actingCard.fight()
            await get_tree().create_timer(actingCard.DRAWTIME).timeout;
    
    #this is to delay after every depletion of a count
    await get_tree().create_timer(cardTime).timeout;
  
  #emit signals to reactivate cards and buttons
  EventsBus.emit_signal("buttonActivation")
  EventsBus.emit_signal("setAnimationstate", true)


    
  
