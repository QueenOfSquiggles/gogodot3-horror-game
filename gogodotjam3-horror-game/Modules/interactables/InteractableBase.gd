extends Area

signal on_interact(source)

func interact(source : Node) -> void:
	emit_signal("on_interact", source)
