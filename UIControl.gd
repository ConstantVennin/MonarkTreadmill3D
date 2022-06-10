extends CanvasLayer

var apiUrl = "http://localhost:8080/instructions/";
var url = "http://localhost:8080/instructions"
var headers = ["Content-Type: application/json"];


func _ready():
	while(true):
		yield(get_tree().create_timer(4.0), "timeout")


func _make_post_request(url):
	var query = JSON.print("")
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, true, HTTPClient.METHOD_POST, query)
	var status = ""
	print("[LOG][POST][URL:" + url + "]")


func _on_PlayButton_pressed():
	_make_post_request(apiUrl+"A0")


func _on_StopButton_pressed():
	_make_post_request(apiUrl+"A2")


func _on_AutoStopButton_pressed():
	_make_post_request(apiUrl+"AA")


func _on_AutoCoolDownButton_pressed():
	_make_post_request(apiUrl+"AB")


func _make_data_correct(data):
	if("." in data):
		data = data.replace(".","")
	else:
		if(data.length()<4):
			data = data + "0"
	data = _fill_zero(data)
	return data


func _fill_zero(data):
	while(data.length()<4):
		data = "0"+data
	return data


func _on_SetElevation_pressed():
	var elevation = $ElevationInput.text
	elevation = _make_data_correct(elevation)
	_make_post_request(apiUrl+"A4/"+elevation)


func _on_SetTime_pressed():
	var time = $TimeInput.text
	time = _fill_zero(time)
	_make_post_request(apiUrl+"A5/"+time)

func _on_SetSpeed_pressed():
	var speed = $SpeedInput.text
	speed = _make_data_correct(speed)
	_make_post_request(apiUrl+"A3/"+speed)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if(response_code != 200):
		print("[MESSAGE:" + body.get_string_from_utf8() + "]")
		$LogOutput.text = "fail :" + body.get_string_from_utf8()
	else:
		var json = JSON.parse(body.get_string_from_utf8())
		print("[MESSAGE:Success]")
		print("JSON_RES:{")
		print(json.result)
		print("}")
		$LogOutput.text = "Success : you added " + body.get_string_from_utf8()


func _read_instructions() :
	$HTTPRequestReader.request(url)


func _on_refreshTimer_timeout():
	_read_instructions()


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


func _on_HTTPRequestReader_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var api_result = json.result
	for i in api_result :
		var tabLine = _i_to_tab(i)
		var hexaCode = _get_Value_From_Json_Tab("hexaCode", tabLine)
		var id = _get_Value_From_Json_Tab("id", tabLine)
		if "D1" == hexaCode :
			$SpeedInput2.text = _get_Value_From_Json_Tab("data", tabLine)
			_delete_by_id(id)
		elif "D2" == hexaCode :
			$ElevationInput2.text = _get_Value_From_Json_Tab("data", tabLine)
			print("set elevation")
			_delete_by_id(id)
		elif "D6" == hexaCode :
			$TimeInput2.text = _get_Value_From_Json_Tab("data", tabLine)
			_delete_by_id(id)
		elif "D7" == hexaCode :
			$DistanceInput2.text = _get_Value_From_Json_Tab("data", tabLine)
			_delete_by_id(id)


func _delete_by_id(id):
	var query = JSON.print("")
	var headers = ["Content-Type: application/json"]
	$HTTPRequestDeleter.request(url+"/"+id, headers, true, HTTPClient.METHOD_DELETE, query)
