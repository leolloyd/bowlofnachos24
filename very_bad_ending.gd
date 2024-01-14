extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.hide()
	await get_tree().create_timer(8).timeout
	$Button.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	$ButtonClick.play()


func _on_button_button_up():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_mouse_entered():
	$ButtonHover.play()
