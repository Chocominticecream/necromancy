extends Node2D
class_name StatusSymbol
#symbols are 512 x 512, scaled down to 0.1
var value : int  = 0 : get = valueget, set = valueset

func valueget():
    return value
    
func valueset(val):
    value = val
    if val == 0:
        $StatusValue.text = "[center]" + ""
    else:
        $StatusValue.text = "[center]" + str(value)
    
func _ready():
    pass
