extends Node

export(PackedScene) var mob_scene

var url = "http://localhost:8080/instructions";

var currentTime = 0
var currentDistance = 0
var currentElevation = 0
var currentSpeed = 10

var serverTime = 0
var serverDistance = 0
var serverElevation = 0
var serverSpeed = 0

func _ready():
	randomize()
	$UserInterface/Retry.hide()
	#$Stream.play()


func _read_Last_Instructions():
	$HTTPRequest.request(url)


func _process(delta):
	if(Input.is_action_pressed("read_datas")):
		_read_Last_Instructions()
	if Input.is_action_pressed("decrease") and currentSpeed > 0:
		$MobTimer.wait_time += 0.05
		currentSpeed-=0.5
		print("currentSpeed:", currentSpeed)
	if Input.is_action_pressed("increase") and currentSpeed < 20 :
		$MobTimer.wait_time -= 0.05
		currentSpeed+=0.5
		print("currentSpeed:", currentSpeed)


func _send_Infos():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


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
	mob.initialize(mob_spawn_location.translation, player_position, currentSpeed)
	

func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	$Stream.stop()
	$DeathSound.play()



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var api_result = json.result
	print(api_result[0])
