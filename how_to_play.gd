extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_play_button_button_up():
	$"/root/SoundFx".stop_main_menu_music()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_play_button_button_down():
	pass # Replace with function body.
