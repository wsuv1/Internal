extends Node2D

const Player = preload("res://Scenes/Player.tscn")

# node variables
onready var capturable_base_manager = $CapturableBaseManager
onready var ally_ai = $AllyMapAI
onready var enemy_ai = $EnemyMapAI
onready var bullet_manager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.initialize(bases, ally_respawns.get_children())
	enemy_ai.initialize(bases, enemy_respawns.get_children())
	
	spawn_player()


# spawn player into scene
func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_player(player)
