extends Node2D


signal state_changed(new_state)


# enemy states
enum State {
	PATROL,
	ENGAGE
}

onready var player_detection_zone = $PlayerDetectionZone

var current_state: int = State.PATROL setget set_state
var character = null
var player: Player = null
var weapon: Weapon = null

# when in enemy states:
# engage - attacks player
# patrol - stationary
func _process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				character.rotation = character.global_position.direction_to(player.global_position).angle()
				weapon.shoot()
			else:
				print("In the engage state but no weapon/player")
		_:
			print("Error: found a state for our enemy that should not exist.")


func initialize(character, weapon: Weapon):
	
	self.character = character
	self.weapon = weapon


# setting state of enemy AI
func set_state(new_state: int):
	if new_state == current_state:
		return
	
	current_state = new_state
	emit_signal("state_changed", current_state)




func _on_PlayerDetectionZone_body_entered(body: Node):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
