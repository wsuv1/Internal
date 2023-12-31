extends Node2D

const Player = preload("res://Scenes/Player.tscn")
const GameOverScreen = preload("res://Scenes/GameOverScreen.tscn")
const PauseScreen = preload("res://Scenes/PauseScreen.tscn")

# node variables
onready var capturable_base_manager = $CapturableBaseManager
onready var ally_ai = $AllyMapAI
onready var enemy_ai = $EnemyMapAI
onready var bullet_manager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	
	pathfinding.create_navigation_map(ground)
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.initialize(bases, ally_respawns.get_children(), pathfinding)
	enemy_ai.initialize(bases, enemy_respawns.get_children(), pathfinding)
	capturable_base_manager.connect("player_captured_all_bases", self, "handle_player_win")
	capturable_base_manager.connect("player_lost_all_bases", self, "handle_player_lost")
	
	spawn_player()


# spawn player into scene
func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_player(player)


# handle player capturing all bases, player win
func handle_player_win():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true


# handle enemy capturing all bases, player lose
func handle_player_lost():
	var game_over = GameOverScreen.instance()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScreen.instance()
		add_child(pause_menu)
