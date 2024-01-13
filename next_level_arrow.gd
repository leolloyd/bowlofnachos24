extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	print("Entered!")
	#pass # Replace with function body.


func _on_visibility_changed():
	if is_visible_in_tree():
		print("visible!")
		$Sprite.play("default")
