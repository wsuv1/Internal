extends KinematicBody2D
class_name Enemy

signal died


onready var health_stat = $Health
onready var ai = $AI
onready var weapon: Weapon = $Weapon
onready var team = $Team


export var speed = 100


func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)

# enemy rotation
func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

# enemy velocity
func velocity_toward(location: Vector2):
	return global_position.direction_to(location) * speed

func has_reached_position(location: Vector2):
	return global_position.distance_to(location) < 5

# assigning team
func get_team():
	return team.team


# health meter for enemy
func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		die()

func die():
	emit_signal("died")
	queue_free()
