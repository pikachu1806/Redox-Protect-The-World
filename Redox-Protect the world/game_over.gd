extends CanvasLayer
var http_request : HTTPRequest
var request_url = GlobalVars.url + GlobalVars.update_score_url

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_HTTPRequest_request_completed)
	$DeathSprite.play()

	var level = int(GlobalVars.levelSelected)
	if level == 1:
		updateScore(1, str(GlobalVars.score))
		$ScoreLabel.text = "Score: " + str(GlobalVars.score) + " / 240"
	else:
		updateScore(2, str(GlobalVars.score))
		$ScoreLabel.text = "Score: " + str(GlobalVars.score) + " / 160"

	$gamelose.stream = preload("res://audio/game-loss.mp3")
	if GlobalVars.lossGame:
		$gamelose.play()

func _on_main_menu_button_pressed():
	GlobalVars.score = 0
	GlobalVars.health = 3
	get_tree().change_scene_to_file("res://menu.tscn")

func updateScore(level: int, score: String) -> void:
	var payload
	if level == 1:
		payload = {
			"level": "level1",
			"score": score,
			"accessCode": str(GlobalVars.playerId)
		}
	else:
		payload = {
			"level": "level2",
			"score": score,
			"accessCode": str(GlobalVars.playerId)
		}

	var json_payload = JSON.stringify(payload).to_utf8_buffer()  # Convert the JSON payload to PackedByteArray
	var headers = PackedStringArray(["Content-Type: application/json"])
	http_request.request_raw(request_url, headers, HTTPClient.METHOD_PUT, json_payload)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if body.size() == 0:
		print("Empty response body")
		return

	var json = JSON.new()
	if json.parse(body.get_string_from_utf8()) != OK:
		print("Failed to parse JSON response")
		return

	var response_data = json.data
	if response_code == 200:
		print("Score updated successfully:", response_data.get("message", "No message"))
	elif response_code == 400:
		print("Bad Request: ", response_data.get("error", "Unknown error"))
	elif response_code == 404:
		print("Not Found: ", response_data.get("error", "Unknown error"))
	else:
		print("Unexpected Error: ", response_data.get("message", "Unknown error"))
