extends Panel
class_name Pin

signal value_changed(bool)

var pins_link: Array[Pin]
var is_wiring: bool = false
var wire: Line2D = Line2D.new()

var value: bool = false:
	set(new):
		value = new
		value_changed.emit(value)
		for pin in pins_link:
			if pin.value != value:
				pin.value = value
	get:
		return value

func _ready() -> void:
	self.gui_input.connect(self._on_gui_input)
	wire.width = 3.0
	wire.default_color = self['theme_override_styles/panel']['bg_color']
	self.add_child(wire)
	wire.add_point(self.size/2)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	and event.is_released() \
	and not is_wiring:
		is_wiring = true
		print("start wiring")
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.is_released() \
	and is_wiring:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_wiring = false
		elif event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			is_wiring = false
			wire.add_point(wire.get_local_mouse_position())
