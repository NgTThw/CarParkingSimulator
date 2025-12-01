extends SimulatorObject
class_name Barrier


@onready var marker: Marker2D = $Marker2D
@onready var button_open: Button = %ButtonOpen
@onready var button_close: Button = %ButtonClose
@onready var led: Panel = $LED
@onready var pin_open: Pin = $PinOpen
@onready var pin_close: Pin = $PinClose
@onready var pin_loop: Pin = $PinLoop

var loop_on: bool = false

func _ready() -> void:
	super._ready()
	button_open.pressed.connect(self.open)
	button_close.pressed.connect(self.close)
	pin_open.value_changed.connect(self._on_pin_open_value_changed)
	pin_close.value_changed.connect(self._on_pin_close_value_changed)
	pin_loop.value_changed.connect(self._on_loop)

func _on_pin_open_value_changed(value: bool) -> void:
	if value:
		pin_open.get_child(0)['theme_override_colors/font_color'] = Color.SEA_GREEN
		self.open()
	else:
		pin_open.get_child(0)['theme_override_colors/font_color'] = Color.WHITE

func _on_pin_close_value_changed(value: bool) -> void:
	if value:
		pin_close.get_child(0)['theme_override_colors/font_color'] = Color.SEA_GREEN
		self.close()
	else:
		pin_close.get_child(0)['theme_override_colors/font_color'] = Color.WHITE

func open() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(marker, "rotation_degrees", 90, 0.3)
	tween.tween_callback(func(): led.modulate = Color("00b056"))

func close() -> void:
	if loop_on:
		return
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(marker, "rotation_degrees", 0, 0.3)
	led.modulate = Color("ff4247")
	tween.tween_callback(func(): led.modulate = Color("ff4247"))

func _on_loop(v: bool) -> void:
	if v:
		pin_loop.get_child(0)['theme_override_colors/font_color'] = Color.SEA_GREEN
	else:
		pin_loop.get_child(0)['theme_override_colors/font_color'] = Color.WHITE
	loop_on = v
	if marker.rotation_degrees != 0:
		if loop_on:
			self.open()
		else:
			self.close()
