extends TextureButton



func _on_mouse_entered():
	$ButtonHover.play()


func _on_button_down():
	$ButtonClick.play()
