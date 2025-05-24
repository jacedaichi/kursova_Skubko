extends CharacterBody2D

const RUN_SPEED = 250.0
const SPEED = 150.0
const acc = 0.2
const decc = 0.1 

const hit = preload("res://audio/hitHurt.wav")
const attck = preload("res://audio/laserShoot (2).wav")

@onready var audio_player := $AudioStreamPlayer 
@onready var move_state_machine := $move_state_machine
@onready var ground_state := $move_state_machine/ground
@onready var player := $player
@onready var hand := $hand
@onready var gun := $gun
@onready var coll := $CollisionShape2D
@onready var bullet_point := $gun/Marker2D

var Bullet = preload("res://scenes/bullet_player.tscn")

var can_run = false
var gravity = 1200
var facing_left = false

@export var attack_cooldown_duration := 0.5
var attack_cooldown_timer := 0.0
@export var attacking = false

func _process(delta):
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta
	
	if Input.is_action_just_pressed("attack") and attack_cooldown_timer > 0 and !move_state_machine.check_if_can_attack():
		pass
	elif Input.is_action_just_pressed("attack") and attack_cooldown_timer <= 0 and move_state_machine.check_if_can_attack():
		attack()

	
func _play_music(music: AudioStream):
	audio_player.stream = music
	audio_player.play()

func _physics_process(delta):
	velocity.y += gravity * delta
	var direction = Input.get_axis("left", "right")

	if move_state_machine.check_if_can_move():
		
		if Input.is_action_pressed("run") and can_run:
			if direction:
				velocity.x = lerp(velocity.x, RUN_SPEED * direction, acc)
			else:
				velocity.x = lerp(velocity.x, 0.0, decc)
		else:
			if direction and can_run:
				velocity.x = lerp(velocity.x, SPEED * direction, acc)
			elif !can_run and ground_state.check_if_left():
				if direction > 0:
					velocity.x = lerp(velocity.x, 0.0, decc)
				else:
					velocity.x = lerp(velocity.x, SPEED * direction, acc)
			elif !can_run and !ground_state.check_if_left():
				if direction < 0:
					velocity.x = lerp(velocity.x, 0.0, decc)
				else:
					velocity.x = lerp(velocity.x, SPEED * direction, acc)
			else:
				velocity.x = lerp(velocity.x, 0.0, decc)

	if(is_on_floor()):
		can_run = true
	else:
		can_run = false
		
	var collision_count = move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("bullet_enemy"):
			death()

func death():
	_play_music(hit)
	get_tree().change_scene_to_file("res://scenes/restart.tscn")

func attack():
	var b = Bullet.instantiate()
	_play_music(attck)
	if ground_state.check_if_left():
		b.speed = -700
	else:
		b.speed = 700
	attack_cooldown_timer = attack_cooldown_duration
	b.start(bullet_point.global_position, rotation)

	get_tree().root.add_child(b)
