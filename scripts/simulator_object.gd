extends Area2D
class_name SimulatorObject


var mouse_insize: bool = true

signal click_on_focus

func _ready() -> void:
	self.mouse_entered.connect(func(): self.mouse_insize = true)
	self.mouse_exited.connect(func(): self.mouse_insize = false)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1 and mouse_insize:
		click_on_focus.emit()
