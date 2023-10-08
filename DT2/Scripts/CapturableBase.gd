extends Area2D
class_name CapturableBase

signal base_captured(new_team)

# colour variables for base
export (Color) var neutral_color = Color(1, 1, 1)
export (Color) var player_color = Color(0.498039, 0.941176, 0.898039)
export (Color) var enemy_color = Color(0.913725, 0.223529, 0.223529)

# team variables
var player_unit_count: int = 0
var enemy_unit_count: int = 0
var team_to_capture: int = Team.TeamName.NEUTRAL

# node variables
onready var team = $Team
onready var capture_timer = $CaptureTimer
onready var sprite = $Sprite


# adding up allied and enemy units
func _on_CapturableBase_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
			
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
			
		check_whether_base_can_be_captured()


# subtracting allied and enemy units
func _on_CapturableBase_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
			
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1
		
		check_whether_base_can_be_captured()


# checking team that has majority in base 'zone' to capture
func check_whether_base_can_be_captured():
	var majority_team = get_team_with_majority()
	
	if majority_team == Team.TeamName.NEUTRAL:
		print("Team evened out, stopping capture timer")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	elif majority_team == team.team:
		print("Owning team regained majority, stopping capture timer")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		print("New team has majority, starting capture timer")
		team_to_capture = majority_team
		capture_timer.start()


# calculating total allied or enemy units in majority
func get_team_with_majority():
	if enemy_unit_count == player_unit_count:
		return Team.TeamName.NEUTRAL
	elif enemy_unit_count > player_unit_count:
		return Team.TeamName.ENEMY
	else:
		return Team.TeamName.PLAYER


# setting colour for team in majority
func set_team(new_team: int):
	team.team = new_team
	emit_signal("base_captured", new_team)
	match new_team: 
		Team.TeamName.NEUTRAL:
			sprite.modulate = neutral_color
			return
		Team.TeamName.PLAYER:
			sprite.modulate = player_color
			return
		Team.TeamName.ENEMY:
			sprite.modulate = enemy_color
			return


# when timer ends, set back to neutral or team in majority
func _on_CaptureTimer_timeout():
	set_team(team_to_capture)
