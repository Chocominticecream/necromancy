extends Control

#deck that stores deck data in battle
@onready var drawdeck = [] : get = drawget, set = drawset 

func drawset(val):
    $drawValue.text = "[center]" + str(len(val)) + "[/center]"
    drawdeck = val 

func drawget():
    return drawdeck
    
func _ready():
    var base = load("res://scenes/widgets/BaseCard.tscn").instantiate()
    for i in range(10):
        drawdeck.append(base.duplicate())
    $drawValue.text = "[center]" + str(len(drawdeck)) + "[/center]"


