extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = "Score: " + str(GlobalVars.score)
	$Health.text = "Health: " + str(GlobalVars.health)
