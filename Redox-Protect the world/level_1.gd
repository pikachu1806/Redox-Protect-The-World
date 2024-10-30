extends Node2D
var is_paused = false
@onready var bullet_scene = get_node("/root/Level1/Bullet")  # Get a reference to the "bullet" scene
@onready var answer_spawn_scene = get_node("/root/Level1/AnswerSpawn")  # Get a reference to the "answer_spawn" scene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("level1")
	$Player.player_hit_answer.connect($AnswerSpawn._on_player_hit_answer)
	$KillPlane.player_missed_answer.connect($AnswerSpawn._on_player_hit_answer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_button_pressed():
	is_paused = true
	get_tree().paused = true
	$PauseButton.hide()
	$ResumeButton.show()
	print("pause btn pressed")

func _on_resume_button_pressed():
	print("Resume btn pressed")
	is_paused = false
	get_tree().paused = false
	$ResumeButton.hide()
	$PauseButton.show()


func _on_answer_display_timer_timeout():
	$AnswerDisplaySprite.visible = false
	
