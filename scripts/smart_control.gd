extends SimulatorObject
class_name SmartControl


@onready var btn_g1: Button = %G1
@onready var btn_g2: Button = %G2
@onready var btn_g3: Button = %G3
@onready var btn_g4: Button = %G4
@onready var btn_g5: Button = %G5
@onready var btn_g6: Button = %G6
@onready var btn_g7: Button = %G7
@onready var btn_g8: Button = %G8

@onready var pin_g1: Pin = %PinG1
@onready var pin_g2: Pin = %PinG2
@onready var pin_g3: Pin = %PinG3
@onready var pin_g4: Pin = %PinG4
@onready var pin_g5: Pin = %PinG5
@onready var pin_g6: Pin = %PinG6
@onready var pin_g7: Pin = %PinG7
@onready var pin_g8: Pin = %PinG8

@onready var click_g1: CheckBox = %ClickG1
@onready var click_g2: CheckBox = %ClickG2
@onready var click_g3: CheckBox = %ClickG3
@onready var click_g4: CheckBox = %ClickG4
@onready var click_g5: CheckBox = %ClickG5
@onready var click_g6: CheckBox = %ClickG6
@onready var click_g7: CheckBox = %ClickG7
@onready var click_g8: CheckBox = %ClickG8


var g1: bool = false:
	set(new):
		_set_pin_value(new, pin_g1, click_g1)
	get:
		return pin_g1.value
var g2: bool = false:
	set(new):
		_set_pin_value(new, pin_g2, click_g2)
	get:
		return pin_g2.value
var g3: bool = false:
	set(new):
		_set_pin_value(new, pin_g3, click_g3)
	get:
		return pin_g3.value
var g4: bool = false:
	set(new):
		_set_pin_value(new, pin_g4, click_g4)
	get:
		return pin_g4.value
var g5: bool = false:
	set(new):
		_set_pin_value(new, pin_g5, click_g5)
	get:
		return pin_g5.value
var g6: bool = false:
	set(new):
		_set_pin_value(new, pin_g6, click_g6)
	get:
		return pin_g6.value
var g7: bool = false:
	set(new):
		_set_pin_value(new, pin_g7, click_g7)
	get:
		return pin_g7.value
var g8: bool = false:
	set(new):
		_set_pin_value(new, pin_g8, click_g8)
	get:
		return pin_g8.value

@onready var line_edit_ip: LineEdit = %LineEditIP
@onready var line_edit_port: LineEdit = %LineEditPort
@onready var label_ip: Label = %LabelIP
@onready var label_port: Label = %LabelPort
@onready var warning: Control = $Warning
@onready var http_request_loop: HTTPRequest = $HTTPRequestLoop
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var http_server: HTTPServer = $HTTPServer
@onready var timer: Timer = $Timer

var ip: String
var port: int
var url: String = ""
var auth: String = ""
var header: PackedStringArray
var connect_smart: bool = false
var user_name: String = "smart"
var password: String = "control"

func _ready() -> void:
	super._ready()
	btn_g1.pressed.connect(self._on_btn_g1_pressed)
	btn_g2.pressed.connect(self._on_btn_g2_pressed)
	btn_g3.pressed.connect(self._on_btn_g3_pressed)
	btn_g4.pressed.connect(self._on_btn_g4_pressed)
	btn_g5.pressed.connect(self._on_btn_g5_pressed)
	btn_g6.pressed.connect(self._on_btn_g6_pressed)
	btn_g7.pressed.connect(self._on_btn_g7_pressed)
	btn_g8.pressed.connect(self._on_btn_g8_pressed)
	self.setting_submit.connect(self._on_setting_submit)
	self.setting_cancel.connect(self._on_setting_cancel)
	http_server.GET.connect(self._on_http_server_get)
	http_server.POST.connect(self._on_http_server_post)
	warning.tooltip_text = "Smart Control is not running.\nOpen setting and click OK"
	warning.show()
	http_request_loop.request_completed.connect(self._on_http_request_completed)
	timer.wait_time = 0.3
	timer.timeout.connect(self._on_timer_timeout)

func _on_btn_g1_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=0", header, HTTPClient.METHOD_GET)
	else:
		g1 = !g1

func _on_btn_g2_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=1", header, HTTPClient.METHOD_GET)
	else:
		g2 = !g2
		
func _on_btn_g3_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=2", header, HTTPClient.METHOD_GET)
	else:
		g3 = !g3

func _on_btn_g4_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=3", header, HTTPClient.METHOD_GET)
	else:
		g4 = !g4

func _on_btn_g5_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=4", header, HTTPClient.METHOD_GET)
	else:
		g5 = !g5

func _on_btn_g6_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=5", header, HTTPClient.METHOD_GET)
	else:
		g6 = !g6

func _on_btn_g7_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=6", header, HTTPClient.METHOD_GET)
	else:
		g7 = !g7

func _on_btn_g8_pressed() -> void:
	if connect_smart:
		http_request.request(url+"/leds.cgi?led=7", header, HTTPClient.METHOD_GET)
	else:
		g8 = !g8

func _set_pin_value(value: bool, pin: Pin, check: CheckBox) -> void:
	pin.value = value
	if value:
		pin.get_child(0)['theme_override_colors/font_color'] = Color.SEA_GREEN
		if !connect_smart and check.button_pressed:
			await get_tree().create_timer(.3).timeout
			pin.value = false
			pin.get_child(0)['theme_override_colors/font_color'] = Color.BLACK
	else:
		pin.get_child(0)['theme_override_colors/font_color'] = Color.BLACK

func _on_setting_submit() -> void:
	warning.hide()
	port = line_edit_port.text.to_int()
	label_port.text = str(port)
	line_edit_port.text = label_port.text
	ip = line_edit_ip.text
	if not ip:
		ip = '127.0.0.1'
	label_ip.text = ip
	if ip == '127.0.0.1' or ip == "localhost":
		connect_smart = false
		http_request_loop.cancel_request()
		timer.stop()
		if http_server.is_running():
			if http_server.port != port:
				http_server.close()
				http_server.listen(port)
		else:
			http_server.listen(port)
	else:
		connect_smart = true
		if http_server.is_running():
			http_server.close()
		url = "http://%s:%s" % [ip, str(port)]
		header = [
			"Authorization: Basic %s" % Marshalls.utf8_to_base64(user_name+":"+password)
		]
		http_request_loop.cancel_request()
		timer.start()
		
func _on_timer_timeout() -> void:
	http_request_loop.request(
		url+"/status.xml", 
		header, 
		HTTPClient.METHOD_GET)

func _on_setting_cancel() -> void:
	line_edit_ip.text = label_ip.text
	line_edit_port.text = label_port.text

func _on_http_server_get(request: HTTPServer.Request) -> void:
	print(request.header)
	var response: HTTPServer.Response = HTTPServer.Response.new()
	response.status_code = 200
	response.headers = {
		"Connection": "close",
		"Content-Type": "text/xml",
		"Cache-Control": "no-cache"
	}
	if request.path == "/status.xml":
		response.data = '''<response>\r\n<led0>%s</led0>\r\n<led1>%s</led1>\r\n<led2>%s</led2>\r
		<led3>%s</led3>\r\n<led4>%s</led4>\r\n<led5>%s</led5>\r\n<led6>%s</led6>\r
		<led7>%s</led7>\r\n<led8>0</led8>\r\n</response>''' % [
			_str(g1), _str(g2), _str(g3), _str(g4), _str(g5), _str(g6), _str(g7), _str(g8)]
		request.send(response)
		return
	match request.path:
		"/leds.cgi?led=0":
			g1 = !g1
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=1":
			g2 = !g2
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=2":
			g3 = !g3
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=3":
			g4= !g4
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=4":
			g5 = !g5
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=5":
			g6 = !g6
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=6":
			g7 = !g7
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=7":
			g8 = !g8
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=8":
			g1 = !g1
			g2 = !g2
			g3 = !g3
			g4 = !g4
			g5 = !g5
			g6 = !g6
			g7 = !g7
			g8 = !g8
			response.data = "Success! 0"
			request.send(response)

func _on_http_server_post(request: HTTPServer.Request) -> void:
	var response: HTTPServer.Response = HTTPServer.Response.new()
	response.status_code = 200
	response.headers = {
		"Connection": "close",
		"Content-Type": "text/xml",
		"Cache-Control": "no-cache"
	}
	match request.path:
		"/leds.cgi?led=0":
			g1 = !g1
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=1":
			g2 = !g2
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=2":
			g3 = !g3
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=3":
			g4= !g4
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=4":
			g5 = !g5
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=5":
			g6 = !g6
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=6":
			g7 = !g7
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=7":
			g8 = !g8
			response.data = "Success! 0"
			request.send(response)
		"/leds.cgi?led=8":
			g1 = !g1
			g2 = !g2
			g3 = !g3
			g4 = !g4
			g5 = !g5
			g6 = !g6
			g7 = !g7
			g8 = !g8
			response.data = "Success! 0"
			request.send(response)

func _str(value: bool) -> String:
	if value:
		return "1"
	return "0"

func _on_http_request_completed(_result, response_code, _headers, body):
	if connect_smart:
		if response_code != 200:
			warning.tooltip_text = "Request failed code: %s" % str(response_code)
			warning.show()
		else:
			var i = 0
			while i < len(body):
				if body[i] == 10:
					break
				i += 1
			while i < len(body):
				if body[i+5] == 48:
					g1 = body[i+7] == 49
				elif body[i+5] == 49:
					g2 = body[i+7] == 49
				elif body[i+5] == 50:
					g3 = body[i+7] == 49
				elif body[i+5] == 51:
					g4 = body[i+7] == 49
				elif body[i+5] == 52:
					g5 = body[i+7] == 49
				elif body[i+5] == 53:
					g6 = body[i+7] == 49
				elif body[i+5] == 54:
					g7 = body[i+7] == 49
				elif body[i+5] == 55:
					g8 = body[i+7] == 49
					break
				i += 16
		timer.start()

func _exit_tree() -> void:
	timer.stop()
	http_server.close()
	http_request.cancel_request()
	http_request_loop.cancel_request()
