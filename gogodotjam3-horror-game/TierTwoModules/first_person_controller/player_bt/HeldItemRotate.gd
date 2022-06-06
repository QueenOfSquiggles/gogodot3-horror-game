extends Leaf
# Held Item Rotate
export (float) var mouse_sensitivity := 0.003

func tick(actor : Node, bb : Blackboard) -> int:
	var obj :Spatial= (actor as FirstPersonCharacterBase).get_held_item()
	if not obj:
		return FAILURE
	if not bb.get("input_toggle_rotate_item", false) as bool:
		if "keep_rotation" in obj and not obj.keep_rotation:
			obj.rotation = Vector3.ZERO
		return FAILURE

	# switch to rotate the remote transform
	obj = (actor as FirstPersonCharacterBase).remote_trans
	var mouse_delta := bb.get("mouse_delta", Vector2.ZERO) as Vector2
	mouse_delta *= mouse_sensitivity
	obj.rotate_x(mouse_delta.y)
	obj.rotate_y(mouse_delta.x)
	return SUCCESS
