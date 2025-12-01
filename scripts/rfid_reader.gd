extends SimulatorObject
class_name RFIDReader


@onready var led: Panel = %LED
@onready var label_com: Label = %LabelCOM
@onready var option_com: OptionButton = %OptionCom
@onready var reader: Area2D = $Area2D
@onready var com: String:
	set(new):
		com = new
		label_com.text = com
	get:
		return com
var serial: GdSerial = GdSerial.new()


func _ready() -> void:
	super._ready()
	reader.area_entered.connect(self._on_area_entered)
	setting_submit.connect(self._on_setting_submit)
	setting_cancel.connect(self._on_setting_cancel)
	serial.set_baud_rate(9600)
	for port in Global.list_ports:
		option_com.add_item(port)
	option_com.select(0)
	com = option_com.text

func _on_setting_submit() -> void:
	com = option_com.text
	if serial.open():
		serial.close()
	serial.set_port(com)

func _on_setting_cancel() -> void:
	option_com.text = com

func _on_area_entered(area: Area2D) -> void:
	var card: Node = area.get_parent()
	if card is RFIDCard:
		if serial.open():
			serial.writeline(card.card_id)
		led["theme_override_styles/panel"]["bg_color"] = Color.GREEN
		await get_tree().create_timer(0.3).timeout
		led["theme_override_styles/panel"]["bg_color"] = Color.RED

func _exit_tree() -> void:
	serial.close()
