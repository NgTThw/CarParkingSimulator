extends Camera2D

var is_dragging: bool = false
var click_position: Vector2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN and event.is_released():
			var mouse_pos: Vector2 = self.get_global_mouse_position()
			self.zoom *= 0.9
			self.position += (mouse_pos - self.get_global_mouse_position())
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP and event.is_released():
			var mouse_pos: Vector2 = self.get_global_mouse_position()
			self.zoom *= 1.1
			self.position += (mouse_pos - self.get_global_mouse_position())
		elif event.button_index == MouseButton.MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				is_dragging = true
				click_position = event.position
			else:
				is_dragging = false
	if event is InputEventMouse:
		if is_dragging:
			self.position += (click_position - event.position) / self.zoom
			click_position = event.position
