extends Area

export (String) var event_name := ""
export (String) var group_name := ""

export (bool) var oneshot := true


func _on_EventTriggerArea_body_entered(body: Node) -> void:
	if body.is_in_group(group_name):
		EventBus.trigger_event(event_name)
