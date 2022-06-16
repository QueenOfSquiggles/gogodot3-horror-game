extends KinematicBody

onready var anim := get_node("../../../AnimationPlayer") as AnimationPlayer
var is_open := false

var interact_prompt := "interact.prompt.door.open"

func interact(_source) -> void:
	var anim_name := "close" if is_open else "open"
	anim.play(anim_name)
	is_open = not is_open
	interact_prompt = ("interact.prompt.door.close" if is_open else "interact.prompt.door.open")
