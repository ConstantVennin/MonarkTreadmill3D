extends Node

export(PackedScene) var mob_scene
var speed2=10

func _ready():
	randomize()
	$UserInterface/Retry.hide()
	

func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var arrow = mob_scene.instance()
	var direction = Vector3.ZERO



	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Treadmill.transform.origin

	add_child(arrow)
	# We connect the mob to the score label to update the score upon squashing a mob.
	arrow.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	arrow.initialize(mob_spawn_location.translation, player_position, speed2)
	if Input.is_action_pressed("decrease") :
		$ArrowTimer.wait_time += 0.05
	if Input.is_action_pressed("increase") and $ArrowTimer.wait_time>0.2:
		$ArrowTimer.wait_time -= 0.05
	if Input.is_action_pressed("decrease") :
		speed2-=0.5
	if Input.is_action_pressed("increase"):
		speed2+=0.5
	print("speed2:", speed2)


