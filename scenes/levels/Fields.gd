extends Control

var universalFunc = Universalfunc.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("countdown", countdown)

#countdown function
func countdown(val : int):
  DataManager.phase = DataManager.countDownPhase

  if !DataManager.deathdelay.is_empty():
        for waittime in DataManager.deathdelay:
           await get_tree().create_timer(waittime).timeout
        DataManager.deathdelay.clear()
    
  var cardTime = DataManager.DRAWTIME
  for i in range(val):
    #this part of the function to delay counter a bit when a card dies
    DataManager.delay.clear()
    #deplete count by 1 and assign the cardtime to delay the depletion of counter values
    for slot in $enemyField.get_children()+$heroField.get_children():
        if slot.activeCard != null and slot.activeCard.state != slot.activeCard.death:
            #checks if the card is sleeping, preventing it from attacking
            if !slot.activeCard.checkStatus(DataManager.STATUS.sleep):
              var actingCard = slot.activeCard
              actingCard.counter -= 1
    
    #checks for counter value and fights if counter is zero
    #input false if the card is on the enemy side and true if on hero side
    #and then execute the appropriate commands and delay by card time
    for slot in $enemyField.get_children()+$heroField.get_children():
        if slot.activeCard != null and slot.activeCard.counter <= 0:
            for j in range(slot.activeCard.multihit):
              var actingCard = slot.activeCard
              actingCard.onAttack()
              #activate special effects like counterattacks
              await get_tree().create_timer(DataManager.DRAWTIME*2.0).timeout;
              if !DataManager.delay.is_empty():
                for waittime in DataManager.delay:
                  await get_tree().create_timer(waittime).timeout;
                  DataManager.delay.clear()
            #trigger after attack effects
            await get_tree().create_timer(DataManager.DRAWTIME*1.5).timeout;    
    

            
    #some code to check for delaying takedamage effects and activate them here
            #some on take damage effect? (reduce counter when hit, draw when hit)
            #plan to implement, grab attackingfoe variable then iterate through opposing field
            #check if variable is takedamage class object, if it is check for delay then add that here
    
    #this is to delay after every depletion of a count
    EventsBus.emit_signal("depleteBell", 1)
        
    await get_tree().create_timer(DataManager.DRAWTIME*1.5).timeout;
    
  if !DataManager.delay.is_empty():
    for waittime in DataManager.delay:
       await get_tree().create_timer(waittime).timeout;
    DataManager.delay.clear()
  
  #wake up all cards
  for slot in $enemyField.get_children()+$heroField.get_children():
     if slot.activeCard != null:
        slot.activeCard.applyStatus(DataManager.STATUS.sleep)
  
  for slot in $enemyField.get_children()+$heroField.get_children():
     if slot.activeCard != null:
        slot.activeCard.freshCard = false
  #emit signals to reactivate cards and buttons
  
  DataManager.phase = DataManager.playPhase

