extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var newShader = DataManager.nebulaShader.duplicate()
    add_child(newShader)
    newShader.get_node("ParallaxLayer/ColorRect").color = Color("004ea9")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
