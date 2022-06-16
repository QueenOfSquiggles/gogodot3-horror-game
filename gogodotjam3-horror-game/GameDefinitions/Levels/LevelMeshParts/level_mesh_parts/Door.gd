extends KinematicBody

var _open := false

export (NodePath) var anim_player_path : NodePath

onready var anim := get_node(anim_player_path) as AnimationPlayer

var interact_prompt := "interact.prompt.door.open"

func interact(_source : Node) -> void:
	if _open:
		anim.play("close")
		interact_prompt = "interact.prompt.door.open"
	else:
		anim.play("open")
		interact_prompt = "interact.prompt.door.close"
	_open = !_open
