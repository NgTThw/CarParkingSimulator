extends Panel
class_name SimulatorObject


var is_dragging: bool = false
var click_position: Vector2 = Vector2.ZERO
var mouse_insize: bool = false

signal setting_submit
signal setting_cancel

@export var setting: Panel
@export var button_ok: Button
@export var button_cancel: Button
@export var button_del: Button
@export var select_effect: Panel
@export var selected: bool = false:
	set(new):
		selected = new
		if selected:
			self.select_effect.show()
		else:
			self.select_effect.hide()
	get:
		return selected

func _ready() -> void:
	if self.select_effect:
		self.select_effect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.mouse_entered.connect(func(): mouse_insize = true)
	self.mouse_exited.connect(func(): mouse_insize = false)
	self.gui_input.connect(self._on_gui_input)
	self.button_ok.pressed.connect(self._on_button_ok_pressed)
	self.button_cancel.pressed.connect(self._on_button_cancel_pressed)
	self.button_del.pressed.connect(self.queue_free)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				is_dragging = true
				click_position = self.get_local_mouse_position()
				self.select()
			else:
				is_dragging = false
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			if event.is_released():
				self.setting.show()

func _input(event: InputEvent) -> void:
	if is_dragging:
		self.global_position = self.get_global_mouse_position() - click_position
	if event is InputEventMouseButton \
	and event.button_index == MouseButton.MOUSE_BUTTON_LEFT \
	and event.is_pressed() and not mouse_insize:
		self.un_select()
	if event is InputEventKey and event.keycode == Key.KEY_DELETE:
		if self.selected:
			self.queue_free()

func _on_button_ok_pressed() -> void:
	self.setting.hide()
	self.setting_submit.emit()

func _on_button_cancel_pressed() -> void:
	self.setting.hide()
	self.setting_cancel.emit()

func select() -> void:
	self.selected = true

func un_select() -> void:
	self.selected = false
	if self.setting.visible:
		self.setting.hide()
		self.setting_cancel.emit()
