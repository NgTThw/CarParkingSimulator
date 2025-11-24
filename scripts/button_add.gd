extends Button
class_name ButtonAdd

@export var object: PackedScene

signal clicked(PackedScene)

func _ready() -> void:
	self.pressed.connect(self._on_pressed)

func _on_pressed() -> void:
	self.clicked.emit(object)
