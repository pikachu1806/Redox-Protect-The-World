extends CanvasLayer

var selected_option = -1

const ACCESS_CODE_URL = "http://localhost:4040/professor/check-access-code"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_access_code(access_code: String) -> void:
	print("Request code -> ", access_code)
	
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(self._on_check_access_code_response)

	var json_data = { "accessCode": access_code }
	var headers = ["Content-Type: application/json"]

	# Create a JSON string using stringify()
	var json_string = JSON.stringify(json_data)

	# Check if JSON stringification was successful
	if json_string == "":
		print("Error converting to JSON.")
		return

	# Send the HTTP request
	var result = request.request(ACCESS_CODE_URL, headers, HTTPClient.METHOD_POST, json_string)

	# Check if the request was sent successfully
	if result != OK:
		print("Failed to send request: ", result)
		return

	print("Checking access code...")

# Callback function to handle the response for access code checking
func _on_check_access_code_response(result, response_code, headers, body):
	var json = JSON.new()  # Create an instance of JSON

	# Parse the response body as a string
	var error = json.parse(body.get_string_from_utf8())
	if error != OK:
		print("Failed to parse response body as JSON.")
		return
	
	var response = json.data

	if response_code == 200:
		print("Access code verified successfully.")
		$ResponseLabel.text = "Access code verified successfully."
		$ResponseLabel.show()

		# Create a timer for 3 seconds and start it
		var timer = Timer.new()
		timer.wait_time = 3.0
		timer.one_shot = true  # The timer will only fire once
		add_child(timer)
		timer.start()

		# Connect the timer's timeout signal to a custom function
		timer.timeout.connect(_on_verification_timeout)

	elif response_code == 403:
		print("Access code already used. Access denied.")
		$ResponseLabel.text = "Access code already used. Access denied."
		$ResponseLabel.show()

		# No timer or UI changes, just show the message

	else:
		print("Failed to verify access code:", response.get("error", "Unknown error"))
		$ResponseLabel.text = "Failed to verify access code: " + response.get("error", "Unknown error")
		$ResponseLabel.show()

		# No timer or UI changes, just show the message

# Function to handle the timeout after 3 seconds (for response_code == 200)
func _on_verification_timeout():
	# Hide the response label and switch the UI elements after the timer expires
	$ResponseLabel.hide()
	$submitButton.hide()
	$accessCodeInput.hide()
	$Label.hide()
	$Selectlevel.show()
	$StartGameButton.show()
	$StageOptions.show()




func _on_start_game_button_pressed():
	if selected_option != -1:
		get_tree().change_scene_to_file(get_scene_path(selected_option))
	else:
		print("No option selected")

func _on_instructions_button_pressed():
	$InstructionsMessage.show()
	$CloseButton.show()
	$StageOptions.hide()
	$StartGameButton.hide()
	$InstructionsButton.hide()
	$Selectlevel.hide()

func _on_stage_options_item_selected(index):
	selected_option = index

func get_scene_path(index):
	match index:
		0:
			GlobalVars.levelSelected = 1
			return "res://level_1.tscn"
		1:
			GlobalVars.levelSelected = 2
			return "res://level_2.tscn"
		2:
			GlobalVars.levelSelected = 3
			return "res://level_3.tscn"
	return ""

func _on_close_button_pressed():
	$InstructionsButton.show()
	$StartGameButton.show()
	$StageOptions.show()
	$CloseButton.hide()
	$InstructionsMessage.hide()
	$Selectlevel.show()

func _on_SubmitButton_pressed() -> void:
	var access_code_input = $accessCodeInput.text.strip_edges()

	# Check if the access code length is exactly 16 characters
	if access_code_input.length() == 16:
		print("Access code submitted:", access_code_input)
		# Call the function to check the access code
		check_access_code(access_code_input)
	else:
		print("Access code must be exactly 16 characters long.")
