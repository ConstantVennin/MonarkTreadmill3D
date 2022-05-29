extends Node

export(PackedScene) var mob_scene


func _ready():
	randomize()
	$UserInterface/Retry.hide()
	#$Stream.play()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
		$Stream.play()


func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()
	var direction = Vector3.ZERO

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Player.transform.origin

	add_child(mob)
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	mob.initialize(mob_spawn_location.translation, player_position)
	if Input.is_action_pressed("decrease") :
		$MobTimer.wait_time += 0.1
	if Input.is_action_pressed("increase") and $MobTimer.wait_time>0.2 :
		$MobTimer.wait_time -= 0.1

func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	$Stream.stop()
	$DeathSound.play()

