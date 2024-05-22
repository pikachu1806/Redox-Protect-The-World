extends Node2D

@onready var bullet_scene = get_node("/root/Lvl1/Player/Bullet")  # Get a reference to the "bullet" scene
@onready var answer_spawn_scene = get_node("/root/Lvl1/AnswerSpawn")  # Get a reference to the "answer_spawn" scene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("level1")
	$Player.player_hit_answer.connect($AnswerSpawn._on_player_hit_answer)
	$KillPlane.player_missed_answer.connect($AnswerSpawn._on_player_hit_answer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
