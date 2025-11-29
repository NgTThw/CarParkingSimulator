extends Node
class_name HTTPServer

enum HTTPMethod {
	GET,
	POST,
	OPTIONS,
}

class Request:
	var method: HTTPMethod
	var path: String
	var upgrade_header: String
	var header: Dictionary
	var data: String
	var peer: StreamPeerTCP
	
	func send(response: Response) -> void:
		var str_headers: String = ""
		for key in response.headers.keys():
			str_headers += "%s: %s\r\n" % [key, response.headers[key]]
		var content: String = "%s %s %s\r\n%s\r\n%s\r\n" % [
			response.upgrade_header,
			response.status_code,
			response.string_status_code(),
			str_headers,
			response.data]
		peer.put_data(content.to_utf8_buffer())
		peer.disconnect_from_host()

class Response:
	var status_code: int
	var upgrade_header: String = 'HTTP/1.1'
	var headers: Dictionary
	var data: String
	
	func string_status_code() -> String:
		if status_code == 200: return "OK"
		if status_code == 404: return "Not Found"
		return ""

var server: TCPServer = TCPServer.new()
var port: int
var thread: Thread = Thread.new()

signal got_request(Request)
signal GET(Request)
signal POST(Request)
signal OPTIONS(Request)

func listen(p: int) -> void:
	port = p
	server.listen(port)
	thread.start(_worker_run_forever)

func is_running() -> bool:
	return server.is_listening()

func _on_get_request(request: Request) -> void:
	if request.method == HTTPMethod.GET:
		GET.emit(request)
	elif request.method == HTTPMethod.POST:
		POST.emit(request)
	elif request.method == HTTPMethod.OPTIONS:
		OPTIONS.emit(request)

func close() -> void:
	server.stop()
	thread.wait_to_finish()

func _worker_run_forever() -> void:
	while server.is_listening():
		if server.is_connection_available():
			var peer: StreamPeerTCP = server.take_connection()
			var request = Request.new()
			request.peer = peer
			var pack: PackedByteArray
			var data = peer.get_data(1)[1][0]
			while data != 32: #space
				pack.append(data)
				data = peer.get_data(1)[1][0]
			if pack == PackedByteArray([71, 69, 84]):
				request.method = HTTPMethod.GET
			elif pack == PackedByteArray([80, 79, 83, 84]):
				request.method = HTTPMethod.POST
			elif pack == PackedByteArray([79, 80, 84, 73, 79, 78, 83]):
				request.method = HTTPMethod.OPTIONS
			pack.clear()
			data = peer.get_data(1)[1][0]
			while data != 32: #space
				pack.append(data)
				data = peer.get_data(1)[1][0]
			request.path = pack.get_string_from_ascii()
			pack.clear()
			data = peer.get_data(1)[1][0]
			while data != 13: #\r
				pack.append(data)
				data = peer.get_data(1)[1][0]
			request.upgrade_header = pack.get_string_from_ascii()
			pack.clear()
			while true:
				data = peer.get_data(1)
				data = peer.get_data(1)[1][0]
				while data != 13: #\r
					pack.append(data)
					data = peer.get_data(1)[1][0]
				if pack.is_empty():
					data = peer.get_data(1)
					break
				var header: String = pack.get_string_from_ascii()
				var key_value: Array = header.split(": ")
				request.header[key_value[0]] = key_value[1]
				pack.clear()
			if peer.get_available_bytes() > 1:
				while true:
					request.data += peer.get_data(peer.get_available_bytes())[1].get_strin_from_utf8()
					if pack[-1] == 10 and pack[-2] == 13:
						break
			self.got_request.emit.call_deferred(request)
			self._on_get_request.call_deferred(request)
