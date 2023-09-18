extends Node2D
class_name Weapon


signal weapon_out_of_ammo

# export variabbles
export var Bullet: PackedScene

#team variable
var team: int = -1

# ammo variables
var max_ammo: int = 10
var current_ammo: int = max_ammo

# node variables
onready var Muzzle = $BulletSpawn
onready var gun_direction = $GunDirection
onready var attack_cooldown = $AttackCooldown
onready var animation_player = $AnimationPlayer
onready var muzzle_flash = $MuzzleFlash


func _ready():
	muzzle_flash.hide()


func initialize(team: int):
	self.team = team


# call reload animation
func start_reload():
	animation_player.play("reload")


# cancel reload animation
func _stop_reload():
	current_ammo = max_ammo


# function for shooting
func shoot():
	if current_ammo != 0 and attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - Muzzle.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired",  bullet_instance, team, Muzzle.global_position, direction)
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
		current_ammo -= 1
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")
