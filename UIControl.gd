extends CanvasLayer

var apiUrl = "http://localhost:8080/instructions/";
var headers = ["Content-Type: application/json"];

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _make_post_request(url):
	var query = JSON.print("")
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, true, HTTPClient.METHOD_POST, query)


func _on_PlayButton_pressed():
	_make_post_request(apiUrl+"A0")


func _on_StopButton_pressed():
	_make_post_request(apiUrl+"A2")


func _on_AutoStopButton_pressed():
	_make_post_request(apiUrl+"AA")


func _on_AutoCoolDownButton_pressed():
	_make_post_request(apiUrl+"AB")
