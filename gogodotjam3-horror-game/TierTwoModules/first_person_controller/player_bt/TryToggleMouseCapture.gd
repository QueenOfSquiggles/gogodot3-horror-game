extends ActionLeaf

func tick(_actor : Node, bb : Blackboard) -> int:
	var toggle = bb.get("input_toggle_mouse_capture", false) as bool
	if toggle:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return SUCCESS
	return FAILURE
