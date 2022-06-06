extends Leaf

export (String) var input_name := "input_use_item"

func tick(actor : Node, bb : Blackboard) -> int:
	if not bb.get(input_name, false) as bool:
		return FAILURE
	var item := (actor as FirstPersonCharacterBase).get_held_item()
	if not item or not item.has_method("interact"):
		return FAILURE
	item.use_item(actor)
	var selection_cast := bb.get("selection_cast") as InteractionRayCast
	selection_cast.call_deferred("force_end_interact")
	return SUCCESS
