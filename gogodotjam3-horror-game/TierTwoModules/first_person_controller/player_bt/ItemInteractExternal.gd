extends Leaf
# Item Interact

func tick(actor : Node, bb : Blackboard) -> int:
	if not bb.get("input_interact", false) as bool:
		return FAILURE
	var selection_cast := bb.get("selection_cast") as InteractionRayCast
	var item := selection_cast.cached_collider
	if not item or not item.has_method("interact"):
		return FAILURE
	item.interact(actor)
	selection_cast.call_deferred("force_end_interact")
	return SUCCESS
