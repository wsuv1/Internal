extends Area2D
class_name Bullet

export var speed = 10

onready var kill_timer = $KillTimer


var direction := Vector2.ZERO
var team: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	kill_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# velocity of bullet
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity

# sets angle of gun/bullet
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


# times out bullet after being shot
func _on_KillTimer_timeout():
	queue_free()

# if bullet hits enemy
func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team:
			body.handle_hit()
		queue_free()
