extends Node

var levelSelected = 0
var score = 0
var health = 3
var isCorrect = false
var lossGame = false
var url = "https://redoxfrontend.onrender.com"
var loadQuestions = "/api/students/loadQuestions"
var update_score_url = "/api/students/updateScore"
var check_access_code_url = "/api/students/check-access-code"
var playerName
var currentLevel = 1
var playerId
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
