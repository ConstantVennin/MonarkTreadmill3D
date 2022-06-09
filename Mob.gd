extends KinematicBody


export var speed_mob = 10
export var Elevation_mob=0
var velocity = Vector3.ZERO

func _physics_process(_delta):
	var direction = Vector3.ZERO
	move_and_slide(velocity)
	velocity = Vector3.FORWARD * speed_mob
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	if Input.is_action_pressed("elever"):
		rotate(Vector3(1, 0, 0), Elevation_mob)
		# shortened
		$Pivot.rotate_x(Elevation_mob)
		direction.y -= 0.1
	if Input.is_action_pressed("abaisser"):
		rotate(Vector3(1, 0, 0), -Elevation_mob)
		# shortened
		$Pivot.rotate_x(-Elevation_mob)
		direction.y += 0.1

func initialize(start_position, speed2, Elevation):
	translation = start_position
	speed_mob=speed2
	Elevation_mob=Elevation

	#rotate_y(rand_range(-PI / 4, PI / 4))
	rotate_y(0)
	# We calculate a forward velocity first, which represents the speed.
	#if Input.is_action_pressed("decrease") :
	#	speed-=1
	#if Input.is_action_pressed("increase"):
	#	speed+=1
	velocity = Vector3.UP * 10
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_VisibilityNotifier_screen_exited():
	queue_free()



func _on_Area_area_entered(area):
	queue_free()
