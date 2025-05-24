extends Control

@onready var slider = $MarginContainer/VBoxContainer/HSlider
@onready var slider1 = $MarginContainer/VBoxContainer/HSlider2
@onready var slider2 = $MarginContainer/VBoxContainer/HSlider3
@onready var text_master = $MarginContainer/VBoxContainer/Label
@onready var text_music = $MarginContainer/VBoxContainer/Label2
@onready var text_sfx = $MarginContainer/VBoxContainer/Label3

const MIN_DB = -30
const MAX_DB = 10
const STEPS = 10


func _ready():
	slider.value = AudioServer.get_bus_volume_db(0)
	slider1.value = AudioServer.get_bus_volume_db(1)
	slider2.value = AudioServer.get_bus_volume_db(2)
	update_master_volume_label(slider.value)
	update_music_volume_label(slider1.value)
	update_sfx_volume_label(slider2.value)

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	update_master_volume_label(value)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")



func _on_h_slider_2_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	update_music_volume_label(value)

func _on_h_slider_3_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	update_sfx_volume_label(value)

func update_master_volume_label(db_value):
	var step = clamp(int(((db_value - MIN_DB) / (MAX_DB - MIN_DB)) * STEPS) + 1, 1, STEPS)
	text_master.text = "Master Volume: %d" % step

func update_music_volume_label(db_value):
	var step = clamp(int(((db_value - MIN_DB) / (MAX_DB - MIN_DB)) * STEPS) + 1, 1, STEPS)
	text_music.text = "Music Volume: %d" % step
	
func update_sfx_volume_label(db_value):
	var step = clamp(int(((db_value - MIN_DB) / (MAX_DB - MIN_DB)) * STEPS) + 1, 1, STEPS)
	text_sfx.text = "SFX Volume: %d" % step


