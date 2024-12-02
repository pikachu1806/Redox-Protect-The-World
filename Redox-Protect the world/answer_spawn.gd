extends Node2D
@export var Answers: PackedScene

var level1
var level2

# HTTPRequest instance
var http_request
var questions = []
var questionSet
var count = 1
var last_spawned_question = null
var url
func _ready():
	http_request = HTTPRequest.new()  # Create HTTPRequest node
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	fetch_data_from_api()

# Function to fetch data from an API
func fetch_data_from_api():
	if int(GlobalVars.levelSelected) == 1:
		url = str(GlobalVars.url) + str(GlobalVars.loadQuestions) + "?level=1"
	else:
		url = str(GlobalVars.url) + str(GlobalVars.loadQuestions) + "?level=2"
	print("Url - ", url)
	http_request.request(url)

# Callback for when the request is completed
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_parser = JSON.new()
		var parse_result = json_parser.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			var json_data = json_parser.data
			print("Json Data ", json_data)
			# Initialize the level1 variable
			if int(GlobalVars.levelSelected) == 1:
				level1 = json_data
			else:
				level2 = json_data
			
				
			print("Questions loaded: ", level1)
			
		else:
			print("Error parsing JSON: ", parse_result)
	else:
		print("Request failed with code: %d" % response_code)





var correct_answers_scene = preload("res://correct_answers.tscn")
var incorrect_answers_scene = preload("res://incorrect_answers.tscn")


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVars.score == 100:
		get_tree().change_scene_to_file("res://game_win.tscn")
	
func updateLvl1QuestionsAnswers():
	get_tree().call_group("correct", "queue_free")
	get_tree().call_group("incorrect", "queue_free")
	#set question and compund for question
	$QuestionLabel.text =  (questionSet["question"])
	$CompoundLabel.bbcode_text = "[center][color=black]" + str(count) + ". " + questionSet[str(count)]["compound"] + " [/color][/center]"
	$CompoundLabel.show()
	# Get the viewport's size to calculate spawn positions
	var viewport = get_viewport().get_visible_rect()
	var width = viewport.size.x
	var height = viewport.size.y

	# Define the y position for the answers
	var y_position = height * 0.3  # Place answers slightly above the bottom of the screen
	var position_x_step = width / 4
	
	#Instantiate answers_scene for correct and incorrect
	var tag: String = ""
	var correctAnswer = correct_answers_scene.instantiate()
	var incorrectAnswer1 = incorrect_answers_scene.instantiate()
	var incorrectAnswer2 = incorrect_answers_scene.instantiate()
	var incorrectAnswer3 = incorrect_answers_scene.instantiate()
	
	# Get a reference to the Label node
	var correctAnswerLabel = correctAnswer.get_node("Label")
	var incorrectAnswerLabel1 = incorrectAnswer1.get_node("Label")
	var incorrectAnswerLabel2 = incorrectAnswer2.get_node("Label")
	var incorrectAnswerLabel3 = incorrectAnswer3.get_node("Label")
	
	#Add answers to label
	correctAnswerLabel.text = (questionSet[str(count)]["correct"])
	incorrectAnswerLabel1.bbcode_text = (questionSet[str(count)]["incorrect1"])
	incorrectAnswerLabel2.bbcode_text = (questionSet[str(count)]["incorrect2"])
	incorrectAnswerLabel3.bbcode_text = (questionSet[str(count)]["incorrect3"])
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	
	# Randomize the order of the answers
	var children = [correctAnswer, incorrectAnswer1, incorrectAnswer2, incorrectAnswer3]
	children.shuffle()
	print("Children ", children)

	# Set positions for each answer based on the shuffled order
	for i in range(children.size()):
		var answer = children[i]
		answer.position = Vector2(position_x_step * (i + 0.1), y_position)  # Adjust index for spacing

	# Spawn each question with a 1-second delay
	for child in children:
		get_parent().add_child(child)
		await get_tree().create_timer(1.0).timeout
	
	if count < 24:
		count += 1 #Update Question count
	else:
		get_tree().change_scene_to_file("res://game_over.tscn")
		
func updateLvl2QuestionsAnswers():
	get_tree().call_group("correct", "queue_free")
	get_tree().call_group("incorrect", "queue_free")
	#set question and compund for question
	print("Question", questionSet["question"])
	if (count % 2) == 0:
		$QuestionLabel.text = "Shoot the Reduced"
	else:
		$QuestionLabel.text = "Shoot the Oxidized"
	$CompoundLabel.bbcode_text = "[center][color=black] Q"+str(count) + "). " + questionSet[str(count)]["question"] + " [/color][/center]"
	$CompoundLabel.show()
	# Get the viewport's size to calculate spawn positions
	var viewport = get_viewport().get_visible_rect()
	var width = viewport.size.x
	var height = viewport.size.y

	# Define the y position for the answers
	var y_position = height * 0.3  # Place answers slightly above the bottom of the screen
	var position_x_step = width / 2
	
	#Instantiate answers_scene for correct and incorrect
	var tag: String = ""
	var correctAnswer = correct_answers_scene.instantiate()
	var incorrectAnswer1 = incorrect_answers_scene.instantiate()
	
	# Get a reference to the Label node
	var correctAnswerLabel = correctAnswer.get_node("Label")
	var incorrectAnswerLabel1 = incorrectAnswer1.get_node("Label")
	
	#Add answers to label
	if (count % 2) == 0:
		correctAnswerLabel.text = (questionSet[str(count)]["reduced"])
		incorrectAnswerLabel1.text = (questionSet[str(count)]["oxidized"])
	else:
		correctAnswerLabel.text = (questionSet[str(count)]["oxidized"])
		incorrectAnswerLabel1.text = (questionSet[str(count)]["reduced"])
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	
	# Randomize the order of the answers
	var children = [correctAnswer, incorrectAnswer1]
	children.shuffle()
	print("Children ", children)

	# Set positions for each answer based on the shuffled order
	for i in range(children.size()):
		var answer = children[i]
		answer.position = Vector2(position_x_step * (i + 0.1), y_position)  # Adjust index for spacing

	# Spawn each question with a 1-second delay
	for child in children:
		get_parent().add_child(child)
		await get_tree().create_timer(1.0).timeout
	
	if count < 16:
		count += 1 #Update Question count
	else:
		get_tree().change_scene_to_file("res://game_over.tscn")

func _on_start_button_pressed():
	$StartButton.hide()
	if GlobalVars.levelSelected == 1:
		questionSet = level1
		updateLvl1QuestionsAnswers()
	elif GlobalVars.levelSelected == 2:
		questionSet = level2
		updateLvl2QuestionsAnswers()
	

func _on_player_hit_answer():
	if int(GlobalVars.levelSelected) == 1:
		updateLvl1QuestionsAnswers()
	else:
		updateLvl2QuestionsAnswers()
