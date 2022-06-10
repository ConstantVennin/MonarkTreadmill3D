extends Node

export(PackedScene) var mob_scene

var url = "http://localhost:8080/instructions";

var power = false
var communication_Disconnect_Stop = false

var currentTime = 0
var currentDistance = 0.0
var currentElevation = 0.0
var currentSpeed = 10.0

var serverTime = 0
var serverDistance = 0
var serverElevation = 0.0
var serverSpeed = 0.0

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
	currentElevation=-10
	$Treadmill.initialize(currentElevation)



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
		if "A0" == hexaCode :
			$ChronoTimer.start()
			power = true
			communication_Disconnect_Stop = true
			_delete_by_id(id)
		elif "A1" == hexaCode :
			$ChronoTimer.start()
			power = true
			communication_Disconnect_Stop = false
			currentSpeed = 0
			_delete_by_id(id)
		elif "A2" == hexaCode :
			$ChronoTimer.stop()
			power = false
			communication_Disconnect_Stop = false
			currentSpeed = 0
			_delete_by_id(id)
		elif "A3" == hexaCode :
			var speedTemp = _get_Value_From_Json_Tab("data", tabLine)
			var speedTempNb = speedTemp as float
			speedTempNb = speedTempNb/10
			currentSpeed = speedTempNb
			_delete_by_id(id)
		elif "A4" == hexaCode :
			var elevationTemp = _get_Value_From_Json_Tab("data", tabLine)
			var elevationTempNb = elevationTemp as float
			elevationTempNb = elevationTempNb/10
			currentElevation = elevationTempNb
			print("elevation setted", serverElevation, " ", currentElevation)
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
	


func _on_HTTPRequestDelete_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print("[DELETING RESULT]:", json.result)


func _on_InstructionTimer_timeout():
	_read_Last_Instructions()
	_send_Infos()


func _on_ChronoTimer_timeout():
	currentTime += 1


func _make_post_request(url):
	print(url)
	var query = JSON.print("")
	var headers = ["Content-Type: application/json"]
	$HTTPRequestSend.request(url, headers, true, HTTPClient.METHOD_POST, query)
	print("[LOG][POST][URL:" + url + "]")

func _transform_in_four_bytes(value):
	var res = str(value)
	while(res.length()<4):
		res = "0" + res
	return res

func _send_Infos():
	if currentSpeed != serverSpeed :
		serverSpeed = currentSpeed
		serverSpeed = serverSpeed * 10
		var data = ""
		data = _transform_in_four_bytes(serverSpeed)
		serverSpeed = serverSpeed / 10
		_make_post_request(url + "/D1/" + data)
	if currentTime != serverTime :
		serverTime = currentTime
		var data = ""
		data = _transform_in_four_bytes(serverTime)
		_make_post_request(url + "/D6/" + data)
	if int(currentDistance) != serverDistance :
		serverDistance = int(currentDistance)
		var data = ""
		data = _transform_in_four_bytes(serverDistance)
		_make_post_request(url + "/D7/" + data)
	if currentElevation != serverElevation :
		serverElevation = currentElevation
		serverElevation = serverElevation * 10
		var data = ""
		data = _transform_in_four_bytes(serverElevation)
		_make_post_request(url + "/D2/" + data)
		serverElevation = serverElevation / 10
		print("elevation changed : ", serverElevation, " ", currentElevation)


func _on_refreshDistanceTimer_timeout():
	
	currentDistance += float(currentSpeed)/36.0
