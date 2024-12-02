extends Area2D

var speed = 300.0
var direction = Vector2.UP
signal hit_answer

# Load the textures for correct and incorrect answers
var correct_texture = preload("res://backgrounds/correct-answer.png")
var incorrect_texture = preload("res://backgrounds/incorrect-answer.png")

# Reference to the Sprite and Timer nodes from player.tscn
var player_sprite
var player_timer
var player_scene

func _ready():
	# Get the Sprite and Timer nodes from the player.tscn scene
	if int(GlobalVars.levelSelected) == 1:
		player_scene = get_tree().root.get_node("Level1")
	else:
		player_scene = get_tree().root.get_node("Level2")
		  # Ensure this matches the name of the main screen scene
	player_sprite = player_scene.get_node("AnswerDisplaySprite")
	player_timer = player_scene.get_node("AnswerDisplayTimer")
	player_sprite.visible = false  # Hide the sprite initially
	player_timer.wait_time = 1  # Set the timer to 1 seconds


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body.is_in_group("correct"):
		GlobalVars.isCorrect = true
		print("Hit correct answer")
		GlobalVars.score += 10
		# Show the correct image
		player_sprite.texture = correct_texture

	else:
		GlobalVars.isCorrect = false
		print("Incorrect answer hit by: " + str(body))
		GlobalVars.health -= 1
		print("Health: " + str(GlobalVars.health))
		# Show the incorrect image
		player_sprite.texture = incorrect_texture
		
	# Show the sprite with the corresponding image
	player_sprite.visible = true

	# Start the timer for 3 seconds to hide the sprite afterward
	player_timer.start()

	hit_answer.emit()

	# Free the node and check for game over
	queue_free()
	
	if GlobalVars.health <= 0:
		GlobalVars.lossGame = true
		print("Game Over! Exiting...")
		get_tree().change_scene_to_file("res://game_over.tscn")
		
	# Called when the timer times out (after 3 seconds)
func _on_AnswerDisplayTimer_timeout():
	# Hide the sprite after the 1-second delay
	player_sprite.visible = false
