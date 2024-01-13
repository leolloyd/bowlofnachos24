extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	#new_game()
	pass

func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	#$Music.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	#$Music.play()

func _on_mob_timer_timeout():
	# Blitz animation - spawns random amount of enemies per cycle within viewport.
	var max_spawn = 4
	var n_spawn = randi_range(1,max_spawn)
	for i in range(n_spawn):
		var mob = mob_scene.instantiate()
		var viewport_bounds = get_viewport()
		var margin = 50.0
		var spawn_position=Vector2(
			randf_range(viewport_bounds.position.x + margin, viewport_bounds.size.x - margin),
			randf_range(viewport_bounds.position.y + margin, viewport_bounds.size.y - margin)
		)
		add_child(mob)
		mob.position = spawn_position

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
