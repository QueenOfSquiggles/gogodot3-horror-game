extends Leaf
# Held Item Rotate
export (float) var mouse_sensitivity := 0.003

func tick(_actor : Node, bb : Blackboard) -> int:
	var held_object_root :Spatial = bb.get("held_object_root") as Spatial
	if not held_object_root or held_object_root.get_child_count() <= 0:
		#don't lock mouse if no object to rotate
		return FAILURE
	var obj := held_object_root.get_child(0) as PickupItemBase
		
	if not bb.get("input_toggle_rotate_item", false) as bool:
		if not obj.keep_rotation:
			obj.rotation = Vector3.ZERO
		return FAILURE
	
	var mouse_delta := bb.get("mouse_delta", Vector2.ZERO) as Vector2
	mouse_delta *= mouse_sensitivity
	obj.rotate_x(mouse_delta.y)
	obj.rotate_y(mouse_delta.x)
	return SUCCESS
