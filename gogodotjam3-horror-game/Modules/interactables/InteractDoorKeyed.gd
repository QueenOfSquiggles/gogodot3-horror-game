extends "res://Modules/interactables/InteractDoorSimple.gd"
class_name InteractDoorKeyed

export (String) var keyed_name := "door_001"
export (bool) var locked_by_default := true

var locked := false setget _set_locked
onready var unlocked_prompt := self.interact_prompt 

func _ready() -> void:
	locked = locked_by_default
	_update_prompt()

func interact(_source) -> void:
	if locked:
		return
	else:
		# when unlocked, act as regular door
		.interact(_source)

func _set_locked(value : bool) -> void:
	locked = value
	_update_prompt()

func _update_prompt() -> void:
	if locked:
		self.interact_prompt = "Unlock door (key required)"
	else:
		self.interact_prompt = unlocked_prompt
