extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/SoundFx".play_main_menu_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://how_to_play.tscn")
