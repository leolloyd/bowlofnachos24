extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_hand()
	#print("overlap2",has_overlapping_bodies())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_hand():
	$Sprite2D.hide()

func _on_area_entered(area):
	#print("overlap",has_overlapping_bodies())
	if has_overlapping_bodies():
		#print("overlapping: ", get_overlapping_bodies())
		hide_hand()
	else:
		$Sprite2D.show()
		$Sprite2D/AnimationPlayer.play("vibrating")
