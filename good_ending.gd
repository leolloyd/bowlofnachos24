extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#$PlayButton.hide()
	$AnimationPlayer2.play('fade_to_normal')
	$Music.play()


func _on_animation_player_2_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://main_menu.tscn")
