extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	show_hand() # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_hand():
	$Sprite2D.hide()
	$Sprite2D/AnimationPlayer.stop("vibrating")
	
func show_hand():
	$Sprite2D.show()
	$Sprite2D/AnimationPlayer.play("vibrating")


func _on_area_entered(area):
	if has_overlapping_bodies():
		hide()
