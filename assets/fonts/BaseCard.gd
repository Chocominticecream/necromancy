extends MarginContainer
class_name BaseCard

#miscellaneous variables for calculation purposes
var printedname : String : get = nameget, set = nameset
var effect : Array : get = effectget, set = effectset
var energy : int : get = energyget, set = energyset
var description : String : get = descget, set = descset
var type : String

var projresolution = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
#for state machine of the card
enum{
    inHand, #check in hand, no focus
    inPlay, #check in play, already assigned to a cardslot
    inMouse, #check if its held in the mouse (ready to be played)
    
    focusing, #playing focus animation
    focusInHand, #check if in hand, focussing
    unfocusing, #playing unfocus
    
    moveDrawnCardToHand, #check if card is being moved to hand
    reOrganiseHand, #reorganise (card is being moved to hand)
    discardCard, #card is being discarded to the pile
    inSlot, #card is held in mouse and about to be played into a cardslot
    inDeck #card is in a deck
    }
    
var state = inHand

#tweens
var TweenNode
var DRAWTIME = 0.2
var tweened = false

#rotation and position
var target
var targetrot
var focustarget
var focusrot

#animation
@onready var animation = $AnimationPlayer

#----------------------------setters and getters---------------------------------
    
func nameset(val):
    $spriteNodes/TextNormal/Name.text = "[center]" + str(val) 
    $spriteNodes/TextFocused/Name.text = "[center][b]" + str(val) 
    printedname = val
    
func nameget():
    return printedname
    
func effectset(val):
    effect = val
    
func effectget():
    return effect

func energyset(val):
    $spriteNodes/TextNormal/Energy.text = "[center]" + str(val) 
    $spriteNodes/TextFocused/Energy.text = "[center][b]" + str(val)
    energy = val

func energyget():
    return energy
    
func descset(val):
    $spriteNodes/TextNormal/Description.text = "[center]" + str(val)
    $spriteNodes/TextFocused/Description.text = "[center][b]" + str(val)
    description = val

func descget():
    return description

#--------------------------------end of setters/getters-------------------------------------

func _ready():
    animation.speed_scale = 1/DRAWTIME

func _process(delta):
   
    match state:
       inHand:
          pass
       reOrganiseHand:
          TweenNode = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenNode.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          state = inHand
       moveDrawnCardToHand:
          TweenNode = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenNode.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
       discardCard:
          TweenNode = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenNode.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
       focusing:
          TweenNode = create_tween()
          var focuspt = target
          rotation_degrees = 0
          animation.play("simpleFocus")
              #1.62
          focuspt.y = projresolution.y*1.45 - $spriteNodes/graphicsScaler/Cardbackground.texture.get_height()*scale.y*1.8
          TweenNode.tween_property(self, "global_position", focuspt , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          $spriteNodes.z_index = 1
          state = focusInHand
       unfocusing:
          $spriteNodes.z_index = 0
          state = reOrganiseHand
       focusInHand:
          pass
        
        


func _on_mouse_entered():
    state = focusing
    


func _on_mouse_exited():
    #put unfocus aniamtion here instead of the state machine as a weird glitch is making the unfocus
    #effect play everytime its in the state machine
    animation.play("simpleUnfocus")
    state = unfocusing
    



func _on_gui_input(event):
    if event is InputEventMouseMotion:
       pass


func _on_animation_player_animation_finished(simpleUnfocus):
    pass
