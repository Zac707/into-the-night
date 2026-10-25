extends Node


#s Script where overarching stats and upgrades can be stored and which the other local script can draw from
var maximum_health: int = 5
var current_health: int
var collected_licans: int
var collected_stars: int

signal health_changed
signal lican_collected
signal star_collected
