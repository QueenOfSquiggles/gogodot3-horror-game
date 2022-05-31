extends BehaviorTreeNode

class_name Decorator, "../../icons/category_decorator.svg"

func _ready():
	assert(self.get_child_count() == 1, "BehaviorTree Error: Decorator %s should have only one child" % self.name)


# DO NOT CHANGE THIS SCRIPT. GO TO INSPECTOR SCRIPT -> EXTEND SCRIPT
