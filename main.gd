extends Node

@export var mob_scene: PackedScene
@export var hand_scene: PackedScene
var score
var MAX_CYCLES = 2
var current_cycles = 0
var current_level
var MAX_LEVELS = 3
var is_end_game = false
#var end_game = false

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

var success_audio = [
	'Cool',
	'Gnarly',
	'Nice',
	'Perfect',
	'Slick',
	'Wicked'
]

var level_music = [
	'Level1',
	'Level2',
	'Level3'
]

func _ready():
	new_game()
	#pass

func _process(delta):
	pass

func end_game():
	$BlitzTimer.stop()
	$StartTimer.stop()
	$Player.reset_accessories()
	#get_tree().call_group("mobs", "queue_free")
	#get_tree().call_group("hands", "queue_free")
	
func handle_good_ending():
	end_game()

func handle_semi_bad_ending():
	print("-->YOU DIED - semi")
	get_node(level_music[current_level]).stop()
	$DeathSound.play()
	end_game()
	$HUD.show_game_over()
	
func handle_very_bad_ending():
	end_game()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("hands", "queue_free")
	current_level = 0
	current_cycles = 0
	viewport_bounds = get_viewport()
	$Player.update_accessories(current_level)
	score = 0
	$ColorRect.color = bkg_colors[current_level]
	print("Score now: ", score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready!")
	$Level1.play()
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
		get_tree().call_group("mobs", "queue_free")
		get_tree().call_group("hands", "queue_free")
		get_node(level_music[current_level-1]).stop()
		get_node(level_music[current_level]).play()
		handle_progress_level()
		$Player.update_accessories(current_level)
		$ColorRect.color = bkg_colors[current_level]
		$Player.start($StartPosition.position)
		$StartTimer.start()
		$HUD.show_message("Get Ready")
		current_cycles = 0
		#new_cycle()
	else:
		handle_good_ending()

func _on_blitz_timer_timeout():
	# Controls blitz cycle
	$IncomingFist.play()
	await get_tree().create_timer(1.5).timeout
	if current_cycles < MAX_CYCLES - 1:
		print("Blitz")
		run_blitz(false)
		current_cycles += 1
	else:
		# Catch any left over blitz timers
		run_blitz(true)
		
func run_blitz(end_of_level:bool):
	spawn_hands()
	var player = $Player.get_node(level_collisions[current_level])	# player collision box
	var player_poly = player.polygon
	var player_pos = player.global_position
	#await get_tree().create_timer(0.5).timeout
		
	if $Player.has_overlapping_bodies():
		print($Player.get_overlapping_bodies())
		var is_overlapping_dorito: bool = $Player.is_overlapping_poly(current_level)
		print("Current collision poly for player: ", player.name)
		print(is_overlapping_dorito)
		if is_overlapping_dorito:
			score += 1
			print("Score is now: ", score)
			get_node(success_audio[randi_range(0,len(success_audio)-1)]).play()
			$Player.show_sparkles()
			await get_tree().create_timer(BLITZ_PERIOD_SECS).timeout
			if end_of_level:
				print("End of level")
				end_level()
			else:
				new_cycle()
		else:
			handle_semi_bad_ending()
	else:
		handle_semi_bad_ending()
			

func spawn_hands():
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
	
	await get_tree().create_timer(1).timeout
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
	
	$BlitzTimer.start()

func _on_start_timer_timeout():
	#new_cycle()
	print("---->New game: start timer")
	new_cycle()
	#spawn_hands()
