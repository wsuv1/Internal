extends Node2D

onready var bullet_manager = $BulletManager
onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("player_fired_bullet",bullet_manager,"handle_bullet_spawned")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
