extends Node2D
class_name AI

signal state_changed(new_state)

# enemy states
enum State {
	PATROL,
	ENGAGE,
	ADVANCE
}


# export variables
export var should_draw_path_line := false

# node variables
onready var patrol_timer = $PatrolTimer
onready var path_line = $PathLine

# player + enemy variables
var current_state: int = -1 setget set_state
var character: Enemy = null
var target: KinematicBody2D = null
var weapon: Weapon = null
var team: int = -1

# patrol state variables
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := false
var character_velocity: Vector2 = Vector2.ZERO

# base variable
var next_base: Vector2 =  Vector2.ZERO

# pathfinding variable
var pathfinding: Pathfinding

# automatically set normal state to patrol
func _ready():
	set_state(State.PATROL)
	path_line.visible = should_draw_path_line


# when in enemy states:
# engage - attacks player when player body has enterted detection zone
# patrol - stationary, patrols an area until a body enters detection zone
func _physics_process(delta):
	path_line.global_rotation = 0
	
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var path = pathfinding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					character_velocity = character.velocity_toward(path[1])
					character.rotate_toward(path[1])
					character.move_and_slide(character_velocity)
					set_path_line(path)
				else: 
					patrol_location_reached = true
					character_velocity = Vector2.ZERO
					patrol_timer.start()
					path_line.clear_points()
		State.ENGAGE:
			if target != null and weapon != null:
				character.rotate_toward(target.global_position)
				var angle_to_target = character.global_position.direction_to(target.global_position).angle()
				if abs(character.rotation - angle_to_target) < 0.1:
					weapon.shoot()
			else:
				print("In the engage state but no weapon/target.")
		State.ADVANCE:
			var path = pathfinding.get_new_path(global_position, next_base)
			if path.size() > 1:
				character_velocity = character.velocity_toward(path[1])
				character.rotate_toward(path[1])
				character.move_and_slide(character_velocity)
				set_path_line(path)
			else:
				set_state(State.PATROL)
				path_line.clear_points()
		_:
			print("Found a state for enemy that should not exist.")


# reference current nodes - handle weapon reload and ammo 
func initialize(character: KinematicBody2D, weapon: Weapon, team: int):
	self.character = character
	self.weapon = weapon
	self.team = team
	
	weapon.connect("weapon_out_of_ammo", self, "handle_reload")


# set line2D to see pathfinding points of AI
func set_path_line(points: Array):
	if not should_draw_path_line:
		return

	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		local_points.append(point - global_position)
	
	path_line.points = local_points


# setting state of enemy AI
func set_state(new_state: int):
	if new_state == current_state:
		return

# setting original state to patrol
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true

	elif new_state == State.ADVANCE:
		if character.has_reached_position(next_base):
			set_state(State.PATROL)


	current_state = new_state
	emit_signal("state_changed", current_state)


# once R is pressed, weapon reload function is triggered
func handle_reload():
	weapon.start_reload()


# timing for enemy movement in patrol state
func _on_PatrolTimer_timeout():
	var patrol_range = 75
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false


# player enters radius
func _on_DetectionZone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


# player exits radius
func _on_DetectionZone_body_exited(body):
	if target and body == target:
		set_state(State.ADVANCE)
		target = null
