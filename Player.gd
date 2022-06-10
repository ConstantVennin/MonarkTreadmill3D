extends KinematicBody


# How fast the player moves in meters per second.
export var speed = 14

export var jump_impulse = 20

export var elevationAdd = 0
var targetElevation=0

var velocity = Vector3.ZERO

var basis = Basis()

func initialize(currentElevation):
	targetElevation = currentElevation*2*PI/180

func _physics_process(delta):
	var direction = Vector3.ZERO
	if targetElevation > elevationAdd:
		rotate(Vector3(1, 0, 0), 0.001)
		elevationAdd +=0.001
	if targetElevation < elevationAdd:
		rotate(Vector3(1, 0, 0), -0.001)
		elevationAdd -=0.001


	velocity = move_and_slide(velocity, Vector3.UP)
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

