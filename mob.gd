extends RigidBody2D

var mob_anim = ['guac', 'cheese', 'meat']
var collision_polys = ['GuacCollisionPolyMob', 'CheeseCollisionPolyMob', 'MeatCollisionPolyMob']

# Called when the node enters the scene tree for the first time.
func _ready():
	#$MobAnim.play('guac')
	# Generate a random rotation angle between 0 and 130 degrees
	var random_rotation = randf_range(0, 360)
	rotate(deg_to_rad(random_rotation))	# Apply the rotation to the MobAnim
	#for poly in collision_polys:
		#get_node(poly).hide()

func update_accessories(current_level):
	$MobAnim.play(mob_anim[current_level])
	for poly in collision_polys:
		get_node(poly).hide()
	get_node(collision_polys[current_level]).show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

