extends "res://Modules/interactables/InteractableBase.gd"

export (String) var keyed_name := "door_001"
export (String) var interact_prompt := "interact.prompt.chain_fence"

export (NodePath) var root_delete : NodePath
var locked := true setget _set_locked

func _set_locked(value : bool) -> void:
	locked = value
	if not value:
		get_node(root_delete).call_deferred("queue_free")
