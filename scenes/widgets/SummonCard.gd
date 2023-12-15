extends BaseCard
class_name SummonCard

#this is a summon card
var hp : int :get = hpget, set = hpset
var attack : int : get = attget, set = attset

func hpset(val):
    $spriteNodes/TextNormal/Name.text = "[center]" + str(val) + "[/center]"
    $spriteNodes/TextFocused/Name.text = "[center][b]" + str(val) + "[/center]"
    hp = val 

func hpget():
    return hp

func attset(val):
    $textNodes/attack.text = "[center]" + str(val) + "[/center]"
    $spriteNodes/textNodes/attack.text = "[center][b]" + str(val) + "[/center]"
    attack = val 

func attget():
    return attack
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
