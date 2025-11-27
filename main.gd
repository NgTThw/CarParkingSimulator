extends Node2D


@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready() -> void:
	for button in %VBoxContainer.get_children():
		button.add_object.connect(self._on_add_object)

func _on_add_object(obj: PackedScene) -> void:
	var child: SimulatorObject = obj.instantiate()
	self.tile_map.add_child(child)
	child.click_position = child.size/2
	child.global_position = self.get_global_mouse_position() - child.click_position
	child.is_dragging = true
