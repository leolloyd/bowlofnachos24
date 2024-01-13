extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MobAnim.play('normal')
	# Generate a random rotation angle between 0 and 130 degrees
	var random_rotation = randf_range(0, 130)
	rotate(deg_to_rad(random_rotation))	# Apply the rotation to the MobAnim


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
