extends KinematicBody2D

onready var health_stat = $Health
onready var ai = $AI
onready var weapon = $Weapon


export var speed = 100


func _ready():
	ai.initialize(self, weapon)

# enemy rotation
func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)

# enemy velocity
func velocity_toward(location: Vector2):
	return global_position.direction_to(location) * speed


# health meter for enemy
func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
