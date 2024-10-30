extends Node2D
@export var Answers: PackedScene

var level1

# HTTPRequest instance
var http_request
var questions = []
var questionSet
var count = 1
var last_spawned_question = null

func _ready():
	http_request = HTTPRequest.new()  # Create HTTPRequest node
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	fetch_data_from_api()

# Function to fetch data from an API
func fetch_data_from_api():
	var url = "http://localhost:4040/professor/loadLevel1Questions"  # API endpoint
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
			level1 = json_data
			
				
			print("Questions loaded: ", level1)
			
		else:
			print("Error parsing JSON: ", parse_result)
	else:
		print("Request failed with code: %d" % response_code)


var level2 = {
	"question1" = "Is this a redox reaction?",
	"question2" = "What reactant was oxidized?",
	"question3" = "What reactant was reduced?",
	
	"1" = {
		"chemicalEquation": "𝐶𝐻2𝑂(𝑎𝑞) + 𝑂2(𝑔) → 𝐶𝑂2(𝑔) + 𝐻2𝑂(𝑙)",
		"redox": "Yes",
		"oxidized": "CH2O",
		"reduced": "O2",
		"incorrect1": "CO2",
		"incorrect2": "H2O"
	},
	
	"2" = {
		"chemicalEquation": "2𝐾𝐶8𝐻5𝑂4 + 30𝑀𝑛2(𝑆𝑂4)3 + 24𝐻2𝑂 → 16𝐶𝑂2 + 60𝑀𝑛𝑆𝑂4 + 28𝐻2𝑆𝑂4 + 2𝐾𝐻𝑆𝑂4",
		"redox": "Yes",
		"oxidized": "KC8H5O4",
		"reduced": "Mn2(SO4)3",
		"incorrect1": "H2O",
		"incorrect2": "CO2"
	},
	
	"3" = {
		"chemicalEquation": "2𝐾𝐶8𝐻5𝑂4 + 10𝐾2𝐶𝑟2𝑂7 + 41𝐻2𝑆𝑂4 → 16𝐶𝑂2 + 46𝐻2𝑂 + 10𝐶𝑟2(𝑆𝑂4)3 + 11𝐾2𝑆𝑂4",
		"redox": "Yes",
		"oxidized": "KC8H5O4",
		"reduced": "K2Cr2O7",
		"incorrect1": "H2SO4",
		"incorrect2": "KHSO4"
	},
	
	"4" = {
		"chemicalEquation": "4𝐶𝑙−(𝑎𝑞) + 𝑂2(𝑔) + 4𝐻+(𝑎𝑞) → 2𝐻2𝑂(𝑙) + 2𝐶𝑙2(𝑔)",
		"redox": "Yes",
		"oxidized": "Cl-",
		"reduced": "O2",
		"incorrect1": "H+",
		"incorrect2": "H2O"
	},
	
	"5" = {
		"chemicalEquation": "4𝐹𝑒𝑆2(𝑠) + 15𝑂2(𝑔) + 2𝐻2𝑂(𝑙) → 𝑏𝑎𝑐𝑡𝑒𝑟𝑖𝑎 → 4𝐹𝑒3+ + 8𝑆𝑂3-4 + 4𝐻+ + 2𝐹𝑒2(𝑆𝑂4)3 + 2𝐻2𝑆𝑂4",
		"redox": "Yes",
		"oxidized": "FeS2",
		"reduced": "FeS2 and O2",
		"incorrect1": "H2O",
		"incorrect2": "Fe2(SO4)3"
	},
	
	"6" = {
		"chemicalEquation": "2𝐶𝐻2𝑂(𝑎𝑞) → 𝑏𝑎𝑐𝑡𝑒𝑟𝑖𝑎 → 𝐶𝐻4(𝑔)+ 𝐶𝑂2(𝑔)",
		"redox": "Yes",
		"oxidized": "Some of the carbon in CH2O",
		"reduced": "Some of the carbon in CH2O",
		"incorrect1": "CH4",
		"incorrect2": "CO2"
	},
	
	"7" = {
		"chemicalEquation": "𝑁2(𝑔)+ 𝑂2(𝑔) → ℎ𝑒𝑎𝑡 → 2𝑁𝑂(𝑔)",
		"redox": "Yes",
		"oxidized": "N2",
		"reduced": "O2",
		"incorrect1": "NO",
		"incorrect2": "O"
	},
	
	"8" = {
		"chemicalEquation": "2𝑁2(𝑔) + 5𝑂2(𝑔) + 2𝐻2𝑂(𝑙) → 4𝐻𝑁𝑂3(𝑎𝑞)",
		"redox": "Yes",
		"oxidized": "N2",
		"reduced": "O2",
		"incorrect1": "H2O",
		"incorrect2": "HNO3"
	},
	
	"9" = {
		"chemicalEquation": "2𝑆(𝑠) + 3𝑂2(𝑔) + 2𝐻2𝑂(𝑙) → 2𝐻2𝑆𝑂4(𝑎𝑞)",
		"redox": "Yes",
		"oxidized": "S (s)",
		"reduced": "O2",
		"incorrect1": "H2O",
		"incorrect2": "H2SO4"
	},
	
	"10" = {
		"chemicalEquation": "𝐶𝐻4(𝑔) + 2𝑂2(𝑔) → 𝐶𝑂2 + 2𝐻2𝑂",
		"redox": "Yes",
		"oxidized": "Carbon in CH4",
		"reduced": "O2",
		"incorrect1": "CO2",
		"incorrect2": "H2O"
	},
	
	"11" = {
		"chemicalEquation": "6𝐶𝑂2(𝑔) + 6𝐻2𝑂(𝑙) → 𝑐ℎ𝑙𝑜𝑟𝑜𝑝ℎ𝑦𝑙𝑙 𝑎𝑛𝑑 𝑆𝑢𝑛𝑙𝑖𝑔ℎ𝑡 → 𝐶6𝐻12𝑂6(𝑠) + 6𝑂2(𝑔)",
		"redox": "Yes",
		"oxidized": "Oxygen in CO2 and in H20",
		"reduced": "Carbon in CO2",
		"incorrect1": "C6H12O6",
		"incorrect2": "O2"
	},
	
	"12" = {
		"chemicalEquation": "2𝐻𝐶𝑙𝑂(𝑎𝑞) + 𝐹𝑒(𝑠) + 2𝐻+(𝑎𝑞) → 𝐹𝑒2+(𝑎𝑞) + 𝐶𝑙2(𝑔) + 2𝐻2𝑂(𝑙)",
		"redox": "Yes",
		"oxidized": "Fe (s)",
		"reduced": "Chlorine in HClO",
		"incorrect1": "H+",
		"incorrect2": "Fe2+"
	},
	
	"13" = {
		"chemicalEquation": "2𝐻𝐶𝑙𝑂(𝑎𝑞) + 𝑃𝑏(𝑠) + 2𝐻+ → 𝑃𝑏2+(𝑎𝑞) + 𝐶𝑙2(𝑔) + 2𝐻2𝑂",
		"redox": "Yes",
		"oxidized": "Pb (s)",
		"reduced": "Chlorine in HClO",
		"incorrect1": "H+",
		"incorrect2": "Pb2+"
	},
	
	"14" = {
		"chemicalEquation": "2𝐹𝑒2+(𝑎𝑞) + 1/2𝑂2(𝑔) + 2𝐻+(𝑎𝑞) → 2𝐹𝑒3+(𝑎𝑞) + 𝐻2𝑂(𝑙)",
		"redox": "Yes",
		"oxidized": "Fe2+",
		"reduced": "O2",
		"incorrect1": "H+",
		"incorrect2": "Fe3+"
	},
	
	"15" = {
		"chemicalEquation": "𝐶𝑑𝐶𝑙2(𝑎𝑞) + 𝑁𝑎2𝑆(𝑎𝑞) → 𝐶𝑑𝑆(𝑠) + 2𝑁𝑎𝐶𝑙(𝑎𝑞)",
		"redox": "No",
		"reaction": "This is a precipitation reaction"
	},
	
	"16" = {
		"chemicalEquation": "2𝑍𝑛𝑆(𝑠) + 2𝐻𝐶𝑙(𝑎𝑞) → 𝑍𝑛𝐶𝑙2(𝑎𝑞) + 𝐻2𝑆(𝑔)",
		"redox": "No",
		"reaction": "This is an acid-base reaction"
	}
}


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
	$QuestionLabel.text = (questionSet["question"])
	$CompoundLabel.text = str(count) + ". " + questionSet[str(count)]["compound"]
	
	# Get the viewport's size to calculate spawn positions
	var viewport = get_viewport().get_visible_rect()
	var width = viewport.size.x
	var height = viewport.size.y

	# Define the y position for the answers
	var y_position = height * 0.1  # Place answers slightly above the bottom of the screen
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
	incorrectAnswerLabel1.text = (questionSet[str(count)]["incorrect1"])
	incorrectAnswerLabel2.text = (questionSet[str(count)]["incorrect2"])
	incorrectAnswerLabel3.text = (questionSet[str(count)]["incorrect3"])
	
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
		
func _on_start_button_pressed():
	$StartButton.hide()
	if GlobalVars.levelSelected == 1:
		questionSet = level1
	elif GlobalVars.levelSelected == 2:
		questionSet = level2
	## ADD LEVEL 3 HERE.
	updateLvl1QuestionsAnswers()

func _on_player_hit_answer():
	updateLvl1QuestionsAnswers()
