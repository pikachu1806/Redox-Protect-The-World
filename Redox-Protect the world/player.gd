extends CharacterBody2D

const SPEED = 300.0
signal player_hit_answer
var bullet_instance = null
@export var bullet_scene: PackedScene

func _ready():
	# Ensure the AudioStreamPlayer node is ready
	$gunshot.stream = preload("res://audio/gunshot.mp3")  # Adjust the path as needed
	$collision.stream = preload("res://audio/collision.mp3")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed('ui_accept') and $ShootTimer.is_stopped():
		shoot()
	move_and_slide()
	
func shoot():
	if $ShootTimer.is_stopped():
		$ShootTimer.start()
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = $Marker2D.global_position
		get_parent().add_child(bullet_instance)
		bullet_instance.hit_answer.connect(_on_bullet_hit_answer)
		
		# Play the gunshot sound
		$gunshot.play()

func _on_shoot_timer_timeout():
	$ShootTimer.stop()
	
func _on_bullet_hit_answer():
	player_hit_answer.emit()
	$collision.play()
