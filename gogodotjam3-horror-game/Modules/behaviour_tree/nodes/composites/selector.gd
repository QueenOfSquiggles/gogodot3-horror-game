extends Composite

class_name SelectorComposite, "../../icons/selector.svg"

func tick(actor : Node, blackboard : Blackboard) -> int:
	for c in get_children():
		var response = c.tick(actor, blackboard)

		if response != FAILURE:
			return response

	return FAILURE
