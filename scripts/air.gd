extends State

class_name AirState
@export var GroundState: State

const footstep_sfx = preload("res://audio/click (1).wav")

@onready var footstep_player := $"../../FootstepPlayer"
@onready var timer := $"../../Timer"

func footsteps(value):
	if timer.time_left <= 0:
		footstep_player.pitch_scale = randf_range(0.8, 1.2)
		footstep_player.play()
		timer.start(value)

func state_process(delta):
	var direction = Input.get_axis("left", "right")
	if(character.is_on_floor()):
		if !GroundState.check_if_left() and direction == 0:
			playback.travel("idle")
		elif GroundState.check_if_left() and direction == 0:
			playback.travel("idle_left")
		elif direction > 0:
			if Input.is_action_pressed("run"):
				footsteps(0.3)
				playback.travel("run")
			else:
				footsteps(0.6)
				playback.travel("walk")
				
		elif direction < 0:
			if Input.is_action_pressed("run"):
				footsteps(0.3)
				playback.travel("run_left")
			else:
				footsteps(0.6)
				playback.travel("walk_left")
			
		
		next_state = GroundState
		


