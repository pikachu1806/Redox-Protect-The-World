extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Level 2")


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
