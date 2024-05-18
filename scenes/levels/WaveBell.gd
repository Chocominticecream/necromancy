extends Control
var bellcounter : int : get = bellget, set = bellset
var onFullField : bool = false
var onEmptySummons : bool = false

var enemywavetime = []

func bellget():
    return bellcounter

func bellset(val : int):
    bellcounter = val
    $BellLabel.text = "[center]" + str(val)

func depleteBell(val: int):
    if onEmptySummons:
        return
    
    if !onFullField:
        bellset(bellcounter-val)
        
    if bellcounter <= 0:
        if !onFullField:
          enemywavetime.pop_front()
        EventsBus.emit_signal("summonWave")

#disables the bell afyer wavequeue and wave array is empty
func disableBell():
    onEmptySummons = true
    $BellLabel.text = "[center]" + "X"

#does not let the bell go below 0 if field is full
func detectFullField(value : bool):
    onFullField = value
    if !value:
       if !enemywavetime.is_empty():
          bellset(enemywavetime[0])
            
# Called when the node enters the scene tree for the first time.
func _ready():
    var enemywavestorage = DataManager.enemywaves.duplicate()
    for wave in enemywavestorage:
        enemywavetime.append(wave[1])
    
    bellset(enemywavetime[0])
    EventsBus.connect("depleteBell", depleteBell) 
    EventsBus.connect("disableBell", disableBell)
    EventsBus.connect("detectFullField", detectFullField)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
