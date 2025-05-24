extends CharacterBody2D

var speed
var count_down = 2

func start(_position, _direction):
	position = _position
	rotation = _direction
	velocity = Vector2.RIGHT.rotated(rotation) * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	count_down -= delta
	if collision:
		queue_free()
	else:
		pass
		
	if count_down <= 0:
		queue_free()

			

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
