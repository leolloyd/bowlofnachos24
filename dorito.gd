extends Area2D

signal hit

@export var speed = 400 # How fast player moves in pixels/sec
var screen_size	#undefined

# on mount
func _ready():
	screen_size = get_viewport_rect().size
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
		
	var player_poly = $CollisionPolygon2D.polygon
	var player_pos = $CollisionPolygon2D.global_position
	await get_tree().create_timer(0.5).timeout
		
	if has_overlapping_bodies():
		print(is_overlapping_poly(player_poly,player_pos))

func is_overlapping_poly(player_poly, player_pos):
	var body = get_overlapping_bodies()[0]
	var body_poly = body.get_node("CollisionPolygon2D").polygon
	var body_pos = body.get_node("CollisionPolygon2D").global_position
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
			#print("Index ", idx, "is within: ", is_within, "given: ", body_poly, "and ", player_poly)
		#for idx in range(len(player_poly)):
			
		
	
	#if has_overlapping_bodies():
		##var mobs = get_tree().get_nodes_in_group("mobs")
		#var player_poly = $CollisionPolygon2D.polygon
		#var player_pos = $CollisionPolygon2D.global_position
		#await get_tree().create_timer(0.5).timeout
		#print(player_poly[0], player_pos.y)
		#if player_poly[0].y + player_pos.y > 500:
			#print("dripped")
		#for point in player_poly:
			#var point_pos = point + player_pos
			#if 
			
		#var mobs = get_tree().get_nodes_in_group("mobs")
		#await get_tree().create_timer(0.5).timeout
		#for mob in mobs:
			#if is_polygon_enclosed(
				#$CollisionPolygon2D.polygon, 
				#mob.get_node("CollisionPolygon2D").polygon,
				#$CollisionPolygon2D.global_position,
				#mob.get_node("CollisionPolygon2D").global_position
				#):
				#print("Fully enclosed")
			#else:
				#print("NOT enclosed")
				
# Function to check if one polygon is completely enclosed in another
func is_polygon_enclosed(inner_polygon: PackedVector2Array, outer_polygon: PackedVector2Array, inner_position, outer_position) -> bool:
	var outer_polygon_with_position = []
	for outer_point in outer_polygon:
		outer_polygon_with_position.append(outer_point + outer_position)
	print(inner_position, outer_polygon_with_position, inner_polygon, outer_polygon)
	for point in inner_polygon:
		var point_with_position = point + inner_position
		print("Point with position:", point_with_position)
		var point_is_inside:bool = Geometry2D.is_point_in_polygon(point_with_position, outer_polygon_with_position)
		print(point_is_inside)
	return true
	#print("-")
	#for point in inner_points:
		#var point_is_inside: bool = Geometry2D.is_point_in_polygon(point, outer_polygon.polygon)
		#print(point_is_inside)
		#if not point_is_inside:
			#return false
			#
	#return true


func _on_body_entered(body):
	print("body entered by mob")
	percent_overlapping()
	#hide()
	#hit.emit()
	#$CollisionShape2D.set_deferred("disabled", true)	# disable collision object so hit signal only triggers once
	
func start(pos):
	position = pos
	show()
	#$CollisionShape2D.disabled = false
	
func percent_overlapping():
	pass
	#var mobs = get_tree().get_nodes_in_group("mobs")
	#var player_rect = $CollisionShape2D.shape.get_rect()
	#print(player_rect)
	#for mob in mobs:
		#var mob_rect = mob.get_node("CollisionShape2D").shape.get_rect()
		#if player_rect.intersects(mob_rect):
			#print("intersect")
		#print(player_rect.encloses(mob_rect))
		#var intersection_area = player_rect.clip(mob_rect).area()
		#print(intersection_area)
	#print(get_overlapping_areas())
	
	# Get references to the Player and the list of nodes in the "mobs" group
	
	#var mobs = get_tree().get_nodes_in_group("mobs")
	#for mob in mobs:
		#var player_rect = $CollisionShape2D.area()
		#print(player_rect.area())
		#var mob_rect = mob.get_node("CollisionShape2D").rect_global
		#print(mob_rect.area())
	
	# Iterate through each shadow in mobs
	#var player_rect = player.get_node("PlayerCollisionShape").rect_global
	#var mob_rect = mob.get_node("MobCollisionShape").rect_global
#
	## Check for area overlap
	#if player_rect.intersects(mob_rect):
		## Calculate the percentage overlap
		#var intersection_area = player_rect.clip(mob_rect).area()
		#var player_area = player_rect.area()
		#var mob_area = mob_rect.area()
		#var overlap_percentage = (intersection_area / min(player_area, mob_area)) * 100
		#return overlap_percentage
	#else:
		#return 0.0
	#for mob in mobs:
		#print(mob.name)
		#if $Dorito.intersects(mob):
			#var intersection_area = $Dorito.clip(mob).area()
			#var dorito_area = $Dorito.area()
			#var mob_area = mob.area()
			#var overlap_pct = (intersection_area / min(dorito_area, mob_area)) * 100
			#print("Overlap is", str(overlap_pct))

