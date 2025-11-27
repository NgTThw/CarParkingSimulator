extends SimulatorObject
class_name RFIDCard


@onready var line_edit_card_no: LineEdit = %LineEditCardNo
@onready var line_edit_card_id: LineEdit = %LineEditCardID
@onready var label_card_no: Label = %LabelCardNo
@onready var label_card_id: Label = %LabelCardID
@onready var card_no: String:
	set(new):
		card_no = new
		self.label_card_no.text = card_no
	get:
		return card_no
@onready var card_id: String:
	set(new):
		card_id = new
		self.label_card_id.text = card_id
	get:
		return card_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.setting_submit.connect(self._on_setting_submit)
	self.setting_cancel.connect(self._on_setting_cancel)

func _on_setting_submit() -> void:
	self.card_no = self.line_edit_card_no.text
	self.card_id = self.line_edit_card_id.text

func _on_setting_cancel() -> void:
	self.line_edit_card_no.text = self.card_no
	self.line_edit_card_id.text = self.card_id
