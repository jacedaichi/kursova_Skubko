extends State

class_name GroundState

const jump_speed = -430.0
var can_run = true
var facing_left = false

const jmp = preload("res://audio/jump.wav")
const footstep_sfx = preload("res://audio/click (1).wav")

@onready var audio_player := $"../../AudioStreamPlayer"
@onready var footstep_player := $"../../FootstepPlayer"
@onready var timer := $"../../Timer"
@export var AirState: State

func _play_music(music: AudioStream):
	audio_player.stream = music
	audio_player.play()

func state_input(event : InputEvent):
	
	var direction = Input.get_axis("left", "right")

	if direction > 0:
		facing_left = false
	elif direction < 0:
		facing_left = true
		
	if Input.is_action_pressed("run"):
		if direction > 0 and !facing_left: 
			playback.travel("run")
			footsteps(0.3)
		elif direction < 0 and facing_left:
			playback.travel("run_left")
			footsteps(0.3)
		elif facing_left:
			playback.travel("idle_left")
		else:
			playback.travel("idle")

	else:
		if direction > 0 and !facing_left:
			playback.travel("walk")
			footsteps(0.6)
		elif direction < 0 and facing_left:
			playback.travel("walk_left")
			footsteps(0.6)
		elif facing_left:
			playback.travel("idle_left")
		else:
			playback.travel("idle")
	
	
	if(event.is_action_pressed("jump")):
		jump()

func footsteps(value):
	if timer.time_left <= 0:
		footstep_player.pitch_scale = randf_range(0.8, 1.2)
		footstep_player.play()
		timer.start(value)



func jump():
	_play_music(jmp)
	character.velocity.y = jump_speed
	next_state = AirState
	if facing_left == false:
		facing_left = false
		playback.travel("jump")
	else:
		facing_left = true
		playback.travel("jump_left")

func check_if_left():
	return facing_left
