extends ActionLeaf

func tick(_actor : Node, _bb : Blackboard) -> int:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return SUCCESS
