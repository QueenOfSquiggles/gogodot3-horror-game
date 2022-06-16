extends "res://Modules/interactables/InteractDoorSimple.gd"
class_name InteractDoorKeyed

export (String) var keyed_name := "door_001"
export (bool) var locked_by_default := true

export (NodePath) var sfx_locked : NodePath
export (NodePath) var sfx_unlocked : NodePath

var locked := false setget _set_locked
onready var unlocked_prompt := self.interact_prompt 

func _ready() -> void:
	locked = locked_by_default
	_update_prompt()

func interact(_source) -> void:
	if locked:
		anim.play("rustle")
		return
	else:
		# when unlocked, act as regular door
		.interact(_source)

func _set_locked(value : bool) -> void:
	locked = value
	if not locked:
		try_play_sfx(sfx_unlocked)
	elif locked:
		try_play_sfx(sfx_locked)
	_update_prompt()

func try_play_sfx(path : NodePath) -> void:
	if not path.is_empty():
		get_node(path).play()
	

func _update_prompt() -> void:
	if locked:
		self.interact_prompt = "interact.prompt.door.unlock"
	else:
		self.interact_prompt = unlocked_prompt
