extends KinematicBody

onready var anim := get_node("../../../AnimationPlayer") as AnimationPlayer
var is_open := false


func interact(_source) -> void:
	var anim_name := "close" if is_open else "open"
	anim.play(anim_name)
	is_open = not is_open
