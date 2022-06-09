extends KinematicBody


# How fast the player moves in meters per second.
export var speed = 14

export var jump_impulse = 20

export var elevationAdd = 0

var velocity = Vector3.ZERO

var basis = Basis()

func initialize(currentElevation):
	elevationAdd=currentElevation

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("elever"):
		rotate(Vector3(1, 0, 0), elevationAdd)
		# shortened
#		$Pivot.rotate_x(elevationAdd)
#		direction.y -= 0.1
	if Input.is_action_pressed("abaisser"):
		rotate(Vector3(1, 0, 0), -elevationAdd)
		# shortened
#		$Pivot.rotate_x(-elevationAdd)
#		direction.y += 0.1
	velocity = move_and_slide(velocity, Vector3.UP)
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

