extends MarginContainer
class_name BaseCard
#miscellaneous variables for calculation purposes
var printedname : String : get = nameget, set = nameset
var effect : Array : get = effectget, set = effectset
var energy : int : get = energyget, set = energyset
var description : String : get = descget, set = descset
var type : String 
var animationFinished : bool = false

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
    inDeck, #card is in a deck
    redrawCard, #card is being moved into the discard for redrawing
    
    playing, #card is being played
    inDiscard, #card is in the discardpile
    inDraw
    
    }
    
var state = inHand

#tweens
var TweenNode
var TweenRotate
var DRAWTIME = 0.2
var tweened = false

#rotation and position
var target = position
var targetrot = 0
var focustarget
var focusrot
var targetdiscard

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

func stateset(val):
    state = val

func animationset(val):
    animationFinished = val

#--------------------------------end of setters/getters-------------------------------------

func _ready():
    animation.speed_scale = 1/DRAWTIME
    
    #animation signals
    EventsBus.connect("setState", stateset)
    EventsBus.connect("setAnimationstate", animationset)

func _process(delta):
    
    if Input.is_action_just_released("ui_left_click") and state == playing:
      animation.play("simpleUnfocus")
      state = unfocusing

    
    match state:
       inHand:
          self.scale = Vector2(1,1)
       reOrganiseHand:
          $spriteNodes.z_index = 1
          TweenNode = create_tween()
          TweenRotate = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenRotate.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          state = inHand
       moveDrawnCardToHand:
          #global_position = Vector2(1750, 750)
          $spriteNodes.z_index = 2
          TweenNode = create_tween()
          TweenRotate = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenRotate.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          state = inHand
       discardCard:
          $spriteNodes.z_index = 0
          TweenNode = create_tween()
          TweenRotate = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenRotate.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          state = inDiscard
       redrawCard:
          $spriteNodes.z_index = 0
          TweenNode = create_tween()
          TweenRotate = create_tween()
          TweenNode.tween_property(self, "global_position", target , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          TweenRotate.tween_property(self, "rotation_degrees", targetrot , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          state = inDiscard
       focusing:
          rotation_degrees = 0
          TweenNode = create_tween()
          var focuspt = target
          animation.play("simpleFocus")
              #1.62
          focuspt.y = projresolution.y*1.45 - $spriteNodes/graphicsScaler/Cardbackground.texture.get_height()*scale.y*1.8
          TweenNode.tween_property(self, "global_position", focuspt , DRAWTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
          $spriteNodes.z_index = 2
          state = focusInHand
       unfocusing:
          $spriteNodes.z_index = 2
          state = reOrganiseHand
       focusInHand:
          rotation_degrees = 0
       inPlay:
          self.scale = Vector2(0.64,0.64)
       inDiscard:
          pass
       inDraw:
          target = Vector2(1700,750)
        
        


func _on_mouse_entered():
    pass
    


func _on_mouse_exited():
    #put unfocus aniamtion here instead of the state machine as a weird glitch is making the unfocus
    #effect play everytime its in the state machine
    if state == focusInHand and animationFinished == true:
      animation.play("simpleUnfocus")
      state = unfocusing
    



func _on_gui_input(event):
    if event is InputEventMouseMotion:
       if state == inHand and !Input.is_action_pressed("ui_left_click") and animationFinished == true:
         state = focusing


func _on_animation_player_animation_finished(simpleUnfocus):
    pass

func _get_drag_data(at_position):
    
    if state == focusInHand:
      var preview = Node2D.new()
      var texture = $spriteNodes.duplicate()
      texture.scale = texture.scale * 0.3
      preview.add_child(texture)
      #preview.expand_mode = 1
      #preview.size = Vector2(30,30)
    
      var ghostdrag = Control.new()
      ghostdrag.add_child(preview)
      set_drag_preview(ghostdrag)
      state = playing
    
      return self

func _can_drop_data(at_position, data):
    return data

func _drop_data(at_position, data):
    pass

