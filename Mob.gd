extends KinematicBody

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
export var min_speed = 10
# Maximum speed of the mob in meters per second.
export var max_speed = 18
export var speed = 10
var velocity = Vector3.ZERO

func save():
	if Input.is_action_pressed("decrease") :
		speed-=1
	if Input.is_action_pressed("increase"):
		speed+=1


func _physics_process(_delta):
	var direction = Vector3.ZERO
	move_and_slide(velocity)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func initialize(start_position, _player_position):
	translation = start_position
	save()
	if Input.is_action_pressed("elever") :
		$Pivot.translation.y+=1
	if Input.is_action_pressed("abaisser") :
		$Pivot.translation.y-=1
	#rotate_y(rand_range(-PI / 4, PI / 4))
	rotate_y(0)
	# We calculate a forward velocity first, which represents the speed.
	#if Input.is_action_pressed("decrease") :
	#	speed-=1
	#if Input.is_action_pressed("increase"):
	#	speed+=1
	velocity = Vector3.UP * speed
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	#$AnimationPlayer.playback_speed = speed / min_speed


func squash():
	emit_signal("squashed")
	queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()



func _on_Area_area_entered(area):
	queue_free()