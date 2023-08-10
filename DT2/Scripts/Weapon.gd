extends Node2D
class_name Weapon



export var Bullet: PackedScene

var team: int = -1

# linking weapon variables
onready var Muzzle = $BulletSpawn
onready var gun_direction = $GunDirection
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer

func initialize(team: int):
	self.team = team



# function for shooting
func shoot():
	if attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - Muzzle.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired",  bullet_instance, team, Muzzle.global_position, direction)
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
