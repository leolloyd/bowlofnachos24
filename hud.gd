extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	#await $MessageTimer.timeout
	#$Message.show()
	$Sprite2D/AnimationPlayer.play("RESET")
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func progress_guac_to_cheese():
	$Sprite2D/AnimationPlayer.play("progress_animation")
	
func progress_cheese_to_beef():
	$Sprite2D/AnimationPlayer.play("cheese_to_beef")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/AnimationPlayer.play("RESET")
	$StartButton.hide()
	#start_game.emit()
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
