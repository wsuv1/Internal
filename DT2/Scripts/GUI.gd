extends CanvasLayer


# node variables
onready var health_bar = $MarginContainer/Rows/BottomRow/HealthSection/HealthBar
onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo

var player: Player

# main script calls func when player spawns, GUI will update stats
func set_player(player: Player):
	self.player = player
	
	set_new_health_value(player.health_stat.health)
	set_current_ammo(player.weapon.current_ammo)
	set_max_ammo(player.weapon.max_ammo)
	
	player.connect("player_health_changed", self, "set_new_health_value")
	player.weapon.connect("weapon_fired", self, "set_current_ammo")


# setting health value
func set_new_health_value(new_health: int):
	health_bar.value = new_health


# setting current ammo value
func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)


# setting max ammo value
func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)

