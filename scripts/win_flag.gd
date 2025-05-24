extends Area2D



func _process(delta):
	detect()
			

func detect():
	for area in get_overlapping_areas():
		var parent = area.get_parent()
		if parent.is_in_group("charachter"):
			get_tree().change_scene_to_file("res://scenes/win.tscn")
