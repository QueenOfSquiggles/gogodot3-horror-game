extends Control

onready var anim := $AnimationPlayer


func start(_collider : Node) -> void:
	anim.play("start_can_interact")

func end(_collider : Node) -> void:
	anim.play("end_can_interact")
