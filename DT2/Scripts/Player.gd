extends KinematicBody2D
class_name Player


signal player_health_changed(new_health)
signal died

# export variables
export var speed = 100

# node variables
onready var team = $Team
onready var weapon: Weapon = $Weapon
onready var health_stat = $Health
onready var camera_transform = $CameraTransform


# stop friendly fire
func _ready():
	weapon.initialize(team.team)


# Player Movement
func _physics_process(delta):
	var movement_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		movement_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		movement_direction.y = 1
	if Input.is_action_pressed("ui_left"):
		movement_direction.x = -1
	if Input.is_action_pressed("ui_right"):
		movement_direction.x = 1
	
	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	look_at(get_global_mouse_position())


# Calling shoot function
func _unhandled_input(event: InputEvent): 
	if event.is_action_released("shoot"):
		weapon.shoot()
	elif event.is_action_released("reload"):
		weapon.start_reload()


# set camera
func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path


# reloading weapon
func reload():
	weapon.start_reload()


# get team
func get_team():
	return team.team


# health counter
func handle_hit():
	health_stat.health -= 20
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		die()


# handle player death
func die():
	emit_signal("died")
	queue_free()
