extends "res://Modules/interactables/InteractDoorSimple.gd"
class_name InteractDoorKeyed

export (String) var keyed_name := "door_001"
export (bool) var locked_by_default := true

var locked := false

func _ready() -> void:
	locked = locked_by_default

func interact(_source) -> void:
	if locked:
		return
	else:
		# when unlocked, act as regular door
		.interact(_source)
