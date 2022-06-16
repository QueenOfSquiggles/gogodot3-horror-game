extends ColorRect

signal key_selected(scancode)

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	if "scancode" in event:
		yield(VisualServer, "frame_post_draw")
		emit_signal("key_selected", event.scancode)
		close()

func open() -> void:
	show()
	set_process_input(true)

func close() -> void:
	hide()
	set_process_input(true)
