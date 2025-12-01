extends Node2D


@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready() -> void:
	var serial = GdSerial.new()
	var invalid := serial.list_ports()
	var i: int = 0
	var com: int = 1
	while i < 5:
		var port: String = "COM%s" % str(com)
		if port not in invalid:
			Global.list_ports.append(port)
			i += 1
	for button in %VBoxContainer.get_children():
		button.add_object.connect(self._on_add_object)

func _on_add_object(obj: PackedScene) -> void:
	var child: SimulatorObject = obj.instantiate()
	self.tile_map.add_child(child)
	child.click_position = child.size/2
	child.global_position = self.get_global_mouse_position() - child.click_position
	child.is_dragging = true
