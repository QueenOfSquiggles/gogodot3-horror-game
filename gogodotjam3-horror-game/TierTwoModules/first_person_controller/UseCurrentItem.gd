extends Leaf

export (String) var input_name := "input_use_item"

func tick(actor : Node, bb : Blackboard) -> int:
	if not bb.get(input_name, false) as bool:
		return FAILURE
	var held_obj_root := bb.get("held_object_root") as Spatial
	
	if held_obj_root.get_child_count() <= 0:
		return FAILURE

	
	var item := held_obj_root.get_child(0) as PickupItemBase
	if not item:
		return FAILURE
	item.use_item(actor)
	var selection_cast := bb.get("selection_cast") as InteractionRayCast
	selection_cast.call_deferred("force_end_interact")
	return SUCCESS
