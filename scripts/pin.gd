extends Panel
class_name Pin

signal value_changed(bool)

var pins_link: Array[Pin]
var is_wiring: bool = false
var wire: Line2D = Line2D.new()
var wire_link: Line2D

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
	wire.gradient = Gradient.new()
	wire.gradient.set_color(0, self['theme_override_styles/panel']['bg_color'])
	wire.gradient.set_color(1, self['theme_override_styles/panel']['bg_color'])
	wire.z_index = 1
	self.add_child(wire)
	wire.add_point(self.size/2, 0)
	wire.add_point(self.size/2, 1)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	and event.is_released() \
	and not is_wiring:
		if Global.mouse_state == Global.MouseState.FREE:
			is_wiring = true
			Global.current_wiring = self
			wire.set_point_position(1, wire.get_local_mouse_position())
		elif Global.mouse_state == Global.MouseState.WIRING:
			Global.link(self)
	if event is InputEventMouseMotion \
	and not is_wiring \
	and Global.mouse_state == Global.MouseState.WIRING:
		Global.current_wiring.wire.set_point_position(
			1, Global.current_wiring.wire.to_local(self.global_position + self.size/2))
		Global.current_wiring.wire.gradient.set_color(1, self['theme_override_styles/panel']['bg_color'])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.is_released() \
	and is_wiring:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_wiring = false
			Global.current_wiring.wire.set_point_position(1, self.size/2)
			Global.current_wiring = null
	if is_wiring:
		wire.set_point_position(1, wire.get_local_mouse_position())
		wire.gradient.set_color(1, self['theme_override_styles/panel']['bg_color'])

func _process(_delta: float) -> void:
	if wire_link:
		wire_link.set_point_position(1, wire_link.to_local(self.global_position + self.size/2))

func set_wire(link: Line2D) -> void:
	link.gradient.set_color(1, self['theme_override_styles/panel']['bg_color'])
	self.wire_link = link
