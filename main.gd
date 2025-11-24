extends Node2D


var selected: SimulatorObject
var selected_local_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $Control/VBoxContainer.get_children():
		button.clicked.connect(self._on_add_object)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_released():
		if self.selected:
			self.selected = null
	elif event is InputEventMouseMotion:
		if self.selected:
			self.selected.position = $TileMapLayer.local_to_map(self.get_local_mouse_position() - self.selected_local_position) * 32

func _on_add_object(obj: PackedScene) -> void:
	var child: SimulatorObject = obj.instantiate()
	self.add_child(child)
	child.click_on_focus.connect(func(): self._on_object_click_on_focus(child))
	self.selected = child
	self.selected.position = $TileMapLayer.local_to_map(self.get_local_mouse_position()) * 32

func _on_object_click_on_focus(obj: SimulatorObject) -> void:
	if not self.selected:
		self.selected = obj
		self.selected_local_position = self.selected.get_local_mouse_position()
	else:
		var obj_pos: Vector2 = obj.get_local_mouse_position()
		var selected_pos: Vector2 = self.selected.get_local_mouse_position()
		if obj_pos.y < selected_pos.y or obj.is_greater_than(self.selected):
			self.selected = obj
			self.selected_local_position = self.selected.get_local_mouse_position()

func _on_rfid_reader_swipe_card(card: RFIDCard) -> void:
	print("swipe card %s %s" % [card.card_no, card.card_id])
