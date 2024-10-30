extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$DeathSprite.play()
	$ScoreLabel.text = "Score: " + str(GlobalVars.score) + " / 240"
	$gamelose.stream = preload("res://audio/game-loss.mp3")
	if GlobalVars.lossGame == true:
		$gamelose.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_main_menu_button_pressed():
	GlobalVars.score = 0
	GlobalVars.health = 3
	get_tree().change_scene_to_file("res://menu.tscn")
