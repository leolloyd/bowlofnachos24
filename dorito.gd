extends Area2D

signal hit

@export var speed = 600 # How fast player moves in pixels/sec
var screen_size

var level_accessories = [
	['GuacSticker'],
	['GuacSticker', 'CheeseSticker'],
	['GuacSticker', 'CheeseSticker', 'MeatballSticker']
]

var mob_collision_polys = [
	'GuacCollisionPolyMob',
	'CheeseCollisionPolyMob',
	'MeatCollisionPolyMob'
]

var player_collision_polys = [
	'GuacCollisionPolygon',
	'CheeseCollisionPolygon',
	'MeatCollisionPolygon'
]

func reset_accessories():
	for name in ['GuacSticker', 'MeatballSticker', 'CheeseSticker']:
		get_node(name).hide()

func update_accessories(n_level:int):
	# Update accessories and collision poly
	var accessories_names = level_accessories[n_level]
	for name in accessories_names:
		get_node(name).show()
	# Hide all polys
	for poly in player_collision_polys:
		get_node(poly).hide()
	get_node(player_collision_polys[n_level]).show()
		
		
func show_sparkles():
	$Sparkles.show()
	await get_tree().create_timer(1).timeout
	$Sparkles.hide()

# on mount
func _ready():
	screen_size = get_viewport_rect().size
	$GuacSticker.hide()
	$MeatballSticker.hide()
	$CheeseSticker.hide()
	$Sparkles.hide()
	#hide()

# update
func _process(delta):
	var velocity = Vector2.ZERO # player's current movement vector
	var rotation_speed = 200.0
	if Input.is_action_pressed("d"):
		velocity.x += 1
	if Input.is_action_pressed("a"):
		velocity.x -= 1
	if Input.is_action_pressed("w"):
		velocity.y -= 1
	if Input.is_action_pressed("s"):
		velocity.y += 1
	if Input.is_action_pressed("left_click"):
		rotate(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("right_click"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Dorito.play()
	else:
		$Dorito.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Select correct animation instead of  the just default one
	if velocity.x != 0 or velocity.y != 0:
		if velocity.x != 0:
			$Dorito.animation = 'left'
			$Dorito.flip_v = false
			$Dorito.flip_h = velocity.x > 0
		if velocity.y != 0:
			if velocity.y > 0:
				$Dorito.animation = 'down'
			else:
				$Dorito.animation = 'up'
	else:
		$Dorito.animation = 'normal'

func is_overlapping_poly(current_level):
	var player = get_node(player_collision_polys[current_level])	# player collision box
	var player_poly = player.polygon
	var player_pos = player.global_position
	var body = get_overlapping_bodies()[0].get_node(mob_collision_polys[current_level])
	var body_poly = body.polygon
	var body_pos = body.global_position
	var body_rotation = body.global_rotation  # Added rotation
	var player_rotation = player.global_rotation  # Added rotation
	#print("For mob: ", body.name, "For player: ", player.name)
	#print("BODY: ", body_poly, "\nPLAYER: ", player_poly)
	#print("body rot: ", body_rotation, "player_rot: ", player_rotation)
	var player_scale = 0.5	# Change if you change the player scale
	var body_scale = 0.5	# Change if you change the mob scale ("body" = "mob")
	var player_poly_pos = []
	for point in player_poly:
		# Rotate, scale, and add position to polygon
		var rotated_point = point.rotated(player_rotation)
		var scaled_point = rotated_point * player_scale
		player_poly_pos.append(Vector2(
			scaled_point.x + player_pos.x,
			scaled_point.y + player_pos.y
		))
	
	var body_poly_pos = []
	for point in body_poly:
		# Rotate, scale, and add position to polygon
		var rotated_point = point.rotated(body_rotation)
		var scaled_point = rotated_point * body_scale
		body_poly_pos.append(Vector2(
			scaled_point.x + body_pos.x,
			scaled_point.y + body_pos.y
		))
	var is_within_flag = true
	for idx in range(len(player_poly)):
		var is_within:bool = Geometry2D.is_point_in_polygon(
			player_poly_pos[idx],
			body_poly_pos)
		print("For point ", idx, "is within is ", is_within)
		if is_within != true:
			is_within_flag = false
	return is_within_flag
	
func start(pos):
	position = pos
	show()
