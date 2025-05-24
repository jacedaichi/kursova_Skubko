extends CharacterBody2D

@onready var detection := $detect_range
@onready var ray := $Idle/RayCast2D
@onready var bullet_point := $Marker2D

var Bullet = preload("res://scenes/bullet_enemy.tscn")

var hurt = preload("res://audio/hitHurt (1).wav")
var attck = preload("res://audio/laserShoot (1).wav")

@onready var audio_player := $AudioStreamPlayer 
@onready var footstep_player := $"FootstepPlayer"
@onready var timer := $"Timer"

var target: Node2D
var playback

const SPEED = 100.0
@export var animation_tree : AnimationTree
const acc = 0.2
const decc = 0.1 

var gravity = 1200
var facing_left = false

@export var attack_cooldown_duration := 1.6
var attack_cooldown_timer := 0.0
@export var attacking = false
var detected = false
var in_range = false
var able = true


func _ready():
	target = get_tree().get_first_node_in_group("charachter")
	playback = animation_tree["parameters/playback"]
 
func footsteps():
	if timer.time_left <= 0:
		footstep_player.pitch_scale = randf_range(0.8, 1.2)
		footstep_player.play()
		timer.start(0.6)



func _play_music(music: AudioStream):
	audio_player.stream = music
	audio_player.play()



func _process(delta):
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta

	if in_range and attack_cooldown_timer <= 0 and able and !attacking:
		attack()
		

func death():
	_play_music(hurt)
	queue_free()

func _physics_process(delta):
	velocity.y += gravity * delta
	detect()
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider is TileMap:
			able = false
		else:
			able = true

		
	
	if facing_left:
		bullet_point.position.x = -24
	else:
		bullet_point.position.x = 24
	# Calculate direction and distance
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	velocity.x = 0

	if detected and !attacking:
		if distance > 150.0:
			in_range = false
			if direction.x < 0:
				footsteps()
				playback.travel("walk_left")
				facing_left = true
				velocity.x = -SPEED
			elif direction.x > 0:
				footsteps()
				playback.travel("walk")
				facing_left = false
				velocity.x = SPEED
		else:
			in_range = true
			velocity.x = 0  

			if direction.x < 0:
				playback.travel("idle_left")
				facing_left = true
			elif direction.x > 0:
				playback.travel("idle")
				facing_left = false

	
	var collision_count = move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("bullet_player"):
			death()
			
			
func detect():
	for area in detection.get_overlapping_areas():
		var parent = area.get_parent()
		if parent.is_in_group("charachter"):
			detected = true
func attack():
	attacking = true
	if facing_left:
		playback.travel("attack_left")
	else:
		playback.travel("attack")

	await get_tree().create_timer(0.4).timeout
	shoot()

	attacking = false
	attack_cooldown_timer = attack_cooldown_duration
	in_range = false



func shoot():
	var b = Bullet.instantiate()
	_play_music(attck)
	if facing_left:
		b.speed = -600
	else:
		b.speed = 600
	
	b.start(bullet_point.global_position, rotation)

	get_tree().root.add_child(b)
