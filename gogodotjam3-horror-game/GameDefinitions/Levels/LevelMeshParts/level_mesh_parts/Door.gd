extends KinematicBody

var _open := false

export (NodePath) var anim_player_path : NodePath

onready var anim := get_node(anim_player_path) as AnimationPlayer

func interact(source : Node) -> void:
	if _open:
		anim.play("close")
	else:
		anim.play("open")
	_open = !_open
