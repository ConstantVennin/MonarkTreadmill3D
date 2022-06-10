extends KinematicBody


export var speed_mob = 10
var targetElevation=0
var elevationAdd=0
var velocity = Vector3.ZERO


func _physics_process(_delta):
	var direction = Vector3.ZERO
	move_and_slide(velocity)
	velocity = Vector3.FORWARD * speed_mob
	velocity = velocity.rotated(Vector3.UP, rotation.y)




func initialize(start_position, speed2, currentElevation):
	translation = start_position
	speed_mob=speed2
	targetElevation = currentElevation*PI/180

	#rotate_y(rand_range(-PI / 4, PI / 4))
	if targetElevation > elevationAdd:
		elevationAdd +=0.001
	if targetElevation < elevationAdd:
		elevationAdd -=0.001
	rotate_y(0)
	rotate(Vector3(1, 0, 0), elevationAdd)
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
