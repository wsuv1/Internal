extends Node2D


signal state_changed(new_state)


# enemy states
enum State {
	PATROL,
	ENGAGE
}

onready var patrol_timer = $PatrolTimer

var current_state: int = -1 setget set_state
var character: KinematicBody2D = null
var target: KinematicBody2D = null
var weapon: Weapon = null
var team: int = -1

# patrol state variables
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := false
var character_velocity: Vector2 = Vector2.ZERO


func _ready():
	set_state(State.PATROL)

# when in enemy states:
# engage - attacks player
# patrol - stationary
func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				character.move_and_slide(character_velocity)
				character.rotate_toward(patrol_location)
				if character.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					character_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				character.rotate_toward(target.global_position)
				var angle_to_target = character.global_position.direction_to(target.global_position).angle()
				if abs(character.rotation - angle_to_target) < 0.1:
					weapon.shoot()
			else:
				print("In the engage state but no weapon/target.")
		_:
			print("Found a state for enemy that should not exist.")


# call child nodes
func initialize(character: KinematicBody2D, weapon: Weapon, team: int):
	self.character = character
	self.weapon = weapon
	self.team = team
	
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")


# setting state of enemy AI
func set_state(new_state: int):
	if new_state == current_state:
		return


# setting original state to patrol
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true


	current_state = new_state
	emit_signal("state_changed", current_state)


func handle_reload():
	weapon.start_reload()


# timing for enemy movement in patrol state
func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	character_velocity = character.velocity_toward(patrol_location)

# player enters radius
func _on_DetectionZone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body

# player exits radius
func _on_DetectionZone_body_exited(body):
	if target and body == target:
		set_state(State.PATROL)
		target = null
