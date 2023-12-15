extends Control

#deck that stores deck data in battle
@onready var drawdeck = [] : get = drawget, set = drawset 

func drawset(val):
    $drawValue.text = "[center]" + str(len(val)) + "[/center]"
    drawdeck = val 

func drawget():
    return drawdeck
    
func _ready():
    pass


