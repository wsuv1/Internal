extends Node2D



onready var capturable_base_manager = $CapturableBaseManager
onready var ally_ai = $AllyMapAI
onready var enemy_ai = $EnemyMapAI
onready var player: Player = $Player
onready var bullet_manager = $BulletManager



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	
	var bases = capturable_base_manager.get_capturable_bases()
	ally_ai.initialize(bases)
	enemy_ai.initialize(bases)

