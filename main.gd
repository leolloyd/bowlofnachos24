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
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_mob_timer_timeout():
	# new mob scene
	var mob = mob_scene.instantiate()
	
	# random location selected
	var mob_spawn_location = get_node("MobPath/MobSpawnLoc")
	mob_spawn_location.progress_ratio = randf()
	
	# mob direction perpendicular to path direction (always inwards)
	var direction = mob_spawn_location.rotation + PI/2
	
	# mob position will be the random location
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI/4, PI/4)	# plus minus 45 degrees range randomness
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn mob to the main scene every timeout
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
