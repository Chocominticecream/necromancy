extends MarginContainer
class_name BaseSlot

var alliance : bool 

signal resetCards

var activeCard = null
# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("onTakeDamage", onTakeSlotDamage)
    EventsBus.connect("activeCardToNull", activeCardToNull)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _can_drop_data(at_position, data):
    pass
    
func _drop_data(at_position, data):
    activeCard = data
    data.position.x = self.position.x
    data.position.y = self.position.y
    data.get_node("spriteNodes").z_index = 0
    data.state = data.inPlay
    data.get_parent().remove_child(data)
    self.add_child(data)
    slotted_logic()

func slotted_logic():
    pass    

func onTakeSlotDamage(ally : bool, damage : int, attackingFoe : Array):
    var teststring = ""
    if alliance:
        teststring = "hero has taken "
    else:
        teststring = "enemy has taken "
    if !ally == alliance:
       for idx in attackingFoe:
         if activeCard == null and get_index() == idx:
            print(teststring + str(damage) + " direct damage!")
         elif get_index() == idx:
            activeCard.onTakeDamage(ally,damage,attackingFoe)
         else:
            pass

#code to set activecard after card death to null because my coding skills suck          
func activeCardToNull(idx : int):
    if get_index() == idx:
        activeCard = null
