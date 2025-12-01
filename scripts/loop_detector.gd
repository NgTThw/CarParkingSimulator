extends SimulatorObject
class_name LoopDetector

@onready var button: Button = %Button
@onready var area_2d: Area2D = $Area2D
@onready var pin: Pin = $Pin
@onready var led_red: Panel = $LEDRed
@onready var led_green: Panel = $LEDGreen

var count_entered: int = 0
var loop: bool = false:
	set(new):
		pin.value = new
		if new:
			led_green["theme_override_styles/panel"]["bg_color"] = Color.GREEN
		else:
			led_green["theme_override_styles/panel"]["bg_color"] = Color("003f00")
	get:
		return pin.value

func _ready() -> void:
	super._ready()
	button.pressed.connect(self._on_button_pressed)
	area_2d.area_entered.connect(self._on_area_entered)
	area_2d.area_exited.connect(self._on_area_exited)

func _on_area_entered(_area: Area2D) -> void:
	count_entered += 1
	loop = true

func _on_area_exited(_area: Area2D) -> void:
	count_entered -= 1
	if count_entered == 0:
		loop = false

func _on_button_pressed() -> void:
	loop = true
	await get_tree().create_timer(0.5).timeout
	loop = false
