extends CanvasLayer

var apiUrl = "http://localhost:8080/instructions/";
var headers = ["Content-Type: application/json"];

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	while(true):
		yield(get_tree().create_timer(4.0), "timeout")
		print("test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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



