extends Control

var tween : Tween
var crystallooper : Tween

var animationFinished : bool = true
#animation components
@onready var tinyCircle = $component3

@onready var redrawButton = $redrawButton
@onready var animation = $AnimationPlayer

@onready var crystalpos = $redrawButton.position


# Called when the node enters the scene tree for the first time.
func _ready():
    EventsBus.connect("buttonActivation", buttonActivation)
    EventsBus.connect("animationActivation", animationActivation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if redrawButton.is_hovered() and DataManager.phase == DataManager.restPhase:
        spinCircle(3.0)
        playAnimation("hover")
        crystalHover()
        animationFinished = true
    else:
        spinCircle(1.5)
        crystalSnapBack()
        animationFinished = true
        
func buttonActivation(val : bool = true):
    $redrawButton.disabled = val

func animationActivation(val : bool):
    animationFinished = val

func spinCircle(speed):
    tween = create_tween()
    tween.tween_property(tinyCircle, "rotation", speed, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()

func crystalHover():
    crystallooper = create_tween().set_loops()
    if !animationFinished:
      crystallooper.tween_property(redrawButton, "position", crystalpos + Vector2(0,10), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
      crystallooper.tween_property(redrawButton, "position", crystalpos - Vector2(0,10), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
      

func crystalSnapBack():
    crystallooper = create_tween()
    crystallooper.kill()
    tween = create_tween().set_loops()
    if !animationFinished:
      tween.tween_property(redrawButton, "position", crystalpos, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    
func playAnimation(val : String):
    if !animationFinished:
      animation.play(val)


func _on_redraw_button_mouse_exited():
    if DataManager.phase == DataManager.restPhase:
      animationFinished = false
      playAnimation("unhover")
    


func _on_redraw_button_mouse_entered():
    if DataManager.phase == DataManager.restPhase:
      animationFinished = false


func _on_redraw_button_pressed():
    $redrawButton.disabled = true
    animationFinished = false
    playAnimation("unhover")
    crystalSnapBack()
    animationFinished = true
