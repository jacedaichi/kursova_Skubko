extends AudioStreamPlayer

const music = preload("res://audio/game_music.mp3")

func _play_music(music: AudioStream, volume = -15.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_lvl_music():
	_play_music(music)
