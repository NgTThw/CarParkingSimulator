extends SimulatorObject
class_name RFIDCard

@export var card_no: String
@export var card_id: String

@onready var setting: Control = $Setting
@onready var line_edit_card_no: LineEdit = %LineEditCardNo
@onready var line_edit_card_id: LineEdit = %LineEditCardID
@onready var button_ok: Button = %ButtonOK
@onready var button_cancel: Button = %ButtonCancel
@onready var label_card_no: Label = %LabelCardNo
@onready var label_card_id: Label = %LabelCardID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.button_ok.pressed.connect(self._on_setting_button_ok_pressed)
	self.button_cancel.pressed.connect(self._on_setting_button_cancel_pressed)

func _input(event: InputEvent) -> void:
	super._input(event)
	if event is InputEventMouseButton and event.is_released() and event.button_index == 2:
		var mouse: Vector2 = self.get_local_mouse_position()
		var size: Vector2 = $Control/ColorRect.size
		if mouse.x > 0 and mouse.x < size.x and mouse.y > 0 and mouse.y < size.y:
			self.setting.show()

func _on_setting_button_ok_pressed() -> void:
	self.setting.hide()
	self.card_no = self.line_edit_card_no.text
	self.card_id = self.line_edit_card_id.text
	self.label_card_no.text = self.card_no
	self.label_card_id.text = self.card_id

func _on_setting_button_cancel_pressed() -> void:
	self.line_edit_card_no.text = ""
	self.line_edit_card_id.text = ""
	self.setting.hide()
