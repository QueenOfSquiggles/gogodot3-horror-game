extends ColorRect

signal key_selected(bind_info)

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	# we need logic to detect what inputs are valid
	var bind_info := {
		"bind" : -1,
		"type" : -1 # NULL binding
	}
	if event is InputEventKey:
		bind_info.bind = (event as InputEventKey).scancode
		bind_info.type = Settings.InputTypes.KEYBOARD
		
	elif event is InputEventMouseButton:
		bind_info.bind = (event as InputEventMouseButton).button_index
		bind_info.type = Settings.InputTypes.MOUSE_BUTTON
		
	elif event is InputEventJoypadButton:
		bind_info.bind = (event as InputEventJoypadButton).button_index
		bind_info.type = Settings.InputTypes.GAMEPAD_BUTTON
		
	elif event is InputEventJoypadMotion:
		bind_info.bind = (event as InputEventJoypadMotion).axis
		bind_info.type = Settings.InputTypes.GAMEPAD_AXIS
	
	if bind_info.bind != -1:
		# if a binding was found, process the binding
		yield(VisualServer, "frame_post_draw")
		emit_signal("key_selected", bind_info)
		close()

func open() -> void:
	show()
	set_process_input(true)

func close() -> void:
	hide()
	set_process_input(false)
