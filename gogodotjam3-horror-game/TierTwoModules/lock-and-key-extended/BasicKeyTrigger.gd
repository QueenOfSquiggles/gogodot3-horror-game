extends "res://Modules/interactables/InteractableBase.gd"

export (String) var key_name := "default"

func _ready() -> void:
	LocksManager.set_lock(key_name, false)

func interact(source : Node) -> void:
	LocksManager.set_lock(key_name, true)

