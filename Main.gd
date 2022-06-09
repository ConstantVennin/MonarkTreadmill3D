extends Node

export(PackedScene) var mob_scene

var url = "http://localhost:8080/instructions";

var power = false
var communication_Disconnect_Stop = false

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
	$HTTPRequestExec.request(url)


func _delete_by_id(id):
	var query = JSON.print("")
	var headers = ["Content-Type: application/json"]
	$HTTPRequestDelete.request(url+"/"+id, headers, true, HTTPClient.METHOD_DELETE, query)


func _process(delta):
	if(Input.is_action_pressed("read_datas")):
		_read_Last_Instructions()
	if Input.is_action_pressed("decrease") and currentSpeed > 0:
		$ArrowTimer.wait_time += 0.05
		currentSpeed-=0.5
		print("currentSpeed:", currentSpeed)
	if Input.is_action_pressed("increase") and currentSpeed < 20 :
		$ArrowTimer.wait_time -= 0.05
		currentSpeed+=0.5
		print("currentSpeed:", currentSpeed)
	if Input.is_action_pressed("elever") :
		currentElevation+=0.001
		print("currentElevation:", currentElevation)
	if Input.is_action_pressed("abaisser") :
		currentElevation-=0.001
		print("currentElevation:", currentElevation)
	$Treadmill.initialize(currentElevation)



func _send_Infos():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_ArrowTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var arrow = mob_scene.instance()
	var direction = Vector3.ZERO

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()


	add_child(arrow)
	# We connect the mob to the score label to update the score upon squashing a mob.
	arrow.initialize(mob_spawn_location.translation, currentSpeed, currentElevation)
	







func _i_to_tab(i):
	var line = var2str(i)
	line = line.replace("{","")
	line = line.replace("}","")
	return line.split(",")

func _get_Value_From_Json_Tab(key, tab):
	for i in tab:
		if key.is_subsequence_of ( i ) :
			var value = i.split(":")[1]
			value = value.replace("\"","")
			value = value.replace(" ","")
			value = value.replace(".0","")
			return value
	return "value not found"



func _on_HTTPRequestExec_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var api_result = json.result
	for i in api_result :
		var tabLine = _i_to_tab(i)
		var hexaCode = _get_Value_From_Json_Tab("hexaCode", tabLine)
		var id = _get_Value_From_Json_Tab("id", tabLine)
		print(hexaCode)
		if "A0" == hexaCode :
			power = true
			communication_Disconnect_Stop = true
			_delete_by_id(id)
		elif "A1" == hexaCode :
			power = true
			communication_Disconnect_Stop = false
			_delete_by_id(id)
		elif "A2" == hexaCode :
			power = false
			communication_Disconnect_Stop = false
			_delete_by_id(id)
		elif "A3" == hexaCode :
			var speedTemp = _get_Value_From_Json_Tab("data", tabLine)
			var speedTempNb = speedTemp as float
			speedTempNb = speedTempNb/10
			currentSpeed = speedTempNb
			_delete_by_id(id)
		elif "AA" == hexaCode :
			power = false
			communication_Disconnect_Stop = false
			currentElevation = 0
			currentSpeed = 0
			_delete_by_id(id)
		elif "AB" == hexaCode :
			currentElevation = 0
			currentSpeed = 0
			_delete_by_id(id)
		print("contain : ", i)



func _on_HTTPRequestDelete_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
