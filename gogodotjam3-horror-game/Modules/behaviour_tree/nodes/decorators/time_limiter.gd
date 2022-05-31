extends Decorator

class_name TimeLimiterDecorator, "../../icons/limiter.svg"

onready var cache_key = 'limiter_%s' % self.get_instance_id()

export (float) var time_limit := 1.0

func tick(actor : Node, blackboard : Blackboard) -> int:
	var current_time = blackboard.get(cache_key, 0.0) as float
	if current_time <= 0.0:
		var result = self.get_child(0).tick(actor, blackboard)
		if result == SUCCESS:
			blackboard.set(cache_key, time_limit)
		return result
	else:
		var delta := blackboard.get("delta", 0.0) as float
		blackboard.set(cache_key, current_time - delta)
	return SUCCESS
