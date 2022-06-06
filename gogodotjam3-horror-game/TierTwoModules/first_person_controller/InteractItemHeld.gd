extends Leaf

export (String) var input_name := "input_interact"

func tick(actor : Node, bb : Blackboard) -> int:
	if not bb.get(input_name, false) as bool:
		return FAILURE
	var item := (actor as FirstPersonCharacterBase).get_held_item()
	if not item or not item.has_method("interact"):
		return FAILURE
	item.interact(actor)
	return SUCCESS
