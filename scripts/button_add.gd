extends Button
class_name ButtonAdd

@export var object: PackedScene

signal add_object(PackedScene)

func _ready() -> void:
	self.pressed.connect(self._on_pressed)

func _on_pressed() -> void:
	self.add_object.emit(object)
