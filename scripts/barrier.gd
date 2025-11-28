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
	pin_open.value_changed.connect(func(v): if v: self.open())
	pin_close.value_changed.connect(func(v): if v: self.close())
	pin_loop.value_changed.connect(self._on_loop)

func open() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(marker, "rotation_degrees", 90, 0.3)
	tween.tween_callback(func(): led.modulate = Color("00b056"))

func close() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(marker, "rotation_degrees", 0, 0.3)
	led.modulate = Color("ff4247")

func _on_loop(v: bool) -> void:
	if v and not loop_on:
		loop_on = true
	elif not v and loop_on:
		loop_on = false
		self.close()
