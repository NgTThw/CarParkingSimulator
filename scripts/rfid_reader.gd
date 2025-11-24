extends SimulatorObject
class_name RFIDReader


@onready var led: Panel = %LED

signal swipe_card(RFIDCard)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	self.area_entered.connect(self._on_area_entered)

func _input(event: InputEvent) -> void:
	super._input(event)

func _on_area_entered(area: Area2D) -> void:
	if area is RFIDCard:
		swipe_card.emit(area)
		led["theme_override_styles/panel"]["bg_color"] = Color.GREEN
		get_tree().create_timer(0.3).timeout.connect(func(): led["theme_override_styles/panel"]["bg_color"] = Color.RED)
		$Control/Label.text = "Quẹt thẻ %s ID:%s" % [area.card_no, area.card_id]
