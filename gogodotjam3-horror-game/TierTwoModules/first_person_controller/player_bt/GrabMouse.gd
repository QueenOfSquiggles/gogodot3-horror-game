extends ActionLeaf

export (bool) var should_grab := true



func tick(_actor : Node, _bb : Blackboard) -> int:
	if should_grab:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	return SUCCESS
