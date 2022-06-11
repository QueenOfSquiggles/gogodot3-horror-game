extends "res://Modules/interactables/InteractableBase.gd"

export (String) var keyed_name := "door_001"
export (String) var interact_prompt := "Chain fence (need tool)"

export (NodePath) var root_delete : NodePath
var locked := true setget _set_locked

func _set_locked(value : bool) -> void:
	locked = value
	print("Chain link was set to locked=%s" % str(value))
	if not value:
		get_node(root_delete).call_deferred("queue_free")
