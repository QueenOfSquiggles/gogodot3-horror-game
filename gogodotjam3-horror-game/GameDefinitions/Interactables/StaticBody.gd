extends "res://Modules/interactables/InteractableBase.gd"

onready var anim_player := $"../../AnimationPlayer"

var interact_prompt := "interact.prompt.drain_sink"

func interact(_source : Node) -> void:
	anim_player.play("drain")
