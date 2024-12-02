extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	GlobalVars.score = 0
	GlobalVars.health = 3
	get_tree().change_scene_to_file("res://menu.tscn")
