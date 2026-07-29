extends Node


#s Script where overarching stats and upgrades can be stored and which the other local script can draw from
var maximum_health: int = 3
var current_health: int

signal health_changed
