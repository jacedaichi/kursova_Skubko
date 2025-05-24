extends CharacterBody2D

var speed
var count_down = 2

func start(_position, _direction):
	
	position = _position
	rotation = _direction
	velocity = Vector2.RIGHT.rotated(rotation) * speed
func _ready():
	add_to_group("bullet_enemy")


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	count_down -= delta

	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("charachter"):  # ← Player must be in "player" group
			collider.death()  # Call the player's death method
		queue_free()
	elif count_down <= 0:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
