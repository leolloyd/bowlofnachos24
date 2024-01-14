extends Area2D

signal hit

@export var speed = 600 # How fast player moves in pixels/sec
var screen_size

var level_accessories = [
	['GuacSticker'],
	['GuacSticker', 'CheeseSticker'],
	['GuacSticker', 'CheeseSticker', 'MeatballSticker']
]

var level_collisions = [
	'GuacCollisionPolygon',
	'CheeseCollisionPolygon',
	'MeatCollisionPolygon'
]

func reset_accessories():
	for name in ['GuacSticker', 'MeatballSticker', 'CheeseSticker']:
		get_node(name).hide()

func update_accessories(n_level:int):
	var accessories_names = level_accessories[n_level]
	for name in accessories_names:
		get_node(name).show()
		
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
		
	for area in get_overlapping_areas():
		print(area)

func is_overlapping_poly(player_poly, player_pos, current_level):
	var body = get_overlapping_bodies()[0]
	var body_poly = body.get_node(level_collisions[current_level]).polygon
	var body_pos = body.get_node(level_collisions[current_level]).global_position
	var player_poly_pos = []
	for point in player_poly:
		player_poly_pos.append(Vector2(
			point.x + player_pos.x,
			point.y + player_pos.y
		))
	var body_poly_pos = []
	for point in body_poly:
		body_poly_pos.append(Vector2(
			point.x + body_pos.x,
			point.y + body_pos.y
		))
	for idx in range(len(player_poly)):
		var is_within:bool = Geometry2D.is_point_in_polygon(
			player_poly_pos[idx],
			body_poly_pos)
		if is_within != true:
			return false
	return true
	
func start(pos):
	position = pos
	show()
