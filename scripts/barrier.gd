extends SimulatorObject
class_name Barrier


@onready var marker: Marker2D = $Marker2D
@onready var button_open: Button = %ButtonOpen
@onready var button_close: Button = %ButtonClose
@onready var led: Panel = $LED

func _ready() -> void:
	super._ready()
	button_open.pressed.connect(self.open)
	button_close.pressed.connect(self.close)

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
