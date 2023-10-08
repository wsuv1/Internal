extends Node2D

# export variables
export var health = 100 setget set_health


# set health boundaries 
func set_health(new_health: int):
	health = clamp(new_health, 0, 100)
