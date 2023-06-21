extends KinematicBody2D
class_name Player

signal player_fired_bullet(bullet, position, direction)

export var speed = 100
export var Bullet: PackedScene

# linking variables
onready var Muzzle = $BulletSpawn
onready var gun_direction = $GunDirection
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer

onready var health_stat = $Health


func _ready():
	pass 

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
		shoot()


# Gun bullet repetition
func shoot():
	if attack_cooldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - Muzzle.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, Muzzle.global_position, direction)
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
	
# health counter
func handle_hit():
	health_stat.health -= 20
	print("player hit!", health_stat.health)
