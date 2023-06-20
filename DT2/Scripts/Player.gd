extends KinematicBody2D


export var speed = 100
export var Bullet: PackedScene
onready var Muzzle = $BulletSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Player Movement
func _process(delta):
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
func _unhandled_input(event): 
	if event.is_action_released("shoot"):
		shoot()
		
# Gun bullet repetition
func shoot():
	var bullet_instance = Bullet.instance()
	add_child(bullet_instance)
	bullet_instance.global_position = Muzzle.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(target).normalized 
