extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_hand()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_hand():
	$Sprite2D.hide()

func _on_area_entered(area):
	if has_overlapping_bodies():
		#print("overlapping: ", get_overlapping_bodies())
		hide()
	else:
		$Sprite2D.show()
		$Sprite2D/AnimationPlayer.play("vibrating")
