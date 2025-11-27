extends SimulatorObject
class_name RFIDReader


@onready var led: Panel = %LED
@onready var label_com: Label = %LabelCOM
@onready var option_com: OptionButton = %OptionCom
@onready var reader: Area2D = $Area2D
@onready var com: String:
	set(new):
		com = new
		self.label_com.text = com
	get:
		return com

signal swipe_card(RFIDCard)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.reader.area_entered.connect(self._on_area_entered)
	self.setting_submit.connect(self._on_setting_submit)
	self.setting_cancel.connect(self._on_setting_cancel)

func _on_setting_submit() -> void:
	self.com = self.option_com.text

func _on_setting_cancel() -> void:
	self.option_com.text = com

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is RFIDCard:
		swipe_card.emit(area.get_parent())
		led["theme_override_styles/panel"]["bg_color"] = Color.GREEN
		get_tree().create_timer(0.3).timeout.connect(
			func(): led["theme_override_styles/panel"]["bg_color"] = Color.RED)
