extends Decorator

class_name AlwaysFailDecorator, "../../icons/fail.svg"

func tick(actor : Node, blackboard : Blackboard) -> int:
	for c in get_children():
		var response = c.tick(actor, blackboard)
		if response == RUNNING:
			return RUNNING
		return FAILURE
	return FAILURE
