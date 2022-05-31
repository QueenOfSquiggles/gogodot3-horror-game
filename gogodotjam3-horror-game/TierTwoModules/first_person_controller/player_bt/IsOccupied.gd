extends Leaf

func tick(_actor : Node, _blackboard : Blackboard) -> int:
	if Globals.player_occupied:
		return RUNNING
	return SUCCESS
