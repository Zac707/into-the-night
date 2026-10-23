extends Control


@export var score_label: Label
@export var star_label: Label

var current_licans: int
var current_stars: int


func _ready() -> void:
	current_licans = PlayerGlobals.collected_licans
	update_score(current_licans)
	current_stars = PlayerGlobals.collected_stars
	update_stars(current_stars)
	
	PlayerGlobals.lican_collected.connect(update_score)
	PlayerGlobals.star_collected.connect(update_stars)


func update_score(lican_number):
	current_licans += lican_number 
	var score_string = str(current_licans)
	var score_length = 4 - score_string.length()
	while score_length > 0:
		score_string = "0" + score_string
		score_length -= 1
	score_label.text = score_string


func update_stars(stars_number):
	current_stars += stars_number
	var star_string = str(current_stars)
	star_label.text = star_string + "/3"
