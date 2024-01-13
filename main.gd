extends Node

@export var mob_scene: PackedScene
var score
var MAX_CYCLES = 1
var current_cycles = 0
var current_level
var MAX_LEVELS = 3

# Spawn stuff
var max_spawn = 4
var viewport_bounds
var margin = 100.0

var bkg_colors = ['#8bcb60','#eca46a', '#8a5634']

var level_collisions = [
	'GuacCollisionPolygon',
	'CheeseCollisionPolygon',
	'MeatCollisionPolygon'
]

func _ready():
	#new_game()
	pass

func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
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
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	new_cycle()
	#$Music.play()
	
func end_level():
	$BlitzTimer.stop() 
	get_tree().call_group("mobs", "queue_free")
	#$NextLevel.show()
	next_level()
	
func next_level():
	current_level += 1
	if current_level < MAX_LEVELS:
		$Player.update_accessories(current_level)
		$ColorRect.color = bkg_colors[current_level]
		#score = 0
		$HUD.update_score(score)
		$Player.start($StartPosition.position)
		$StartTimer.start()
		$HUD.show_message("Get Ready")
		current_cycles = 0
		new_cycle()
	else:
		game_over()

func _on_blitz_timer_timeout():
	# Blitz animation - spawns random amount of enemies per cycle within viewport.
	print("Blitz")
	run_blitz()
	
	if current_cycles < MAX_CYCLES - 1:
		new_cycle()
		current_cycles += 1
	else:
		print("End of level")
		end_level()
		
func run_blitz():
	var player = $Player.get_node(level_collisions[current_level])
	var player_poly = player.polygon
	var player_pos = player.global_position
	#await get_tree().create_timer(0.5).timeout
		
	if $Player.has_overlapping_bodies():
		var is_overlapping_dorito: bool = $Player.is_overlapping_poly(player_poly,player_pos,current_level)
		print(is_overlapping_dorito)
		if is_overlapping_dorito:
			score += 1
			$HUD.update_score(score)
	
func new_cycle():
	get_tree().call_group("mobs", "queue_free")	# @todo: await here?
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

func _on_score_timer_timeout():
	pass

func _on_start_timer_timeout():
	$BlitzTimer.start()
	$ScoreTimer.start()
