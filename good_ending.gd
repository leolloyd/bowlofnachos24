extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#$PlayButton.hide()
	$AnimationPlayer2.play('fade_to_normal')
	$Music.play()
	var viewport = get_viewport()
	$Player.position = Vector2(
		viewport.size.x / 2,
		viewport.size.y / 2
	)
	await get_tree().create_timer(5).timeout
	$Player.get_node("MiddleAge").show()
	await get_tree().create_timer(4.2).timeout
	$Player.get_node("MiddleAge").hide()
	$Player.get_node("OldAge").show()


func _on_animation_player_2_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://main_menu.tscn")
