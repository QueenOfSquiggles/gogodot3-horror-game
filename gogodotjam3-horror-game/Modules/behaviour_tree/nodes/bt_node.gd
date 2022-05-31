extends BehaviorTree

class_name BehaviorTreeNode, "../icons/action.svg"

enum {
	 SUCCESS, FAILURE, RUNNING
}

func tick(_actor : Node, _blackboard : Blackboard) -> int:
	return SUCCESS
