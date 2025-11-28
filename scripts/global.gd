extends Node

enum MouseState {
	FREE,
	WIRING,
	DRAGGING
}

var mouse_state: MouseState = MouseState.FREE
var current_wiring: Pin:
	set(new):
		if new == null:
			if mouse_state == MouseState.WIRING:
				mouse_state = MouseState.FREE
		else:
			current_wiring = new
			mouse_state = MouseState.WIRING
	get:
		if mouse_state == MouseState.WIRING:
			return current_wiring
		return null

func link(pin: Pin) -> void:
	if mouse_state == MouseState.WIRING:
		current_wiring.pins_link.append(pin)
		pin.pins_link.append(current_wiring)
		pin.set_wire(current_wiring.wire)
		current_wiring.is_wiring = false
		current_wiring = null
