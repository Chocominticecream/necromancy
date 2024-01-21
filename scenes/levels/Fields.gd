extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("countdown", countdown)

func countdown(val):
  EventsBus.emit_signal("setAnimationstate", false)
  var cardTime = 0
  for i in range(val):
    #deplete count
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
    
    #fight if counter is zero
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
    
    await get_tree().create_timer(cardTime).timeout;
  EventsBus.emit_signal("setAnimationstate", true)
    
  
