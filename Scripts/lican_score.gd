extends Control


@export var score_label: Label

var current_licans: int


func _ready() -> void:
	current_licans = PlayerGlobals.collected_licans
	update_score(current_licans)
	
	PlayerGlobals.lican_collected.connect(update_score)


func update_score(lican_number):
	current_licans += lican_number 
	var score_string = str(current_licans)
	var score_length = 4 - score_string.length()
	while score_length > 0:
		score_string = "0" + score_string
		score_length -= 1
	score_label.text = score_string
