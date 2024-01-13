extends Node

@export var mob_scene: PackedScene
var score
var max_cycles = 3
var current_cycles = 0

# Spawn stuff
var max_spawn = 4
var viewport_bounds
var margin = 50.0

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
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	viewport_bounds = get_viewport()
	
	score = 0
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	new_cycle()
	#$Music.play()
	
func end_level():
	$BlitzTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$HUD.get_node("NextLevelLabel").text = "Next level!"

func _on_blitz_timer_timeout():
	# Blitz animation - spawns random amount of enemies per cycle within viewport.
	print("Blitz")
	if current_cycles < max_cycles:
		run_blitz()
		current_cycles += 1
	else:
		print("End of level")
		end_level()
		
		
func run_blitz():
	var player = $Player.get_node('CollisionPolygon2D')
	var player_poly = player.polygon
	var player_pos = player.global_position
	#await get_tree().create_timer(0.5).timeoutccc
		
	if $Player.has_overlapping_bodies():
		var is_overlapping_dorito: bool = $Player.is_overlapping_poly(player_poly,player_pos)
		print(is_overlapping_dorito)
		if is_overlapping_dorito:
			score += 1
			$HUD.update_score(score)
	
	new_cycle()
	
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
		add_child.call_deferred(mob)
		mob.position = spawn_position
	
func spawn_holes():
	print("Spawning...")
	var max_spawn = 4
	var n_spawn = randi_range(1,max_spawn)
	var mob = mob_scene.instantiate()
	var viewport_bounds = get_viewport()
	var margin = 50.0
	for i in range(n_spawn):
		var spawn_position=Vector2(
			randf_range(viewport_bounds.position.x + margin, viewport_bounds.size.x - margin),
			randf_range(viewport_bounds.position.y + margin, viewport_bounds.size.y - margin)
		)
		add_child(mob)
		mob.position = spawn_position

func _on_score_timer_timeout():
	pass
	#score += 1
	#$HUD.update_score(score)

func _on_start_timer_timeout():
	$BlitzTimer.start()
	$ScoreTimer.start()
