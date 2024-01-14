extends Node

@export var mob_scene: PackedScene
@export var hand_scene: PackedScene
var score
var MAX_CYCLES = 3
var current_cycles = 0
var current_level
var MAX_LEVELS = 3

# Spawn stuff
var max_spawn = 4
var viewport_bounds
var margin = 100.0
var BLITZ_PERIOD_SECS = 3

var bkg_colors = ['#8bcb60','#eca46a', '#8a5634']

var level_collisions = [
	'GuacCollisionPolygon',
	'CheeseCollisionPolygon',
	'MeatCollisionPolygon'
]

func _ready():
	new_game()
	#pass

func _process(delta):
	pass

func game_over():
	$BlitzTimer.stop()
	$HUD.show_game_over()
	#$Music.stop()
	#$DeathSound.play()
	$Player.reset_accessories()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	current_level = 0
	viewport_bounds = get_viewport()
	$Player.update_accessories(current_level)
	score = 0
	$ColorRect.color = bkg_colors[current_level]
	print("Score now: ", score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready!")
	#$Music.play()
	
func end_level():
	$BlitzTimer.stop() 
	get_tree().call_group("mobs", "queue_free")
	#$NextLevel.show()
	next_level()
	
func handle_progress_level():
	if current_level == 1:
		$HUD.progress_guac_to_cheese()
	if current_level == 2:
		$HUD.progress_cheese_to_beef()
	
func next_level():
	current_level += 1
	if current_level < MAX_LEVELS:
		handle_progress_level()
		$Player.update_accessories(current_level)
		$ColorRect.color = bkg_colors[current_level]
		$Player.start($StartPosition.position)
		$StartTimer.start()
		$HUD.show_message("Get Ready")
		current_cycles = 0
		#new_cycle()
	else:
		game_over()

func _on_blitz_timer_timeout():
	# Controls blitz cycle
	print("Blitz")
	run_blitz()
	await get_tree().create_timer(BLITZ_PERIOD_SECS).timeout
	
	
	if current_cycles < MAX_CYCLES - 1:
		$BlitzTimer.start()
		new_cycle()
		current_cycles += 1
	else:
		print("End of level")
		end_level()
		
func run_blitz():
	spawn_hands()
	var player = $Player.get_node(level_collisions[current_level])	# player collision box
	var player_poly = player.polygon
	var player_pos = player.global_position
	#await get_tree().create_timer(0.5).timeout
		
	if $Player.has_overlapping_bodies():
		var is_overlapping_dorito: bool = $Player.is_overlapping_poly(current_level)
		print("Current collision poly for player: ", player.name)
		print(is_overlapping_dorito)
		if is_overlapping_dorito:
			score += 1
			print("Score is now: ", score)
			$Player.show_sparkles()
		else:
			print("You died!")
			

func spawn_hands():
	get_tree().call_group("hands", "queue_free")
	print("Spawning hands")
	var x_spawn = 6
	var y_spawn = 4
	var hand_margin = 150
	var pos_x = hand_margin
	var pos_y = hand_margin
	var counter = 1
	for i in range(1,(x_spawn * y_spawn)+1):
		var hand = hand_scene.instantiate()
		var spawn_position = Vector2(pos_x, pos_y)
		hand.position = spawn_position
		
		# Logic to prevent overlap
		add_child.call_deferred(hand)
		pos_x += ((viewport_bounds.size.x - hand_margin)/x_spawn)
		if counter == x_spawn:
			pos_x = hand_margin
			pos_y += ((viewport_bounds.size.y - hand_margin)/y_spawn)
			counter = 0
		counter += 1

func new_cycle():
	get_tree().call_group("mobs", "queue_free")	# @todo: await here?
	get_tree().call_group("hands", "queue_free")
	#spawn_holes()
	
	print("Spawning...")
	var n_spawn = randi_range(1,max_spawn)
	for i in range(n_spawn):
		var mob = mob_scene.instantiate()
		var spawn_position=Vector2(
			randf_range(viewport_bounds.position.x + margin, viewport_bounds.size.x - margin),
			randf_range(viewport_bounds.position.y + margin, viewport_bounds.size.y - margin)
		)
		mob.position = spawn_position
		mob.update_accessories(current_level)
		add_child.call_deferred(mob)

func _on_start_timer_timeout():
	#new_cycle()
	$BlitzTimer.start()
	new_cycle()
	#spawn_hands()
