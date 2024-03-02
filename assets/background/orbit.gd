extends Node2D

@onready var spinner = $Spinner
@onready var CircleAxis = $CircleAxis
@onready var OrbitAxis = $OrbitalAxis
var tweener

@export var circleSpeed : float = 3.0
@export var orbitSpeed : float = -1.5
@export var orbitalVisible = true

# Called when the node enters the scene tree for the first time.
func _ready():
    $OrbitalAxis/OrbitalObject.visible = orbitalVisible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    spinCircle(circleSpeed)
    spinOrbit(orbitSpeed)
    
func _physics_process(delta):
    pass
    
func spinCircle(speed):
    tweener = create_tween()
    tweener.tween_property(CircleAxis, "rotation", speed, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()

func spinOrbit(speed):
    tweener = create_tween()
    tweener.tween_property(OrbitAxis, "rotation", speed, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()
