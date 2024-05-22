extends Area2D

var speed = 300.0
var direction = Vector2.UP
signal hit_answer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body.is_in_group("correct"):
		print("hit correct answer") #Placeholder
		GlobalVars.score += 10
	else:
		print("Incorrect answer hit") #Placeholder
	hit_answer.emit()
	queue_free()
