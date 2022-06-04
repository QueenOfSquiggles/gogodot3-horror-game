extends "res://Modules/interactables/InteractableBase.gd"

onready var anim_player := $"../../AnimationPlayer"

var interact_prompt := "Drain sink"

func interact(_source : Node) -> void:
	anim_player.play("drain")
