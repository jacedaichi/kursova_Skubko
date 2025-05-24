extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAudioStreamPlayer.play_lvl_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_exit_pressed():
	get_tree().quit()
