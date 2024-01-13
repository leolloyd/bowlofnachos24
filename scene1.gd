extends Area2D

signal hit

@export var speed = 400 # How fast player moves in pixels/sec
var screen_size	#undefined

# on mount
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# update
func _process(delta):
	var velocity = Vector2.ZERO # player's current movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$BugGuy.play()
	else:
		$BugGuy.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Select correct animation instead of  the just default one
	if velocity.x != 0:
		$BugGuy.animation = 'walk'
		$BugGuy.flip_v = false
		$BugGuy.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$BugGuy.animation = 'up'
		$BugGuy.flip_v = velocity.y > 0

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)	# disable collision object so hit signal only triggers once
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
