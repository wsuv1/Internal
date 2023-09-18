extends Node2D
class_name Team

# team names
enum TeamName {
	NEUTRAL,
	PLAYER,
	ENEMY
}

# export variable
export (TeamName) var team = TeamName.NEUTRAL

