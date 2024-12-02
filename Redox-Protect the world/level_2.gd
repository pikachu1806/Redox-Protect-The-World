extends Control
var is_paused = false
@onready var bullet_scene = get_node("/root/Level1/Bullet")  # Get a reference to the "bullet" scene
@onready var answer_spawn_scene = get_node("/root/Level1/AnswerSpawn")  # Get a reference to the "answer_spawn" scene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Level 2")
	$Player.player_hit_answer.connect($AnswerSpawn._on_player_hit_answer)
	$KillPlane.player_missed_answer.connect($AnswerSpawn._on_player_hit_answer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pause_button_pressed():
	get_tree().paused = true
	$PauseButton.hide()
	$HelpButton.show()
	$ResumeButton.show()

func _on_resume_button_pressed():
	get_tree().paused = false
	$Message.hide()
	$ResumeButton.hide()
	$HelpButton.hide()
	$PauseButton.show()


func _on_help_button_pressed():
	$ResumeButton.hide()
	$HelpButton.hide()
	$HelpMessage.show()
	$HelpOkButton.show()


func _on_help_ok_button_pressed():
	$HelpButton.show()
	$ResumeButton.show()
	$HelpMessage.hide()
	$HelpOkButton.hide()

func _on_answer_display_timer_timeout():
	$AnswerDisplaySprite.visible = false
