extends Control
var bellcounter : int : get = bellget, set = bellset

#stopping booleans

#this boolean detects a full field
var onFullField : bool = false
#this one detects if there are no more summons
var onEmptySummons : bool = false
#this one detects if a wave is just summoned (prevent the counter from overflowing when using a high cost action)
var onWaveJustSummoned : bool = false

var enemywavetime = []

func bellget():
    return bellcounter

func bellset(val : int):
    bellcounter = val
    $BellLabel.text = "[center]" + str(val)

func depleteBell(val: int):
    if onEmptySummons or onWaveJustSummoned:
        return
    
    if !onFullField:
        bellset(bellcounter-val)
        
    if bellcounter <= 0:
        if !onFullField and !enemywavetime.is_empty():
          await get_tree().create_timer(DataManager.DRAWTIME).timeout;
          bellset(enemywavetime[0])
          enemywavetime.pop_front()
          EventsBus.emit_signal("summonWave")
          onWaveJustSummoned = true
        else:
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
          bellset(enemywavetime.pop_front())

func setWaveJustSummoned(val):
    onWaveJustSummoned = val
        
# Called when the node enters the scene tree for the first time.
func _ready():
    var enemywavestorage = DataManager.enemywaves.duplicate()
    for wave in enemywavestorage:
        enemywavetime.append(wave[1])
    
    bellset(enemywavetime[0])
    EventsBus.connect("depleteBell", depleteBell) 
    EventsBus.connect("disableBell", disableBell)
    EventsBus.connect("detectFullField", detectFullField)
    EventsBus.connect("setWaveJustSummoned", setWaveJustSummoned)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
